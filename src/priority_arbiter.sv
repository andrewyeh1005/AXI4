module priority_arbiter #(
  parameter MASTER_NUM = 2
)(
  input  logic [MASTER_NUM - 1:0] request,
  output logic [MASTER_NUM - 1:0] grant
);
  logic [MASTER_NUM - 1:0]  pre_req;
  assign pre_req[0] = 1'b0;
  assign pre_req[MASTER_NUM - 1:1] = request[MASTER_NUM - 2:0] | pre_req[MASTER_NUM - 2:0];
  assign grant      = request & (~pre_req);

endmodule