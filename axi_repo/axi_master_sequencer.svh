/********************************************************************
 *
 *******************************************************************/

`timescale 1ps/1ps;

class axi_master_sequencer #(int D_W= 32,int A_W=32,int ID_W = 10) extends uvm_sequencer #(axi_seq_item);

	`uvm_component_param_utils(axi_master_sequencer #(D_W,A_W,ID_W))

	axi_agent_configuration #(D_W,A_W,ID_W) cfg;

	uvm_analysis_export #(axi_seq_item) inbound_write_transactions;
	uvm_analysis_export #(axi_seq_item) inbound_read_transactions;
	uvm_tlm_analysis_fifo #(axi_seq_item) write_rsp_fifo;
	uvm_tlm_analysis_fifo #(axi_seq_item) read_rsp_fifo;

	extern function new (string name="", uvm_component parent = null);
	extern function void connect_phase(uvm_phase phase);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task verify_response(axi_seq_item tr);

	extern task get_write_responses(inout axi_seq_item tr[], input int response_count, input int timeout_in_us = 1);
	extern task get_read_responses(inout axi_seq_item tr[], input int response_count, input int timeout_in_us = 1);
	extern task get_all_write_responses_in_fifo(inout axi_seq_item tr[], input int timeout_in_us = 1);
	extern task get_single_write_response(inout axi_seq_item tr, input int timeout_in_us = 1);
	extern task get_all_read_responses_in_fifo(inout axi_seq_item tr[], input int timeout_in_us = 1);
	extern task get_single_read_response(inout axi_seq_item tr, input int timeout_in_us = 1);


endclass : axi_master_sequencer

function axi_master_sequencer::new (string name="", uvm_component parent = null);
	super.new(name, parent);

	write_rsp_fifo = new("write_rsp_fifo", this);
	read_rsp_fifo = new("read_rsp_fifo", this);
	inbound_write_transactions = new("inbound_write_transactions", this);
	inbound_read_transactions = new("inbound_read_transactions", this);

endfunction : new

task axi_master_sequencer::run_phase(uvm_phase phase);
	super.run_phase(phase);

endtask : run_phase

function void axi_master_sequencer::build_phase(uvm_phase phase);
	super.build_phase (phase);

	if (!uvm_config_db#(axi_agent_configuration #(D_W,A_W,ID_W))::get(this, "", "axi_cfg", cfg)) begin
		`uvm_fatal(get_type_name(), "Can't get configuration object through config_db")
	end

endfunction : build_phase

function void axi_master_sequencer::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	inbound_write_transactions.connect(write_rsp_fifo.analysis_export);
	inbound_read_transactions.connect(read_rsp_fifo.analysis_export);

endfunction // connect_phase

task axi_master_sequencer:: verify_response(axi_seq_item tr);
	if(tr.op_type == AXI_WRITE) begin
		if(tr.bresp != 0) begin
			`uvm_error("AXI_SQR", $sformatf("Error occurred in AXI WRITE packet: ID: %0d, bresp: %b", tr.id, tr.bresp))
		end
	end else begin
		for(int i = 0; i < tr.burst_length; i++) begin
			if(tr.rresp[i] != 0) begin
				`uvm_error("AXI_SQR", $sformatf("Error occurred in AXI READ packet: ID: %0d, rresp: %b, burst instance: %0d", tr.id, tr.bresp, i))
			end
		end
	end
endtask : verify_response

// read tasks

task axi_master_sequencer:: get_read_responses(inout axi_seq_item tr[], input int response_count, input int timeout_in_us = 1);
	automatic int ii = 0;
	tr = new[response_count];
	fork
		begin
			fork
				begin
					for(ii = 0; ii < response_count; ii++) begin
						read_rsp_fifo.get(tr[ii]);
						verify_response(tr[ii]);
					end
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_read_responses

task axi_master_sequencer:: get_single_read_response(inout axi_seq_item tr, input int timeout_in_us = 1);
	fork
		begin
			fork
				begin
					read_rsp_fifo.get(tr);
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_single_read_response

task axi_master_sequencer:: get_all_read_responses_in_fifo(inout axi_seq_item tr[], input int timeout_in_us = 1);
	automatic int ii = 0;
	tr = new[read_rsp_fifo.size()];
	fork
		begin
			fork
				begin
					for(ii = 0; ii < read_rsp_fifo.size(); ii++) begin
						read_rsp_fifo.get(tr[ii]);
						verify_response(tr[ii]);
					end
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_all_read_responses_in_fifo

// write tasks

task axi_master_sequencer:: get_write_responses(inout axi_seq_item tr[], input int response_count, input int timeout_in_us = 1);
	automatic int ii = 0;
	tr = new[response_count];
	fork
		begin
			fork
				begin
					for(ii = 0; ii < response_count; ii++) begin
						write_rsp_fifo.get(tr[ii]);
						verify_response(tr[ii]);
					end
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_write_responses

task axi_master_sequencer::get_single_write_response(inout axi_seq_item tr, input int timeout_in_us = 1);
	fork
		begin
			fork
				begin
					write_rsp_fifo.get(tr);
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_single_write_response

task axi_master_sequencer:: get_all_write_responses_in_fifo(inout axi_seq_item tr[], input int timeout_in_us = 1);
	automatic int ii = 0;
	tr = new[write_rsp_fifo.size()];
	fork
		begin
			fork
				begin
					for(ii = 0; ii < write_rsp_fifo.size(); ii++) begin
						write_rsp_fifo.get(tr[ii]);
						verify_response(tr[ii]);
					end
				end
				begin
					#(timeout_in_us * 1e6);
				end
			join_any
			disable fork;
		end
	join
endtask : get_all_write_responses_in_fifo

