module decoder#(
  parameter SLAVE_NUM = 1
)(
  input  logic [31:0] addr,
  output logic [SLAVE_NUM - 1:0] select 
);
//s0 0x0000_0000 ~ 0x0000_3FFF
//s1 0x0001_0000 ~ 0x0001_FFFF
//s2 0x0002_0000 ~ 0x0002_FFFF
//s3 0x1000_0000 ~ 0x1000_03FF
//s4 0x1001_0000 ~ 0x1001_03FF
//s5 0x2000_0000 ~ 0x207F_FFFF
always_comb begin
  unique if   ((addr >= 32'h0000_0000) & (addr <= 32'h0000_3fff)) begin 
    select = 6'b000001;//s0
  end else if ((addr >= 32'h0001_0000) & (addr <= 32'h0001_ffff)) begin
    select = 6'b000010;//s1
  end else if ((addr >= 32'h0002_0000) & (addr <= 32'h0002_ffff)) begin
    select = 6'b000100;//s2
  end else if ((addr >= 32'h1000_0000) & (addr <= 32'h1000_03ff)) begin
    select = 6'b001000;//s3
  end else if ((addr >= 32'h1001_0000) & (addr <= 32'h1001_03ff)) begin
    select = 6'b010000;//s4
  end else if ((addr >= 32'h2000_0000) & (addr <= 32'h207f_ffff)) begin
    select = 6'b100000;//s5
  end else begin
    select = 6'b000000;
  end
end
endmodule

