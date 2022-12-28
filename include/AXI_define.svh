`define ADDR_WIDTH    32
`define DATA_WIDTH    32
`define STRB_WIDTH    4
`define LEN_WIDTH     4
`define SIZE_WIDTH    3
`define BURST_WIDTH   2
`define RESP_WIDTH    2
`define ID_MAS        4
`define ID_SLV        8
`define BURST_WIDTH   2
`define RESP_WIDTH    2

//AXSIZE(burst size)
`define SIZE_1_BYTE   3'b000
`define SIZE_2_BYTE   3'b001
`define SIZE_4_BYTE   3'b010
`define SIZE_8_BYTE   3'b011
`define SIZE_16_BYTE  3'b100
`define SIZE_32_BYTE  3'b101
`define SIZE_64_BYTE  3'b110
`define SIZE_128_BYTE 3'b111


//AXBURST(burst type)
`define BURST_FIXED   2'b00
`define BURST_INCR    2'b01
`define BURST_WRAP    2'b10


//AXLEN(burst len)
`define BURST_LEN_1   4'h0
`define BURST_LEN_2   4'h1
`define BURST_LEN_3   4'h2
`define BURST_LEN_4   4'h3


//RRESP BRESP
`define RESP_OKAY     2'b00
`define RESP_EXOKAY   2'b01
`define RESP_SLVERR   2'b10
`define RESP_DECERR   2'b11


//strobe type
`define STRB_WORD     4'b1111
`define STRB_HWORD    4'b0011
`define STRB_BYTE     4'b0001
