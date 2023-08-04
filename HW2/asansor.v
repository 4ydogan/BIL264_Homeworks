`timescale 1ns / 1ps

module asansor(
    input [1:0] bulundugu_kat, buton,
    output [1:0] durdugu_kat   
    );
    
    wire [1:0] not_bulundugu_kat, not_buton;
    
    not (not_bulundugu_kat[1], bulundugu_kat[1]); //A
    not (not_bulundugu_kat[0], bulundugu_kat[0]); //B
    
    not (not_buton[0], buton[0]); //D
    not (not_buton[1], buton[1]); //C
    
    //durdugu_kat[1]
    wire nCD, BnC, AnC, ABD;
    
    and (nCD, not_buton[1], buton[0]);
    and (BnC, bulundugu_kat[0], not_buton[1]);
    and (AnC, bulundugu_kat[1], not_buton[1]);
    and (ABD, bulundugu_kat[1], bulundugu_kat[0], buton[0]);
    
    or (durdugu_kat[1], nCD, BnC, AnC, ABD);
    
    //durdugu_kat[0]
    wire ABnD, AnBD, nBnC;
    
    and (ABnD, bulundugu_kat[1], bulundugu_kat[0], not_buton[0]);
    and (AnBD, bulundugu_kat[1], not_bulundugu_kat[0], buton[0]);
    and (nBnC, not_bulundugu_kat[0], not_buton[1]);
  
    or (durdugu_kat[0], ABnD, AnBD, nBnC, nCD);
         
endmodule
