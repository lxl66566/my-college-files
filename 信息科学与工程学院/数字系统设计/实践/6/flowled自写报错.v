`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:04:37 04/24/2023 
// Design Name: 
// Module Name:    flowled 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module flowled(
input start,
input reset,
input clk,
output [7:0] cled
    );
reg flag = 0;
integer i = 0;
reg [20:0] count;
reg [7:0] led = 8'b0000_0000;
assign cled = led;

always@(posedge start)
begin
	flag <= 1;
	led[0] = 1;
end

always@(posedge reset)
begin
	flag <= 0;
	led = 8'b0000_0000;
end
always@(posedge clk)
begin
	if(count[20] == 1) count <= 0;
	else count <= count + 1;
	if(flag && count[20]) begin
		for(i = 0;i < 8;i = i + 1) begin
			if(led[i] == 1) begin
				led[i] <= 0;
				if(i < 7) led[i + 1] <= 1;
				else led[i - 7] <= 1;
			end
			else led <= led;
		end
	end
	else ;
end

endmodule
