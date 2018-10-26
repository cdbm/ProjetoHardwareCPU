	
module MuxRegDesl( input wire [1:0] ContShifts, input wire [4:0] Shamt, input wire [31:0] BFio, output reg [31:0] RegWriteFio);
	
	
	always begin 
	
		case(ContShifts)
			
			2'b00:
			begin
				RegWriteFio <= 5'b10000;
			
			end	
		
			2'b01:
			begin
				RegWriteFio <= BFio[4:0];
			
			end
		
			2'b10:
			begin
				RegWriteFio <= Shamt;
			
			end
		
		endcase

	end
		

endmodule 