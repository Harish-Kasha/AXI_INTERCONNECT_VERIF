vlog axi_interface.sv
vlog axi_footprint_interface.sv
vlog axi_interconnect_veri_top.sv
vlog axi_interconnect_pkg.sv
vlog -coveropt 3 +cover axi_interconnect_wrapper.sv axi_master_interface_coupler_wrapper.v axi_SI_coupler_wrapper.sv axi_fifo.v axi_fifo_rd.v axi_fifo_wr.v axi_register.v axi_register_rd.v axi_register_wr.v axi_adapter.v axi_adapter_rd.v axi_adapter_wr.v axi_crossbar.v axi_crossbar_addr.v axi_crossbar_rd.v axi_crossbar_wr.v arbiter.v priority_encoder.v
vsim -voptargs=+acc -coverage -suppress 12003 -suppress 3053 -logfile log3.txt axi_interconnect_top -do "coverage save -onexit -directive -codeAll 11may2;"
run -all
vcover report -html 11may2
