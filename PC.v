module PC( input wire [0:0] PCWriteFio, input wire [31:0] PCFio, output reg [31:0] SaidaPCFio);
	
	always begin 
	
		case(PCWriteFio)

			1'b1:
			begin
				SaidaPCFio <= PCFio;
			end	
		
		endcase

	end
	
endmodule 