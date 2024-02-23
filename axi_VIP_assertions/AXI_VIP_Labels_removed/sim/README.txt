
#
# PART 1: standalone testbench
#

module purge
module load proj/verif_common/r001/verif
module load questacoreprime/10_5c_5
module load vcsmx/L_2016_06_SP2_1
module load verdi/L_2016_06_SP2_3

cd <verif_common_r001_ws>/verif/axi_vip/sim

######################################

# VCS
# all default: check clean comp run

# GUI for default UVM_TEST 'example_test1' , make all steps
grid make -f Makefile_example_env MODE=DEBUG

# Batch for default UVM_TEST 'example_test1' , make all steps
grid make -f Makefile_example_env

# GUI for UVM_TEST 'example_test_burst' , make all steps
# To be merged with existing sequence file
grid make -f Makefile_example_env UVM_TEST=example_test_burst MODE=DEBUG

# Batch for UVM_TEST 'example_test_burst' , make all steps
# NB: this test might have $stop calls
grid make -f Makefile_example_env UVM_TEST=example_test_burst

######################################

# Questa: vsim
grid make -f Makefile_example_env_vsim MODE=DEBUG
grid make -f Makefile_example_env_vsim UVM_TEST=example_test_burst



##################################################################################################################
##################################################################################################################



#
# PART 2: Integration problematics
#

1) systemverilog `define : main defines default values:
 `define AXI_MAX_AW 32
 `define AXI_MAX_DW 1024   ==>  mainly 128 in designs
 `define AXI_ID_HEADER_SIZE 6
 `define AXI_TRANSACTION_ID_SIZE 10
 `define AXI_PC_MAXWAITS 64

2) Timeouts for big transfers (above 16 beats)
axi_agent_configuration.num_timeout_cycles might be augmented if *READY are driven low for a while

3) To enable 4k boundary check (not enabled by default since not all slaves implement it)
wr_seq = axi_master_write_seq::type_id::create("wr_seq");
wr_seq.check_4k_boundary = 1;
rd_seq = axi_master_read_seq::type_id::create("rd_seq");
rd_seq.check_4k_boundary = 1;
