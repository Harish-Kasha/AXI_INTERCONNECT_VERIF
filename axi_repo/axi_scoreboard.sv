
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// File name   : axi_scoreboard234.sv
// Description : It is going to compare the expected packet with the actual packet,from that we can test the axi_interconnect functionlity.
//               During development of scoreboard by taking the no of queues as equal to the no of slaves.
//              
//               No of masters : 4
//		 No of slaves  : 6    
//  
//               // Slave address ranges   
//               parameter NO_M     = 4,	NO_S     = 6; 
//              
//		 parameter S0_START = 'h0,      S0_END   = 'h0FFF; 
//               parameter S1_START = 'h1000,   S1_END   = 'h2FFF; 
//               parameter S2_START = 'h3000,   S2_END   = 'h6FFF; 
//               parameter S3_START = 'h7000,   S3_END   = 'h106FFF; 
//               parameter S4_START = 'h107000, S4_END   = 'h108FFF; 
//               parameter S5_START = 'h109000, S5_END   = 'h10AFFF;
// 		 
//		 parameter MID_M0   = 0; 
//		 parameter MID_M1   = 1; 
//		 parameter MID_M2   = 2; 
//		 parameter MID_M3   = 3; 
//
//	         parameter S_ID_MAX = 7;
//	         parameter S_NUM_S0 = 0;
//	         parameter S_NUM_S1 = 1;
//	         parameter S_NUM_S2 = 2;
//	         parameter S_NUM_S3 = 3;
//	         parameter S_NUM_S4 = 4;
//	         parameter S_NUM_S5 = 5;
//
//                
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 
import axi_parameter_pkg::*;


