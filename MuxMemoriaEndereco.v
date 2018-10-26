

module MuxMemoriaEndereco( input wire [2:0] MuxMemoriaEnd, input wire [31:0] SaidaPCFio, input wire [31:0] ALUOutFio, input wire[31:0] RDFio, output reg [31:0] MuxMemFio);
	
	
	always begin 
	
		case(MuxMemoriaEnd)
			
			3'b000:
			begin
				MuxMemFio <= SaidaPCFio;
			
			end
		
		
			3'b001:
			begin
				MuxMemFio <= ALUOutFio;
			
			end
		
			3'b010:
			begin
				MuxMemFio <= {24'd0,8'b11111111};
			
			end
		
			3'b011:
			begin
				MuxMemFio <= {24'd0,8'b11111110};
			
			end
		
			3'b100:
			begin
				MuxMemFio <= {24'd0,8'b11111101};
			
			end
		
			3'b101:
			begin
				MuxMemFio <= RDFio;
			
			end
		
		endcase

	end
		

endmodule 
