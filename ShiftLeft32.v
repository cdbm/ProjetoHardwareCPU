module ShiftLeft32(input wire [31:0] Ext16Fio, output wire [31:0] ShiftLFio);

assign ShiftLFio = Ext16Fio[31:0] << 2'b10;

endmodule
