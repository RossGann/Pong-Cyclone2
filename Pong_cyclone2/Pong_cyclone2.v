module Pong_cyclone2(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output reg [3:0] VGA_R,    // 4-bit VGA red output
    output reg [3:0] VGA_G,    // 4-bit VGA green output
    output reg [3:0] VGA_B,     // 4-bit VGA blue output
	 input key0, 
	 input key1, 
	 input key2, 
	 input key3,
	 input startsig
    );
	 

wire PL;   //player stuff
wire PR;
reg [8:0]PLy1;
reg [8:0]PLy2;
reg [8:0]PRy1;
reg [8:0]PRy2;
reg [19:0]count;


reg [9:0]ballx1;  //ball stuff
reg [9:0]ballx2;
reg [8:0]bally1;
reg [8:0]bally2;
wire collision;
wire XballMovement;
wire YballMovement;
wire bounceBack;
wire boundaryBoxTop;
wire boundaryboxBottom;
wire boundaryBoxLeft;
wire boundaryBoxRight;
reg [19:0]countball;
reg gameoversig;

//red background
wire red_bg;
assign red_bg = ((x > 0) & (y > 0) & (x < 640) & (y < 480)) ? 1 : 0;

//S
wire s1_;
assign s1_ = ((x > 16) & (y > 8) & (x < 48) & (y < 16)) ? 1 : 0;
wire s2;
assign s2 = ((x > 8) & (y > 16) & (x < 24) & (y < 24)) ? 1 : 0;
wire s3;
assign s3 = ((x > 8) & (y > 24) & (x < 32) & (y < 32)) ? 1 : 0;
wire s4;
assign s4 = ((x > 16) & (y > 32) & (x < 40) & (y < 40)) ? 1 : 0;
wire s5;
assign s5 = ((x > 24) & (y > 40) & (x < 48) & (y < 48)) ? 1 : 0;
wire s6;
assign s6 = ((x > 32) & (y > 48) & (x < 48) & (y < 56)) ? 1 : 0;
wire s7;
assign s7 = ((x > 8) & (y > 56) & (x < 40) & (y < 64)) ? 1 : 0;

//U
wire u1;
assign u1 = ((x > 64) & (y > 8) & (x < 80) & (y < 16)) ? 1 : 0;	
wire u2;
assign u2 = ((x > 64) & (y > 16) & (x < 80) & (y < 24)) ? 1 : 0; 
wire u3;
assign u3 = ((x > 64) & (y > 24) & (x < 80) & (y < 32)) ? 1 : 0; 
wire u4;
assign u4 = ((x > 64) & (y > 32) & (x < 80) & (y < 40)) ? 1 : 0; 
wire u5;
assign u5 = ((x > 64) & (y > 40) & (x < 80) & (y < 48)) ? 1 : 0; 
wire u6;
assign u6 = ((x > 64) & (y > 48) & (x < 88) & (y < 56)) ? 1 : 0; 
wire u7;
assign u7 = ((x > 72) & (y > 56) & (x < 96) & (y < 64)) ? 1 : 0; 
wire u8;
assign u8 = ((x > 96) & (y > 48) & (x < 104) & (y < 64)) ? 1 : 0; 
wire u9;
assign u9 = ((x > 104) & (y > 8) & (x < 112) & (y < 56)) ? 1 : 0;


//D
wire d1;
assign d1 = ((x > 120) & (y > 8) & (x < 160) & (y < 16)) ? 1 : 0; 
wire d2;
assign d2 = ((x > 120) & (y > 16) & (x < 136) & (y < 24)) ? 1 : 0; 
wire d2p2;
assign d2p2 = ((x > 152) & (y > 16) & (x < 168) & (y < 24)) ? 1 : 0; 
wire d3;
assign d3 = ((x > 120) & (y > 24) & (x < 136) & (y < 32)) ? 1 : 0; 
wire d3p2;
assign d3p2 = ((x > 160) & (y > 24) & (x < 176) & (y < 32)) ? 1 : 0;
wire d4;
assign d4 = ((x > 120) & (y > 32) & (x < 136) & (y < 40)) ? 1 : 0; 
wire d4p2;
assign d4p2 = ((x > 160) & (y > 32) & (x < 176) & (y < 40)) ? 1 : 0;
wire d5;
assign d5 = ((x > 120) & (y > 40) & (x < 136) & (y < 48)) ? 1 : 0; 
wire d5p2;
assign d5p2 = ((x > 160) & (y > 40) & (x < 176) & (y < 48)) ? 1 : 0;
wire d6;
assign d6 = ((x > 120) & (y > 48) & (x < 136) & (y < 56)) ? 1 : 0; 
wire d6p2;
assign d6p2 = ((x > 152) & (y > 48) & (x < 168) & (y < 56)) ? 1 : 0; 
wire d7;
assign d7 = ((x > 120) & (y > 56) & (x < 160) & (y < 64)) ? 1 : 0;

