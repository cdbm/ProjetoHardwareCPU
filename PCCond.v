module PCCond(input wire [0:0] PCWriteCond, input wire [0:0] PCWrite, input wire [0:0] MuxPCWriteCondFio, output wire [0:0] PCWriteFio);

wire [0:0] PCWriteCondAND;

assign PCWriteCondAND = PCWriteCond[0:0] & MuxPCWriteCondFio[0:0];
assign PCWriteFio = PCWriteCondAND[0:0] | PCWrite[0:0];

endmodule
