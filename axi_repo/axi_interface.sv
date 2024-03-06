 /********************************************************************
 *
 * Project     : AXI VIP
 * File        : axi_interface.sv
 * Description : AXI interface
 *
 *
 *******************************************************************/
 
 `timescale 1ps/1ps
 
`ifndef AXI_INTERFACE__SV
`define AXI_INTERFACE__SV

`include "axi_defines.svh"

//IF TYPE :: 0 Master, 1 Slave, 2 Monitor
interface axi_interface #(int DW=32, int AW=32, int ID_W =10,int if_type=0, string inst_name = "axi_interface");

  //FULL AXI4 INTERFACE

  // ---Globals
  logic     aclk;
  logic     aresetn;

  // ---Write address channel signals
  //Master
  logic [ID_W-1:0]    awid;                                              // ID_W defined in the defines.svh 
  logic [AW-1:0] 	 				awaddr;
  logic [7:0]               	awlen;
  logic [2:0] 			 			awsize;
  logic [1:0]                 awburst;
  logic 							   awlock;
  logic [3:0]					   awcache;
  logic [2:0]			 			awprot;
  logic [3:0]			 			awqos;
  logic [3:0]			 			awregion;
  logic 			 				   awuser;
  logic                       awvalid;
  //Slave
  logic                       awready;

  // ---Write data channel signals
  //Master
  logic [DW-1:0] 	 				wdata;
  logic [DW/8-1:0] 	 			wstrb;
  logic                       wlast;
  logic 			 				   wuser;
  logic                       wvalid;
  //Slave
  logic  	                  wready;

  // ---Write response channel signals
  //Master
  logic                       bready;
  //Slave
  logic [ID_W-1:0]	   bid;
  logic [1:0]                 bresp;
  logic 							   buser;
  logic                       bvalid;

  // ---Read address channel signals
  //Master
  logic [ID_W-1:0]	   arid;
  logic [AW-1:0] 	 				araddr;
  logic [7:0] 						arlen;
  logic [2:0] 						arsize;
  logic [1:0] 			 			arburst;
  logic 							   arlock;
  logic [3:0]			 			arcache;
  logic [2:0]						arprot;
  logic [3:0]			 			arqos;
  logic [3:0]			 			arregion;
  logic 			 				   aruser;
  logic 			 				   arvalid;
  //Slave
  logic                       arready;

  // ---Read data channel signals
  //Master
  logic                       rready;
  //Slave
  logic [ID_W-1:0]	   rid;
  logic [DW-1:0] 	 				rdata;
  logic [1:0] 			 			rresp;
  logic                       rlast;
  logic 			 				   ruser;
  logic                       rvalid;

  // ---Low-power interface signals
  logic 			  				   csysreq;
  logic 			  				   csysack;
  logic 			  				   cactive;

   `ifdef AXI4PC
     Axi4PC #(.inst_name(inst_name),
              .DATA_WIDTH(DW),
              .WID_WIDTH(ID_W),
              .RID_WIDTH(ID_W),
              .MAXRBURSTS(ID_W),
              .MAXWBURSTS(ID_W),
              .MAXWAITS(`AXI_PC_MAXWAITS),
              .ADDR_WIDTH(AW)) u_axi4_sva (
       .ACLK (aclk),
       .ARESETn (aresetn),
       .AWID (awid),
       .AWADDR (awaddr),
       .AWLEN (awlen),
       .AWSIZE (awsize),
       .AWBURST (awburst),
       .AWLOCK (1'b0),
       .AWCACHE (4'b0),
       .AWPROT (3'b0),
       .AWQOS (4'b0),
       .AWREGION (4'b0),
       .AWUSER (32'b0),
       .AWVALID (awvalid),
       .AWREADY (awready),
       .WLAST (wlast),
       .WDATA (wdata),
       .WSTRB (wstrb),
       .WUSER (32'b0),
       .WVALID (wvalid),
       .WREADY (wready),
       .BID (bid),
       .BRESP (bresp),
       .BUSER (32'b0),
       .BVALID (bvalid),
       .BREADY (bready),
       .ARID (arid),
       .ARADDR (araddr),
       .ARLEN (arlen),
       .ARSIZE (arsize),
       .ARBURST (arburst),
       .ARLOCK (1'b0),
       .ARCACHE (4'b0),
       .ARPROT (3'b0),
       .ARQOS (4'b0),
       .ARREGION (4'b0),
       .ARUSER (32'b0),
       .ARVALID (arvalid),
       .ARREADY (arready),
       .RID (rid),
       .RLAST (rlast),
       .RDATA (rdata),
       .RRESP (rresp),
       .RUSER (32'b0),
       .RVALID (rvalid),
       .RREADY (rready),
       .CACTIVE (1'b1),
       .CSYSREQ (1'b1),
       .CSYSACK (1'b1)
     );
   `endif

  axi_footprint_interface #(DW,AW,ID_W) max_footprint_if();

  generate
	  //Globals
	  assign max_footprint_if.aresetn = aresetn;
   	  assign max_footprint_if.aclk = aclk;

	// MASTER
    if(if_type == 0) begin : master_gen
       //from slave to master
	   assign max_footprint_if.bid = bid;
	   assign max_footprint_if.rid = rid;
	   assign max_footprint_if.awready = awready;
	   assign max_footprint_if.wready = wready;
	   assign max_footprint_if.bresp = bresp;
	   assign max_footprint_if.bvalid = bvalid;
	   assign max_footprint_if.arready = arready;
	   assign max_footprint_if.rdata = {`AXI_MAX_DW'h0, rdata};
	   assign max_footprint_if.rresp = rresp;
	   assign max_footprint_if.rvalid = rvalid;
	   assign max_footprint_if.rlast = rlast;
	   //TIED
	   assign max_footprint_if.csysack = csysack;
	   assign max_footprint_if.cactive = cactive;
	   assign max_footprint_if.buser = buser;
	   assign max_footprint_if.ruser = ruser;

	   //from master to slave
	   assign awid = max_footprint_if.awid;
	   assign arid = max_footprint_if.arid;
	   assign awaddr = max_footprint_if.awaddr[AW-1:0];
	   assign awvalid = max_footprint_if.awvalid;
	   assign awsize = max_footprint_if.awsize;
	   assign wdata = max_footprint_if.wdata[DW-1:0];
	   assign wstrb = max_footprint_if.wstrb;
	   assign wvalid = max_footprint_if.wvalid;
	   assign bready = max_footprint_if.bready;
	   assign araddr = max_footprint_if.araddr[AW-1:0];
	   assign arvalid = max_footprint_if.arvalid;
	   assign arsize = max_footprint_if.arsize;
	   assign rready = max_footprint_if.rready;
	   assign awlen = max_footprint_if.awlen;
	   assign awburst = max_footprint_if.awburst;
	   assign arlen = max_footprint_if.arlen;
	   assign arburst = max_footprint_if.arburst;
	   assign wlast = max_footprint_if.wlast;
	   //TIED
	   assign csysreq = max_footprint_if.csysreq;
	   assign aruser = max_footprint_if.aruser;
	   assign awuser = max_footprint_if.awuser;
	   assign wuser = max_footprint_if.wuser;
	   assign awlock = max_footprint_if.awlock;
	   assign arlock = max_footprint_if.arlock;
  	   assign awqos = max_footprint_if.awqos;
	   assign awregion = max_footprint_if.awregion;
  	   assign awcache = max_footprint_if.awcache;
  	   assign arqos = max_footprint_if.arqos;
	   assign arregion = max_footprint_if.arregion;
	   assign arcache = max_footprint_if.arcache;
	   assign awprot = max_footprint_if.awprot;
	   assign arprot = max_footprint_if.arprot;

	   // SLAVE
    end else if(if_type == 1) begin : slave_gen
	   //from slave to master
	   assign bid = max_footprint_if.bid;
	   assign rid = max_footprint_if.rid;
	   assign awready = max_footprint_if.awready;
	   assign wready = max_footprint_if.wready;
	   assign bresp = max_footprint_if.bresp;
	   assign bvalid = max_footprint_if.bvalid;
	   assign arready = max_footprint_if.arready;
	   assign rdata = max_footprint_if.rdata[DW-1:0];
	   assign rresp = max_footprint_if.rresp;
	   assign rvalid = max_footprint_if.rvalid;
	   assign rlast = max_footprint_if.rlast;
	   //TIED
	   assign csysack = max_footprint_if.csysack;
	   assign cactive = max_footprint_if.cactive;
	   assign buser = max_footprint_if.buser;
	   assign ruser = max_footprint_if.ruser;

	   //from master to slave
	   assign max_footprint_if.awid = awid;
	   assign max_footprint_if.arid = arid;
	   assign max_footprint_if.awaddr = {`AXI_MAX_AW'h0, awaddr};
	   assign max_footprint_if.awvalid = awvalid;
	   assign max_footprint_if.awsize = awsize;
	   assign max_footprint_if.wdata = {`AXI_MAX_DW'h0, wdata};
	   assign max_footprint_if.wstrb = wstrb;
	   assign max_footprint_if.wvalid = wvalid;
	   assign max_footprint_if.bready = bready;
	   assign max_footprint_if.araddr = {`AXI_MAX_AW'h0, araddr};
	   assign max_footprint_if.arvalid = arvalid;
	   assign max_footprint_if.arsize = arsize;
	   assign max_footprint_if.rready = rready;
	   assign max_footprint_if.awlen = awlen;
	   assign max_footprint_if.awburst = awburst;
	   assign max_footprint_if.arlen = arlen;
	   assign max_footprint_if.arburst = arburst;
	   assign max_footprint_if.wlast = wlast;
	   //TIED
	   assign max_footprint_if.csysreq = csysreq;
	   assign max_footprint_if.aruser = aruser;
	   assign max_footprint_if.awuser = awuser;
	   assign max_footprint_if.wuser = wuser;
	   assign max_footprint_if.awlock = awlock;
	   assign max_footprint_if.arlock = arlock;
  	   assign max_footprint_if.awqos = awqos;
	   assign max_footprint_if.awregion = awregion;
  	   assign max_footprint_if.awcache = awcache;
  	   assign max_footprint_if.arqos = arqos;
	   assign max_footprint_if.arregion = arregion;
	   assign max_footprint_if.arcache = arcache;
	   assign max_footprint_if.awprot = awprot;
	   assign max_footprint_if.arprot = arprot;

	   // MONITOR
    end else if(if_type == 2) begin : mon_gen

	   assign max_footprint_if.bid = bid;
	   assign max_footprint_if.rid = rid;
	   assign max_footprint_if.awready = awready;
	   assign max_footprint_if.wready = wready;
	   assign max_footprint_if.bresp = bresp;
	   assign max_footprint_if.bvalid = bvalid;
	   assign max_footprint_if.arready = arready;
	   assign max_footprint_if.rdata = {`AXI_MAX_DW'h0, rdata};
	   assign max_footprint_if.rresp = rresp;
	   assign max_footprint_if.rvalid = rvalid;
	   assign max_footprint_if.rlast = rlast;
	   assign max_footprint_if.csysack = csysack;
	   assign max_footprint_if.cactive = cactive;
	   assign max_footprint_if.buser = buser;
	   assign max_footprint_if.ruser = ruser;
	   assign max_footprint_if.awid = awid;
	   assign max_footprint_if.arid = arid;
	   assign max_footprint_if.awaddr = {`AXI_MAX_AW'h0, awaddr};
	   assign max_footprint_if.awvalid = awvalid;
	   assign max_footprint_if.awsize = awsize;
	   assign max_footprint_if.wdata = {`AXI_MAX_DW'h0, wdata};
	   assign max_footprint_if.wstrb = wstrb;
	   assign max_footprint_if.wvalid = wvalid;
	   assign max_footprint_if.bready = bready;
	   assign max_footprint_if.araddr = {`AXI_MAX_AW'h0, araddr};
	   assign max_footprint_if.arvalid = arvalid;
	   assign max_footprint_if.arsize = arsize;
	   assign max_footprint_if.rready = rready;
	   assign max_footprint_if.awlen = awlen;
	   assign max_footprint_if.awburst = awburst;
	   assign max_footprint_if.arlen = arlen;
	   assign max_footprint_if.arburst = arburst;
	   assign max_footprint_if.wlast = wlast;
	   assign max_footprint_if.csysreq = csysreq;
	   assign max_footprint_if.aruser = aruser;
	   assign max_footprint_if.awuser = awuser;
	   assign max_footprint_if.wuser = wuser;
	   assign max_footprint_if.awlock = awlock;
	   assign max_footprint_if.arlock = arlock;
  	   assign max_footprint_if.awqos = awqos;
	   assign max_footprint_if.awregion = awregion;
  	   assign max_footprint_if.awcache = awcache;
  	   assign max_footprint_if.arqos = arqos;
	   assign max_footprint_if.arregion = arregion;
	   assign max_footprint_if.arcache = arcache;
	   assign max_footprint_if.awprot = awprot;
	   assign max_footprint_if.arprot = arprot;

    end
  endgenerate

  assign max_footprint_if.dbg_if_type = if_type;

endinterface: axi_interface

`endif

