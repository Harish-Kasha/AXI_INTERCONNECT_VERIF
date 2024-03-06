 //***********************************************************************************************************************************************************
 //	File_name   : interconnect_extended_test.sv
 //     Description : This class is going to test the proper routing of packets to the respective slave slave from respective master by using slave address
 //***********************************************************************************************************************************************************
`include "axi_defines.svh"
class axi_interconnect_basic_test extends axi_interconnect_base_test;
   `uvm_component_utils(axi_interconnect_basic_test)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern task run_phase (uvm_phase phase);

endclass

   //constructor
   function axi_interconnect_basic_test::new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   //build_phase
   function void axi_interconnect_basic_test::build_phase(uvm_phase phase);
      super.build_phase(phase);  
   endfunction: build_phase
   
   //run_phase
   task axi_interconnect_basic_test::run_phase (uvm_phase phase);
      logic [1:0] 		   resp;   
      logic [`AXI_MAX_DW-1:0] wr_data        [];
      logic [`AXI_MAX_DW-1:0] rd_data        [];
      logic [`AXI_MAX_DW-1:0] rd_data_single;
      logic [1:0]  rresp[];
      logic [1:0]  bresp;
      int  	data;
      int          burst_length;
     
      //axi_seq_item instances
      axi_seq_item tr[];
      axi_seq_item t;
      //master read and write sequences handles
      axi_master_write_seq   wr_seq;
      axi_master_read_seq    rd_seq;
      axi_pipeline_write_seq pw_seq;
      axi_pipeline_read_seq  pr_seq;
   
   
      `uvm_info("TRACE"," Interconnect_extended_test is running. Using read and write sequences", UVM_LOW);
      uvm_top.print_topology ();
      phase.raise_objection (this);
   
      rd_seq = axi_master_read_seq::type_id::create("rd_seq");
      wr_seq = axi_master_write_seq::type_id::create("wr_seq");
      pw_seq = axi_pipeline_write_seq::type_id::create("pw_seq");
      pr_seq = axi_pipeline_read_seq::type_id::create("pr_seq");
      
      #50ns;
      // master 0 --> 16 transactions of write and read to slave 0   
     // pipelined write
 /*     burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 16'h0001; 
      wr_data[1] = 16'h0002; 
      wr_data[2] = 16'h0003; 
      wr_data[3] = 16'h0004; 
      wr_data[4] = 16'h0005; 



      //data = 16'h0;
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst(i*128, wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end
   `uvm_info(get_full_name,"from test after the pipeline write resp of 5",UVM_NONE)
      env.master_agt_0.sqr.get_write_responses(tr, 5, 0);

   `uvm_info(get_full_name,"from test after the pipeline write resp of 1",UVM_NONE)
      env.master_agt_0.sqr.get_single_write_response(t);
   `uvm_info(get_full_name,"from test after the pipeline write resp of all",UVM_NONE)
      env.master_agt_0.sqr.get_all_write_responses_in_fifo(tr, 100);
   `uvm_info(get_full_name,"from test after the pipeline write seq",UVM_NONE)
      foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
      #200ns;
*/

      burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 128'h0011; 
      wr_data[1] = 128'h0022; 
      wr_data[2] = 128'h0033; 
      wr_data[3] = 128'h0044; 
      wr_data[4] = 128'h0055; 



      //data = 16'h0;
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst(i*16, wr_data,burst_length, 16'h0001, env.master_agt_1.sqr,1);
         #30ns;
      end
   `uvm_info(get_full_name,"from test after the pipeline write resp of 5",UVM_NONE)
      env.master_agt_1.sqr.get_write_responses(tr, 5, 0);

   `uvm_info(get_full_name,"from test after the pipeline write resp of 1",UVM_NONE)
      env.master_agt_1.sqr.get_single_write_response(t);
   `uvm_info(get_full_name,"from test after the pipeline write resp of all",UVM_NONE)
      env.master_agt_1.sqr.get_all_write_responses_in_fifo(tr, 100);
   `uvm_info(get_full_name,"from test after the pipeline write seq",UVM_NONE)
      foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
      #200ns;


   /*   burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 32'hAA11; 
      wr_data[1] = 32'hBB22; 
      wr_data[2] = 32'hCC33; 
      wr_data[3] = 32'hDD44; 
      wr_data[4] = 32'hEE55; 



      //data = 16'h0;
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst((i+1)*4, wr_data,burst_length, 4'b0011, env.master_agt_2.sqr,2);
         #30ns;
      end
   `uvm_info(get_full_name,"from test after the pipeline write resp of 5",UVM_NONE)
      env.master_agt_2.sqr.get_write_responses(tr, 5, 0);

   `uvm_info(get_full_name,"from test after the pipeline write resp of 1",UVM_NONE)
      env.master_agt_2.sqr.get_single_write_response(t);
   `uvm_info(get_full_name,"from test after the pipeline write resp of all",UVM_NONE)
      env.master_agt_2.sqr.get_all_write_responses_in_fifo(tr, 100);
   `uvm_info(get_full_name,"from test after the pipeline write seq",UVM_NONE)
      foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
      #200ns;
     
      burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 8'hAA; 
      wr_data[1] = 8'hBB; 
      wr_data[2] = 8'hCC; 
      wr_data[3] = 8'hDD; 
      wr_data[4] = 8'hEE; 



      //data = 16'h0;
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst(i+1, wr_data,burst_length, 1'b1, env.master_agt_3.sqr,1);
         #30ns;
      end
   `uvm_info(get_full_name,"from test after the pipeline write resp of 5",UVM_NONE)
      env.master_agt_3.sqr.get_write_responses(tr, 5, 0);

   `uvm_info(get_full_name,"from test after the pipeline write resp of 1",UVM_NONE)
      env.master_agt_3.sqr.get_single_write_response(t);
   `uvm_info(get_full_name,"from test after the pipeline write resp of all",UVM_NONE)
      env.master_agt_3.sqr.get_all_write_responses_in_fifo(tr, 100);
   `uvm_info(get_full_name,"from test after the pipeline write seq",UVM_NONE)
      foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
      #200ns;
*/

   // #50ns;

    //wr_seq.write(32'h0, 8'hAB, 1'b1, resp, env.master_agt_3.sqr, 1);

   
   /*   // pipelined read
      for(int i = 0; i < 16; i++) begin
         pr_seq.read(i*128, env.master_agt[0].sqr, 2);
         #100ns;
      end
   
      #20ns;
      env.master_agt[0].sqr.get_read_responses(tr, 5, 0);
      env.master_agt[0].sqr.get_single_read_response(t);
      env.master_agt[0].sqr.get_all_read_responses_in_fifo(tr, 100);
      foreach (tr[ii]) begin
         for(int j = 0; j < tr[ii].burst_length; j++)
            `uvm_info("TEST", $sformatf("rdata: %0x, rresp: %0d", tr[ii].data[j], tr[ii].rresp[j]), UVM_LOW)
      end
              
      // master 1 to slave 1
   
      for(int i = 0; i < 16; i++) begin
          wr_seq.write((32'h00001000+i), (128'hABBADEADABBADEADABBADEADABBADEAD*i), 16'hFFFF, resp, env.master_agt[1].sqr, 16);
#100ns;
      end
      #1us;
      for(int i = 0; i < 16; i++) begin
         rd_seq.read((32'h00001000+i), rd_data_single, resp, env.master_agt[1].sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
#100ns;
      end
   
      // master 2 write and read to slave 2
      
      #100ns;
      wr_seq.write(32'h3000, 32'hABBADEAD, 4'b1111, resp, env.master_agt[2].sqr, 4);
      rd_seq.read(32'h3000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
      #100ns;
      rd_seq.read(32'h3000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
   
      #100ns;
      wr_seq.write(32'h3004, 32'hABBADEAD, 4'b1111, resp, env.master_agt[2].sqr, 4);
      #100ns;
      rd_seq.read(32'h3004, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
      
   
      // master 2 write and read to slave 4
      #100;
      wr_seq.write(32'h8000, 32'hABBADEAD, 4'b1111, resp, env.master_agt[2].sqr, 4);
      rd_seq.read(32'h8000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
      #100ns;
      rd_seq.read(32'h8000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
      
      // master 2 to slave 5
      #100;
      wr_seq.write(32'h107000, 32'hABBADEAD, 4'b1111, resp, env.master_agt[2].sqr, 4);
      rd_seq.read(32'h107000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
      #100ns; 
      rd_seq.read(32'h107000, rd_data_single, resp, env.master_agt[2].sqr, 1, 32'hABBADEAD, 4);
    
   
      // master 1 to slave 6
      #100;
      wr_seq.write(32'h00109010, 128'hABBADEAD, 16'hFFFF, resp, env.master_agt[0].sqr, 16);
      rd_seq.read(32'h00109010, rd_data_single, resp, env.master_agt[0].sqr, 1, 128'hABBADEAD, 16);
      #100ns;
      rd_seq.read(32'h00109010, rd_data_single, resp, env.master_agt[0].sqr, 1, 128'hABBADEAD, 16);
   
      // burst transfer from master 2 to slave 4 
      burst_length = 5;
      wr_data = new[burst_length];
      rd_data = new[burst_length];
      rresp = new[burst_length];
   
      #1us;
   
      wr_data[0] = 128'hA5A5A5A5ABBADEADABBADEADABBADEAD; 
      wr_data[1] = 128'h11111111ABBADEADABBADEADABBADEAD; 
      wr_data[2] = 128'h22222222ABBADEADABBADEADABBADEAD;
      wr_data[3] = 128'h33333333ABBADEADABBADEADABBADEAD; 
      wr_data[4] = 128'h44444444ABBADEADABBADEADABBADEAD; 
   
      wr_seq.write_burst(32'h00005000, wr_data, 5, 16'hFFFF, bresp, env.master_agt[1].sqr, 16);
      #100;
      rd_seq.read_burst(32'h00005000, rd_data, 5, rresp, env.master_agt[1].sqr, 16);
     */
      #5000ns;
   
      phase.drop_objection (this);
     
   endtask



