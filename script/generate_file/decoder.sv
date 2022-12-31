module decoder#(
	parameter SLAVE_NUM = 1
)(
	input  logic [`ADDR_WIDTH:0] addr,
	output logic [SLAVE_NUM - 1:0] select 
);
	always_comb begin
		select = SLAVE_NUM'b0;
		unique case(addr)
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b001;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b010;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b100;
			default:;
		endcase
	end
endmodule
