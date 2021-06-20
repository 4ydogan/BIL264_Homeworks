`timescale 1ns / 1ps

module kapilar(   
    input A, B, C, D,
    output F
    );
    
    wire red, w1, w2, w3;
    
    xor i1(red, A, B);
    nand i2(w1, red, C);
    or i3(w2, A, w1);
    not i4(w3, red);
    nor i5(F, D, w3, w2);
    
endmodule
