module MuxHi( input wire [31:0] MultHiFio, input wire [31:0] DivHiFio, input wire [0:0] MuxHi, output reg [31:0] MuxHiFio);

always begin
		case(MuxHi)
			1'b0: 
			begin
			MuxHiFio <= MultHiFio;
			end
						
			1'b1:
			begin
			MuxHiFio <= DivHiFio;
			end
			
		endcase
	end
 
	

endmodule
