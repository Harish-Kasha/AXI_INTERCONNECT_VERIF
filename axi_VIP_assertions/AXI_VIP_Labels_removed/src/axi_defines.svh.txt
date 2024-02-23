 /********************************************************************
 *
 *******************************************************************/

 `ifndef _AXI_DEFINES__SVH
 `define _AXI_DEFINES__SVH

`ifndef AXI_MAX_AW
 `define AXI_MAX_AW 32
`endif

`ifndef AXI_MAX_DW
 `define AXI_MAX_DW 1024
`endif

`ifndef AXI_ID_HEADER_SIZE
 `define AXI_ID_HEADER_SIZE 6
`endif

`ifndef AXI_TRANSACTION_ID_SIZE
 `define AXI_TRANSACTION_ID_SIZE 10
`endif

`ifndef AXI_VIP_MAX_BURST_LENGTH
 `define AXI_VIP_MAX_BURST_LENGTH 16
`endif

`ifndef AXI_VIP_MAX_BURST_LENGTH_INCR
 `define AXI_VIP_MAX_BURST_LENGTH_INCR 256
`endif

`ifndef AXI_PC_MAXWAITS
 `define AXI_PC_MAXWAITS 64
`endif

`endif


