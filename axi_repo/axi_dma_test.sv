UVM_INFO verilog_src/uvm-1.1d/src/base/uvm_resource_db.svh(121) @ 0: reporter [CFGDB/SET] Configuration 'uvm_test_top.*.dma_cfg' (type class axi_agent_pkg::axi_dma_configuration) set by uvm_test_top = (class axi_agent_pkg::axi_dma_configuration) {dma_cfg} 596 1 613 @uvm_status_container@1 0 0 1 null 4 4 20 0 8192 2 {axi_dma_configuration}
UVM_INFO verilog_src/uvm-1.1d/src/base/uvm_resource_db.svh(121) @ 435000: reporter [CFGDB/GET] Configuration '.dma_cfg' (type class axi_agent_pkg::axi_dma_configuration) read by  = null (failed lookup)
 function poke_1(input string reg_name="a", input int wr_data);
         regmodel.reg_name.poke(status, wr_data);
         des = regmodel.reg_name.get();
         mir = regmodel.reg_name.get_mirrored_value();
         `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
         $display("-----------------------------------------------");

      endfunction


