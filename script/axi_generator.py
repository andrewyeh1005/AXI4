import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-m", "--master", nargs='?', const=1, help="how many master device do u have",type=int, default=1)
parser.add_argument("-s", "--slave", nargs='?', const=1, help="how many slave device do u have",type=int, default=1)
args = parser.parse_args()
master_num = args.master
slave_num  = args.slave

#write AXI
text = []
text.append('`include "decoder.sv"')
text.append('`include "priority_arbiter.sv"')
text.append('`include "../include/AXI_define.svh"')
text.append('')
text.append('`define MASTER_NUM '+str(master_num))
text.append('`define SLAVE_NUM  '+str(slave_num))
text.append("`define BRIDGE_ID  4'd0")
text.append('')
text.append('module AXI (')
#input output port  
text.append('\tinput  logic                       ACLK,')
text.append('\tinput  logic                       ARESETn,')
for i in range(master_num):
    text.append('//------------------------[ MASTER '+str(i)+' ]------------------------//')
    t = [
        '\tinput  logic [     `ID_MAS - 1:0]  ARID_M'+str(i)+',',
        '\tinput  logic [ `ADDR_WIDTH - 1:0]  ARADDR_M'+str(i)+',',
        '\tinput  logic [  `LEN_WIDTH - 1:0]  ARLEN_M'+str(i)+',',
        '\tinput  logic [ `SIZE_WIDTH - 1:0]  ARSIZE_M'+str(i)+',',
        '\tinput  logic [`BURST_WIDTH - 1:0]  ARBURST_M'+str(i)+',',
        '\tinput  logic                       ARVALID_M'+str(i)+',',
        '\toutput logic                       ARREADY_M'+str(i)+',',
        '\tinput  logic                       RREADY_M'+str(i)+',',
        '\toutput logic [     `ID_MAS - 1:0]  RID_M'+str(i)+',',
        '\toutput logic [ `DATA_WIDTH - 1:0]  RDATA_M'+str(i)+',',
        '\toutput logic [ `RESP_WIDTH - 1:0]  RRESP_M'+str(i)+',',
        '\toutput logic                       RLAST_M'+str(i)+',',
        '\toutput logic                       RVALID_M'+str(i)+',',
        '\tinput  logic [     `ID_MAS - 1:0]  AWID_M'+str(i)+',',
        '\tinput  logic [ `ADDR_WIDTH - 1:0]  AWADDR_M'+str(i)+',',
        '\tinput  logic [  `LEN_WIDTH - 1:0]  AWLEN_M'+str(i)+',',
        '\tinput  logic [ `SIZE_WIDTH - 1:0]  AWSIZE_M'+str(i)+',',
        '\tinput  logic [               1:0]  AWBURST_M'+str(i)+',',
        '\tinput  logic                       AWVALID_M'+str(i)+',',
        '\toutput logic                       AWREADY_M'+str(i)+',',
        '\tinput  logic [ `DATA_WIDTH - 1:0]  WDATA_M'+str(i)+',',
        '\tinput  logic [ `STRB_WIDTH - 1:0]  WSTRB_M'+str(i)+',',
        '\tinput  logic                       WLAST_M'+str(i)+',',
        '\tinput  logic                       WVALID_M'+str(i)+',',
        '\toutput logic                       WREADY_M'+str(i)+',',
        '\toutput logic [  `AXI_ID_BITS-1:0]  BID_M'+str(i)+',',
        '\toutput logic [ `RESP_WIDTH - 1:0]  BRESP_M'+str(i)+',',
        '\toutput logic                       BVALID_M'+str(i)+',',
        '\tinput  logic                       BREADY_M'+str(i)+',',
    ]
    for i in t:
        text.append(i)
