 /********************************************************************
 *******************************************************************/

class example_test1 extends example_test;
   //example_env env;
   `uvm_component_utils(example_test1)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern task main_phase (uvm_phase phase);

endclass

function example_test1::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction

function void example_test1::build_phase(uvm_phase phase);

   super.build_phase(phase);
   //env = super.env;

endfunction: build_phase

/// \anchor <class_name>_TEST_SPEC
/// ### Test Specification : <br>
task example_test1::main_phase (uvm_phase phase);
  uvm_reg_data_t data;
  bit[31:0] addr;
  logic [1:0] resp;
  uvm_status_e    status;
  axi_master_write_seq wr_seq;
  axi_master_read_seq rd_seq;
  axi_pipeline_write_seq pw_seq;
  axi_pipeline_read_seq pr_seq;
  logic[`AXI_MAX_DW-1:0] wr_data [];
       logic[128-1:0] wdata;
  logic[`AXI_MAX_DW-1:0] wr_data_single [];
  logic[`AXI_MAX_DW-1:0] rd_data [];
  logic[`AXI_MAX_DW-1:0] rd_data_single;
  logic[31:0] reg_data;
  logic[31:0] reg_data1;
  logic[31:0] reg_data2;
  logic[31:0] reg_data3;
	//uvm_reg_data_t rd_data_single;
   logic[1:0] rresp [];
   logic[1:0] bresp;
   int burst_length;
	bit state;
   axi_seq_item tr[];
	axi_seq_item t;

   `uvm_info("TRACE","Example test1 is running. Using read and write sequences in reg accesses", UVM_LOW);
   uvm_top.print_topology ();
   phase.raise_objection (this);

   rd_seq = axi_master_read_seq::type_id::create("rd_seq");
   wr_seq = axi_master_write_seq::type_id::create("wr_seq");
   pw_seq = axi_pipeline_write_seq::type_id::create("pw_seq");
   pr_seq = axi_pipeline_read_seq::type_id::create("pr_seq");
   
   burst_length = 16;
   wr_data = new[burst_length];
   for(int i = 0; i < 16; i++) begin
      wr_data[i] = 128'hA5A5A5A5ABBADEADABBADEADABBADEAD;
   end
   
   // pipelined write
   data = 128'h0;
   for(int i = 0; i < 16; i++) begin
      //pw_seq.write_burst(32'h70000000, wr_data, 16, 16'hFFFF, env.u_axi_master_agt.sqr, 16);
      data = data + 1;
      pw_seq.write(i*128, data, 16'hFFFF, env.u_axi_master_agt.sqr, 16);
   end
   //#2us;
   env.u_axi_master_agt.sqr.get_write_responses(tr, 5, 0);
   env.u_axi_master_agt.sqr.get_single_write_response(t);
   env.u_axi_master_agt.sqr.get_all_write_responses_in_fifo(tr, 100);
   foreach (tr[ii]) `uvm_info("TEST", $sformatf("bresp: %0d", tr[ii].bresp), UVM_LOW)
	#2us;
   // pipelined read
   for(int i = 0; i < 16; i++) begin
      //pr_seq.read_burst(32'h70000000, 16, env.u_axi_master_agt.sqr, 16);
      pr_seq.read(i*128, env.u_axi_master_agt.sqr, 16);
   end
   //#2us;
   env.u_axi_master_agt.sqr.get_read_responses(tr, 5, 0);
   env.u_axi_master_agt.sqr.get_single_read_response(t);
   env.u_axi_master_agt.sqr.get_all_read_responses_in_fifo(tr, 100);
   foreach (tr[ii]) begin
      for(int j = 0; j < tr[ii].burst_length; j++)
         `uvm_info("TEST", $sformatf("rdata: %0x, rresp: %0d", tr[ii].data[j], tr[ii].rresp[j]), UVM_LOW)
   end
   #5us;
	rd_seq.read(32'hC03898C0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);  
   rd_seq.read(32'hC03899B0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
	#1us;
   rd_seq.read(32'hC03898C0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);  
   #1us;
   rd_seq.read(32'hC03899B0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
	#2us;   
   wr_seq.write(32'hCAFEBABE, 128'hABBADEADABBADEADABBADEADABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   rd_seq.read(32'hCAFEBABE, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
   #30000;
            
   for(int i = 0; i < 16; i++) begin
       wr_seq.write(32'h10000000, 128'hABBADEADABBADEADABBADEADABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   end
   #1us;
   for(int i = 0; i < 16; i++) begin
      rd_seq.read(32'h10000000, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
   end

   #100ns;
   wr_seq.write(32'h0, 32'hABBADEAD, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read(32'h0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
   #100ns;
   wr_seq.write(32'h4, 32'hABBADEAD, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read(32'h4, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
   #100ns;
   wr_seq.write(32'h8, 32'hABBADEAD, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read(32'h8, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
   #100ns;
   wr_seq.write(32'hC, 32'hABBADEAD, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read(32'hC, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
   #100ns;
   wr_seq.write(32'h0, 128'hABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   rd_seq.read(32'h0, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEAD, 16);
   #100ns;
   wr_seq.write(32'h4, 128'hABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   rd_seq.read(32'h4, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEAD, 16);
   #100ns;
   wr_seq.write(32'h8, 128'hABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   rd_seq.read(32'h8, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEAD, 16);
   #100ns;
   wr_seq.write(32'hC, 128'hABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
   rd_seq.read(32'hC, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEAD, 16);

   
   for(int i = 0; i < 50; i++) begin
      //p_seq.write(32'h10000000, 128'hABBADEADABBADEADABBADEADABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
      wr_seq.write(32'h10000000, 128'hABBADEADABBADEADABBADEADABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
      //rd_seq.read(32'h10000000, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
   end
   for(int i = 0; i < 50; i++) begin
      //wr_seq.write(32'h10000000, 128'hABBADEADABBADEADABBADEADABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);
      rd_seq.read(32'h10000000, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 128'hABBADEADABBADEADABBADEADABBADEAD, 16);
   end
   

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

   //wr_seq.write_burst(32'h70000000, wr_data, 5, 16'hFFFF, bresp, env.u_axi_master_agt.sqr, 16);
   //rd_seq.read_burst(32'h70000000, rd_data, 5, rresp, env.u_axi_master_agt.sqr, 16);

   `uvm_info("TEST", "32b read write read on 128b channel (4 lowest bytes valid)", UVM_LOW)
	rd_seq.read(32'h200, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'h0, 4);
	wr_seq.write(32'h200, 128'hABBADEAD, 16'h000F, resp, env.u_axi_master_agt.sqr, 16);
	rd_seq.read(32'h200, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
   
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e4716e, 128'hfa3e4cbdc82cfe6bd6cfcc72754d815a, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e4717e, 128'hc375d236d9ce9f8b7bd0ed15e642fbd0, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e4718e, 128'hb85665bfd723aef51083c16fc8efbf01, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e4719e, 128'hc18c2a71c5a0ac76be822c070cd48964, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e471ae, 128'h6df0425bbc1e48dc38d481b3b6c8576c, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e471be, 128'h4ffd28b5a2181af54b1e7402ecb326a1, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e471ce, 128'hae983b88b383b2f646cdb777d05ebb6b, 16);
   env.u_axi_slave_agt.mem.backdoor_write(32'hf6e471de, 128'h1bda1d0c351effce96a4300f57a3, 16);
   
   rd_seq.read(32'hf6e47160, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e47170, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e47180, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e47190, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e471a0, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e471b0, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   rd_seq.read(32'hf6e471c0, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 128'h0, 16);
   `uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   

   wr_seq.write(32'h800, 32'hABBADEAD, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
	wr_seq.write(32'h804, 32'hCAFEBABE, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
	wr_seq.write(32'h808, 32'hABCD1234, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);
	//wr_seq.write(32'h80C, 32'h12345678, 4'b1111, resp, env.u_axi_master_agt.sqr, 4);

	rd_seq.read(32'h800, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABBADEAD, 4);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
	rd_seq.read(32'h804, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hCAFEBABE, 4);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
	rd_seq.read(32'h808, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'hABCD1234, 4);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
	rd_seq.read(32'h80C, rd_data_single, resp, env.u_axi_master_agt.sqr, 1, 32'h12345678, 4);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   
   this.env.u_reg_block.A0.write(.status(status), .value(32'hABBADEAD));
   this.env.u_reg_block.A1.write(.status(status), .value(32'hCAFEBABE));
   this.env.u_reg_block.A2.write(.status(status), .value(32'hABCD1234));
   //this.env.u_reg_block.A3.write(.status(status), .value(32'h12345678));

   this.env.u_reg_block.A0.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A1.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A2.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A3.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)

   field_write("A0.a0_f", 32'hABBADEAD);
   field_write("A1.a1_f", 32'hCAFEBABE);
   field_write("A2.a2_f", 32'hABCD1234);
   //field_write("A3.a3_f", 32'h12345678);
   this.env.u_reg_block.A0.a0_f.write(.status(status), .value(32'hABBADEAD));
   this.env.u_reg_block.A1.a1_f.write(.status(status), .value(32'hCAFEBABE));
   this.env.u_reg_block.A2.a2_f.write(.status(status), .value(32'hABCD1234));
   //this.env.u_reg_block.A3.a3_f.write(.status(status), .value(32'h12345678));

   this.env.u_reg_block.A0.a0_f.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A1.a1_f.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A2.a2_f.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)
   this.env.u_reg_block.A3.a3_f.read(status, rd_data_single);
	`uvm_info("TEST", $sformatf("single read data: %0x", rd_data_single), UVM_LOW)

   this.env.u_reg_block.REG2.read(status, data);

   /// RAL convenience function usage example: Write, read and check.
   reg_write("REG2", 32'hAABBCCDD);
   reg_read("REG2", data, 32'h123476);

   /// RAL convenience function usage example: Write field (uses byte enables), read and check.
   field_write("REG2.reg2_field1", 16'h5678);
   field_read("REG2.reg2_field1", data, 16'h5678);

   #30000;

   for (int k = 0; k < burst_length; k++) begin
      wr_seq.write_burst(32'h70000000, wr_data, 5, 4'b1111, bresp, env.u_axi_master_agt.sqr, 16);
	   rd_seq.read_burst(32'h70000000, rd_data, 5, rresp, env.u_axi_master_agt.sqr, 16);
   end

 	#30000;

   rd_seq.read_burst(32'h70000000, rd_data, 15, rresp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read_burst(32'h70000000, rd_data, 15, rresp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read_burst(32'h70000000, rd_data, 15, rresp, env.u_axi_master_agt.sqr, 4);
   rd_seq.read_burst(32'h70000000, rd_data, 8, rresp, env.u_axi_master_agt.sqr, 4);

   #30000;

	rd_seq.read(32'h12345678, rd_data_single, resp, env.u_axi_master_agt.sqr, 0, 0, 16);
	wr_seq.write(32'h12345678, 128'hABBADEAD, 16'hFFFF, resp, env.u_axi_master_agt.sqr, 16);

   #30000;

   phase.drop_objection (this);
  
endtask



