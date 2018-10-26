module Controle(input wire [5:0] Opcode, 
input wire [5:0] func,
input wire [0:0] clk,
output reg [0:0] PCWrite,
output reg [0:0] PCWriteCond,
output reg [1:0] PCWriteCondMux,
output reg [2:0] MuxBranch,
output reg [2:0] MuxMemoriaEnd,
output reg [0:0] IRWrite,
output reg [0:0] RegWrite,
output reg [1:0] RegDst,
output reg [2:0] MuxULA1,
output reg [2:0] ALUControl,
output reg [0:0] ALUOutControl,
output reg [0:0] DivControl,
output reg [2:0] MuxULA2,
output reg [1:0] MuxMemoriaDado,
output reg [0:0] AControl,
output reg [0:0] BControl,
output reg [0:0] EPCCont,
output reg [0:0] MultControl,
output reg [2:0] RDControl,
output reg [0:0] MuxRD,
output reg [0:0] MuxSaidaLO,
output reg [0:0] MuxSaidaHI,
output reg [1:0] ContShifts,
output reg [3:0] MuxWriteData,
output reg [0:0] MuxHILO,
output reg [0:0] LuiControl,
output reg [0:0] MuxMDR,
output reg [2:0] ControleBits,
output reg [0:0] CHi,
output reg [0:0] CLo,
output reg [0:0] MemRead,
output reg [0:0] MDRControl);

reg [31:0] state;
///OPCODES
parameter TipoR = 6'd0;
parameter Addi = 6'd8;
parameter Beq = 6'd4;
parameter Bne = 6'd5;
parameter Bgt = 6'd7;
parameter Ble = 6'd6;
parameter Lui = 6'd15;
parameter Lh = 6'd33;
parameter Lw = 6'd35;
parameter Lb = 6'd32;
parameter Sw = 6'd43;
parameter Sh = 6'd41;
parameter Sb = 6'd40;
parameter J = 6'd2;
parameter Jal = 6'd3;
parameter Inc = 6'd16;
parameter Dec = 6'd17;

//FUNC
parameter Add = 6'd32;
parameter Sub = 6'd34;
parameter Srl = 6'd0;
parameter Sra = 6'd3;
parameter Sll = 6'd2;
parameter Slt = 6'd42;
parameter And = 6'd36;
parameter Jr = 6'd8;
parameter Sllv = 6'd4;
parameter Srav = 6'd7;
parameter Break = 6'd13;
parameter Rte = 6'd19;
parameter Mult = 6'd24;
parameter Div = 6'd26;
parameter Mfhi = 6'd16;
parameter Mflo = 6'd18;


