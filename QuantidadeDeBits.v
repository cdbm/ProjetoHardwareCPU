module QuantidadeDeBits(input wire [31:0] BFio, input wire [31:0] MemFio, input wire [2:0] ControleBits,
 output reg[31:0] QtdBitsDadoFio);
 
	always begin
		case(ControleBits)
			
			3'b000: //LW
			begin
			QtdBitsDadoFio <= MemFio;
			end
			
			3'b001: //LB
			begin
			QtdBitsDadoFio <= {MemFio[7:0], 24'd0};
			end
			
			3'b010: //LH	
			begin
			QtdBitsDadoFio <= {MemFio[15:0], 15'd0};
			end
			
			3'b011: //SH
			begin
			QtdBitsDadoFio <= {MemFio[31:16], BFio[15:0]};
			end
			
			3'b100: //SB
			begin
			QtdBitsDadoFio <= {MemFio[31:8], BFio[7:0]};
			end
			
		endcase
	end	
	  
 endmodule