for i in range(slave_num):
    text.append('//------------------------[ SLAVE '+str(i)+' ]------------------------//')
    t = [
        '\toutput logic [     `ID_SLV - 1:0]  ARID_S'+str(i)+',',
        '\toutput logic [ `ADDR_WIDTH - 1:0]  ARADDR_S'+str(i)+',',
        '\toutput logic [  `LEN_WIDTH - 1:0]  ARLEN_S'+str(i)+',',
        '\toutput logic [ `SIZE_WIDTH - 1:0]  ARSIZE_S'+str(i)+',',
        '\toutput logic [`BURST_WIDTH - 1:0]  ARBURST_S'+str(i)+',',
        '\toutput logic                       ARVALID_S'+str(i)+',',
        '\tinput  logic                       ARREADY_S'+str(i)+',',
        '\toutput logic                       RREADY_S'+str(i)+',',
        '\tinput  logic [     `ID_SLV - 1:0]  RID_S'+str(i)+',',
        '\tinput  logic [ `DATA_WIDTH - 1:0]  RDATA_S'+str(i)+',',
        '\tinput  logic [ `RESP_WIDTH - 1:0]  RRESP_S'+str(i)+',',
        '\tinput  logic                       RLAST_S'+str(i)+',',
        '\tinput  logic                       RVALID_S'+str(i)+',',
        '\toutput logic [     `ID_SLV - 1:0]  AWID_S'+str(i)+',',
        '\toutput logic [ `ADDR_WIDTH - 1:0]  AWADDR_S'+str(i)+',',
        '\toutput logic [  `LEN_WIDTH - 1:0]  AWLEN_S'+str(i)+',',
        '\toutput logic [ `SIZE_WIDTH - 1:0]  AWSIZE_S'+str(i)+',',
        '\toutput logic [               1:0]  AWBURST_S'+str(i)+',',
        '\toutput logic                       AWVALID_S'+str(i)+',',
        '\tinput  logic                       AWREADY_S'+str(i)+',',
        '\toutput logic [ `DATA_WIDTH - 1:0]  WDATA_S'+str(i)+',',
        '\toutput logic [ `STRB_WIDTH - 1:0]  WSTRB_S'+str(i)+',',
        '\toutput logic                       WLAST_S'+str(i)+',',
        '\toutput logic                       WVALID_S'+str(i)+',',
        '\tinput  logic                       WREADY_S'+str(i)+',',
        '\tinput  logic [  `AXI_ID_BITS-1:0]  BID_S'+str(i)+',',
        '\tinput  logic [ `RESP_WIDTH - 1:0]  BRESP_S'+str(i)+',',
        '\tinput  logic                       BVALID_S'+str(i)+',',
        '\toutput logic                       BREADY_S'+str(i)+','
    ]
    for i in t:
        text.append(i)
t = text.pop()
text.append(t[0:-1])
text.append(');')

#logic
text.append('')
text.append('//------------------------[ AXI logic ]------------------------//')
t = [
    'logic [        `ID_MAS - 1:0] axi_arid;'   ,
    'logic [    `ADDR_WIDTH - 1:0] axi_araddr;' ,
    'logic [     `LEN_WIDTH - 1:0] axi_arlen;'  ,
    'logic [    `SIZE_WIDTH - 1:0] axi_arsize;' ,
    'logic [   `BURST_WIDTH - 1:0] axi_arburst;',
    'logic                         axi_arvalid;',
    'logic                         axi_arready;',
    'logic [        `ID_SLV - 1:0] axi_rid;'    ,
    'logic [    `DATA_WIDTH - 1:0] axi_rdata;'  ,
    'logic [    `RESP_WIDTH - 1:0] axi_rresp;'  ,
    'logic                         axi_rlast;'  ,
    'logic                         axi_rvalid;' ,
    'logic                         axi_rready;' ,
    'logic [        `ID_MAS - 1:0] axi_awid;'   ,
    'logic [    `ADDR_WIDTH - 1:0] axi_awaddr;' ,
    'logic [     `LEN_WIDTH - 1:0] axi_awlen;'  ,
    'logic [    `SIZE_WIDTH - 1:0] axi_awsize;' ,
    'logic [   `BURST_WIDTH - 1:0] axi_awburst;',
    'logic                         axi_awvalid;',
    'logic                         axi_awready;',
    'logic [    `DATA_WIDTH - 1:0] axi_wdata;'  ,
    'logic [    `STRB_WIDTH - 1:0] axi_wstrb;'  ,
    'logic                         axi_wlast;'  ,
    'logic                         axi_wvalid;' ,
    'logic                         axi_wready;' ,
    'logic [        `ID_SLV - 1:0] axi_bid;'    ,
    'logic [    `RESP_WIDTH - 1:0] axi_bresp;'  ,
    'logic                         axi_bvalid;' ,
    'logic                         axi_bready;',
    'logic [    `MASTER_NUM - 1:0] aw_request;',
    'logic [    `MASTER_NUM - 1:0] ar_request;',
    'logic [    `MASTER_NUM - 1:0] aw_grant;',
    'logic [    `MASTER_NUM - 1:0] ar_grant;',
    'logic [    `MASTER_NUM - 1:0] write_mas_onehot_idx_reg;',
    'logic [    `MASTER_NUM - 1:0] read_mas_onehot_idx_reg;',
    'logic [    `MASTER_NUM - 1:0] write_mas_onehot_idx;',
    'logic [    `MASTER_NUM - 1:0] read_mas_onehot_idx;',
    'logic [     `SLAVE_NUM - 1:0] aw_select;',
    'logic [     `SLAVE_NUM - 1:0] ar_select;',
    'logic [     `SLAVE_NUM - 1:0] write_slv_onehot_idx_reg;',
    'logic [     `SLAVE_NUM - 1:0] read_slv_onehot_idx_reg;',
    'logic [     `SLAVE_NUM - 1:0] read_slv_onehot_idx;',
    'logic [     `SLAVE_NUM - 1:0] write_slv_onehot_idx;',
    'logic [    `ADDR_WIDTH - 1:0] aw_grant_mas_addr;',
    'logic [    `ADDR_WIDTH - 1:0] ar_grant_mas_addr;'
]
for i in t:
    text.append(i)
