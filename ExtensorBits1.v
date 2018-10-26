module ExtensorBits1(input wire [0:0] MenorFio, output wire [31:0] Ext1bitFio);

assign Ext1bitFio = {31'd0, MenorFio[0:0]};

endmodule
