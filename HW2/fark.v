`timescale 1ns / 1ps


module fark(
   input [3:0] dugum_1,dugum_2,
   input [1:0] yon_1, yon_2,
   output [1:0] seviye_farki
   );
   
   wire [3:0] hedef_dugumu_1, hedef_dugumu_2; 
   wire [2:0] seviye_1, seviye_2;
   
   binary bnry1 (dugum_1, yon_1, hedef_dugumu_1);
   binary bnry2 (dugum_2, yon_2, hedef_dugumu_2);
    
   seviye sv1 (hedef_dugumu_1, seviye_1);
   seviye sv2 (hedef_dugumu_2, seviye_2);
   
   wire A, B, C, D;
   
   buf (A, seviye_1[2]);
   buf (B, seviye_1[0]);
   
   buf (C, seviye_2[2]);
   buf (D, seviye_2[0]);
   
   
   wire nA, nB, nC, nD;
   
   not (nA, A);
   not (nB, B);
   not (nC, C);
   not (nD, D);
   
   // seviye_farki[0]
   xor (seviye_farki[0], B, D);
   
   // seviye_farki[1]
   wire nAandnBandC, AandnCandnD;
   
   and (nAandnBandC, nA, nB, C);
   and (AandnCandnD, A, nC, nD);
   
   or (seviye_farki[1], nAandnBandC, AandnCandnD);
   
endmodule
