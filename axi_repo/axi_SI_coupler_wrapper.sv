module axi_slave_interface_coupler #(
	      parameter W_DATA_WIDTH=32,
	      parameter R_DATA_WIDTH=16,
	      parameter CROSSBAR_D_WIDTH=32,
	      parameter ID_WIDTH=4,
	      parameter ADDR_WIDTH=12,
              parameter AW_USER_ENABLE=0,
	      parameter AWUSER_WIDTH = 1,
	      parameter WUSER_ENABLE = 0,
              parameter WUSER_WIDTH = 1,
              parameter BUSER_ENABLE = 0,
              parameter BUSER_WIDTH = 1,
              parameter ARUSER_ENABLE = 0,
              parameter STRB_WIDTH=4, 
              parameter ARUSER_WIDTH = 1,
              parameter RUSER_ENABLE = 0,
              parameter RUSER_WIDTH = 1,
	      parameter COUPLER_REG_INSTANCE=0

           )
	
         (  
              input                      clk,
              input                      rst,    
              input   [ID_WIDTH-1:0]     s_axi_awid,
              input   [ADDR_WIDTH-1:0]   s_axi_awaddr,
              input   [7:0]              s_axi_awlen,
              input   [2:0]              s_axi_awsize,
              input   [1:0]              s_axi_awburst,
              input                      s_axi_awlock,
              input   [3:0]              s_axi_awcache,
              input   [2:0]              s_axi_awprot,
              input   [3:0]              s_axi_awqos,
              input   [3:0]              s_axi_awregion,
              input   [AWUSER_WIDTH-1:0] s_axi_awuser,
              input                      s_axi_awvalid,
              output             	   s_axi_awready,
              input   [W_DATA_WIDTH-1:0]   s_axi_wdata,
              input   [W_DATA_WIDTH/8-1:0]   s_axi_wstrb,
              input                      s_axi_wlast,
              input   [WUSER_WIDTH-1:0]  s_axi_wuser,
              input                      s_axi_wvalid,
              output                     s_axi_wready,
              output  [ID_WIDTH-1:0]     s_axi_bid,
              output  [1:0]              s_axi_bresp,
              output  [BUSER_WIDTH-1:0]  s_axi_buser,
              output                     s_axi_bvalid,
              input                      s_axi_bready,
              input   [ID_WIDTH-1:0]     s_axi_arid,
              input   [ADDR_WIDTH-1:0]   s_axi_araddr,
              input   [7:0]              s_axi_arlen,
              input   [2:0]              s_axi_arsize,
              input   [1:0]              s_axi_arburst,
              input                      s_axi_arlock,
              input   [3:0]              s_axi_arcache,
              input   [2:0]              s_axi_arprot,
              input   [3:0]              s_axi_arqos,
              input   [3:0]              s_axi_arregion,
              input   [ARUSER_WIDTH-1:0] s_axi_aruser,
              input                      s_axi_arvalid,
              output                     s_axi_arready,
              output  [ID_WIDTH-1:0]     s_axi_rid,
              output  [R_DATA_WIDTH-1:0] s_axi_rdata,
              output  [1:0]              s_axi_rresp,
              output                     s_axi_rlast,
              output  [RUSER_WIDTH-1:0]  s_axi_ruser,
              output                     s_axi_rvalid,
              input                      s_axi_rready,

              /*
               * AXI master interfaces
               */
              output wire [ID_WIDTH-1:0]     m_axi_awid,
              output wire [ADDR_WIDTH-1:0]   m_axi_awaddr,
              output wire [7:0]              m_axi_awlen,
              output wire [2:0]              m_axi_awsize,
              output wire [1:0]              m_axi_awburst,
              output wire                    m_axi_awlock,
              output wire [3:0]              m_axi_awcache,
              output wire [2:0]              m_axi_awprot,
              output wire [3:0]              m_axi_awqos,
              output wire [3:0]              m_axi_awregion,
              output wire [AWUSER_WIDTH-1:0] m_axi_awuser,
              output wire                    m_axi_awvalid,
              input  wire                    m_axi_awready,
              output wire [CROSSBAR_D_WIDTH-1:0]   m_axi_wdata,
              output wire [CROSSBAR_D_WIDTH/8-1:0]   m_axi_wstrb,
              output wire                    m_axi_wlast,
              output wire [WUSER_WIDTH-1:0]  m_axi_wuser,
              output wire                    m_axi_wvalid,
              input  wire                    m_axi_wready,
              input  wire [ID_WIDTH-1:0]     m_axi_bid,
              input  wire [1:0]              m_axi_bresp,
              input  wire [BUSER_WIDTH-1:0]  m_axi_buser,
              input  wire                    m_axi_bvalid,
              output wire                    m_axi_bready,
              output wire [ID_WIDTH-1:0]     m_axi_arid,
              output wire [ADDR_WIDTH-1:0]   m_axi_araddr,
              output wire [7:0]              m_axi_arlen,
              output wire [2:0]              m_axi_arsize,
              output wire [1:0]              m_axi_arburst,
              output wire                    m_axi_arlock,
              output wire [3:0]              m_axi_arcache,
              output wire [2:0]              m_axi_arprot,
              output wire [3:0]              m_axi_arqos,
              output wire [3:0]              m_axi_arregion,
              output wire [ARUSER_WIDTH-1:0] m_axi_aruser,
              output wire                    m_axi_arvalid,
              input  wire                    m_axi_arready,
              input  wire [ID_WIDTH-1:0]     m_axi_rid,
              input  wire [CROSSBAR_D_WIDTH-1:0]   m_axi_rdata,
              input  wire [1:0]              m_axi_rresp,
              input  wire                    m_axi_rlast,
              input  wire [RUSER_WIDTH-1:0]  m_axi_ruser,
              input  wire                    m_axi_rvalid,
              output wire                    m_axi_rready
             );

