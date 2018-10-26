module MuxULA2 (input wire [2:0]CRTMuxULA2 ,input wire [31:0] BFio, 
				input wire [31:0] Ext16Fio,  input wire [31:0] ShiftLFio,
				 output reg [31:0] MuxULA2Fio);
				
	always begin
		case(CRTMuxULA2)
			3'b000:
			begin
				MuxULA2Fio <= BFio;
			end
			
			3'b001:
			begin
				MuxULA2Fio <= {29'd0, 3'd100};
			end
			
			3'b010:
			begin
				MuxULA2Fio <= Ext16Fio;
			end
			
			3'b011:
			begin
				MuxULA2Fio <= {31'd0, 1'd1};
			end
			
			3'b100:
			begin
				MuxULA2Fio <= ShiftLFio;
			end
			
			3'b101:
			begin
				MuxULA2Fio <= {32'd0};
			end
			
			
		endcase
	end
	
endmodule