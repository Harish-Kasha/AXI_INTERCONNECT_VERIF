
import axi_interconnect_pkg::*;


module axi_interconnect_wrapper #(
	      parameter S_COUNT =4,
	      parameter M_COUNT =6,
	      parameter  int M_R_D_WIDTH[6]={32'd16,32'd8,32'd32,32'd64,32'd32,32'd32},
              parameter  int M_W_D_WIDTH[6] = '{32'd32, 32'd64, 32'd32, 32'd64, 32'd32, 32'd32},
              parameter  int M_A_WIDTH[6] = '{32'd12, 32'd13, 32'd14, 32'd20, 32'd13, 32'd13},
              parameter  int S_R_D_WIDTH[4] = '{32'd16, 32'd32, 32'd32, 32'd32},
              parameter  int S_W_D_WIDTH[4] = '{32'd32, 32'd16, 32'd32, 32'd32},
              parameter int S_STRB_WIDTH[4] = '{4, 2, 4, 4},
              parameter int M_STRB_WIDTH[6] = '{4, 8, 4, 8, 4, 4},

              parameter  int S_ID_WIDTH[4] = '{32'd6, 32'd8, 32'd10, 32'd12},

	      parameter S_A_WIDTH=21,
	      parameter M_ID_WIDTH=14,
	      parameter CROSSBAR_D_WIDTH=32,
	      parameter CROSSBAR_STRB_WIDTH=CROSSBAR_D_WIDTH/8,
	      parameter CROSSBAR_ACCEPT_LIMIT=4,
	      parameter CROSSBAR_ISSUSE_LIMIT=4,
	      parameter AW_USER_ENABLE=0,
	      parameter AWUSER_WIDTH = 1,
	      parameter WUSER_ENABLE = 0,
              parameter WUSER_WIDTH = 1,
              parameter BUSER_ENABLE = 0,
              parameter BUSER_WIDTH = 1,
              parameter ARUSER_ENABLE = 0,
              parameter ARUSER_WIDTH = 1,
              parameter RUSER_ENABLE = 0,
              parameter RUSER_WIDTH = 1,
