`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2017 17:06:20
// Design Name: 
// Module Name: sevensegment
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


module sevensegment(input clock,user_clock,[27:0]display, 
output a, b, c, d, e, f, g, dp, 
output [3:0]an); 

reg [3:0] in0,in1,in2,in3;  
 
always @ (posedge user_clock) begin 
   in3 = display/1000;
   in2 = (display%1000)/100;
   in1 = (display%100)/10; 
   in0 = (display%10); 
end 
 
localparam N = 18; 
 
reg [N-1:0]count; 
 
always @ (posedge clock)begin
   count <= count + 1;
 end
 
reg [6:0]sseg; //the 7 bit register to hold the data to output
reg [3:0]an_temp; //register for the 4 bit enable
 
always @ (*)
 begin
  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
    
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     sseg = in0;
     an_temp = 4'b1110;
    end
    
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     sseg = in1;
     an_temp = 4'b1101;
    end
    
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg = in2;
     an_temp = 4'b1011;
    end
     
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     sseg = in3;
     an_temp = 4'b0111;
    end
  endcase
 end
assign an = an_temp;


reg [6:0] sseg_temp; // 7 bit register to hold the binary value of each input given
 
always @ (*)begin
  case(sseg)
   4'd0 : sseg_temp = 7'b1000000; //to display 0
   4'd1 : sseg_temp = 7'b1111001; //to display 1
   4'd2 : sseg_temp = 7'b0100100; //to display 2
   4'd3 : sseg_temp = 7'b0110000; //to display 3
   4'd4 : sseg_temp = 7'b0011001; //to display 4
   4'd5 : sseg_temp = 7'b0010010; //to display 5
   4'd6 : sseg_temp = 7'b0000010; //to display 6
   4'd7 : sseg_temp = 7'b1111000; //to display 7
   4'd8 : sseg_temp = 7'b0000000; //to display 8
   4'd9 : sseg_temp = 7'b0010000; //to display 9
   default : sseg_temp = 7'b0111111; //dash
  endcase
  end
  assign {g,f,e,d,c,b,a} = sseg_temp; 
  assign dp = 1'b1; 
endmodule   