/********************************************************************
 *******************************************************************/

`timescale 1ps/1ps

`ifndef _AXI_FOOTPRINT_INTERFACE__SV
`define _AXI_FOOTPRINT_INTERFACE__SV

`ifndef AXI_MASTER_IF_HOLD_TIME
 `define AXI_MASTER_IF_HOLD_TIME 1
`endif
`ifndef AXI_MASTER_IF_SETUP_TIME
`define AXI_MASTER_IF_SETUP_TIME 1
`endif
`ifndef AXI_MONITOR_IF_HOLD_TIME
 `define AXI_MONITOR_IF_HOLD_TIME 1
`endif
`ifndef AXI_MONITOR_IF_SETUP_TIME
 `define AXI_MONITOR_IF_SETUP_TIME 1
`endif
`ifndef AXI_SLAVE_IF_HOLD_TIME
 `define AXI_SLAVE_IF_HOLD_TIME 1
`endif
`ifndef AXI_SLAVE_IF_SETUP_TIME
 `define AXI_SLAVE_IF_SETUP_TIME 1
`endif

`include "uvm_macros.svh"

`include "axi_common.svh"
`include "axi_defines.svh"

interface axi_footprint_interface #(int DW=32, int AW=32, int ID_W =10);

   import uvm_pkg::*;
   import axi_agent_pkg::axi_seq_item;

   //FULL AXI4 INTERFACE

   // ---Globals
   logic                             aclk;
   logic                             aresetn;

   // ---Write address channel signals
   //Master
   logic [ID_W-1:0]          awid;
   logic [AW-1:0]           awaddr;
   logic [7:0]                       awlen;
   logic [2:0]                       awsize;
   logic [1:0]                       awburst;
   logic                             awlock   = 0;
   logic [3:0]                       awcache  = 0;
   logic [2:0]                       awprot;
   logic [3:0]                       awqos    = 0;
   logic [3:0]                       awregion = 0;
   logic                             awuser   = 0;
   logic                             awvalid;
   //Slave
   logic                             awready;

   // ---Write data channel signals
   //Master
   logic [DW-1:0]           wdata;
   logic [(DW/8)-1:0]         wstrb;
   logic                             wlast;
   logic                             wuser    = 0;
   logic                             wvalid;
   //Slave
   logic                             wready;

   // ---Write response channel signals
   //Master
   logic                             bready;
   //Slave
   logic [ID_W-1:0]          bid;
   logic [1:0]                       bresp;
   logic                             buser=0;
   logic                             bvalid;

   // ---Read address channel signals
   //Master
   logic [ID_W-1:0]          arid;
   logic [AW-1:0]           araddr;
   logic [7:0]                       arlen;
   logic [2:0]                       arsize;
   logic [1:0]                       arburst;
   logic                             arlock     = 0;
   logic [3:0]                       arcache    = 0;
   logic [2:0]                       arprot;
   logic [3:0]                       arqos      = 0;
   logic [3:0]                       arregion   = 0;
   logic                             aruser     = 0;
   logic                             arvalid;
   //Slave
   logic                             arready;

   // ---Read data channel signals
   //Master
   logic                             rready;
   //Slave
   logic [ID_W-1:0]          rid;
   logic [DW-1:0]           rdata;
   logic [1:0]                       rresp;
   logic                             rlast;
   logic                             ruser     = 0;
   logic                             rvalid;

   // ---Low-power interface signals
   logic                             csysreq   = 0;
   logic                             csysack   = 0;
   logic                             cactive   = 0;

   int dbg_if_type;

   clocking axi_master_cb @(posedge aclk);
      default input #`AXI_MASTER_IF_SETUP_TIME output #`AXI_MASTER_IF_HOLD_TIME;

      input   aresetn ;

      output  awid;
      output  awaddr ;
      output  awvalid ;
      output  awsize ;
      input   awready ;
      output  awprot;

      output  wdata ;
      output  wstrb ;
      output  wvalid ;
      input   wready ;

      input   bid;
      input   bresp ;
      input   bvalid ;
      output  bready ;

      output  arid;
      output  arprot;
      output  araddr ;
      output  arvalid ;
      output  arsize ;
      input   arready ;

      input   rid;
      input   rdata ;
      input   rresp ;
      input   rvalid ;
      output  rready ;

      output  awlen ;
      output  awburst ;
      output  arlen ;
      output  arburst ;
      output  wlast ;
      input   rlast ;

   endclocking : axi_master_cb

   clocking axi_slave_cb @(posedge aclk);
      default input #`AXI_SLAVE_IF_SETUP_TIME output #`AXI_SLAVE_IF_HOLD_TIME;

      input  aresetn ;

      input   awid;
      input   awaddr ;
      input   awvalid ;
      input   awsize ;
      output  awready ;
      input   awprot;

      input   wdata ;
      input   wstrb ;
      input   wvalid ;
      output  wready ;

      output  bid;
      output  bresp ;
      output  bvalid ;
      input   bready ;

      input   arid;
      input   arprot;
      input   araddr ;
      input   arvalid ;
      input   arsize ;
      output  arready ;

      output  rid;
      output  rdata ;
      output  rresp ;
      output  rvalid ;
      input   rready ;

      input   awlen ;
      input   awburst ;
      input   arlen ;
      input   arburst ;
      input   wlast ;
      output  rlast ;

   endclocking : axi_slave_cb

   clocking axi_monitor_cb @(posedge aclk);
      default input #`AXI_MONITOR_IF_SETUP_TIME output #`AXI_MONITOR_IF_HOLD_TIME;

      input  aresetn ;

      input  awid;
      input  awprot;
      input  awaddr ;
      input  awvalid ;
      input  awsize;
      input  awready ;

      input  wdata ;
      input  wstrb ;
      input  wvalid ;
      input  wready ;

      input  bid;
      input  bresp ;
      input  bvalid ;
      input  bready ;

      input  arid;
      input  arprot;
      input  araddr ;
      input  arvalid ;
      input  arsize;
      input  arready ;

      input  rid;
      input  rdata ;
      input  rresp ;
      input  rvalid ;
      input  rready ;

      input  awlen ;
      input  awburst ;
      input  arlen ;
      input  arburst ;
      input  wlast ;
      input  rlast ;

   endclocking : axi_monitor_cb

   //Drive default values to AXI bus
   task master_drive_idle();
      awid <= 0;
      arid <= 0;
      awaddr <= 0;
      awvalid <= 0;
      awsize <= 0;
      wdata <= 0;
      wstrb <= 0;
      wvalid <= 0;
      bready <= 0;
      araddr <= 0;
      arvalid <= 0;
      arsize <= 0;
      rready <= 0;
      awlen <= 0;
      awburst <= 0;
      arlen <= 0;
      arburst <= 0;
      wlast <= 0;
      arprot <= 0;
      awprot <= 0;
   //add low power, user, cache, region, qos, lock signals here if implemented
   endtask

   task slave_drive_idle();
      bid <= 0;
      rid <= 0;
      awready <= 0;
      wready  <= 0;
      bresp  <= 0;
      bvalid  <= 0;
      arready  <= 0;
      rdata  <= 0;
      rresp  <= 0;
      rvalid  <= 0;
      rlast  <= 0;
   endtask

   task slv_reset();
     if(axi_master_cb.aresetn===1)begin
      axi_master_cb.arvalid <= 1'b1;      
     end

     if(axi_slave_cb.aresetn===1)begin
      axi_slave_cb.rvalid <= 1'b1;      
     end
     
   endtask
   /*task slv_reset();
     if(axi_slave_cb.aresetn===1)begin
      //axi_slave_cb.arvalid <= 1'b1;
      axi_slave_cb.rvalid <= 1'b1;      
     end
   endtask*/


