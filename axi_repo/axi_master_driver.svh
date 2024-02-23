 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_MASTER_DRIVER__SVH
`define AXI_MASTER_DRIVER__SVH

class axi_master_driver extends uvm_driver #(axi_seq_item);

   axi_agent_configuration cfg;
   virtual axi_footprint_interface axi_vif;
   logic [`AXI_MAX_DW-1:0] shifted_wr_data [];
   logic [`AXI_MAX_DW-1:0] shifted_rd_data [];
   bit [`AXI_MAX_DW/8-1:0] shifted_byte_en [];
   bit reset_active = 0;

   bit [`AXI_TRANSACTION_ID_SIZE-1:0] awid_bid_counter = 0;
   bit [`AXI_TRANSACTION_ID_SIZE-1:0] arid_rid_counter = 0;

   int opened_requests = 0;

   int opened_w_reqs = 0;
   int opened_r_reqs = 0;
   int w_resp = 0;
   int r_resp = 0;

   mailbox #(axi_seq_item) rsp_write_q;
   mailbox #(axi_seq_item) rsp_read_q;
   mailbox #(axi_seq_item) req_write_q;
   mailbox #(axi_seq_item) req_read_q;
   
   uvm_queue #(axi_seq_item) r_q;
   uvm_queue #(axi_seq_item) b_q;

   semaphore p_lock;
   semaphore sem_w;
   semaphore sem_r;

   bit m_data_left = 0;
   bit m_timeouted = 0;

   uvm_analysis_port #(axi_seq_item) outbound_write_transactions;
   uvm_analysis_port #(axi_seq_item) outbound_read_transactions;

   `uvm_component_utils(axi_master_driver)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual protected task run_phase(uvm_phase phase);

   /// Get data from sequence, pass to processing and get read response to sequence
   extern task get_and_drive();
   extern task process_axi_write_pkt();
   extern task process_axi_read_pkt();
   extern task get_write_responses();
   extern task get_read_responses();
   extern task match_write_id_pairs();
   extern task match_read_id_pairs();
   extern task data_left();
   extern function void shift_write(ref axi_seq_item t);
   extern function void shift_read(ref axi_seq_item t);
   extern function int unsigned INT(input real r);
   
   extern function void reset();
   extern function void restart();

   extern task wait_timeout(time timeout, uvm_phase phase);
   extern task wait_stim_drain(uvm_phase phase);
   extern task drain_or_timeout(uvm_phase phase);
   extern function void phase_ready_to_end(uvm_phase phase);

endclass: axi_master_driver

function axi_master_driver::new(string name, uvm_component parent = null);
   super.new(name, parent);

   outbound_write_transactions = new("outbound_write_transactions", this);
   outbound_read_transactions = new("outbound_read_transactions", this);
   /*
   rsp_write_q = new("rsp_write_q");
   rsp_read_q = new("rsp_read_q");
   req_write_q = new("req_write_q");
   req_read_q = new("req_read_q");
   */
   r_q = new("r_q");
   b_q = new("b_q");

   sem_w = new(1);
   sem_r = new(1);
   p_lock = new(1);

endfunction

function void axi_master_driver::build_phase(uvm_phase phase);
   super.build_phase (phase);

   if (!uvm_config_db#(axi_agent_configuration)::get(this, "", "axi_cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "Can't get configuration object through config_db")
   end

   axi_vif = cfg.axi_vif;
   if(axi_vif == null)
      `uvm_fatal(get_type_name(), "NULL VIF");

   rsp_read_q = new(cfg.max_read_requests);
   rsp_write_q = new(cfg.max_write_requests);
	req_write_q = new(cfg.max_write_requests);
   req_read_q = new(cfg.max_read_requests);
   
endfunction

