`include "decoder.sv"
`include "priority_arbiter.sv"
`include "../include/AXI_define.svh"

`define MASTER_NUM 2
`define SLAVE_NUM  6
`define BRIDGE_ID  4'd0

module AXI (
	input  logic                       ACLK,
	input  logic                       ARESETn,
//------------------------[ MASTER 0 ]------------------------//
	input  logic [     `ID_MAS - 1:0]  ARID_M0,
	input  logic [ `ADDR_WIDTH - 1:0]  ARADDR_M0,
	input  logic [  `LEN_WIDTH - 1:0]  ARLEN_M0,
	input  logic [ `SIZE_WIDTH - 1:0]  ARSIZE_M0,
	input  logic [`BURST_WIDTH - 1:0]  ARBURST_M0,
	input  logic                       ARVALID_M0,
	output logic                       ARREADY_M0,
	input  logic                       RREADY_M0,
	output logic [     `ID_MAS - 1:0]  RID_M0,
	output logic [ `DATA_WIDTH - 1:0]  RDATA_M0,
	output logic [ `RESP_WIDTH - 1:0]  RRESP_M0,
	output logic                       RLAST_M0,
	output logic                       RVALID_M0,
	input  logic [     `ID_MAS - 1:0]  AWID_M0,
	input  logic [ `ADDR_WIDTH - 1:0]  AWADDR_M0,
	input  logic [  `LEN_WIDTH - 1:0]  AWLEN_M0,
	input  logic [ `SIZE_WIDTH - 1:0]  AWSIZE_M0,
	input  logic [               1:0]  AWBURST_M0,
	input  logic                       AWVALID_M0,
	output logic                       AWREADY_M0,
	input  logic [ `DATA_WIDTH - 1:0]  WDATA_M0,
	input  logic [ `STRB_WIDTH - 1:0]  WSTRB_M0,
	input  logic                       WLAST_M0,
	input  logic                       WVALID_M0,
	output logic                       WREADY_M0,
	output logic [  `AXI_ID_BITS-1:0]  BID_M0,
	output logic [ `RESP_WIDTH - 1:0]  BRESP_M0,
	output logic                       BVALID_M0,
	input  logic                       BREADY_M0,
//------------------------[ MASTER 1 ]------------------------//
	input  logic [     `ID_MAS - 1:0]  ARID_M1,
	input  logic [ `ADDR_WIDTH - 1:0]  ARADDR_M1,
	input  logic [  `LEN_WIDTH - 1:0]  ARLEN_M1,
	input  logic [ `SIZE_WIDTH - 1:0]  ARSIZE_M1,
	input  logic [`BURST_WIDTH - 1:0]  ARBURST_M1,
	input  logic                       ARVALID_M1,
	output logic                       ARREADY_M1,
	input  logic                       RREADY_M1,
	output logic [     `ID_MAS - 1:0]  RID_M1,
	output logic [ `DATA_WIDTH - 1:0]  RDATA_M1,
	output logic [ `RESP_WIDTH - 1:0]  RRESP_M1,
	output logic                       RLAST_M1,
	output logic                       RVALID_M1,
	input  logic [     `ID_MAS - 1:0]  AWID_M1,
	input  logic [ `ADDR_WIDTH - 1:0]  AWADDR_M1,
	input  logic [  `LEN_WIDTH - 1:0]  AWLEN_M1,
	input  logic [ `SIZE_WIDTH - 1:0]  AWSIZE_M1,
	input  logic [               1:0]  AWBURST_M1,
	input  logic                       AWVALID_M1,
	output logic                       AWREADY_M1,
	input  logic [ `DATA_WIDTH - 1:0]  WDATA_M1,
	input  logic [ `STRB_WIDTH - 1:0]  WSTRB_M1,
	input  logic                       WLAST_M1,
	input  logic                       WVALID_M1,
	output logic                       WREADY_M1,
	output logic [  `AXI_ID_BITS-1:0]  BID_M1,
	output logic [ `RESP_WIDTH - 1:0]  BRESP_M1,
	output logic                       BVALID_M1,
	input  logic                       BREADY_M1,
//------------------------[ SLAVE 0 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S0,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S0,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S0,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S0,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S0,
	output logic                       ARVALID_S0,
	input  logic                       ARREADY_S0,
	output logic                       RREADY_S0,
	input  logic [     `ID_SLV - 1:0]  RID_S0,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S0,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S0,
	input  logic                       RLAST_S0,
	input  logic                       RVALID_S0,
	output logic [     `ID_SLV - 1:0]  AWID_S0,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S0,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S0,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S0,
	output logic [               1:0]  AWBURST_S0,
	output logic                       AWVALID_S0,
	input  logic                       AWREADY_S0,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S0,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S0,
	output logic                       WLAST_S0,
	output logic                       WVALID_S0,
	input  logic                       WREADY_S0,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S0,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S0,
	input  logic                       BVALID_S0,
	output logic                       BREADY_S0,
//------------------------[ SLAVE 1 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S1,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S1,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S1,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S1,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S1,
	output logic                       ARVALID_S1,
	input  logic                       ARREADY_S1,
	output logic                       RREADY_S1,
	input  logic [     `ID_SLV - 1:0]  RID_S1,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S1,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S1,
	input  logic                       RLAST_S1,
	input  logic                       RVALID_S1,
	output logic [     `ID_SLV - 1:0]  AWID_S1,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S1,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S1,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S1,
	output logic [               1:0]  AWBURST_S1,
	output logic                       AWVALID_S1,
	input  logic                       AWREADY_S1,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S1,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S1,
	output logic                       WLAST_S1,
	output logic                       WVALID_S1,
	input  logic                       WREADY_S1,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S1,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S1,
	input  logic                       BVALID_S1,
	output logic                       BREADY_S1,
//------------------------[ SLAVE 2 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S2,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S2,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S2,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S2,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S2,
	output logic                       ARVALID_S2,
	input  logic                       ARREADY_S2,
	output logic                       RREADY_S2,
	input  logic [     `ID_SLV - 1:0]  RID_S2,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S2,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S2,
	input  logic                       RLAST_S2,
	input  logic                       RVALID_S2,
	output logic [     `ID_SLV - 1:0]  AWID_S2,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S2,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S2,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S2,
	output logic [               1:0]  AWBURST_S2,
	output logic                       AWVALID_S2,
	input  logic                       AWREADY_S2,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S2,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S2,
	output logic                       WLAST_S2,
	output logic                       WVALID_S2,
	input  logic                       WREADY_S2,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S2,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S2,
	input  logic                       BVALID_S2,
	output logic                       BREADY_S2,
//------------------------[ SLAVE 3 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S3,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S3,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S3,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S3,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S3,
	output logic                       ARVALID_S3,
	input  logic                       ARREADY_S3,
	output logic                       RREADY_S3,
	input  logic [     `ID_SLV - 1:0]  RID_S3,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S3,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S3,
	input  logic                       RLAST_S3,
	input  logic                       RVALID_S3,
	output logic [     `ID_SLV - 1:0]  AWID_S3,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S3,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S3,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S3,
	output logic [               1:0]  AWBURST_S3,
	output logic                       AWVALID_S3,
	input  logic                       AWREADY_S3,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S3,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S3,
	output logic                       WLAST_S3,
	output logic                       WVALID_S3,
	input  logic                       WREADY_S3,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S3,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S3,
	input  logic                       BVALID_S3,
	output logic                       BREADY_S3,
//------------------------[ SLAVE 4 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S4,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S4,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S4,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S4,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S4,
	output logic                       ARVALID_S4,
	input  logic                       ARREADY_S4,
	output logic                       RREADY_S4,
	input  logic [     `ID_SLV - 1:0]  RID_S4,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S4,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S4,
	input  logic                       RLAST_S4,
	input  logic                       RVALID_S4,
	output logic [     `ID_SLV - 1:0]  AWID_S4,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S4,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S4,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S4,
	output logic [               1:0]  AWBURST_S4,
	output logic                       AWVALID_S4,
	input  logic                       AWREADY_S4,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S4,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S4,
	output logic                       WLAST_S4,
	output logic                       WVALID_S4,
	input  logic                       WREADY_S4,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S4,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S4,
	input  logic                       BVALID_S4,
	output logic                       BREADY_S4,
//------------------------[ SLAVE 5 ]------------------------//
	output logic [     `ID_SLV - 1:0]  ARID_S5,
	output logic [ `ADDR_WIDTH - 1:0]  ARADDR_S5,
	output logic [  `LEN_WIDTH - 1:0]  ARLEN_S5,
	output logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S5,
	output logic [`BURST_WIDTH - 1:0]  ARBURST_S5,
	output logic                       ARVALID_S5,
	input  logic                       ARREADY_S5,
	output logic                       RREADY_S5,
	input  logic [     `ID_SLV - 1:0]  RID_S5,
	input  logic [ `DATA_WIDTH - 1:0]  RDATA_S5,
	input  logic [ `RESP_WIDTH - 1:0]  RRESP_S5,
	input  logic                       RLAST_S5,
	input  logic                       RVALID_S5,
	output logic [     `ID_SLV - 1:0]  AWID_S5,
	output logic [ `ADDR_WIDTH - 1:0]  AWADDR_S5,
	output logic [  `LEN_WIDTH - 1:0]  AWLEN_S5,
	output logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S5,
	output logic [               1:0]  AWBURST_S5,
	output logic                       AWVALID_S5,
	input  logic                       AWREADY_S5,
	output logic [ `DATA_WIDTH - 1:0]  WDATA_S5,
	output logic [ `STRB_WIDTH - 1:0]  WSTRB_S5,
	output logic                       WLAST_S5,
	output logic                       WVALID_S5,
	input  logic                       WREADY_S5,
	input  logic [  `AXI_ID_BITS-1:0]  BID_S5,
	input  logic [ `RESP_WIDTH - 1:0]  BRESP_S5,
	input  logic                       BVALID_S5,
	output logic                       BREADY_S5
);