/*   task master_reset();
     if(axi_master_cb.aresetn==0)begin
      axi_master_cb.awvalid <= 1'b0;
      axi_master_cb.wvalid <= 1'b0;      
     end
     else if(axi_master_cb.aresetn==1)begin
      axi_master_cb.awvalid <= 1'b1;
      axi_master_cb.wvalid <= 1'b1;      
     end
   endtask*/

  /* task automatic m_aw (ref axi_seq_item t);
     if(axi_master_cb.aresetn==1)begin
        repeat(t.delay_vars.m_aw_start_delay) @(axi_master_cb);
        $display($time,"from interface write task of aw channel");
        axi_master_cb.awid <= t.id;
        axi_master_cb.awaddr <= t.addr;
        axi_master_cb.awsize <= $clog2(t.tr_size_in_bytes);
        axi_master_cb.awvalid <= 1'b1;
        axi_master_cb.awlen <= t.burst_length-1;
        axi_master_cb.awburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY
        @(axi_master_cb);

        if (awvalid == 1'b0) @(axi_master_cb);

        while (axi_master_cb.awready !== 1'b1) begin
           @(axi_master_cb);
        end
 
        axi_master_cb.awid <= 0;
        axi_master_cb.awvalid <= 1'b0;
        axi_master_cb.awaddr <= 0;
        axi_master_cb.awsize <= 0;
        axi_master_cb.awlen <= 0;
        axi_master_cb.awburst <= 0;
      end

      if(axi_master_cb.aresetn==0)begin
        $display($time,"from interface reset write task of aw channel");
        axi_master_cb.awid <= t.id;
        axi_master_cb.awaddr <= t.addr;
        axi_master_cb.awsize <= $clog2(t.tr_size_in_bytes);
        axi_master_cb.awvalid <= 1'b0;
        axi_master_cb.awlen <= t.burst_length-1;
        axi_master_cb.awburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY

        @(axi_master_cb);


       /* if(axi_master_cb.aresetn==1)begin
        axi_master_cb.awvalid <= 1'b1;
        end
       // else begin
        axi_master_cb.awid <= 0;
        axi_master_cb.awvalid <= 1'b0;
        axi_master_cb.awaddr <= 0;
        axi_master_cb.awsize <= 0;
        axi_master_cb.awlen <= 0;
        axi_master_cb.awburst <= 0;
      //  end

      end

   endtask : m_aw

   task automatic m_w (ref axi_seq_item t);
      
      if(axi_master_cb.aresetn==1)begin
        repeat(t.delay_vars.m_w_start_delay) @(axi_master_cb);

        for (int i = 0; i < t.burst_length; i++) begin

          // if (i > 0)
              //repeat(t.delay_vars.m_w_beat_delay) @(axi_master_cb);

           axi_master_cb.wdata <= t.data[i];
           axi_master_cb.wvalid <= 1'b1;
           axi_master_cb.wstrb <= t.byte_en[i];

           if (i == t.burst_length-1)
              axi_master_cb.wlast <= 1'b1;

           @(axi_master_cb);

           if (wvalid == 1'b0)
              @(axi_master_cb);

           while (axi_master_cb.wready !== 1'b1) begin
              @(axi_master_cb);
           end
        end
           axi_master_cb.wdata <= 0;
           axi_master_cb.wvalid <= 1'b0;
           axi_master_cb.wstrb <= 0;
           axi_master_cb.wlast <= 1'b0;
      end

      if(axi_master_cb.aresetn==0)begin

        for (int i = 0; i < t.burst_length; i++) begin
           axi_master_cb.wdata <= t.data[i];
           axi_master_cb.wvalid <= 1'b0;
           axi_master_cb.wstrb <= t.byte_en[i];

           if (i == t.burst_length-1)
              axi_master_cb.wlast <= 1'b1;

           @(axi_master_cb);
          
          /*if(axi_master_cb.aresetn==1)begin
          axi_master_cb.wvalid <= 1'b1;
          end
         end
           axi_master_cb.wdata <= 0;
           axi_master_cb.wvalid <= 1'b0;
           axi_master_cb.wstrb <= 0;
           axi_master_cb.wlast <= 1'b0;

       end

   endtask : m_w

   task automatic m_b (ref axi_seq_item t);
     if(axi_master_cb.aresetn==1)begin

        if (t.delay_vars.m_b_start_delay === 0) begin
           axi_master_cb.bready <= 1'b1;
           @(axi_master_cb);
        end
        
        while (axi_master_cb.bvalid !== 1'b1) begin
           @(axi_master_cb);
        end

        if (t.delay_vars.m_b_start_delay > 0) begin
           repeat(t.delay_vars.m_b_start_delay) @(axi_master_cb);
           axi_master_cb.bready <= 1'b1;
           @(axi_master_cb);
        end
        t.id = axi_master_cb.bid;
        t.bresp = axi_master_cb.bresp;

        /* if(axi_master_cb.aresetn==0)
           axi_master_cb.bready <= 1'b0;
         else
           axi_master_cb.bready <= 1'b1;

     end     
     if(axi_master_cb.aresetn==0)begin

   
      t.id = axi_master_cb.bid;
      t.bresp = axi_master_cb.bresp;
      axi_master_cb.bready <= 1'b0;

      /*if(axi_master_cb.aresetn==1)begin
          axi_master_cb.bready <= 1'b1;
      end
      end

   endtask : m_b*/

  /* task automatic m_aw (ref axi_seq_item t);

      repeat(t.delay_vars.m_aw_start_delay) @(axi_master_cb);

      axi_master_cb.awid <= t.id;
      axi_master_cb.awaddr <= t.addr;
      axi_master_cb.awsize <= $clog2(t.tr_size_in_bytes);
     // axi_master_cb.awvalid <= 1'b1;
      axi_master_cb.awlen <= t.burst_length-1;
      axi_master_cb.awburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY
      if(axi_master_cb.aresetn==1)begin
        axi_master_cb.awvalid <= 1'b1;
        @(axi_master_cb);
        if (awvalid == 1'b0) @(axi_master_cb);

        while (axi_master_cb.awready !== 1'b1) begin
         @(axi_master_cb);
        end
        while (axi_master_cb.aresetn === 1'b0) begin
         axi_master_cb.awvalid <= 1'b0;         
         @(axi_master_cb);
        end
      end
      else begin
        axi_master_cb.awvalid <= 1'b0;    
        @(axi_master_cb);
        while (axi_master_cb.aresetn === 1'b1) begin
         axi_master_cb.awvalid <= 1'b1;         
         @(axi_master_cb);
        end

      end
      
      
      axi_master_cb.awid <= 0;
      axi_master_cb.awvalid <= 1'b0;
      axi_master_cb.awaddr <= 0;
      axi_master_cb.awsize <= 0;
      axi_master_cb.awlen <= 0;
      axi_master_cb.awburst <= 0;
   endtask : m_aw*/

