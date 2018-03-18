 `timescale 1ns / 1ps

module myDAC_TOP(
input CLK, 
input pbup,pbdown,pbleft,pbright,pbcenter,[15:0]sw,[15:0]led,
output [3:0] JA,
output a, b, c, d, e, f, g, dp, 
output [3:0] an);

//DATA_A VARIABLES
wire[11:0] STEPVALUE; 
reg [27:0] DISP; 
reg [11:0] DATA_A = 12'd0;
reg [11:0] MIN = 12'd0;
reg [11:0] MAX = 12'd4095; 
reg [13:0] pressed = 14'd0;
reg [27:0] TRACK = 28'b1;
reg FREQ; 
reg [27:0] COUNT = 28'b0;
reg tick = 0; 
reg [11:0] STEPUP;
reg [11:0] STEPDOWN; 
reg [11:0] sine [0:359]; 
integer sinval;
reg [6:0] dutycount = 7'd0;  
integer left_freq = 50 ;

//DEBOUCING CLOCKS
wire HALF_CLOCK; wire SAMP_CLOCK; wire NEW_CLOCK;
HALF_CLOCK f1(CLK,HALF_CLOCK);
SAMP_CLOCK f2(CLK,SAMP_CLOCK); 
NEW_CLOCK f3(CLK,NEW_CLOCK); 

//DEBOUNCING PUSH BUTTONS 
wire du; wire dd; wire dl; wire dr; wire dc;  
maindff DU(NEW_CLOCK,pbup,du);
maindff DD(NEW_CLOCK,pbdown,dd);
maindff DL(NEW_CLOCK,pbleft,dl);
maindff DR(NEW_CLOCK,pbright,dr);
maindff DC(NEW_CLOCK,pbcenter,dc);

// RESET DATA_A
//always @ (posedge CLK)begin 
//if (sw[6] && dc)begin
//    MAX = 4095;
//    MIN = 0;
//    DATA_A = 0; 
//    pressed = 0;
//    left_freq = 50; end 
//end     

// ASSIGNING LEDS TO SWITCHES 
//assign led[0] = sw[0];
//assign led[1] = sw[1]; assign led[2] = sw[2]; assign led[3] = sw[3]; assign led[4] = sw[4]; assign led[5] = sw[5]; 
//assign led[6] = sw[6]; assign led[7] = sw[7]; assign led[8] = sw[8]; assign led[9] = sw[9]; assign led[10] = sw[10]; 
//assign led[11] = sw[11]; assign led[12] = sw[12]; assign led[13] = sw[13]; assign led[14] = sw[14];assign led[15] = sw[15];

// SINE WAVE LOOKUP TABLE 
initial begin
sine [0] = 2048;
sine [1] = 2083;
sine [2] = 2119;
sine [3] = 2155;
sine [4] = 2190;
sine [5] = 2226;
sine [6] = 2262;
sine [7] = 2297;
sine [8] = 2332;
sine [9] = 2368;
sine [10] = 2403;
sine [11] = 2438; 
sine [12] = 2473;
sine [13] = 2508;
sine [14] = 2543; 
sine [15] = 2577; 
sine [16] = 2612;
sine [17] = 2646; 
sine [18] = 2680;
sine [19] = 2714;
sine [20] = 2748;
sine [21] = 2781; 
sine [22] = 2815;
sine [23] = 2848;
sine [24] = 2880;
sine [25] = 2913;
sine [26] = 2945;
sine [27] = 2977;
sine [28] = 3009;
sine [29] = 3040;
sine [30] = 3071;
sine [31] = 3102;
sine [32] = 3133;
sine [33] = 3163;
sine [34] = 3192;
sine [35] = 3222;
sine [36] = 3251;
sine [37] = 3280;
sine [38] = 3308;
sine [39] = 3336;
sine [40] = 3364;
sine [41] = 3391;
sine [42] = 3418;
sine [43] = 3444;
sine [44] = 3470;
sine [45] = 3495;
sine [46] = 3520;
sine [47] = 3545;
sine [48] = 3569;
sine [49] = 3593;
sine [50] = 3616;
sine [51] = 3639;
sine [52] = 3661;
sine [53] = 3683;
sine [54] = 3704;
sine [55] = 3725;
sine [56] = 3745;
sine [57] = 3765;
sine [58] = 3784;
sine [59] = 3803;
sine [60] = 3821;
sine [61] = 3838;
sine [62] = 3855;
sine [63] = 3872;
sine [64] = 3888;
sine [65] = 3903;
sine [66] = 3918;
sine [67] = 3932;
sine [68] = 3946;
sine [69] = 3959;
sine [70] = 3972;
sine [71] = 3983;
sine [72] = 3995;
sine [73] = 4006;
sine [74] = 4016;
sine [75] = 4025;
sine [76] = 4034;
sine [77] = 4043;
sine [78] = 4050;
sine [79] = 4057;
sine [80] = 4064;
sine [81] = 4070;
sine [82] = 4075;
sine [83] = 4080;
sine [84] = 4084;
sine [85] = 4087;
sine [86] = 4090;
sine [87] = 4092;
sine [88] = 4094;
sine [89] = 4095; 
sine [90] = 4095;
sine [91] = 4095;
sine [92] = 4094;
sine [93] = 4092;
sine [94] = 4090;
sine [95] = 4087;
sine [96] = 4084;
sine [97] = 4084;
sine [98] = 4080;
sine [99] = 4075;
sine [100] = 4070; 
sine [101] = 4064; 
sine [102] = 4057;
sine [103] = 4050;
sine [104] = 4043;
sine [105] = 4034;
sine [106] = 4025;
sine [107] = 4016;
sine [108] = 4006;
sine [109] = 3995;
sine [110] = 3983;
sine [111] = 3972;
sine [112] = 3959;
sine [113] = 3946;
sine [114] = 3932;
sine [115] = 3918;
sine [116] = 3903;
sine [117] = 3888;
sine [118] = 3872;
sine [119] = 3855;
sine [120] = 3838;
sine [121] = 3821;
sine [122] = 3803;
sine [123] = 3784;
sine [124] = 3765;
sine [125] = 3745;
sine [126] = 3725;
sine [127] = 3704;
sine [128] = 3683;
sine [129] = 3661;
sine [130] = 3639;
sine [131] = 3616;
sine [132] = 3593;
sine [133] = 3569;
sine [134] = 3545;
sine [135] = 3520;
sine [136] = 3495;
sine [137] = 3470;
sine [138] = 3444;
sine [139] = 3418;
sine [140] = 3391;
sine [141] = 3364;
sine [142] = 3336;
sine [143] = 3308;
sine [144] = 3280;
sine [145] = 3251;
sine [146] = 3222;
sine [147] = 3192;
sine [148] = 3163;
sine [149] = 3133;
sine [150] = 3102;
sine [151] = 3071;
sine [152] = 3040;
sine [153] = 3009;
sine [154] = 2977;
sine [155] = 2945;
sine [156] = 2913;
sine [157] = 2880;
sine [158] = 2848;
sine [159] = 2815;
sine [160] = 2781;
sine [161] = 2748;
sine [162] = 2714;
sine [163] = 2680;
sine [164] = 2646;
sine [165] = 2612;
sine [166] = 2577;
sine [167] = 2543;
sine [168] = 2508;
sine [169] = 2473;
sine [170] = 2438;
sine [171] = 2403;
sine [172] = 2368;
sine [173] = 2332;
sine [174] = 2297;
sine [175] = 2262;
sine [176] = 2226;
sine [177] = 2190;
sine [178] = 2155;
sine [179] = 2119;
sine [180] = 2083;
sine [181] = 2048;
sine [182] = 2012;
sine [183] = 1976;
sine [184] = 1940;
sine [185] = 1905;
sine [186] = 1869;
sine [187] = 1833;
sine [188] = 1798;
sine [189] = 1763;
sine [190] = 1727;
sine [191] = 1692;
sine [192] = 1657;
sine [193] = 1622;
sine [194] = 1587;
sine [195] = 1552;
sine [196] = 1518;
sine [197] = 1483;
sine [198] = 1449;
sine [199] = 1415;
sine [200] = 1381;
sine [201] = 1347;
sine [202] = 1314;
sine [203] = 1280;
sine [204] = 1247;
sine [205] = 1215;
sine [206] = 1182;
sine [207] = 1150;
sine [208] = 1118;
sine [209] = 1086;
sine [210] = 1055;
sine [211] = 1024;
sine [212] = 993;
sine [213] = 962;
sine [214] = 932;
sine [215] = 903;
sine [216] = 873;
sine [217] = 844;
sine [218] = 815;
sine [219] = 787;
sine [220] = 759;
sine [221] = 731;
sine [222] = 704;
sine [223] = 677;
sine [224] = 651;
sine [225] = 625;
sine [226] = 600;
sine [227] = 575;
sine [228] = 550;
sine [229] = 526;
sine [230] = 502;
sine [231] = 479;
sine [232] = 456;
sine [233] = 434;
sine [234] = 412;
sine [235] = 391;
sine [236] = 370;
sine [237] = 350;
sine [238] = 330;
sine [239] = 311;
sine [240] = 292;
sine [241] = 274;
sine [242] = 257;
sine [243] = 240;
sine [244] = 223;
sine [245] = 207;
sine [246] = 192;
sine [247] = 177;
sine [248] = 163;
sine [249] = 149;
sine [250] = 136;
sine [251] = 123;
sine [252] = 112;
sine [253] = 100;
sine [254] = 89;
sine [255] = 79;
sine [256] = 70;
sine [257] = 61;
sine [258] = 52;
sine [259] = 45;
sine [260] = 38;
sine [261] = 31;
sine [262] = 25;
sine [263] = 20;
sine [264] = 15;
sine [265] = 11; 
sine [266] = 8;
sine [267] = 5;
sine [268] = 3;
sine [269] = 1;
sine [270] = 0;
sine [271] = 0;
sine [272] = 0;
sine [273] = 1;
sine [274] = 3;
sine [275] = 5;
sine [276] = 8;
sine [277] = 11;
sine [278] = 15;
sine [279] = 20;
sine [280] = 25;
sine [281] = 31;
sine [282] = 38;
sine [283] = 45;
sine [284] = 52;
sine [285] = 61;
sine [286] = 70;
sine [287] = 79;
sine [288] = 89;
sine [289] = 100; 
sine [290] = 112; 
sine [291] = 123;
sine [292] = 136;
sine [293] = 149;
sine [294] = 163;
sine [295] = 177;
sine [296] = 192;
sine [297] = 207;
sine [298] = 223;
sine [299] = 240;
sine [300] = 257;
sine [301] = 274;
sine [302] = 292;
sine [303] = 311;
sine [304] = 330;
sine [305] = 350;
sine [306] = 370;
sine [307] = 391;
sine [308] = 412;
sine [309] = 434;
sine [310] = 456;
sine [311] = 479;
sine [312] = 502;
sine [313] = 526;
sine [314] = 550;
sine [315] = 575;
sine [316] = 600;
sine [317] = 625;
sine [318] = 651;
sine [319] = 677;
sine [320] = 704;
sine [321] = 731;
sine [322] = 759;
sine [323] = 787;
sine [324] = 815;
sine [325] = 844;
sine [326] = 873;
sine [327] = 903;
sine [328] = 932;
sine [329] = 962;
sine [330] = 993;
sine [331] = 1024;
sine [332] = 1055;
sine [333] = 1086;
sine [334] = 1118;
sine [335] = 1150; 
sine [336] = 1182;
sine [337] = 1215;
sine [338] = 1247;
sine [339] = 1280;
sine [340] = 1314;
sine [341] = 1347;
sine [342] = 1381;
sine [343] = 1415;
sine [344] = 1449;
sine [345] = 1483;
sine [346] = 1518;
sine [347] = 1552;
sine [348] = 1587;
sine [349] = 1622;
sine [350] = 1657;
sine [351] = 1692;
sine [352] = 1727;
sine [353] = 1763;
sine [354] = 1798;
sine [355] = 1833;
sine [357] = 1905;
sine [358] = 1940;
sine [359] = 1976;
sine [359] = 2012;
end 
 
// STEPVALUE FOR BOTH DATA_A AND DATA_B
assign STEPVALUE = sw[5] ? (sw[4] ? 12'd1000 : 12'd100) : (sw[4] ? 12'd10 : 12'd1);

// FREQUENCY, DUTY-CYCLE & AMPLITUDE CONTROL FOR DATA_A 
always @ (posedge dd | du | dr | dl) begin
 // ADJUST MAXMIMUM VOLTAGE OF DATA_A
 if (sw[0] && sw[6])begin 
   if (dd && (MAX <= MIN + STEPVALUE ))
      MAX <= MIN; 
   else if (dd) begin
      MAX <= (MAX - STEPVALUE);end    
   if (du && (MAX <= 12'd4095 - STEPVALUE)) begin
      MAX <= (MAX + STEPVALUE);end      
   else if (du && (MAX > 12'd4095 - STEPVALUE))begin   
         MAX <= 12'd4095;end  
 end 
// ADJUST MINIMUM VOTAGE OF DATA_A 
 
if (sw[1] && sw[6]) begin
    if (du && (MIN >= MAX - STEPVALUE)) 
        MIN <= MAX;  
    else if (du) begin  
        MIN <= (MIN + STEPVALUE);end 
    if (dd && (MIN >= 12'd0 + STEPVALUE))begin
          MIN <= (MIN - STEPVALUE);end       
    else if (dd && (MIN < 12'd0 + STEPVALUE)) 
           MIN <= 12'd0;
 end
 
 //DECREASE FREQUENCY OF DATA_A
if(dl && sw[2]&& sw[6])begin
        if(pressed >= STEPVALUE)begin
            pressed = pressed - STEPVALUE;end
        else begin
            pressed = 12'd0;end
end 

//INCREASE FREQUENCY OF DATA_A     
if(dr && sw[2]&& sw[6])begin
          if ( pressed <= 14'd9999 - STEPVALUE)begin
              pressed =  pressed + STEPVALUE;end
          else begin
              pressed = 14'd9999;end
end

//DECREASE DUTY CYCLE OF DATA_A 
if (dl && sw[3]&& sw[6])begin
   if (left_freq >= left_freq - STEPVALUE)
       left_freq <= left_freq - STEPVALUE;
end 

//INCREASE DUTY CYCLE OF DATA_A
if (dr && sw[3]&& sw[6])begin        
   if (left_freq <= 100 - STEPVALUE)
       left_freq <= left_freq + STEPVALUE;
end 
      
end 

//DATA_A VARIABLE FREQUENCY CONTROL 
always @(posedge CLK) begin
// TRIANGLE WAVE CLOCK DATA_A
if (sw[9]) 
TRACK <= (28'd500000/pressed);
// SINE WAVE CLOCK DATA_A 
else if (sw[10])
TRACK <= (28'd25000000/pressed)/180;
//SQUARE WAVE CLOCK DATA_A 
else if (sw[8])
TRACK <= (28'd50000000/pressed)/100;
    COUNT = COUNT + 1; 
    FREQ <= (COUNT == TRACK) ? ~FREQ : FREQ; 
    if (COUNT == TRACK)
        COUNT = 28'b0;
end 

     
//DATA_A WAVEFORM GENERATOR 

always @ (posedge FREQ) begin 

//DC VOLTAGE 
if (sw[8]==0&&sw[9]==0&&sw[10]==0&&sw[11]==0)
   DATA_A = MIN; 

//SQUARE WAVE GENERATOR DATA_A 
if (sw[8] && pressed != 0) begin
      DATA_A <= (dutycount <= left_freq) ? MAX : MIN;
      dutycount <= (dutycount == 100) ? 0 : dutycount + 1;end 

//TRIANGLE WAVE GENERATOR DATA_A
if (sw[9] && pressed != 0)begin  
 STEPUP = (MAX - MIN)/left_freq;  
 STEPDOWN = (MAX - MIN)/(100-left_freq); 
    if (tick == 1)begin 
        if (DATA_A <= MAX - STEPUP) 
            DATA_A = DATA_A + STEPUP;
        else if (DATA_A > MAX - STEPUP)begin
        DATA_A <= MAX;    
        tick = 0;end
    end  
        
   else if (tick == 0) begin
        if (DATA_A >= MIN +  STEPDOWN)
        DATA_A <= DATA_A - STEPDOWN; 
        else if (DATA_A < MIN + STEPDOWN)begin
        DATA_A <= MIN;
        tick = 1;end
   end 
end 

//SINE WAVE GENERATOR DATA_A
if (sw[10] && pressed != 0)begin
DATA_A <= (sine[sinval] * (MAX - MIN)/4095 + MIN);
sinval <= (sinval == 359) ? 0 : sinval + 1; 
end

//ARBITARY WAVE GENERATOR DATA_A
if (sw[11] && pressed != 0)begin
DATA_A <= ((sine[sinval]/sinval) + MIN);
sinval <= (sinval == 359) ? 0 : sinval + 1; 
end

end  


//--------------------------------------------------------------------------------------------------------------------//

// DATA_B VARIABLES  
reg [11:0] DATA_B = 12'd0;
reg [11:0] MIN_B = 12'd0;
reg [11:0] MAX_B = 12'd4095; 
reg [13:0] pressed_B = 14'd0;
reg [27:0] TRACK_B = 28'b1;
reg FREQ_B; 
reg [27:0] COUNT_B = 28'b0;
reg tick_B = 0; 
reg [11:0] STEPUP_B;
reg [11:0] STEPDOWN_B; 
integer sinval_B;
reg [6:0] dutycount_B = 7'd0;   
integer left_freq_B = 50 ;

// RESET FOR DATA_B 
//always @ (posedge CLK)begin 
//  if (sw[7] && dc )begin
//        MAX_B = 4095;
//        MIN_B = 0;
//        DATA_B = 0; 
//        pressed_B = 0;
//        left_freq_B = 50; end 
//end  
 

// FREQUENCY, DUTY-CYCLE & AMPLITUDE CONTROL FOR DATA_B 
always @ (posedge dd | du | dr | dl) begin
 
 // ADJUST MAXIMUM VOLTAGE OF DATA_B
 if (sw[0]&& sw[7])begin 
   if (dd && (MAX_B <= MIN_B + STEPVALUE ))
      MAX_B <= MIN_B; 
   else if (dd) begin
      MAX_B <= (MAX_B - STEPVALUE);end    
   if (du && (MAX_B <= 12'd4095 - STEPVALUE)) begin
      MAX_B <= (MAX_B + STEPVALUE);end      
   else if (du && (MAX_B > 12'd4095 - STEPVALUE))begin   
         MAX_B <= 12'd4095;end  

 end 

// ADJUST MINIMUM VOLTAGE OF DATA_B
if (sw[1]&& sw[7]) begin
    if (du && (MIN_B >= MAX_B - STEPVALUE)) 
        MIN_B <= MAX_B;  
    else if (du) begin  
        MIN_B <= (MIN_B + STEPVALUE);end 
    if (dd && (MIN_B >= 12'd0 + STEPVALUE))begin
          MIN_B <= (MIN_B - STEPVALUE);end       
    else if (dd && (MIN_B < 12'd0 + STEPVALUE)) 
           MIN_B <= 12'd0;
 end
 
//DECREASING DATA_B FREQUENCY   
if(dl && sw[2]&& sw[7])begin
        if(pressed_B >= STEPVALUE)begin
            pressed_B = pressed_B - STEPVALUE;end
        else begin
            pressed_B = 12'd0;end
end     

//INCREASING DATA_B FREQUENCY 
if(dr && sw[2]&& sw[7])begin
          if ( pressed_B <= 14'd9999 - STEPVALUE)begin
              pressed_B =  pressed_B + STEPVALUE;end
          else begin
              pressed_B = 14'd9999;end
end

//DECREASING DATA_B DUTY CYCLE 
if (dl && sw[3]&& sw[7])begin
   if (left_freq_B >= left_freq_B - STEPVALUE)
       left_freq_B <= left_freq_B - STEPVALUE;
end 

//INCREASING DATA_B DUTY CYCLE 
if (dr && sw[3]&& sw[7])begin        
   if (left_freq_B <= 100 - STEPVALUE)
       left_freq_B <= left_freq_B + STEPVALUE;
end 
      
end 

//DATA_B VARIABLE FREQUENCY CONTROL 

always @(posedge CLK) begin
//DATA_B TRIANGLE WAVE CLOCK
if (sw[13]) 
TRACK_B <= (28'd500000/pressed_B);
//DATA_B SINE WAVE & ARBITARY WAVE CLOCK
else if (sw[14])
TRACK_B <= (28'd25000000/pressed_B)/180;
// DATA_B SQUARE WAVE CLOCK
else if (sw[12]) 
TRACK_B <= (28'd50000000/pressed_B)/100;
    COUNT_B = COUNT_B + 1; 
    FREQ_B <= (COUNT_B == TRACK_B) ? ~FREQ_B : FREQ_B; 
    if (COUNT_B == TRACK_B)
        COUNT_B = 28'b0;
end 

     
// DATA_B WAVEFORM GENERATOR 

always @ (posedge FREQ_B) begin 

if (sw[12]==0&&sw[13]==0&&sw[14]==0&&sw[15]==0)
   DATA_B = MIN_B; 
   
//SQUARE WAVE GENERATOR 
if (sw[12] && pressed_B != 0) begin
      DATA_B <= (dutycount_B <= left_freq_B) ? MAX_B : MIN_B;
      dutycount_B <= (dutycount_B == 100) ? 0 : dutycount_B + 1;end 

//TRIANGLE WAVE GENERATOR 
if (sw[13] & pressed_B != 0)begin  
 STEPUP_B = (MAX_B - MIN_B)/left_freq_B;  
 STEPDOWN_B = (MAX_B - MIN_B)/(100-left_freq_B); 
    if (tick_B == 1)begin 
        if (DATA_B <= MAX_B - STEPUP_B) 
            DATA_B = DATA_B + STEPUP_B;
        else if (DATA_B > MAX_B - STEPUP_B)begin
        DATA_B <= MAX_B;    
        tick_B = 0;end
    end  
        
   else if (tick_B == 0) begin
        if (DATA_B >= MIN_B +  STEPDOWN_B)
        DATA_B <= DATA_B - STEPDOWN_B; 
        else if (DATA_B < MIN_B + STEPDOWN_B)begin
        DATA_B <= MIN_B;
        tick_B = 1;end
   end 
end 
//SINE WAVE GENERATOR 
if (sw[14] && pressed_B != 0)begin
DATA_B <= (sine[sinval_B] * (MAX_B - MIN_B)/4095 + MIN_B);
sinval_B <= (sinval_B == 359) ? 0 : sinval_B + 1; 
end

//ARBITARY WAVE GENERATOR 
if (sw[15] && pressed_B != 0)begin
DATA_B <= ((sine[sinval_B]/sinval_B) + MIN_B);
sinval_B <= (sinval_B == 359) ? 0 : sinval_B + 1; 
end

end  

// 7 SEGMENT DISPLAY 

//DATA_A and DATA_B VARIABLES DISPLAY 
always @ ( posedge CLK)begin
   if (sw[0] && sw[6])begin 
       DISP = MAX;end
   if (sw[1]&& sw[6])begin
       DISP = MIN;end
   if (sw[2]&& sw[6])begin
      DISP = pressed;end 
   if (sw[3]&& sw[6])begin
      DISP = left_freq;end
   if (sw[0] && sw[7])begin 
       DISP = MAX_B;end
   if (sw[1]&& sw[7])begin
      DISP = MIN_B;end
   if (sw[2]&& sw[7])begin 
      DISP = pressed_B;end
   if (sw[3]&& sw[7])begin
      DISP = left_freq_B;end 
end 

    
sevensegment data_b(CLK,NEW_CLOCK,DISP,a, b, c, d, e, f, g, dp,an);  


//--------------------------------------------------------------------------------------------------------------------//

DA2RefComp u1(
    //SIGNALS PROVIDED TO DA2RefComp
    .CLK(HALF_CLOCK), 
    .START(SAMP_CLOCK), 
    .DATA1(DATA_A), 
    .DATA2(DATA_B), 
    .RST(), 
        
    //DO NOT CHANGE THE FOLLOWING LINES
    .D1(JA[1]), 
    .D2(JA[2]), 
    .CLK_OUT(JA[3]), 
    .nSYNC(JA[0]), 
    .DONE()
    );

endmodule

