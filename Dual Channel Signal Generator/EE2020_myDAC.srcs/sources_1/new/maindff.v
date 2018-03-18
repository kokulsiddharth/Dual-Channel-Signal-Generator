module maindff(input CLOCK, pb,output sp);
   wire Q1, Q2; 
   
   dff f1(CLOCK, pb, Q1);
   dff f2(CLOCK, Q1, Q2);
   
   assign sp = Q1 & ~Q2; 
endmodule