#fsm
text.append('')
text.append('//------------------------[ AXI FSM ]------------------------//')
t = [
'typedef enum logic [1:0] {',
'\tIDLER, AR, R',
'}read_e;',
'',
'typedef enum logic [1:0] {',
'\tIDLEW, AW, W, B',
'}write_e;',
'',
'read_e  read_cs, read_ns;',
'write_e write_cs, write_ns;',
'',
'always_ff@(posedge ACLK) begin',
'\tif(~ARESETn) begin',
'\t\tread_cs  <= IDLER;',
'\t\twrite_cs <= IDLEW;',
'\tend else begin',
'\t\tread_cs  <= read_ns;',
'\t\twrite_cs <= write_ns;',
'\tend',
'end',
'',
'always_comb begin',
'\tread_ns = IDLER;',
'\tunique case(read_cs)',
'\t\tIDLER   : read_ns = (|ar_grant)?(AR):(IDLER);',
'\t\tAR      : read_ns = (axi_arvalid & axi_arready)?(R):(AR);',
'\t\tR       : read_ns = (axi_rvalid  &  axi_rready & axi_rlast)?(IDLER):(R);',
'\t\tdefault :;',
'\tendcase',
'end',
'',
'always_comb begin',
'\twrite_ns = IDLEW;',
'\tunique case(write_cs)',
'\t\tIDLEW   : write_ns = (|aw_grant)?(AW):(IDLEW);',
'\t\tAW      : write_ns = (axi_awvalid & axi_awready)?(W):(AW);',
'\t\tW       : write_ns = (axi_wvalid  &  axi_wready & axi_wlast)?(B):(W);',
'\t\tB       : write_ns = (axi_bvalid  &  axi_bready)?(IDLEW):(B);',
'\t\tdefault :;',
'\tendcase',
'end',
'',
'',
'//------------------------[ arbiter select register ]------------------------//',
'always_ff@(posedge ACLK) begin',
'\tif(~ARESETn) begin',
"\t\tread_mas_onehot_idx_reg    <= `MASTER_NUM'd0;",
"\t\tread_slv_onehot_idx_reg    <= `SLAVE_NUM'd0;",
"\t\twrite_mas_onehot_idx_reg   <= `MASTER_NUM'd0;",
"\t\twrite_slv_onehot_idx_reg   <= `SLAVE_NUM'd0;",
"\tend else begin",
"\t\tif ((read_cs == IDLER) & (|ar_grant)) begin",
"\t\t\tread_mas_onehot_idx_reg  <= ar_grant;",
"\t\t\tread_slv_onehot_idx_reg  <= ar_select;",
"\t\tend else if (read_cs == IDLER) begin",
"\t\t\tread_mas_onehot_idx_reg  <= `MASTER_NUM'd0;",
"\t\t\tread_slv_onehot_idx_reg  <= `SLAVE_NUM'd0;",
"\t\tend",
"\t\tif ((write_cs == IDLEW) & (|aw_grant)) begin",
"\t\t\twrite_mas_onehot_idx_reg <= aw_grant;",
"\t\t\twrite_slv_onehot_idx_reg <= aw_select;",
"\t\tend else if (write_cs == IDLEW) begin",
"\t\t\twrite_mas_onehot_idx_reg <= `MASTER_NUM'd0;",
"\t\t\twrite_slv_onehot_idx_reg <= `SLAVE_NUM'd0;",
'\t\tend',
'\tend',
'end',
'',
'',
'assign write_mas_onehot_idx  = ((write_cs == IDLEW) & (|aw_grant))?( aw_grant):(write_mas_onehot_idx_reg);',
'assign write_slv_onehot_idx  = ((write_cs == IDLEW) & (|aw_grant))?(aw_select):(write_slv_onehot_idx_reg);',
'assign read_mas_onehot_idx   = (( read_cs == IDLER) & (|ar_grant))?( ar_grant):( read_mas_onehot_idx_reg);',
'assign read_slv_onehot_idx   = (( read_cs == IDLER) & (|ar_grant))?(ar_select):( read_slv_onehot_idx_reg);'
    
]
for i in t:
    text.append(i)
    
