`define MAX_BURST_LEN  4'd4
`include "./include/AXI_define.svh"

module axi_master(
  input   logic                        aclk,
  input   logic                        areset_n,
  //signal conncect to core
  input   logic [  `ADDR_WIDTH - 1:0]  write_addr,
  input   logic [  `DATA_WIDTH - 1:0]  write_data,
  input   logic [  `LEN_WIDTH  - 1:0]  write_len,
  input   logic [ `BURST_WIDTH - 1:0]  write_burst,
  input   logic [  `STRB_WIDTH - 1:0]  write_strb,
  input   logic [  `SIZE_WIDTH - 1:0]  write_size,
  input   logic                        write_en,
  input   logic [  `ADDR_WIDTH - 1:0]  read_addr,
  input   logic [  `LEN_WIDTH  - 1:0]  read_len,
  input   logic [ `BURST_WIDTH - 1:0]  read_burst,
  input   logic [  `SIZE_WIDTH - 1:0]  read_size,
  output  logic [  `DATA_WIDTH - 1:0]  read_data,
  input   logic                        read_en,
  //signal connect to AXI
  output  logic [      `ID_MAS - 1:0]  awid,
  output  logic [  `ADDR_WIDTH - 1:0]  awaddr,
  output  logic [  `LEN_WIDTH  - 1:0]  awlen,
  output  logic [  `SIZE_WIDTH - 1:0]  awsize,
  output  logic [ `BURST_WIDTH - 1:0]  awburst,
  output  logic                        awvalid,
  input   logic                        awready,
  output  logic [ `DATA_WIDTH - 1:0]   wdata,
  output  logic [ `STRB_WIDTH - 1:0]   wstrb,
  output  logic                        wlast,
  output  logic                        wvalid,
  input   logic                        wready,
  input   logic [     `ID_MAS - 1:0]   bid,
  input   logic [ `RESP_WIDTH - 1:0]   bresp,
  input   logic                        bvalid,
  output  logic                        bready,
  output  logic [     `ID_MAS - 1:0]   arid,
  output  logic [ `ADDR_WIDTH - 1:0]   araddr,
  output  logic [ `LEN_WIDTH  - 1:0]   arlen,
  output  logic [ `SIZE_WIDTH - 1:0]   arsize,
  output  logic [`BURST_WIDTH - 1:0]   arburst,
  output  logic                        arvalid,
  input   logic                        arready,
  input   logic [     `ID_MAS - 1:0]   rid,
  input   logic [ `DATA_WIDTH - 1:0]   rdata,
  input   logic [ `RESP_WIDTH - 1:0]   rresp,
  input   logic                        rlast,
  input   logic                        rvalid,
  output  logic                        rready
);

logic [ `LEN_WIDTH - 1:0] read_len_modify;  
logic [`SIZE_WIDTH - 1:0] read_size_modify; 
logic [ `LEN_WIDTH - 1:0] write_len_modify;
logic [`SIZE_WIDTH - 1:0] write_size_modify;
logic [`ADDR_WIDTH - 1:0] max_rdata_length; 
logic [`ADDR_WIDTH - 1:0] max_wdata_length; 
logic [`ADDR_WIDTH - 1:0] RfourKBound;      
logic [`ADDR_WIDTH - 1:0] WfourKBound;

typedef enum logic [2:0] {
  IDLE, RADDR, RDATA, WADDR, WDATA, BRESP
}state_e;
state_e cs,ns;

