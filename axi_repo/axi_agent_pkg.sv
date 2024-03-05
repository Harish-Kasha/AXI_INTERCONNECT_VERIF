 /********************************************************************
 *******************************************************************/

`timescale 1ps/1ps

package axi_agent_pkg;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {
     AXI_WRITE = 0,
     AXI_READ = 1
  } axi_op_type_t;
  
  typedef enum {
      REQUEST  = 0,
      RESPONSE = 1
  } req_res_identifier;

 
  typedef enum logic [1:0] {
    FIXED, INCR, WRAP
  } burst_type_t;

  typedef enum logic [1:0] {
    OKAY, EXOKAY, SLVERR, DECERR
  } resp_type_t;

  typedef enum logic [3:0] {
    BUFFERABLE     = 4'b0001,
    CACHEABLE      = 4'b0010,
    READ_ALLOCATE  = 4'b0100,
    WRITE_ALLOCATE = 4'b1000
  } cache_attr_t;

  typedef enum logic [2:0] {
    PRIVILEGED  = 3'b001,
    NON_SECURE  = 3'b010,
    INSTRUCTION = 3'b100
  } prot_attr_t;

  typedef enum logic [1:0] {
    NORMAL, EXCLUSIVE, LOCKED
  } lock_type_t;

// Common
`include "axi_defines.svh"
`include "axi_common.svh"
`include "axi_delay_vars.svh"
`include "axi_seq_item.svh"
`include "axi_adapter.svh"
`include "axi_agent_configuration.svh"
`include "axi_monitor.svh"

// Master sequences
`include "axi_master_read_seq.svh"
`include "axi_master_write_seq.svh"
`include "axi_pipeline_write_seq.svh"
`include "axi_pipeline_read_seq.svh"
`include "axi_burst_write_seq.svh"

// Master
`include "axi_master_driver.svh"
`include "axi_master_sequencer.svh"
`include "axi_master_agent.svh"

// Slave
`include "axi_slave_memory.svh"
`include "axi_slave_sequencer.svh"
`include "axi_slave_driver.svh"
`include "axi_slave_agent.svh"

//ONLY HERE FOR BACKWARDS COMPATIBILITY - DO NOT USE
`include "axi_slave_response_seq.svh"

// Monitor
//`include "axi_monitor_agent.svh"

endpackage : axi_agent_pkg