#assign axi signal 
text.append('')
text.append('//------------------------[ assign axi_* signal ]------------------------//')
t = [
"always_comb begin",  
"\taxi_arid     = 'd0;",      
"\taxi_araddr   = 'd0;",      
"\taxi_arlen    = 'd0;",      
"\taxi_arsize   = 'd0;",      
"\taxi_arburst  = 'd0;",          
"\taxi_arvalid  = 'd0;",          
"\taxi_arready  = 'd0;",          
"\taxi_rid      = 'd0;",      
"\taxi_rdata    = 'd0;",      
"\taxi_rresp    = 'd0;",      
"\taxi_rlast    = 'd0;",      
"\taxi_rvalid   = 'd0;",      
"\taxi_rready   = 'd0;", 
"\taxi_awid     = 'd0;",      
"\taxi_awaddr   = 'd0;",      
"\taxi_awlen    = 'd0;",      
"\taxi_awsize   = 'd0;",      
"\taxi_awburst  = 'd0;",          
"\taxi_awvalid  = 'd0;",   
"\taxi_awready  = 'd0;",   
"\taxi_wdata    = 'd0;",      
"\taxi_wstrb    = 'hf;",      
"\taxi_wlast    = 'd0;",      
"\taxi_wvalid   = 'd0;",    
"\taxi_wready   = 'd0;",      
"\taxi_bid      = 'd0;",      
"\taxi_bresp    = 'd0;",      
"\taxi_bvalid   = 'd0;",  
"\taxi_bready   = 'd0;"   
]
for i in t:
    text.append(i)
text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\tread_mas_onehot_idx["+ str(i) +"]: begin//master "+str(i))
    text.append("\t\t\taxi_arid     = ARID_M"+str(i)+";")     
    text.append("\t\t\taxi_araddr   = ARADDR_M"+str(i)+";")    
    text.append("\t\t\taxi_arlen    = ARLEN_M"+str(i)+";")   
    text.append("\t\t\taxi_arsize   = ARSIZE_M"+str(i)+";")  
    text.append("\t\t\taxi_arburst  = ARBURST_M"+str(i)+";")        
    text.append("\t\t\taxi_arvalid  = ARVALID_M"+str(i)+";")
    text.append("\t\t\taxi_rready   = RREADY_M"+str(i)+";")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")

text.append("\tunique case(1'b1)")
for i in range(slave_num):
    text.append("\t\tread_slv_onehot_idx["+ str(i) +"]: begin//slave "+str(i))
    text.append("\t\t\taxi_arready  = ARREADY_S"+str(i)+";")     
    text.append("\t\t\taxi_rid      = RID_S"+str(i)+";")    
    text.append("\t\t\taxi_rdata    = RDATA_S"+str(i)+";")   
    text.append("\t\t\taxi_rresp    = RRESP_S"+str(i)+";")  
    text.append("\t\t\taxi_rlast    = RLAST_S"+str(i)+";")        
    text.append("\t\t\taxi_rvalid   = RVALID_S"+str(i)+";")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")

