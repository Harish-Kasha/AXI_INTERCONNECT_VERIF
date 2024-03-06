`timescale 1ns / 1ps
module tb;

	      parameter S_COUNT =4;
	      parameter M_COUNT =6;
	      parameter  int M_R_D_WIDTH[6]=  {32'd16,32'd8,32'd32,32'd64,32'd32,32'd32};
              parameter  int M_W_D_WIDTH[6] = '{32'd32, 32'd64, 32'd32, 32'd64, 32'd32, 32'd32};
              parameter  int M_A_WIDTH[6] = '{32'd12, 32'd13, 32'd14, 32'd20, 32'd13, 32'd13};
              parameter  int S_R_D_WIDTH[4] = '{32'd16, 32'd32, 32'd32, 32'd32};
              parameter  int S_W_D_WIDTH[4] = '{32'd32, 32'd16, 32'd32, 32'd32};
              parameter int S_STRB_WIDTH[4] = '{4, 2, 4, 4};
              parameter int M_STRB_WIDTH[6] = '{4, 8, 4, 8, 4, 4};

              parameter  int S_ID_WIDTH[4] = '{32'd6, 32'd8, 32'd10, 32'd12};

	      parameter S_A_WIDTH=21;
	      parameter M_ID_WIDTH=14;
	      parameter CROSSBAR_D_WIDTH=32;
	      parameter CROSSBAR_STRB_WIDTH=CROSSBAR_D_WIDTH/8;
	      parameter CROSSBAR_ACCEPT_LIMIT=4;
	      parameter CROSSBAR_ISSUSE_LIMIT=4;
	      parameter AW_USER_ENABLE=0;
	      parameter AWUSER_WIDTH = 1;
	      parameter WUSER_ENABLE = 0;
              parameter WUSER_WIDTH = 1;
              parameter BUSER_ENABLE = 0;
              parameter BUSER_WIDTH = 1;
              parameter ARUSER_ENABLE = 0;
              parameter ARUSER_WIDTH = 1;
              parameter RUSER_ENABLE = 0;
              parameter RUSER_WIDTH = 1;
parameter SUM_S_ID_WIDTH =36; 
parameter SUM_M_R_D_WIDTH=184; 
parameter SUM_M_W_D_WIDTH=256; 
parameter SUM_M_A_WIDTH=85; 
parameter SUM_S_R_D_WIDTH=112; 
parameter SUM_S_W_D_WIDTH=112; 
parameter SUM_S_STRB_WIDTH=14;
parameter SUM_M_STRB_WIDTH=24; 
parameter SUM_CROSSBAR_STRB_WIDTH=24; 
parameter MAX_S_ID_WIDTH=12;
parameter COUPLER_REG_INSTANCE=0;
parameter MAX_M_A_WIDTH=20;


    reg                              clk;
    reg                              rst;
    reg   [SUM_S_ID_WIDTH-1:0]     s_axi_awid;
    reg   [S_COUNT*S_A_WIDTH-1:0]   s_axi_awaddr;
    reg   [S_COUNT*8-1:0]            s_axi_awlen;
    reg   [S_COUNT*3-1:0]            s_axi_awsize;
    reg   [S_COUNT*2-1:0]            s_axi_awburst;
    reg   [S_COUNT-1:0]              s_axi_awlock;
    reg   [S_COUNT*4-1:0]            s_axi_awcache;
    reg   [S_COUNT*3-1:0]            s_axi_awprot;
    reg   [S_COUNT*4-1:0]            s_axi_awqos;
    reg   [S_COUNT*AWUSER_WIDTH-1:0] s_axi_awuser;
    reg   [S_COUNT-1:0]              s_axi_awvalid;
    wire  [S_COUNT-1:0]              s_axi_awready;
    reg   [SUM_S_W_D_WIDTH-1:0]   s_axi_wdata;
    reg   [SUM_S_STRB_WIDTH-1:0]   s_axi_wstrb;
    reg   [S_COUNT-1:0]              s_axi_wlast;
    reg   [S_COUNT*WUSER_WIDTH-1:0]  s_axi_wuser;
    reg   [S_COUNT-1:0]              s_axi_wvalid;
    wire  [S_COUNT-1:0]              s_axi_wready;
    wire  [SUM_S_ID_WIDTH-1:0]     s_axi_bid;
    wire  [S_COUNT*2-1:0]            s_axi_bresp;
    wire  [S_COUNT*BUSER_WIDTH-1:0]  s_axi_buser;
    wire  [S_COUNT-1:0]              s_axi_bvalid;
    reg   [S_COUNT-1:0]              s_axi_bready;
    reg   [SUM_S_ID_WIDTH-1:0]     s_axi_arid;
    reg   [S_COUNT*S_A_WIDTH-1:0]   s_axi_araddr;
    reg   [S_COUNT*8-1:0]            s_axi_arlen;
    reg   [S_COUNT*3-1:0]            s_axi_arsize;
    reg   [S_COUNT*2-1:0]            s_axi_arburst;
    reg   [S_COUNT-1:0]              s_axi_arlock;
    reg   [S_COUNT*4-1:0]            s_axi_arcache;
    reg   [S_COUNT*3-1:0]            s_axi_arprot;
    reg   [S_COUNT*4-1:0]            s_axi_arqos;
    reg   [S_COUNT*ARUSER_WIDTH-1:0] s_axi_aruser;
    reg   [S_COUNT-1:0]              s_axi_arvalid;
    wire  [S_COUNT-1:0]              s_axi_arready;
    wire  [SUM_S_ID_WIDTH-1:0]     s_axi_rid;
    wire  [SUM_S_R_D_WIDTH-1:0]   s_axi_rdata;
    wire  [S_COUNT*2-1:0]            s_axi_rresp;
    wire  [S_COUNT-1:0]              s_axi_rlast;
    wire  [S_COUNT*RUSER_WIDTH-1:0]  s_axi_ruser;
    wire  [S_COUNT-1:0]              s_axi_rvalid;
    reg   [S_COUNT-1:0]              s_axi_rready;

    /*
     * AXI er interfaces
     */
    wire  [M_COUNT*M_ID_WIDTH-1:0]     m_axi_awid;
    wire  [SUM_M_A_WIDTH-1:0]   m_axi_awaddr;
    wire  [M_COUNT*8-1:0]            m_axi_awlen;
    wire  [M_COUNT*3-1:0]            m_axi_awsize;
    wire  [M_COUNT*2-1:0]            m_axi_awburst;
    wire  [M_COUNT-1:0]              m_axi_awlock;
    wire  [M_COUNT*4-1:0]            m_axi_awcache;
    wire  [M_COUNT*3-1:0]            m_axi_awprot;
    wire  [M_COUNT*4-1:0]            m_axi_awqos;
    wire  [M_COUNT*4-1:0]            m_axi_awregion;
    wire  [M_COUNT*AWUSER_WIDTH-1:0] m_axi_awuser;
    wire  [M_COUNT-1:0]              m_axi_awvalid;
    reg   [M_COUNT-1:0]              m_axi_awready;
    wire  [SUM_M_W_D_WIDTH-1:0]     m_axi_wdata;
    wire  [SUM_M_STRB_WIDTH-1:0]    m_axi_wstrb;
    wire  [M_COUNT-1:0]              m_axi_wlast;
    wire  [M_COUNT*WUSER_WIDTH-1:0]  m_axi_wuser;
    wire  [M_COUNT-1:0]              m_axi_wvalid;
    reg   [M_COUNT-1:0]              m_axi_wready;
    reg   [M_COUNT*M_ID_WIDTH-1:0]   m_axi_bid;
    reg   [M_COUNT*2-1:0]            m_axi_bresp;
    reg   [M_COUNT*BUSER_WIDTH-1:0]  m_axi_buser;
    reg   [M_COUNT-1:0]              m_axi_bvalid;
    wire  [M_COUNT-1:0]              m_axi_bready;
    wire  [M_COUNT*M_ID_WIDTH-1:0]   m_axi_arid;
    wire  [SUM_M_A_WIDTH-1:0]       m_axi_araddr;
    wire  [M_COUNT*8-1:0]            m_axi_arlen;
    wire  [M_COUNT*3-1:0]            m_axi_arsize;
    wire  [M_COUNT*2-1:0]            m_axi_arburst;
    wire  [M_COUNT-1:0]              m_axi_arlock;
    wire  [M_COUNT*4-1:0]            m_axi_arcache;
    wire  [M_COUNT*3-1:0]            m_axi_arprot;
    wire  [M_COUNT*4-1:0]            m_axi_arqos;
    wire  [M_COUNT*4-1:0]            m_axi_arregion;
    wire  [M_COUNT*ARUSER_WIDTH-1:0] m_axi_aruser;
    wire  [M_COUNT-1:0]              m_axi_arvalid;
    reg   [M_COUNT-1:0]              m_axi_arready;
    reg   [M_COUNT*M_ID_WIDTH-1:0]   m_axi_rid;
    reg   [SUM_M_R_D_WIDTH-1:0]     m_axi_rdata;
    reg   [M_COUNT*2-1:0]            m_axi_rresp;
    reg   [M_COUNT-1:0]              m_axi_rlast;
    reg   [M_COUNT*RUSER_WIDTH-1:0]  m_axi_ruser;
    reg   [M_COUNT-1:0]              m_axi_rvalid;
    wire  [M_COUNT-1:0]              m_axi_rready;


axi_interconnect_wrapper dut(.*);

initial
begin
clk =0; rst = 1;
#100;
rst=0;

       s_axi_awid={{42{1'd1}},{6'd0}};
       s_axi_awaddr='d0;
         s_axi_awlen='d0;
         s_axi_awsize='d0;
         s_axi_awburst='d0;
         s_axi_awlock='d0;
         s_axi_awcache='d0;
         s_axi_awprot='d0;
         s_axi_awqos='d0;
     s_axi_awuser='d0;
         s_axi_awvalid={S_COUNT{1'd1}};
      s_axi_wdata='d4;
       s_axi_wstrb='d1;
         s_axi_wlast='d0;
      s_axi_wuser='d0;
         s_axi_wvalid={S_COUNT{1'd1}};
         s_axi_bready={S_COUNT{1'b1}};
       s_axi_arid='d0;
       s_axi_araddr='d0;
         s_axi_arlen='d0;
         s_axi_arsize='d0;
         s_axi_arburst='d0;
         s_axi_arlock='d0;
         s_axi_arcache='d0;
         s_axi_arprot='d0;
         s_axi_arqos='d0;
     s_axi_aruser='d0;
         s_axi_arvalid='d1;
         s_axi_rready={S_COUNT{1'b1}};

    
    
    
       m_axi_awready={M_COUNT{1'd1}};
       m_axi_wready={M_COUNT{1'd1}};
       m_axi_bid='d0;
       m_axi_bresp='d0;
       m_axi_buser='d0;
       m_axi_bvalid='d0;
       m_axi_arready={M_COUNT{1'd1}};
       m_axi_rid='d0;
       m_axi_rdata='d0;
       m_axi_rresp='d0;
       m_axi_rlast='d0;
       m_axi_ruser='d0;
       m_axi_rvalid='d0;


#1000;
$finish;
end


always #5 clk =~clk;

endmodule
