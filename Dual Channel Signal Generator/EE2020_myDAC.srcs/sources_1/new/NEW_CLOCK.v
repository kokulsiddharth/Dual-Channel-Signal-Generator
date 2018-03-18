`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2017 07:58:33
// Design Name: 
// Module Name: NEW_CLOCK
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module NEW_CLOCK(input CLOCK,output CLOCKOUT);
reg [20:0] COUNT = 21'b0000;
 reg Cout = 0;
 always @ (posedge CLOCK) begin 
         COUNT <= COUNT + 1;
         Cout <= (COUNT == 21'b0000) ? ~Cout : Cout ;      
 end
 assign CLOCKOUT = Cout; 
endmodule


