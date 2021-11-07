`timescale 1ns / 1ps

module tb_carpici();
    reg clk, reset;
    reg [31:0] sayi1, sayi2;
    wire [31:0] sonuc;
    
    carpici uut(clk, reset, sayi1, sayi2, sonuc);

    initial begin
        /*clk = 0;
        reset = 0;
        sayi1 = 32'b10111110100110011001100110011010;
        sayi2 = 32'b01000011111110100010000000000000;
        
        #350;
        
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b01000001011101010101010101011111;
        sayi2 = 32'b01000001001010101010101010101010;
        
         #350;
         
         
         clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b01111111110000000000000000000000;
        sayi2 = 32'b01000001001010101010101010101010;
         #350;*/
        
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b01000001011101010101010101011111;
        sayi2 = 32'b01111111110000000000000000000000;
         #350;
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b11111111100000000000000000000000;
        sayi2 = 32'b01000001001010101010101010101010;
         #350;
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b01111111110000000000000000000000;
        sayi2 = 32'b11000001001010101010101010101010;
         #350;
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        sayi1 = 32'b01111111100000000000000000000000;
        sayi2 = 32'b00000000000000000000000000000000;
         #350;
        
    end
    
    always begin
        clk = ~clk;
        #5;
    end
        
endmodule
