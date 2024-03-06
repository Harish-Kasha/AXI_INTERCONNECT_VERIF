 /********************************************************************
 *
 *******************************************************************/

module axi_interface_bind #(parameter DW = 32, parameter AW = 32, parameter ID_SIZE, parameter if_type = 0)  
  ( input          CLK,
    input          RSTN,

    output         ARVALID,
    input          ARREADY,
    output [AW-1:0]  ARADDR,
    output [2:0]   ARSIZE,
    
    input          RVALID,
    output         RREADY,
    input [DW-1:0]  RDATA,
    input [1:0]    RRESP,
    
    output         AWVALID,
    input          AWREADY,
    output [AW-1:0]  AWADDR,
    output [2:0]   AWSIZE,
    
    output         WVALID,
    input          WREADY,
    output [15:0]  WSTRB,
    output [DW-1:0] WDATA,
    
    input          BVALID,
    output         BREADY,
    input [1:0]    BRESP,

    output [3:0]   AWLEN,
    output [1:0]   AWBURST,
    output [3:0]   ARLEN,
    output [1:0]   ARBURST,
    output         WLAST,
    input          RLAST,
    
    output [ID_SIZE-1:0] AWID,
    output [ID_SIZE-1:0] ARID,
    input [ID_SIZE-1:0] BID,
    input [ID_SIZE-1:0] RID
    );
  
  axi_interface #(DW, AW, if_type) axi_if();

  //  IF mapping
  assign axi_if.aclk = CLK;
  assign axi_if.aresetn = RSTN;
  assign AWADDR = axi_if.awaddr;
  assign AWVALID = axi_if.awvalid;
  assign AWSIZE = axi_if.awsize;
  assign axi_if.awready = AWREADY;
  assign WDATA = axi_if.wdata;
  assign WSTRB = axi_if.wstrb;
  assign WVALID = axi_if.wvalid;
  assign axi_if.wready = WREADY;
  assign axi_if.bresp = BRESP;
  assign axi_if.bvalid = BVALID;
  assign BREADY = axi_if.bready ;
  assign ARADDR = axi_if.araddr ;
  assign ARVALID = axi_if.arvalid;
  assign ARSIZE = axi_if.arsize;
  assign axi_if.arready = ARREADY;
  assign axi_if.rdata = RDATA;
  assign axi_if.rresp = RRESP;
  assign axi_if.rvalid = RVALID;
  assign RREADY = axi_if.rready;
  assign AWID = axi_if.awid;
  assign ARID = axi_if.arid;
  assign axi_if.bid = BID;
  assign axi_if.rid = RID;
  assign AWLEN = axi_if.awlen;
  assign AWBURST = axi_if.awburst;
  assign ARLEN = axi_if.arlen;
  assign ARBURST = axi_if.arburst;
  assign WLAST = axi_if.wlast;
  assign axi_if.rlast = RLAST;
  
  // Default drivers for outputs
  assign AWADDR = 32'hzzzzzzzz;
  assign AWVALID = 1'bz;
  assign AWSIZE = 3'bzzz;
  assign WDATA = 128'hzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  assign WSTRB = 16'hzzzz;
  assign WVALID = 1'bz;
  assign BREADY = 1'bz;
  assign ARADDR = 32'hzzzzzzzz;
  assign ARVALID = 1'bz;
  assign ARSIZE = 3'bzzz;
  assign RREADY = 1'bz;
  assign AWID = 'bz;
  assign ARID = 'bz; 
  assign AWLEN = 4'bzzzz;
  assign AWBURST = 2'bzz;
  assign ARLEN = 4'bzzzz;
  assign ARBURST = 2'bzz;
  assign WLAST = 1'bz;
   
endmodule : axi_interface_bind

