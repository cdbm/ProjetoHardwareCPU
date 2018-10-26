module EPC( input wire [0:0] PCWriteFio, input wire [31:0] SaidaAritDadoFio, output reg [31:0] EPCFio);
	
	always begin 
	
		case(PCWriteFio)

			1'b1:
			begin
				EPCFio <= SaidaAritDadoFio;
			end	
		
		endcase

	end
	
endmodule 