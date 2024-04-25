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
      bit [31:0] arr1[6];
      bit [31:0] arr_address1[6];
      bit [31:0] arr_address2[6];
      bit [31:0] arr_address3[6];
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
      axi_pipeline_write_seq pw_seq,pw_seq1,pw_seq2,pw_seq3;
      axi_pipeline_read_seq  pr_seq,pr_seq1,pr_seq2,pr_seq3;
   
   
      `uvm_info("TRACE"," Interconnect_extended_test is running. Using read and write sequences", UVM_LOW);
      uvm_top.print_topology ();
      phase.raise_objection (this);
   
      rd_seq = axi_master_read_seq::type_id::create("rd_seq");
      wr_seq = axi_master_write_seq::type_id::create("wr_seq");
      pw_seq = axi_pipeline_write_seq::type_id::create("pw_seq");
      pw_seq1 = axi_pipeline_write_seq::type_id::create("pw_seq1");
      pw_seq2 = axi_pipeline_write_seq::type_id::create("pw_seq2");
      pw_seq3 = axi_pipeline_write_seq::type_id::create("pw_seq3");
      pr_seq = axi_pipeline_read_seq::type_id::create("pr_seq");
      pr_seq1 = axi_pipeline_read_seq::type_id::create("pr_seq1");
      pr_seq2 = axi_pipeline_read_seq::type_id::create("pr_seq2");
      pr_seq3 = axi_pipeline_read_seq::type_id::create("pr_seq3");
      
      #50ns;
      // master 0 --> 16 transactions of write and read to slave 0   
     // pipelined write
      burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 16'h0001; 
      wr_data[1] = 16'h0002; 
      wr_data[2] = 16'h0003; 
      wr_data[3] = 16'h0004; 
      wr_data[4] = 16'h0005; 


     
      //data = 16'h0;
   fork
      begin
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst(i*128, wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst(i*128,burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end
      end
      
     begin
       for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq1.write_burst(i*128, wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq1.read_burst(i*128,burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end
     end

     
     begin
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq2.write_burst(i*128, wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq2.read_burst(i*128,burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end
     end
 
     begin     
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq3.write_burst(i*128, wr_data,burst_length, 1'b1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq3.read_burst(i*128,burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end
     end
    join

     // all master to slave 1
      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h2000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h2000+(i*4),burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end
      
       for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h2000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h2000+(i*4),burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end

       for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h2000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h2000+(i*4),burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end

      for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h2000+(i*4), wr_data,burst_length, 1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h2000+(i*4),burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end

// to slave 2

     for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h4000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h4000+(i*4),burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end

       for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h4000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h4000+(i*4),burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end

       for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h4000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h4000+(i*4),burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end

        for(int i = 0; i < 5; i++) begin
         data = data + 1;
         pw_seq.write_burst('h4000+(i*4), wr_data,burst_length, 1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h4000+(i*4),burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end






     //all master to slave 3
          for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h100000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h100000+(i*4),burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end

          for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h100000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h100000+(i*4),burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end


        for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h100000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h100000+(i*4),burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end


         for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h100000+(i*4), wr_data,burst_length, 1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h100000+(i*4),burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end



    // all master to slave s4

     for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h200000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h200000+(i*4),burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end


      for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h200000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h200000+(i*4),burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end

       for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h200000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h200000+(i*4),burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end


       for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h200000+(i*4), wr_data,burst_length, 1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h200000+(i*4),burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end



      // all master to slave 5 
      for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h202000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h202000+(i*4),burst_length,env.master_agt_0.sqr,2);
         #30ns;
      end


       for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h202000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_1.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h202000+(i*4),burst_length,env.master_agt_1.sqr,2);
         #30ns;
      end
     
      for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h202000+(i*4), wr_data,burst_length, 2'b11, env.master_agt_2.sqr,2);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h202000+(i*4),burst_length,env.master_agt_2.sqr,2);
         #30ns;
      end


       for(int i = 0; i < 5; i++) begin
         pw_seq.write_burst('h202000+(i*4), wr_data,burst_length, 1, env.master_agt_3.sqr,1);
         #30ns;
      end

      #10000;
      for(int i = 0; i < 5; i++) begin
         pr_seq.read_burst('h202000+(i*4),burst_length,env.master_agt_3.sqr,1);
         #30ns;
      end


arr1={'h0,'h2000,'h4000,'h100000,'h200000,'h202000};
      burst_length=1;
      //data = 16'h0;
      for(int i = 0; i < 6; i++) begin
        burst_length=burst_length+i;
        `uvm_info(get_type_name,$sformatf("value of burst_length=%0d",burst_length),UVM_LOW)
        wr_data=new[burst_length];
        foreach(wr_data[i])         wr_data[i]=i;
         pw_seq.write_burst(arr1[i], wr_data,burst_length, 2'b11, env.master_agt_0.sqr,2);
         #30ns;
      end
     #1000;
      for(int j=0;j<6;j++)begin
         int burst_length=1;
         burst_length=burst_length+j;
          pr_seq.read_burst(arr1[j], burst_length, env.master_agt_0.sqr,2);
      end
   #1000;
 
     //int arr_address;
 
    arr_address1={'h40,'h2040,'h4040,'h100040,'h200040,'h202040};  
for(int i = 0; i < 6; i++) begin
        int burst_length=1;
        burst_length=burst_length+i;
        `uvm_info(get_type_name,$sformatf("value of burst_length=%0d",burst_length),UVM_LOW)
        wr_data=new[burst_length];
        foreach(wr_data[i])begin
          wr_data[i]=i;
        end
         pw_seq.write_burst(arr_address1[i], wr_data,burst_length, 16'h1111, env.master_agt_1.sqr,16);
         #30ns;
      end
     #1000;
      for(int j=0;j<6;j++)begin
         int burst_length=1;
         $display("value of &&&&&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% =0d ",burst_length);
         burst_length=burst_length+j;
          pr_seq.read_burst(arr_address1[j], burst_length, env.master_agt_1.sqr,4);
      end
   #1000;
 
 
arr_address2={'h80,'h2080,'h4080,'h100080,'h200080,'h202080};
for(int i = 0; i < 6; i++) begin
        int burst_length=1;
        burst_length=burst_length+i;
        `uvm_info(get_type_name,$sformatf("value of burst_length=%0d",burst_length),UVM_LOW)
        wr_data=new[burst_length];
        foreach(wr_data[i])begin
          wr_data[i]=i;
        end
         pw_seq.write_burst(arr_address2[i], wr_data,burst_length, 4'b1111, env.master_agt_2.sqr,4);
         #30ns;
      end
     #1000;
      for(int j=0;j<6;j++)begin
         int burst_length=1;
         burst_length=burst_length+j;
          pr_seq.read_burst(arr_address2[j], burst_length, env.master_agt_2.sqr,4);
      end
#1000;
arr_address3={'h120,'h2120,'h4120,'h100120,'h200120,'h202120};
for(int i = 0; i < 6; i++) begin
        int burst_length=1;
        burst_length=burst_length+i;
        `uvm_info(get_type_name,$sformatf("value of burst_length=%0d",burst_length),UVM_LOW)
        wr_data=new[burst_length];
        foreach(wr_data[i])begin
          wr_data[i]=i;
        end
         pw_seq.write_burst(arr_address3[i], wr_data,burst_length, 'b1, env.master_agt_3.sqr,1);
         #30ns;
      end
     #1000;
      for(int j=0;j<6;j++)begin
         int burst_length=1;
         burst_length=burst_length+j;
          pr_seq.read_burst(arr_address3[j], burst_length, env.master_agt_3.sqr,1);
      end
  #1000;
     







       



/*
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


     /* burst_length = 5;
      wr_data = new[burst_length];   
      wr_data[0] = 'h9AF9AA11; 
      wr_data[1] = 'h9BF9BB22; 
      wr_data[2] = 'h9CF9CC33; 
      wr_data[3] = 'h9DF9DD44; 
      wr_data[4] = 'h9EF9EE55; 

      //wr_data[0] = 128'h0011; 
      //wr_data[1] = 128'h0022; 
      //wr_data[2] = 128'h0033; 
      //wr_data[3] = 128'h0044; 
      //wr_data[4] = 128'h0055; 



      //pw_seq.write_burst( 'h0000, wr_data,burst_length, 'd3, env.master_agt_0.sqr,2);
      //#10000;
      //pr_seq.read_burst('h0000,burst_length, env.master_agt_0.sqr,2);



      pw_seq.write_burst( 'h002000, wr_data,burst_length, 'd3, env.master_agt_0.sqr,2);
      #10000;
      pr_seq.read_burst('h002000, burst_length, env.master_agt_0.sqr,2);
*/


      //for(int i = 0; i < 5; i++) begin
      //   pw_seq.write_burst('h200000+(i*40), wr_data,burst_length, 'd3, env.master_agt_0.sqr,2);
      //   #30ns;
      //end

 //  `uvm_info(get_full_name,"from test after the pipeline write resp of 5",UVM_NONE)
 //     env.master_agt_1.sqr.get_write_responses(tr, 5, 0);

 //  `uvm_info(get_full_name,"from test after the pipeline write resp of 1",UVM_NONE)
 //     env.master_agt_1.sqr.get_single_write_response(t);
 //  `uvm_info(get_full_name,"from test after the pipeline write resp of all",UVM_NONE)
 //     env.master_agt_1.sqr.get_all_write_responses_in_fifo(tr, 100);
 //  `uvm_info(get_full_name,"from test after the pipeline write seq",UVM_NONE)
 //     foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
 //     #200ns;


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




