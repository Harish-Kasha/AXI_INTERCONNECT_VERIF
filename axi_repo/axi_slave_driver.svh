 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_SLAVE_DRIVER__SVH
`define AXI_SLAVE_DRIVER__SVH

class axi_slave_driver #(int D_W= 32,int A_W=32,int ID_W = 10)extends uvm_driver #(axi_seq_item);
   `uvm_component_utils(axi_slave_driver #(D_W,A_W,ID_W))
   axi_agent_configuration #(D_W,A_W,ID_W) cfg;
   virtual axi_footprint_interface #(D_W,A_W,ID_W) axi_vif;
   logic [`AXI_MAX_DW-1:0] shifted_wr_data [];
   logic [`AXI_MAX_DW-1:0] shifted_rd_data [];
   bit [`AXI_MAX_DW/8-1:0] shifted_byte_en [];
   bit reset_active = 0;
	 bit state;
   bit [`AXI_MAX_AW-1:0] addr_tmp;
  
   bit first_write = 1;
   bit first_read = 1;
   int last_wtr_id = 0;
   int last_rtr_id = 0;
  
  
     axi_slave_memory mem;

   //overflow -> zero ?
   bit [`AXI_TRANSACTION_ID_SIZE-1:0] awid_bid_counter = 0;
   bit [`AXI_TRANSACTION_ID_SIZE-1:0] arid_rid_counter = 0;
   
   int opened_requests = 0;
   
   //separate w and r request q's to be implemented ?
   int opened_w_reqs = 0;
   int opened_r_reqs = 0;
   
   mailbox #(axi_seq_item) req_write_q;
   mailbox #(axi_seq_item) rsp_write_q;
   mailbox #(axi_seq_item) rsp_read_q;
   mailbox #(axi_seq_item) req_read_q;
   
   uvm_queue #(axi_seq_item) r_q;
   uvm_queue #(axi_seq_item) b_q;
   
   semaphore sem_w;
   semaphore sem_r;

     uvm_analysis_port #(axi_seq_item) req_port;

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual protected task run_phase(uvm_phase phase);

   /// Get data from sequence, pass to processing and get read response to sequence
   extern task get_and_drive();

   extern task process_write_resp();
   extern task process_read_resp();
   extern task get_write_transactions();
   extern task get_read_transactions();
   
   extern task read_and_shift(ref axi_seq_item t);
   extern task shift_and_write(ref axi_seq_item t);
   
   extern function void reset();
   extern function void restart();

endclass: axi_slave_driver

function axi_slave_driver::new(string name, uvm_component parent = null);
   super.new(name, parent);
   req_port = new ("req_port",this);
   
   req_read_q = new("req_read_q");
   rsp_read_q = new("rsp_read_q");
   req_write_q = new("req_write_q");
   rsp_write_q = new("rsp_write_q");
   
   r_q = new("r_q");
   b_q = new("b_q");
   
   sem_w = new(1);
   sem_r = new(1);

endfunction

function void axi_slave_driver::build_phase(uvm_phase phase);
   super.build_phase (phase);

   if (!uvm_config_db#(axi_agent_configuration #(D_W,A_W,ID_W))::get(this, "", "axi_cfg", cfg)) begin
      `uvm_fatal(get_type_name (), "Can't get configuration object through config_db")
   end

  axi_vif = cfg.axi_vif;
  if(axi_vif == null)
    `uvm_fatal(get_type_name (), "AXI SLAVE VIP :: BUILD PHASE :: NULL VIF");

  if(cfg.has_memory == 1) begin
     //Get memory handle
     if (!uvm_config_db#(axi_slave_memory)::get(this, "", "slave_memory", mem)) begin
      `uvm_fatal(get_type_name(), "Can't get memory component through config_db")
     end
  end
  
endfunction

task axi_slave_driver::run_phase(uvm_phase phase);
   super.run_phase (phase);

   `uvm_info (get_type_name(),"axi_slave_driver: run_phase is running...", UVM_DEBUG);

   axi_vif.slave_drive_idle();
   get_and_drive();

endtask // run_phase

task axi_slave_driver::get_and_drive ();
   axi_seq_item t;
   first_write = 1;
   first_read = 1;
   
   if (axi_vif.aresetn !== 1'b1) begin
      `uvm_info (get_type_name(), "axi_slave_driver: waiting for reset signal...", UVM_LOW);
      @(posedge axi_vif.aresetn);
      `uvm_info (get_type_name(), "axi_slave_driver: reset signal deactivated", UVM_LOW);
      repeat (10) @(axi_vif.axi_slave_cb);
   end
   
   if(cfg.has_memory == 1) begin
      mem.init(cfg.memory_debug_verbosity, cfg.addr_to_cause_error, cfg.enable_addr_to_cause_error);
   end
   
   fork
      begin
         forever get_read_transactions();
      end
      begin
         forever get_write_transactions();
      end
      begin
         forever process_read_resp();
      end
      begin
         forever process_write_resp();
      end
   join
 
endtask

task axi_slave_driver:: get_read_transactions();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   while(!(this.opened_r_reqs < cfg.max_read_requests)) @(axi_vif.axi_slave_cb);
   
	if(cfg.last_signaling_used == 1'b0 || (cfg.last_signaling_used == 1'b1 && cfg.has_pipelining == 1'b0))
	while((rsp_read_q.num() > 0)) @(axi_vif.axi_slave_cb);
   
   if (cfg.fast_mode == 0) state = t.delay_vars.randomize();
   else begin
      t.delay_vars.s_ar_start_delay = 0;
   end
   
   axi_vif.s_ar(t);
   
   t.burst_length += 1;
   t.data = new[t.burst_length];
   t.rresp = new[t.burst_length];
   t.op_type = AXI_READ;
      
   sem_r.get(1);
   opened_r_reqs++;
   sem_r.put(1);
   
   req_read_q.put(t);
   
   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_slave_cb);    
endtask : get_read_transactions

task axi_slave_driver:: process_read_resp();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);

   req_read_q.get(t);
  
   read_and_shift(t);
   
   if (cfg.fast_mode == 0) state = t.delay_vars.randomize();
   else begin
      t.delay_vars.s_r_start_delay = 0;
      t.delay_vars.s_r_beat_delay = 0;
   end
   
   if(first_read) begin
     first_read = 0;
   end else begin
     t.delay_vars.s_r_start_delay = 1;
   end
      
   axi_vif.s_r(t);
   
   sem_r.get(1);
   --opened_r_reqs;
   if(opened_r_reqs === 0) first_read = 1;
   sem_r.put(1);
   
   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_slave_cb);
endtask : process_read_resp

task axi_slave_driver:: get_write_transactions();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   while(!(this.opened_w_reqs < cfg.max_write_requests)) @(axi_vif.axi_slave_cb);
   
	if(cfg.last_signaling_used == 1'b0 || (cfg.last_signaling_used == 1'b1 && cfg.has_pipelining == 1'b0))
	while((rsp_write_q.num() > 0)) @(axi_vif.axi_slave_cb);
   
   if (cfg.fast_mode == 0) state = t.delay_vars.randomize();
   else begin
      t.delay_vars.s_aw_start_delay = 0;
      t.delay_vars.s_w_start_delay = 0;
      t.delay_vars.s_w_beat_delay = 0;
   end

   t.use_last_signaling = cfg.last_signaling_used;

   if(cfg.aw_before_w_channel == 1) begin
      axi_vif.s_aw(t);
      axi_vif.s_w(t);
   end else begin
      fork
         begin
            axi_vif.s_aw(t);
         end
         begin
            axi_vif.s_w(t);
         end
      join
   end
   
   t.burst_length += 1;
   t.op_type = AXI_WRITE;   
  
   sem_w.get(1);
   opened_w_reqs++;
   sem_w.put(1);
   
   req_write_q.put(t);
   
   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_slave_cb);
endtask : get_write_transactions

task axi_slave_driver:: process_write_resp();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);

   req_write_q.get(t);

   shift_and_write(t);
   
   if (cfg.fast_mode == 0) state = t.delay_vars.randomize();
   else t.delay_vars.s_b_start_delay = 0;
   
   if(first_write) begin
     first_write = 0;
   end else begin
     t.delay_vars.s_b_start_delay = 1;
   end
        
   axi_vif.s_b(t);
   
   sem_w.get(1);
   --opened_w_reqs;
   if(opened_w_reqs === 0) first_write = 1;
   sem_w.put(1);
   
   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_slave_cb);
