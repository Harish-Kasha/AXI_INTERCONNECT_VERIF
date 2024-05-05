 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_MONITOR__SVH
`define AXI_MONITOR__SVH

`include "axi_slave_memory.svh"

class axi_monitor #(int D_W= 32,int A_W=32,int ID_W = 10) extends uvm_monitor;
   `uvm_component_param_utils(axi_monitor #(D_W,A_W,ID_W))
   
   axi_agent_configuration #(D_W,A_W,ID_W)cfg;
   axi_slave_memory mem;
   virtual axi_footprint_interface #(D_W,A_W,ID_W) axi_vif;
   uvm_analysis_port #(axi_seq_item) axi_analysis_port;
   
   logic [`AXI_MAX_DW-1:0] shifted_wr_data [];
   logic [`AXI_MAX_DW-1:0] shifted_rd_data [];
   bit [`AXI_MAX_DW/8-1:0] shifted_byte_en [];

   //overflow -> zero
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
   
   uvm_queue #(axi_seq_item) all_r;
   uvm_queue #(axi_seq_item) all_w;
   
   semaphore sem_w;
   semaphore sem_r;
   
   real clk;
   real timescale;
   
   int file_m_wr_req,file_m_rd_req;
   int file_s_wr_req,file_s_rd_req;
   int file_m_wr_resp,file_m_rd_resp;
   int file_s_wr_resp,file_s_rd_resp;
   int count_m_wr_req,count_s_wr_req;
   int count_m_rd_req,count_s_rd_req;
   int count_m_wr_resp,count_s_wr_resp;
   int count_m_rd_resp,count_s_rd_resp;

   extern function new(string name, uvm_component parent);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern function void report_phase(uvm_phase phase);
   extern function void perf_report();
   extern task axi_monitor();

   extern task post_process_axi_write_pkt(axi_seq_item t);
   extern task post_process_axi_read_pkt(axi_seq_item t);
   extern task publish_write_transaction(axi_seq_item t);
   extern task publish_read_transaction(axi_seq_item t);
   
   extern task get_write_responses();
   extern task get_read_responses();
   extern task get_writes();
   extern task check_reset();
   extern task get_reads();
   extern task match_writes();
   extern task match_reads();
   extern task feel_the_beat();
   extern function int get_abs_resolution(); 

   
endclass

function axi_monitor::new(string name, uvm_component parent);
   super.new(name,parent);
   axi_analysis_port = new ("axi_analysis_port",this);

   req_read_q = new("req_read_q");
   rsp_read_q = new("rsp_read_q");
   req_write_q = new("req_write_q");
   rsp_write_q = new("rsp_write_q");
   
   r_q = new("r_q");
   b_q = new("b_q");
   all_w = new("all_w");
   all_r = new("all_r");
   
   sem_w = new(1);
   sem_r = new(1);
endfunction : new