/////wire declarations between fifo and register////////////
   //wire                      f_r_axi_rready;
   wire                      f_r_arvalid;
   wire [ARUSER_WIDTH-1:0]   f_r_aruser;
   wire [3:0]		     f_r_arrregion;
   wire [3:0]		     f_r_ar_qos;
   wire [2:0]		     f_r_arprot;
   wire [3:0]		     f_r_arcache;
   wire      		     f_r_arlock;
   //wire [1:0]		     f_r_axi_arburst;
   //wire [2:0]		     f_r_axi_arsize;
   wire [ID_WIDTH-1:0]       f_r_axi_awid;
   wire [ADDR_WIDTH-1:0]     f_r_axi_awaddr;
   wire [7:0]                f_r_axi_awlen;
   wire [2:0]                f_r_axi_awsize;
   wire [1:0]                f_r_axi_awburst;
   wire                      f_r_axi_awlock;
   wire [3:0]                f_r_axi_awcache;
   wire [2:0]                f_r_axi_awprot;
   wire [3:0]                f_r_axi_awqos;
   wire [3:0]                f_r_axi_awregion;
   wire [AWUSER_WIDTH-1:0]   f_r_axi_awuser;
   wire                      f_r_axi_awvalid;
   wire                      f_r_axi_awready;
   wire [W_DATA_WIDTH-1:0]   f_r_axi_wdata;
   wire [W_DATA_WIDTH/8-1:0]     f_r_axi_wstrb;
   wire                      f_r_axi_wlast;
   wire [WUSER_WIDTH-1:0]    f_r_axi_wuser;
   wire                      f_r_axi_wvalid;
   wire                      f_r_axi_wready;
   wire [ID_WIDTH-1:0]       f_r_axi_bid;
   wire [1:0]                f_r_axi_bresp;
   wire [BUSER_WIDTH-1:0]    f_r_axi_buser;
   wire                      f_r_axi_bvalid;
   wire                      f_r_axi_bready;
   wire [ID_WIDTH-1:0]       f_r_axi_arid;
   wire [ADDR_WIDTH-1:0]     f_r_axi_araddr;
   wire [7:0]                f_r_axi_arlen;
   wire [2:0]                f_r_axi_arsize;
   wire [1:0]                f_r_axi_arburst;
   wire                      f_r_axi_arlock;
   wire [3:0]                f_r_axi_arcache;
   wire [2:0]                f_r_axi_arprot;
   wire [3:0]                f_r_axi_arqos;
   wire [ARUSER_WIDTH-1:0]   f_r_axi_aruser;
   wire                      f_r_axi_arvalid;
   wire                      f_r_axi_arready;
   wire [ID_WIDTH-1]         f_r_axi_rid;
   wire [R_DATA_WIDTH-1:0]   f_r_axi_rdata;
   wire [1:0]                f_r_axi_rresp;
   wire                      f_r_axi_rlast;
   wire [RUSER_WIDTH-1:0]    f_r_axi_ruser;
   wire                      f_r_axi_rvalid;
   wire                      f_r_axi_rready;