endtask : process_write_resp

task axi_slave_driver::shift_and_write(ref axi_seq_item t);
   bit[`AXI_MAX_AW-1:0] beat_address;
   bit[`AXI_MAX_AW-1:0] address_tmp[];
   logic [`AXI_MAX_DW-1:0] data_tmp [];
   bit [`AXI_MAX_DW/8-1:0] wstrb_tmp [];
	bit bresp_flag; 
	
   address_tmp = new[t.burst_length];
   data_tmp = new[t.burst_length];
   wstrb_tmp = new[t.burst_length];
   
   data_tmp = t.data;
   wstrb_tmp = t.byte_en;

   //Shift byte enable and data
   beat_address = t.addr;
   for (int i = 0; i < t.burst_length; i++) begin
     axi_common::shift_data_right(beat_address, wstrb_tmp[i], t.byte_en[i], t.tr_size_in_bytes, 1, cfg.data_width);
       if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
        beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
        else
           beat_address = beat_address + t.tr_size_in_bytes;
   end

   beat_address = t.addr;
   for (int i = 0; i < t.burst_length; i++) begin
      axi_common::shift_data_right(beat_address, data_tmp[i], t.data[i], t.tr_size_in_bytes, 0, cfg.data_width);
      address_tmp[i] = beat_address;
       if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
        beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
        else
           beat_address = beat_address + t.tr_size_in_bytes;
   end
   bresp_flag = 0;
   if(cfg.has_memory == 1) begin
      //Write to memory
      for (int j = 0; j < t.burst_length; j++) begin
        if(mem.write(address_tmp[j], t.data[j], t.tr_size_in_bytes, t.byte_en[j])) begin
	        t.bresp = 0;
        end else begin
	        bresp_flag = 1;
        end
      end
      if(bresp_flag) t.bresp = 2;
   end
endtask : shift_and_write

task axi_slave_driver::read_and_shift(ref axi_seq_item t);
   bit[`AXI_MAX_AW-1:0] beat_address;
   logic [`AXI_MAX_DW-1:0] shifted_rd_data [];

   shifted_rd_data = new[t.burst_length];

   beat_address = t.addr;
   for (int i = 0; i < t.burst_length; i++) begin
      
      if(cfg.has_memory == 1) begin
         if(mem.read(beat_address, shifted_rd_data[i], t.tr_size_in_bytes)) begin
	         t.rresp[i] = 0;
         end else begin
	         t.rresp[i] = 2; //Error occured
         end
      end
  
      axi_common::shift_data_left(beat_address, shifted_rd_data[i], t.data[i], t.tr_size_in_bytes, 0, cfg.data_width);

      if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
        beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
      else
        beat_address = beat_address + t.tr_size_in_bytes;
   end

   
endtask : read_and_shift

function void axi_slave_driver::reset();
   reset_active = 1'b1;
endfunction

function void axi_slave_driver::restart();
   reset_active = 1'b0;
endfunction

`endif // AXI_SLAVE_DRIVER__SVH

