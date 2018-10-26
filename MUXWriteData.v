module MUXWriteData (input wire [3:0] MuxWriteData, input wire [31:0] AluOutFio , input wire [31:0] EPCFio , input wire [31:0] MDRFio,
						input wire [31:0] Menor , input wire [31:0] RegDeslFio , input wire [31:0] SaidaPCFio, 
		    				input wire [31:0] MuxHiLoFio, input wire [31:0] LuiFio,
						output reg [31:0] WriteDataFio);	
		
	always begin
		case(MuxWriteData)
			4'b0000:
			begin
			WriteDataFio <= AluOutFio;
			end
			
			4'b0001:
			begin
			WriteDataFio <= EPCFio;
			end
			
			4'b0010:
			begin
			WriteDataFio <= MDRFio;
			end
			
			4'b0011:
			begin
			WriteDataFio <= Menor;
			end
			
			4'b0100:
			begin
			WriteDataFio <= RegDeslFio;
			end
			
			4'b0101:
			begin
			WriteDataFio <= SaidaPCFio;
			end
			
			4'b0110:
			begin
			WriteDataFio <= MuxHiLoFio;
			end
			
			4'b0111:
			begin
			WriteDataFio <= LuiFio;
			end
			
			4'b1000:
			begin
			//227
			WriteDataFio <= {24'b0,8'b11100011};
			end
			
			
		endcase
	end				
		
		
		
						
endmodule
