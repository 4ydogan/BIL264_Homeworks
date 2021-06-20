`timescale 1ns / 1ps


module hiyerarsik_devre(
        input X, Y, Z, T,
        output M
    );
    
    wire w1;
    
    kapilar kapi(
        .A(X),
        .B(Y),
        .C(Z),
        .D(1'b0),
        .F(w1)
       );  
        
   xor(M, w1, 1'b1, T);
   
endmodule
