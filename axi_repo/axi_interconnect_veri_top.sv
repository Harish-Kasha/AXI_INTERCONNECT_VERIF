/////////////////////////////////////////////////////////////////////////////////////////////////////////
// File name : axi_interconnect_top.sv
// 
/////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

// importing package and includine the necessary files
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_common.svh"
`include "axi_parameter_pkg.sv"
`include "axi_vip_test_pkg.sv"
 module axi_interconnect_top();

   import axi_vip_test_pkg::*;
   import axi_parameter_pkg::*;

   // global signals : clock and reset signals
   bit aclk;
   bit aresetn;                                           

   //axi_interface #(data_width,addr_width,master/slave,"instance name");
   axi_interface#(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0],0,"axi_master_if_0") u_axi_master_if_0();  
   axi_interface#(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1],0,"axi_master_if_1") u_axi_master_if_1();
   axi_interface#(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2],0,"axi_master_if_2") u_axi_master_if_2();
   axi_interface#(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3],0,"axi_master_if_3") u_axi_master_if_3();
                                        
   axi_interface#(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH, 1, "axi_slave_if_0")  u_axi_slave_if_0();
   axi_interface#(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH, 1, "axi_slave_if_1")  u_axi_slave_if_1();
   axi_interface#(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH, 1, "axi_slave_if_2")  u_axi_slave_if_2();
   axi_interface#(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH, 1, "axi_slave_if_3")  u_axi_slave_if_3();
   axi_interface#(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH, 1, "axi_slave_if_4")  u_axi_slave_if_4();
   axi_interface#(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH, 1, "axi_slave_if_5")  u_axi_slave_if_5();
   

  // clock generation
   always #(CP/2) aclk = ~aclk;
     
   // Reset and set
   initial begin
      aresetn = 1'b0;
      aclk    = 1'b0;
      repeat(5) @(posedge aclk);
      aresetn = 1'b1;
   end

   
   // setting the interface for all the agents
   initial begin
       
        uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]))::set(null, "uvm_test_top","axi_master_vif_0", u_axi_master_if_0.max_footprint_if);
        uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]))::set(null, "uvm_test_top","axi_master_vif_1", u_axi_master_if_1.max_footprint_if);
        uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]))::set(null, "uvm_test_top","axi_master_vif_2", u_axi_master_if_2.max_footprint_if);
        uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]))::set(null, "uvm_test_top","axi_master_vif_3", u_axi_master_if_3.max_footprint_if);
   	
        uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_0", u_axi_slave_if_0.max_footprint_if);
    	uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_1", u_axi_slave_if_1.max_footprint_if);
    	uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_2", u_axi_slave_if_2.max_footprint_if);
    	uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_3", u_axi_slave_if_3.max_footprint_if);
    	uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_4", u_axi_slave_if_4.max_footprint_if);
    	uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH))::set(null, "uvm_test_top", "axi_slave_vif_5", u_axi_slave_if_5.max_footprint_if);
     // initial uvm_config_db #(virtual axi_footprint_interface)::set(null, "*",$sformatf( "axi_slave_vif_%0d",j), u_axi_slave_if_j.max_footprint_if);

   end
  //  contionous assignment of clock and reset to respective interfaces
         
   assign u_axi_master_if_0.aresetn = aresetn;
   assign u_axi_master_if_0.aclk    = aclk;

   assign u_axi_master_if_1.aresetn = aresetn;
   assign u_axi_master_if_1.aclk    = aclk;

   assign u_axi_master_if_2.aresetn = aresetn;
   assign u_axi_master_if_2.aclk    = aclk;

   assign u_axi_master_if_3.aresetn = aresetn;
   assign u_axi_master_if_3.aclk    = aclk;


   assign u_axi_slave_if_0.aresetn = aresetn;
   assign u_axi_slave_if_0.aclk    = aclk;
   
   assign u_axi_slave_if_1.aresetn = aresetn;
   assign u_axi_slave_if_1.aclk    = aclk;
   
   assign u_axi_slave_if_2.aresetn = aresetn;
   assign u_axi_slave_if_2.aclk    = aclk;
  
   assign u_axi_slave_if_3.aresetn = aresetn;
   assign u_axi_slave_if_3.aclk    = aclk;

   assign u_axi_slave_if_4.aresetn = aresetn;
   assign u_axi_slave_if_4.aclk    = aclk;

   assign u_axi_slave_if_5.aresetn = aresetn;
   assign u_axi_slave_if_5.aclk    = aclk;



   axi_interconnect_wrapper #(.S_COUNT(NO_M),
                              .M_COUNT(NO_S),
                              .S_R_D_WIDTH(M_DATA_W),
                              .S_W_D_WIDTH(M_DATA_W),
                              .M_R_D_WIDTH(S_DATA_W),
                              .M_W_D_WIDTH(S_DATA_W),
                              .S_A_WIDTH(M_ADDR_W),
                              .M_A_WIDTH(S_ADDR_W),
                              .S_STRB_WIDTH(M_STRB_WIDTH),
                              .M_STRB_WIDTH(S_STRB_WIDTH),
                              .S_ID_WIDTH(M_ID_WIDTH),
                              .M_ID_WIDTH(S_ID_WIDTH),
                              .SUM_S_ID_WIDTH(SUM_M_ID_WIDTH),
                              .SUM_S_R_D_WIDTH(SUM_M_DATA_W),
                              .SUM_S_W_D_WIDTH(SUM_M_DATA_W),
                              .SUM_M_R_D_WIDTH(SUM_S_DATA_W),
                              .SUM_M_W_D_WIDTH(SUM_S_DATA_W),
                              .SUM_M_A_WIDTH(SUM_S_ADDR_W),
			      .SUM_M_STRB_WIDTH(SUM_S_STRB_W),
			      .SUM_S_STRB_WIDTH(SUM_M_STRB_W),
                              .MAX_S_ID_WIDTH(MAX_M_ID_WIDTH),
                              .MAX_M_A_WIDTH(MAX_S_ADDR_WIDTH),
		              .COUPLER_REG_INSTANCE('d0))
                           dut1 (.clk             (aclk             ),             
                                 .rst             (!aresetn          ),         
                                 .s_axi_awid      ({u_axi_master_if_3.awid,    1'b0,    u_axi_master_if_1.awid,    u_axi_master_if_0.awid}      ),
                                 .s_axi_awaddr    ({u_axi_master_if_3.awaddr,  u_axi_master_if_2.awaddr,  u_axi_master_if_1.awaddr, u_axi_master_if_0.awaddr}    ),
                                 .s_axi_awlen     ({u_axi_master_if_3.awlen,   u_axi_master_if_2.awlen,   u_axi_master_if_1.awlen,   u_axi_master_if_0.awlen}     ),
                                 .s_axi_awsize    ({u_axi_master_if_3.awsize,  {1'b0,u_axi_master_if_2.awsize[1:0]},  u_axi_master_if_1.awsize,  u_axi_master_if_0.awsize}    ),
                                 .s_axi_awburst   ({u_axi_master_if_3.awburst, 'd1, u_axi_master_if_1.awburst, u_axi_master_if_0.awburst}   ),
                                 .s_axi_awlock    ({u_axi_master_if_3.awlock,  u_axi_master_if_2.awlock,  u_axi_master_if_1.awlock,  u_axi_master_if_0.awlock}    ),
                                 .s_axi_awcache   ({u_axi_master_if_3.awcache, u_axi_master_if_2.awcache, u_axi_master_if_1.awcache, u_axi_master_if_0.awcache}   ),
                                 .s_axi_awprot    ({u_axi_master_if_3.awprot,  u_axi_master_if_2.awprot,  u_axi_master_if_1.awprot,  u_axi_master_if_0.awprot}    ),
                                 .s_axi_awqos     ({u_axi_master_if_3.awqos,   u_axi_master_if_2.awqos,   u_axi_master_if_1.awqos,   u_axi_master_if_0.awqos}     ),
                                 .s_axi_awuser    ({u_axi_master_if_3.awuser,  u_axi_master_if_2.awuser,  u_axi_master_if_1.awuser,  u_axi_master_if_0.awuser}    ),
                                 .s_axi_awvalid   ({u_axi_master_if_3.awvalid, u_axi_master_if_2.awvalid, u_axi_master_if_1.awvalid, u_axi_master_if_0.awvalid}   ),
                                 .s_axi_awready   ({u_axi_master_if_3.awready, u_axi_master_if_2.awready, u_axi_master_if_1.awready, u_axi_master_if_0.awready}   ),
                                 .s_axi_wdata     ({u_axi_master_if_3.wdata,   u_axi_master_if_2.wdata,   u_axi_master_if_1.wdata,   u_axi_master_if_0.wdata}     ),
                                 .s_axi_wstrb     ({u_axi_master_if_3.wstrb,   u_axi_master_if_2.wstrb,   u_axi_master_if_1.wstrb,   u_axi_master_if_0.wstrb}     ),
                                 .s_axi_wlast     ({u_axi_master_if_3.wlast,   u_axi_master_if_2.wlast,   u_axi_master_if_1.wlast,   u_axi_master_if_0.wlast}     ),
                                 .s_axi_wuser     ({u_axi_master_if_3.wuser,   u_axi_master_if_2.wuser,   u_axi_master_if_1.wuser,   u_axi_master_if_0.wuser}     ),
                                 .s_axi_wvalid    ({u_axi_master_if_3.wvalid,  u_axi_master_if_2.wvalid,  u_axi_master_if_1.wvalid,  u_axi_master_if_0.wvalid}    ),
                                 .s_axi_wready    ({u_axi_master_if_3.wready,  u_axi_master_if_2.wready,  u_axi_master_if_1.wready,  u_axi_master_if_0.wready}    ),
                                 .s_axi_bid       ({u_axi_master_if_3.bid,     u_axi_master_if_2.bid,     u_axi_master_if_1.bid,     u_axi_master_if_0.bid}       ),
                                 .s_axi_bresp     ({u_axi_master_if_3.bresp,   u_axi_master_if_2.bresp,   u_axi_master_if_1.bresp,   u_axi_master_if_0.bresp}     ),
                                 .s_axi_buser     ({u_axi_master_if_3.buser,   u_axi_master_if_2.buser,   u_axi_master_if_1.buser,   u_axi_master_if_0.buser}     ),
                                 .s_axi_bvalid    ({u_axi_master_if_3.bvalid,  u_axi_master_if_2.bvalid,  u_axi_master_if_1.bvalid,  u_axi_master_if_0.bvalid}    ),
                                 .s_axi_bready    ({u_axi_master_if_3.bready,  u_axi_master_if_2.bready,  u_axi_master_if_1.bready,  u_axi_master_if_0.bready}    ),
                                 .s_axi_arid      ({u_axi_master_if_3.arid,    'd0,    u_axi_master_if_1.arid,    u_axi_master_if_0.arid}      ),
                                 .s_axi_araddr    ({u_axi_master_if_3.araddr,  u_axi_master_if_2.araddr,  u_axi_master_if_1.araddr,  u_axi_master_if_0.araddr}    ),
                                 .s_axi_arlen     ({u_axi_master_if_3.arlen,   u_axi_master_if_2.arlen,   u_axi_master_if_1.arlen,   u_axi_master_if_0.arlen}     ),
                                 .s_axi_arsize    ({u_axi_master_if_3.arsize,  {1'b0,u_axi_master_if_2.arsize[1:0]},  u_axi_master_if_1.arsize,  u_axi_master_if_0.arsize}    ),
                                 .s_axi_arburst   ({u_axi_master_if_3.arburst, 'd1, u_axi_master_if_1.arburst, u_axi_master_if_0.arburst}   ),
                                 .s_axi_arlock    ({u_axi_master_if_3.arlock,  u_axi_master_if_2.arlock,  u_axi_master_if_1.arlock,  u_axi_master_if_0.arlock}    ),
                                 .s_axi_arcache   ({u_axi_master_if_3.arcache, u_axi_master_if_2.arcache, u_axi_master_if_1.arcache, u_axi_master_if_0.arcache}   ),
                                 .s_axi_arprot    ({u_axi_master_if_3.arprot,  u_axi_master_if_2.arprot,  u_axi_master_if_1.arprot,  u_axi_master_if_0.arprot}    ),
                                 .s_axi_arqos     ({u_axi_master_if_3.arqos,   u_axi_master_if_2.arqos,   u_axi_master_if_1.arqos,   u_axi_master_if_0.arqos}     ),
                                 .s_axi_aruser    ({u_axi_master_if_3.aruser,  u_axi_master_if_2.aruser,  u_axi_master_if_1.aruser,  u_axi_master_if_0.aruser}    ),
                                 .s_axi_arvalid   ({u_axi_master_if_3.arvalid, u_axi_master_if_2.arvalid, u_axi_master_if_1.arvalid, u_axi_master_if_0.arvalid}   ),
                                 .s_axi_arready   ({u_axi_master_if_3.arready, u_axi_master_if_2.arready, u_axi_master_if_1.arready, u_axi_master_if_0.arready}   ),
			                     .s_axi_rid       ({u_axi_master_if_3.rid,     u_axi_master_if_2.rid,     u_axi_master_if_1.rid,     u_axi_master_if_0.rid}       ),
			                     .s_axi_rdata     ({u_axi_master_if_3.rdata,   u_axi_master_if_2.rdata,   u_axi_master_if_1.rdata,   u_axi_master_if_0.rdata}     ),
			                     .s_axi_rresp     ({u_axi_master_if_3.rresp,   u_axi_master_if_2.rresp,   u_axi_master_if_1.rresp,   u_axi_master_if_0.rresp}     ),
			                     .s_axi_rlast     ({u_axi_master_if_3.rlast,   u_axi_master_if_2.rlast,   u_axi_master_if_1.rlast,   u_axi_master_if_0.rlast}     ),  				
                          	     .s_axi_ruser     ({u_axi_master_if_3.ruser,   u_axi_master_if_2.ruser,   u_axi_master_if_1.ruser,   u_axi_master_if_0.ruser}     ),
			                     .s_axi_rvalid    ({u_axi_master_if_3.rvalid,  u_axi_master_if_2.rvalid,  u_axi_master_if_1.rvalid,  u_axi_master_if_0.rvalid}    ),
			                     .s_axi_rready    ({u_axi_master_if_3.rready,  u_axi_master_if_2.rready,  u_axi_master_if_1.rready,  u_axi_master_if_0.rready}    ),

                                 .m_axi_awid      ({u_axi_slave_if_5.awid ,    u_axi_slave_if_4.awid ,    u_axi_slave_if_3.awid,     u_axi_slave_if_2.awid,	    u_axi_slave_if_1.awid,	    u_axi_slave_if_0.awid}    	),
                                 .m_axi_awaddr    ({u_axi_slave_if_5.awaddr ,  u_axi_slave_if_4.awaddr ,  u_axi_slave_if_3.awaddr,   u_axi_slave_if_2.awaddr,	u_axi_slave_if_1.awaddr,    u_axi_slave_if_0.awaddr} 	),
                                 .m_axi_awlen     ({u_axi_slave_if_5.awlen,    u_axi_slave_if_4.awlen ,   u_axi_slave_if_3.awlen,    u_axi_slave_if_2.awlen,	u_axi_slave_if_1.awlen,	    u_axi_slave_if_0.awlen}		),
                                 .m_axi_awsize    ({u_axi_slave_if_5.awsize,   u_axi_slave_if_4.awsize ,  u_axi_slave_if_3.awsize,   u_axi_slave_if_2.awsize,	u_axi_slave_if_1.awsize,    u_axi_slave_if_0.awsize}	),
                                 .m_axi_awburst   ({u_axi_slave_if_5.awburst,  u_axi_slave_if_4.awburst , u_axi_slave_if_3.awburst,  u_axi_slave_if_2.awburst,	u_axi_slave_if_1.awburst,   u_axi_slave_if_0.awburst}	),
                                 .m_axi_awlock    ({u_axi_slave_if_5.awlock ,  u_axi_slave_if_4.awlock ,  u_axi_slave_if_3.awlock,   u_axi_slave_if_2.awlock,	u_axi_slave_if_1.awlock,    u_axi_slave_if_0.awlock}	),
                                 .m_axi_awcache   ({u_axi_slave_if_5.awcache,  u_axi_slave_if_4.awcache , u_axi_slave_if_3.awcache,  u_axi_slave_if_2.awcache,	u_axi_slave_if_1.awcache,   u_axi_slave_if_0.awcache}	),
                                 .m_axi_awprot    ({u_axi_slave_if_5.awprot,   u_axi_slave_if_4.awprot ,  u_axi_slave_if_3.awprot,   u_axi_slave_if_2.awprot,	u_axi_slave_if_1.awprot,    u_axi_slave_if_0.awprot}	),
                                 .m_axi_awqos     ({u_axi_slave_if_5.awqos,    u_axi_slave_if_4.awqos ,   u_axi_slave_if_3.awqos,    u_axi_slave_if_2.awqos,	u_axi_slave_if_1.awqos,	    u_axi_slave_if_0.awqos}		),
                                 .m_axi_awregion  ({u_axi_slave_if_5.awregion, u_axi_slave_if_4.awregion, u_axi_slave_if_3.awregion, u_axi_slave_if_2.awregion,	u_axi_slave_if_1.awregion,  u_axi_slave_if_0.awregion}	),
                                 .m_axi_awuser    ({u_axi_slave_if_5.awuser ,  u_axi_slave_if_4.awuser ,  u_axi_slave_if_3.awuser,   u_axi_slave_if_2.awuser,	u_axi_slave_if_1.awuser,	u_axi_slave_if_0.awuser}	),
                                 .m_axi_awvalid   ({u_axi_slave_if_5.awvalid , u_axi_slave_if_4.awvalid,  u_axi_slave_if_3.awvalid,  u_axi_slave_if_2.awvalid,	u_axi_slave_if_1.awvalid,   u_axi_slave_if_0.awvalid}	),
                                 .m_axi_awready   ({u_axi_slave_if_5.awready , u_axi_slave_if_4.awready,  u_axi_slave_if_3.awready,  u_axi_slave_if_2.awready,	u_axi_slave_if_1.awready,   u_axi_slave_if_0.awready}	),
                                 .m_axi_wdata     ({u_axi_slave_if_5.wdata ,   u_axi_slave_if_4.wdata ,   u_axi_slave_if_3.wdata,    u_axi_slave_if_2.wdata,	u_axi_slave_if_1.wdata,	  	u_axi_slave_if_0.wdata}		),
                                 .m_axi_wstrb     ({u_axi_slave_if_5.wstrb ,   u_axi_slave_if_4.wstrb ,   u_axi_slave_if_3.wstrb,    u_axi_slave_if_2.wstrb,	u_axi_slave_if_1.wstrb,    	u_axi_slave_if_0.wstrb}		),
                                 .m_axi_wlast     ({u_axi_slave_if_5.wlast ,   u_axi_slave_if_4.wlast ,   u_axi_slave_if_3.wlast,    u_axi_slave_if_2.wlast,	u_axi_slave_if_1.wlast,		u_axi_slave_if_0.wlast}		),
                                 .m_axi_wuser     ({u_axi_slave_if_5.wuser ,   u_axi_slave_if_4.wuser ,   u_axi_slave_if_3.wuser,    u_axi_slave_if_2.wuser,	u_axi_slave_if_1.wuser,		u_axi_slave_if_0.wuser}		),
                                 .m_axi_wvalid    ({u_axi_slave_if_5.wvalid ,  u_axi_slave_if_4.wvalid ,  u_axi_slave_if_3.wvalid,   u_axi_slave_if_2.wvalid,	u_axi_slave_if_1.wvalid,	u_axi_slave_if_0.wvalid}	),
                                 .m_axi_wready    ({u_axi_slave_if_5.wready ,  u_axi_slave_if_4.wready ,  u_axi_slave_if_3.wready,   u_axi_slave_if_2.wready,	u_axi_slave_if_1.wready,	u_axi_slave_if_0.wready}	),
                                 .m_axi_bid       ({u_axi_slave_if_5.bid ,     u_axi_slave_if_4.bid ,     u_axi_slave_if_3.bid,      u_axi_slave_if_2.bid,		u_axi_slave_if_1.bid,		u_axi_slave_if_0.bid}		),
                                 .m_axi_bresp     ({u_axi_slave_if_5.bresp ,   u_axi_slave_if_4.bresp ,   u_axi_slave_if_3.bresp,    u_axi_slave_if_2.bresp,	u_axi_slave_if_1.bresp,		u_axi_slave_if_0.bresp}		),
                                 .m_axi_buser     ({u_axi_slave_if_5.buser ,   u_axi_slave_if_4.buser ,   u_axi_slave_if_3.buser,    u_axi_slave_if_2.buser,	u_axi_slave_if_1.buser,		u_axi_slave_if_0.buser}		),
                                 .m_axi_bvalid    ({u_axi_slave_if_5.bvalid ,  u_axi_slave_if_4.bvalid ,  u_axi_slave_if_3.bvalid,   u_axi_slave_if_2.bvalid,	u_axi_slave_if_1.bvalid,	u_axi_slave_if_0.bvalid}	),
                                 .m_axi_bready    ({u_axi_slave_if_5.bready ,  u_axi_slave_if_4.bready ,  u_axi_slave_if_3.bready,   u_axi_slave_if_2.bready,	u_axi_slave_if_1.bready,	u_axi_slave_if_0.bready}	),
                                 .m_axi_arid      ({u_axi_slave_if_5.arid ,    u_axi_slave_if_4.arid ,    u_axi_slave_if_3.arid,     u_axi_slave_if_2.arid,	    u_axi_slave_if_1.arid,		u_axi_slave_if_0.arid}		),
                                 .m_axi_araddr    ({u_axi_slave_if_5.araddr ,  u_axi_slave_if_4.araddr ,  u_axi_slave_if_3.araddr,   u_axi_slave_if_2.araddr,	u_axi_slave_if_1.araddr,	u_axi_slave_if_0.araddr}	),
                                 .m_axi_arlen     ({u_axi_slave_if_5.arlen ,   u_axi_slave_if_4.arlen ,   u_axi_slave_if_3.arlen,    u_axi_slave_if_2.arlen,	u_axi_slave_if_1.arlen,		u_axi_slave_if_0.arlen}		),
                                 .m_axi_arsize    ({u_axi_slave_if_5.arsize ,  u_axi_slave_if_4.arsize ,  u_axi_slave_if_3.arsize,   u_axi_slave_if_2.arsize,	u_axi_slave_if_1.arsize,	u_axi_slave_if_0.arsize}	),
                                 .m_axi_arburst   ({u_axi_slave_if_5.arburst , u_axi_slave_if_4.arburst , u_axi_slave_if_3.arburst,  u_axi_slave_if_2.arburst,	u_axi_slave_if_1.arburst,	u_axi_slave_if_0.arburst}	),
                                 .m_axi_arlock    ({u_axi_slave_if_5.arlock ,  u_axi_slave_if_4.arlock ,  u_axi_slave_if_3.arlock,   u_axi_slave_if_2.arlock,	u_axi_slave_if_1.arlock,	u_axi_slave_if_0.arlock}	),
                                 .m_axi_arcache   ({u_axi_slave_if_5.arcache , u_axi_slave_if_4.arcache , u_axi_slave_if_3.arcache,  u_axi_slave_if_2.arcache,	u_axi_slave_if_1.arcache,	u_axi_slave_if_0.arcache}	),
                                 .m_axi_arprot    ({u_axi_slave_if_5.arprot ,  u_axi_slave_if_4.arprot ,  u_axi_slave_if_3.arprot,   u_axi_slave_if_2.arprot,	u_axi_slave_if_1.arprot,	u_axi_slave_if_0.arprot}	),
                                 .m_axi_arqos     ({u_axi_slave_if_5.arqos ,   u_axi_slave_if_4.arqos ,   u_axi_slave_if_3.arqos,    u_axi_slave_if_2.arqos,	u_axi_slave_if_1.arqos,		u_axi_slave_if_0.arqos}		),
                                 .m_axi_arregion  ({u_axi_slave_if_5.arregion, u_axi_slave_if_4.arregion, u_axi_slave_if_3.arregion, u_axi_slave_if_2.arregion,	u_axi_slave_if_1.arregion,	u_axi_slave_if_0.arregion}	),
                                 .m_axi_aruser    ({u_axi_slave_if_5.aruser ,  u_axi_slave_if_4.aruser ,  u_axi_slave_if_3.aruser,   u_axi_slave_if_2.aruser,	u_axi_slave_if_1.aruser,	u_axi_slave_if_0.aruser}	),
                                 .m_axi_arvalid   ({u_axi_slave_if_5.arvalid , u_axi_slave_if_4.arvalid , u_axi_slave_if_3.arvalid,  u_axi_slave_if_2.arvalid,	u_axi_slave_if_1.arvalid,	u_axi_slave_if_0.arvalid}   ),
                                 .m_axi_arready   ({u_axi_slave_if_5.arready , u_axi_slave_if_4.arready , u_axi_slave_if_3.arready,  u_axi_slave_if_2.arready,	u_axi_slave_if_1.arready,	u_axi_slave_if_0.arready}   ),
                                 .m_axi_rid       ({u_axi_slave_if_5.rid ,	   u_axi_slave_if_4.rid ,     u_axi_slave_if_3.rid,      u_axi_slave_if_2.rid,	    u_axi_slave_if_1.rid,	    u_axi_slave_if_0.rid}       ),
                                 .m_axi_rdata     ({u_axi_slave_if_5.rdata ,   u_axi_slave_if_4.rdata ,   u_axi_slave_if_3.rdata,    u_axi_slave_if_2.rdata,	u_axi_slave_if_1.rdata,		u_axi_slave_if_0.rdata}     ),
                                 .m_axi_rresp     ({u_axi_slave_if_5.rresp ,   u_axi_slave_if_4.rresp ,   u_axi_slave_if_3.rresp,    u_axi_slave_if_2.rresp,	u_axi_slave_if_1.rresp,		u_axi_slave_if_0.rresp}     ),
                                 .m_axi_rlast     ({u_axi_slave_if_5.rlast ,   u_axi_slave_if_4.rlast ,   u_axi_slave_if_3.rlast,    u_axi_slave_if_2.rlast,	u_axi_slave_if_1.rlast,		u_axi_slave_if_0.rlast}     ),
                                 .m_axi_ruser     ({u_axi_slave_if_5.ruser ,   u_axi_slave_if_4.ruser ,   u_axi_slave_if_3.ruser,    u_axi_slave_if_2.ruser,	u_axi_slave_if_1.ruser,		u_axi_slave_if_0.ruser}     ),
                                 .m_axi_rvalid    ({u_axi_slave_if_5.rvalid ,  u_axi_slave_if_4.rvalid ,  u_axi_slave_if_3.rvalid,   u_axi_slave_if_2.rvalid,	u_axi_slave_if_1.rvalid,	u_axi_slave_if_0.rvalid}    ),
                                 .m_axi_rready    ({u_axi_slave_if_5.rready ,  u_axi_slave_if_4.rready ,  u_axi_slave_if_3.rready,   u_axi_slave_if_2.rready,	u_axi_slave_if_1.rready,	u_axi_slave_if_0.rready}    ));


//assign u_axi_slave_if_5.bid = 'd0;

dma_axi32 inst_dma_axi32 (
    .clk(aclk),
    .reset(!aresetn),
    .scan_en('b0),
    .idle(),
    .INT(),
    .periph_tx_req('b0),
    .periph_tx_clr(),
    .periph_rx_req('b0),
    .periph_rx_clr(),
    .pclken('h1),
    // interface for configuring the dma
    .ARADDR(u_axi_slave_if_5.araddr),
    .ARVALID(u_axi_slave_if_5.arvalid),
    .ARSIZE(u_axi_slave_if_5.arsize),
    .ARBURST(u_axi_slave_if_5.arburst),
    .ARLEN(u_axi_slave_if_5.arlen),
    .AWID(u_axi_slave_if_5.awid),
    .ARID(u_axi_slave_if_5.arid),
    .ARREADY(u_axi_slave_if_5.arready),
    .AWADDR({{19{1'b0}},u_axi_slave_if_5.awaddr}),
    .AWVALID(u_axi_slave_if_5.awvalid),
    .AWSIZE(u_axi_slave_if_5.awsize),
    .AWBURST(u_axi_slave_if_5.awburst),
    .AWLEN(u_axi_slave_if_5.awlen),
    .AWREADY(u_axi_slave_if_5.awready),
    .RDATA(u_axi_slave_if_5.rdata),
    .RID(u_axi_slave_if_5.rid),
    .RVALID(u_axi_slave_if_5.rvalid),
    .RRESP(u_axi_slave_if_5.rresp),
    .RREADY(u_axi_slave_if_5.rready),
    .WDATA(u_axi_slave_if_5.wdata),
    .WVALID(u_axi_slave_if_5.wvalid),
    .WSTRB(u_axi_slave_if_5.wstrb),
    .WREADY(u_axi_slave_if_5.wready),
    .BRESP(u_axi_slave_if_5.bresp),
    .BID(u_axi_slave_if_5.bid),
    .BVALID(u_axi_slave_if_5.bvalid),
    .BREADY(u_axi_slave_if_5.bready),

    // dma interface
    .AWID0(u_axi_master_if_2.awid),
    .AWADDR0(u_axi_master_if_2.awaddr),
    .AWLEN0(u_axi_master_if_2.awlen),
    .AWSIZE0(u_axi_master_if_2.awsize),
    .AWVALID0(u_axi_master_if_2.awvalid),
    .AWREADY0(u_axi_master_if_2.awready),
    .WID0('b0),
    .WDATA0(u_axi_master_if_2.wdata),
    .WSTRB0(u_axi_master_if_2.wstrb),
    .WLAST0(u_axi_master_if_2.wlast),
    .WVALID0(u_axi_master_if_2.wvalid),
    .WREADY0(u_axi_master_if_2.wready),
    .BID0(u_axi_master_if_2.bid),
    .BRESP0(u_axi_master_if_2.bresp),
    .BVALID0(u_axi_master_if_2.bvalid),
    .BREADY0(u_axi_master_if_2.bready),
    .ARID0(u_axi_master_if_2.arid),
    .ARADDR0(u_axi_master_if_2.araddr),
    .ARLEN0(u_axi_master_if_2.arlen),
    .ARSIZE0(u_axi_master_if_2.arsize),
    .ARVALID0(u_axi_master_if_2.arvalid),
    .ARREADY0(u_axi_master_if_2.arready),
    .RID0(u_axi_master_if_2.rid),
    .RDATA0(u_axi_master_if_2.rdata),
    .RRESP0(u_axi_master_if_2.rresp),
    .RLAST0(u_axi_master_if_2.rlast),
    .RVALID0(u_axi_master_if_2.rvalid),
    .RREADY0(u_axi_master_if_2.rready)
     
);


/*                                                                   

   //To connect from master to slave below connections are required
   //Protected accesses
   assign u_axi_slave_if_0.awprot = u_axi_master_if_0.awprot;
   assign u_axi_slave_if_0.arprot = u_axi_master_if_0.arprot;


   //Signals from Master to SLAVE
   assign u_axi_slave_if_0.awid = u_axi_master_if_0.awid;
   assign u_axi_slave_if_0.arid = u_axi_master_if_0.arid;
   assign u_axi_slave_if_0.awaddr = u_axi_master_if_0.awaddr;
   assign u_axi_slave_if_0.awvalid = u_axi_master_if_0.awvalid;
   assign u_axi_slave_if_0.awsize = u_axi_master_if_0.awsize;
   assign u_axi_slave_if_0.wdata = u_axi_master_if_0.wdata;
   assign u_axi_slave_if_0.wstrb = u_axi_master_if_0.wstrb;
   assign u_axi_slave_if_0.wvalid = u_axi_master_if_0.wvalid;
   assign u_axi_slave_if_0.bready = u_axi_master_if_0.bready;
   assign u_axi_slave_if_0.araddr = u_axi_master_if_0.araddr;
   assign u_axi_slave_if_0.arvalid = u_axi_master_if_0.arvalid;
   assign u_axi_slave_if_0.arsize = u_axi_master_if_0.arsize;
   assign u_axi_slave_if_0.rready = u_axi_master_if_0.rready;
   assign u_axi_slave_if_0.awlen = u_axi_master_if_0.awlen;
   assign u_axi_slave_if_0.awburst = u_axi_master_if_0.awburst;
   assign u_axi_slave_if_0.arlen = u_axi_master_if_0.arlen;
   assign u_axi_slave_if_0.arburst = u_axi_master_if_0.arburst;
   assign u_axi_slave_if_0.wlast = u_axi_master_if_0.wlast;
   //Few signals are required from slave to master
   //Signals from Slave to MASTER
   assign u_axi_master_if_0.bid = u_axi_slave_if_0.bid;
   assign u_axi_master_if_0.rid = u_axi_slave_if_0.rid;
   assign u_axi_master_if_0.awready = u_axi_slave_if_0.awready;
   assign u_axi_master_if_0.wready = u_axi_slave_if_0.wready;
   assign u_axi_master_if_0.bresp = u_axi_slave_if_0.bresp;
   assign u_axi_master_if_0.bvalid = u_axi_slave_if_0.bvalid;
   assign u_axi_master_if_0.arready = u_axi_slave_if_0.arready;
   assign u_axi_master_if_0.rdata = u_axi_slave_if_0.rdata;
   assign u_axi_master_if_0.rresp = u_axi_slave_if_0.rresp;
   assign u_axi_master_if_0.rvalid = u_axi_slave_if_0.rvalid;
   assign u_axi_master_if_0.rlast = u_axi_slave_if_0.rlast; */



initial run_test ("dma_test");


endmodule