//2nd D
wire dD1;
assign dD1 = ((x > 184) & (y > 8) & (x < 224) & (y < 16)) ? 1 : 0; 
wire dD2;
assign dD2 = ((x > 184) & (y > 16) & (x < 200) & (y < 24)) ? 1 : 0; 
wire dD2p2;
assign dD2p2 = ((x > 216) & (y > 16) & (x < 232) & (y < 24)) ? 1 : 0; 
wire dD3;
assign dD3 = ((x > 184) & (y > 24) & (x < 200) & (y < 32)) ? 1 : 0; 
wire dD3p2;
assign dD3p2 = ((x > 224) & (y > 24) & (x < 240) & (y < 32)) ? 1 : 0;
wire dD4;
assign dD4 = ((x > 184) & (y > 32) & (x < 200) & (y < 40)) ? 1 : 0; 
wire dD4p2;
assign dD4p2 = ((x > 224) & (y > 32) & (x < 240) & (y < 40)) ? 1 : 0;
wire dD5;
assign dD5 = ((x > 184) & (y > 40) & (x < 200) & (y < 48)) ? 1 : 0; 
wire dD5p2;
assign dD5p2 = ((x > 224) & (y > 40) & (x < 240) & (y < 48)) ? 1 : 0;
wire dD6;
assign dD6 = ((x > 184) & (y > 48) & (x < 200) & (y < 56)) ? 1 : 0; 
wire dD6p2;
assign dD6p2 = ((x > 216) & (y > 48) & (x < 232) & (y < 56)) ? 1 : 0; 
wire dD7;
assign dD7 = ((x > 184) & (y > 56) & (x < 224) & (y < 64)) ? 1 : 0;

// E
wire e1;
assign e1 = ((x > 248) & (y > 8) & (x < 288) & (y < 16)) ? 1 : 0;
wire e2;
assign e2 = ((x > 248) & (y > 16) & (x < 264) & (y < 24)) ? 1 : 0;
wire e3;
assign e3 = ((x > 248) & (y > 24) & (x < 280) & (y < 32)) ? 1 : 0;
wire e4;
assign e4 = ((x > 248) & (y > 32) & (x < 264) & (y < 40)) ? 1 : 0;
wire e5;
assign e5 = ((x > 248) & (y > 40) & (x < 264) & (y < 48)) ? 1 : 0;
wire e6;
assign e6 = ((x > 248) & (y > 48) & (x < 264) & (y < 56)) ? 1 : 0;
wire e7;
assign e7 = ((x > 248) & (y > 56) & (x < 288) & (y < 64)) ? 1 : 0;

//N
wire n1;
assign n1 = ((x > 296) & (y > 8) & (x < 304) & (y < 64)) ? 1 : 0;
wire n2;
assign n2 = ((x > 304) & (y > 16) & (x < 312) & (y < 40)) ? 1 : 0;
wire n3;
assign n3 = ((x > 312) & (y > 24) & (x < 320) & (y < 48)) ? 1 : 0;
wire n4;
assign n4 = ((x > 320) & (y > 32) & (x < 328) & (y < 56)) ? 1 : 0;
wire n5;
assign n5 = ((x > 328) & (y > 8) & (x < 336) & (y < 64)) ? 1 : 0;

//D of death
wire dDD1;
assign dDD1 = ((x > 184) & (y > 72) & (x < 224) & (y < 80)) ? 1 : 0; 
wire dDD2;
assign dDD2 = ((x > 184) & (y > 80) & (x < 200) & (y < 88)) ? 1 : 0; 
wire dDD2p2;
assign dDD2p2 = ((x > 216) & (y > 80) & (x < 232) & (y < 88)) ? 1 : 0; 
wire dDD3;
assign dDD3 = ((x > 184) & (y > 88) & (x < 200) & (y < 96)) ? 1 : 0; 
wire dDD3p2;
assign dDD3p2 = ((x > 224) & (y > 88) & (x < 240) & (y < 96)) ? 1 : 0;
wire dDD4;
assign dDD4 = ((x > 184) & (y > 96) & (x < 200) & (y < 104)) ? 1 : 0; 
wire dDD4p2;
assign dDD4p2 = ((x > 224) & (y > 96) & (x < 240) & (y < 104)) ? 1 : 0;
wire dDD5;
assign dDD5 = ((x > 184) & (y > 104) & (x < 200) & (y < 112)) ? 1 : 0; 
wire dDD5p2;
assign dDD5p2 = ((x > 224) & (y > 104) & (x < 240) & (y < 112)) ? 1 : 0;
wire dDD6;
assign dDD6 = ((x > 184) & (y > 112) & (x < 200) & (y < 120)) ? 1 : 0; 
wire dDD6p2;
assign dDD6p2 = ((x > 216) & (y > 112) & (x < 232) & (y < 120)) ? 1 : 0; 
wire dDD7;
assign dDD7 = ((x > 184) & (y > 120) & (x < 224) & (y < 128)) ? 1 : 0;

