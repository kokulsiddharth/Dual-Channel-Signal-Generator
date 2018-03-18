module SAMP_CLOCK(input CLOCK,output CLOCKOUT);
 reg [4:0] COUNT = 5'b0000;
 reg Cout = 0;
 always @ (posedge CLOCK) begin 
         COUNT <= COUNT + 1;
         Cout <= (COUNT == 5'b0000) ? ~Cout : Cout ;      
 end
 assign CLOCKOUT = Cout; 

    
endmodule