text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\twrite_mas_onehot_idx["+ str(i) +"]: begin//master "+str(i))
    text.append("\t\t\taxi_awid     = AWID_M"+str(i)+";")     
    text.append("\t\t\taxi_awaddr   = AWADDR_M"+str(i)+";")    
    text.append("\t\t\taxi_awlen    = AWLEN_M"+str(i)+";")   
    text.append("\t\t\taxi_awsize   = AWSIZE_M"+str(i)+";")  
    text.append("\t\t\taxi_awburst  = AWBURST_M"+str(i)+";")        
    text.append("\t\t\taxi_awvalid  = AWVALID_M"+str(i)+";")
    text.append("\t\t\taxi_wdata    = WDATA_M"+str(i)+";")
    text.append("\t\t\taxi_wstrb    = WSTRB_M"+str(i)+";")
    text.append("\t\t\taxi_wlast    = WLAST_M"+str(i)+";")
    text.append("\t\t\taxi_wvalid   = WVALID_M"+str(i)+";")
    text.append("\t\t\taxi_bready   = BREADY_M"+str(i)+";")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")

text.append("\tunique case(1'b1)")
for i in range(slave_num):
    text.append("\t\twrite_slv_onehot_idx["+ str(i) +"]: begin//slave "+str(i))
    text.append("\t\t\taxi_awready  = AWREADY_S"+str(i)+";")     
    text.append("\t\t\taxi_wready   = WREADY_S"+str(i)+";")    
    text.append("\t\t\taxi_bid      = BID_S"+str(i)+";")   
    text.append("\t\t\taxi_bresp    = BRESP_S"+str(i)+";")  
    text.append("\t\t\taxi_bvalid   = BVALID_S"+str(i)+";")        
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("end")

#axi output
text.append('')
text.append('//------------------------[ axi output signal ]------------------------//')
text.append('always_comb begin')
for i in range(master_num):
    text.append("\tARREADY_M"+ str(i) +" = 'd0;")
    text.append("\tRID_M"+ str(i) +"     = 'd0;")
    text.append("\tRDATA_M"+ str(i) +"   = 'd0;")
    text.append("\tRRESP_M"+ str(i) +"   = 'd0;")
    text.append("\tRLAST_M"+ str(i) +"   = 'd0;")
    text.append("\tRVALID_M"+ str(i) +"  = 'd0;")
    text.append("\tAWREADY_M"+ str(i) +" = 'd0;")
    text.append("\tWREADY_M"+ str(i) +"  = 'd0;")
    text.append("\tBID_M"+ str(i) +"     = 'd0;")
    text.append("\tBRESP_M"+ str(i) +"   = 'd0;")
    text.append("\tBVALID_M"+ str(i) +"  = 'd0;")
text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\tread_mas_onehot_idx["+ str(i) +"] & (read_cs == AR): begin//master "+str(i))
    text.append("\t\t\tARREADY_M0 = axi_arready;")
    text.append("\t\tend")
    text.append("\t\tread_mas_onehot_idx["+ str(i) +"] & (read_cs ==  R): begin//master "+str(i))
    text.append("\t\t\tRID_M"+ str(i) +"     = axi_rid[3:0];")
    text.append("\t\t\tRDATA_M"+ str(i) +"   = axi_rdata;")
    text.append("\t\t\tRRESP_M"+ str(i) +"   = axi_rresp;")
    text.append("\t\t\tRLAST_M"+ str(i) +"   = axi_rlast;")
    text.append("\t\t\tRVALID_M"+ str(i) +"  = axi_rvalid;")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\twrite_mas_onehot_idx["+ str(i) +"] & (write_cs == AW): begin//master "+str(i))
    text.append("\t\t\tAWREADY_M"+ str(i) +" = axi_awready;")
    text.append("\t\tend")
    text.append("\t\twrite_mas_onehot_idx["+ str(i) +"] & (write_cs == W): begin//master "+str(i))
    text.append("\t\t\tWREADY_M"+ str(i) +" = axi_wready;")
    text.append("\t\tend")
    text.append("\t\twrite_mas_onehot_idx["+ str(i) +"] & (write_cs == B): begin//master "+str(i))
    text.append("\t\t\tBID_M"+ str(i) +"     = axi_bid[3:0];")
    text.append("\t\t\tBRESP_M"+ str(i) +"   = axi_bresp ;")
    text.append("\t\t\tBVALID_M"+ str(i) +"  = axi_bvalid;")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("end")

