`timescale 1ns / 1ps


module buyruk_ayir(
        input clk,
        input rst,
        input [78:0] buyruk,
        output [12:0] adres,
        output [31:0] sayi1,
        output [31:0] sayi2,
        output [1:0] islem_turu,
        output buyruk_bitti
    );
    
    // cevrim ve cevrim_sonraki icin yazmaclar
    reg [31:0] cevrim = 0, cevrim_sonraki = 1;
    
    // tum islemler icin gerekli yazmaclar
    reg [12:0] adres_reg = 0;
    reg [31:0] sayi1_reg = 0;
    reg [31:0] sayi2_reg = 0;
    reg [1:0]  islem_turu_reg = 0;
    reg buyruk_bitti_mi = 0;
    
    // outputlar icin assign islemleri
    assign adres = adres_reg;
    assign sayi1 = sayi1_reg;
    assign sayi2 = sayi2_reg;
    assign islem_turu = islem_turu_reg;
    assign buyruk_bitti = buyruk_bitti_mi;
    
    always@(cevrim) begin
    
        // resetlemek icin
        if(rst) begin
            adres_reg = 0;     
            sayi1_reg = 0;     
            sayi2_reg = 0;     
            islem_turu_reg = 0;
        end
        
        // sonraki cevrim degerini olusturur
        cevrim_sonraki = cevrim + 1;        
        
        // buyruk ayirma islemi burada gerceklesir
        if(cevrim == 1) begin
            adres_reg = buyruk[12:0];    
            sayi1_reg = buyruk[76:45];    
            sayi2_reg = buyruk[44:13];    
            islem_turu_reg = buyruk[78:77];  
        end
        
        else if(cevrim == 24) begin
            buyruk_bitti_mi = 1;
        end       
        
        else if(cevrim == 25) begin
            cevrim_sonraki = 1;
            buyruk_bitti_mi = 0;
        end 
    end
    
    always@(posedge clk) begin
        if(rst) begin
            adres_reg <= 0;     
            sayi1_reg <= 0;     
            sayi2_reg <= 0;     
            islem_turu_reg <= 0;
            cevrim <= 1;
            cevrim_sonraki <= 1;
            buyruk_bitti_mi <= 0;
        end
        
        else cevrim <= cevrim_sonraki;
    end
    
endmodule