//E of death
wire ee1;
assign ee1 = ((x > 248) & (y > 72) & (x < 288) & (y < 80)) ? 1 : 0;
wire ee2;
assign ee2 = ((x > 248) & (y > 80) & (x < 264) & (y < 88)) ? 1 : 0;
wire ee3;
assign ee3 = ((x > 248) & (y > 88) & (x < 280) & (y < 96)) ? 1 : 0;
wire ee4;
assign ee4 = ((x > 248) & (y > 96) & (x < 264) & (y < 104)) ? 1 : 0;
wire ee5;
assign ee5 = ((x > 248) & (y > 104) & (x < 264) & (y < 112)) ? 1 : 0;
wire ee6;
assign ee6 = ((x > 248) & (y > 112) & (x < 264) & (y < 120)) ? 1 : 0;
wire ee7;
assign ee7 = ((x > 248) & (y > 120) & (x < 288) & (y < 128)) ? 1 : 0;

// A
wire a1;
assign a1 = ((x > 304) & (y > 72) & (x < 320) & (y < 80)) ? 1 : 0;
wire a2;
assign a2 = ((x > 296) & (y > 80) & (x < 304) & (y < 128)) ? 1 : 0;
wire a3;
assign a3 = ((x > 304) & (y > 80) & (x < 320) & (y < 88)) ? 1 : 0;
wire a4;
assign a4 = ((x > 304) & (y > 104) & (x < 320) & (y < 112)) ? 1 : 0;
wire a5;
assign a5 = ((x > 320) & (y > 72) & (x < 328) & (y < 128)) ? 1 : 0;
wire a6;
assign a6 = ((x > 328) & (y > 80) & (x < 336) & (y < 128)) ? 1 : 0;

//T

wire t1;
assign t1 = ((x >344) & (y > 72) & (x < 392) & (y < 80)) ? 1 : 0;
wire t2;
assign t2 = ((x >360) & (y > 80) & (x < 376) & (y < 128)) ? 1 : 0;

//H

wire h1;
assign h1 = ((x >400) & (y > 72) & (x < 416) & (y < 128)) ? 1 : 0;
wire h2;
assign h2 = ((x > 416) & (y > 96) & (x < 440) & (y < 104)) ? 1 : 0;
wire h3;
assign h3 = ((x >440) & (y > 72) & (x < 456) & (y < 128)) ? 1 : 0;

//P

wire p1;
assign p1 = ((x > 60) & (y > 230) & (x < 90) & (y < 400)) ? 1 : 0;
wire p2;
assign p2 = ((x > 90) & (y > 230) & (x < 180) & (y < 260)) ? 1 : 0;
wire p3;
assign p3 = ((x > 90) & (y > 280) & (x < 180) & (y < 310)) ? 1 : 0;
wire p4;
assign p4 = ((x > 150) & (y > 260) & (x < 180) & (y < 280)) ? 1 : 0;

//O

wire o1;
assign o1 = ((x > 200) & (y > 230) & (x < 230) & (y < 400)) ? 1 : 0;
wire o2;
assign o2 = ((x > 230) & (y > 230) & (x < 290) & (y < 260)) ? 1 : 0;
wire o3;
assign o3 = ((x > 290) & (y > 230) & (x < 320) & (y < 400)) ? 1 : 0;
wire o4;
assign o4 = ((x > 230) & (y > 370) & (x < 290) & (y < 400)) ? 1 : 0;

//N

wire nn1;
assign nn1 = ((x > 340) & (y > 230) & (x < 370) & (y < 400)) ? 1 : 0;
wire nn2;
assign nn2 = ((x > 370) & (y > 265) & (x < 385) & (y < 320)) ? 1 : 0;
wire nn3;
assign nn3 = ((x > 385) & (y > 285) & (x < 400) & (y < 350)) ? 1 : 0;
wire nn4;
assign nn4 = ((x > 400) & (y > 230) & (x < 430) & (y < 400)) ? 1 : 0;

//G

wire g1;
assign g1 = ((x > 450) & (y > 230) & (x < 480) & (y < 400)) ? 1 : 0;
wire g2;
assign g2 = ((x > 480) & (y > 230) & (x < 570) & (y < 260)) ? 1 : 0;
wire g3;
assign g3 = ((x > 480) & (y > 370) & (x < 570) & (y < 400)) ? 1 : 0;
wire g4;
assign g4 = ((x > 540) & (y > 320) & (x < 570) & (y < 370)) ? 1 : 0;
wire g5;
assign g5 = ((x > 510) & (y > 290) & (x < 570) & (y < 320)) ? 1 : 0;
assign boundaryBoxTop = ((x > 0) & (y >  0) & (x < 640) & (y < 10)) ? 1 : 0;
assign boundaryBoxLeft = ((x > 0) & (y > 0) & (x < 10) & (y < 480)) ? 1 : 0;
assign boundaryBoxRight = ((x > 630) & (y > 0) & (x < 640) & (y < 480)) ? 1 : 0;
assign boundaryBoxBottom = ((x > 0) & (y > 470) & (x < 640) & (y < 480)) ? 1 : 0;