/*task automatic m_aw (ref axi_seq_item t);
    repeat(t.delay_vars.m_aw_start_delay) @(axi_master_cb);

    axi_master_cb.awid <= t.id;
    axi_master_cb.awaddr <= t.addr;
    axi_master_cb.awsize <= $clog2(t.tr_size_in_bytes);
    axi_master_cb.awlen <= t.burst_length-1;
    axi_master_cb.awburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY

    if(axi_master_cb.aresetn == 1'b0) begin
        axi_master_cb.awvalid <= 1'b0; // Reset asserted, set awvalid to 0
    end
    else begin
        axi_master_cb.awvalid <= 1'b1; // Reset deasserted, set awvalid to 1
        @(axi_master_cb); // Wait for one clock cycle

       while (axi_master_cb.awready !== 1'b1) begin
            @(axi_master_cb); // Wait until awready is high

        while (axi_master_cb.aresetn === 1'b0) begin
            axi_master_cb.awvalid <= 1'b0; // Set awvalid to 0

     //   while (axi_master_cb.awready !== 1'b1) begin
       //     @(axi_master_cb); // Wait until awready is high
        end

        // Reset is deasserted, wait for it to be asserted again
      //  while (axi_master_cb.aresetn === 1'b1) begin
          //  axi_master_cb.awvalid <= 1'b0; // Set awvalid to 0
            //@(axi_master_cb); // Wait for one clock cycle
        end
    end

    // Reset or not, clean up the signals
    axi_master_cb.awid <= 0;
    axi_master_cb.awvalid <= 1'b0;
    axi_master_cb.awaddr <= 0;
    axi_master_cb.awsize <= 0;
    axi_master_cb.awlen <= 0;
    axi_master_cb.awburst <= 0;
endtask : m_aw*/

      

  

   /*task automatic m_w (ref axi_seq_item t);

      repeat(t.delay_vars.m_w_start_delay) @(axi_master_cb);

      for (int i = 0; i < t.burst_length; i++) begin

         if (i > 0)
            repeat(t.delay_vars.m_w_beat_delay) @(axi_master_cb);

         axi_master_cb.wdata <= t.data[i];
        // axi_master_cb.wvalid <= 1'b1;
         axi_master_cb.wstrb <= t.byte_en[i];
         axi_master_cb.wvalid <= (axi_master_cb.aresetn) ? 1'b1 : 1'b0;
         @(axi_master_cb);
           if (i == t.burst_length-1)
              axi_master_cb.wlast <= 1'b1;

           @(axi_master_cb);
          if(axi_master_cb.aresetn === 1)begin
           if (wvalid == 1'b0)
              @(axi_master_cb);

           while (axi_master_cb.wready !== 1'b1) begin
             if(axi_master_cb.aresetn === 1'b0) axi_master_cb.wvalid <= 0;
             else axi_master_cb.wvalid <= 1;
             @(axi_master_cb);
           end
            if(axi_master_cb.aresetn === 1'b0) axi_master_cb.wvalid <= 0;
            else axi_master_cb.wvalid <= 1;
         end
         else 
            axi_master_cb.wvalid <= 1'b0;
         end

       /*  else if(axi_master_cb.aresetn==0)begin
           axi_master_cb.wvalid <= 1'b0;

           if (i == t.burst_length-1)
              axi_master_cb.wlast <= 1'b1;

           @(axi_master_cb);
         end
       end
         @(axi_master_cb);        
         axi_master_cb.wdata <= 0;
         axi_master_cb.wvalid <= 1'b0;
         axi_master_cb.wstrb <= 0;
         axi_master_cb.wlast <= 1'b0;
    endtask : m_w*/

   task automatic m_aw (ref axi_seq_item t);
      repeat(t.delay_vars.m_aw_start_delay) @(axi_master_cb);

      axi_master_cb.awid <= t.id;
      axi_master_cb.awaddr <= t.addr;
      axi_master_cb.awsize <= $clog2(t.tr_size_in_bytes);
      axi_master_cb.awlen <= t.burst_length-1;
      axi_master_cb.awburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY

      // Set awvalid to 0 whenever there is a reset
      axi_master_cb.awvalid <= (axi_master_cb.aresetn) ? 1'b1 : 1'b0;
      @(axi_master_cb);
      
      
     // Wait until awready is high
     if(axi_master_cb.aresetn === 1)begin   
        axi_master_cb.awvalid <= 1;          
        if (awvalid == 1'b0) @(axi_master_cb);                  
        while (axi_master_cb.awready !== 1'b1) begin
           if(axi_master_cb.aresetn === 1'b0)begin
              axi_master_cb.awvalid <= 0;
              break;
           end
           else axi_master_cb.awvalid <= 1;
           @(axi_master_cb);
        end
        if(axi_master_cb.aresetn === 1'b0) axi_master_cb.awvalid <= 0;
        else axi_master_cb.awvalid <= 1;
     end
     else begin
        axi_master_cb.awvalid <= 1'b0;
     end     

     // Clean up the signals
     axi_master_cb.awid <= 0;
     axi_master_cb.awvalid <= 1'b0;
     axi_master_cb.awaddr <= 0;
     axi_master_cb.awsize <= 0;
     axi_master_cb.awlen <= 0;
     axi_master_cb.awburst <= 0;
   endtask : m_aw

  /* task automatic m_w (ref axi_seq_item t);
      bit temp;

     repeat(t.delay_vars.m_w_start_delay) @(axi_master_cb);

     for (int i = 0; i < t.burst_length; i++) begin

       if(axi_master_cb.aresetn === 1 && i==0) begin
           temp = 1;
           axi_master_cb.wvalid <=1;
          end
          else if(axi_master_cb.aresetn === 0 && i==0) begin
           temp = 0;
           axi_master_cb.wvalid <=0;   
          end          
       
        if(axi_master_cb.aresetn === 1)begin 
          axi_master_cb.wdata <= t.data[i];
          // $monitor("master write data = %0h",axi_master_cb.wdata);
          axi_master_cb.wstrb <= t.byte_en[i];      
        end 
        else begin
          axi_master_cb.wdata <= axi_master_cb.wdata ;
          // $monitor("master write data = %0h",axi_master_cb.wdata);
          axi_master_cb.wstrb <= 0;      
        end
        //axi_master_cb.wvalid <= (axi_master_cb.aresetn) ? 1'b1 : 1'b0;
      // if(axi_master_cb.aresetn === 1)begin 
        if (i == t.burst_length-1) axi_master_cb.wlast <= 1'b1;
     //  end
        @(axi_master_cb);
       if (axi_master_cb.wlast == 1) begin
           break;
        end
         if(!temp && i < t.burst_length)begin
           axi_master_cb.wvalid <=0;
         end
       else begin

         if(axi_master_cb.aresetn === 1)begin          
           axi_master_cb.wvalid <= 1;     
           if (wvalid == 1'b0)
              @(axi_master_cb);

           while (axi_master_cb.wready !== 1'b1) begin
               if(axi_master_cb.aresetn === 1'b0)begin
                  axi_master_cb.wvalid <= 0;     
                  break;
                end        
               else axi_master_cb.wvalid <= 1;
 
              @(axi_master_cb);
           end
              if(axi_master_cb.aresetn === 1'b0) axi_master_cb.wvalid <= 0;
              else axi_master_cb.wvalid <= 1;
         end
         else 
            axi_master_cb.wvalid <= 1'b0;
       end
     end
     axi_master_cb.wdata <= 0;
     axi_master_cb.wvalid <= 1'b0;
     axi_master_cb.wstrb <= 0;
     axi_master_cb.wlast <= 1'b0;
   endtask : m_w*/
  
   task automatic m_w (ref axi_seq_item t);
      bit rst;
      int count;
      int num;

      repeat(t.delay_vars.s_r_start_delay) @(axi_master_cb);

      for(int i = 0; i < t.burst_length; i++) begin
                        
        if(axi_master_cb.aresetn === 1)begin
          count ++;
          axi_master_cb.wdata <= t.data[i];
          axi_master_cb.wstrb <= t.byte_en[i];                 
          axi_master_cb.wvalid <=1;         
        end
        else begin
          for(int i = 0; i < t.burst_length; i++) begin
            axi_master_cb.wdata <= 0;
            axi_master_cb.wstrb <= 0;                 
            axi_master_cb.wvalid <=0;         
            @(axi_master_cb);
          end
          break;
        end
        
        if (i == t.burst_length-1) axi_master_cb.wlast <= 1'b1;
        @(axi_master_cb);
       
       if (axi_master_cb.wlast === 1) begin
          axi_master_cb.wlast <= 1'b0;
          axi_master_cb.wvalid <= 0;               
          break;
        end

        if(axi_master_cb.aresetn === 1)begin   
          if (wvalid == 1'b0) @(axi_master_cb);
          while (axi_master_cb.wready !== 1'b1) begin
             if(axi_master_cb.aresetn === 1'b0)begin
               axi_master_cb.wvalid <= 0;     
               break;
             end        
             else axi_master_cb.wvalid <= 1;
             @(axi_master_cb);
          end        
        end
        if(axi_master_cb.aresetn === 0)begin            
            num = t.burst_length - count ;
            for(int i=0; i < num; i++)begin
              axi_master_cb.wdata  <= axi_master_cb.wdata;
              axi_master_cb.wstrb  <= 0;
              axi_master_cb.wvalid <= 0;
              @(axi_master_cb);
            end
          break;
        end       
      end
     axi_master_cb.wdata <= 0;
     axi_master_cb.wvalid <= 1'b0;
     axi_master_cb.wstrb <= 0;
     axi_master_cb.wlast <= 1'b0;

   endtask : m_w


   task automatic m_b (ref axi_seq_item t);
 
      if (t.delay_vars.m_b_start_delay === 0) begin
         axi_master_cb.bready <= 1'b1;
         @(axi_master_cb);
      end
      
      while (axi_master_cb.bvalid !== 1'b1) begin
         @(axi_master_cb);
      end

      if (t.delay_vars.m_b_start_delay > 0) begin
         repeat(t.delay_vars.m_b_start_delay) @(axi_master_cb);
         axi_master_cb.bready <= 1'b1;
         @(axi_master_cb);
      end

      t.id = axi_master_cb.bid;
      t.bresp = axi_master_cb.bresp;
      axi_master_cb.bready <= 1'b0;

   endtask : m_b


   task automatic m_ar (ref axi_seq_item t);

      repeat(t.delay_vars.m_ar_start_delay) @(axi_master_cb);

      axi_master_cb.arid <= t.id;
      axi_master_cb.araddr <= t.addr;
      axi_master_cb.arsize <= $clog2(t.tr_size_in_bytes);
      axi_master_cb.arlen <= t.burst_length-1;
      axi_master_cb.arburst <= 2'b01; //TODO: ATM INCR BURST SUPPORTED ONLY
      axi_master_cb.arvalid <= (axi_master_cb.aresetn) ? 1'b1 : 1'b0;
      @(axi_master_cb);

      if(axi_master_cb.aresetn === 1)begin   
        axi_master_cb.arvalid <= 1;      
        if (arvalid == 1'b0)
         @(axi_master_cb);
         while (axi_master_cb.arready !== 1'b1) begin
            if(axi_master_cb.aresetn === 1'b0)begin
               axi_master_cb.arvalid <= 0;
               break;
            end
            else axi_master_cb.arvalid <= 1;
            @(axi_master_cb);
         end
            if(axi_master_cb.aresetn === 1'b0) axi_master_cb.awvalid <= 0;
            else axi_master_cb.awvalid <= 1;
       end
       else begin
           axi_master_cb.wvalid <= 1'b0; 
           @(axi_master_cb);
          // break;
       end     

      axi_master_cb.arid <= 0;
      axi_master_cb.arvalid <= 1'b0;
      axi_master_cb.araddr <= 0;
      axi_master_cb.arsize <= 0;
      axi_master_cb.arlen <= 0;
      axi_master_cb.arburst <= 0;
   endtask : m_ar

   task automatic m_r (ref axi_seq_item t);
      automatic int i = 0;
      t.data = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];
      t.rresp = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];

      if (t.delay_vars.m_r_start_delay === 0) axi_master_cb.rready <= 1'b1;

      forever begin

         if (i > 0) begin
            //repeat(t.delay_vars.m_r_beat_delay) @(axi_master_cb);
	    repeat(2) @(axi_master_cb);
            axi_master_cb.rready <= 1'b1;
         end
         
         @(axi_master_cb);

         while (axi_master_cb.rvalid !== 1'b1) begin
            @(axi_master_cb);
         end

         if (i < 1 && t.delay_vars.m_r_start_delay > 0) begin
            repeat(t.delay_vars.m_r_start_delay) @(axi_master_cb);
            axi_master_cb.rready <= 1'b1;
            @(axi_master_cb);
         end

         axi_master_cb.rready <= 1'b0;
         t.id = axi_master_cb.rid;
         t.data[i] = axi_master_cb.rdata;
         t.rresp[i] = axi_master_cb.rresp;
         i++;

         if (axi_master_cb.rlast === 1'b1 || !(t.use_last_signaling)) break;
      end
      
      t.burst_length = i;

   endtask : m_r
   
   /*task check_reset();
   //  forever begin
     while(axi_monitor_cb.aresetn === 1)@(axi_monitor_cb);
    // break;
   //  end
   endtask*/


   task automatic mon_aw (ref axi_seq_item t);
  // int burst_value;
      while(axi_monitor_cb.awvalid !== 1'b1) @(axi_monitor_cb);
      t.start_time = $realtime();
      while(axi_monitor_cb.awready !== 1'b1) @(axi_monitor_cb);
      if (axi_monitor_cb.awvalid === 1'b1) begin
         t.id = axi_monitor_cb.awid;
         t.addr = axi_monitor_cb.awaddr;
         t.tr_size_in_bytes = 2**axi_monitor_cb.awsize;
         t.burst_length = axi_monitor_cb.awlen;
        // burst_value = axi_monitor_cb.awlen;

        $display($time,"@@@@@@@@@@@@@@@@@_mon_aw burst_length =%0d aw_len=%0d",t.burst_length,axi_monitor_cb.awlen);
         t.size = axi_monitor_cb.awsize;
         t.burst_type = axi_monitor_cb.awburst;
         t.prot = axi_monitor_cb.awprot;
        
      //   t.data = new[()+1];
       //  t.byte_en = new[(axi_monitor_cb.awlen)+1];
        
         $display($time,"!!!!!!!!!!!!!!! mon_aw data_size =%0d stobe_size=%0d",t.data.size,t.byte_en.size);
       
      end else begin
            `uvm_error("AXI MONITOR :: AW", "AWVALID lowered before AWREADY was set")
      end
   endtask : mon_aw

     // t.data = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];
     // t.byte_en = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];

   task automatic mon_w (ref axi_seq_item t);
      automatic int i = 0;
      bit [1023:0] qu_data[$];    
      bit [1023:0] qu_storb[$];      
      bit [7:0] qu_8_data[$];      
      bit [1023:0] temp_data; 
      bit [1023:0] temp,temp1,shift,vale,data;
      int storb;   
      int data_size_in_bytes=0;             

      forever begin
         while (axi_monitor_cb.wvalid !== 1'b1) @(axi_monitor_cb);
         while (axi_monitor_cb.wready !== 1'b1) @(axi_monitor_cb);
         if (axi_monitor_cb.wvalid === 1'b1) begin
            qu_data.push_back(axi_monitor_cb.wdata); 
            $display($time,"data_write_queue_array =%0p",qu_data);
            $display($time,"data_write_queue =%0h",axi_monitor_cb.wdata);
            qu_storb.push_back(axi_monitor_cb.wstrb);  
            i++;
            //check for reset
            if(axi_monitor_cb.aresetn === 1'b0)begin
            qu_data.delete();
            qu_storb.delete();
            break;
	    end
            if (axi_monitor_cb.wlast === 1'b1 || !(t.use_last_signaling)) begin
              t.byte_en =new[qu_storb.size()];
              t.data =new[qu_data.size()];
              foreach(t.byte_en[i]) t.byte_en[i] = qu_storb.pop_front();
              foreach(t.data[i]) t.data[i] = qu_data.pop_front();
              
            for(int i=0;i<t.data.size;i++)
            begin
              temp_data = t.data[i];
              for(int j=0;j<$size(axi_monitor_cb.wstrb);j++) 
              begin
                 if(t.byte_en[i][j]==1'b1) qu_8_data.push_front(temp_data[j*8+:8]);
              end
            end
            
              t.data =new[qu_8_data.size()];
              foreach(t.data[i]) t.data[i] = qu_8_data.pop_back();
              //foreach(t.byte_en[i])   
              //begin 
              //   foreach(t.byte_en[i][j]) if(t.byte_en[i][j] == 1'b1) data_size_in_bytes++; 
              //end
              //t.data =new[data_size_in_bytes];

              //foreach(t.data[i]) begin
	      //  temp_data = qu_data.pop_front();
              //  foreach(t.byte_en[i][j])
              //  begin
              //     if(t.byte_en[i][j] == 1'b1)    t.data[i]         = temp_data[j*8+:8];
              //     //else                           t.data[i][j*8+:8] = 8'h00;
              //  end
              //  $display($time,"##################$$$$$$$$$$$$$$$ data write[%0d] =%0d",i,t.data[i]);
              //end
              //data_size_in_bytes = 0;
            //if (axi_monitor_cb.wlast === 1'b1 || !(t.use_last_signaling)) begin
            //  
            //  t.data =new[qu_data.size()];
            //  
            //  t.byte_en =new[qu_storb.size()];
            //  $display($time,"mon_w data_size =%0d stobe_size=%0d",t.data.size,t.byte_en.size);
            //  foreach(t.data[i])begin
            //  storb = qu_storb[i]; 
	    //  temp1 = (8*storb);
            //  shift = 1 << temp1;
            //  vale = shift -1;
	    //  temp =  qu_data.pop_front();
            //  data = temp & vale;
	    //  t.data[i] = data;
            //  $display($time,"##################$$$$$$$$$$$$$$$ data write[%0d] =%0d",i,t.data[i]);
            //  end
            //  foreach(t.byte_en[i]) t.byte_en[i] = qu_storb.pop_front();
              break;

            end
            else begin
               @(axi_monitor_cb);
            end
         end
            else begin
            `uvm_fatal("AXI MONITOR :: W", "WVALID lowered before WREADY was set")
            end
       end
   endtask : mon_w

   task automatic mon_b (ref axi_seq_item t);
      while (axi_monitor_cb.bvalid !== 1'b1) @(axi_monitor_cb);
      while (axi_monitor_cb.bready !== 1'b1) @(axi_monitor_cb);
      if (axi_monitor_cb.bvalid === 1'b1) begin
      t.id = axi_monitor_cb.bid;
      t.bresp = axi_monitor_cb.bresp;
      t.end_time= $realtime();
      end else begin
         `uvm_fatal("AXI MONITOR :: B", "BVALID lowered before BREADY was set")
      end
   endtask : mon_b

   task automatic mon_ar (ref axi_seq_item t);
      while (axi_monitor_cb.arvalid !== 1'b1) @(axi_monitor_cb);
      t.start_time = $realtime();
      while (axi_monitor_cb.arready !== 1'b1) @(axi_monitor_cb);
      if (axi_monitor_cb.arvalid === 1'b1) begin
         t.addr = axi_monitor_cb.araddr;
         t.size = axi_monitor_cb.arsize;
         t.tr_size_in_bytes = 2**axi_monitor_cb.arsize;
         t.burst_length = axi_monitor_cb.arlen;
         t.burst_type = axi_monitor_cb.arburst;
         t.id = axi_monitor_cb.arid;
      end else begin
         `uvm_error("AXI MONITOR :: AR", "ARVALID lowered before ARREADY was set")
      end
   endtask : mon_ar

   task automatic mon_r (ref axi_seq_item t);
      automatic int i = 0;
      bit [1023:0] qu_data [$];    
      bit [1023:0] qu_resp[$];      
                     
      forever begin
         while (axi_monitor_cb.rvalid !== 1'b1) @(axi_monitor_cb);
         while (axi_monitor_cb.rready !== 1'b1) @(axi_monitor_cb);
         if (axi_monitor_cb.rvalid === 1'b1) begin
            qu_data.push_back(axi_monitor_cb.rdata); 
            qu_resp.push_back(axi_monitor_cb.rresp);  
            t.id = axi_monitor_cb.rid;
            i++;
            if(axi_monitor_cb.aresetn === 1'b0)begin
            qu_data.delete();
            qu_resp.delete();
            break;
	    end

            if (axi_monitor_cb.rlast === 1'b1 || !(t.use_last_signaling)) begin
              
               t.data =new[qu_data.size()];
               t.rresp =new[qu_resp.size()];
               foreach(t.data[i])begin
	          t.data[i] = qu_data.pop_front();
                 // $display($time,"##################$$$$$$$$$$$$$$$ data read[%0d] =%0d",i,t.data[i]);
               end
               foreach(t.rresp[i]) t.rresp[i] = qu_resp.pop_front();

               t.end_time = $realtime();
               break;
            end
            else begin
               @(axi_monitor_cb);
            end
         end
         else begin
            `uvm_fatal("AXI MONITOR :: R", "RVALID lowered before RREADY was set")
         end
      end
   endtask : mon_r

   task automatic s_aw (ref axi_seq_item t);

      if(t.delay_vars.s_aw_start_delay === 0) begin
         axi_slave_cb.awready <= 1'b1;
         @(axi_slave_cb);
      end
      
      while (axi_slave_cb.awvalid !== 1'b1) begin
         @(axi_slave_cb);   
      end
      
      if(t.delay_vars.s_aw_start_delay > 0) begin
         repeat (t.delay_vars.s_aw_start_delay-1) @(axi_slave_cb);
         axi_slave_cb.awready <= 1'b1;
         @(axi_slave_cb);
      end
      
      if (axi_slave_cb.awvalid === 1'b1) begin
         t.addr = axi_slave_cb.awaddr;
         t.size = axi_slave_cb.awsize;
         t.tr_size_in_bytes = 2**axi_slave_cb.awsize;
         t.burst_length = axi_slave_cb.awlen;
         t.burst_type = axi_slave_cb.awburst;
         t.id = axi_slave_cb.awid;
      end
      axi_slave_cb.awready <= 1'b0;
   endtask : s_aw

  task automatic s_w (ref axi_seq_item t);
      automatic int i = 0;
      t.data = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];
      t.byte_en = new[`AXI_VIP_MAX_BURST_LENGTH_INCR];

      if (t.delay_vars.s_w_start_delay === 0) axi_slave_cb.wready <= 1'b1;

      forever begin

         if(i > 0) begin
            repeat(t.delay_vars.s_w_beat_delay) @(axi_slave_cb);
            axi_slave_cb.wready <= 1'b1;
         end
         
         @(axi_slave_cb);

         while (axi_slave_cb.wvalid !== 1'b1) begin
            @(axi_slave_cb);
         end

         if (i < 1 && t.delay_vars.s_w_start_delay > 0) begin
            repeat(t.delay_vars.s_w_start_delay-1) @(axi_slave_cb);
            axi_slave_cb.wready <= 1'b1;
            @(axi_slave_cb);
         end

         axi_slave_cb.wready <= 1'b0;
         t.data[i] = axi_slave_cb.wdata;
         t.byte_en[i] = axi_slave_cb.wstrb;
         i++;
         if (axi_slave_cb.wlast === 1'b1 || !(t.use_last_signaling)) break;
      end
   endtask : s_w

   task automatic s_b (ref axi_seq_item t);

      repeat (t.delay_vars.s_b_start_delay) @(axi_slave_cb);
      if(axi_slave_cb.aresetn ===1)begin      
        axi_slave_cb.bvalid <= 1'b1;
        axi_slave_cb.bid <= t.id;
        axi_slave_cb.bresp <= t.bresp;
      end
      else begin
        axi_slave_cb.bvalid <= 1'b0;
        axi_slave_cb.bid <= axi_slave_cb.bid ;
        axi_slave_cb.bresp <= axi_slave_cb.bresp;
      end
      //axi_slave_cb.bvalid <= (axi_slave_cb.aresetn) ? 1'b1 : 1'b0;
     // $display($time,"@@@@valid=%0d",axi_slave_cb.bvalid);

      @(axi_slave_cb);
      if(axi_slave_cb.aresetn ===1)begin
        axi_slave_cb.bvalid <= 1;
        if(bvalid == 0) @(axi_slave_cb);
        while (axi_slave_cb.bready !== 1'b1)begin
          if(axi_slave_cb.aresetn === 1'b0) begin
           axi_slave_cb.bvalid <= 0;
           break;
          end
          else axi_slave_cb.bvalid <= 1;
          @(axi_slave_cb);
        end
         //if(axi_slave_cb.aresetn === 1'b0) axi_slave_cb.bvalid <= 0;
         //else axi_slave_cb.bvalid <= 1;
      end

     
      axi_slave_cb.bvalid <= 1'b0;
      axi_slave_cb.bid <= 0;
      axi_slave_cb.bresp <= 0;
   endtask : s_b

 
 /*   task automatic s_b (ref axi_seq_item t);

      repeat (t.delay_vars.s_b_start_delay) @(axi_slave_cb);
      $display($time,"@@@@@@@@@response");
      axi_slave_cb.bvalid <= 1'b1;
      axi_slave_cb.bid <= t.id;
      axi_slave_cb.bresp <= t.bresp;

      @(axi_slave_cb);
      if(bvalid == 0) @(axi_slave_cb);
      while (!(axi_slave_cb.bready === 1'b1)) @(axi_slave_cb);

      axi_slave_cb.bvalid <= 1'b0;
      axi_slave_cb.bid <= 0;
      axi_slave_cb.bresp <= 0;
   endtask : s_b*/

  

  /*task automatic s_b (ref axi_seq_item t);

      repeat (t.delay_vars.s_b_start_delay) @(axi_slave_cb);
      $display($time,"@@@@@@@@@response");
     // axi_slave_cb.bvalid <= 1'b1;
      axi_slave_cb.bid <= t.id;
      axi_slave_cb.bresp <= t.bresp;
      axi_slave_cb.bvalid <= (axi_slave_cb.aresetn) ? 1'b1 : 1'b0;
      $display($time,"@@@@valid=%0d",axi_slave_cb.bvalid);

      @(axi_slave_cb);
      if(axi_slave_cb.aresetn ===1)begin
      axi_slave_cb.bvalid <= 1;
      if(bvalid == 0) @(axi_slave_cb);
      while (!(axi_slave_cb.bready === 1'b1))begin
        if(axi_slave_cb.aresetn === 1'b0) begin
         axi_slave_cb.bvalid <= 0;
         break;
        end
        else axi_slave_cb.bvalid <= 1;
        @(axi_slave_cb);
      end
       if(axi_slave_cb.aresetn === 1'b0) axi_slave_cb.bvalid <= 0;
        else axi_slave_cb.bvalid <= 1;
      end
      else
        axi_slave_cb.bvalid <= 0;

      axi_slave_cb.bvalid <= 1'b0;
      axi_slave_cb.bid <= 0;
      axi_slave_cb.bresp <= 0;
   endtask : s_b*/



  /* task automatic s_b (ref axi_seq_item t);

        $display("from_slave_bresp");
     // if(axi_slave_cb.aresetn===1)begin

        repeat (t.delay_vars.s_b_start_delay) @(axi_slave_cb);
        axi_slave_cb.bid <= t.id;
        axi_slave_cb.bresp <= t.bresp;

        $display("from_slave_bresp_1");
        /*if(axi_slave_cb.aresetn==0)
          axi_slave_cb.bvalid <= 1'b0;
        else
        axi_slave_cb.bvalid <= 1'b1;
        
        @(axi_slave_cb);
        if(bvalid == 0) @(axi_slave_cb);
        while (!(axi_slave_cb.bready === 1'b1)) @(axi_slave_cb);
         
        axi_slave_cb.bvalid <= 1'b0;
        axi_slave_cb.bid <= 0;
        axi_slave_cb.bresp <= 0;
     // end
  
      if(axi_slave_cb.aresetn===0)begin
        $display("from_slave_bresp_2");
      axi_slave_cb.bvalid <= 1'b0;
      axi_slave_cb.bid <= t.id;
      axi_slave_cb.bresp <= t.bresp;
      /*if(axi_slave_cb.aresetn==1)begin
        axi_slave_cb.bvalid <= 1'b1;
      end
      end
   endtask : s_b*/
   task automatic s_ar (ref axi_seq_item t);
    

      if (t.delay_vars.s_ar_start_delay === 0) begin
        //repeat(10) @(axi_slave_cb);
         axi_slave_cb.arready <= 1'b1;
         @(axi_slave_cb);
      end
      
      while (axi_slave_cb.arvalid !== 1'b1) begin
         @(axi_slave_cb);
      end
      
      if(t.delay_vars.s_ar_start_delay > 0) begin
         repeat(t.delay_vars.s_ar_start_delay-1) @(axi_slave_cb);
         axi_slave_cb.arready <= 1'b1;
         @(axi_slave_cb);
      end

      if (axi_slave_cb.arvalid === 1'b1) begin
         t.addr = axi_slave_cb.araddr;
         t.size = axi_slave_cb.arsize;
         t.tr_size_in_bytes = 2**axi_slave_cb.arsize;
         t.burst_length = axi_slave_cb.arlen;
         t.burst_type = axi_slave_cb.arburst;
         t.id = axi_slave_cb.arid;
      end
      axi_slave_cb.arready <= 1'b0;
   endtask : s_ar

  /* task automatic s_r (ref axi_seq_item t);
      logic temp,rst;
      repeat(t.delay_vars.s_r_start_delay) @(axi_slave_cb);

      for(int i = 0; i < t.burst_length; i++) begin

         if(i > 0)
	   begin
	     repeat(t.delay_vars.s_r_beat_delay) @(axi_slave_cb);
	     //repeat(5) @(axi_slave_cb);
	   end

        // axi_slave_cb.rvalid <= 1'b1;
          if(axi_slave_cb.aresetn === 1 && i==0) begin
           temp = 1;
           axi_slave_cb.rvalid <=1;
          end
          else if(axi_slave_cb.aresetn === 0 && i==0) begin
           temp = 0;
           axi_slave_cb.rvalid <=0;   
          end          
        if(axi_slave_cb.aresetn === 1)begin
         axi_slave_cb.rdata <= t.data[i];
         axi_slave_cb.rid <= t.id;
         axi_slave_cb.rresp <= t.rresp[i];
        end
        else begin
         axi_slave_cb.rdata <= axi_slave_cb.rdata;
         axi_slave_cb.rid <= t.id;
         axi_slave_cb.rresp <= t.rresp[i];
        end

        
        // axi_slave_cb.rvalid <= (axi_master_cb.aresetn) ? 1'b1 : 1'b0;
         
         if (i == t.burst_length-1) axi_slave_cb.rlast <= 1'b1;

         @(axi_slave_cb);
         if (axi_slave_cb.rlast == 1) begin
           break;
         end

         if(!temp && i < t.burst_length)begin
           axi_slave_cb.rvalid <=0;
         end
         else begin
               
         if(axi_slave_cb.aresetn === 1 && !rst)begin          
            axi_slave_cb.rvalid <= 1;
            if (rvalid == 1'b0)
               @(axi_slave_cb);

            while (axi_slave_cb.rready !== 1'b1) begin
	       if(axi_slave_cb.aresetn === 1'b0)begin
                 axi_slave_cb.rvalid <= 0;     
                 break;
               end        
               else axi_slave_cb.rvalid <= 1;
               @(axi_slave_cb);
            end
            if(axi_slave_cb.aresetn === 1'b0) axi_slave_cb.rvalid <= 0;
            else axi_slave_cb.rvalid <= 1;
         end
         else begin 
            rst = 1;
            axi_slave_cb.rvalid <= 1'b0;
         end
         end
      end
         axi_slave_cb.rdata <= 0;
         axi_slave_cb.rid <= 0;
         axi_slave_cb.rlast <= 1'b0;
         axi_slave_cb.rresp <= 0;
         axi_slave_cb.rvalid <= 1'b0;

   endtask : s_r*/


   task automatic s_r (ref axi_seq_item t);
      bit rst;
      int count;
      int num;

      repeat(t.delay_vars.s_r_start_delay) @(axi_slave_cb);

      for(int i = 0; i < t.burst_length; i++) begin
                        
        if(axi_slave_cb.aresetn === 1)begin
          count ++;
          axi_slave_cb.rdata <= t.data[i];
          axi_slave_cb.rid <= t.id;
          axi_slave_cb.rresp <= t.rresp[i];
          axi_slave_cb.rvalid <=1;         
        end
        else begin
          for(int i = 0; i < t.burst_length; i++) begin
            axi_slave_cb.rdata <= 0;
            axi_slave_cb.rid <= t.id;
            axi_slave_cb.rresp <= t.rresp[i];
            axi_slave_cb.rvalid <=0;
           // if (i == t.burst_length-1) axi_slave_cb.rlast <= 1'b1;
            @(axi_slave_cb);
          end
          break;
        end
        
        if (i == t.burst_length-1) axi_slave_cb.rlast <= 1'b1;

        @(axi_slave_cb);
        if (axi_slave_cb.rlast === 1) begin
          axi_slave_cb.rlast <= 1'b0;
          axi_slave_cb.rvalid <= 0;               
          break;
        end

        if(axi_slave_cb.aresetn === 1)begin   
          if (rvalid == 1'b0) @(axi_slave_cb);
          while (axi_slave_cb.rready !== 1'b1) begin
             if(axi_slave_cb.aresetn === 1'b0)begin
               axi_slave_cb.rvalid <= 0;     
               break;
             end        
             else axi_slave_cb.rvalid <= 1;
             @(axi_slave_cb);
          end        
        end
        if(axi_slave_cb.aresetn === 0)begin            
           // rst 		<= 1;  
            num = t.burst_length - count ;
            for(int i=0; i < num; i++)begin
              axi_slave_cb.rdata  <= axi_slave_cb.rdata;
              axi_slave_cb.rid    <= t.id;
              axi_slave_cb.rresp  <= axi_slave_cb.rresp  ;
              axi_slave_cb.rvalid <= 0;
              //if (i == num-1) axi_slave_cb.rlast <= 1'b1;
              @(axi_slave_cb);
            end
          //end
          break;
        end        
      end
         axi_slave_cb.rdata <= 0;
         axi_slave_cb.rid <= 0;
         axi_slave_cb.rlast <= 1'b0;
         axi_slave_cb.rresp <= 0;
         axi_slave_cb.rvalid <= 1'b0;
     // end

   endtask : s_r


endinterface

`endif

