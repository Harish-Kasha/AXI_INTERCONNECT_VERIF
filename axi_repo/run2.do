vlog axi_agent_pkg.sv
vlog axi_interface.sv
vlog axi_footprint_interface.sv
vlog axi_interconnect_veri_top.sv
vlog axi_interconnect_pkg.sv
vlog -coveropt 3 +cover axi_interconnect_wrapper.sv axi_master_interface_coupler_wrapper.v axi_SI_coupler_wrapper.sv axi_fifo.v axi_fifo_rd.v axi_fifo_wr.v axi_register.v axi_register_rd.v axi_register_wr.v axi_adapter.v axi_adapter_rd.v axi_adapter_wr.v axi_crossbar.v axi_crossbar_addr.v axi_crossbar_rd.v axi_crossbar_wr.v arbiter.v priority_encoder.v
vsim -voptargs=+acc -coverage -suppress 12003 -suppress 3053 -logfile logNARROW.txt axi_interconnect_top -do "coverage save -onexit -directive -codeAll 11may2;"
add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_master_if_0/max_footprint_if/rvalid 

add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_master_if_1/max_footprint_if/rvalid
 
add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_master_if_2/max_footprint_if/rvalid

add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_0/max_footprint_if/rvalid 


add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_1/max_footprint_if/rvalid 


add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_2/max_footprint_if/rvalid 

add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_3/max_footprint_if/rvalid 

add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_4/max_footprint_if/rvalid 

add wave -position insertpoint  \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/aclk \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/aresetn \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awaddr \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awlen \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awsize \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awburst \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awvalid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/awready \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/wdata \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/wstrb \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/wlast \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/wvalid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/wready \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/bready \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/bid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/bresp \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/bvalid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/araddr \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arlen \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arsize \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arburst \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arvalid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/arready \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rready \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rid \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rdata \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rresp \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rlast \
sim:/axi_interconnect_top/u_axi_slave_if_5/max_footprint_if/rvalid 




run -all
vcover report -html 11may2