text.append('always_comb begin')
for i in range(slave_num):
    text.append("\tAWID_S"+ str(i) +"     =   'd0;")
    text.append("\tAWADDR_S"+ str(i) +"   =   'd0;")
    text.append("\tAWLEN_S"+ str(i) +"    =   'd0;")
    text.append("\tAWSIZE_S"+ str(i) +"   =   'd0;")
    text.append("\tAWBURST_S"+ str(i) +"  =   'd0;")
    text.append("\tAWVALID_S"+ str(i) +"  =   'd0;")
    text.append("\tWDATA_S"+ str(i) +"    =   'd0;")
    text.append("\tWSTRB_S"+ str(i) +"    =   'hf;")
    text.append("\tWLAST_S"+ str(i) +"    =   'd0;")
    text.append("\tWVALID_S"+ str(i) +"   =   'd0;")
    text.append("\tARID_S"+ str(i) +"     =   'd0;")
    text.append("\tARADDR_S"+ str(i) +"   =   'd0;")
    text.append("\tARLEN_S"+ str(i) +"    =   'd0;")
    text.append("\tARSIZE_S"+ str(i) +"   =   'd0;")
    text.append("\tARBURST_S"+ str(i) +"  =   'd0;")
    text.append("\tARVALID_S"+ str(i) +"  =   'd0;")
    text.append("\tRREADY_S"+ str(i) +"   =   'd0;")
    text.append("\tBREADY_S"+ str(i) +"   =   'd0;")
text.append("\tunique case(1'b1)")
for i in range(slave_num):
    text.append("\t\tread_slv_onehot_idx["+ str(i) +"] & (read_cs == AR): begin//slave "+str(i))
    text.append("\t\t\tARID_S"+ str(i) +"    = {`BRIDGE_ID,axi_arid};")
    text.append("\t\t\tARADDR_S"+ str(i) +"  = axi_araddr;")
    text.append("\t\t\tARLEN_S"+ str(i) +"   = axi_arlen;")
    text.append("\t\t\tARSIZE_S"+ str(i) +"  = axi_arsize;")
    text.append("\t\t\tARBURST_S"+ str(i) +" = axi_arburst;")
    text.append("\t\t\tARVALID_S"+ str(i) +" = axi_arvalid;")
    text.append("\t\tend")
    text.append("\t\tread_slv_onehot_idx["+ str(i) +"] & (read_cs == R): begin//slave "+str(i))
    text.append("\t\t\tRREADY_S"+ str(i) +"  = axi_rready;")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("")
text.append("\tunique case(1'b1)")
for i in range(slave_num):
    text.append("\t\twrite_slv_onehot_idx["+ str(i) +"] & (write_cs == AW): begin//slave "+str(i))
    text.append("\t\t\tAWID_S"+ str(i) +"    = {`BRIDGE_ID,axi_awid};")
    text.append("\t\t\tAWADDR_S"+ str(i) +"  = axi_awaddr;")
    text.append("\t\t\tAWLEN_S"+ str(i) +"   = axi_awlen;")
    text.append("\t\t\tAWSIZE_S"+ str(i) +"  = axi_awsize;")
    text.append("\t\t\tAWBURST_S"+ str(i) +" = axi_awburst;")
    text.append("\t\t\tAWVALID_S"+ str(i) +" = axi_awvalid;")
    text.append("\t\tend")
    text.append("\t\twrite_slv_onehot_idx["+ str(i) +"] & (write_cs == W): begin//slave "+str(i))
    text.append("\t\t\tWDATA_S"+ str(i) +"  = axi_wdata;")
    text.append("\t\t\tWSTRB_S"+ str(i) +"  = axi_wstrb;")
    text.append("\t\t\tWLAST_S"+ str(i) +"  = axi_wlast;")
    text.append("\t\t\tWVALID_S"+ str(i) +" = axi_wvalid;")
    text.append("\t\tend")
    text.append("\t\twrite_slv_onehot_idx["+ str(i) +"] & (write_cs == B): begin//slave "+str(i))
    text.append("\t\t\tBREADY_S"+ str(i) +" = axi_bready;")
    text.append("\t\tend")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("end")
