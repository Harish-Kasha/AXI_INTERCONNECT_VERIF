/********************************************************************
 *
 *******************************************************************/

`timescale 1ps/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_common.svh"
`include "axi_vip_test_pkg.sv"

 module top ();

   import axi_vip_test_pkg::*;

   bit aclk;
   bit aresetn;

   axi_interface#(128, 32, 0, "axi_master_if") u_axi_master_if ();
   axi_interface#(128, 32, 1, "axi_slave_if") u_axi_slave_if ();
   axi_interface#(128, 32, 2, "axi_mon_if") u_axi_mon_if ();
   
   assign u_axi_master_if.aresetn = aresetn;
   assign u_axi_master_if.aclk = aclk;
   assign u_axi_slave_if.aresetn = aresetn;
   assign u_axi_slave_if.aclk = aclk;
   assign u_axi_mon_if.aresetn = aresetn;
   assign u_axi_mon_if.aclk = aclk;  

   initial begin
      aresetn = 1'b0;
      #5000;
      aresetn = 1'b1;
   end

   initial begin
      aclk <= 1'b0;
        forever begin
           aclk <= 1'b1;
           #1000;
           aclk <= 1'b0;
           #1000;
        end
   end

   //Protected accesses
   assign u_axi_slave_if.awprot = u_axi_master_if.awprot;
   assign u_axi_slave_if.arprot = u_axi_master_if.arprot;

   //Signals from Master to SLAVE
   assign u_axi_slave_if.awid = u_axi_master_if.awid;
   assign u_axi_slave_if.arid = u_axi_master_if.arid;
   assign u_axi_slave_if.awaddr = u_axi_master_if.awaddr;
   assign u_axi_slave_if.awvalid = u_axi_master_if.awvalid;
   assign u_axi_slave_if.awsize = u_axi_master_if.awsize;
   assign u_axi_slave_if.wdata = u_axi_master_if.wdata;
   assign u_axi_slave_if.wstrb = u_axi_master_if.wstrb;
   assign u_axi_slave_if.wvalid = u_axi_master_if.wvalid;
   assign u_axi_slave_if.bready = u_axi_master_if.bready;
   assign u_axi_slave_if.araddr = u_axi_master_if.araddr;
   assign u_axi_slave_if.arvalid = u_axi_master_if.arvalid;
   assign u_axi_slave_if.arsize = u_axi_master_if.arsize;
   assign u_axi_slave_if.rready = u_axi_master_if.rready;
   assign u_axi_slave_if.awlen = u_axi_master_if.awlen;
   assign u_axi_slave_if.awburst = u_axi_master_if.awburst;
   assign u_axi_slave_if.arlen = u_axi_master_if.arlen;
   assign u_axi_slave_if.arburst = u_axi_master_if.arburst;
   assign u_axi_slave_if.wlast = u_axi_master_if.wlast;

   //Signals from Slave to MASTER
   assign u_axi_master_if.bid = u_axi_slave_if.bid;
   assign u_axi_master_if.rid = u_axi_slave_if.rid;
   assign u_axi_master_if.awready = u_axi_slave_if.awready;
   assign u_axi_master_if.wready = u_axi_slave_if.wready;
   assign u_axi_master_if.bresp = u_axi_slave_if.bresp;
   assign u_axi_master_if.bvalid = u_axi_slave_if.bvalid;
   assign u_axi_master_if.arready = u_axi_slave_if.arready;
   assign u_axi_master_if.rdata = u_axi_slave_if.rdata;
   assign u_axi_master_if.rresp = u_axi_slave_if.rresp;
   assign u_axi_master_if.rvalid = u_axi_slave_if.rvalid;
   assign u_axi_master_if.rlast = u_axi_slave_if.rlast;

   //Monitor signals
   assign u_axi_mon_if.bid = u_axi_slave_if.bid;
   assign u_axi_mon_if.rid = u_axi_slave_if.rid;
   assign u_axi_mon_if.awready = u_axi_slave_if.awready;
   assign u_axi_mon_if.wready = u_axi_slave_if.wready;
   assign u_axi_mon_if.bresp = u_axi_slave_if.bresp;
   assign u_axi_mon_if.bvalid = u_axi_slave_if.bvalid;
   assign u_axi_mon_if.arready = u_axi_slave_if.arready;
   assign u_axi_mon_if.rdata = u_axi_slave_if.rdata;
   assign u_axi_mon_if.rresp = u_axi_slave_if.rresp;
   assign u_axi_mon_if.rvalid = u_axi_slave_if.rvalid;
   assign u_axi_mon_if.rlast = u_axi_slave_if.rlast;
   assign u_axi_mon_if.csysack = u_axi_slave_if.csysack;
   assign u_axi_mon_if.cactive = u_axi_slave_if.cactive;
   assign u_axi_mon_if.buser = u_axi_slave_if.buser;
   assign u_axi_mon_if.ruser = u_axi_slave_if.ruser;
   assign u_axi_mon_if.awid = u_axi_slave_if.awid;
   assign u_axi_mon_if.arid = u_axi_slave_if.arid;
   assign u_axi_mon_if.awaddr = u_axi_slave_if.awaddr;
   assign u_axi_mon_if.awvalid = u_axi_slave_if.awvalid;
   assign u_axi_mon_if.awsize = u_axi_slave_if.awsize;
   assign u_axi_mon_if.wdata = u_axi_slave_if.wdata;
   assign u_axi_mon_if.wstrb = u_axi_slave_if.wstrb;
   assign u_axi_mon_if.wvalid = u_axi_slave_if.wvalid;
   assign u_axi_mon_if.bready = u_axi_slave_if.bready;
   assign u_axi_mon_if.araddr = u_axi_slave_if.araddr;
   assign u_axi_mon_if.arvalid = u_axi_slave_if.arvalid;
   assign u_axi_mon_if.arsize = u_axi_slave_if.arsize;
   assign u_axi_mon_if.rready = u_axi_slave_if.rready;
   assign u_axi_mon_if.awlen = u_axi_slave_if.awlen;
   assign u_axi_mon_if.awburst = u_axi_slave_if.awburst;
   assign u_axi_mon_if.arlen = u_axi_slave_if.arlen;
   assign u_axi_mon_if.arburst = u_axi_slave_if.arburst;
   assign u_axi_mon_if.wlast = u_axi_slave_if.wlast;
   assign u_axi_mon_if.csysreq = u_axi_slave_if.csysreq;
   assign u_axi_mon_if.aruser = u_axi_slave_if.aruser;
   assign u_axi_mon_if.awuser = u_axi_slave_if.awuser;
   assign u_axi_mon_if.wuser = u_axi_slave_if.wuser;
   assign u_axi_mon_if.awlock = u_axi_slave_if.awlock;
   assign u_axi_mon_if.arlock = u_axi_slave_if.arlock;
   assign u_axi_mon_if.awqos = u_axi_slave_if.awqos;
   assign u_axi_mon_if.awregion = u_axi_slave_if.awregion;
   assign u_axi_mon_if.awcache = u_axi_slave_if.awcache;
   assign u_axi_mon_if.arqos = u_axi_slave_if.arqos;
   assign u_axi_mon_if.arregion = u_axi_slave_if.arregion;
   assign u_axi_mon_if.arcache = u_axi_slave_if.arcache;
   assign u_axi_mon_if.awprot = u_axi_slave_if.awprot;
   assign u_axi_mon_if.arprot = u_axi_slave_if.arprot; 

   initial begin
          uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_master_vif", u_axi_master_if.max_footprint_if);
	  uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_slave_vif", u_axi_slave_if.max_footprint_if);
	  uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_mon_vif", u_axi_mon_if.max_footprint_if);


          //uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_master_vif", u_axi_master_if.max_footprint_if);
	  //uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_slave_vif", u_axi_master_if.max_footprint_if);
	  //uvm_config_db #(virtual axi_footprint_interface)::set(null, "uvm_test_top", "axi_mon_vif", u_axi_master_if.max_footprint_if);
     run_test ();
   end

endmodule


