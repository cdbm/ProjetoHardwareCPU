module ExtensorSinal16(input wire [15:0] OffsetFio, output wire [31:0] Ext16Fio);

assign Ext16Fio = {16'd0, OffsetFio[15:0]};

endmodule
