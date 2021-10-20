`timescale 1ns / 1ps


module seviye(
    input [3:0] dugum,
    output [2:0] dugumun_seviyesi
    );
    
    wire [3:0] not_dugum;
    
    not (not_dugum[3], dugum[3]); //A
    not (not_dugum[2], dugum[2]); //B
    not (not_dugum[1], dugum[1]); //C
    not (not_dugum[0], dugum[0]); //D
        
    // dugumun_seviyesi[2] 
    and (dugumun_seviyesi[2], dugum[3], dugum[2], dugum[1]);
    
    // dugumun_seviyesi[1] 
    wire nAB, BnC, AnB, nACD;
    
    and (nAB, not_dugum[3], dugum[2]); 
    and (BnC, dugum[2], not_dugum[1]); 
    and (AnB, dugum[3], not_dugum[2]); 
    and (nACD, not_dugum[3], dugum[1], dugum[0]); 
   
    or (dugumun_seviyesi[1], nAB, BnC, AnB, nACD);
    
    // dugumun_seviyesi[0] 
    wire AnC, nBnCD, nBCnD, nABCD;
    
    and (AnC, dugum[3], not_dugum[1]);
    and (nBnCD, not_dugum[2], not_dugum[1], dugum[0]);
    and (nBCnD, not_dugum[2], dugum[1], not_dugum[0]);
    and (nABCD, not_dugum[3], dugum[2], dugum[1], dugum[0]);
    
    or (dugumun_seviyesi[0], AnB, AnC, nBnCD, nBCnD, nABCD);
    
endmodule