function void axi_monitor::build_phase(uvm_phase phase);
   super.build_phase (phase);

   if (!uvm_config_db#(axi_agent_configuration #(D_W,A_W,ID_W))::get(this, "", "axi_cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "Can't get configuration object through config_db")
   end

  axi_vif = cfg.axi_vif;
  if(axi_vif == null)
    `uvm_fatal(get_type_name(), "NULL VIF");
  
  if(cfg.active_monitor == 1 && cfg.has_memory == 1) begin
     //Get memory handle
     if (!uvm_config_db#(axi_slave_memory)::get(this, "", "slave_memory", mem)) begin
      `uvm_fatal(get_type_name(), "Can't get memory component through config_db")
     end
  end
  
endfunction : build_phase

task axi_monitor::run_phase(uvm_phase phase);
   super.run_phase (phase);
   forever begin
      @(posedge axi_vif.aresetn);
      fork
         axi_monitor();
      join_none
      @(negedge axi_vif.aresetn);
      disable fork;
      check_reset();
   end

endtask : run_phase

task axi_monitor::axi_monitor();
   if (axi_vif.aresetn !== 1'b1) begin
      `uvm_info (get_type_name(), "Waiting for reset signal...", UVM_LOW);
      @(posedge axi_vif.aresetn);
      `uvm_info (get_type_name(), "Reset signal deactivated", UVM_LOW);
   end

   if(cfg.active_monitor == 1 && cfg.has_memory == 1) begin
      mem.init(cfg.memory_debug_verbosity, cfg.addr_to_cause_error, cfg.enable_addr_to_cause_error);
   end
   
   fork
      forever get_write_responses();
      forever get_read_responses();
      forever get_writes();
      forever get_reads();
      forever match_reads();
      forever match_writes();
      forever feel_the_beat(); 
      forever check_reset();
   join

endtask

task axi_monitor::check_reset();
    while(axi_vif.aresetn === 1)@(axi_vif.axi_monitor_cb);
    if(axi_vif.aresetn === 0)begin
      fork
         req_write_q = new();
         rsp_write_q = new();
         req_read_q  = new();

         rsp_read_q  = new();

         r_q.delete();

         b_q.delete();
         all_w.delete();
         all_r.delete();
      join

    end	
//`uvm_info(get_full_name,"(((((((((((((((((((((end)))))))))))))))))",UVM_NONE)

endtask



function int axi_monitor::get_abs_resolution();
      time tmp;
      tmp = 1fs;
      if(tmp) return 15;
      tmp = 10fs;
      if(tmp) return 14;
      tmp = 100fs;
      if(tmp) return 13;
      tmp = 1ps;
      if(tmp) return 12;
      tmp = 10ps;
      if(tmp) return 11;
      tmp = 100ps;
      if(tmp) return 10;
      tmp = 1ns;
      if(tmp) return 9;
      tmp = 10ns;
      if(tmp) return 8;
      tmp = 100ns;
      if(tmp) return 7;

      assert(0) else $fatal(1,"unsupported simulation precision");

endfunction // get_abs_resolution

task axi_monitor:: feel_the_beat();    
   
   real cnt_high, cnt_low, ts = 0;
 
   #1;
   
   ts = -1 * get_abs_resolution();
   timescale = 1*(10**ts);
   
   while(1) begin

      @(posedge axi_vif.aclk);
      cnt_high = $realtime();
      @(negedge axi_vif.aclk);
      cnt_high = $realtime - cnt_high;
      cnt_low = $realtime();
      @(posedge axi_vif.aclk);
      cnt_low = $realtime() - cnt_low;
      
      clk = 1 / ((cnt_high + cnt_low)*timescale);
   end

endtask : feel_the_beat

task axi_monitor:: get_read_responses();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   t.use_last_signaling = cfg.last_signaling_used;
   
   axi_vif.mon_r(t);
   
   sem_r.get(1);
   r_q.push_back(t);
   sem_r.put(1);

   @(axi_vif.axi_monitor_cb);
endtask : get_read_responses

task axi_monitor:: get_reads();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   axi_vif.mon_ar(t);
   
   // Internal ID counter in case of AXI Lite
   if(cfg.last_signaling_used == 0)
      t.id = arid_rid_counter++;
   
   t.burst_length += 1;
   //t.data = new[t.burst_length];
   //t.rresp = new[t.burst_length];
   t.op_type = AXI_READ;
         
   @(axi_vif.axi_monitor_cb);
   t.end_of_rw = $realtime();
  
   req_read_q.put(t);
   if(cfg.master == 1)begin
     file_m_rd_req= $fopen($sformatf("mon_master_%0d_read_req_log.txt",cfg.master_i),"a");
  
     $fdisplay(file_m_rd_req,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [read resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_m_rd_req,t.sprint);  
     count_m_rd_req++; 
 
   end
   else begin
     file_s_rd_req= $fopen($sformatf("mon_slave_%0d_read_req_log.txt",cfg.slave_i),"a");
    
     $fdisplay(file_s_rd_req,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [read resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_s_rd_req,t.sprint);  
     count_s_rd_req++; 
 
   end

   if(axi_vif.aresetn === 1) begin
   axi_analysis_port.write(t);
    `uvm_info(get_type_name,$sformatf("monitor read req packet is =%0s",t.sprint),UVM_NONE) 
   end
endtask : get_reads

task axi_monitor:: match_reads();
   axi_seq_item t, b;
   int pop_out = 0;
   t = axi_seq_item::type_id::create("t", this);
   b = axi_seq_item::type_id::create("b", this);
   
   req_read_q.peek(t);
   t.data = new[t.burst_length];
   t.rresp = new[t.burst_length];
   sem_r.get(1);
   
   //check for validity
   if( (($realtime - t.start_time) / ((1/timescale)/clk)) > cfg.num_timeout_cycles ) 
         `uvm_fatal(get_type_name(), $sformatf("Read response not received for transaction ID: %0d (start time: %0d, current cycles: %0d, max cycles: %0d", 
         t.id, t.start_time, (($realtime - t.start_time) / ((1/timescale)/clk)), cfg.num_timeout_cycles))
      
   for(int i = 0; i < r_q.size(); i++) begin
      b = r_q.get(i);
     
      if(b.id == t.id || cfg.last_signaling_used == 0) begin
         for(int j = 0; j < t.burst_length; j++) begin
            t.rresp[j] = b.rresp[j];
            t.data[j] = b.data[j];
         end
         t.end_time = b.end_time;
         pop_out = 1;
         r_q.delete(i);
         t.total_time = t.end_time - t.start_time;
         t.transaction_cycles = t.total_time / ((1/timescale)/clk);
         if(cfg.has_perf_analysis == 1) all_r.push_back(t);
      end
   end
   sem_r.put(1);  
   if(pop_out) begin
      post_process_axi_read_pkt(t);
      req_read_q.get(b);
   end
   
   @(axi_vif.axi_master_cb);
endtask : match_reads

task axi_monitor:: get_write_responses();
   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   axi_vif.mon_b(t);
   
   sem_w.get(1);
   b_q.push_back(t);
   sem_w.put(1);

   @(axi_vif.axi_monitor_cb);
endtask : get_write_responses

task axi_monitor:: get_writes();
   bit[`AXI_MAX_AW-1:0] address[];
   bit[`AXI_MAX_AW-1:0] beat_address;
   logic [`AXI_MAX_DW-1:0] wr_data [];
   bit [`AXI_MAX_DW/8-1:0] byte_en [];

   axi_seq_item t;
   t = axi_seq_item::type_id::create("t", this);
   
   t.use_last_signaling = cfg.last_signaling_used;
  // fork
     fork
      begin
         axi_vif.mon_aw(t);
      end
      begin
         axi_vif.mon_w(t);
      end
    join
    //  check_reset();
 //  join_any
   
  /* if(axi_vif.axi_vif.axi_monitor_cb.aresetn === 0) begin
     disable fork;
     t=null();
   end*/

   //else begin
     // Internal ID counter in case of AXI Lite
     if(cfg.last_signaling_used == 0)
        t.id = awid_bid_counter++;

     t.burst_length += 1;
     t.op_type = AXI_WRITE;
     
     @(axi_vif.axi_monitor_cb);
     t.end_of_rw = $realtime();
   //  if(axi_vif.axi_monitor_cb.aresetn === 0) t=null();
      // while(req_write_q.try_get(t));
     //end
    
    // else begin
     
     if(cfg.master == 1)begin
       file_m_wr_req= $fopen($sformatf("mon_master_%0d_write__req_log.txt",cfg.master_i),"a");
      
       $fdisplay(file_m_wr_req,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [write req packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_m_wr_req,t.sprint);  
       count_m_wr_req++; 
 
     end
     else begin
       file_s_wr_req= $fopen($sformatf("mon_slave_%0d_write_req_log.txt",cfg.slave_i),"a");
      
       $fdisplay(file_s_wr_req,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [write req packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_s_wr_resp,t.sprint);  
       count_s_wr_req++; 
 
     end
   //  `uvm_info(get_name,$sformatf("write req packet is \n %s",t.sprint),UVM_LOW)
   
     if(axi_vif.aresetn === 1)begin
       axi_analysis_port.write(t);  
       `uvm_info(get_name,$sformatf("write req packet is \n %s",t.sprint),UVM_LOW)
     end
     req_write_q.put(t);
  // end
endtask : get_writes

task axi_monitor:: match_writes();
   axi_seq_item t, b;
   int pop_out = 0;
   t = axi_seq_item::type_id::create("t", this);
   b = axi_seq_item::type_id::create("b", this);
   
   req_write_q.peek(t);
   sem_w.get(1);


   if( (($realtime - t.start_time) / ((1/timescale)/clk)) > cfg.num_timeout_cycles ) 
      `uvm_fatal(get_type_name(), $sformatf("Write response not received for transaction ID: %0d (start time: %0d, current cycles: %0d, max cycles: %0d", 
      t.id, t.start_time, (($realtime - t.start_time) / ((1/timescale)/clk)), cfg.num_timeout_cycles))

   for(int i = 0; i < b_q.size(); i++) begin
      b = b_q.get(i);
      if(b.id == t.id || cfg.last_signaling_used == 0) begin         
         t.bresp = b.bresp;
         t.end_time = b.end_time;
         pop_out = 1;
         b_q.delete(i);
         t.total_time = t.end_time - t.start_time;
         t.transaction_cycles = t.total_time / ((1/timescale)/clk);
         if(cfg.has_perf_analysis == 1) all_w.push_back(t);
      end
   end
   sem_w.put(1);  
   if(pop_out) begin
      post_process_axi_write_pkt(t); 
      req_write_q.get(b);
   end
   
   @(axi_vif.axi_master_cb);
endtask : match_writes

task axi_monitor:: post_process_axi_write_pkt(axi_seq_item t);
   axi_seq_item wr_tr;
   bit[`AXI_MAX_AW-1:0] address[];
   bit[`AXI_MAX_AW-1:0] beat_address;
   logic [`AXI_MAX_DW-1:0] wr_data [];
   bit [`AXI_MAX_DW/8-1:0] byte_en [];
   
   wr_tr = axi_seq_item::type_id::create("wr_tr", this);

   $cast(wr_tr, t.clone());
   
   //byte_en = new[wr_tr.burst_length];
   //wr_data = new[wr_tr.burst_length];
 //  address = new[wr_tr.burst_length];
   //byte_en = wr_tr.byte_en;
   //wr_data = wr_tr.data;
   //
   //
   ////
   //// Print mode
   ////
   //
   //// Shift byte enable and data (default mode)
   //if (cfg.monitor_print_tr_in_state == 1'b0) begin
   //  beat_address = wr_tr.addr;
   //  for (int i = 0; i < wr_tr.burst_length; i++) begin
   //     axi_common::shift_data_right(beat_address, byte_en[i], wr_tr.byte_en[i], wr_tr.tr_size_in_bytes, 1, cfg.data_width);
   //     if (i == 0 && (beat_address % wr_tr.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
   //       beat_address = (beat_address + wr_tr.tr_size_in_bytes) - (beat_address % wr_tr.tr_size_in_bytes);
   //     else
   //       beat_address = beat_address + wr_tr.tr_size_in_bytes;
   //  end
   //  
   //  beat_address = wr_tr.addr;
   //  for (int i = 0; i < wr_tr.burst_length; i++) begin
   //     axi_common::shift_data_right(beat_address, wr_data[i], wr_tr.data[i], wr_tr.tr_size_in_bytes, 0, cfg.data_width); 
    //    address[i] = beat_address;
   //     if (i == 0 && (beat_address % wr_tr.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
   //       beat_address = (beat_address + wr_tr.tr_size_in_bytes) - (beat_address % wr_tr.tr_size_in_bytes);
   //     else
   //       beat_address = beat_address + wr_tr.tr_size_in_bytes;
   //  end
   //end
   
   
   if(cfg.active_monitor == 1) begin
      for (int j = 0; j < wr_tr.burst_length; j++) begin
         if(mem.write(address[j], wr_tr.data[j], wr_tr.tr_size_in_bytes, wr_tr.byte_en[j])) wr_tr.bresp = 0;
      else wr_tr.bresp = 2; //Error occured
    end   
   end
   
   if(cfg.log_verbosity != "none")
      publish_write_transaction(wr_tr);
   if(cfg.master == 1)begin
   file_m_wr_resp= $fopen($sformatf("mon_master_%0d_write__resp_log.txt",cfg.master_i),"a");
  
   $fdisplay(file_m_wr_resp,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [write resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_m_wr_resp,wr_tr.sprint);  
   count_m_wr_resp++; 
 
   end
   else begin
   file_s_wr_resp= $fopen($sformatf("mon_slave_%0d_write_resp_log.txt",cfg.slave_i),"a");
  
   $fdisplay(file_s_wr_resp,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [write resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_s_wr_resp,wr_tr.sprint);  
   count_s_wr_resp++; 
 
   end

    
   wr_tr.req_res = RESPONSE;
//  `uvm_info(get_type_name,$sformatf("monitor write packet respnse is =%0s",wr_tr.sprint),UVM_NONE) 
    if(axi_vif.aresetn === 1)begin 
    axi_analysis_port.write(wr_tr);
    `uvm_info(get_type_name,$sformatf("monitor write packet respnse is =%0s",wr_tr.sprint),UVM_NONE) 
    end
   
endtask : post_process_axi_write_pkt

task axi_monitor:: post_process_axi_read_pkt(axi_seq_item t);
   axi_seq_item rd_tr;
   bit [`AXI_MAX_AW-1:0]     beat_address;
   logic [`AXI_MAX_AW-1:0]   Start_Address;
   logic [31:0]              Number_Bytes;
   logic [31:0]              Burst_Length;
   logic [7:0]               Data_Bus_Bytes;
   logic [31:0]              addr;
   logic [31:0]              Aligned_Address;
   bit                       aligned;
   logic [31:0]              dtsize;
   logic [7:0]               Lower_Byte_Lane;
   logic [7:0]               Upper_Byte_Lane;
   logic [7:0]               temp_data[$];
   logic [7:0]               temp_rresp[$];
   //int 			     slave_data;
  
   rd_tr = axi_seq_item::type_id::create("rd_tr", this);

   $cast(rd_tr, t.clone());
   
   `uvm_info(get_type_name(),$sformatf("before scr =%0s",rd_tr.sprint),UVM_LOW)
   rd_tr.byte_en = new[rd_tr.burst_length];  
   shifted_rd_data = new[rd_tr.burst_length];
   shifted_rd_data = rd_tr.data;
   
   Data_Bus_Bytes = $size(axi_vif.axi_monitor_cb.rdata)/8;

    Number_Bytes = rd_tr.tr_size_in_bytes;

    // Calculate Aligned_Address
    Aligned_Address = ($floor(rd_tr.addr / rd_tr.tr_size_in_bytes)) * rd_tr.tr_size_in_bytes;
    aligned = (Aligned_Address == rd_tr.addr);

    Start_Address = rd_tr.addr;

    // Calculate dtsize
    dtsize = rd_tr.tr_size_in_bytes * rd_tr.burst_length;

	for (int n = 1; n <= rd_tr.burst_length; n++) begin
          if(n==1) begin
            //`uvm_info(get_type_name(),$sformatf("value of Address=%0d",Start_Address),UVM_LOW)
            //`uvm_info(get_type_name(),$sformatf("value of data_bus_bytes=%0d",Data_Bus_Bytes),UVM_LOW)
            Lower_Byte_Lane = Start_Address -($floor(Start_Address/Data_Bus_Bytes))* Data_Bus_Bytes;
            Upper_Byte_Lane = Aligned_Address +( Number_Bytes - 1) - ($floor(Start_Address / Data_Bus_Bytes)) * Data_Bus_Bytes;
          `uvm_info(get_type_name(),$sformatf("start LB =%0d\t UB = %0d\t data_bus_B = %0d\t start_add= %0h no_B=%0d",Lower_Byte_Lane,Upper_Byte_Lane,Data_Bus_Bytes,Start_Address,Number_Bytes),UVM_LOW)

          end
          else begin
            Start_Address =Aligned_Address+(n-1)* Number_Bytes;
            //`uvm_info(get_type_name(),$sformatf("value of second_transfer=%0d",Start_Address),UVM_LOW)
            //   B=($floor(Start_Address / Data_Bus_Bytes));
            //`uvm_info(get_type_name(),$sformatf("value of B=%0d",B),UVM_LOW)
            Lower_Byte_Lane=Start_Address-($floor(Start_Address/Data_Bus_Bytes))*Data_Bus_Bytes;
            Upper_Byte_Lane = Lower_Byte_Lane + (Number_Bytes - 1);
          `uvm_info(get_type_name(),$sformatf("LB =%0d\t UB = %0d\t data_bus_B = %0d\t start_add= %0h no_B=%0d",Lower_Byte_Lane,Upper_Byte_Lane,Data_Bus_Bytes,Start_Address,Number_Bytes),UVM_LOW)

            end
         // `uvm_info(get_type_name(),$sformatf("LB =%0d\t UB = %0d\t data_bus_B = %0d\t start_add= %0h no_B=%0d",Lower_Byte_Lane,Upper_Byte_Lane,Data_Bus_Bytes,Start_Address,Number_Bytes),UVM_LOW)
           
            // All transfers after the first are aligned
            //`uvm_info(get_type_name(),$sformatf("lower_byte_lane=%0h and upper_byte-lane=%0h",Lower_Byte_Lane,Upper_Byte_Lane),UVM_LOW)
            for (int i = Lower_Byte_Lane; i <= Upper_Byte_Lane; i++) begin
                temp_data.push_front(rd_tr.data[n-1][i*8+:8]);
               //  slave_data=rd_tr.data[n-1][i*8+:8];
              //   `uvm_info(get_type_name(),$sformatf("value_checking=%0h",slave_data),UVM_LOW)
                temp_rresp.push_front(rd_tr.rresp[n-1]);
  // `uvm_info(get_type_name(),$sformatf("tempdata =%0d after scr =%0s",temp_data.size,rd_tr.sprint),UVM_LOW)

            end
   //`uvm_info(get_type_name(),$sformatf("tempdata =%0d after scr =%0s",temp_data.size,rd_tr.sprint),UVM_LOW)

        end
   `uvm_info(get_type_name(),$sformatf("tempdata =%0d after scr =%0s",temp_data.size,rd_tr.sprint),UVM_LOW)

  // `uvm_info(get_type_name(),$sformatf("after scr =%0s",rd_tr.sprint),UVM_LOW)

       rd_tr.data  = new[temp_data.size()];
       rd_tr.rresp = new[temp_rresp.size()];
 //  `uvm_info(get_type_name(),$sformatf("tempdata =%0d after scr =%0s",temp_data.size,rd_tr.sprint),UVM_LOW)

       foreach(rd_tr.data[i])   begin
                 rd_tr.data[i]  = temp_data.pop_back();
                // `uvm_info(get_type_name(),$sformatf("checking_value=%0h",rd_tr.data[i]),UVM_LOW)
            end

       foreach(rd_tr.rresp[i])  rd_tr.rresp[i] = temp_rresp.pop_back();
   //`uvm_info(get_type_name(),$sformatf("tempdata =%0d after scr =%0s",temp_data.size,rd_tr.sprint),UVM_LOW)

        /*for (int n = 1; n <= rd_tr.burst_length; n++) begin
            Lower_Byte_Lane = Start_Address - ($floor(Start_Address / Data_Bus_Bytes)) * Data_Bus_Bytes;
            if (aligned) begin
                Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes - 1;
            end else begin
                Upper_Byte_Lane = Aligned_Address + Number_Bytes - 1 - ($floor(Start_Address / Data_Bus_Bytes)) * Data_Bus_Bytes;
            end
            Start_Address =n + Number_Bytes;
            aligned = 1; // All transfers after the first are aligned
            for (int i = Lower_Byte_Lane; i <= Upper_Byte_Lane; i++) begin
                temp_data.push_front(rd_tr.data[n-1][i*8+:8]);
                temp_rresp.push_front(rd_tr.rresp[n-1]);
            end
        end


       rd_tr.data  = new[temp_data.size()];
       rd_tr.rresp = new[temp_data.size()];

       foreach(rd_tr.data[i])   rd_tr.data[i]  = temp_data.pop_back();
       foreach(rd_tr.rresp[i])  rd_tr.rresp[i] = temp_rresp.pop_back();*/
   // Shift each data beat
   //beat_address = rd_tr.addr;
   //for (int i = 0; i < rd_tr.burst_length; i++) begin
   //   axi_common::shift_data_right(beat_address, shifted_rd_data[i], rd_tr.data[i], rd_tr.tr_size_in_bytes, 0, cfg.data_width); //`AXI_MAX_DW);
   //   if (i == 0 && (beat_address % rd_tr.tr_size_in_bytes != 0)) // Unaligned transfer, next addresses of burst are aligned
   //     beat_address = (beat_address + rd_tr.tr_size_in_bytes) - (beat_address % rd_tr.tr_size_in_bytes);
   //   else
   //     beat_address = beat_address + rd_tr.tr_size_in_bytes;
   //end
   //
   //// Clear unused upper data bits
   //for (int j = 0; j < rd_tr.burst_length; j++) begin
   //   for(int i = `AXI_MAX_DW-1; i >= rd_tr.tr_size_in_bytes*8; i--)
   //     if (rd_tr.byte_en[j][i/8] !== 1'b1)
   //       rd_tr.data[j][i] = 0;
   //end

   if(cfg.master == 1)begin
     file_m_rd_resp= $fopen($sformatf("mon_master_%0d_read_resp_log.txt",cfg.master_i),"a");
  
     $fdisplay(file_m_rd_resp,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [read resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_m_rd_resp,rd_tr.sprint);  
     count_m_rd_resp++; 
 
   end
   else begin
     file_s_rd_resp= $fopen($sformatf("mon_slave_%0d_read_resp_log.txt",cfg.slave_i),"a");
    
     $fdisplay(file_s_rd_resp,"\n\n------------------------****************************START****************************************-------------------------\nmonitor [read resp packet=%0d]\n%s\n------------------------------****************************END****************************************----------------------------\n",count_s_rd_resp,rd_tr.sprint);  
     count_s_rd_resp++; 
   end

   rd_tr.req_res = RESPONSE; 
    if(axi_vif.aresetn === 1)begin
    axi_analysis_port.write(rd_tr);
    `uvm_info(get_type_name,$sformatf("monitor read packet respnse is =%0s",rd_tr.sprint),UVM_NONE) 
    end
   if(cfg.log_verbosity != "none")
      publish_read_transaction(rd_tr);
  

endtask : post_process_axi_read_pkt

task axi_monitor::publish_write_transaction(axi_seq_item t);
   
  case (cfg.log_verbosity)
  "low" : begin
     `uvm_info(get_type_name(),
               $sformatf("AXI write: addr: 0x%0h, data[0]: 0x%0h, byte_en: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                         t.addr, t.data[0], t.byte_en[0], t.tr_size_in_bytes, t.burst_length), UVM_LOW);
     if (t.burst_length > 1) begin
        for (int i = 0; i < t.burst_length; i++) begin
           `uvm_info(get_type_name(), $sformatf("AXI write burst data %0d: 0x%0h", i, t.data[i]), UVM_LOW);
        end
     end
  end
  "medium" : begin
     `uvm_info(get_type_name(),
               $sformatf("AXI write: addr: 0x%0h, data[0]: 0x%0h, byte_en: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                         t.addr, t.data[0], t.byte_en[0], t.tr_size_in_bytes, t.burst_length), UVM_MEDIUM);
     if (t.burst_length > 1) begin
        for (int i = 0; i < t.burst_length; i++) begin
           `uvm_info(get_type_name(),
		      $sformatf("AXI write burst data %0d: 0x%0h", i, t.data[i]), UVM_MEDIUM);
        end
     end
  end
  "high" : begin
     `uvm_info(get_type_name(),
               $sformatf("AXI write: addr: 0x%0h, data[0]: 0x%0h, byte_en: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                         t.addr, t.data[0], t.byte_en[0], t.tr_size_in_bytes, t.burst_length), UVM_HIGH);
     if (t.burst_length > 1) begin
        for (int i = 0; i < t.burst_length; i++) begin
           `uvm_info(get_type_name(),
		      $sformatf("AXI write burst data %0d: 0x%0h", i, t.data[i]), UVM_HIGH);
        end
     end
  end
  endcase
  
  case (cfg.log_verbosity)
     "low" : begin
       `uvm_info(get_type_name(), $sformatf("AXI write completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_LOW);
     end
     "medium" : begin
       `uvm_info(get_type_name(), $sformatf("AXI write completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_MEDIUM);
     end
     "high" : begin
       `uvm_info(get_type_name(), $sformatf("AXI write completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_HIGH);
     end
  endcase
  
   if(t.bresp !== 0) begin
      if (cfg.bresp_error == 1) begin
         `uvm_error(get_type_name(),
            $sformatf("AXI write resp channel response not as expected: bresp = %0h for transaction ID: %0d @=0x%0h",t.bresp, t.id, t.addr));
      end else begin
         `uvm_warning(get_type_name(),
            $sformatf("AXI write resp channel response not as expected: bresp = %0h for transaction ID: %0d @=0x%0h",t.bresp, t.id, t.addr));
      end
   end
      
endtask : publish_write_transaction

task axi_monitor::publish_read_transaction(axi_seq_item t);
   
   case (cfg.log_verbosity)
     "low" : begin
        `uvm_info(get_type_name(), $sformatf("AXI read: addr: 0x%0h, data[0]: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                                             t.addr, t.data[0], t.tr_size_in_bytes, t.burst_length), UVM_LOW);
        if (t.burst_length > 1) begin
           for (int i = 0; i < t.burst_length; i++) begin
              `uvm_info(get_type_name(), $sformatf("AXI read burst data %0d: 0x%0h", i, t.data[i]), UVM_LOW);
           end
        end
     end
     "medium" : begin
        `uvm_info(get_type_name(), $sformatf("AXI read: addr: 0x%0h, data[0]: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                                             t.addr, t.data[0], t.tr_size_in_bytes, t.burst_length), UVM_MEDIUM);
        if (t.burst_length > 1) begin
           for (int i = 0; i < t.burst_length; i++) begin
              `uvm_info(get_type_name(), $sformatf("AXI read burst data %0d: 0x%0h", i, t.data[i]), UVM_MEDIUM);
           end
        end
     end
     "high" : begin
        `uvm_info(get_type_name(), $sformatf("AXI read: addr: 0x%0h, data[0]: 0x%0h, tr_size_in_bytes: %0d, burst_length: %0d",
                                             t.addr, t.data[0], t.tr_size_in_bytes, t.burst_length), UVM_HIGH);
        if (t.burst_length > 1) begin
           for (int i = 0; i < t.burst_length; i++) begin
              `uvm_info(get_type_name(), $sformatf("AXI read burst data %0d: 0x%0h", i, t.data[i]), UVM_HIGH);
           end
        end
     end
   endcase

   case (cfg.log_verbosity)
     "low" : begin
        `uvm_info(get_type_name(), $sformatf("AXI read completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_LOW);
     end
     "medium" : begin
       `uvm_info(get_type_name(), $sformatf("AXI read completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_MEDIUM);
     end
     "high" : begin
       `uvm_info(get_type_name(), $sformatf("AXI read completed for transaction ID: %0d, latency: %0d cycles", t.id, t.transaction_cycles), UVM_HIGH);
     end
   endcase
   
   for(int i = 0; i < t.burst_length; i++) begin
      if(t.rresp[i] !== 0) begin
         if (cfg.rresp_error == 1) begin
            `uvm_error(get_type_name(),
               $sformatf("AXI read resp channel response not as expected: rresp = %0h",
                  t.rresp[i]));
         end else begin
            `uvm_warning(get_type_name(),
               $sformatf("AXI read resp channel response not as expected: rresp = %0h",
                  t.rresp[i]));
         end
      end
   end
         
endtask : publish_read_transaction

function void axi_monitor::report_phase(uvm_phase phase);

   if(cfg.has_perf_analysis == 1) begin
      perf_report();
   end
   $fclose(file_m_wr_req);
   $fclose(file_s_wr_req);
   $fclose(file_m_wr_resp);
   $fclose(file_s_wr_resp);
   $fclose(file_m_wr_req);
   $fclose(file_s_wr_req);
   $fclose(file_m_wr_resp);
   $fclose(file_s_wr_resp);
endfunction : report_phase

function void axi_monitor::perf_report();
   axi_seq_item t;
   real read_bw = 0;
   real write_bw = 0;
   
   t = axi_seq_item::type_id::create("t", this);
   
   `uvm_info(get_type_name(), "BW calculation is based on the maximum bus width (cfg.data_width) without idle periods", UVM_LOW);
   
   if(all_w.size() !== 0) begin
      for(int i = 0; i < all_w.size(); i++) begin
         t = all_w.get(i);
         t.data_amount_in_bits = cfg.data_width * t.burst_length;
         t.total_time = t.end_of_rw - t.start_time;
         write_bw += ((t.data_amount_in_bits/8)/1e6) / (t.total_time*timescale);
      end
      write_bw = write_bw / all_w.size();
      `uvm_info(get_type_name(), $sformatf("Average write bandwidth: %f MBytes/s", write_bw), UVM_LOW);
   end else begin
      `uvm_info(get_type_name(), "No write transactions observed", UVM_LOW);
   end
      
   if(all_r.size() !== 0) begin
      for(int i = 0; i < all_r.size(); i++) begin
         t = all_r.get(i);
         t.data_amount_in_bits = cfg.data_width * t.burst_length;
         t.total_time = t.end_of_rw - t.start_time;
         read_bw += ((t.data_amount_in_bits/8)/1e6) / (t.total_time*timescale);
      end
      read_bw = read_bw / all_r.size();
      `uvm_info(get_type_name(), $sformatf("Average read bandwidth: %f MBytes/s", read_bw), UVM_LOW);
   end else begin
      `uvm_info(get_type_name(), "No read transactions observed", UVM_LOW);
   end
   
endfunction : perf_report

`endif //AXI_MONITOR__SVH

