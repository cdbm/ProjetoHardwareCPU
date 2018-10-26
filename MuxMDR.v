module MuxMDR (input wire[0:0] MuxMDR, input wire [31:0] ExtBitsFio, input wire [31:0] QtdBitsDadoFio,
			 output reg [31:0] MuxMDRFio); 	
	
	always begin
		case(MuxMDR)
			1'b0: 
			begin
			MuxMDRFio <= QtdBitsDadoFio;
			end
			
			1'b1:
			begin
			MuxMDRFio <= ExtBitsFio;
			end
			
		
		endcase
	end
	
endmodule
