module MuxHiLo( input wire [31:0] HiFio, input wire [31:0] LoFio, input wire [0:0] MuxHiLo, output reg [31:0] MuxHiLoFio);

always begin
		case(MuxHiLo)
			1'b0: 
			begin
			MuxHiLoFio <= HiFio;
			end
						
			1'b1:
			begin
			MuxHiLoFio <= LoFio;
			end
			
		endcase
	end
 
	

endmodule