//ESTADOS
parameter Addi2 = 32'd09;
parameter Addi3 = 32'd010;
parameter Add1 = 32'd18;
parameter Add2 = 32'd19;
parameter Add3 = 32'd110;
parameter Add4 = 32'd111;
parameter Sub1 = 32'd28;
parameter Sub2 = 32'd29;
parameter Sub3 = 32'd210;
parameter Sub4 = 32'd211;
parameter Srl1 = 32'd38;
parameter Srl2 = 32'd39;
parameter Srl3 = 32'd310;
parameter Srl4 = 32'd311;
parameter Srl5 = 32'd312;
parameter Sra1 = 32'd48;
parameter Sra2 = 32'd49;
parameter Sra3 = 32'd410;
parameter Sra4 = 32'd411;
parameter Sra5 = 32'd412;
parameter Sll1 = 32'd58;
parameter Sll2 = 32'd59;
parameter Sll3 = 32'd510;
parameter Sll4 = 32'd511;
parameter Sll5 = 32'd512;
parameter Slt1 = 32'd68;
parameter Slt2 = 32'd69;
parameter Slt3 = 32'd610;
parameter Slt4 = 32'd611;
parameter And1 = 32'd78;
parameter And2 = 32'd79;
parameter And3 = 32'd710;
parameter And4 = 32'd711;
parameter Jr1 = 32'd88;
parameter Jr2 = 32'd89;
parameter Jr3 = 32'd810;
parameter Jr4 = 32'd811;
parameter Sllv1 = 32'd98;
parameter Sllv2 = 32'd99;
parameter Sllv3 = 32'd910;
parameter Sllv4 = 32'd911;
parameter Sllv5 = 32'd912;
parameter Srav1 = 32'd108;
parameter Srav2 = 32'd109;
parameter Srav3 = 32'd1010;
parameter Srav4 = 32'd1011;
parameter Srav5 = 32'd1012;
parameter Break1 = 32'd117;
parameter Break2 = 32'd118;
parameter Break3 = 32'd119;
parameter Break4 = 32'd1110;
parameter Break5 = 32'd1111;
parameter Rte1 = 32'd127;
parameter Beq1 = 32'd137;
parameter Beq2 = 32'd138;
parameter Beq3 = 32'd139;
parameter Beq4 = 32'd1310;
parameter Beq5 = 32'd1311;
parameter Beq6 = 32'd1312;
parameter Beq7 = 32'd1313;
parameter Bne1 = 32'd147;
parameter Bne2 = 32'd148;
parameter Bne3 = 32'd149;
parameter Bne4 = 32'd1410;
parameter Bne5 = 32'd1411;
parameter Bne6 = 32'd1412;
parameter Bne7 = 32'd1413;
parameter Bgt1 = 32'd157;
parameter Bgt2 = 32'd158;
parameter Bgt3 = 32'd159;
parameter Bgt4 = 32'd1510;
parameter Bgt5 = 32'd1511;
parameter Bgt6 = 32'd1512;
parameter Bgt7 = 32'd1513;
parameter Ble1 = 32'd167;
parameter Ble2 = 32'd168;
parameter Ble3 = 32'd169;
parameter Ble4 = 32'd1610;
parameter Ble5 = 32'd1611;
parameter Ble6 = 32'd1612;
parameter Ble7 = 32'd1613;
parameter Lui1 = 32'd177;
parameter Lui2 = 32'd178;
parameter Lui3 = 32'd179;
parameter Lui4 = 32'd1710;
parameter Lw_Lb_Lh1 = 32'd187;
parameter Lw_Lb_Lh2 = 32'd188;
parameter Lw_Lb_Lh3 = 32'd189;
parameter Lw_Lb_Lh4 = 32'd1810;
parameter Lw_Lb_Lh5 = 32'd1811;
parameter Lw_Lb_Lh6 = 32'd1812;
parameter Lw_Lb_Lh7 = 32'd1813;
parameter Lw_Lb_Lh8 = 32'd1814;
parameter Lw_Lb_Lh9 = 32'd1815;
parameter Sw1 = 32'd197;
parameter Sw2 = 32'd198;
parameter Sw3 = 32'd199;
parameter Sw4 = 32'd1910;
parameter Sw5 = 32'd1911;
parameter Sw6 = 32'd1912;
parameter Sh_Sb1 = 32'd207;
parameter Sh_Sb2 = 32'd208;
parameter Sh_Sb3 = 32'd209;
parameter Sh_Sb4 = 32'd2010;
parameter Sh_Sb5 = 32'd2011;
parameter Sh_Sb6 = 32'd2012;
parameter J1 = 32'd247;
parameter Jal1 = 32'd257;
parameter Jal2 = 32'd258;
parameter Jal3 = 32'd259;
parameter Inc1 = 32'd267;
parameter Inc2 = 32'd268;
parameter Inc3 = 32'd269;
parameter Inc4 = 32'd2610;
parameter Inc5 = 32'd2611;
parameter Inc6 = 32'd2612;
parameter Inc7 = 32'd2613;
parameter Inc8 = 32'd2614;
parameter Inc9 = 32'd2615;
parameter Inc10 = 32'd2616;
parameter Dec1 = 32'd277;
parameter Dec2 = 32'd278;
parameter Dec3 = 32'd279;
parameter Dec4 = 32'd2710;
parameter Dec5 = 32'd2711;
parameter Dec6 = 32'd2712;
parameter Dec7 = 32'd2713;
parameter Dec8 = 32'd2714;
parameter Dec9 = 32'd2715;
parameter Dec10 = 32'd2716;
parameter Mult1 = 32'd287;
parameter Mult2 = 32'd288;
parameter Mult3 = 32'd289;
parameter Mult4 = 32'd2810;
parameter Mult5 = 32'd2811;
parameter Div1 = 32'd297;
parameter Div2 = 32'd298;
parameter Div3 = 32'd299;
parameter Div4 = 32'd2910;
parameter Div5 = 32'd2911;
parameter Mfhi1 = 32'd307;
parameter Mflo1 = 32'd317;
reg [5:0] contaMult;
reg [5:0] contaDiv;

