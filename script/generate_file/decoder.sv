module decoder#(
	parameter SLAVE_NUM = 1
)(
	input  logic [`ADDR_WIDTH:0] addr,
	output logic [SLAVE_NUM - 1:0] select 
);
	always_comb begin
		select = SLAVE_NUM'b0;
		unique case(addr)
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b00001;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b00010;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b00100;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b01000;
			`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b10000;
			default:;
		endcase
	end
endmodule
