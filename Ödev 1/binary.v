`timescale 1ns / 1ps

module binary(
    input [3:0] kaynak_dugumu,
    input [1:0] yon,
    output [3:0] hedef_dugumu
    );
    
    wire [3:0] not_kaynak_dugumu;
    wire [1:0] not_yon;
    
    not (not_kaynak_dugumu[0], kaynak_dugumu[0]); //B
    not (not_kaynak_dugumu[1], kaynak_dugumu[1]); //A
    not (not_kaynak_dugumu[2], kaynak_dugumu[2]);
    not (not_kaynak_dugumu[3], kaynak_dugumu[3]); 
    
    not (not_yon[0],yon[0]);
    not (not_yon[1],yon[1]);
    
    // hedef_dugumu[0]
    wire nAandnD, nBandnD, AandC, AandBandD;
    
    and (nAandnD, not_kaynak_dugumu[1], not_yon[0]);
    and (nBandnD, not_kaynak_dugumu[0], not_yon[0]);
    and (AandC, kaynak_dugumu[1], yon[1]);
    and (AandBandD, kaynak_dugumu[1], kaynak_dugumu[0], yon[0]); 
   
    or (hedef_dugumu[0], nAandnD, nBandnD, AandC, AandBandD);
    
    // hedef_dugumu[1]
    wire nCandnD, AandB, nAandCandD;
    
    and (nCandnD, not_yon[1], not_yon[0]);
    and (AandB, kaynak_dugumu[1], kaynak_dugumu[0]);
    and (nAandCandD, not_kaynak_dugumu[1], yon[1], yon[0]);
    
    or (hedef_dugumu[1], nCandnD, AandB, nAandCandD);
    
    // hedef_dugumu[2]
    wire nBandD, nBandC, AandD, BandnCandnD;
    
    and (nBandD, not_kaynak_dugumu[0], yon[0]);
    and (nBandC, not_kaynak_dugumu[0], yon[1]);
    and (AandD, kaynak_dugumu[1], yon[0]);
    and (BandnCandnD, kaynak_dugumu[0], not_yon[1], not_yon[0]);
    
    or (hedef_dugumu[2], nBandD, nBandC, AandD, BandnCandnD);
    
    // hedef_dugumu[3]
    wire BandD, BandC;
    
    and (BandD, kaynak_dugumu[0], yon[0]);
    and (BandC, kaynak_dugumu[0], yon[1]);
    
    or (hedef_dugumu[3], kaynak_dugumu[1], BandD, BandC);
    
endmodule





