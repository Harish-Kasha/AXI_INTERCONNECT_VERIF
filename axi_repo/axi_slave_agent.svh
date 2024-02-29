 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_SLAVE_AGENT_SV
`define AXI_SLAVE_AGENT_SV

class axi_slave_agent #(int D_W= 32,int A_W=32,int ID_W = 10) extends uvm_agent;
  `uvm_component_param_utils(axi_slave_agent # (D_W,A_W,ID_W))
  axi_agent_configuration #(D_W,A_W,ID_W) cfg;
  axi_slave_driver #(D_W,A_W,ID_W) drv;
  axi_monitor #(D_W,A_W,ID_W) mon;
  axi_slave_memory mem;
  uvm_analysis_port #(axi_seq_item) axi_analysis_port;

  
  extern function new(string name, uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern function void reset();
  extern function void restart();

endclass: axi_slave_agent

function axi_slave_agent::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction

function void axi_slave_agent::build_phase(uvm_phase phase);
   string str;
   super.build_phase(phase);

 //  if (!uvm_config_db #(axi_agent_configuration)::get(this, "", "cfg", cfg)) begin
   //   `uvm_fatal(get_full_name (), "Can't get configuration object through config_db")
   //end

   // Check legality of data width configuration
   if ((`AXI_MAX_DW !=  8  ) &&
       (`AXI_MAX_DW != 16  ) &&
       (`AXI_MAX_DW != 32  ) &&
       (`AXI_MAX_DW != 64  ) &&
       (`AXI_MAX_DW != 128 ) &&
       (`AXI_MAX_DW != 256 ) &&
       (`AXI_MAX_DW != 512 ) &&
       (`AXI_MAX_DW != 1024)) begin
      `uvm_fatal(get_full_name (), $sformatf("Invalid datawidth: %0d, check AXI_MAX_DW!", `AXI_MAX_DW))
   end

   if ((cfg.data_width !=  8  ) &&
       (cfg.data_width != 16  ) &&
       (cfg.data_width != 32  ) &&
       (cfg.data_width != 64  ) &&
       (cfg.data_width != 128 ) &&
       (cfg.data_width != 256 ) &&
       (cfg.data_width != 512 ) &&
       (cfg.data_width != 1024)) begin
      `uvm_fatal(get_full_name(), $sformatf("Invalid datawidth: %0d, check cfg.data_width!", cfg.data_width))
   end

   if (cfg.data_width > `AXI_MAX_DW)  begin
      `uvm_fatal(get_full_name(),
                 $sformatf("Data width in config (%0d) should not be bigger than AXI_MAX_DW (%0d) define",
                           cfg.data_width, `AXI_MAX_DW))
   end


   uvm_config_db#(axi_agent_configuration #(D_W,A_W,ID_W))::set(this, "*", "axi_cfg", cfg);

   if (cfg.is_active == UVM_ACTIVE) begin
      drv = axi_slave_driver #(D_W,A_W,ID_W)::type_id::create("drv", this);
      mon = axi_monitor #(D_W,A_W,ID_W)::type_id::create("mon", this);
   end
   else begin
      mon = axi_monitor #(D_W,A_W,ID_W)::type_id::create("mon", this);
   end

   if (cfg.has_memory == 1) begin
      mem = axi_slave_memory::type_id::create("mem", this);
      uvm_config_db #(axi_slave_memory)::set(this,"*","slave_memory", mem);
   end
   
    axi_analysis_port = new("axi_analysis_port", this);

   `uvm_info(get_full_name(), "## AXI4 VIP (Slave) release v1.0 ##", UVM_LOW);

endfunction: build_phase

function void axi_slave_agent::connect_phase(uvm_phase phase);

  if (cfg.has_monitor == 1) begin
     axi_analysis_port = mon.axi_analysis_port;
  end

endfunction

function void axi_slave_agent::reset();
   drv.reset();
endfunction

function void axi_slave_agent::restart();
   drv.restart();
endfunction

`endif // AXI_SLAVE_AGENT_SV

