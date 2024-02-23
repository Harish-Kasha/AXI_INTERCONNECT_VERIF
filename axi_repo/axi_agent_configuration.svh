 /********************************************************************
 *
 * Project     : AXI VIP
 * File        : axi_agent_configuration.svh
 * Description : AXI agent configuration file
 *
 *
 *******************************************************************/

class axi_agent_configuration extends uvm_object;
   `uvm_object_utils(axi_agent_configuration)
   uvm_active_passive_enum is_active = UVM_ACTIVE;
   virtual axi_footprint_interface axi_vif;

   bit master   = 1;
   int master_i = 0;
   int slave_i  = 0;
  // int masters[NO_M];
  // int slaves [NO_S]; 
	//Enable/disable if pipelining is wanted (does not work with AXI4 LITE!)
	bit has_pipelining = 1;
   // Define max num of open requests
   int max_write_requests = 16;
   int max_read_requests = 16;
   //If pipelining, keeps simulation alive
   bit wait_all_data = 1;
   
   // Define data width
   int data_width = 32;

   // If agent has driver, it is advised to include the monitor also
   bit has_driver = 1;
   bit has_monitor = 1;
   
   // Slave has internal memory i.e. works as memory component
   bit has_memory = 1;
	// Set any address here if you want the slave to produce SLVERR when accessing this address
	bit enable_addr_to_cause_error = 0;
	bit [`AXI_MAX_AW-1:0] addr_to_cause_error = 32'hCAFEBABE;
   // Setting this bit passive agent (i.e. monitor) writes transactions to memory component
   bit active_monitor = 0;
   // Monitor does performance reporting
   bit has_perf_analysis = 0;
   // When 1, AW channel is executed before W channel (this reduces write channel performance by 2x), 
   // When 0, AW and W are executed in parallel (performance in par with read channel)
   bit aw_before_w_channel = 0;
   
   int num_timeout_cycles = 300;

   string log_verbosity = "medium"; ///< "low", "medium" or "high"
   bit memory_debug_verbosity = 0;
   bit bresp_error = 1; ///< bresp monitoring log severity control
   bit rresp_error = 1; ///< rresp monitoring log severity control

   //If using AXI4 LITE protocol, set this bit to '0
   bit last_signaling_used = 1; 

   bit fast_mode= 0; ///< when 1, no timing randomization. fast accesses
   
   //Master identifier ID - Not used 
   int id = 0; 
   
   // Monitor print mode
   int monitor_print_tr_in_state = 0; 
   
   // For internal use mainly
   bit clean_data_for_printing = 0;
   bit enable_debug_messages = 0;
   
   extern function new(string name = "axi_agent_configuration");

endclass: axi_agent_configuration

function axi_agent_configuration::new(string name = "axi_agent_configuration");
   super.new(name);
endfunction

