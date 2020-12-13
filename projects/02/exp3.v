module SEG8(CLK,switch,seg,sel);
input CLK;
input [3:0] switch;
output reg [7:0] seg;
output reg [2:0] sel;

parameter div = 11;
reg CLK_D;
reg[3:0] count;


//assign CLK = CLK / 50000;
always@(posedge CLK)
begin

if(count < div)
begin
	count <= count + 1'b1;
	CLK_D <= CLK_D;
end
else
begin
	count <= 0;
	CLK_D <= ~CLK_D;
end
end

always@(posedge CLK_D)
begin
case(switch)
4'b0000:begin seg = 8'b00111111; end 
4'b0001:begin seg = 8'b00110000; end 
4'b0010:begin seg = 8'b01011011; end 
4'b0011:begin seg = 8'b01001111; end 
4'b0100:begin seg = 8'b01100110; end
4'b0101:begin seg = 8'b01101101; end 
4'b0110:begin seg = 8'b01111101; end 
4'b0111:begin seg = 8'b00000111; end 
4'b1000:begin seg = 8'b01111111; end 
4'b1001:begin seg = 8'b01101111; end 
4'b1010:begin seg = 8'b01011100; end
4'b1011:begin seg = 8'b01111100; end
4'b1100:begin seg = 8'b01011000; end 
4'b1101:begin seg = 8'b01011110; end 
4'b1110:begin seg = 8'b01111011; end 
4'b1111:begin seg = 8'b01110001; end 
endcase
end

always@(posedge CLK)
begin
sel = sel + 1;
end

endmodule