text.append("")

#arbiter / decoder
ar_request = 'assign ar_request = {'
aw_request = 'assign aw_request = {'
for i in range(master_num - 1, -1, -1):
    if (i == 0):
        ar_request += ' ARVALID_M0};'
        aw_request += ' AWVALID_M0};'
    else:
        ar_request += ' ARVALID_M'+str(i)+','
        aw_request += ' AWVALID_M'+str(i)+','
        
text.append('//------------------------[ arbiter / decoder ]------------------------//')
text.append(ar_request)
text.append(aw_request)
text.append("")
text.append('always_comb begin')
text.append("\taw_grant_mas_addr = `ADDR_WIDTH'h0;")
text.append("\tar_grant_mas_addr = `ADDR_WIDTH'h0;")
text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\twrite_mas_onehot_idx["+str(i)+"]: aw_grant_mas_addr = AWADDR_M"+str(i)+";")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("\tunique case(1'b1)")
for i in range(master_num):
    text.append("\t\tread_mas_onehot_idx["+str(i)+"]: ar_grant_mas_addr = ARADDR_M"+str(i)+";")
text.append("\t\tdefault;")
text.append("\tendcase")
text.append("end")

text.append("priority_arbiter #(")
text.append("\t.MASTER_NUM(`MASTER_NUM)")
text.append(")AW_arbiter(")
text.append("\t.request(aw_request),")
text.append("\t.grant  (aw_grant)")
text.append(");")
text.append("")
text.append("decoder #(")
text.append("\t.SLAVE_NUM(`SLAVE_NUM)")
text.append(")AW_decoder(")
text.append("\t.addr   (aw_grant_mas_addr),")
text.append("\t.select (aw_select)")
text.append(");")
text.append("")
text.append("priority_arbiter #(")
text.append("\t.MASTER_NUM(`MASTER_NUM)")
text.append(")AR_arbiter(")
text.append("\t.request(ar_request),")
text.append("\t.grant  (ar_grant)")
text.append(");")
text.append("")
text.append("decoder #(")
text.append("\t.SLAVE_NUM(`SLAVE_NUM)")
text.append(")AR_decoder(")
text.append("\t.addr   (ar_grant_mas_addr),")
text.append("\t.select (ar_select)")
text.append(");")
text.append("")
text.append("endmodule")

with open('./generate_file/AXI.sv', 'w') as f:
    for t in text:
        f.write(t+'\n')

text = []
text.append("module decoder#(")
text.append("\tparameter SLAVE_NUM = 1")
text.append(")(")
text.append("\tinput  logic [`ADDR_WIDTH:0] addr,")
text.append("\toutput logic [SLAVE_NUM - 1:0] select ")
text.append(");")
text.append("\talways_comb begin")
text.append("\t\tselect = SLAVE_NUM'b0;")
text.append("\t\tunique case(addr)")
for i in range(slave_num):
    onehot = ''
    for j in range(slave_num):
        if i == j:
            onehot = '1' + onehot
        else:
            onehot = '0' + onehot
    text.append("\t\t\t`ADDR_WIDTH'd[user defined] : select = SLAVE_NUM'b"+onehot+";")
text.append("\t\t\tdefault:;")
text.append("\t\tendcase")
text.append("\tend")
text.append("endmodule")

with open('./generate_file/decoder.sv', 'w') as f:
    for t in text:
        f.write(t+'\n')


text = []
text.append("module priority_arbiter #(")
text.append("\tparameter MASTER_NUM = 1")
text.append(")(")
text.append("\tinput  logic [MASTER_NUM - 1:0] request,")
text.append("\toutput logic [MASTER_NUM - 1:0] grant")
text.append(");")
text.append("\tlogic [MASTER_NUM - 1:0]  pre_req;")
text.append("\tassign pre_req[0] = 1'b0;")
text.append("\tassign pre_req[1] = request[0] | pre_req[0];")
text.append("\tassign grant      = request & (~pre_req);")
text.append("endmodule")

with open('./generate_file/priority_arbiter.sv', 'w') as f:
    for t in text:
        f.write(t+'\n')
