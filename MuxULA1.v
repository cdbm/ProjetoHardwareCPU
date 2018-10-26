module MuxULA1( input wire [31:0] Ext26Fio, input wire [31:0] PCULAFio, input wire [31:0] AFio, input wire [31:0] MemoriaFio,
input wire [2:0] MuxULA1, output reg [31:0] MuxULA1Fio);

always begin
		case(MuxULA1)
			3'b000: 
			begin
			MuxULA1Fio <= PCULAFio;
			end
						
			3'b010:
			begin
			MuxULA1Fio <= Ext26Fio;
			end
			
			3'b011: 
			begin
			MuxULA1Fio <= 32'd0;
			end
			
			3'b100:
			begin
			MuxULA1Fio <= AFio;
			end
			
			3'b101:
			begin
			MuxULA1Fio <= MemoriaFio;
			end
		
		endcase
	end
 
	

endmodule
