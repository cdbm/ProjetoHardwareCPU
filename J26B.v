module J26B( input wire [20:0] J20F, input wire [4:0] RSFio, output wire [25:0] JFio);

assign JFio = {RSFio,J20F};

endmodule 