var g_data = {"name":"axi_fifo_rd.v","src":"/*\n\nCopyright (c) 2018 Alex Forencich\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in\nall copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\nTHE SOFTWARE.\n\n*/\n\n// Language: Verilog 2001\n\n`resetall\n`timescale 1ns / 1ps\n`default_nettype none\n\n/*\n * AXI4 FIFO (read)\n */\nmodule axi_fifo_rd #\n(\n    // Width of data bus in bits\n    parameter DATA_WIDTH = 32,\n    // Width of address bus in bits\n    parameter ADDR_WIDTH = 32,\n    // Width of wstrb (width of data bus in words)\n    parameter STRB_WIDTH = (DATA_WIDTH/8),\n    // Width of ID signal\n    parameter ID_WIDTH = 8,\n    // Propagate aruser signal\n    parameter ARUSER_ENABLE = 0,\n    // Width of aruser signal\n    parameter ARUSER_WIDTH = 1,\n    // Propagate ruser signal\n    parameter RUSER_ENABLE = 0,\n    // Width of ruser signal\n    parameter RUSER_WIDTH = 1,\n    // Read data FIFO depth (cycles)\n    parameter FIFO_DEPTH = 32,\n    // Hold read address until space available in FIFO for data, if possible\n    parameter FIFO_DELAY = 0\n)\n(\n    input  wire                     clk,\n    input  wire                     rst,\n\n    /*\n     * AXI slave interface\n     */\n    input  wire [ID_WIDTH-1:0]      s_axi_arid,\n    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,\n    input  wire [7:0]               s_axi_arlen,\n    input  wire [2:0]               s_axi_arsize,\n    input  wire [1:0]               s_axi_arburst,\n    input  wire                     s_axi_arlock,\n    input  wire [3:0]               s_axi_arcache,\n    input  wire [2:0]               s_axi_arprot,\n    input  wire [3:0]               s_axi_arqos,\n    input  wire [3:0]               s_axi_arregion,\n    input  wire [ARUSER_WIDTH-1:0]  s_axi_aruser,\n    input  wire                     s_axi_arvalid,\n    output wire                     s_axi_arready,\n    output wire [ID_WIDTH-1:0]      s_axi_rid,\n    output wire [DATA_WIDTH-1:0]    s_axi_rdata,\n    output wire [1:0]               s_axi_rresp,\n    output wire                     s_axi_rlast,\n    output wire [RUSER_WIDTH-1:0]   s_axi_ruser,\n    output wire                     s_axi_rvalid,\n    input  wire                     s_axi_rready,\n\n    /*\n     * AXI master interface\n     */\n    output wire [ID_WIDTH-1:0]      m_axi_arid,\n    output wire [ADDR_WIDTH-1:0]    m_axi_araddr,\n    output wire [7:0]               m_axi_arlen,\n    output wire [2:0]               m_axi_arsize,\n    output wire [1:0]               m_axi_arburst,\n    output wire                     m_axi_arlock,\n    output wire [3:0]               m_axi_arcache,\n    output wire [2:0]               m_axi_arprot,\n    output wire [3:0]               m_axi_arqos,\n    output wire [3:0]               m_axi_arregion,\n    output wire [ARUSER_WIDTH-1:0]  m_axi_aruser,\n    output wire                     m_axi_arvalid,\n    input  wire                     m_axi_arready,\n    input  wire [ID_WIDTH-1:0]      m_axi_rid,\n    input  wire [DATA_WIDTH-1:0]    m_axi_rdata,\n    input  wire [1:0]               m_axi_rresp,\n    input  wire                     m_axi_rlast,\n    input  wire [RUSER_WIDTH-1:0]   m_axi_ruser,\n    input  wire                     m_axi_rvalid,\n    output wire                     m_axi_rready\n);\n\nparameter LAST_OFFSET  = DATA_WIDTH;\nparameter ID_OFFSET    = LAST_OFFSET + 1;\nparameter RESP_OFFSET  = ID_OFFSET + ID_WIDTH;\nparameter RUSER_OFFSET = RESP_OFFSET + 2;\nparameter RWIDTH       = RUSER_OFFSET + (RUSER_ENABLE ? RUSER_WIDTH : 0);\n\nparameter FIFO_ADDR_WIDTH = $clog2(FIFO_DEPTH);\n\nreg [FIFO_ADDR_WIDTH:0] wr_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}, wr_ptr_next;\nreg [FIFO_ADDR_WIDTH:0] wr_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};\nreg [FIFO_ADDR_WIDTH:0] rd_ptr_reg = {FIFO_ADDR_WIDTH+1{1'b0}}, rd_ptr_next;\nreg [FIFO_ADDR_WIDTH:0] rd_addr_reg = {FIFO_ADDR_WIDTH+1{1'b0}};\n\n(* ramstyle = \"no_rw_check\" *)\nreg [RWIDTH-1:0] mem[(2**FIFO_ADDR_WIDTH)-1:0];\nreg [RWIDTH-1:0] mem_read_data_reg;\nreg mem_read_data_valid_reg = 1'b0, mem_read_data_valid_next;\n\nwire [RWIDTH-1:0] m_axi_r;\n\nreg [RWIDTH-1:0] s_axi_r_reg;\nreg s_axi_rvalid_reg = 1'b0, s_axi_rvalid_next;\n\n// full when first MSB different but rest same\nwire full = ((wr_ptr_reg[FIFO_ADDR_WIDTH] != rd_ptr_reg[FIFO_ADDR_WIDTH]) &&\n             (wr_ptr_reg[FIFO_ADDR_WIDTH-1:0] == rd_ptr_reg[FIFO_ADDR_WIDTH-1:0]));\n// empty when pointers match exactly\nwire empty = wr_ptr_reg == rd_ptr_reg;\n\n// control signals\nreg write;\nreg read;\nreg store_output;\n\nassign m_axi_rready = !full;\n\ngenerate\n    assign m_axi_r[DATA_WIDTH-1:0] = m_axi_rdata;\n    assign m_axi_r[LAST_OFFSET] = m_axi_rlast;\n    assign m_axi_r[ID_OFFSET +: ID_WIDTH] = m_axi_rid;\n    assign m_axi_r[RESP_OFFSET +: 2] = m_axi_rresp;\n    if (RUSER_ENABLE) assign m_axi_r[RUSER_OFFSET +: RUSER_WIDTH] = m_axi_ruser;\nendgenerate\n\ngenerate\n\nif (FIFO_DELAY) begin\n    // store AR channel value until there is enough space to store R channel burst in FIFO or FIFO is empty\n\n    localparam COUNT_WIDTH = (FIFO_ADDR_WIDTH > 8 ? FIFO_ADDR_WIDTH : 8) + 1;\n\n    localparam [1:0]\n        STATE_IDLE = 1'd0,\n        STATE_WAIT = 1'd1;\n\n    reg [1:0] state_reg = STATE_IDLE, state_next;\n\n    reg [COUNT_WIDTH-1:0] count_reg = 0, count_next;\n\n    reg [ID_WIDTH-1:0] m_axi_arid_reg = {ID_WIDTH{1'b0}}, m_axi_arid_next;\n    reg [ADDR_WIDTH-1:0] m_axi_araddr_reg = {ADDR_WIDTH{1'b0}}, m_axi_araddr_next;\n    reg [7:0] m_axi_arlen_reg = 8'd0, m_axi_arlen_next;\n    reg [2:0] m_axi_arsize_reg = 3'd0, m_axi_arsize_next;\n    reg [1:0] m_axi_arburst_reg = 2'd0, m_axi_arburst_next;\n    reg m_axi_arlock_reg = 1'b0, m_axi_arlock_next;\n    reg [3:0] m_axi_arcache_reg = 4'd0, m_axi_arcache_next;\n    reg [2:0] m_axi_arprot_reg = 3'd0, m_axi_arprot_next;\n    reg [3:0] m_axi_arqos_reg = 4'd0, m_axi_arqos_next;\n    reg [3:0] m_axi_arregion_reg = 4'd0, m_axi_arregion_next;\n    reg [ARUSER_WIDTH-1:0] m_axi_aruser_reg = {ARUSER_WIDTH{1'b0}}, m_axi_aruser_next;\n    reg m_axi_arvalid_reg = 1'b0, m_axi_arvalid_next;\n\n    reg s_axi_arready_reg = 1'b0, s_axi_arready_next;\n\n    assign m_axi_arid = m_axi_arid_reg;\n    assign m_axi_araddr = m_axi_araddr_reg;\n    assign m_axi_arlen = m_axi_arlen_reg;\n    assign m_axi_arsize = m_axi_arsize_reg;\n    assign m_axi_arburst = m_axi_arburst_reg;\n    assign m_axi_arlock = m_axi_arlock_reg;\n    assign m_axi_arcache = m_axi_arcache_reg;\n    assign m_axi_arprot = m_axi_arprot_reg;\n    assign m_axi_arqos = m_axi_arqos_reg;\n    assign m_axi_arregion = m_axi_arregion_reg;\n    assign m_axi_aruser = ARUSER_ENABLE ? m_axi_aruser_reg : {ARUSER_WIDTH{1'b0}};\n    assign m_axi_arvalid = m_axi_arvalid_reg;\n\n    assign s_axi_arready = s_axi_arready_reg;\n\n    always @* begin\n        state_next = STATE_IDLE;\n\n        count_next = count_reg;\n\n        m_axi_arid_next = m_axi_arid_reg;\n        m_axi_araddr_next = m_axi_araddr_reg;\n        m_axi_arlen_next = m_axi_arlen_reg;\n        m_axi_arsize_next = m_axi_arsize_reg;\n        m_axi_arburst_next = m_axi_arburst_reg;\n        m_axi_arlock_next = m_axi_arlock_reg;\n        m_axi_arcache_next = m_axi_arcache_reg;\n        m_axi_arprot_next = m_axi_arprot_reg;\n        m_axi_arqos_next = m_axi_arqos_reg;\n        m_axi_arregion_next = m_axi_arregion_reg;\n        m_axi_aruser_next = m_axi_aruser_reg;\n        m_axi_arvalid_next = m_axi_arvalid_reg && !m_axi_arready;\n        s_axi_arready_next = s_axi_arready_reg;\n\n        case (state_reg)\n            STATE_IDLE: begin\n                s_axi_arready_next = !m_axi_arvalid || m_axi_arready;\n\n                if (s_axi_arready && s_axi_arvalid) begin\n                    s_axi_arready_next = 1'b0;\n\n                    m_axi_arid_next = s_axi_arid;\n                    m_axi_araddr_next = s_axi_araddr;\n                    m_axi_arlen_next = s_axi_arlen;\n                    m_axi_arsize_next = s_axi_arsize;\n                    m_axi_arburst_next = s_axi_arburst;\n                    m_axi_arlock_next = s_axi_arlock;\n                    m_axi_arcache_next = s_axi_arcache;\n                    m_axi_arprot_next = s_axi_arprot;\n                    m_axi_arqos_next = s_axi_arqos;\n                    m_axi_arregion_next = s_axi_arregion;\n                    m_axi_aruser_next = s_axi_aruser;\n\n                    if (count_reg == 0 || count_reg + m_axi_arlen_next + 1 <= 2**FIFO_ADDR_WIDTH) begin\n                        count_next = count_reg + m_axi_arlen_next + 1;\n                        m_axi_arvalid_next = 1'b1;\n                        s_axi_arready_next = 1'b0;\n                        state_next = STATE_IDLE;\n                    end else begin\n                        s_axi_arready_next = 1'b0;\n                        state_next = STATE_WAIT;\n                    end\n                end else begin\n                    state_next = STATE_IDLE;\n                end\n            end\n            STATE_WAIT: begin\n                s_axi_arready_next = 1'b0;\n\n                if (count_reg == 0 || count_reg + m_axi_arlen_reg + 1 <= 2**FIFO_ADDR_WIDTH) begin\n                    count_next = count_reg + m_axi_arlen_reg + 1;\n                    m_axi_arvalid_next = 1'b1;\n                    state_next = STATE_IDLE;\n                end else begin\n                    state_next = STATE_WAIT;\n                end\n            end\n        endcase\n\n        if (s_axi_rready && s_axi_rvalid) begin\n            count_next = count_next - 1;\n        end\n    end\n\n    always @(posedge clk) begin\n        state_reg <= state_next;\n        count_reg <= count_next;\n\n        m_axi_arid_reg <= m_axi_arid_next;\n        m_axi_araddr_reg <= m_axi_araddr_next;\n        m_axi_arlen_reg <= m_axi_arlen_next;\n        m_axi_arsize_reg <= m_axi_arsize_next;\n        m_axi_arburst_reg <= m_axi_arburst_next;\n        m_axi_arlock_reg <= m_axi_arlock_next;\n        m_axi_arcache_reg <= m_axi_arcache_next;\n        m_axi_arprot_reg <= m_axi_arprot_next;\n        m_axi_arqos_reg <= m_axi_arqos_next;\n        m_axi_arregion_reg <= m_axi_arregion_next;\n        m_axi_aruser_reg <= m_axi_aruser_next;\n        m_axi_arvalid_reg <= m_axi_arvalid_next;\n        s_axi_arready_reg <= s_axi_arready_next;\n\n        if (rst) begin\n            state_reg <= STATE_IDLE;\n            count_reg <= {COUNT_WIDTH{1'b0}};\n            m_axi_arvalid_reg <= 1'b0;\n            s_axi_arready_reg <= 1'b0;\n        end\n    end\nend else begin\n    // bypass AR channel\n    assign m_axi_arid = s_axi_arid;\n    assign m_axi_araddr = s_axi_araddr;\n    assign m_axi_arlen = s_axi_arlen;\n    assign m_axi_arsize = s_axi_arsize;\n    assign m_axi_arburst = s_axi_arburst;\n    assign m_axi_arlock = s_axi_arlock;\n    assign m_axi_arcache = s_axi_arcache;\n    assign m_axi_arprot = s_axi_arprot;\n    assign m_axi_arqos = s_axi_arqos;\n    assign m_axi_arregion = s_axi_arregion;\n    assign m_axi_aruser = ARUSER_ENABLE ? s_axi_aruser : {ARUSER_WIDTH{1'b0}};\n    assign m_axi_arvalid = s_axi_arvalid;\n    assign s_axi_arready = m_axi_arready;\nend\n\nendgenerate\n\nassign s_axi_rvalid = s_axi_rvalid_reg;\n\nassign s_axi_rdata = s_axi_r_reg[DATA_WIDTH-1:0];\nassign s_axi_rlast = s_axi_r_reg[LAST_OFFSET];\nassign s_axi_rid   = s_axi_r_reg[ID_OFFSET +: ID_WIDTH];\nassign s_axi_rresp = s_axi_r_reg[RESP_OFFSET +: 2];\nassign s_axi_ruser = RUSER_ENABLE ? s_axi_r_reg[RUSER_OFFSET +: RUSER_WIDTH] : {RUSER_WIDTH{1'b0}};\n\n// Write logic\nalways @* begin\n    write = 1'b0;\n\n    wr_ptr_next = wr_ptr_reg;\n\n    if (m_axi_rvalid) begin\n        // input data valid\n        if (!full) begin\n            // not full, perform write\n            write = 1'b1;\n            wr_ptr_next = wr_ptr_reg + 1;\n        end\n    end\nend\n\nalways @(posedge clk) begin\n    wr_ptr_reg <= wr_ptr_next;\n    wr_addr_reg <= wr_ptr_next;\n\n    if (write) begin\n        mem[wr_addr_reg[FIFO_ADDR_WIDTH-1:0]] <= m_axi_r;\n    end\n\n    if (rst) begin\n        wr_ptr_reg <= {FIFO_ADDR_WIDTH+1{1'b0}};\n    end\nend\n\n// Read logic\nalways @* begin\n    read = 1'b0;\n\n    rd_ptr_next = rd_ptr_reg;\n\n    mem_read_data_valid_next = mem_read_data_valid_reg;\n\n    if (store_output || !mem_read_data_valid_reg) begin\n        // output data not valid OR currently being transferred\n        if (!empty) begin\n            // not empty, perform read\n            read = 1'b1;\n            mem_read_data_valid_next = 1'b1;\n            rd_ptr_next = rd_ptr_reg + 1;\n        end else begin\n            // empty, invalidate\n            mem_read_data_valid_next = 1'b0;\n        end\n    end\nend\n\nalways @(posedge clk) begin\n    rd_ptr_reg <= rd_ptr_next;\n    rd_addr_reg <= rd_ptr_next;\n\n    mem_read_data_valid_reg <= mem_read_data_valid_next;\n\n    if (read) begin\n        mem_read_data_reg <= mem[rd_addr_reg[FIFO_ADDR_WIDTH-1:0]];\n    end\n\n    if (rst) begin\n        rd_ptr_reg <= {FIFO_ADDR_WIDTH+1{1'b0}};\n        mem_read_data_valid_reg <= 1'b0;\n    end\nend\n\n// Output register\nalways @* begin\n    store_output = 1'b0;\n\n    s_axi_rvalid_next = s_axi_rvalid_reg;\n\n    if (s_axi_rready || !s_axi_rvalid) begin\n        store_output = 1'b1;\n        s_axi_rvalid_next = mem_read_data_valid_reg;\n    end\nend\n\nalways @(posedge clk) begin\n    s_axi_rvalid_reg <= s_axi_rvalid_next;\n\n    if (store_output) begin\n        s_axi_r_reg <= mem_read_data_reg;\n    end\n\n    if (rst) begin\n        s_axi_rvalid_reg <= 1'b0;\n    end\nend\n\nendmodule\n\n`resetall\n","lang":"verilog"};
processSrcData(g_data);