///////////wire declarations between register and  adapter/////////////////////
   //wire                      r_a_axi_rready;
   wire                      r_a_arvalid;
   wire [ARUSER_WIDTH-1:0]   r_a_aruser;
   wire [3:0]                r_a_arrregion;
   wire [3:0]                r_a_ar_qos;
   wire [2:0]                r_a_arprot;
   wire [3:0]                r_a_arcache;
   wire                      r_a_arlock;
   //wire [1:0]                r_a_axi_arburst;
   //wire [2:0]                r_a_axi_arsize;
   wire [ID_WIDTH-1:0]       r_a_axi_awid;
   wire [ADDR_WIDTH-1:0]     r_a_axi_awaddr;
   wire [7:0]                r_a_axi_awlen;
   wire [2:0]                r_a_axi_awsize;
   wire [1:0]                r_a_axi_awburst;
   wire                      r_a_axi_awlock;
   wire [3:0]                r_a_axi_awcache;
   wire [2:0]                r_a_axi_awprot;
   wire [3:0]                r_a_axi_awqos;
   wire [3:0]                r_a_axi_awregion;
   wire [AWUSER_WIDTH-1:0]   r_a_axi_awuser;
   wire                      r_a_axi_awvalid;
   wire                      r_a_axi_awready;
   wire [W_DATA_WIDTH-1:0]   r_a_axi_wdata;
   wire [W_DATA_WIDTH/8-1:0]     r_a_axi_wstrb;
   wire                      r_a_axi_wlast;
   wire [WUSER_WIDTH-1:0]    r_a_axi_wuser;
   wire                      r_a_axi_wvalid;
   wire                      r_a_axi_wready;
   wire [ID_WIDTH-1:0]       r_a_axi_bid;
   wire [1:0]                r_a_axi_bresp;
   wire [BUSER_WIDTH-1:0]    r_a_axi_buser;
   wire                      r_a_axi_bvalid;
   wire                      r_a_axi_bready;
   wire [ID_WIDTH-1:0]       r_a_axi_arid;
   wire [ADDR_WIDTH-1:0]     r_a_axi_araddr;
   wire [7:0]                r_a_axi_arlen;
   wire [2:0]                r_a_axi_arsize;
   wire [1:0]                r_a_axi_arburst;
   wire                      r_a_axi_arlock;
   wire [3:0]                r_a_axi_arcache;
   wire [2:0]                r_a_axi_arprot;
   wire [3:0]                r_a_axi_arqos;
   wire [ARUSER_WIDTH-1:0]   r_a_axi_aruser;
   wire                      r_a_axi_arvalid;
   wire                      r_a_axi_arready;
   wire [ID_WIDTH-1]         r_a_axi_rid;
   wire [R_DATA_WIDTH-1:0]   r_a_axi_rdata;
   wire [1:0]                r_a_axi_rresp;
   wire                      r_a_axi_rlast;
   wire [RUSER_WIDTH-1:0]    r_a_axi_ruser;
   wire                      r_a_axi_rvalid;
   wire                      r_a_axi_rready;

   ///////////wire declarations between  adapter and register     /////////////////////
   //wire                      f_a_axi_rready;
   wire                      f_a_arvalid;
   wire [ARUSER_WIDTH-1:0]   f_a_aruser;
   wire [3:0]                f_a_arrregion;
   wire [3:0]                f_a_ar_qos;
   wire [2:0]                f_a_arprot;
   wire [3:0]                f_a_arcache;
   wire                      f_a_arlock;
   //wire [1:0]                f_a_axi_arburst;
   //wire [2:0]                f_a_axi_arsize;
   wire [ID_WIDTH-1:0]       f_a_axi_awid;
   wire [ADDR_WIDTH-1:0]     f_a_axi_awaddr;
   wire [7:0]                f_a_axi_awlen;
   wire [2:0]                f_a_axi_awsize;
   wire [1:0]                f_a_axi_awburst;
   wire                      f_a_axi_awlock;
   wire [3:0]                f_a_axi_awcache;
   wire [2:0]                f_a_axi_awprot;
   wire [3:0]                f_a_axi_awqos;
   wire [3:0]                f_a_axi_awregion;
   wire [AWUSER_WIDTH-1:0]   f_a_axi_awuser;
   wire                      f_a_axi_awvalid;
   wire                      f_a_axi_awready;
   wire [W_DATA_WIDTH-1:0]   f_a_axi_wdata;
   wire [W_DATA_WIDTH/8-1:0]     f_a_axi_wstrb;
   wire                      f_a_axi_wlast;
   wire [WUSER_WIDTH-1:0]    f_a_axi_wuser;
   wire                      f_a_axi_wvalid;
   wire                      f_a_axi_wready;
   wire [ID_WIDTH-1:0]       f_a_axi_bid;
   wire [1:0]                f_a_axi_bresp;
   wire [BUSER_WIDTH-1:0]    f_a_axi_buser;
   wire                      f_a_axi_bvalid;
   wire                      f_a_axi_bready;
   wire [ID_WIDTH-1:0]       f_a_axi_arid;
   wire [ADDR_WIDTH-1:0]     f_a_axi_araddr;
   wire [7:0]                f_a_axi_arlen;
   wire [2:0]                f_a_axi_arsize;
   wire [1:0]                f_a_axi_arburst;
   wire                      f_a_axi_arlock;
   wire [3:0]                f_a_axi_arcache;
   wire [2:0]                f_a_axi_arprot;
   wire [3:0]                f_a_axi_arqos;
   wire [3:0]                f_a_axi_arregion;
   wire [ARUSER_WIDTH-1:0]   f_a_axi_aruser;
   wire                      f_a_axi_arvalid;
   wire                      f_a_axi_arready;
   wire [ID_WIDTH-1:0]         f_a_axi_rid;
   wire [R_DATA_WIDTH-1:0]   f_a_axi_rdata;
   wire [1:0]                f_a_axi_rresp;
   wire                      f_a_axi_rlast;
   wire [RUSER_WIDTH-1:0]    f_a_axi_ruser;
   wire                      f_a_axi_rvalid;
   wire                      f_a_axi_rready;


///////////////////////////////////////////
generate 
if(COUPLER_REG_INSTANCE==1)begin  

axi_fifo #(
	   .R_DATA_WIDTH(R_DATA_WIDTH),
	   .ADDR_WIDTH(ADDR_WIDTH),
	   .STRB_WIDTH(STRB_WIDTH),
	   .ID_WIDTH(ID_WIDTH),
	   .W_DATA_WIDTH(W_DATA_WIDTH)
          )