//------------------------[ AXI logic ]------------------------//
logic [        `ID_MAS - 1:0] axi_arid;
logic [    `ADDR_WIDTH - 1:0] axi_araddr;
logic [     `LEN_WIDTH - 1:0] axi_arlen;
logic [    `SIZE_WIDTH - 1:0] axi_arsize;
logic [   `BURST_WIDTH - 1:0] axi_arburst;
logic                         axi_arvalid;
logic                         axi_arready;
logic [        `ID_SLV - 1:0] axi_rid;
logic [    `DATA_WIDTH - 1:0] axi_rdata;
logic [    `RESP_WIDTH - 1:0] axi_rresp;
logic                         axi_rlast;
logic                         axi_rvalid;
logic                         axi_rready;
logic [        `ID_MAS - 1:0] axi_awid;
logic [    `ADDR_WIDTH - 1:0] axi_awaddr;
logic [     `LEN_WIDTH - 1:0] axi_awlen;
logic [    `SIZE_WIDTH - 1:0] axi_awsize;
logic [   `BURST_WIDTH - 1:0] axi_awburst;
logic                         axi_awvalid;
logic                         axi_awready;
logic [    `DATA_WIDTH - 1:0] axi_wdata;
logic [    `STRB_WIDTH - 1:0] axi_wstrb;
logic                         axi_wlast;
logic                         axi_wvalid;
logic                         axi_wready;
logic [        `ID_SLV - 1:0] axi_bid;
logic [    `RESP_WIDTH - 1:0] axi_bresp;
logic                         axi_bvalid;
logic                         axi_bready;
logic [    `MASTER_NUM - 1:0] aw_request;
logic [    `MASTER_NUM - 1:0] ar_request;
logic [    `MASTER_NUM - 1:0] aw_grant;
logic [    `MASTER_NUM - 1:0] ar_grant;
logic [    `MASTER_NUM - 1:0] write_mas_onehot_idx_reg;
logic [    `MASTER_NUM - 1:0] read_mas_onehot_idx_reg;
logic [    `MASTER_NUM - 1:0] write_mas_onehot_idx;
logic [    `MASTER_NUM - 1:0] read_mas_onehot_idx;
logic [     `SLAVE_NUM - 1:0] aw_select;
logic [     `SLAVE_NUM - 1:0] ar_select;
logic [     `SLAVE_NUM - 1:0] write_slv_onehot_idx_reg;
logic [     `SLAVE_NUM - 1:0] read_slv_onehot_idx_reg;
logic [     `SLAVE_NUM - 1:0] read_slv_onehot_idx;
logic [     `SLAVE_NUM - 1:0] write_slv_onehot_idx;
logic [    `ADDR_WIDTH - 1:0] aw_grant_mas_addr;
logic [    `ADDR_WIDTH - 1:0] ar_grant_mas_addr;

//------------------------[ AXI FSM ]------------------------//
typedef enum logic [1:0] {
	IDLER, AR, R
}read_e;

typedef enum logic [1:0] {
	IDLEW, AW, W, B
}write_e;

read_e  read_cs, read_ns;
write_e write_cs, write_ns;

always_ff@(posedge ACLK) begin
	if(~ARESETn) begin
		read_cs  <= IDLER;
		write_cs <= IDLEW;
	end else begin
		read_cs  <= read_ns;
		write_cs <= write_ns;
	end
end

always_comb begin
	read_ns = IDLER;
	unique case(read_cs)
		IDLER   : read_ns = (|ar_grant)?(AR):(IDLER);
		AR      : read_ns = (axi_arvalid & axi_arready)?(R):(AR);
		R       : read_ns = (axi_rvalid  &  axi_rready & axi_rlast)?(IDLER):(R);
		default :;
	endcase
end

always_comb begin
	write_ns = IDLEW;
	unique case(write_cs)
		IDLEW   : write_ns = (|aw_grant)?(AW):(IDLEW);
		AW      : write_ns = (axi_awvalid & axi_awready)?(W):(AW);
		W       : write_ns = (axi_wvalid  &  axi_wready & axi_wlast)?(B):(W);
		B       : write_ns = (axi_bvalid  &  axi_bready)?(IDLEW):(B);
		default :;
	endcase
end


//------------------------[ arbiter select register ]------------------------//
always_ff@(posedge ACLK) begin
	if(~ARESETn) begin
		read_mas_onehot_idx_reg    <= `MASTER_NUM'd0;
		read_slv_onehot_idx_reg    <= `SLAVE_NUM'd0;
		write_mas_onehot_idx_reg   <= `MASTER_NUM'd0;
		write_slv_onehot_idx_reg   <= `SLAVE_NUM'd0;
	end else begin
		if ((read_cs == IDLER) & (|ar_grant)) begin
			read_mas_onehot_idx_reg  <= ar_grant;
			read_slv_onehot_idx_reg  <= ar_select;
		end else if (read_cs == IDLER) begin
			read_mas_onehot_idx_reg  <= `MASTER_NUM'd0;
			read_slv_onehot_idx_reg  <= `SLAVE_NUM'd0;
		end
		if ((write_cs == IDLEW) & (|aw_grant)) begin
			write_mas_onehot_idx_reg <= aw_grant;
			write_slv_onehot_idx_reg <= aw_select;
		end else if (write_cs == IDLEW) begin
			write_mas_onehot_idx_reg <= `MASTER_NUM'd0;
			write_slv_onehot_idx_reg <= `SLAVE_NUM'd0;
		end
	end
end


assign write_mas_onehot_idx  = ((write_cs == IDLEW) & (|aw_grant))?( aw_grant):(write_mas_onehot_idx_reg);
assign write_slv_onehot_idx  = ((write_cs == IDLEW) & (|aw_grant))?(aw_select):(write_slv_onehot_idx_reg);
assign read_mas_onehot_idx   = (( read_cs == IDLER) & (|ar_grant))?( ar_grant):( read_mas_onehot_idx_reg);
assign read_slv_onehot_idx   = (( read_cs == IDLER) & (|ar_grant))?(ar_select):( read_slv_onehot_idx_reg);

//------------------------[ assign axi_* signal ]------------------------//
always_comb begin
	axi_arid     = 'd0;
	axi_araddr   = 'd0;
	axi_arlen    = 'd0;
	axi_arsize   = 'd0;
	axi_arburst  = 'd0;
	axi_arvalid  = 'd0;
	axi_arready  = 'd0;
	axi_rid      = 'd0;
	axi_rdata    = 'd0;
	axi_rresp    = 'd0;
	axi_rlast    = 'd0;
	axi_rvalid   = 'd0;
	axi_rready   = 'd0;
	axi_awid     = 'd0;
	axi_awaddr   = 'd0;
	axi_awlen    = 'd0;
	axi_awsize   = 'd0;
	axi_awburst  = 'd0;
	axi_awvalid  = 'd0;
	axi_awready  = 'd0;
	axi_wdata    = 'd0;
	axi_wstrb    = 'hf;
	axi_wlast    = 'd0;
	axi_wvalid   = 'd0;
	axi_wready   = 'd0;
	axi_bid      = 'd0;
	axi_bresp    = 'd0;
	axi_bvalid   = 'd0;
	axi_bready   = 'd0;
	unique case(1'b1)
		read_mas_onehot_idx[0]: begin//master 0
			axi_arid     = ARID_M0;
			axi_araddr   = ARADDR_M0;
			axi_arlen    = ARLEN_M0;
			axi_arsize   = ARSIZE_M0;
			axi_arburst  = ARBURST_M0;
			axi_arvalid  = ARVALID_M0;
			axi_rready   = RREADY_M0;
		end
		read_mas_onehot_idx[1]: begin//master 1
			axi_arid     = ARID_M1;
			axi_araddr   = ARADDR_M1;
			axi_arlen    = ARLEN_M1;
			axi_arsize   = ARSIZE_M1;
			axi_arburst  = ARBURST_M1;
			axi_arvalid  = ARVALID_M1;
			axi_rready   = RREADY_M1;
		end
		default;
	endcase
	unique case(1'b1)
		read_slv_onehot_idx[0]: begin//slave 0
			axi_arready  = ARREADY_S0;
			axi_rid      = RID_S0;
			axi_rdata    = RDATA_S0;
			axi_rresp    = RRESP_S0;
			axi_rlast    = RLAST_S0;
			axi_rvalid   = RVALID_S0;
		end
		read_slv_onehot_idx[1]: begin//slave 1
			axi_arready  = ARREADY_S1;
			axi_rid      = RID_S1;
			axi_rdata    = RDATA_S1;
			axi_rresp    = RRESP_S1;
			axi_rlast    = RLAST_S1;
			axi_rvalid   = RVALID_S1;
		end
		read_slv_onehot_idx[2]: begin//slave 2
			axi_arready  = ARREADY_S2;
			axi_rid      = RID_S2;
			axi_rdata    = RDATA_S2;
			axi_rresp    = RRESP_S2;
			axi_rlast    = RLAST_S2;
			axi_rvalid   = RVALID_S2;
		end
		read_slv_onehot_idx[3]: begin//slave 3
			axi_arready  = ARREADY_S3;
			axi_rid      = RID_S3;
			axi_rdata    = RDATA_S3;
			axi_rresp    = RRESP_S3;
			axi_rlast    = RLAST_S3;
			axi_rvalid   = RVALID_S3;
		end
		read_slv_onehot_idx[4]: begin//slave 4
			axi_arready  = ARREADY_S4;
			axi_rid      = RID_S4;
			axi_rdata    = RDATA_S4;
			axi_rresp    = RRESP_S4;
			axi_rlast    = RLAST_S4;
			axi_rvalid   = RVALID_S4;
		end
		read_slv_onehot_idx[5]: begin//slave 5
			axi_arready  = ARREADY_S5;
			axi_rid      = RID_S5;
			axi_rdata    = RDATA_S5;
			axi_rresp    = RRESP_S5;
			axi_rlast    = RLAST_S5;
			axi_rvalid   = RVALID_S5;
		end
		default;
	endcase
	unique case(1'b1)
		write_mas_onehot_idx[0]: begin//master 0
			axi_awid     = AWID_M0;
			axi_awaddr   = AWADDR_M0;
			axi_awlen    = AWLEN_M0;
			axi_awsize   = AWSIZE_M0;
			axi_awburst  = AWBURST_M0;
			axi_awvalid  = AWVALID_M0;
			axi_wdata    = WDATA_M0;
			axi_wstrb    = WSTRB_M0;
			axi_wlast    = WLAST_M0;
			axi_wvalid   = WVALID_M0;
			axi_bready   = BREADY_M0;
		end
		write_mas_onehot_idx[1]: begin//master 1
			axi_awid     = AWID_M1;
			axi_awaddr   = AWADDR_M1;
			axi_awlen    = AWLEN_M1;
			axi_awsize   = AWSIZE_M1;
			axi_awburst  = AWBURST_M1;
			axi_awvalid  = AWVALID_M1;
			axi_wdata    = WDATA_M1;
			axi_wstrb    = WSTRB_M1;
			axi_wlast    = WLAST_M1;
			axi_wvalid   = WVALID_M1;
			axi_bready   = BREADY_M1;
		end
		default;
	endcase
	unique case(1'b1)
		write_slv_onehot_idx[0]: begin//slave 0
			axi_awready  = AWREADY_S0;
			axi_wready   = WREADY_S0;
			axi_bid      = BID_S0;
			axi_bresp    = BRESP_S0;
			axi_bvalid   = BVALID_S0;
		end
		write_slv_onehot_idx[1]: begin//slave 1
			axi_awready  = AWREADY_S1;
			axi_wready   = WREADY_S1;
			axi_bid      = BID_S1;
			axi_bresp    = BRESP_S1;
			axi_bvalid   = BVALID_S1;
		end
		write_slv_onehot_idx[2]: begin//slave 2
			axi_awready  = AWREADY_S2;
			axi_wready   = WREADY_S2;
			axi_bid      = BID_S2;
			axi_bresp    = BRESP_S2;
			axi_bvalid   = BVALID_S2;
		end
		write_slv_onehot_idx[3]: begin//slave 3
			axi_awready  = AWREADY_S3;
			axi_wready   = WREADY_S3;
			axi_bid      = BID_S3;
			axi_bresp    = BRESP_S3;
			axi_bvalid   = BVALID_S3;
		end
		write_slv_onehot_idx[4]: begin//slave 4
			axi_awready  = AWREADY_S4;
			axi_wready   = WREADY_S4;
			axi_bid      = BID_S4;
			axi_bresp    = BRESP_S4;
			axi_bvalid   = BVALID_S4;
		end
		write_slv_onehot_idx[5]: begin//slave 5
			axi_awready  = AWREADY_S5;
			axi_wready   = WREADY_S5;
			axi_bid      = BID_S5;
			axi_bresp    = BRESP_S5;
			axi_bvalid   = BVALID_S5;
		end
		default;
	endcase
end

//------------------------[ axi output signal ]------------------------//
always_comb begin
	ARREADY_M0 = 'd0;
	RID_M0     = 'd0;
	RDATA_M0   = 'd0;
	RRESP_M0   = 'd0;
	RLAST_M0   = 'd0;
	RVALID_M0  = 'd0;
	AWREADY_M0 = 'd0;
	WREADY_M0  = 'd0;
	BID_M0     = 'd0;
	BRESP_M0   = 'd0;
	BVALID_M0  = 'd0;
	ARREADY_M1 = 'd0;
	RID_M1     = 'd0;
	RDATA_M1   = 'd0;
	RRESP_M1   = 'd0;
	RLAST_M1   = 'd0;
	RVALID_M1  = 'd0;
	AWREADY_M1 = 'd0;
	WREADY_M1  = 'd0;
	BID_M1     = 'd0;
	BRESP_M1   = 'd0;
	BVALID_M1  = 'd0;
	unique case(1'b1)
		read_mas_onehot_idx[0] & (read_cs == AR): begin//master 0
			ARREADY_M0 = axi_arready;
		end
		read_mas_onehot_idx[0] & (read_cs ==  R): begin//master 0
			RID_M0     = axi_rid[3:0];
			RDATA_M0   = axi_rdata;
			RRESP_M0   = axi_rresp;
			RLAST_M0   = axi_rlast;
			RVALID_M0  = axi_rvalid;
		end
		read_mas_onehot_idx[1] & (read_cs == AR): begin//master 1
			ARREADY_M1 = axi_arready;
		end
		read_mas_onehot_idx[1] & (read_cs ==  R): begin//master 1
			RID_M1     = axi_rid[3:0];
			RDATA_M1   = axi_rdata;
			RRESP_M1   = axi_rresp;
			RLAST_M1   = axi_rlast;
			RVALID_M1  = axi_rvalid;
		end
		default;
	endcase
	unique case(1'b1)
		write_mas_onehot_idx[0] & (write_cs == AW): begin//master 0
			AWREADY_M0 = axi_awready;
		end
		write_mas_onehot_idx[0] & (write_cs == W): begin//master 0
			WREADY_M0 = axi_wready;
		end
		write_mas_onehot_idx[0] & (write_cs == B): begin//master 0
			BID_M0     = axi_bid[3:0];
			BRESP_M0   = axi_bresp ;
			BVALID_M0  = axi_bvalid;
		end
		write_mas_onehot_idx[1] & (write_cs == AW): begin//master 1
			AWREADY_M1 = axi_awready;
		end
		write_mas_onehot_idx[1] & (write_cs == W): begin//master 1
			WREADY_M1 = axi_wready;
		end
		write_mas_onehot_idx[1] & (write_cs == B): begin//master 1
			BID_M1     = axi_bid[3:0];
			BRESP_M1   = axi_bresp ;
			BVALID_M1  = axi_bvalid;
		end
		default;
	endcase
end
always_comb begin
	AWID_S0     =   'd0;
	AWADDR_S0   =   'd0;
	AWLEN_S0    =   'd0;
	AWSIZE_S0   =   'd0;
	AWBURST_S0  =   'd0;
	AWVALID_S0  =   'd0;
	WDATA_S0    =   'd0;
	WSTRB_S0    =   'hf;
	WLAST_S0    =   'd0;
	WVALID_S0   =   'd0;
	ARID_S0     =   'd0;
	ARADDR_S0   =   'd0;
	ARLEN_S0    =   'd0;
	ARSIZE_S0   =   'd0;
	ARBURST_S0  =   'd0;
	ARVALID_S0  =   'd0;
	RREADY_S0   =   'd0;
	BREADY_S0   =   'd0;
	AWID_S1     =   'd0;
	AWADDR_S1   =   'd0;
	AWLEN_S1    =   'd0;
	AWSIZE_S1   =   'd0;
	AWBURST_S1  =   'd0;
	AWVALID_S1  =   'd0;
	WDATA_S1    =   'd0;
	WSTRB_S1    =   'hf;
	WLAST_S1    =   'd0;
	WVALID_S1   =   'd0;
	ARID_S1     =   'd0;
	ARADDR_S1   =   'd0;
	ARLEN_S1    =   'd0;
	ARSIZE_S1   =   'd0;
	ARBURST_S1  =   'd0;
	ARVALID_S1  =   'd0;
	RREADY_S1   =   'd0;
	BREADY_S1   =   'd0;
	AWID_S2     =   'd0;
	AWADDR_S2   =   'd0;
	AWLEN_S2    =   'd0;
	AWSIZE_S2   =   'd0;
	AWBURST_S2  =   'd0;
	AWVALID_S2  =   'd0;
	WDATA_S2    =   'd0;
	WSTRB_S2    =   'hf;
	WLAST_S2    =   'd0;
	WVALID_S2   =   'd0;
	ARID_S2     =   'd0;
	ARADDR_S2   =   'd0;
	ARLEN_S2    =   'd0;
	ARSIZE_S2   =   'd0;
	ARBURST_S2  =   'd0;
	ARVALID_S2  =   'd0;
	RREADY_S2   =   'd0;
	BREADY_S2   =   'd0;
	AWID_S3     =   'd0;
	AWADDR_S3   =   'd0;
	AWLEN_S3    =   'd0;
	AWSIZE_S3   =   'd0;
	AWBURST_S3  =   'd0;
	AWVALID_S3  =   'd0;
	WDATA_S3    =   'd0;
	WSTRB_S3    =   'hf;
	WLAST_S3    =   'd0;
	WVALID_S3   =   'd0;
	ARID_S3     =   'd0;
	ARADDR_S3   =   'd0;
	ARLEN_S3    =   'd0;
	ARSIZE_S3   =   'd0;
	ARBURST_S3  =   'd0;
	ARVALID_S3  =   'd0;
	RREADY_S3   =   'd0;
	BREADY_S3   =   'd0;
	AWID_S4     =   'd0;
	AWADDR_S4   =   'd0;
	AWLEN_S4    =   'd0;
	AWSIZE_S4   =   'd0;
	AWBURST_S4  =   'd0;
	AWVALID_S4  =   'd0;
	WDATA_S4    =   'd0;
	WSTRB_S4    =   'hf;
	WLAST_S4    =   'd0;
	WVALID_S4   =   'd0;
	ARID_S4     =   'd0;
	ARADDR_S4   =   'd0;
	ARLEN_S4    =   'd0;
	ARSIZE_S4   =   'd0;
	ARBURST_S4  =   'd0;
	ARVALID_S4  =   'd0;
	RREADY_S4   =   'd0;
	BREADY_S4   =   'd0;
	AWID_S5     =   'd0;
	AWADDR_S5   =   'd0;
	AWLEN_S5    =   'd0;
	AWSIZE_S5   =   'd0;
	AWBURST_S5  =   'd0;
	AWVALID_S5  =   'd0;
	WDATA_S5    =   'd0;
	WSTRB_S5    =   'hf;
	WLAST_S5    =   'd0;
	WVALID_S5   =   'd0;
	ARID_S5     =   'd0;
	ARADDR_S5   =   'd0;
	ARLEN_S5    =   'd0;
	ARSIZE_S5   =   'd0;
	ARBURST_S5  =   'd0;
	ARVALID_S5  =   'd0;
	RREADY_S5   =   'd0;
	BREADY_S5   =   'd0;
	unique case(1'b1)
		read_slv_onehot_idx[0] & (read_cs == AR): begin//slave 0
			ARID_S0    = {`BRIDGE_ID,axi_arid};
			ARADDR_S0  = axi_araddr;
			ARLEN_S0   = axi_arlen;
			ARSIZE_S0  = axi_arsize;
			ARBURST_S0 = axi_arburst;
			ARVALID_S0 = axi_arvalid;
		end
		read_slv_onehot_idx[0] & (read_cs == R): begin//slave 0
			RREADY_S0  = axi_rready;
		end
		read_slv_onehot_idx[1] & (read_cs == AR): begin//slave 1
			ARID_S1    = {`BRIDGE_ID,axi_arid};
			ARADDR_S1  = axi_araddr;
			ARLEN_S1   = axi_arlen;
			ARSIZE_S1  = axi_arsize;
			ARBURST_S1 = axi_arburst;
			ARVALID_S1 = axi_arvalid;
		end
		read_slv_onehot_idx[1] & (read_cs == R): begin//slave 1
			RREADY_S1  = axi_rready;
		end
		read_slv_onehot_idx[2] & (read_cs == AR): begin//slave 2
			ARID_S2    = {`BRIDGE_ID,axi_arid};
			ARADDR_S2  = axi_araddr;
			ARLEN_S2   = axi_arlen;
			ARSIZE_S2  = axi_arsize;
			ARBURST_S2 = axi_arburst;
			ARVALID_S2 = axi_arvalid;
		end
		read_slv_onehot_idx[2] & (read_cs == R): begin//slave 2
			RREADY_S2  = axi_rready;
		end
		read_slv_onehot_idx[3] & (read_cs == AR): begin//slave 3
			ARID_S3    = {`BRIDGE_ID,axi_arid};
			ARADDR_S3  = axi_araddr;
			ARLEN_S3   = axi_arlen;
			ARSIZE_S3  = axi_arsize;
			ARBURST_S3 = axi_arburst;
			ARVALID_S3 = axi_arvalid;
		end
		read_slv_onehot_idx[3] & (read_cs == R): begin//slave 3
			RREADY_S3  = axi_rready;
		end
		read_slv_onehot_idx[4] & (read_cs == AR): begin//slave 4
			ARID_S4    = {`BRIDGE_ID,axi_arid};
			ARADDR_S4  = axi_araddr;
			ARLEN_S4   = axi_arlen;
			ARSIZE_S4  = axi_arsize;
			ARBURST_S4 = axi_arburst;
			ARVALID_S4 = axi_arvalid;
		end
		read_slv_onehot_idx[4] & (read_cs == R): begin//slave 4
			RREADY_S4  = axi_rready;
		end
		read_slv_onehot_idx[5] & (read_cs == AR): begin//slave 5
			ARID_S5    = {`BRIDGE_ID,axi_arid};
			ARADDR_S5  = axi_araddr;
			ARLEN_S5   = axi_arlen;
			ARSIZE_S5  = axi_arsize;
			ARBURST_S5 = axi_arburst;
			ARVALID_S5 = axi_arvalid;
		end
		read_slv_onehot_idx[5] & (read_cs == R): begin//slave 5
			RREADY_S5  = axi_rready;
		end
		default;
	endcase

	unique case(1'b1)
		write_slv_onehot_idx[0] & (write_cs == AW): begin//slave 0
			AWID_S0    = {`BRIDGE_ID,axi_awid};
			AWADDR_S0  = axi_awaddr;
			AWLEN_S0   = axi_awlen;
			AWSIZE_S0  = axi_awsize;
			AWBURST_S0 = axi_awburst;
			AWVALID_S0 = axi_awvalid;
		end
		write_slv_onehot_idx[0] & (write_cs == W): begin//slave 0
			WDATA_S0  = axi_wdata;
			WSTRB_S0  = axi_wstrb;
			WLAST_S0  = axi_wlast;
			WVALID_S0 = axi_wvalid;
		end
		write_slv_onehot_idx[0] & (write_cs == B): begin//slave 0
			BREADY_S0 = axi_bready;
		end
		write_slv_onehot_idx[1] & (write_cs == AW): begin//slave 1
			AWID_S1    = {`BRIDGE_ID,axi_awid};
			AWADDR_S1  = axi_awaddr;
			AWLEN_S1   = axi_awlen;
			AWSIZE_S1  = axi_awsize;
			AWBURST_S1 = axi_awburst;
			AWVALID_S1 = axi_awvalid;
		end
		write_slv_onehot_idx[1] & (write_cs == W): begin//slave 1
			WDATA_S1  = axi_wdata;
			WSTRB_S1  = axi_wstrb;
			WLAST_S1  = axi_wlast;
			WVALID_S1 = axi_wvalid;
		end
		write_slv_onehot_idx[1] & (write_cs == B): begin//slave 1
			BREADY_S1 = axi_bready;
		end
		write_slv_onehot_idx[2] & (write_cs == AW): begin//slave 2
			AWID_S2    = {`BRIDGE_ID,axi_awid};
			AWADDR_S2  = axi_awaddr;
			AWLEN_S2   = axi_awlen;
			AWSIZE_S2  = axi_awsize;
			AWBURST_S2 = axi_awburst;
			AWVALID_S2 = axi_awvalid;
		end
		write_slv_onehot_idx[2] & (write_cs == W): begin//slave 2
			WDATA_S2  = axi_wdata;
			WSTRB_S2  = axi_wstrb;
			WLAST_S2  = axi_wlast;
			WVALID_S2 = axi_wvalid;
		end
		write_slv_onehot_idx[2] & (write_cs == B): begin//slave 2
			BREADY_S2 = axi_bready;
		end
		write_slv_onehot_idx[3] & (write_cs == AW): begin//slave 3
			AWID_S3    = {`BRIDGE_ID,axi_awid};
			AWADDR_S3  = axi_awaddr;
			AWLEN_S3   = axi_awlen;
			AWSIZE_S3  = axi_awsize;
			AWBURST_S3 = axi_awburst;
			AWVALID_S3 = axi_awvalid;
		end
		write_slv_onehot_idx[3] & (write_cs == W): begin//slave 3
			WDATA_S3  = axi_wdata;
			WSTRB_S3  = axi_wstrb;
			WLAST_S3  = axi_wlast;
			WVALID_S3 = axi_wvalid;
		end
		write_slv_onehot_idx[3] & (write_cs == B): begin//slave 3
			BREADY_S3 = axi_bready;
		end
		write_slv_onehot_idx[4] & (write_cs == AW): begin//slave 4
			AWID_S4    = {`BRIDGE_ID,axi_awid};
			AWADDR_S4  = axi_awaddr;
			AWLEN_S4   = axi_awlen;
			AWSIZE_S4  = axi_awsize;
			AWBURST_S4 = axi_awburst;
			AWVALID_S4 = axi_awvalid;
		end
		write_slv_onehot_idx[4] & (write_cs == W): begin//slave 4
			WDATA_S4  = axi_wdata;
			WSTRB_S4  = axi_wstrb;
			WLAST_S4  = axi_wlast;
			WVALID_S4 = axi_wvalid;
		end
		write_slv_onehot_idx[4] & (write_cs == B): begin//slave 4
			BREADY_S4 = axi_bready;
		end
		write_slv_onehot_idx[5] & (write_cs == AW): begin//slave 5
			AWID_S5    = {`BRIDGE_ID,axi_awid};
			AWADDR_S5  = axi_awaddr;
			AWLEN_S5   = axi_awlen;
			AWSIZE_S5  = axi_awsize;
			AWBURST_S5 = axi_awburst;
			AWVALID_S5 = axi_awvalid;
		end
		write_slv_onehot_idx[5] & (write_cs == W): begin//slave 5
			WDATA_S5  = axi_wdata;
			WSTRB_S5  = axi_wstrb;
			WLAST_S5  = axi_wlast;
			WVALID_S5 = axi_wvalid;
		end
		write_slv_onehot_idx[5] & (write_cs == B): begin//slave 5
			BREADY_S5 = axi_bready;
		end
		default;
	endcase
end

//------------------------[ arbiter / decoder ]------------------------//
assign ar_request = { ARVALID_M1, ARVALID_M0};
assign aw_request = { AWVALID_M1, AWVALID_M0};

always_comb begin
	aw_grant_mas_addr = `ADDR_WIDTH'h0;
	ar_grant_mas_addr = `ADDR_WIDTH'h0;
	unique case(1'b1)
		write_mas_onehot_idx[0]: aw_grant_mas_addr = AWADDR_M0;
		write_mas_onehot_idx[1]: aw_grant_mas_addr = AWADDR_M1;
		default;
	endcase
	unique case(1'b1)
		read_mas_onehot_idx[0]: ar_grant_mas_addr = ARADDR_M0;
		read_mas_onehot_idx[1]: ar_grant_mas_addr = ARADDR_M1;
		default;
	endcase
end
priority_arbiter #(
	.MASTER_NUM(`MASTER_NUM)
)AW_arbiter(
	.request(aw_request),
	.grant  (aw_grant)
);

decoder #(
	.SLAVE_NUM(`SLAVE_NUM)
)AW_decoder(
	.addr   (aw_grant_mas_addr),
	.select (aw_select)
);

priority_arbiter #(
	.MASTER_NUM(`MASTER_NUM)
)AR_arbiter(
	.request(ar_request),
	.grant  (ar_grant)
);

decoder #(
	.SLAVE_NUM(`SLAVE_NUM)
)AR_decoder(
	.addr   (ar_grant_mas_addr),
	.select (ar_select)
);

endmodule
