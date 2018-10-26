module MuxLo( input wire [31:0] MultLoFio, input wire [31:0] DivLoFio, input wire [0:0] MuxLo, output reg [31:0] MuxLoFio);

always begin
		case(MuxLo)
			1'b0: 
			begin
			MuxLoFio <= MultLoFio;
			end
						
			1'b1:
			begin
			MuxLoFio <= DivLoFio;
			end
			
		endcase
	end
 
	

endmodule
