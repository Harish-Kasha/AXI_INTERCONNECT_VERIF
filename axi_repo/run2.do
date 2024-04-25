vlog dma_axi32.v dma_axi32_dual_core.v dma_axi32_apb_mux.v dma_axi32_reg.v dma_axi32_reg_core0.v prgen_scatter8_1.v dma_axi32_core0_top.v dma_axi32_core0.v dma_axi32_core0_wdt.v dma_axi32_core0_arbiter.v dma_axi32_core0_ctrl.v dma_axi32_core0_axim_wr.v dma_axi32_core0_axim_cmd.v dma_axi32_core0_axim_timeout.v dma_axi32_core0_axim_wdata.v prgen_joint_stall.v prgen_fifo.v prgen_stall.v dma_axi32_core0_axim_resp.v dma_axi32_core0_axim_rd.v dma_axi32_core0_axim_rdata.v dma_axi32_core0_channels.v dma_axi32_core0_channels_apb_mux.v dma_axi32_core0_channels_mux.v prgen_or8.v prgen_mux8.v prgen_demux8.v dma_axi32_core0_ch.v dma_axi32_core0_ch_reg.v dma_axi32_core0_ch_reg_size.v prgen_rawstat.v dma_axi32_core0_ch_offsets.v dma_axi32_core0_ch_remain.v dma_axi32_core0_ch_outs.v dma_axi32_core0_ch_calc.v dma_axi32_core0_ch_calc_addr.v dma_axi32_core0_ch_calc_size.v prgen_min3.v prgen_min2.v dma_axi32_core0_ch_calc_joint.v dma_axi32_core0_ch_periph_mux.v dma_axi32_core0_ch_fifo_ctrl.v dma_axi32_core0_ch_wr_slicer.v prgen_swap_32.v dma_axi32_core0_ch_rd_slicer.v dma_axi32_core0_ch_fifo_ptr.v dma_axi32_core0_ch_fifo.v dma_axi32_core0_ch_empty.v prgen_delay.v AXI_APB_Bridge.v
vlog axi_parameter_pkg.sv
vlog axi_agent_pkg.sv
vlog axi_interface.sv
vlog axi_footprint_interface.sv
vlog axi_interconnect_veri_top.sv
vlog axi_interconnect_pkg.sv
vlog -coveropt 3 +cover axi_interconnect_wrapper.sv axi_master_interface_coupler_wrapper.v axi_SI_coupler_wrapper.sv axi_fifo.v axi_fifo_rd.v axi_fifo_wr.v axi_register.v axi_register_rd.v axi_register_wr.v axi_adapter.v axi_adapter_rd.v axi_adapter_wr.v axi_crossbar.v axi_crossbar_addr.v axi_crossbar_rd.v axi_crossbar_wr.v arbiter.v priority_encoder.v
vsim -voptargs=+acc -coverage -suppress 12003 -suppress 3053 -suppress 3009 -suppress 3839 -logfile logdma1.txt axi_interconnect_top -do "coverage save -onexit -directive -codeAll 11may2;"
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

