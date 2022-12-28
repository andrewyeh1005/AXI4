module priority_arbiter #(
	parameter MASTER_NUM = 1
)(
	input  logic [MASTER_NUM - 1:0] request,
	output logic [MASTER_NUM - 1:0] grant
);
	logic [MASTER_NUM - 1:0]  pre_req;
	assign pre_req[0] = 1'b0;
	assign pre_req[1] = request[0] | pre_req[0];
	assign grant      = request & (~pre_req);
endmodule
