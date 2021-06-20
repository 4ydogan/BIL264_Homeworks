`timescale 1ns / 1ps

module ikibit_cikarici(
    input [1:0] a,
    input [1:0] b,
    output [1:0] c
    );
    
    wire nB1, nB0;
    wire and1, and2;
    
    not (nB1, b[1]);
    not (nB0, b[0]);
    
    xor (c[0], a[0], b[0]);
    and (and1, a[1], nB1, nB0);
    and (and2, a[1], a[0], nB1);
    or (c[1], and1, and2);
    
endmodule
