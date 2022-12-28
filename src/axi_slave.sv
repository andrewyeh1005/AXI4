`include "./include/AXI_define.svh"
module axi_slave(
  input  logic  aclk,
  input  logic  areset_n,
  //signal connect to AXI
  input   logic [     `ID_SLV - 1:0]  awid,
  input   logic [ `ADDR_WIDTH - 1:0]  awaddr,
  input   logic [ `LEN_WIDTH  - 1:0]  awlen,
  input   logic [ `SIZE_WIDTH - 1:0]  awsize,
  input   logic [`BURST_WIDTH - 1:0]  awburst,
  input   logic                       awvalid,
  output  logic                       awready,
  input   logic [ `DATA_WIDTH - 1:0]  wdata,
  input   logic [ `STRB_WIDTH - 1:0]  wstrb,
  input   logic                       wlast,
  input   logic                       wvalid,
  output  logic                       wready,
  output  logic [     `ID_SLV - 1:0]  bid,
  output  logic [ `RESP_WIDTH - 1:0]  bresp,
  output  logic                       bvalid,
  input   logic                       bready,
  input   logic [     `ID_SLV - 1:0]  arid,
  input   logic [ `ADDR_WIDTH - 1:0]  araddr,
  input   logic [ `LEN_WIDTH  - 1:0]  arlen,
  input   logic [ `SIZE_WIDTH - 1:0]  arsize,
  input   logic [`BURST_WIDTH - 1:0]  arburst,
  input   logic                       arvalid,
  output  logic                       arready,
  output  logic [     `ID_SLV - 1:0]  rid,
  output  logic [ `DATA_WIDTH - 1:0]  rdata,
  output  logic [ `RESP_WIDTH - 1:0]  rresp,
  output  logic                       rlast,
  output  logic                       rvalid,
  input   logic                       rready
  //signal connect to core
  /*---------------------------------------
          
            signal connect to core

  ---------------------------------------*/
);

typedef enum logic [2:0] {
  IDLE, RADDR, RDATA, WADDR, WDATA, BRESP
}state_e;
state_e cs,ns;

logic  [ `LEN_WIDTH  - 1:0]  write_len_count;
logic  [ `LEN_WIDTH  - 1:0]  read_len_count;
logic  [     `ID_SLV - 1:0]  awid_reg;
logic  [ `ADDR_WIDTH - 1:0]  awaddr_reg;
logic  [ `LEN_WIDTH  - 1:0]  awlen_reg;
logic  [ `SIZE_WIDTH - 1:0]  awsize_reg;
logic  [`BURST_WIDTH - 1:0]  awburst_reg;   
logic  [ `DATA_WIDTH - 1:0]  wdata_reg;
logic  [ `STRB_WIDTH - 1:0]  wstrb_reg;
logic  [     `ID_SLV - 1:0]  arid_reg;
logic  [ `ADDR_WIDTH - 1:0]  araddr_reg;
logic  [ `LEN_WIDTH  - 1:0]  arlen_reg;
logic  [ `SIZE_WIDTH - 1:0]  arsize_reg;
logic  [`BURST_WIDTH - 1:0]  arburst_reg;
logic  [ `DATA_WIDTH - 1:0]  data_from_core;

//----------------------store master info-----------------------------


always_ff@(posedge aclk) begin
  if(!areset_n) begin
    awid_reg    <= `ID_SLV'd0;
    awaddr_reg  <= `ADDR_WIDTH'd0;
    awlen_reg   <= `LEN_WIDTH'd0;
    awsize_reg  <= `SIZE_WIDTH'd0;
    awburst_reg <= `BURST_WIDTH'd0;
    wdata_reg   <= `DATA_WIDTH'd0;
    wstrb_reg   <= `STRB_WIDTH'hf;
    arid_reg    <= `ID_SLV'd0;
    araddr_reg  <= `ADDR_WIDTH'd0;
    arlen_reg   <= `LEN_WIDTH'd0;
    arsize_reg  <= `SIZE_WIDTH'd0;
    arburst_reg <= `BURST_WIDTH'd0;
  end else if (arvalid & arready) begin//AR handshake
    arid_reg    <= arid;
    araddr_reg  <= araddr;
    arlen_reg   <= arlen;
    arsize_reg  <= arsize;
    arburst_reg <= arburst;
  end else if (awvalid & awready) begin//AW handshake
    awid_reg    <= awid;
    awaddr_reg  <= awaddr;
    awlen_reg   <= awlen;
    awsize_reg  <= awsize;
    awburst_reg <= awburst;
  end else if (wvalid & wready) begin//W handshake
    wdata_reg   <= wdata;
    wstrb_reg   <= wstrb;
  end
end
 
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
    IDLE  : ns = (awvalid)?(WADDR):((arvalid)?(RADDR):(IDLE));
    RADDR : ns = (arvalid & arready)?(RDATA):(RADDR);
    RDATA : ns = (rvalid & rready & rlast & (rresp == `RESP_OKAY))?(IDLE):(RDATA);
    WADDR : ns = (awvalid & awready)?(WDATA):(WADDR);
    WDATA : ns = (wvalid & wready & wlast)?(BRESP):(WDATA);
    BRESP : ns = (bvalid & bready & (bresp == `RESP_OKAY))?(IDLE):(BRESP);
    default:;
  endcase
end


always_ff@(posedge aclk) begin
  if(!areset_n) begin
    read_len_count    <= `LEN_WIDTH'd0;
    write_len_count   <= `LEN_WIDTH'd0;
  end else begin
    if(wvalid & wready) begin
      write_len_count <= write_len_count + `LEN_WIDTH'd1;
    end else if (cs == IDLE) begin
      write_len_count <= `LEN_WIDTH'd0;
    end
    if (rvalid & rready) begin
      read_len_count  <= read_len_count + `LEN_WIDTH'd1;
    end else if (cs == IDLE) begin
      read_len_count  <= `LEN_WIDTH'd0;
    end
  end
end


//----------------------[ signal connect to AXI ]-----------------------------//
//AW
assign awready = (cs == WADDR)?(1'd1):(1'd0);
//W
assign wready  = (cs == WDATA)?(1'd1):(1'd0);
//B
assign bresp   = `RESP_OKAY;
assign bvalid  = (cs == BRESP)?(1'd1):(1'd0);
assign bid     = (cs == BRESP)?(awid_reg):(`ID_SLV'hf);
//AR
assign arready = (cs == RADDR)?(1'd1):(1'd0);
assign rdata   = ((cs == RDATA) & rvalid & rready)?(data_from_core):(`DATA_WIDTH'b0);
//R
assign rlast   = ((cs == RDATA) & (read_len_count == arlen_reg))?(1'd1):(1'd0);
assign rresp   = (cs == RDATA)?(`RESP_OKAY):(`RESP_DECERR);
assign rvalid  = (cs == RDATA)?(1'd1):(1'd0);
assign rid     = (cs == RDATA)?(arid_reg):(`ID_SLV'hf);

//----------------------[ signal connect to core ]-----------------------------//
assign data_from_core = 32'hdeadbeef;

endmodule