parameter SUM_S_ID_WIDTH =36, 
parameter SUM_M_R_D_WIDTH=184, 
parameter SUM_M_W_D_WIDTH=256, 
parameter SUM_M_A_WIDTH=85, 
parameter SUM_S_R_D_WIDTH=112, 
parameter SUM_S_W_D_WIDTH=112, 
parameter SUM_S_STRB_WIDTH=14,
parameter SUM_M_STRB_WIDTH=24, 
parameter SUM_CROSSBAR_STRB_WIDTH=24, 
parameter MAX_S_ID_WIDTH=12,
parameter COUPLER_REG_INSTANCE=0,
parameter MAX_M_A_WIDTH=20
	      
             ) 
       
   (
	
    input  wire                            clk,
    input  wire                            rst,
    input  wire [SUM_S_ID_WIDTH-1:0]     s_axi_awid,
    input  wire [S_COUNT*S_A_WIDTH-1:0]   s_axi_awaddr,
    input  wire [S_COUNT*8-1:0]            s_axi_awlen,
    input  wire [S_COUNT*3-1:0]            s_axi_awsize,
    input  wire [S_COUNT*2-1:0]            s_axi_awburst,
    input  wire [S_COUNT-1:0]              s_axi_awlock,
    input  wire [S_COUNT*4-1:0]            s_axi_awcache,
    input  wire [S_COUNT*3-1:0]            s_axi_awprot,
    input  wire [S_COUNT*4-1:0]            s_axi_awqos,
    input  wire [S_COUNT*AWUSER_WIDTH-1:0] s_axi_awuser,
    input  wire [S_COUNT-1:0]              s_axi_awvalid,
    output wire [S_COUNT-1:0]              s_axi_awready,
    input  wire [SUM_S_W_D_WIDTH-1:0]   s_axi_wdata,
    input  wire [SUM_S_STRB_WIDTH-1:0]   s_axi_wstrb,
    input  wire [S_COUNT-1:0]              s_axi_wlast,
    input  wire [S_COUNT*WUSER_WIDTH-1:0]  s_axi_wuser,
    input  wire [S_COUNT-1:0]              s_axi_wvalid,
    output wire [S_COUNT-1:0]              s_axi_wready,
    output wire [SUM_S_ID_WIDTH-1:0]     s_axi_bid,
    output wire [S_COUNT*2-1:0]            s_axi_bresp,
    output wire [S_COUNT*BUSER_WIDTH-1:0]  s_axi_buser,
    output wire [S_COUNT-1:0]              s_axi_bvalid,
    input  wire [S_COUNT-1:0]              s_axi_bready,
    input  wire [SUM_S_ID_WIDTH-1:0]     s_axi_arid,
    input  wire [S_COUNT*S_A_WIDTH-1:0]   s_axi_araddr,
    input  wire [S_COUNT*8-1:0]            s_axi_arlen,
    input  wire [S_COUNT*3-1:0]            s_axi_arsize,
    input  wire [S_COUNT*2-1:0]            s_axi_arburst,
    input  wire [S_COUNT-1:0]              s_axi_arlock,
    input  wire [S_COUNT*4-1:0]            s_axi_arcache,
    input  wire [S_COUNT*3-1:0]            s_axi_arprot,
    input  wire [S_COUNT*4-1:0]            s_axi_arqos,
    input  wire [S_COUNT*ARUSER_WIDTH-1:0] s_axi_aruser,
    input  wire [S_COUNT-1:0]              s_axi_arvalid,
    output wire [S_COUNT-1:0]              s_axi_arready,
    output wire [SUM_S_ID_WIDTH-1:0]     s_axi_rid,
    output wire [SUM_S_R_D_WIDTH-1:0]   s_axi_rdata,
    output wire [S_COUNT*2-1:0]            s_axi_rresp,
    output wire [S_COUNT-1:0]              s_axi_rlast,
    output wire [S_COUNT*RUSER_WIDTH-1:0]  s_axi_ruser,
    output wire [S_COUNT-1:0]              s_axi_rvalid,
    input  wire [S_COUNT-1:0]              s_axi_rready,

    /*
     * AXI master interfaces
     */
    output wire [M_COUNT*M_ID_WIDTH-1:0]     m_axi_awid,
    output wire [SUM_M_A_WIDTH-1:0]   m_axi_awaddr,
    output wire [M_COUNT*8-1:0]            m_axi_awlen,
    output wire [M_COUNT*3-1:0]            m_axi_awsize,
    output wire [M_COUNT*2-1:0]            m_axi_awburst,
    output wire [M_COUNT-1:0]              m_axi_awlock,
    output wire [M_COUNT*4-1:0]            m_axi_awcache,
    output wire [M_COUNT*3-1:0]            m_axi_awprot,
    output wire [M_COUNT*4-1:0]            m_axi_awqos,
    output wire [M_COUNT*4-1:0]            m_axi_awregion,
    output wire [M_COUNT*AWUSER_WIDTH-1:0] m_axi_awuser,
    output wire [M_COUNT-1:0]              m_axi_awvalid,
    input  wire [M_COUNT-1:0]              m_axi_awready,
    output wire [SUM_M_W_D_WIDTH-1:0]     m_axi_wdata,
    output wire [SUM_M_STRB_WIDTH-1:0]    m_axi_wstrb,
    output wire [M_COUNT-1:0]              m_axi_wlast,
    output wire [M_COUNT*WUSER_WIDTH-1:0]  m_axi_wuser,
    output wire [M_COUNT-1:0]              m_axi_wvalid,
    input  wire [M_COUNT-1:0]              m_axi_wready,
    input  wire [M_COUNT*M_ID_WIDTH-1:0]   m_axi_bid,
    input  wire [M_COUNT*2-1:0]            m_axi_bresp,
    input  wire [M_COUNT*BUSER_WIDTH-1:0]  m_axi_buser,
    input  wire [M_COUNT-1:0]              m_axi_bvalid,
    output wire [M_COUNT-1:0]              m_axi_bready,
    output wire [M_COUNT*M_ID_WIDTH-1:0]   m_axi_arid,
    output wire [SUM_M_A_WIDTH-1:0]       m_axi_araddr,
    output wire [M_COUNT*8-1:0]            m_axi_arlen,
    output wire [M_COUNT*3-1:0]            m_axi_arsize,
    output wire [M_COUNT*2-1:0]            m_axi_arburst,
    output wire [M_COUNT-1:0]              m_axi_arlock,
    output wire [M_COUNT*4-1:0]            m_axi_arcache,
    output wire [M_COUNT*3-1:0]            m_axi_arprot,
    output wire [M_COUNT*4-1:0]            m_axi_arqos,
    output wire [M_COUNT*4-1:0]            m_axi_arregion,
    output wire [M_COUNT*ARUSER_WIDTH-1:0] m_axi_aruser,
    output wire [M_COUNT-1:0]              m_axi_arvalid,
    input  wire [M_COUNT-1:0]              m_axi_arready,
    input  wire [M_COUNT*M_ID_WIDTH-1:0]   m_axi_rid,
    input  wire [SUM_M_R_D_WIDTH-1:0]     m_axi_rdata,
    input  wire [M_COUNT*2-1:0]            m_axi_rresp,
    input  wire [M_COUNT-1:0]              m_axi_rlast,
    input  wire [M_COUNT*RUSER_WIDTH-1:0]  m_axi_ruser,
    input  wire [M_COUNT-1:0]              m_axi_rvalid,
    output wire [M_COUNT-1:0]              m_axi_rready
);

