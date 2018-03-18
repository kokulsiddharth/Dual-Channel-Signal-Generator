module HALF_CLOCK(input CLOCK,output CLOCKOUT);
 reg COUNT = 1'b0;
 reg Cout = 0;
 always @ (posedge CLOCK) begin 
         COUNT <= COUNT + 1;
         Cout <= (COUNT == 1'b0) ? ~Cout : Cout ;      
 end
 assign CLOCKOUT = Cout; 
endmodule