axi_fifo_inst (
            .clk(clk),
            .rst(rst),

            /*
             * AXI slave interface
             */
            .s_axi_awid(s_axi_awid),
            .s_axi_awaddr(s_axi_awaddr),
            .s_axi_awlen(s_axi_awlen),
            .s_axi_awsize(s_axi_awsize),
            .s_axi_awburst(s_axi_awburst),
            .s_axi_awlock(s_axi_awlock),
            .s_axi_awcache(s_axi_awcache),
            .s_axi_awprot(s_axi_awprot),
            .s_axi_awqos(s_axi_awqos),
            .s_axi_awregion(s_axi_awregion),
            .s_axi_awuser(s_axi_awuser),
            .s_axi_awvalid(s_axi_awvalid),
            .s_axi_awready(s_axi_awready),
            .s_axi_wdata(s_axi_wdata),
            .s_axi_wstrb(s_axi_wstrb),
            .s_axi_wlast(s_axi_wlast),
            .s_axi_wuser(s_axi_wuser),
            .s_axi_wvalid(s_axi_wvalid),
            .s_axi_wready(s_axi_wready),
            .s_axi_bid(s_axi_bid),
            .s_axi_bresp(s_axi_bresp),
            .s_axi_buser(s_axi_buser),
            .s_axi_bvalid(s_axi_bvalid),
            .s_axi_bready(s_axi_bready),  
	    .s_axi_arid(s_axi_arid),
            .s_axi_araddr(s_axi_araddr),
            .s_axi_arlen(s_axi_arlen),
            .s_axi_arsize(s_axi_arsize),
            .s_axi_arburst(s_axi_arburst),
            .s_axi_arlock(s_axi_arlock),
            .s_axi_arcache(s_axi_arcache),
            .s_axi_arprot(s_axi_arprot),
            .s_axi_arqos(s_axi_arqos),
            .s_axi_arregion(s_axi_arregion),
            .s_axi_aruser(s_axi_aruser),
            .s_axi_arvalid(s_axi_arvalid),
            .s_axi_arready(s_axi_arready),
            .s_axi_rid(s_axi_rid),
            .s_axi_rdata(s_axi_rdata),
            .s_axi_rresp(s_axi_rresp),
            .s_axi_rlast(s_axi_rlast),
            .s_axi_ruser(s_axi_ruser),
            .s_axi_rvalid(s_axi_rvalid),
            .s_axi_rready(s_axi_rready),



            /*
             * AXI master interface
             */
            .m_axi_awid(f_r_axi_awid),
            .m_axi_awaddr(f_r_axi_awaddr),
            .m_axi_awlen(f_r_axi_awlen),
            .m_axi_awsize(f_r_axi_awsize),
            .m_axi_awburst(f_r_axi_awburst),
            .m_axi_awlock(f_r_axi_awlock),
            .m_axi_awcache(f_r_axi_awcache),
            .m_axi_awprot(f_r_axi_awprot),
            .m_axi_awqos(f_r_axi_awqos),
            .m_axi_awregion(f_r_axi_awregion),
            .m_axi_awuser(f_r_axi_awuser),
            .m_axi_awvalid(f_r_axi_awvalid),
            .m_axi_awready(f_r_axi_awready),
            .m_axi_wdata(f_r_axi_wdata),
            .m_axi_wstrb(f_r_axi_wstrb),
            .m_axi_wlast(f_r_axi_wlast),
            .m_axi_wuser(f_r_axi_wuser),
            .m_axi_wvalid(f_r_axi_wvalid),
            .m_axi_wready(f_r_axi_wready),
            .m_axi_bid(f_r_axi_bid),
            .m_axi_bresp(f_r_axi_bresp),
            .m_axi_buser(f_r_axi_buser),
            .m_axi_bvalid(f_r_axi_bvalid),
            .m_axi_bready(f_r_axi_bready),
	    .m_axi_arid(f_r_axi_arid),
	    .m_axi_araddr(f_r_axi_araddr),
	    .m_axi_arlen(f_r_axi_arlen),
            .m_axi_arsize(f_r_axi_arsize),
            .m_axi_arburst(f_r_axi_arburst),
            .m_axi_arlock(f_r_axi_arlock),
            .m_axi_arcache(f_r_axi_arcache),
            .m_axi_arprot(f_r_axi_arprot),
            .m_axi_arqos(f_r_axi_arqos),
            .m_axi_arregion(f_r_axi_arregion),
            .m_axi_aruser(f_r_axi_aruser),
            .m_axi_arvalid(f_r_axi_arvalid),
            .m_axi_arready(f_r_axi_arready),
            .m_axi_rid(f_r_axi_rid),
            .m_axi_rdata(f_r_axi_rdata),
            .m_axi_rresp(f_r_axi_rresp),
            .m_axi_rlast(f_r_axi_rlast),
            .m_axi_ruser(f_r_axi_ruser),
            .m_axi_rvalid(f_r_axi_rvalid),
            .m_axi_rready(f_r_axi_rready)

           );

 axi_register #
              (
	   .R_DATA_WIDTH(R_DATA_WIDTH),
	   .ADDR_WIDTH(ADDR_WIDTH),
	   .STRB_WIDTH(STRB_WIDTH),
	   .ID_WIDTH(ID_WIDTH),
	   .W_DATA_WIDTH(W_DATA_WIDTH)

	      )
     register_instance
              (
	    .clk(clk),
            .rst(rst),

            .s_axi_awid(f_r_axi_awid),
            .s_axi_awaddr(f_r_axi_awaddr),
            .s_axi_awlen(f_r_axi_awlen),
            .s_axi_awsize(f_r_axi_awsize),
            .s_axi_awburst(f_r_axi_awburst),
            .s_axi_awlock(f_r_axi_awlock),
            .s_axi_awcache(f_r_axi_awcache),
            .s_axi_awprot(f_r_axi_awprot),
            .s_axi_awqos(f_r_axi_awqos),
            .s_axi_awregion(f_r_axi_awregion),
            .s_axi_awuser(f_r_axi_awuser),
            .s_axi_awvalid(f_r_axi_awvalid),
            .s_axi_awready(f_r_axi_awready),
            .s_axi_wdata(f_r_axi_wdata),
            .s_axi_wstrb(f_r_axi_wstrb),
            .s_axi_wlast(f_r_axi_wlast),
            .s_axi_wuser(f_r_axi_wuser),
            .s_axi_wvalid(f_r_axi_wvalid),
            .s_axi_wready(f_r_axi_wready),
            .s_axi_bid(f_r_axi_bid),
            .s_axi_bresp(f_r_axi_bresp),
            .s_axi_buser(f_r_axi_buser),
            .s_axi_bvalid(f_r_axi_bvalid),
            .s_axi_bready(f_r_axi_bready),
            .s_axi_arid(f_r_axi_arid),
            .s_axi_araddr(f_r_axi_araddr),
            .s_axi_arlen(f_r_axi_arlen),
            .s_axi_arsize(f_r_axi_arsize),
            .s_axi_arburst(f_r_axi_arburst),
            .s_axi_arlock(f_r_axi_arlock),
            .s_axi_arcache(f_r_axi_arcache),
            .s_axi_arprot(f_r_axi_arprot),
            .s_axi_arqos(f_r_axi_arqos),
            .s_axi_arregion(f_r_axi_arregion),
            .s_axi_aruser(f_r_axi_aruser),
            .s_axi_arvalid(f_r_axi_arvalid),
            .s_axi_arready(f_r_axi_arready),
            .s_axi_rid(f_r_axi_rid),
            .s_axi_rdata(f_r_axi_rdata),
            .s_axi_rresp(f_r_axi_rresp),
            .s_axi_rlast(f_r_axi_rlast),
            .s_axi_ruser(f_r_axi_ruser),
            .s_axi_rvalid(f_r_axi_rvalid),
            .s_axi_rready(f_r_axi_rready),


            .m_axi_awid(r_a_axi_awid),
            .m_axi_awaddr(r_a_axi_awaddr),
            .m_axi_awlen(r_a_axi_awlen),
            .m_axi_awsize(r_a_axi_awsize),
            .m_axi_awburst(r_a_axi_awburst),
            .m_axi_awlock(r_a_axi_awlock),
            .m_axi_awcache(r_a_axi_awcache),
            .m_axi_awprot(r_a_axi_awprot),
            .m_axi_awqos(r_a_axi_awqos),
            .m_axi_awregion(r_a_axi_awregion),
            .m_axi_awuser(r_a_axi_awuser),
            .m_axi_awvalid(r_a_axi_awvalid),
            .m_axi_awready(r_a_axi_awready),
            .m_axi_wdata(r_a_axi_wdata),
            .m_axi_wstrb(r_a_axi_wstrb),
            .m_axi_wlast(r_a_axi_wlast),
            .m_axi_wuser(r_a_axi_wuser),
            .m_axi_wvalid(r_a_axi_wvalid),
            .m_axi_wready(r_a_axi_wready),
            .m_axi_bid(r_a_axi_bid),
            .m_axi_bresp(r_a_axi_bresp),
            .m_axi_buser(r_a_axi_buser),
            .m_axi_bvalid(r_a_axi_bvalid),
            .m_axi_bready(r_a_axi_bready),
            .m_axi_arid(r_a_axi_arid),
            .m_axi_araddr(r_a_axi_araddr),
            .m_axi_arlen(r_a_axi_arlen),
            .m_axi_arsize(r_a_axi_arsize),
            .m_axi_arburst(r_a_axi_arburst),
            .m_axi_arlock(r_a_axi_arlock),
            .m_axi_arcache(r_a_axi_arcache),
            .m_axi_arprot(r_a_axi_arprot),
            .m_axi_arqos(r_a_axi_arqos),
            .m_axi_arregion(r_a_axi_arregion),
            .m_axi_aruser(r_a_axi_aruser),
            .m_axi_arvalid(r_a_axi_arvalid),
            .m_axi_arready(r_a_axi_arready),
            .m_axi_rid(r_a_axi_rid),
            .m_axi_rdata(r_a_axi_rdata),
            .m_axi_rresp(r_a_axi_rresp),
            .m_axi_rlast(r_a_axi_rlast),
            .m_axi_ruser(r_a_axi_ruser),
            .m_axi_rvalid(r_a_axi_rvalid),
            .m_axi_rready(r_a_axi_rready)
    );
 axi_adapter #(
	   .S_R_DATA_WIDTH(R_DATA_WIDTH),
	   .ADDR_WIDTH(ADDR_WIDTH),
	   .ID_WIDTH(ID_WIDTH),
	   .S_W_DATA_WIDTH(W_DATA_WIDTH),
	   .M_W_DATA_WIDTH(CROSSBAR_D_WIDTH),
	   .M_R_DATA_WIDTH(CROSSBAR_D_WIDTH)

                )
	     
	adapter_instance
	   (
	    .clk(clk),
            .rst(rst),

	    .s_axi_awid(r_a_axi_awid),
            .s_axi_awaddr(r_a_axi_awaddr),
            .s_axi_awlen(r_a_axi_awlen),
            .s_axi_awsize(r_a_axi_awsize),
            .s_axi_awburst(r_a_axi_awburst),
            .s_axi_awlock(r_a_axi_awlock),
            .s_axi_awcache(r_a_axi_awcache),
            .s_axi_awprot(r_a_axi_awprot),
            .s_axi_awqos(r_a_axi_awqos),
            .s_axi_awregion(r_a_axi_awregion),
            .s_axi_awuser(r_a_axi_awuser),
            .s_axi_awvalid(r_a_axi_awvalid),
            .s_axi_awready(r_a_axi_awready),
            .s_axi_wdata(r_a_axi_wdata),
            .s_axi_wstrb(r_a_axi_wstrb),
            .s_axi_wlast(r_a_axi_wlast),
            .s_axi_wuser(r_a_axi_wuser),
            .s_axi_wvalid(r_a_axi_wvalid),
            .s_axi_wready(r_a_axi_wready),
            .s_axi_bid(r_a_axi_bid),
            .s_axi_bresp(r_a_axi_bresp),
            .s_axi_buser(r_a_axi_buser),
            .s_axi_bvalid(r_a_axi_bvalid),
            .s_axi_bready(r_a_axi_bready),
	    .s_axi_arid(r_a_axi_arid),
            .s_axi_araddr(r_a_axi_araddr),
            .s_axi_arlen(r_a_axi_arlen),
            .s_axi_arsize(r_a_axi_arsize),
            .s_axi_arburst(r_a_axi_arburst),
            .s_axi_arlock(r_a_axi_arlock),
            .s_axi_arcache(r_a_axi_arcache),
            .s_axi_arprot(r_a_axi_arprot),
            .s_axi_arqos(r_a_axi_arqos),
            .s_axi_arregion(r_a_axi_arregion),
            .s_axi_aruser(r_a_axi_aruser),
            .s_axi_arvalid(r_a_axi_arvalid),
            .s_axi_arready(r_a_axi_arready),
            .s_axi_rid(r_a_axi_rid),
            .s_axi_rdata(r_a_axi_rdata),
            .s_axi_rresp(r_a_axi_rresp),
            .s_axi_rlast(r_a_axi_rlast),
            .s_axi_ruser(r_a_axi_ruser),
            .s_axi_rvalid(r_a_axi_rvalid),
            .s_axi_rready(r_a_axi_rready),

	    //////master interface///////////////// 
	    .m_axi_awid(m_axi_awid),
            .m_axi_awaddr(m_axi_awaddr),
            .m_axi_awlen(m_axi_awlen),
            .m_axi_awsize(m_axi_awsize),
            .m_axi_awburst(m_axi_awburst),
            .m_axi_awlock(m_axi_awlock),
            .m_axi_awcache(m_axi_awcache),
            .m_axi_awprot(m_axi_awprot),
            .m_axi_awqos(m_axi_awqos),
            .m_axi_awregion(m_axi_awregion),
            .m_axi_awuser(m_axi_awuser),
            .m_axi_awvalid(m_axi_awvalid),
            .m_axi_awready(m_axi_awready),
            .m_axi_wdata(m_axi_wdata),
            .m_axi_wstrb(m_axi_wstrb),
            .m_axi_wlast(m_axi_wlast),
            .m_axi_wuser(m_axi_wuser),
            .m_axi_wvalid(m_axi_wvalid),
            .m_axi_wready(m_axi_wready),
            .m_axi_bid(m_axi_bid),
            .m_axi_bresp(m_axi_bresp),
            .m_axi_buser(m_axi_buser),
            .m_axi_bvalid(m_axi_bvalid),
            .m_axi_bready(m_axi_bready),
	    .m_axi_arid(m_axi_arid),
            .m_axi_araddr(m_axi_araddr),
            .m_axi_arlen(m_axi_arlen),
            .m_axi_arsize(m_axi_arsize),
            .m_axi_arburst(m_axi_arburst),
            .m_axi_arlock(m_axi_arlock),
            .m_axi_arcache(m_axi_arcache),
            .m_axi_arprot(m_axi_arprot),
            .m_axi_arqos(m_axi_arqos),
            .m_axi_arregion(m_axi_arregion),
            .m_axi_aruser(m_axi_aruser),
            .m_axi_arvalid(m_axi_arvalid),
            .m_axi_arready(m_axi_arready),
            .m_axi_rid(m_axi_rid),
            .m_axi_rdata(m_axi_rdata),
            .m_axi_rresp(m_axi_rresp),
            .m_axi_rlast(m_axi_rlast),
            .m_axi_ruser(m_axi_ruser),
            .m_axi_rvalid(m_axi_rvalid),
            .m_axi_rready(m_axi_rready)
      );
      end
      else begin
	     axi_fifo #(
	   .R_DATA_WIDTH(R_DATA_WIDTH),
	   .ADDR_WIDTH(ADDR_WIDTH),
	   .STRB_WIDTH(STRB_WIDTH),
	   .ID_WIDTH(ID_WIDTH),
	   .W_DATA_WIDTH(W_DATA_WIDTH)
          )
       axi_fifo_inst (
            .clk(clk),
            .rst(rst),

            /*
             * AXI slave interface
             */
            .s_axi_awid(s_axi_awid),
            .s_axi_awaddr(s_axi_awaddr),
            .s_axi_awlen(s_axi_awlen),
            .s_axi_awsize(s_axi_awsize),
            .s_axi_awburst(s_axi_awburst),
            .s_axi_awlock(s_axi_awlock),
            .s_axi_awcache(s_axi_awcache),
            .s_axi_awprot(s_axi_awprot),
            .s_axi_awqos(s_axi_awqos),
            .s_axi_awregion(s_axi_awregion),
            .s_axi_awuser(s_axi_awuser),
            .s_axi_awvalid(s_axi_awvalid),
            .s_axi_awready(s_axi_awready),
            .s_axi_wdata(s_axi_wdata),
            .s_axi_wstrb(s_axi_wstrb),
            .s_axi_wlast(s_axi_wlast),
            .s_axi_wuser(s_axi_wuser),
            .s_axi_wvalid(s_axi_wvalid),
            .s_axi_wready(s_axi_wready),
            .s_axi_bid(s_axi_bid),
            .s_axi_bresp(s_axi_bresp),
            .s_axi_buser(s_axi_buser),
            .s_axi_bvalid(s_axi_bvalid),
            .s_axi_bready(s_axi_bready),  
	    .s_axi_arid(s_axi_arid),
            .s_axi_araddr(s_axi_araddr),
            .s_axi_arlen(s_axi_arlen),
            .s_axi_arsize(s_axi_arsize),
            .s_axi_arburst(s_axi_arburst),
            .s_axi_arlock(s_axi_arlock),
            .s_axi_arcache(s_axi_arcache),
            .s_axi_arprot(s_axi_arprot),
            .s_axi_arqos(s_axi_arqos),
            .s_axi_arregion(s_axi_arregion),
            .s_axi_aruser(s_axi_aruser),
            .s_axi_arvalid(s_axi_arvalid),
            .s_axi_arready(s_axi_arready),
            .s_axi_rid(s_axi_rid),
            .s_axi_rdata(s_axi_rdata),
            .s_axi_rresp(s_axi_rresp),
            .s_axi_rlast(s_axi_rlast),
            .s_axi_ruser(s_axi_ruser),
            .s_axi_rvalid(s_axi_rvalid),
            .s_axi_rready(s_axi_rready),



            /*
             * AXI master interface
             */
            .m_axi_awid(f_a_axi_awid),
            .m_axi_awaddr(f_a_axi_awaddr),
            .m_axi_awlen(f_a_axi_awlen),
            .m_axi_awsize(f_a_axi_awsize),
            .m_axi_awburst(f_a_axi_awburst),
            .m_axi_awlock(f_a_axi_awlock),
            .m_axi_awcache(f_a_axi_awcache),
            .m_axi_awprot(f_a_axi_awprot),
            .m_axi_awqos(f_a_axi_awqos),
            .m_axi_awregion(f_a_axi_awregion),
            .m_axi_awuser(f_a_axi_awuser),
            .m_axi_awvalid(f_a_axi_awvalid),
            .m_axi_awready(f_a__axi_awready),
            .m_axi_wdata(f_a_axi_wdata),
            .m_axi_wstrb(f_a_axi_wstrb),
            .m_axi_wlast(f_a_axi_wlast),
            .m_axi_wuser(f_a_axi_wuser),
            .m_axi_wvalid(f_a_axi_wvalid),
            .m_axi_wready(f_a_axi_wready),
            .m_axi_bid(f_a_axi_bid),
            .m_axi_bresp(f_a_axi_bresp),
            .m_axi_buser(f_a_axi_buser),
            .m_axi_bvalid(f_a_axi_bvalid),
            .m_axi_bready(f_a_axi_bready),
	    .m_axi_arid(f_a_axi_arid),
	    .m_axi_araddr(f_a_axi_araddr),
	    .m_axi_arlen(f_a_axi_arlen),
            .m_axi_arsize(f_a_axi_arsize),
            .m_axi_arburst(f_a_axi_arburst),
            .m_axi_arlock(f_a_axi_arlock),
            .m_axi_arcache(f_a_axi_arcache),
            .m_axi_arprot(f_a_axi_arprot),
            .m_axi_arqos(f_a_axi_arqos),
            .m_axi_arregion(f_a_axi_arregion),
            .m_axi_aruser(f_a_axi_aruser),
            .m_axi_arvalid(f_a_axi_arvalid),
            .m_axi_arready(f_a_axi_arready),
            .m_axi_rid(f_a_axi_rid),
            .m_axi_rdata(f_a_axi_rdata),
            .m_axi_rresp(f_a_axi_rresp),
            .m_axi_rlast(f_a_axi_rlast),
            .m_axi_ruser(f_a_axi_ruser),
            .m_axi_rvalid(f_a_axi_rvalid),
            .m_axi_rready(f_a_axi_rready)

           );
	    axi_adapter # (
	   .S_R_DATA_WIDTH(R_DATA_WIDTH),
	   .ADDR_WIDTH(ADDR_WIDTH),
	   .ID_WIDTH(ID_WIDTH),
	   .S_W_DATA_WIDTH(W_DATA_WIDTH),
	   .M_W_DATA_WIDTH(CROSSBAR_D_WIDTH),
	   .M_R_DATA_WIDTH(CROSSBAR_D_WIDTH)

                )
	     
	adapter_instance
	   (
	    .clk(clk),
            .rst(rst),

	    .s_axi_awid(f_a_axi_awid),
            .s_axi_awaddr(f_a_axi_awaddr),
            .s_axi_awlen(f_a_axi_awlen),
            .s_axi_awsize(f_a_axi_awsize),
            .s_axi_awburst(f_a_axi_awburst),
            .s_axi_awlock(f_a_axi_awlock),
            .s_axi_awcache(f_a_axi_awcache),
            .s_axi_awprot(f_a_axi_awprot),
            .s_axi_awqos(f_a_axi_awqos),
            .s_axi_awregion(f_a_axi_awregion),
            .s_axi_awuser(f_a_axi_awuser),
            .s_axi_awvalid(f_a_axi_awvalid),
            .s_axi_awready(f_a_axi_awready),
            .s_axi_wdata(f_a_axi_wdata),
            .s_axi_wstrb(f_a_axi_wstrb),
            .s_axi_wlast(f_a_axi_wlast),
            .s_axi_wuser(f_a_axi_wuser),
            .s_axi_wvalid(f_a_axi_wvalid),
            .s_axi_wready(f_a_axi_wready),
            .s_axi_bid(f_a_axi_bid),
            .s_axi_bresp(f_a_axi_bresp),
            .s_axi_buser(f_a_axi_buser),
            .s_axi_bvalid(f_a_axi_bvalid),
            .s_axi_bready(f_a_axi_bready),
	    .s_axi_arid(f_a_axi_arid),
            .s_axi_araddr(f_a_axi_araddr),
            .s_axi_arlen(f_a_axi_arlen),
            .s_axi_arsize(f_a_axi_arsize),
            .s_axi_arburst(f_a_axi_arburst),
            .s_axi_arlock(f_a_axi_arlock),
            .s_axi_arcache(f_a_axi_arcache),
            .s_axi_arprot(f_a_axi_arprot),
            .s_axi_arqos(f_a_axi_arqos),
            .s_axi_arregion(f_a_axi_arregion),
            .s_axi_aruser(f_a_axi_aruser),
            .s_axi_arvalid(f_a_axi_arvalid),
            .s_axi_arready(f_a_axi_arready),
            .s_axi_rid(f_a_axi_rid),
            .s_axi_rdata(f_a_axi_rdata),
            .s_axi_rresp(f_a_axi_rresp),
            .s_axi_rlast(f_a_axi_rlast),
            .s_axi_ruser(f_a_axi_ruser),
            .s_axi_rvalid(f_a_axi_rvalid),
            .s_axi_rready(f_a_axi_rready),

	    //////master interface///////////////// 
	    .m_axi_awid(m_axi_awid),
            .m_axi_awaddr(m_axi_awaddr),
            .m_axi_awlen(m_axi_awlen),
            .m_axi_awsize(m_axi_awsize),
            .m_axi_awburst(m_axi_awburst),
            .m_axi_awlock(m_axi_awlock),
            .m_axi_awcache(m_axi_awcache),
            .m_axi_awprot(m_axi_awprot),
            .m_axi_awqos(m_axi_awqos),
            .m_axi_awregion(m_axi_awregion),
            .m_axi_awuser(m_axi_awuser),
            .m_axi_awvalid(m_axi_awvalid),
            .m_axi_awready(m_axi_awready),
            .m_axi_wdata(m_axi_wdata),
            .m_axi_wstrb(m_axi_wstrb),
            .m_axi_wlast(m_axi_wlast),
            .m_axi_wuser(m_axi_wuser),
            .m_axi_wvalid(m_axi_wvalid),
            .m_axi_wready(m_axi_wready),
            .m_axi_bid(m_axi_bid),
            .m_axi_bresp(m_axi_bresp),
            .m_axi_buser(m_axi_buser),
            .m_axi_bvalid(m_axi_bvalid),
            .m_axi_bready(m_axi_bready),
	    .m_axi_arid(m_axi_arid),
            .m_axi_araddr(m_axi_araddr),
            .m_axi_arlen(m_axi_arlen),
            .m_axi_arsize(m_axi_arsize),
            .m_axi_arburst(m_axi_arburst),
            .m_axi_arlock(m_axi_arlock),
            .m_axi_arcache(m_axi_arcache),
            .m_axi_arprot(m_axi_arprot),
            .m_axi_arqos(m_axi_arqos),
            .m_axi_arregion(m_axi_arregion),
            .m_axi_aruser(m_axi_aruser),
            .m_axi_arvalid(m_axi_arvalid),
            .m_axi_arready(m_axi_arready),
            .m_axi_rid(m_axi_rid),
            .m_axi_rdata(m_axi_rdata),
            .m_axi_rresp(m_axi_rresp),
            .m_axi_rlast(m_axi_rlast),
            .m_axi_ruser(m_axi_ruser),
            .m_axi_rvalid(m_axi_rvalid),
            .m_axi_rready(m_axi_rready)
     );
     end
   endgenerate


endmodule
















