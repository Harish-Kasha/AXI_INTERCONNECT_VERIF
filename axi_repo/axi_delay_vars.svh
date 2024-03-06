 /********************************************************************
 *
 *******************************************************************/

class axi_delay_vars extends uvm_object;
   `uvm_object_utils(axi_delay_vars)
   
   rand int m_aw_start_delay;
   rand int m_w_start_delay;
   rand int m_w_beat_delay;
   rand int m_b_start_delay;
   rand int m_ar_start_delay;
   rand int m_r_start_delay;
   rand int m_r_beat_delay;

   constraint master_delays {
      m_aw_start_delay inside {[0:3]};
      m_w_start_delay inside {[0:3]};
      m_w_beat_delay inside {[0:3]};
      m_b_start_delay inside {[0:3]};
      m_ar_start_delay inside {[0:3]};
      m_r_start_delay inside {[0:3]};
      m_r_beat_delay inside {[0:3]};
   }

   rand int s_aw_start_delay;
   rand int s_w_start_delay;
   rand int s_w_beat_delay;
   rand int s_b_start_delay;
   rand int s_ar_start_delay;
   rand int s_r_start_delay;
   rand int s_r_beat_delay;

   constraint slave_delays {
      s_aw_start_delay inside {[0:3]};
      s_w_start_delay inside {[0:3]};
      s_w_beat_delay inside {[0:3]};
      s_b_start_delay inside {[0:3]};
      s_ar_start_delay inside {[0:3]};
      s_r_start_delay inside {[0:3]};
      s_r_beat_delay inside {[0:3]};
   }
   
   //TODO: remove
   //BEGIN - TO BE DELETED - DO NOT USE
   rand int wa_ack_delay;
   rand int wd_ack_delay;
   rand int wresp_start_delay;
   rand int ra_ack_delay;
   rand int rd_start_delay;
   rand int burst_rd_beat_delay;

   constraint slave_valid {
      wa_ack_delay inside {[0:2]};
      wd_ack_delay inside {[0:2]};
      wresp_start_delay inside {[0:3]};
      ra_ack_delay  inside {[0:2]};
      rd_start_delay  inside {[0:3]};
      burst_rd_beat_delay inside {[0:1]};
   }
   //END - TO BE DELETED - DO NOT USE
   
  extern function new(string name = "axi_delay_vars");

endclass: axi_delay_vars

function axi_delay_vars::new(string name = "axi_delay_vars");
   super.new(name);
endfunction


