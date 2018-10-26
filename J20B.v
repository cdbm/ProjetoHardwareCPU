module J20B( input wire [15:0] OffsetFio, input wire [4:0] Fio2016, output wire [20:0] J20F);

assign J20F = {Fio2016,OffsetFio};

endmodule 