task axi_master_driver::run_phase(uvm_phase phase);
   super.run_phase (phase);
   `uvm_info (get_type_name(),"Run_phase is running...", UVM_LOW);
   axi_vif.master_drive_idle();

   if (axi_vif.aresetn !== 1'b1) begin
      `uvm_info (get_type_name(), "Waiting for reset signal...", UVM_LOW);
      @(posedge axi_vif.aresetn);
      `uvm_info (get_type_name(), "Reset signal deactivated", UVM_LOW);
      repeat (10) @(axi_vif.axi_master_cb);
   end

   fork
      forever process_axi_write_pkt();
      forever process_axi_read_pkt();
      forever get_write_responses();
      forever get_read_responses();
      forever match_write_id_pairs();
      forever match_read_id_pairs();
      forever data_left();
   join_none

   get_and_drive();

endtask

task axi_master_driver::get_and_drive ();

   forever begin
      while (reset_active == 1'b1)
        @(posedge axi_vif.aclk);
      seq_item_port.get(req);
      
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      rsp.pipelined = req.pipelined;

      if(rsp.op_type == AXI_WRITE) req_write_q.put(rsp);
      else req_read_q.put(rsp);   
       
   
   end

endtask

task axi_master_driver::data_left();
   if(rsp_write_q.num() > 0 || rsp_read_q.num() > 0 || req_read_q.num() > 0 || req_write_q.num() > 0)
      m_data_left = 1'b1;
   else
      m_data_left = 1'b0;

   @(axi_vif.axi_master_cb);
endtask : data_left

task axi_master_driver::match_write_id_pairs();
   axi_seq_item t, b;
   int pop_out = 0;
   t = axi_seq_item::type_id::create("t", this);
   b = axi_seq_item::type_id::create("b", this);

   rsp_write_q.peek(t);
   sem_w.get(1);
   for(int i = 0; i < b_q.size(); i++) begin
      b = b_q.get(i);
      if(b.id == t.id || cfg.last_signaling_used == 0) begin
         t.bresp = b.bresp;
         pop_out = 1;
         b_q.delete(i);
      end
   end
   sem_w.put(1);
   if(pop_out) begin
      if(t.pipelined) outbound_write_transactions.write(t);
      else seq_item_port.put(t);
      rsp_write_q.get(b);
   end

   @(axi_vif.axi_master_cb);
endtask : match_write_id_pairs

task axi_master_driver::match_read_id_pairs();
   axi_seq_item t, b;
   int pop_out = 0;
   t = axi_seq_item::type_id::create("t", this);
   b = axi_seq_item::type_id::create("b", this);

   rsp_read_q.peek(t);
   t.data = new[t.burst_length];
   t.rresp = new[t.burst_length];
   sem_r.get(1);
   for(int i = 0; i < r_q.size(); i++) begin
      b = r_q.get(i);
      if(b.id == t.id || cfg.last_signaling_used == 0) begin
         for(int j = 0; j < t.burst_length; j++) begin
            t.rresp[j] = b.rresp[j];
            t.data[j] = b.data[j];
         end
         shift_read(t);
         pop_out = 1;
         r_q.delete(i);
      end
   end
   sem_r.put(1);
   if(pop_out) begin
      if(t.pipelined) outbound_read_transactions.write(t);
      else seq_item_port.put(t);
      rsp_read_q.get(b);
   end

   @(axi_vif.axi_master_cb);
endtask : match_read_id_pairs

task axi_master_driver::get_write_responses();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);

   axi_vif.m_b(t);
   sem_w.get(1);
   b_q.push_back(t);
   sem_w.put(1);

   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_master_cb);
endtask : get_write_responses

task axi_master_driver::get_read_responses();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);

   t.use_last_signaling = cfg.last_signaling_used;
   
   axi_vif.m_r(t);

   sem_r.get(1);
   r_q.push_back(t);
   sem_r.put(1);

  	if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_master_cb);
endtask : get_read_responses

task axi_master_driver::process_axi_write_pkt();
   bit state;
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);

   req_write_q.get(t);
   
 if (cfg.data_width/8 < t.tr_size_in_bytes) begin
     `uvm_fatal(get_full_name (),
	   $sformatf("Transfer size %0d bytes exceeds data bus width %0d bytes (%0d bits)", t.tr_size_in_bytes,cfg.data_width/8,cfg.data_width));
   end
	
   if(cfg.last_signaling_used == 1'b0 || (cfg.last_signaling_used == 1'b1 && cfg.has_pipelining == 1'b0))
   while((rsp_write_q.num() > 0)) @(axi_vif.axi_master_cb);

   if (cfg.fast_mode == 0)
     state = t.delay_vars.randomize();
   else begin
      t.delay_vars.m_aw_start_delay = 0;
      t.delay_vars.m_w_start_delay = 0;
      t.delay_vars.m_w_beat_delay = 0;
      t.delay_vars.m_b_start_delay = 0;
   end

 
   shift_write(t);
   
   if(cfg.last_signaling_used) t.id = awid_bid_counter++;
   else t.id = 0;

   if(cfg.aw_before_w_channel == 1) begin
      axi_vif.m_aw(t);
      axi_vif.m_w(t);
      `uvm_info(get_full_name,$sformatf("from driver process write task of \n %s",t.sprint),UVM_NONE)

   end else begin
      fork
         begin
            axi_vif.m_aw(t);
         end
         begin
            axi_vif.m_w(t);
         end
      join

      `uvm_info(get_full_name,$sformatf("from driver process write task \n %s",t.sprint),UVM_NONE)
   end

   // Blocks here if mailbox full == max_write_requests achieved
   rsp_write_q.put(t);

   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_master_cb);
