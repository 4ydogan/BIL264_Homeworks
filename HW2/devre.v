`timescale 1ns / 1ps


module devre(
    input A, B, C,
    output F
    );
    
    wire AandB, Cand1;
    wire w1, nA;
    
    not (nA, A);
    or (w1, A, nA);
    
    and (AandB, A, B);
    and (Cand1, C, w1);
    
    wire RnandG, AxorR, BnorG;
    
    xor (AxorR, A, AandB);
    nand (RnandG, AandB, Cand1);
    nor (BnorG, RnandG, Cand1);
    
    or (F, AxorR, BnorG);
    
endmodule
