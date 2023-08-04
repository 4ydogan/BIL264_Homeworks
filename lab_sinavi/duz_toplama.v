`timescale 1ns / 1ps

// Engineer: Mustafa aydogan
// Number: 191101002

module duz_toplama #(parameter N=8)(
    input clk,
    input [N-1:0] sayi1,
    input [N-1:0] sayi2,
    input [N-1:0] sayi3,
    input [N-1:0] sayi4,
    input [N-1:0] sayi5,
    input [N-1:0] sayi6,
    input [N-1:0] sayi7,
    input [N-1:0] sayi8,
    input [N-1:0] sayi9,
    input [N-1:0] sayi10,
    input giris_etkin,
    output [N+3:0] sonuc,
    output sonuc_etkin
    );
    
    // yazmaclar
    reg [N+3:0] sum1 = 0;
    reg [N+3:0] sum2 = 0;
    reg [31:0]  cevrim;
    reg [31:0]  cevrim_sonraki = 1;
    reg [N+3:0] sonuc_reg;
    reg sonuc_etkin_reg;
    
    // output assign
    assign sonuc = sonuc_reg;
    assign sonuc_etkin = sonuc_etkin_reg;
    
    always@(cevrim) begin
        
        // giris etkin = mantik-1
        if(giris_etkin == 1'b1) begin
            
            // giris etkin mantik-1 olmasi durumunda islemler gerceklesir
            
            // sonraki cevrim
            cevrim_sonraki = cevrim + 1;
            
            // cevrim = 1
            if(cevrim == 1) begin
                sonuc_etkin_reg = 0;
                sonuc_reg = 0;
                sum1 = sayi1 + sayi2;
                sum2 = sayi6 + sayi7;
            end
            
            // cevrim = 2
            else if(cevrim == 2) begin
                sum1 = sum1 + sayi3;
                sum2 = sum2 + sayi8;
            end
            
            // cevrim = 3
            else if(cevrim == 3) begin
                sum1 = sum1 + sayi4;
                sum2 = sum2 + sayi9;
            end
            
            // cevrim = 4
            else if(cevrim == 4) begin
                sum1 = sum1 + sayi5;
                sum2 = sum2 + sayi10;
            end
            
            // cevrim = 5
            else if(cevrim == 5) begin
                sonuc_reg = sum1 + sum2;
                sonuc_etkin_reg = 1;
                cevrim_sonraki = 1;
            end
        end
    end
    
    // cevrim atmasi yapilir
    always@(posedge clk) begin
        cevrim <= cevrim_sonraki;
    end
    
endmodule