//G of game
wire gg1;
assign gg1 = ((x > 24) & (y > 8) & (x < 56) & (y < 16)) ? 1 : 0;
wire gg2;
assign gg2 = ((x > 16) & (y > 16) & (x < 32) & (y < 24)) ? 1 : 0;
wire gg3;
assign gg3 = ((x > 8) & (y > 24) & (x < 24) & (y < 32)) ? 1 : 0;
wire gg4;
assign gg4 = ((x > 8) & (y > 32) & (x < 24) & (y < 40)) ? 1 : 0;
wire gg5;
assign gg5 = ((x > 8) & (y > 40) & (x < 24) & (y < 48)) ? 1 : 0;
wire gg6;
assign gg6 = ((x > 16) & (y > 48) & (x < 32) & (y < 56)) ? 1 : 0;
wire gg7;
assign gg7 = ((x > 24) & (y > 56) & (x < 64) & (y < 64)) ? 1 : 0;
wire gg8;
assign gg8 = ((x > 48) & (y > 48) & (x < 64) & (y < 56)) ? 1 : 0;
wire gg9;
assign gg9 = ((x > 48) & (y > 40) & (x < 64) & (y < 48)) ? 1 : 0;
wire gg10;
assign gg10 = ((x > 40) & (y > 32) & (x < 64) & (y < 40)) ? 1 : 0;


//A of game
wire aa1;
assign aa1 = ((x > 80) & (y > 8) & (x < 96) & (y < 16)) ? 1 : 0;
wire aa2;
assign aa2 = ((x > 72) & (y > 16) & (x < 80) & (y < 64)) ? 1 : 0;
wire aa3;
assign aa3 = ((x > 80) & (y > 16) & (x < 96) & (y < 24)) ? 1 : 0;
wire aa4;
assign aa4 = ((x > 80) & (y > 40) & (x < 96) & (y < 48)) ? 1 : 0;
wire aa5;
assign aa5 = ((x > 96) & (y > 8) & (x < 104) & (y < 64)) ? 1 : 0;
wire aa6;
assign aa6 = ((x > 104) & (y > 16) & (x < 112) & (y < 64)) ? 1 : 0;

// M
wire m1;
assign m1 = ((x > 120) & (y > 8) & (x < 128) & (y < 60)) ? 1 : 0;
wire m2;
assign m2 = ((x > 128) & (y > 16) & (x < 136) & (y < 32)) ? 1 : 0;
wire m3;
assign m3 = ((x > 136) & (y > 24) & (x < 144) & (y < 40)) ? 1 : 0;
wire m4;
assign m4 = ((x > 144) & (y > 16) & (x < 152) & (y < 32)) ? 1 : 0;
wire m5;
assign m5 = ((x > 152) & (y > 8) & (x < 160) & (y < 60)) ? 1 : 0;
wire m6;
assign m6 = ((x > 160) & (y > 8) & (x < 168) & (y < 60)) ? 1 : 0;


// E of game
wire eee1;
assign eee1 = ((x > 176) & (y > 8) & (x < 216) & (y < 16)) ? 1 : 0;
wire eee2;
assign eee2 = ((x > 176) & (y > 16) & (x < 192) & (y < 24)) ? 1 : 0;
wire eee3;
assign eee3 = ((x > 176) & (y > 24) & (x < 208) & (y < 32)) ? 1 : 0;
wire eee4;
assign eee4 = ((x > 176) & (y > 32) & (x < 192) & (y < 40)) ? 1 : 0;
wire eee5;
assign eee5 = ((x > 176) & (y > 40) & (x < 192) & (y < 48)) ? 1 : 0;
wire eee6;
assign eee6 = ((x > 176) & (y > 48) & (x < 192) & (y < 56)) ? 1 : 0;
wire eee7;
assign eee7 = ((x > 176) & (y > 56) & (x < 216) & (y < 64)) ? 1 : 0;

//O 
wire oo1;
assign oo1 = ((x > 256) & (y > 8) & (x < 288) & (y < 16)) ? 1 : 0;
wire oo2; 
assign oo2 = ((x > 248) & (y > 16) & (x < 264) & (y < 24)) ? 1 : 0;
wire oo3; 
assign oo3 = ((x > 280) & (y > 16) & (x < 296) & (y < 24)) ? 1 : 0;
wire oo4;
assign oo4 = ((x > 240) & (y > 24) & (x < 256) & (y < 32)) ? 1 : 0;
wire oo5;
assign oo5 = ((x > 288) & (y > 24) & (x < 304) & (y < 32)) ? 1 : 0;
wire oo6;
assign oo6 = ((x > 240) & (y > 32) & (x < 256) & (y < 40)) ? 1 : 0;
wire oo7;
assign oo7 = ((x > 288) & (y > 32) & (x < 304) & (y < 40)) ? 1 : 0;
wire oo8;
assign oo8 = ((x > 240) & (y > 40) & (x < 256) & (y < 48)) ? 1 : 0;
wire oo9;
assign oo9 = ((x > 288) & (y > 40) & (x < 304) & (y < 48)) ? 1 : 0;
wire oo10; 
assign oo10 = ((x > 248) & (y > 48) & (x < 264) & (y < 56)) ? 1 : 0;
wire oo11; 
assign oo11 = ((x > 280) & (y > 48) & (x < 296) & (y < 56)) ? 1 : 0;
wire oo12;
assign oo12 = ((x > 256) & (y > 56) & (x < 288) & (y < 64)) ? 1 : 0;


