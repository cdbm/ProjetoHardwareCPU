module Juncao( input wire [31:0] PCULAFio, input wire [27:0] ShiftLCimaFio, output wire [31:0] JumpFio);

assign JumpFio = {PCULAFio[31:28],ShiftLCimaFio};

endmodule 