module ShiftLeft28(input wire [25:0] JFio, output wire [27:0] ShiftCimaFio);

assign ShiftCimaFio = JFio[25:0] << 2'b10;

endmodule