logic [`LEN_WIDTH  - 1:0]  write_len_count;

//----------------------[ FSM ]-----------------------------//
always_ff@(posedge aclk) begin
  if(!areset_n) begin
    cs <= IDLE;
  end else begin
    cs <= ns;
  end
end

always_comb begin
  ns           = IDLE;
  unique case(cs)
    IDLE  : ns = (write_en)?(WADDR):((read_en)?(RADDR):(IDLE));
    RADDR : ns = (arvalid & arready)?(RDATA):(RADDR);
    RDATA : ns = (rvalid & rready & rlast & (rresp == `RESP_OKAY) & (rid == 4'h0))?(IDLE):(RDATA);
    WADDR : ns = (awvalid & awready)?(WDATA):(WADDR);
    WDATA : ns = (wvalid & wready & wlast)?(BRESP):(WDATA);
    BRESP : ns = (bvalid & bready & (bresp == `RESP_OKAY) & (bid == 4'h0))?(IDLE):(BRESP);
    default:;
  endcase
end

always_ff@(posedge aclk) begin
  if(!areset_n) begin
    write_len_count   <= 4'd0;
  end else begin
    if(wvalid & wready) begin
      write_len_count <= write_len_count + 4'd1;
    end else if (cs == IDLE) begin
      write_len_count <= 4'd0;
    end
  end
end

//----------------------[ signal connect to AXI ]-----------------------------//
//AW
assign awid      = 4'd0;//inordering
assign awvalid   = ((cs == WADDR) & (awburst != 2'b11))?(1'd1):(1'd0);
//W
assign wlast     = (wvalid & (write_len_count == awlen))?(1'd1):(1'd0);
assign wvalid    = (cs == WDATA)?(1'd1):(1'd0);
//B
assign bready    = (cs == BRESP)?(1'd1):(1'd0);
//AR
assign arid      = 4'd0;//inordering
assign arvalid   = (cs == RADDR)?(1'd1):(1'd0);
//R
assign rready    = (cs == RDATA)?(1'd1):(1'd0);

always_ff@(posedge aclk) begin
  if(!areset_n) begin
    araddr  <= 32'd0;
    arlen   <= 4'd0;
    arsize  <= 3'd0;
    arburst <= 2'd0;
  end else if ((cs == IDLE) &  read_en) begin//AR handshake
    araddr  <= (RfourKBound[31:12] == read_addr[31:12])?(read_addr):({read_addr[31:12]+20'd1,12'h0} - max_rdata_length);
    arlen   <= read_len_modify;
    arsize  <= read_size_modify;
    arburst <= (read_burst == 2'b11)?(2'b00):(read_burst);
  end
 
end

always_ff@(posedge aclk) begin
  if(!areset_n) begin
    awaddr  <= 32'd0;
    awlen   <= 4'd0;
    awsize  <= 3'd0;
    awburst <= 2'd0;
    wdata   <= 32'd0;
    wstrb   <= 4'hf;
  end else if ((cs == IDLE) &  write_en) begin//AW handshake
    awaddr  <= (WfourKBound[31:12] == write_addr[31:12])?(write_addr):({write_addr[31:12]+20'd1,12'h000} - max_wdata_length);
    awsize  <= write_size_modify;
    awburst <= write_burst;
    wdata   <= write_data;
    wstrb   <= write_strb;
    awlen   <= write_len;
  end
end

//----------------------[ signal connect to core ]-----------------------------//
assign read_data = (rready & rvalid)?(rdata):(32'd0);
assign read_len_modify   = (read_len >= `MAX_BURST_LEN)?(`MAX_BURST_LEN - 4'd1):(read_len);
assign read_size_modify  = (read_size >= `SIZE_4_BYTE)?(`SIZE_4_BYTE):(read_size);
assign write_len_modify  = (awlen >= `MAX_BURST_LEN)?(`MAX_BURST_LEN - 4'd1):(write_len);
assign write_size_modify = (write_size >= `SIZE_4_BYTE)?(`SIZE_4_BYTE):(write_size);
assign max_rdata_length  = {21'd0,(read_len+4'b1)<< ( read_size)};
assign max_wdata_length  = {21'd0,(awlen+4'b1)<< (write_size)};
assign RfourKBound       = read_addr  + max_rdata_length;
assign WfourKBound       = write_addr + max_wdata_length;


endmodule