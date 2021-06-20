`timescale 1ns / 1ps

module hipotenus(
    input [1:0] a,
    input [1:0] b,
    output [2:0] c
    );
    
    wire nA0, nA1, nB0, nB1;
    wire a0andNB1, a0andB1, b1andNB0andNA0;
    wire b1andA1, nA0andNB0, a0andB0;
    wire comp2, comp3, a1andB1;
    wire a1xorB1;
    wire nA1andB0;
            
    not (nA0, a[0]);
    not (nA1, a[1]);
    not (nB0, b[0]);
    not (nB1, b[1]);
      
    and (a0andNB1, a[0], nB1);
    and (nA1andB0, nA1, b[0]);
    and (b1andA1, a[1], b[1]);
    and (nA0andNB0, nA0, nB0);
    and (comp2, b1andA1, nA0andNB0);
    or (c[0], a0andNB1, nA1andB0, comp2);
    
    xor (a1xorB1, a[1], b[1]);
    and (b1andNB0andNA0, b[1], nB0, nA0);
    or (c[1], a1xorB1, b1andNB0andNA0); 
    
    and (a1andB1, a[1], b[1]);
    or (a0andB0, a[0], b[0]);
    and (c[2], a1andB1, a0andB0);
    
endmodule