//    wire [SUM_S_ID_WIDTH-1:0]     internal_s_axi_bid[S_COUNT];
//// Connect the internal wire to your output port
//assign s_axi_bid = internal_s_axi_bid[0];

    wire [SUM_S_ID_WIDTH-1:0]       a_c_axi_awid;
    wire [S_COUNT*S_A_WIDTH-1:0]     a_c_axi_awaddr;
    wire [S_COUNT*8-1:0]             a_c_axi_awlen;
    wire [S_COUNT*3-1:0]             a_c_axi_awsize;
    wire [S_COUNT*2-1:0]             a_c_axi_awburst;
    wire [S_COUNT-1:0]               a_c_axi_awlock;
    wire [S_COUNT*4-1:0]             a_c_axi_awcache;
    wire [S_COUNT*3-1:0]             a_c_axi_awprot;
    wire [S_COUNT*4-1:0]             a_c_axi_awqos;
    wire [S_COUNT*AWUSER_WIDTH-1:0]  a_c_axi_awuser;
    wire [S_COUNT-1:0]               a_c_axi_awvalid;
    wire [S_COUNT-1:0]               a_c_axi_awready;
    wire [S_COUNT*CROSSBAR_D_WIDTH-1:0]      a_c_axi_wdata;
    wire [S_COUNT*CROSSBAR_D_WIDTH/8-1:0]     a_c_axi_wstrb;
    wire [S_COUNT-1:0]               a_c_axi_wlast;
    wire [S_COUNT*WUSER_WIDTH-1:0]   a_c_axi_wuser;
    wire [S_COUNT-1:0]               a_c_axi_wvalid;
    wire [S_COUNT-1:0]               a_c_axi_wready;
    reg [SUM_S_ID_WIDTH-1:0]       a_c_axi_bid;
    wire [S_COUNT*2-1:0]             a_c_axi_bresp;
    wire [S_COUNT*BUSER_WIDTH-1:0]   a_c_axi_buser;
    wire [S_COUNT-1:0]               a_c_axi_bvalid;
    wire [S_COUNT-1:0]               a_c_axi_bready;
    wire [SUM_S_ID_WIDTH-1:0]       a_c_axi_arid;
    wire [S_COUNT*S_A_WIDTH-1:0]     a_c_axi_araddr;
    wire [S_COUNT*8-1:0]             a_c_axi_arlen;
    wire [S_COUNT*3-1:0]             a_c_axi_arsize;
    wire [S_COUNT*2-1:0]             a_c_axi_arburst;
    wire [S_COUNT-1:0]               a_c_axi_arlock;
    wire [S_COUNT*4-1:0]             a_c_axi_arcache;
    wire [S_COUNT*3-1:0]             a_c_axi_arprot;
    wire [S_COUNT*4-1:0]             a_c_axi_arqos;
    wire [S_COUNT*ARUSER_WIDTH-1:0]  a_c_axi_aruser;
    wire [S_COUNT-1:0]               a_c_axi_arvalid;
    wire [S_COUNT-1:0]               a_c_axi_arready;
    reg [SUM_S_ID_WIDTH-1:0]       a_c_axi_rid;
    wire [S_COUNT*CROSSBAR_D_WIDTH-1:0]      a_c_axi_rdata;
    wire [S_COUNT*2-1:0]             a_c_axi_rresp;
    wire [S_COUNT-1:0]               a_c_axi_rlast;
    wire [S_COUNT*RUSER_WIDTH-1:0]   a_c_axi_ruser;
    wire [S_COUNT-1:0]               a_c_axi_rvalid;
    wire [S_COUNT-1:0]               a_c_axi_rready;

    /*
     * AXI master interfaces
     */
    wire [M_COUNT*M_ID_WIDTH-1:0]    c_a_axi_awid;
    reg [SUM_M_A_WIDTH-1:0]        c_a_axi_awaddr;
    wire [M_COUNT*8-1:0]             c_a_axi_awlen;
    wire [M_COUNT*3-1:0]             c_a_axi_awsize;
    wire [M_COUNT*2-1:0]             c_a_axi_awburst;
    wire [M_COUNT-1:0]               c_a_axi_awlock;
    wire [M_COUNT*4-1:0]             c_a_axi_awcache;
    wire [M_COUNT*3-1:0]             c_a_axi_awprot;
    wire [M_COUNT*4-1:0]             c_a_axi_awqos;
    wire [M_COUNT*4-1:0]             c_a_axi_awregion;
    wire [M_COUNT*AWUSER_WIDTH-1:0]  c_a_axi_awuser;
    wire [M_COUNT-1:0]               c_a_axi_awvalid;
    wire [M_COUNT-1:0]               c_a_axi_awready;
    wire [M_COUNT*CROSSBAR_D_WIDTH-1:0]      c_a_axi_wdata;
    wire [SUM_CROSSBAR_STRB_WIDTH-1:0]     c_a_axi_wstrb;
    wire [M_COUNT-1:0]               c_a_axi_wlast;
    wire [M_COUNT*WUSER_WIDTH-1:0]   c_a_axi_wuser;
    wire [M_COUNT-1:0]               c_a_axi_wvalid;
    wire [M_COUNT-1:0]               c_a_axi_wready;
    wire [M_COUNT*M_ID_WIDTH-1:0]    c_a_axi_bid;
    wire [M_COUNT*2-1:0]             c_a_axi_bresp;
    wire [M_COUNT*BUSER_WIDTH-1:0]   c_a_axi_buser;
    wire [M_COUNT-1:0]               c_a_axi_bvalid;
    wire [M_COUNT-1:0]               c_a_axi_bready;
    wire [M_COUNT*M_ID_WIDTH-1:0]    c_a_axi_arid;
    reg [SUM_M_A_WIDTH-1:0]        c_a_axi_araddr;
    wire [M_COUNT*8-1:0]             c_a_axi_arlen;
    wire [M_COUNT*3-1:0]             c_a_axi_arsize;
    wire [M_COUNT*2-1:0]             c_a_axi_arburst;
    wire [M_COUNT-1:0]               c_a_axi_arlock;
    wire [M_COUNT*4-1:0]             c_a_axi_arcache;
    wire [M_COUNT*3-1:0]             c_a_axi_arprot;
    wire [M_COUNT*4-1:0]             c_a_axi_arqos;
    wire [M_COUNT*4-1:0]             c_a_axi_arregion;
    wire [M_COUNT*ARUSER_WIDTH-1:0]  c_a_axi_aruser;
    wire [M_COUNT-1:0]               c_a_axi_arvalid;
    wire [M_COUNT-1:0]               c_a_axi_arready;
    wire [M_COUNT*M_ID_WIDTH-1:0]    c_a_axi_rid;
    logic [SUM_M_R_D_WIDTH-1:0]      c_a_axi_rdata;
    wire [M_COUNT*2-1:0]             c_a_axi_rresp;
    wire [M_COUNT-1:0]               c_a_axi_rlast;
    wire [M_COUNT*RUSER_WIDTH-1:0]   c_a_axi_ruser;
    wire [M_COUNT-1:0]               c_a_axi_rvalid;
    wire [M_COUNT-1:0]               c_a_axi_rready;



    wire [MAX_S_ID_WIDTH-1:0] adapter_crossbar_S_AW_ID[S_COUNT];
    wire [S_COUNT*MAX_S_ID_WIDTH-1:0] adapter_crossbar_S_B_ID;
    wire [MAX_S_ID_WIDTH-1:0] adapter_crossbar_S_AR_ID[S_COUNT];
    wire [S_COUNT*MAX_S_ID_WIDTH-1:0] adapter_crossbar_S_R_ID;

    wire [S_COUNT*MAX_S_ID_WIDTH-1:0] temp_adapter_crossbar_S_AW_ID;
    wire [S_COUNT*MAX_S_ID_WIDTH-1:0] temp_adapter_crossbar_S_AR_ID;

    //wire [M_COUNT*S_A_WIDTH-1:0] temp_adapter_crossbar_M_ARADDR;

    genvar k;
    generate
	    for(k=0;k<S_COUNT;k=k+1)begin
		 assign temp_adapter_crossbar_S_AW_ID[k*MAX_S_ID_WIDTH +: MAX_S_ID_WIDTH] = adapter_crossbar_S_AW_ID[k]; 
		 assign temp_adapter_crossbar_S_AR_ID[k*MAX_S_ID_WIDTH +: MAX_S_ID_WIDTH] = adapter_crossbar_S_AR_ID[k];
	    end
   endgenerate 


    genvar i;
    generate 
       for(i=0;i <S_COUNT;i=i+1) begin
          assign adapter_crossbar_S_AW_ID[i] = {{(MAX_S_ID_WIDTH-S_ID_WIDTH[i]){1'b0}},a_c_axi_awid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,i)+:S_ID_WIDTH[i]]}; 
          assign adapter_crossbar_S_AR_ID[i] = {{(MAX_S_ID_WIDTH-S_ID_WIDTH[i]){1'b0}},a_c_axi_arid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,i)+:S_ID_WIDTH[i]]};
          //assign c_a_axi_araddr[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,i)+:S_ID_WIDTH[i]] = temp_adapter_crossbar_M_ARADDR[i*S_A_WIDTH+:S_A_WIDTH];
          always@(*)  
          begin 
             a_c_axi_bid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,i)+:S_ID_WIDTH[i]] = adapter_crossbar_S_B_ID[i*MAX_S_ID_WIDTH+:MAX_S_ID_WIDTH]; 
             a_c_axi_rid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,i)+:S_ID_WIDTH[i]] = adapter_crossbar_S_R_ID[i*MAX_S_ID_WIDTH+:MAX_S_ID_WIDTH]; 
          end
       end
    endgenerate


    wire [M_COUNT*S_A_WIDTH-1:0] crossbar_adapter_M_AWADDR;
    wire [M_COUNT*S_A_WIDTH-1:0] crossbar_adapter_M_ARADDR;
    wire [M_COUNT*CROSSBAR_D_WIDTH-1:0] crossbar_adapter_M_RDATA;

    genvar j;
    generate  
       for(j=0;j <M_COUNT;j=j+1) begin
          always@(*)  
          begin 
             c_a_axi_awaddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,j)+:M_A_WIDTH[j]] = crossbar_adapter_M_AWADDR[j*S_A_WIDTH+:S_A_WIDTH]; 
             c_a_axi_araddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,j)+:M_A_WIDTH[j]] = crossbar_adapter_M_ARADDR[j*S_A_WIDTH+:S_A_WIDTH]; 
             c_a_axi_rdata[axi_interconnect_pkg::sum_up_to_index(M_R_D_WIDTH,j)+:M_R_D_WIDTH[j]] = crossbar_adapter_M_RDATA[j*CROSSBAR_D_WIDTH+:CROSSBAR_D_WIDTH]; 
          end
       end
    endgenerate

  //wire [S_COUNT*CROSSBAR_D_WIDTH-1:0] a_c_axi_wdata_upsized;

  //genvar aa;
  //generate 
  //    for(aa=0;aa <S_COUNT;aa=aa+1)begin
  //       assign a_c_axi_wdata_upsized   =  a_c_axi_wdata;  
  //    end
  //endgenerate

  genvar m;
    generate 
	    for(m=0;m <S_COUNT;m=m+1)begin
		axi_slave_interface_coupler #(
	       .W_DATA_WIDTH(S_W_D_WIDTH[m]),
	       .R_DATA_WIDTH(S_R_D_WIDTH[m]),
	       .CROSSBAR_D_WIDTH(CROSSBAR_D_WIDTH),
	       .ID_WIDTH(S_ID_WIDTH[m]),
               .ADDR_WIDTH(S_A_WIDTH),
	       .COUPLER_REG_INSTANCE(COUPLER_REG_INSTANCE),
               .STRB_WIDTH(S_STRB_WIDTH[m]))

		coupler_wrapper_instance
		( .clk(clk),
            .rst(rst),
            .s_axi_awid(s_axi_awid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+: S_ID_WIDTH[m]]),
            .s_axi_awaddr(s_axi_awaddr[S_A_WIDTH*m+:S_A_WIDTH]),
            .s_axi_awlen(s_axi_awlen[m*8+:8]),
            .s_axi_awsize(s_axi_awsize[m*3+:3]),
            .s_axi_awburst(s_axi_awburst[m*2+:2]),
            .s_axi_awlock(s_axi_awlock[m]),
            .s_axi_awcache(s_axi_awcache[m*4+:4]),
            .s_axi_awprot(s_axi_awprot[m*3+:3]),
            .s_axi_awqos(s_axi_awqos[m*4+:4]),
            .s_axi_awuser(s_axi_awuser[m*AWUSER_WIDTH+:AWUSER_WIDTH]),
            .s_axi_awvalid(s_axi_awvalid[m]),
            .s_axi_awready(s_axi_awready[m]),
            .s_axi_wdata(s_axi_wdata[axi_interconnect_pkg::sum_up_to_index(S_W_D_WIDTH,m)+: S_W_D_WIDTH[m]]),
            .s_axi_wstrb(s_axi_wstrb[axi_interconnect_pkg::sum_up_to_index(S_STRB_WIDTH,m)+: S_STRB_WIDTH[m]]),
            .s_axi_wlast(s_axi_wlast[m]),
            .s_axi_wuser(s_axi_wuser[m*WUSER_WIDTH+:WUSER_WIDTH]),
            .s_axi_wvalid(s_axi_wvalid[m]),
            .s_axi_wready(s_axi_wready[m]),
            .s_axi_bid(s_axi_bid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .s_axi_bresp(s_axi_bresp[m*2+:2]),
            .s_axi_buser(s_axi_buser[m*BUSER_WIDTH+:BUSER_WIDTH]),
            .s_axi_bvalid(s_axi_bvalid[m]),
            .s_axi_bready(s_axi_bready[m]),  
	    .s_axi_arid(s_axi_arid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .s_axi_araddr(s_axi_araddr[S_A_WIDTH*m+:S_A_WIDTH]),
            .s_axi_arlen(s_axi_arlen[m*8+:8]),
            .s_axi_arsize(s_axi_arsize[m*3+:3]),
            .s_axi_arburst(s_axi_arburst[m*2+:2]),
            .s_axi_arlock(s_axi_arlock[m]),
            .s_axi_arcache(s_axi_arcache[m*4+:4]),
            .s_axi_arprot(s_axi_arprot[m*3+:3]),
            .s_axi_arqos(s_axi_arqos[m*4+:4]),
            .s_axi_aruser(s_axi_aruser[m*ARUSER_WIDTH+:ARUSER_WIDTH]),
            .s_axi_arvalid(s_axi_arvalid[m]),
            .s_axi_arready(s_axi_arready[m]),
            .s_axi_rid(s_axi_rid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .s_axi_rdata(s_axi_rdata[axi_interconnect_pkg::sum_up_to_index(S_R_D_WIDTH,m)+:S_R_D_WIDTH[m]]),
            .s_axi_rresp(s_axi_rresp[m*2+:2]),
            .s_axi_rlast(s_axi_rlast[m]),
            .s_axi_ruser(s_axi_ruser[m*RUSER_WIDTH+: RUSER_WIDTH]),
            .s_axi_rvalid(s_axi_rvalid[m]),
            .s_axi_rready(s_axi_rready[m]),



            /*
             * AXI master interface
             */
	    .m_axi_awid(a_c_axi_awid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+: S_ID_WIDTH[m]]),
            .m_axi_awaddr(a_c_axi_awaddr[S_A_WIDTH*m+:S_A_WIDTH]),
            .m_axi_awlen(a_c_axi_awlen[m*8+:8]),
            .m_axi_awsize(a_c_axi_awsize[m*3+:3]),
            .m_axi_awburst(a_c_axi_awburst[m*2+:2]),
            .m_axi_awlock(a_c_axi_awlock[m]),
            .m_axi_awcache(a_c_axi_awcache[m*4+:4]),
            .m_axi_awprot(a_c_axi_awprot[m*3+:3]),
            .m_axi_awqos(a_c_axi_awqos[m*4+:4]),
            .m_axi_awregion(a_c_axi_awregion),
            .m_axi_awuser(a_c_axi_awuser[m*AWUSER_WIDTH+:AWUSER_WIDTH]),
            .m_axi_awvalid(a_c_axi_awvalid[m]),
            .m_axi_awready(a_c_axi_awready[m]),
            .m_axi_wdata(a_c_axi_wdata[m*CROSSBAR_D_WIDTH+:CROSSBAR_D_WIDTH]),
            .m_axi_wstrb(a_c_axi_wstrb[m*CROSSBAR_STRB_WIDTH+:CROSSBAR_STRB_WIDTH]),
            .m_axi_wlast(a_c_axi_wlast[m]),
            .m_axi_wuser(a_c_axi_wuser[m*WUSER_WIDTH+:WUSER_WIDTH]),
            .m_axi_wvalid(a_c_axi_wvalid[m]),
            .m_axi_wready(a_c_axi_wready[m]),
            .m_axi_bid(a_c_axi_bid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .m_axi_bresp(a_c_axi_bresp[m*2+:2]),
            .m_axi_buser(a_c_axi_buser[m*BUSER_WIDTH+:BUSER_WIDTH]),
            .m_axi_bvalid(a_c_axi_bvalid[m]),
            .m_axi_bready(a_c_axi_bready[m]),  
	    .m_axi_arid(a_c_axi_arid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .m_axi_araddr(a_c_axi_araddr[S_A_WIDTH*m+:S_A_WIDTH]),
            .m_axi_arlen(a_c_axi_arlen[m*8+:8]),
            .m_axi_arsize(a_c_axi_arsize[m*3+:3]),
            .m_axi_arburst(a_c_axi_arburst[m*2+:2]),
            .m_axi_arlock(a_c_axi_arlock[m]),
            .m_axi_arcache(a_c_axi_arcache[m*4+:4]),
            .m_axi_arprot(a_c_axi_arprot[m*3+:3]),
            .m_axi_arqos(a_c_axi_arqos[n*4+:4]),
            .m_axi_arregion(a_c_axi_arregion),
            .m_axi_aruser(a_c_axi_aruser[m*ARUSER_WIDTH+:ARUSER_WIDTH]),
            .m_axi_arvalid(a_c_axi_arvalid[m]),
            .m_axi_arready(a_c_axi_arready[m]),
            .m_axi_rid(a_c_axi_rid[axi_interconnect_pkg::sum_up_to_index(S_ID_WIDTH,m)+:S_ID_WIDTH[m]]),
            .m_axi_rdata(a_c_axi_rdata[m*CROSSBAR_D_WIDTH+:CROSSBAR_D_WIDTH]),
            .m_axi_rresp(a_c_axi_rresp[m*2+:2]),
            .m_axi_rlast(a_c_axi_rlast[m]),
            .m_axi_ruser(a_c_axi_ruser[m*RUSER_WIDTH+: RUSER_WIDTH]),
            .m_axi_rvalid(a_c_axi_rvalid[m]),
            .m_axi_rready(a_c_axi_rready[m])

            );

      end
    endgenerate

     genvar n;
     generate 
	    for(n=0;n<M_COUNT;n=n+1)begin
		axi_master_interface_coupler_wrapper #(
	           .W_DATA_WIDTH(M_W_D_WIDTH[n]),
	           .R_DATA_WIDTH(M_R_D_WIDTH[n]),
	           .CROSSBAR_D_WIDTH(CROSSBAR_D_WIDTH),
	           .ID_WIDTH(M_ID_WIDTH),
                   .ADDR_WIDTH(M_A_WIDTH[n]),
		   .COUPLER_REG_INSTANCE(COUPLER_REG_INSTANCE)
		)m_interface_coupler_instance
		( 		
	    .clk(clk),
            .rst(rst),

            /*
             * AXI master interface
             */
            .m_axi_awid(m_axi_awid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .m_axi_awaddr(m_axi_awaddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,n)+:M_A_WIDTH[n]]),
            .m_axi_awlen(m_axi_awlen[n*8+:8]),
            .m_axi_awsize(m_axi_awsize[n*3+:3]),
            .m_axi_awburst(m_axi_awburst[n*2+:2]),
            .m_axi_awlock(m_axi_awlock[n]),
            .m_axi_awcache(m_axi_awcache[n*4+:4]),
            .m_axi_awprot(m_axi_awprot[n*3+:3]),
            .m_axi_awqos(m_axi_awqos[n*4+:4]),
            .m_axi_awregion(m_axi_awregion),
            .m_axi_awuser(m_axi_awuser[n*AWUSER_WIDTH+:AWUSER_WIDTH]),
            .m_axi_awvalid(m_axi_awvalid[n]),
            .m_axi_awready(m_axi_awready[n]),
            .m_axi_wdata(m_axi_wdata[axi_interconnect_pkg::sum_up_to_index(M_W_D_WIDTH,n)+:M_W_D_WIDTH[n]]),
            .m_axi_wstrb(m_axi_wstrb[axi_interconnect_pkg::sum_up_to_index(M_STRB_WIDTH,n)+:M_STRB_WIDTH[n]]),
            .m_axi_wlast(m_axi_wlast[n]),
            .m_axi_wuser(m_axi_wuser[n*WUSER_WIDTH+:WUSER_WIDTH]),
            .m_axi_wvalid(m_axi_wvalid[n]),
            .m_axi_wready(m_axi_wready[n]),
            .m_axi_bid(m_axi_bid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .m_axi_bresp(m_axi_bresp[n*2+:2]),
            .m_axi_buser(m_axi_buser[n*BUSER_WIDTH+:BUSER_WIDTH]),
            .m_axi_bvalid(m_axi_bvalid[n]),
            .m_axi_bready(m_axi_bready[n]),  
	    .m_axi_arid(m_axi_arid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .m_axi_araddr(m_axi_araddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,n)+:M_A_WIDTH[n]]),
            .m_axi_arlen(m_axi_arlen[n*8+:8]),
            .m_axi_arsize(m_axi_arsize[n*3+:3]),
            .m_axi_arburst(m_axi_arburst[n*2+:2]),
            .m_axi_arlock(m_axi_arlock[n]),
            .m_axi_arcache(m_axi_arcache[n*4+:4]),
            .m_axi_arprot(m_axi_arprot[n*3+:3]),
            .m_axi_arqos(m_axi_arqos[n*4+:4]),
            .m_axi_arregion(m_axi_arregion),
            .m_axi_aruser(m_axi_aruser[n*ARUSER_WIDTH+:ARUSER_WIDTH]),
            .m_axi_arvalid(m_axi_arvalid[n]),
            .m_axi_arready(m_axi_arready[n]),
            .m_axi_rid(m_axi_rid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .m_axi_rdata(m_axi_rdata[axi_interconnect_pkg::sum_up_to_index(M_R_D_WIDTH,n)+:M_R_D_WIDTH[n]]),
            .m_axi_rresp(m_axi_rresp[n*2+:2]),
            .m_axi_rlast(m_axi_rlast[n]),
            .m_axi_ruser(m_axi_ruser[n*RUSER_WIDTH+: RUSER_WIDTH]),
            .m_axi_rvalid(m_axi_rvalid[n]),
            .m_axi_rready(m_axi_rready[n]),



            /*
             * AXI slave interface
             */
	    .s_axi_awid(c_a_axi_awid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .s_axi_awaddr(c_a_axi_awaddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,n)+:M_A_WIDTH[n]]),
            .s_axi_awlen(c_a_axi_awlen[n*8+:8]),
            .s_axi_awsize(c_a_axi_awsize[n*3+:3]),
            .s_axi_awburst(c_a_axi_awburst[n*2+:2]),
            .s_axi_awlock(c_a_axi_awlock[n]),
            .s_axi_awcache(s_axi_awcache[n*4+:4]),
            .s_axi_awprot(c_a_axi_awprot[n*3+:3]),
            .s_axi_awqos(c_a_axi_awqos[n*4+:4]),
            .s_axi_awregion(c_a_axi_awregion),
            .s_axi_awuser(c_a_axi_awuser[n*AWUSER_WIDTH+:AWUSER_WIDTH]),
            .s_axi_awvalid(c_a_axi_awvalid[n]),
            .s_axi_awready(c_a_axi_awready[n]),
            .s_axi_wdata(c_a_axi_wdata[n*CROSSBAR_D_WIDTH+:CROSSBAR_D_WIDTH]),
            .s_axi_wstrb(c_a_axi_wstrb[n*CROSSBAR_STRB_WIDTH+:CROSSBAR_STRB_WIDTH]),
            .s_axi_wlast(c_a_axi_wlast[n]),
            .s_axi_wuser(c_a_axi_wuser[n*WUSER_WIDTH+:WUSER_WIDTH]),
            .s_axi_wvalid(c_a_axi_wvalid[n]),
            .s_axi_wready(c_a_axi_wready[n]),
            .s_axi_bid(c_a_axi_bid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .s_axi_bresp(c_a_axi_bresp[n*2+:2]),
            .s_axi_buser(c_a_axi_buser[n*BUSER_WIDTH+:BUSER_WIDTH]),
            .s_axi_bvalid(c_a_axi_bvalid[n]),
            .s_axi_bready(c_a_axi_bready[n]),  
	    .s_axi_arid(c_a_axi_arid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .s_axi_araddr(c_a_axi_araddr[axi_interconnect_pkg::sum_up_to_index(M_A_WIDTH,n)+:M_A_WIDTH[n]]),
            .s_axi_arlen(c_a_axi_arlen[n*8+:8]),
            .s_axi_arsize(c_a_axi_arsize[n*3+:3]),
            .s_axi_arburst(c_a_axi_arburst[n*2+:2]),
            .s_axi_arlock(c_a_axi_arlock[n]),
            .s_axi_arcache(c_a_axi_arcache[n*4+:4]),
            .s_axi_arprot(c_a_axi_arprot[n*3+:3]),
            .s_axi_arqos(c_a_axi_arqos[n*4+:4]),
            .s_axi_arregion(c_a_axi_arregion),
            .s_axi_aruser(c_a_axi_aruser[n*ARUSER_WIDTH+:ARUSER_WIDTH]),
            .s_axi_arvalid(c_a_axi_arvalid[n]),
            .s_axi_arready(c_a_axi_arready[n]),
            .s_axi_rid(c_a_axi_rid[M_ID_WIDTH*n+:M_ID_WIDTH]),
            .s_axi_rdata(c_a_axi_rdata[axi_interconnect_pkg::sum_up_to_index(M_R_D_WIDTH,n)+:M_R_D_WIDTH[n]]),
            .s_axi_rresp(c_a_axi_rresp[n*2+:2]),
            .s_axi_rlast(c_a_axi_rlast[n]),
            .s_axi_ruser(c_a_axi_ruser[n*RUSER_WIDTH+: RUSER_WIDTH]),
            .s_axi_rvalid(c_a_axi_rvalid[n]),
            .s_axi_rready(c_a_axi_rready[n])


            );

      end
    endgenerate

    axi_crossbar #(
               .S_COUNT(S_COUNT),
	       .M_COUNT(M_COUNT) ,
	       .DATA_WIDTH(CROSSBAR_D_WIDTH),
	       .ADDR_WIDTH(S_A_WIDTH),
	       .M_ID_WIDTH(M_ID_WIDTH),
	       .S_ID_WIDTH(MAX_S_ID_WIDTH)
               )

    crossbar_instance (
	          .clk(clk),
            .rst(rst),

            /*
             * AXI slave interface
             */
            .s_axi_awid(temp_adapter_crossbar_S_AW_ID),
            .s_axi_awaddr(a_c_axi_awaddr),
            .s_axi_awlen(a_c_axi_awlen),
            .s_axi_awsize(a_c_axi_awsize),
            .s_axi_awburst(a_c_axi_awburst),
            .s_axi_awlock(a_c_axi_awlock),
            .s_axi_awcache(a_c_axi_awcache),
            .s_axi_awprot(a_c_axi_awprot),
            .s_axi_awqos(a_c_axi_awqos),
            .s_axi_awuser(a_c_axi_awuser),
            .s_axi_awvalid(a_c_axi_awvalid),
            .s_axi_awready(a_c_axi_awready),
            .s_axi_wdata(a_c_axi_wdata),
            .s_axi_wstrb(a_c_axi_wstrb),
            .s_axi_wlast(a_c_axi_wlast),
            .s_axi_wuser(a_c_axi_wuser),
            .s_axi_wvalid(a_c_axi_wvalid),
            .s_axi_wready(a_c_axi_wready),
            .s_axi_bid(adapter_crossbar_S_B_ID),
            .s_axi_bresp(a_c_axi_bresp),
            .s_axi_buser(a_c_axi_buser),
            .s_axi_bvalid(a_c_axi_bvalid),
            .s_axi_bready(a_c_axi_bready),  
	    .s_axi_arid(temp_adapter_crossbar_S_AR_ID),
            .s_axi_araddr(a_c_axi_araddr),
            .s_axi_arlen(a_c_axi_arlen),
            .s_axi_arsize(a_c_axi_arsize),
            .s_axi_arburst(a_c_axi_arburst),
            .s_axi_arlock(a_c_axi_arlock),
            .s_axi_arcache(a_c_axi_arcache),
            .s_axi_arprot(a_c_axi_arprot),
            .s_axi_arqos(a_c_axi_arqos),
            .s_axi_aruser(a_c_axi_aruser),
            .s_axi_arvalid(a_c_axi_arvalid),
            .s_axi_arready(a_c_axi_arready),
            .s_axi_rid(adapter_crossbar_S_R_ID),
            .s_axi_rdata(a_c_axi_rdata),
            .s_axi_rresp(a_c_axi_rresp),
            .s_axi_rlast(a_c_axi_rlast),
            .s_axi_ruser(a_c_axi_ruser),
            .s_axi_rvalid(a_c_axi_rvalid),
            .s_axi_rready(a_c_axi_rready),



            /*
             * AXI master interface
             */
            .m_axi_awid(c_a_axi_awid),
            .m_axi_awaddr(crossbar_adapter_M_AWADDR),
            .m_axi_awlen(c_a_axi_awlen),
            .m_axi_awsize(c_a_axi_awsize),
            .m_axi_awburst(c_a_axi_awburst),
            .m_axi_awlock(c_a_axi_awlock),
            .m_axi_awcache(c_a_axi_awcache),
            .m_axi_awprot(c_a_axi_awprot),
            .m_axi_awqos(c_a_axi_awqos),
            .m_axi_awregion(c_a_axi_awregion),
            .m_axi_awuser(c_a_axi_awuser),
            .m_axi_awvalid(c_a_axi_awvalid),
            .m_axi_awready(c_a_axi_awready),
            .m_axi_wdata(c_a_axi_wdata),
            .m_axi_wstrb(c_a_axi_wstrb),
            .m_axi_wlast(c_a_axi_wlast),
            .m_axi_wuser(c_a_axi_wuser),
            .m_axi_wvalid(c_a_axi_wvalid),
            .m_axi_wready(c_a_axi_wready),
            .m_axi_bid(c_a_axi_bid),
            .m_axi_bresp(c_a_axi_bresp),
            .m_axi_buser(c_a_axi_buser),
            .m_axi_bvalid(c_a_axi_bvalid),
            .m_axi_bready(c_a_axi_bready),
	    .m_axi_arid(c_a_axi_arid),
	    .m_axi_araddr(crossbar_adapter_M_ARADDR),
	    .m_axi_arlen(c_a_axi_arlen),
            .m_axi_arsize(c_a_axi_arsize),
            .m_axi_arburst(c_a_axi_arburst),
            .m_axi_arlock(c_a_axi_arlock),
            .m_axi_arcache(c_a_axi_arcache),
            .m_axi_arprot(c_a_axi_arprot),
            .m_axi_arqos(c_a_axi_arqos),
            .m_axi_arregion(c_a_axi_arregion),
            .m_axi_aruser(c_a_axi_aruser),
            .m_axi_arvalid(c_a_axi_arvalid),
            .m_axi_arready(c_a_axi_arready),
            .m_axi_rid(c_a_axi_rid),
            .m_axi_rdata(crossbar_adapter_M_RDATA),
            .m_axi_rresp(c_a_axi_rresp),
            .m_axi_rlast(c_a_axi_rlast),
            .m_axi_ruser(c_a_axi_ruser),
            .m_axi_rvalid(c_a_axi_rvalid),
            .m_axi_rready(c_a_axi_rready)
    );
endmodule



		    




