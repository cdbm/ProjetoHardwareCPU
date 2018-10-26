	
module MuxPC( input wire [2:0] RegDst, input wire [31:0] SaidaAritDadoFio , input wire [31:0] EPCFio, input wire [31:0] ALUOutFio, input wire [31:0] JumpFio, input wire [31:0] MDRFio, output reg [31:0] PCFio);
	
	
	always begin 
	
		case(RegDst)
			
			3'b000:
			begin
				PCFio <= SaidaAritDadoFio;
			
			end	
		
			3'b001:
			begin
				PCFio <= EPCFio;
			
			end
		
			3'b010:
			begin
				PCFio <= ALUOutFio;
			
			end
		
			3'b011:
			begin
				PCFio <= JumpFio;
			
			end
			
			3'b100:
			begin
				PCFio <= MDRFio;
			
			end
		endcase

	end
		

endmodule 