// V
wire v1;
assign v1 = ((x > 312) & (y > 8) & (x < 320) & (y < 24)) ? 1 : 0;
wire v2;
assign v2 = ((x > 320) & (y > 8) & (x < 328) & (y < 48)) ? 1 : 0;
wire v3;
assign v3 = ((x > 328) & (y > 24) & (x < 336) & (y < 72)) ? 1 : 0;
wire v4;
assign v4 = ((x > 336) & (y > 56) & (x < 344) & (y < 72)) ? 1 : 0;
wire v5;
assign v5 = ((x > 344) & (y > 40) & (x < 352) & (y < 72)) ? 1 : 0;
wire v6;
assign v6 = ((x > 352) & (y > 8) & (x < 360) & (y < 40)) ? 1 : 0;
wire v7;
assign v7 = ((x > 360) & (y > 8) & (x < 368) & (y < 24)) ? 1 : 0;

// E of over
wire eeee1;
assign eeee1 = ((x > 376) & (y > 8) & (x < 416) & (y < 16)) ? 1 : 0;
wire eeee2;
assign eeee2 = ((x > 376) & (y > 16) & (x < 392) & (y < 24)) ? 1 : 0;
wire eeee3;
assign eeee3 = ((x > 376) & (y > 24) & (x < 408) & (y < 32)) ? 1 : 0;
wire eeee4;
assign eeee4 = ((x > 376) & (y > 32) & (x < 392) & (y < 40)) ? 1 : 0;
wire eeee5;
assign eeee5 = ((x > 376) & (y > 40) & (x < 392) & (y < 48)) ? 1 : 0;
wire eeee6;
assign eeee6 = ((x > 376) & (y > 48) & (x < 392) & (y < 56)) ? 1 : 0;
wire eeee7;
assign eeee7 = ((x > 376) & (y > 56) & (x < 416) & (y < 64)) ? 1 : 0;

//R
wire r1;
assign r1 = ((x > 424) & (y > 8) & (x < 432) & (y < 64)) ? 1 : 0;
wire r2;
assign r2 = ((x > 432) & (y > 8) & (x < 440) & (y < 64)) ? 1 : 0;
wire r3;
assign r3 = ((x > 440) & (y > 8) & (x < 464) & (y < 16)) ? 1 : 0;
wire r4;
assign r4 = ((x > 456) & (y > 16) & (x < 472) & (y < 24)) ? 1 : 0;
wire r5;
assign r5 = ((x > 456) & (y > 24) & (x < 472) & (y < 32)) ? 1 : 0;
wire r6;
assign r6 = ((x > 440) & (y > 32) & (x < 464) & (y < 40)) ? 1 : 0;
wire r7;
assign r7 = ((x > 432) & (y > 40) & (x < 456) & (y < 48)) ? 1 : 0;
wire r8;
assign r8 = ((x > 456) & (y > 48) & (x < 472) & (y < 56)) ? 1 : 0;
wire r9;
assign r9 = ((x > 456) & (y > 56) & (x < 480) & (y < 64)) ? 1 : 0;




assign collisionPR = ballMovement && PR;
assign collisionPL = ballMovement && PL;
assign collisionTop = ballMovement && boundaryBoxTop;
assign collisionBottom = ballMovement && boundaryBoxBottom;
assign collisionLeft = ballMovement && boundaryBoxLeft;
assign collisionRight = ballMovement && boundaryBoxRight;
assign collisionPlayerRlow = PR && boundaryBoxBottom;
assign collisionPlayerRhigh = PR && boundaryBoxTop;
assign collisionPlayerLlow = PL && boundaryBoxBottom;
assign collisionPlayerLhigh = PL && boundaryBoxTop;

assign ballMovement = ((x > ballx1 + ballwidth) && (y > bally1 + ballheight) && (x < ballx2 + ballwidth) && (y < bally2 + ballheight)) ? 1 : 0;

//assign launchAngle = 6d'45;

reg [1:0]s;  // states
reg [1:0]NS;

reg [2:0]s1;  // states
reg [2:0]NS1;

parameter 
			leftdown = 3'd0,
			leftup = 3'd1,
			rightdown = 3'd2,
			rightup = 3'd3,
			staystill = 3'd4,
			gameover2 = 3'd5;

parameter 
			start = 2'b00,
			play = 2'b01,
			gameover = 2'b10;

assign yheight = 100;
assign ballwidth = 20;
assign ballheight = 20;



assign PL = ((x > 0) & (y >  PLy1 + yheight) & (x < 20) & (y < PLy2 + yheight)) ? 1 : 0;
assign PR = ((x > 620) & (y >  PRy1 + yheight) & (x < 640) & (y < PRy2 + yheight)) ? 1 : 0;
//////////////////////////////////////////////////////////////////////////////////////////////////
// if key[3] PL goes up... key[2] PR goes down