endtask : process_axi_write_pkt

task axi_master_driver::process_axi_read_pkt();
   bit state;
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   req_read_q.get(t);
	
	if(cfg.last_signaling_used == 1'b0 || (cfg.last_signaling_used == 1'b1 && cfg.has_pipelining == 1'b0))
		while((rsp_read_q.num() > 0)) @(axi_vif.axi_master_cb);
	   
   if (cfg.fast_mode == 0)
     state = t.delay_vars.randomize();
   else begin
      t.delay_vars.m_ar_start_delay = 0;
      t.delay_vars.m_r_start_delay = 0;
      t.delay_vars.m_r_beat_delay = 0;
   end

   if(cfg.last_signaling_used) t.id = arid_rid_counter++;
   else t.id = 0;
   
   axi_vif.m_ar(t);

   // Blocks here if mailbox full == max_read_requests achieved
   rsp_read_q.put(t);

   if(!(cfg.fast_mode && cfg.has_pipelining)) @(axi_vif.axi_master_cb);
endtask : process_axi_read_pkt

function void axi_master_driver::shift_read(ref axi_seq_item t);
   bit[`AXI_MAX_AW-1:0] beat_address;

   beat_address = t.addr;
   shifted_rd_data = new[t.burst_length];
   shifted_rd_data = t.data;

   for (int i = 0; i < t.burst_length; i++) begin
  
      axi_common::shift_data_right(beat_address, shifted_rd_data[i], t.data[i], t.tr_size_in_bytes, 0, cfg.data_width);

      if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
        beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
      else
        beat_address = beat_address + t.tr_size_in_bytes;
   end
   
   t.byte_en = new[t.burst_length];
   for (int j = 0; j < t.burst_length; j++) begin
      for(int i = `AXI_MAX_DW-1; i >= t.tr_size_in_bytes*8; i--)
        if (t.byte_en[j][i/8] !== 1'b1)
          t.data[j][i] = 0;
   end

endfunction : shift_read

function int unsigned axi_master_driver::INT(input real r);
  //$display("r = %f , i = 'h%h = 'd%0d",r,$rtoi(r),$rtoi(r));
  return $rtoi(r);
endfunction : INT

function void axi_master_driver::shift_write(ref axi_seq_item t);
   bit [`AXI_MAX_AW-1:0]   beat_address;
   bit [`AXI_MAX_DW/8-1:0] byte_en;
   bit [`AXI_MAX_DW/8-1:0] byte_en_last;
   // AXI4 protocol variables
   bit [`AXI_MAX_AW-1:0] Start_Address,Aligned_Address,Address_N;
   shortint unsigned Number_Bytes,Data_Bus_Bytes,Lower_Byte_Lane,Upper_Byte_Lane;
   bit [`AXI_MAX_DW/8-1:0] fullBandWstrb;
   bit addressIsUnaligned,fullBand,fullBandWstrbUsed;
   
   // AXI4 protocol equations
   Start_Address = t.addr;
   Number_Bytes = t.tr_size_in_bytes;
   Data_Bus_Bytes = cfg.data_width/8;
   Aligned_Address = INT(Start_Address / Number_Bytes) * Number_Bytes;
   
   // Others
   addressIsUnaligned = (Start_Address != Aligned_Address);
   fullBand = (Data_Bus_Bytes == Number_Bytes);
   fullBandWstrbUsed = 1;
   for (int i = 0; i < Data_Bus_Bytes; i++) begin
     if (t.byte_en[0][i] == 1'b0) begin
	   fullBandWstrbUsed = 0;
	   break;
	 end
   end

   // Debug info
   if (cfg.enable_debug_messages == 1'b1) begin
     `uvm_info(get_type_name(),
       $sformatf("Start_Address = %h , Aligned_Address = %h , unaligned address = %b",Start_Address,Aligned_Address,addressIsUnaligned), UVM_DEBUG);
     `uvm_info(get_type_name(),
       $sformatf("Data_Bus_Bytes = %0d , Number_Bytes = %0d , t.burst_length = %0d , t.tr_size_in_bytes = %0d",Data_Bus_Bytes,Number_Bytes,t.burst_length,t.tr_size_in_bytes), UVM_DEBUG);
     `uvm_info(get_type_name(),
       $sformatf("Fullband = %0d , t.byte_en[0] = %h , fullBandWstrbUsed = %0d",fullBand,t.byte_en[0],fullBandWstrbUsed), UVM_DEBUG);
     if (t.byte_en_first_custom == 1) begin
       `uvm_info(get_type_name(),
         $sformatf("Custom first beat byte_en = %0d",t.byte_en_first_custom), UVM_DEBUG);
     end
     if (t.byte_en_last_custom == 1) begin
       `uvm_info(get_type_name(),
         $sformatf("Custom last beat byte_en = %0d",t.byte_en_last_custom), UVM_DEBUG);
     end
   end
   
   
   //
   // Shift each byte enable beat
   //
   
   shifted_byte_en = new[t.burst_length];
   beat_address = Start_Address;
   
   // WSTRB are computed (see section A3.4.1 of IHI0022F_b)
   if (fullBandWstrbUsed || t.byte_en_first_custom == 1) begin
     for (int i = 0; i < t.burst_length; i++) begin
  	   if (i == 0) begin  // First transfer
  	     Lower_Byte_Lane = Start_Address - (INT(Start_Address / Data_Bus_Bytes)) * Data_Bus_Bytes;
  		 Upper_Byte_Lane = Aligned_Address + (Number_Bytes - 1) - (INT(Start_Address / Data_Bus_Bytes)) * Data_Bus_Bytes;
  	   end else begin
  	     Lower_Byte_Lane = Address_N - (INT(Address_N / Data_Bus_Bytes)) * Data_Bus_Bytes;
  		 Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes - 1;
  	   end
  	   // Enable correct byte lanes
       if (cfg.enable_debug_messages == 1'b1) begin
         `uvm_info(get_type_name(),
               $sformatf("Transfer %0d: Lower_Byte_Lane = %0d , Upper_Byte_Lane = %0d",i,Lower_Byte_Lane,Upper_Byte_Lane), UVM_DEBUG);
  	   end
	   for (int j = $low(byte_en); j <= $high(byte_en); j++) begin
  	     byte_en[j] = (j >= Lower_Byte_Lane && j <= Upper_Byte_Lane) ? 1'b1 : 1'b0;
  	   end
       if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) begin // Unaligned tfer, next addresses of burst are aligned
         beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
       end else begin
         beat_address = beat_address + t.tr_size_in_bytes;
       end
	   shifted_byte_en[i] = byte_en;
       Address_N = beat_address;  // address of next transfer
       if (cfg.enable_debug_messages == 1'b1) begin
         `uvm_info(get_type_name(),
               $sformatf("Transfer %0d: shifted_byte_en[%0d] = %h , Address_N = %h",i,i,shifted_byte_en[i],Address_N), UVM_DEBUG);
  	   end
     end  // for
   
   // WSTRB: byte_en[0] computed by user (retro-compatibility)
   end else begin
     for (int i = 0; i < t.burst_length; i++) begin
       axi_common::shift_data_left(beat_address, t.byte_en[0], shifted_byte_en[i], t.tr_size_in_bytes, 1, cfg.data_width);
       if (cfg.enable_debug_messages == 1'b1) begin
         `uvm_info(get_type_name(),
               $sformatf("WSTRB: computed by user: shifted_byte_en[%0d] = %h",i,shifted_byte_en[i]), UVM_DEBUG);
       end
	   if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned tfer, next addresses of burst are aligned
         beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
       else
         beat_address = beat_address + t.tr_size_in_bytes;
     end
   end
   
   // First byte enable computed by user
   if (t.byte_en_first_custom == 1) begin
     shifted_byte_en[0] = t.byte_en[0];
   end
   
   // Last byte enable computed by user
   if (t.byte_en_last_custom == 1) begin
     shifted_byte_en[t.burst_length-1] = t.byte_en_last;
   end
   
   t.byte_en = shifted_byte_en;
   
   
   //
   // Shift each data beat
   //
   
   shifted_wr_data = new[t.burst_length];
   beat_address = t.addr;
   
   // Clean-up for printing: keep only useful bits
   if (cfg.clean_data_for_printing) begin
     for (int i = 0; i < t.burst_length; i++) begin
	   for (int j = Number_Bytes*8; j < cfg.data_width; j++) begin
         t.data[i][j] = 1'b0;
       end
     end
   end
   
   // Shift data
   for (int i = 0; i < t.burst_length; i++) begin
     axi_common::shift_data_left(beat_address,t.data[i],shifted_wr_data[i],t.tr_size_in_bytes,0,cfg.data_width);
     if (cfg.enable_debug_messages == 1'b1) begin
       `uvm_info(get_type_name(),
          $sformatf("Transfer %0d: initial data[%0d] = %0h , shifted data[%0d] = %0h",i,i,t.data[i],i,shifted_wr_data[i]), UVM_DEBUG);
     end
	 if (i == 0 && (beat_address % t.tr_size_in_bytes != 0)) // Unaligned tfer, next addresses of burst are aligned
       beat_address = (beat_address + t.tr_size_in_bytes) - (beat_address % t.tr_size_in_bytes);
     else
       beat_address = beat_address + t.tr_size_in_bytes;
   end
   
   t.data = shifted_wr_data;
   
   
   // Debug info
   for (int i = 0; i < t.burst_length; i++) begin
     if (cfg.enable_debug_messages == 1'b1) begin
       `uvm_info(get_type_name(),
         $sformatf("Transfer %0d: data[%0d] = %0h , byte_en[%0d] = %h",i,i,t.data[i],i,t.byte_en[i]), UVM_HIGH);
     end
   end

endfunction : shift_write


function void axi_master_driver::reset();
   reset_active = 1'b1;
endfunction

function void axi_master_driver::restart();
   reset_active = 1'b0;
endfunction


function void axi_master_driver::phase_ready_to_end(uvm_phase phase);
  // Keeps main_phase alive if enabled (wait_all_data = 1'b1)
  if ((phase.get_name() == "main") && cfg.wait_all_data) begin
    // Hack to get rid of the looping which seems to come from the fact that this is called
    // when the objection is dropped by the timeout task.
    if (!m_timeouted) begin
      if (m_data_left) begin
        /// by raising objection if some data is still expected
        phase.raise_objection(this, "Draining stimulus");

        `uvm_info(get_type_name(),"Keeping simulation alive to wait for data",UVM_LOW)

        fork
          /// Fork a task to drain data or timeout
          drain_or_timeout(phase);
        join_none
        /// and the first one of the processes to end will drop the objection and simulation can end
      end
    end
  end
endfunction : phase_ready_to_end

// Method to wait until all expected data has been consumed or timeout if this takes too long
task axi_master_driver::drain_or_timeout(uvm_phase phase);
  fork
    /// In which case wait_stim_drain & wait_timeout processes will be forked
    wait_stim_drain(phase);
    /// (timeout is fixed to 100us)
    wait_timeout(100us,phase);
  join_any;
  disable fork;

  /// and then drops the objection
  phase.drop_objection(this);
endtask : drain_or_timeout


// Method to wait until all expected data has been consumed
task axi_master_driver::wait_stim_drain(uvm_phase phase);
  /// Waits until there's no data left
  wait (! m_data_left);

  `uvm_info(get_type_name(),"All data received --> ending simulation",UVM_LOW)
endtask : wait_stim_drain


task axi_master_driver::wait_timeout(time timeout, uvm_phase phase);
  // Waits the specified timeout period
  #timeout;

  `uvm_error(get_type_name(),"Timeout reached (all output data was not received)  --> ending simulation")
  m_timeouted = 1'b1;
endtask : wait_timeout


`endif // AXI_MASTER_DRIVER__SVH

