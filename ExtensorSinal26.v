module ExtensorSinal26(input wire [25:0] JFio, output wire [31:0] Ext26Fio);

assign Ext26Fio = {6'd0, JFio[25:0]};

endmodule
