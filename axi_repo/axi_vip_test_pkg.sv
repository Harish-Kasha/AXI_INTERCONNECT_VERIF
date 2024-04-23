 /********************************************************************
 *******************************************************************/

`ifndef _AXI_VIP_TEST_PKG_
`define _AXI_VIP_TEST_PKG_

package axi_vip_test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //include files
  `include "axi_interconnect_base_test.sv"
  `include "interconnect_extended_test.sv"
  `include "axi_interconnect_reset_test.sv"
  `include "axi_interconnect_narrow_transfer_test.sv"
  `include "axi_interconnect_4k_boundary_test.sv"
  `include "axi_interconnect_reg_slice_test.sv"
  `include "dma_test.sv"

 // `include "example_test_burst.sv"

endpackage: axi_vip_test_pkg

`endif