class interconnect_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(interconnect_scoreboard)
`uvm_analysis_imp_decl(_M0)
`uvm_analysis_imp_decl(_M1)
`uvm_analysis_imp_decl(_M2)
`uvm_analysis_imp_decl(_M3)
`uvm_analysis_imp_decl(_S0)
`uvm_analysis_imp_decl(_S1)
`uvm_analysis_imp_decl(_S2)
`uvm_analysis_imp_decl(_S3)
`uvm_analysis_imp_decl(_S4)
`uvm_analysis_imp_decl(_S5)
int count;

   // queues for storing the  expected packets
   axi_seq_item write_req_q[NO_S][$];  
   axi_seq_item read_req_q[NO_S][$];  
   axi_seq_item write_res_q[NO_M][$];  
   axi_seq_item read_res_q[NO_M][$];  

   // analysis ports  
   uvm_analysis_imp_M0     #(axi_seq_item,interconnect_scoreboard) M0_imp;
   uvm_analysis_imp_M1     #(axi_seq_item,interconnect_scoreboard) M1_imp;
   uvm_analysis_imp_M2     #(axi_seq_item,interconnect_scoreboard) M2_imp;
   uvm_analysis_imp_M3     #(axi_seq_item,interconnect_scoreboard) M3_imp;

   uvm_analysis_imp_S0     #(axi_seq_item,interconnect_scoreboard) S0_imp;
   uvm_analysis_imp_S1     #(axi_seq_item,interconnect_scoreboard) S1_imp;
   uvm_analysis_imp_S2     #(axi_seq_item,interconnect_scoreboard) S2_imp;
   uvm_analysis_imp_S3     #(axi_seq_item,interconnect_scoreboard) S3_imp;
   uvm_analysis_imp_S4     #(axi_seq_item,interconnect_scoreboard) S4_imp;
   uvm_analysis_imp_S5     #(axi_seq_item,interconnect_scoreboard) S5_imp;
 
   function new(string name= "interconnect_scoreboard", uvm_component parent = null);
      super.new(name, parent);
      //analysis imp_ports
      M0_imp = new("M0_imp", this);
      M1_imp = new("M1_imp", this);
      M2_imp = new("M2_imp", this);
      M3_imp = new("M3_imp", this);
      S0_imp = new("S0_imp", this);
      S1_imp = new("S1_imp", this);
      S2_imp = new("S2_imp", this);
      S3_imp = new("S3_imp", this);
      S4_imp = new("S4_imp", this);
      S5_imp = new("S5_imp", this);
      
   endfunction


   // Master 0
   function void write_M0(axi_seq_item packet);
      reference_queues(packet,MID_M0);
   endfunction
   
   // Master1
   function void write_M1(axi_seq_item packet);
      reference_queues(packet,MID_M1);
   endfunction

   //Master2
   function void write_M2(axi_seq_item packet);
      reference_queues(packet,MID_M2);
   endfunction
  
   //Master3
   function void write_M3(axi_seq_item packet);
      reference_queues(packet,MID_M3);
   endfunction

   
   // Storing expected packets into the queues
   function  axi_seq_item reference_queues(axi_seq_item packet,int m_id);
      int q_num;
      axi_seq_item pkt;
      $cast(pkt,packet.clone());
      // Appending master_id with packet_id
      m_id = m_id << MAX_M_ID_WIDTH;
      pkt.id = m_id | pkt.id;
      //packet.id = m_id | packet.id;
      // Storing the packet into respective queues based on slave address
      case(pkt.addr) inside
            [S0_START:S0_END]  : q_num = 'd0;
            [S1_START:S1_END]  : q_num = 'd1;
            [S2_START:S2_END]  : q_num = 'd2;
            [S3_START:S3_END]  : q_num = 'd3;
            [S4_START:S4_END]  : q_num = 'd4;
            [S5_START:S5_END]  : q_num = 'd5;

            default            : `uvm_info(get_type_name(), $sformatf("Decode error=%s ",pkt.sprint()), UVM_LOW)
      endcase
      if(pkt.req_res == RESPONSE)
      begin
         pkt.addr = ({M_ADDR_W{1'b1}} >> (M_ADDR_W-S_ADDR_W[q_num])) & pkt.addr;
         pkt_compare(pkt,pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]);
      end
      else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST) 
      begin
         //pkt.addr = {{(M_ADDR_W-S_ADDR_W[q_num]){1'b0}},{S_ADDR_W[q_num]{1'b1}}} & pkt.addr;
         pkt.addr = ({M_ADDR_W{1'b1}} >> (M_ADDR_W-S_ADDR_W[q_num])) & pkt.addr;
         write_req_q[q_num].push_back(pkt);
      end
      else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)  
      begin
         pkt.addr = ({M_ADDR_W{1'b1}} >> (M_ADDR_W-S_ADDR_W[q_num])) & pkt.addr;
         //pkt.addr = {{(M_ADDR_W-S_ADDR_W[q_num]){1'b0}},{S_ADDR_W[q_num]{1'b1}}} & pkt.addr;
         read_req_q[q_num].push_back(pkt);
      end
      count++;
      //`uvm_info(get_type_name(), $sformatf("write_req_q[%0d] write_req_q[%0d]size =%0d",q_num,q_num,write_req_q[q_num].size()), UVM_LOW)
    endfunction


   //............................................... slave.............................
    // Slave 0
    function void write_S0(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
       $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)      pkt_compare(pkt,S_NUM_S0);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)       pkt_compare(pkt,S_NUM_S0);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      begin
          read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
    endfunction    
    // Slave 1
    function void write_S1(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
       $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)                 pkt_compare(pkt,S_NUM_S1);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)                  pkt_compare(pkt,S_NUM_S1);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      
       begin
          read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
    endfunction  
    // Slave 2
    function void write_S2(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
         $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)                 pkt_compare(pkt,S_NUM_S2);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)                  pkt_compare(pkt,S_NUM_S2);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
    endfunction   
    // Slave 3
    function void write_S3(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
         $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)                 pkt_compare(pkt,S_NUM_S3);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)                  pkt_compare(pkt,S_NUM_S3);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
    endfunction   
    // Slave 4
    function void write_S4(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
         $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)                 pkt_compare(pkt,S_NUM_S4);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)                  pkt_compare(pkt,S_NUM_S4);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
    endfunction  
    // Slave 5
    function void write_S5(axi_seq_item pkt);
       axi_seq_item cloned_pkt;
         $cast(cloned_pkt,pkt.clone());
       if(pkt.op_type==AXI_WRITE && pkt.req_res == RESPONSE)    begin
         write_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
       end
       else if(pkt.op_type==AXI_WRITE && pkt.req_res == REQUEST)                 pkt_compare(pkt,S_NUM_S5);
       else if(pkt.op_type==AXI_READ && pkt.req_res == REQUEST)                  pkt_compare(pkt,S_NUM_S5);
       else if(pkt.op_type==AXI_READ && pkt.req_res == RESPONSE)      read_res_q[cloned_pkt.id[(S_ID_WIDTH-1)-:$clog2(NO_M)]].push_back(cloned_pkt);
    endfunction    

    // Comparison method for expected and actual packet 
    function axi_seq_item pkt_compare(axi_seq_item pkt,int m_s_num);
       axi_seq_item temp,temp2;
       axi_seq_item slave_q[NO_S][$];
       axi_seq_item master_q[NO_M][$];
       // If no packets in expected queues
       if((pkt.op_type==AXI_WRITE) ? (pkt.req_res == 1'b0)? (write_req_q[m_s_num].size == 0) : (write_res_q[m_s_num].size == 0) : (pkt.req_res == 1'b0)? (read_req_q[m_s_num].size == 0) : (read_res_q[m_s_num].size == 0))begin   
          `uvm_error(get_type_name(), "no packet in the expected queues")
       end
       // If packets exists in expected queues
       else begin          
	  //`uvm_info(get_type_name(), $sformatf("Queue size of expected slave[%0d] =%d ",m_s_num,write_req_q[m_s_num].size), UVM_LOW)
          //`uvm_info(get_type_name(), $sformatf("Actual packet recevied from S[%0d] slave=%s ",m_s_num,pkt.sprint()), UVM_LOW)
          temp = (pkt.op_type == AXI_WRITE) ? (pkt.req_res == 1'b0) ? write_req_q[m_s_num][0] : write_res_q[m_s_num][0] : (pkt.req_res == 1'b0) ? read_req_q[m_s_num][0] : read_res_q[m_s_num][0];
          // comparing the actual packet with first packet from the expected queues for in-order transaction
          if(pkt.id == temp.id) begin
             if(pkt.addr == temp.addr) begin
                if(pkt.compare(temp)) begin
                   if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b0)                   write_req_q[m_s_num].pop_front();
                   else if (pkt.op_type == AXI_WRITE && pkt.req_res == 1'b1)             write_res_q[m_s_num].pop_front();
                   else if (pkt.op_type == AXI_READ && pkt.req_res == 1'b0)              read_req_q[m_s_num].pop_front();
                   else if (pkt.op_type == AXI_READ && pkt.req_res == 1'b1)              read_res_q[m_s_num].pop_front();
                   `uvm_info(get_type_name(), $sformatf("actual and expected packets are same for %s %s following order for same ID's",pkt.op_type.name,pkt.req_res.name), UVM_LOW)
                   `uvm_info(get_type_name(), $sformatf("%s %s comparison failed due to data mismatch, expected is \n%s actual is \n%s",pkt.op_type.name,pkt.req_res.name,temp.sprint(),pkt.sprint()),UVM_NONE)
                end            
                else begin
                `uvm_error(get_type_name(), $sformatf("%s %s comparison failed due to data mismatch, expected is \n%s actual is \n%s",pkt.op_type.name,pkt.req_res.name,temp.sprint(),pkt.sprint()))
                end
             end
             else begin
              `uvm_error(get_type_name(), $sformatf("In-order transaction is failed or address mismatch, expected is \n%s actual is \n%s",temp.sprint(),pkt.sprint()))
             end
          end
          // comparing the actual packet with packets from the expected queues for out of order transaction
          else begin
             if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b0)            slave_q[m_s_num]  = write_req_q[m_s_num].find(i) with (i.id == pkt.id);
             else if (pkt.op_type == AXI_WRITE && pkt.req_res == 1'b1)      master_q[m_s_num] = write_res_q[m_s_num].find(i) with (i.id == pkt.id);
             else if (pkt.op_type == AXI_READ && pkt.req_res == 1'b0)       slave_q[m_s_num] = read_req_q[m_s_num].find(i) with (i.id == pkt.id);
             else if (pkt.op_type == AXI_READ && pkt.req_res == 1'b1)       master_q[m_s_num] = read_res_q[m_s_num].find(i) with (i.id == pkt.id);

             if(pkt.compare( (pkt.req_res == 1'b0)?slave_q[m_s_num][0] : master_q[m_s_num][0])) begin
                `uvm_info(get_type_name(), $sformatf("actual and expected packets are same for %s %s",pkt.op_type.name,pkt.req_res.name), UVM_LOW)
                //if(pkt.req_res == 1'b0)  slave_q[m_s_num].pop_front();
                //else                                                 master_q[m_s_num].pop_front();
                if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b0)        write_req_q[m_s_num].pop_front();
                else if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b1)   write_res_q[m_s_num].pop_front;
                else if(pkt.op_type == AXI_READ && pkt.req_res == 1'b0)    read_req_q[m_s_num].pop_front();
                else if(pkt.op_type == AXI_READ && pkt.req_res == 1'b1)    read_res_q[m_s_num].pop_front();
             end            
             else begin
                `uvm_error(get_type_name(), $sformatf("two packets are not same for %s %s, expected is \n%p actual is \n%s",pkt.op_type.name,pkt.req_res.name, (pkt.req_res == 1'b0)? slave_q[0]: master_q[0],pkt.sprint()))
                //if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b0)  slave_q[m_s_num].pop_front(); else master_q[m_s_num].pop_front();
                //if(pkt.op_type == AXI_WRITE && pkt.req_res == 1'b0)  write_req_q[m_s_num].pop_front(); else write_res_q[m_s_num].pop_front;
	     end
          end
       
     end             
    endfunction

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info(get_full_name,$sformatf("count=%0d",count),UVM_NONE)
endfunction
endclass