//PC+4
parameter pc4 = 32'd3;

	always @(posedge clk)begin

			case(state)
				//RESET
				32'd0:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd1;
				end
				
				32'd1:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd3;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'b1000;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd2;
				end
				
				32'd2:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd3;
				end
				//PC+4
				32'd3:
				begin
					PCWrite = 1'd1;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd1;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd1;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd4;
				end
				
				32'd4:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd5;
				end
				
				32'd5:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd1;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd6;
				end
				
				32'd6:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = 32'd7;
				end
				32'd7:
				begin
					case(Opcode)
						TipoR:	
						begin
							case(func)
							//ADD
								Add:
								begin
									state = Add1;
								end
							//SUB
								Sub:
								begin
									state = Sub1;
								end
							//SRL
								Srl:
								begin
									state = Srl1;
								end
							//SRA
								Sra:
								begin
									state = Sra1;
								end
							//SLL
								Sll:
								begin
									state = Sll1;
								end
							//SLT
								Slt:
								begin
									state = Slt1;
								end
							//AND
								And:
								begin
									state = And1;
								end
							//JR
								Jr:
								begin
									state = Jr1;
								end
							//SLLV
								Sllv:
								begin
								state = Sllv1;
								end
							//SRAV
								Srav:
								begin
								state = Srav1;
								end
							//BREAK
								Break:
								begin
								state = Break1;
								end
							//RTE
								Rte:
								begin
								state = Rte1;
								end
							//MULT
								Mult:
								begin
								state = Mult1;
								end
							//DIV
								Div:
								begin
								state = Div1;
								end
							//MFHI
								Mfhi:
								begin
								state = Mfhi1;
								end
							//MFLO
								Mflo:
								begin
								state = Mflo1;
								end
							//DEFAULT
								default:
								begin
								state = pc4;
								end
							endcase
						end
						//ADDI
						Addi:
						begin
							state = Addi;
						end
						//BEQ
						Beq:
						begin
							state = Beq1;
						end
						
						//BNE
						Bne:
						begin
							state = Beq1;
						end
							
						//BGT
						Bgt:
						begin
							state = Bgt1;
						end
						Ble:
                        begin
                            state = Ble1;
                        end
                       
                        //LUI
                        Lui:
                        begin
                            state = Lui1;
                        end
                        //LW_LB_LH
                        Lw:
                        begin
                            state = Lw_Lb_Lh1;
                        end
                        Lb:
                        begin
                            state = Lw_Lb_Lh1;
                        end
                        Lh:
                        begin
                            state = Lw_Lb_Lh1;
                        end
                       
                        //SW
                        Sw:
                        begin
                            state = Sw1;
                        end
                       
                        //SH-SB
                        Sh:
                        begin
                            state = Sh_Sb1;
                        end
                        Sb:
                        begin
                            state = Sh_Sb1;
                        end
                        
                         J:
                        begin
                            state = J1;
                        end
                       
                        Jal:
                        begin
                            state = Jal1;
                        end
                       
                        Inc:
                        begin
                            state = Inc1;
                        end
                       
                        Dec:
                        begin
                            state = Dec1;
                        end
						
						default:
							begin
							state = pc4;
							end
					endcase
				end
				//ADDI
				Addi:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b100;
					ALUControl = 3'd1;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'b010;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Addi2;
				end
				Addi2:
				begin
					state = Addi3;
				end
				Addi3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				 //SRL
                Srl1:
               
                begin
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                PCWriteCondMux = 1'd0;
                MuxBranch = 3'd0;
                MuxMemoriaEnd = 3'd0;
                IRWrite = 1'd0;
                RegWrite = 1'd0;
                RegDst = 2'd0;
                MuxULA1 = 3'b100;
                ALUControl = 3'd0;
                ALUOutControl = 1'd0;
                DivControl = 1'd0;
                MuxULA2 = 3'b000;
                MuxMemoriaDado = 2'd0;
                AControl = 1'b1;
                BControl = 1'b1;
                EPCCont = 1'd0;
                MultControl = 1'd0;
                RDControl = 3'd0;
                MuxRD = 1'b1;
                MuxSaidaLO = 1'd0;
                MuxSaidaHI = 1'd0;
                ContShifts = 2'b10;
                MuxWriteData = 4'd0;
                MuxHILO = 1'd0;
                LuiControl = 1'd0;
                MuxMDR = 1'd0;
                ControleBits = 3'd0;
                CHi = 1'd0;
                CLo = 1'd0;
                MemRead = 1'd0;
                MDRControl = 1'd0;
                state = Srl2;
               
                end
                Srl2:
                begin  
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'b011;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srl3;
                end
                Srl3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 1'b1;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0100;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srl4;
                end
                Srl4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srl5;
                end
                Srl5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //SRA
                Sra1:
                begin          
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                PCWriteCondMux = 1'd0;
                MuxBranch = 3'd0;
                MuxMemoriaEnd = 3'd0;
                IRWrite = 1'd0;
                RegWrite = 1'd0;
                RegDst = 2'd0;
                MuxULA1 = 3'b100;
                ALUControl = 3'd0;
                ALUOutControl = 1'd0;
                DivControl = 1'd0;
                MuxULA2 = 3'd0;
                MuxMemoriaDado = 2'd0;
                AControl = 1'b1;
                BControl = 1'b1;
                EPCCont = 1'd0;
                MultControl = 1'd0;
                RDControl = 3'd0;
                MuxRD = 1'b1;
                MuxSaidaLO = 1'd0;
                MuxSaidaHI = 1'd0;
                ContShifts = 2'b10;
                MuxWriteData = 4'd0;
                MuxHILO = 1'd0;
                LuiControl = 1'd0;
                MuxMDR = 1'd0;
                ControleBits = 3'd0;
                CHi = 1'd0;
                CLo = 1'd0;
                MemRead = 1'd0;
                MDRControl = 1'd0;
                state = Sra2;
               
               
                end
                Sra2:
                begin                  
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'b100;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sra3;
                   
                end
                Sra3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 2'b01;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0100;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sra4;
                end
                Sra4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sra5;
                end
                Sra5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //SLL
                Sll1:
                begin              
                PCWrite = 1'd0;
                PCWriteCond = 1'd0;
                PCWriteCondMux = 1'd0;
                MuxBranch = 3'd0;
                MuxMemoriaEnd = 3'd0;
                IRWrite = 1'd0;
                RegWrite = 1'd0;
                RegDst = 2'd0;
                MuxULA1 = 3'b100;
                ALUControl = 3'd0;
                ALUOutControl = 1'd0;
                DivControl = 1'd0;
                MuxULA2 = 3'd0;
                MuxMemoriaDado = 2'd0;
                AControl = 1'b1;
                BControl = 1'b1;
                EPCCont = 1'd0;
                MultControl = 1'd0;
                RDControl = 3'd0;
                MuxRD = 1'b1;
                MuxSaidaLO = 1'd0;
                MuxSaidaHI = 1'd0;
                ContShifts = 2'b10;
                MuxWriteData = 4'd0;
                MuxHILO = 1'd0;
                LuiControl = 1'd0;
                MuxMDR = 1'd0;
                ControleBits = 3'd0;
                CHi = 1'd0;
                CLo = 1'd0;
                MemRead = 1'd0;
                MDRControl = 1'd0;
                state = Sll2;
                end
                Sll2:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'b010;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sll3;
                end
                Sll3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 2'b01;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0100;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sll4;
                end
                Sll4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sll5;
                end
                Sll5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //SLT
                Slt1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'b111;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b000;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'b1;
                    BControl = 1'b1;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Slt2;
                end
                Slt2:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 2'b01;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0011;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Slt3;
                end
                Slt3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Slt4;
                end    
                Slt4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
                //JR
                Jr1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b011;
                    ALUControl = 3'b001;
                    ALUOutControl = 1'b1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b101;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Jr2;
                end    
                Jr2:
                begin
                    PCWrite = 1'b1;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'b10;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Jr3;
                end    
                Jr3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Jr4;
                end    
                Jr4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
           
                //SLLV
                Sllv1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'b0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'b01;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sllv2;
                end
                Sllv2:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'b010;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sllv3;
                end            
                Sllv3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 2'b01;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0100;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sllv4;
                end            
                Sllv4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sllv5;
                end        
                Sllv5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //SRAV
                Srav1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'b0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'b01;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srav2;
                end
                Srav2:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'b100;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srav3;
                end
                Srav3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'b1;
                    RegDst = 2'b01;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0100;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srav4;
                end
                Srav4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Srav5;
                end
                Srav5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //Break
                Break1:
                begin  
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'b010;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b001;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'b1;
                    BControl = 1'b1;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Break2;
                end
                Break2:
                begin
                    PCWrite = 1'b1;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Break3;
                end
                Break3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state =Break4;
                end
                Break4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state =Break5;
                end
                Break5:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state =pc4;
                end
               
                //RTE
                Rte1:
                begin
                    PCWrite = 1'b1;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'b001;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
				
				//SUB
				Sub1:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b100;
					ALUControl = 3'b010;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Sub2;
				end
				Sub2:
				begin
					state = Sub3;
				end
				Sub3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd1;
					MuxULA1 = 3'd0;
					ALUControl = 3'b010;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Sub4;
				end
				Sub4:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end		
				//AND
				And1:
				begin 
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b100;
					ALUControl = 3'b011;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Add2;
				end
				And2:
				begin
					state = Add3;
				end
				And3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'b01;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Add4;
				end
				And4:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				//ADD
				Add1:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b100;
					ALUControl = 3'b001;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'b000;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state= Add2;
				end
				
				Add2:
				begin
					state = Add3;
				end
				
				Add3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd1;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Add4;
				end
				
				Add4:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				
				//BEQ
				Beq1:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'b001;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'b100;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Beq2;
				end
				
				Beq2:
				begin
					state = Beq3;
				end
				Beq3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b000;
					ALUControl = 3'b000;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state= Beq4;
				end
				Beq4:
				begin
					if(Opcode == Beq)
					begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd1;
					PCWriteCondMux = 2'b01;
					MuxBranch = 3'b010;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd100;
					ALUControl = 3'b010;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Beq5;
					end
					else if(Opcode == Bne)
					begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd1;
					PCWriteCondMux = 2'b00;
					MuxBranch = 3'b010;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd100;
					ALUControl = 3'b010;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Bne1;
					end
				end
				Beq5:
				begin
					state = Beq6;
				end
				Beq6:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state= pc4;
				end
				
				//BNE
				Bne1:
				begin
					state = Bne2;
				end
				Bne2:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				//BGT
				Bgt1:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'b001;
					ALUOutControl = 1'd1;
					DivControl = 1'd0;
					MuxULA2 = 3'b100;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Bgt2;
				end
				Bgt2:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Bgt3;
				end
				Bgt3:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd1;
					PCWriteCondMux = 2'b10;
					MuxBranch = 3'b010;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'b100;
					ALUControl = 3'b111;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Bgt4;
				end
				Bgt4:
				begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 2'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				//BLE
				Ble1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'b001;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b100;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Ble2;
                end
                Ble2:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'b000;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd1;
                    BControl = 1'd1;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Ble3;
                end
               
                Ble3:
                begin
					PCWrite = 1'd0;
                    PCWriteCond = 1'd1;
                    PCWriteCondMux = 2'b11;
                    MuxBranch = 3'b010;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'b111;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state= Ble4;
                end
                Ble4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'b00;
                    MuxBranch = 3'b000;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //LUI
                Lui1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd1;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Lui2;
                end
                Lui2:
                begin
                    state = Lui3;
                end
                Lui3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd1;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0111;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Lui4;
                end
                Lui4:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //LW_LB_LH
                Lw_Lb_Lh1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'b001;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b010;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd1;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Lw_Lb_Lh2;
                end
                Lw_Lb_Lh2:
                begin
                    state = Lw_Lb_Lh3;
                end
                Lw_Lb_Lh3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Lw_Lb_Lh4;
                end
                Lw_Lb_Lh4:
                begin
                    state = Lw_Lb_Lh5;
                end
                Lw_Lb_Lh5:
                begin
                    state = Lw_Lb_Lh6;
                end
                Lw_Lb_Lh6:
                begin
                    state = Lw_Lb_Lh7;
                end
                Lw_Lb_Lh7:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                        case(Opcode)
                            Lw:
                            begin
                             ControleBits = 3'd0;
                            end
                            Lb:
                            begin
                                ControleBits = 3'b001;
                            end
                            Lh:
                            begin
                                ControleBits = 3'b010;
                            end
                        endcase
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Lw_Lb_Lh8;
                end
                Lw_Lb_Lh8:
                begin
                    state = Lw_Lb_Lh9;
                end
                Lw_Lb_Lh9:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd1;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'b0010;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state= pc4;
                end
               
                //SW
                Sw1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'b001;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b010;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd1;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sw2;
                end
                Sw2:
                begin
                    state = Sw3;
                end
                Sw3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'b001;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'b01;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd1;
                    MDRControl = 1'd0;
                    state = Sw4;
                end
                Sw4:
                begin
                    state = Sw5;
                end
                Sw5:
                begin
                    state = Sw6;
                end
                Sw6:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                //SH_SB
                Sh_Sb1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'b100;
                    ALUControl = 3'b001;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'b010;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd1;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sh_Sb2;
                end
                Sh_Sb2:
                begin
                    state = Sh_Sb3;
                end
                Sh_Sb3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Sh_Sb4;
                end
                Sh_Sb4:
                begin
                    state = Sh_Sb5;
                end
                Sh_Sb5:
                begin
                    state = Sh_Sb6;
                end
                Sh_Sb6:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 2'd0;
                    MuxBranch = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MDRControl = 1'd0;
                   
                    case (Opcode)
                        Sh:
                        begin
                            MuxMemoriaEnd = 3'd1;
                            MuxMemoriaDado = 2'b11;
                            MemRead = 1'd1;
                            ControleBits = 3'b011;
                        end
                       
                        Sb:
                        begin
                            MuxMemoriaEnd = 3'd1;
                            MuxMemoriaDado = 2'b11;
                            MemRead = 1'd1;
                            ControleBits = 3'b100;
                        end
                    endcase
                    state = pc4;
                end
                
                J1:
                begin
                    PCWrite = 1'd1;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'b011;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                Jal1:
                begin
                    PCWrite = 1'd1;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'b011;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd2;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd5;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Jal2;
                end
               
                Jal2:
                begin
                    state = Jal3;
                end
               
                Jal3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                Inc1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd2;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Inc2;
                end
               
                Inc2:
                begin
                    state = Inc3;
                end
               
                Inc3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Inc4;
                end
               
                Inc4:
                begin
                    state = Inc5;
                end
               
                Inc5:
                begin
                    state = Inc6;
                end
               
                Inc6:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd5;
                    ALUControl = 3'd1;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd3;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Inc7;
                end
               
                Inc7:
                begin
                    state = Inc8;
                end
               
                Inc8:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd2;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd1;
                    MDRControl = 1'd0;
                    state = Inc9;
                end
               
                Inc9:
                begin
                    state = Inc10;
                end
               
                Inc10:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
               
                Dec1:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd2;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd1;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Dec2;
                end
               
                Dec2:
                begin
                    state = Dec3;
                end
               
                Dec3:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Dec4;
                end
               
                Dec4:
                begin
                    state = Dec5;
                end
               
                Dec5:
                begin
                    state = Dec6;
                end
               
                Dec6:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd5;
                    ALUControl = 3'd2;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd3;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = Dec7;
                end
               
                Dec7:
                begin
                    state = Dec8;
                end
               
                Dec8:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd1;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd2;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd1;
                    MDRControl = 1'd0;
                    state = Dec9;
                end
               
                Dec9:
                begin
                    state = Dec10;
                end
               
                Dec10:
                begin
                    PCWrite = 1'd0;
                    PCWriteCond = 1'd0;
                    PCWriteCondMux = 1'd0;
                    MuxBranch = 3'd0;
                    MuxMemoriaEnd = 3'd0;
                    IRWrite = 1'd0;
                    RegWrite = 1'd0;
                    RegDst = 2'd0;
                    MuxULA1 = 3'd0;
                    ALUControl = 3'd0;
                    ALUOutControl = 1'd0;
                    DivControl = 1'd0;
                    MuxULA2 = 3'd0;
                    MuxMemoriaDado = 2'd0;
                    AControl = 1'd0;
                    BControl = 1'd0;
                    EPCCont = 1'd0;
                    MultControl = 1'd0;
                    RDControl = 3'd0;
                    MuxRD = 1'd0;
                    MuxSaidaLO = 1'd0;
                    MuxSaidaHI = 1'd0;
                    ContShifts = 2'd0;
                    MuxWriteData = 4'd0;
                    MuxHILO = 1'd0;
                    LuiControl = 1'd0;
                    MuxMDR = 1'd0;
                    ControleBits = 3'd0;
                    CHi = 1'd0;
                    CLo = 1'd0;
                    MemRead = 1'd0;
                    MDRControl = 1'd0;
                    state = pc4;
                end
                
                Div1:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Div2;
				end
				
				Div2:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd1;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Div3;
					contaDiv = 6'd32;
				end
				
				Div3:
                begin
					contaDiv = contaDiv - 1;
					if (contaDiv == 0)
						state = Div4;
				end
				
				Div4:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd1;
					MuxSaidaHI = 1'd1;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd1;
					CLo = 1'd1;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Div5;
				end
				
				Div5:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				Mult1:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd1;
					BControl = 1'd1;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Mult2;
				end
				
				Mult2:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd1;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					contaMult = 6'd35;
					state = Mult3;
				end
				
				Mult3:
                begin
					contaMult = contaMult - 1;
					if (contaMult == 0)
						state = Mult4;
				end
				
				Mult4:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd1;
					CLo = 1'd1;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = Mult5;
				end
				
				Mult5:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd0;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd0;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				Mfhi1:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd6;
					MuxHILO = 1'd1;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
				
				Mflo1:
                begin
					PCWrite = 1'd0;
					PCWriteCond = 1'd0;
					PCWriteCondMux = 1'd0;
					MuxBranch = 3'd0;
					MuxMemoriaEnd = 3'd0;
					IRWrite = 1'd0;
					RegWrite = 1'd1;
					RegDst = 2'd0;
					MuxULA1 = 3'd0;
					ALUControl = 3'd0;
					ALUOutControl = 1'd0;
					DivControl = 1'd0;
					MuxULA2 = 3'd0;
					MuxMemoriaDado = 2'd0;
					AControl = 1'd0;
					BControl = 1'd0;
					EPCCont = 1'd0;
					MultControl = 1'd0;
					RDControl = 3'd0;
					MuxRD = 1'd0;
					MuxSaidaLO = 1'd0;
					MuxSaidaHI = 1'd0;
					ContShifts = 2'd0;
					MuxWriteData = 4'd6;
					MuxHILO = 1'd0;
					LuiControl = 1'd0;
					MuxMDR = 1'd0;
					ControleBits = 3'd0;
					CHi = 1'd0;
					CLo = 1'd0;
					MemRead = 1'd0;
					MDRControl = 1'd0;
					state = pc4;
				end
                
				default:
					begin
					state = pc4;
					end
			endcase	
				
		end
endmodule