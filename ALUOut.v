module ALUOut( input wire [0:0] ALUOutControl, input wire [31:0] SaidaAritDadoFio, output reg [31:0] AluOutFio);
	
	always begin 
	
		case(ALUOutControl)

			1'b1:
			begin
				AluOutFio <= SaidaAritDadoFio;
			end	
		
		endcase

	end
	
endmodule 