always@(posedge CLK or negedge RST_BTN)
if(RST_BTN == 1'b0)
	s <= start;
else	
	s <= NS;
	
always@(posedge CLK or negedge RST_BTN)
if(RST_BTN == 1'b0)
	s1 <= staystill;
else	
	s1 <= NS1;
	
always@(posedge CLK)
	begin
	if(count == 20'd115000)
		count <= 0;
	else
		count <= count + 1;
	end
	
always@(posedge CLK)
	begin
	if(countball == 20'd1250000)
		countball <= 0;
	else
		countball <= countball + 1;
	end

always@(posedge CLK)
case(s1)
	staystill:
		if(startsig == 1'b1)
			NS1 <= rightdown;
		else	
			NS1 <= staystill;
		
	rightdown:
		if(collisionBottom == 1'b1)
			NS1 <= rightup;
		else if(collisionPR == 1'b1)
			NS1 <= leftdown;
		else if(collisionRight == 1'b1)
			NS1 <= gameover2;
			
	rightup:
		if(collisionTop == 1'b1)
			NS1 <= rightdown;
		else if(collisionPR == 1'b1)
			NS1 <= leftup;
		else if(collisionRight == 1'b1)
			NS1 <= gameover2;
			
	leftup:
		if(collisionTop == 1'b1)
			NS1 <= leftdown;
		else if(collisionPL == 1'b1)
			NS1 <= rightup;
		else if(collisionLeft == 1'b1)
			NS1 <= gameover2;
			
	leftdown:
		if(collisionBottom == 1'b1)
			NS1 <= leftup;
		else if(collisionPL == 1'b1)
			NS1 <= rightdown;
		else if(collisionLeft == 1'b1)
			NS1 <= gameover2;
			
	gameover2:
		NS1 <= gameover2;
endcase

always@(posedge CLK)
case(s)
	start:
		if(startsig == 1'b1)
			NS <= play;
		else	
			NS <= start;
			
	play:
		if(gameoversig == 1'b1)
			NS <= gameover;
		else
			NS <= play;
			
	gameover:
			NS <= gameover;
				
endcase

always@(posedge CLK) // player on left movement 
case(s)
	start:
		begin
		PLy1 <= 190;
		PLy2 <= 290;
		end
		
	play:
	if(count == 20'd1150000)
	begin
		if(key3 == 1'b0)
			begin
			if(collisionPlayerLlow == 1'b1 || collisionPlayerLhigh == 1'b1)
				begin
				PLy1 <= PLy1;
				PLy2 <= PLy2;
				end
			else	
				PLy1 <= PLy1 + 1;
				PLy2 <= PLy2 + 1; //left player up
			end
		else if (key2 == 1'b0)
			begin
			if(collisionPlayerLlow == 1'b1 || collisionPlayerLhigh == 1'b1)
				begin
				PLy1 <= PLy1;
				PLy2 <= PLy2;
				end
			else	
				PLy1 <= PLy1 - 1; //left player down
				PLy2 <= PLy2 - 1;
			end
		else
			begin	
			PLy1 <= PLy1;  //stay
			PLy2 <= PLy2;
			end
		end	
endcase 
	 
always@(posedge CLK) //player on the right movement
case(s)
	start:
		begin
		PRy1 <= 360;
		PRy2 <= 460;
		end
		
	play:
	if(count == 20'd1150000)
	begin
		if (key1 == 1'b0)
			begin
			if(collisionPlayerRlow == 1'b1 || collisionPlayerRhigh == 1'b1)
				begin
				PRy1 <= PRy1;
				PRy2 <= PRy2;
				end
			else
				PRy1 <= PRy1 + 1; //right player up
				PRy2 <= PRy2 + 1;
			end
		else if (key0 == 1'b0)
			begin
			if(collisionPlayerRlow == 1'b1 || collisionPlayerRhigh == 1'b1)
				begin
				PRy1 <= PRy1;
				PRy2 <= PRy2;
				end
			else	
				PRy1 <= PRy1 - 1; //right player down
				PRy2 <= PRy2 - 1;
			end
		else
			begin	
			PRy1 <= PRy1;  //stay
			PRy2 <= PRy2;
			end
		end
endcase 

always@(posedge CLK) //ball movement
case(s1)
		leftdown:
		if(countball == 20'd1250000)
			begin
			ballx1 <= ballx1 - 1;
			ballx2 <= ballx2 - 1;
			bally1 <= bally1 + 1;
			bally2 <= bally2 + 1;
			end
		else	
			begin
			ballx1 <= ballx1;
			ballx2 <= ballx2;
			bally1 <= bally1;
			bally2 <= bally2;
			end
			
		leftup:
		if(countball == 20'd1250000)
			begin
			ballx1 <= ballx1 - 1;
			ballx2 <= ballx2 - 1;
			bally1 <= bally1 - 1;
			bally2 <= bally2 - 1;
			end
		else	
			begin
			ballx1 <= ballx1;
			ballx2 <= ballx2;
			bally1 <= bally1;
			bally2 <= bally2;
			end
			
		rightdown:
		if(countball == 20'd1250000)
			begin
			ballx1 <= ballx1 + 1;
			ballx2 <= ballx2 + 1;
			bally1 <= bally1 + 1;
			bally2 <= bally2 + 1;
			end
		else	
			begin
			ballx1 <= ballx1;
			ballx2 <= ballx2;
			bally1 <= bally1;
			bally2 <= bally2;
			end
			
		rightup:
		if(countball == 20'd1250000)
			begin
			ballx1 <= ballx1 + 1;
			ballx2 <= ballx2 + 1;
			bally1 <= bally1 - 1;
			bally2 <= bally2 - 1;
			end
		else	
			begin
			ballx1 <= ballx1;
			ballx2 <= ballx2;
			bally1 <= bally1;
			bally2 <= bally2;
			end
			
		staystill:	
			begin
			ballx1 <= 310;
			ballx2 <= 330;
			bally1 <= 230;
			bally2 <= 250;
			gameoversig <= 1'b0;
			end
		
		gameover2:	
			begin
			ballx1 <= ballx1;
			ballx2 <= ballx2;
			bally1 <= bally1;
			bally2 <= bally2;
			gameoversig <= 1'b1;
			end
endcase 


always@(posedge CLK) // VGA state 
case(s)
	start:
	begin
		VGA_R[3] <= red_bg | s1_ | s2 | s3 | s4 | s5 | s6 | s7 | u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 | u9 | d1 | d2 | d2p2 | d3 | d3p2 | d4 | d4p2 | d5 | d5p2 | d6 | d6p2 | d7 | dD1 | dD2 | dD2p2 | dD3 | dD3p2 | dD4 | dD4p2 | dD5 | dD5p2 | dD6 | dD6p2 | dD7 | e1 | e2 | e3 | e4 | e5 | e6 | e7 | n1 | n2 | n3 | n4 | n5 | dDD1 | dDD2 | dDD2p2 | dDD3 | dDD3p2 | dDD4 | dDD4p2 | dDD5 | dDD5p2 | dDD6 | dDD6p2 | dDD7 | ee1 | ee2 | ee3 | ee4 | ee5 | ee6 | ee7 | a1 | a2 | a3 | a4 | a5 | a6 | t1 | t2 | h1 | h2 | h3 | p1 | p2 | p3 | p4 | o1 | o2 | o3 | o4 | nn1 | nn2 | nn3 | nn4 | g1 | g2 | g3 | g4 | g5;    
		VGA_G[3] <= s1_ | s2 | s3 | s4 | s5 | s6 | s7 | u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 | u9 | d1 | d2 | d2p2 | d3 | d3p2 | d4 | d4p2 | d5 | d5p2 | d6 | d6p2 | d7 | dD1 | dD2 | dD2p2 | dD3 | dD3p2 | dD4 | dD4p2 | dD5 | dD5p2 | dD6 | dD6p2 | dD7 | e1 | e2 | e3 | e4 | e5 | e6 | e7 | n1 | n2 | n3 | n4 | n5 | dDD1 | dDD2 | dDD2p2 | dDD3 | dDD3p2 | dDD4 | dDD4p2 | dDD5 | dDD5p2 | dDD6 | dDD6p2 | dDD7 | ee1 | ee2 | ee3 | ee4 | ee5 | ee6 | ee7 | a1 | a2 | a3 | a4 | a5 | a6 | t1 | t2 | h1 | h2 | h3 | p1 | p2 | p3 | p4 | o1 | o2 | o3 | o4 | nn1 | nn2 | nn3 | nn4 | g1 | g2 | g3 | g4 | g5;
		VGA_B[3] <= s1_ | s2 | s3 | s4 | s5 | s6 | s7 | u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 | u9 | d1 | d2 | d2p2 | d3 | d3p2 | d4 | d4p2 | d5 | d5p2 | d6 | d6p2 | d7 | dD1 | dD2 | dD2p2 | dD3 | dD3p2 | dD4 | dD4p2 | dD5 | dD5p2 | dD6 | dD6p2 | dD7 | e1 | e2 | e3 | e4 | e5 | e6 | e7 | n1 | n2 | n3 | n4 | n5 | dDD1 | dDD2 | dDD2p2 | dDD3 | dDD3p2 | dDD4 | dDD4p2 | dDD5 | dDD5p2 | dDD6 | dDD6p2 | dDD7 | ee1 | ee2 | ee3 | ee4 | ee5 | ee6 | ee7 | a1 | a2 | a3 | a4 | a5 | a6 | t1 | t2 | h1 | h2 | h3 | p1 | p2 | p3 | p4 | o1 | o2 | o3 | o4 | nn1 | nn2 | nn3 | nn4 | g1 | g2 | g3 | g4 | g5;
	end
	 
		
	play:
	begin
		VGA_R[3] <= PR | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop;         
		VGA_G[3] <= PL | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop;  
		VGA_B[3] <= ballMovement | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop; 
	end

	gameover:
	begin
		VGA_R[3] <= gg1 | gg2 | gg3 | gg4 | gg5 | gg6 | gg7 | gg8 | gg9 | gg10 | aa1 | aa2 | aa3 | aa4 | aa5 | aa6 | m1 | m2 | m3 | m4 | m5 | m6 | eee1 | eee2 | eee3 | eee4 | eee5 | eee6 | eee7 | oo1 | oo2 | oo3 | oo4 | oo5 | oo6 | oo7 | oo8 | oo9 | oo10 | oo11 | oo12 | v1 | v2 | v3 | v4 | v5 | v6 | v7 | eeee1 | eeee2 | eeee3 | eeee4 | eeee5 | eeee6 | eeee7 | r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9;
		VGA_G[3] <= gg1 | gg2 | gg3 | gg4 | gg5 | gg6 | gg7 | gg8 | gg9 | gg10 | aa1 | aa2 | aa3 | aa4 | aa5 | aa6 | m1 | m2 | m3 | m4 | m5 | m6 | eee1 | eee2 | eee3 | eee4 | eee5 | eee6 | eee7 | oo1 | oo2 | oo3 | oo4 | oo5 | oo6 | oo7 | oo8 | oo9 | oo10 | oo11 | oo12 | v1 | v2 | v3 | v4 | v5 | v6 | v7 | eeee1 | eeee2 | eeee3 | eeee4 | eeee5 | eeee6 | eeee7 | r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9;
		VGA_B[3] <= gg1 | gg2 | gg3 | gg4 | gg5 | gg6 | gg7 | gg8 | gg9 | gg10 | aa1 | aa2 | aa3 | aa4 | aa5 | aa6 | m1 | m2 | m3 | m4 | m5 | m6 | eee1 | eee2 | eee3 | eee4 | eee5 | eee6 | eee7 | oo1 | oo2 | oo3 | oo4 | oo5 | oo6 | oo7 | oo8 | oo9 | oo10 | oo11 | oo12 | v1 | v2 | v3 | v4 | v5 | v6 | v7 | eeee1 | eeee2 | eeee3 | eeee4 | eeee5 | eeee6 | eeee7 | r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9;
	end
		
	
	
endcase 
	 
	 ////////////////////////////////////////////////////////////////////////////////////////////////////
    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    // wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

	 
    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h8000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );

   /* // Four overlapping squares
    wire sq_a, sq_b, sq_c, sq_d, sq_e;
    assign sq_a = ((x > 0) & (y >  0) & (x < 20) & (y < 100)) ? 1 : 0;
    assign sq_b = ((x > 620) & (y > 120) & (x < 640) & (y < 220)) ? 1 : 0;*/
    /*assign sq_c = ((x > 330) & (y > 200) & (x < 360) & (y < 230)) ? 1 : 0;*/
    
	 
    //assign VGA_R[3] = PR | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop;         // right player
    //assign VGA_G[3] = PL | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop;  // left player 
    //assign VGA_B[3] = ballMovement | boundaryBoxBottom | boundaryBoxLeft | boundaryBoxRight | boundaryBoxTop;         // duh ball
	 
endmodule
 
 
 module vga640x480(
    input wire i_clk,           // base clock
    input wire i_pix_stb,       // pixel clock strobe
    input wire i_rst,           // reset: restarts frame
    output wire o_hs,           // horizontal sync
    output wire o_vs,           // vertical sync
    output wire o_blanking,     // high during blanking interval
    output wire o_active,       // high during active pixel drawing
    output wire o_screenend,    // high for one tick at the end of screen
    output wire o_animate,      // high for one tick at end of active drawing
    output wire [9:0] o_x,      // current pixel x position
    output wire [8:0] o_y       // current pixel y position
    );

    // VGA timings https://timetoexplore.net/blog/video-timings-vga-720p-1080p
    localparam HS_STA = 16;              // horizontal sync start
    localparam HS_END = 16 + 96;         // horizontal sync end
    localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
    localparam VS_STA = 480 + 10;        // vertical sync start
    localparam VS_END = 480 + 10 + 2;    // vertical sync end
    localparam VA_END = 480;             // vertical active pixel end
    localparam LINE   = 800;             // complete line (pixels)
    localparam SCREEN = 525;             // complete screen (lines)

    reg [9:0] h_count;  // line position
    reg [9:0] v_count;  // screen position

    // generate sync signals (active low for 640x480)
    assign o_hs = ~((h_count >= HS_STA) & (h_count < HS_END));
    assign o_vs = ~((v_count >= VS_STA) & (v_count < VS_END));

    // keep x and y bound within the active pixels
    assign o_x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
    assign o_y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

    // blanking: high within the blanking period
    assign o_blanking = ((h_count < HA_STA) | (v_count > VA_END - 1));

    // active: high during active pixel drawing
    assign o_active = ~((h_count < HA_STA) | (v_count > VA_END - 1)); 

    // screenend: high for one tick at the end of the screen
    assign o_screenend = ((v_count == SCREEN - 1) & (h_count == LINE));

    // animate: high for one tick at the end of the final active pixel line
    assign o_animate = ((v_count == VA_END - 1) & (h_count == LINE));

    always @ (posedge i_clk)
    begin
        if (i_rst)  // reset to start of frame
        begin
            h_count <= 0;
            v_count <= 0;
        end
        if (i_pix_stb)  // once per pixel
        begin
            if (h_count == LINE)  // end of line
            begin
                h_count <= 0;
                v_count <= v_count + 1;
            end
            else 
                h_count <= h_count + 1;

            if (v_count == SCREEN)  // end of screen
                v_count <= 0;
        end
    end
endmodule