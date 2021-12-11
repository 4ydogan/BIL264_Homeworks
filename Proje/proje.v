`timescale 1ns / 1ps

module proje(
        input clk,
        input rst,
        input [78:0] buyruk,
        output [31:0] cikis,
        output cikis_gecerli
    );
    
    // bellek ve cikis icin gerekli yazmaclar olusturulur 
    reg [31:0]sonuc_bellegi[8191:0];
    reg [31:0] cikis_reg = 0;
    reg cikis_gecerli_mi_reg = 0;
    
    // islem icin gerekli kablolar olusturulur
    wire [31:0] sayi1, sayi2, sonuc;
    wire [1:0] islem_turu;
    wire [12:0] adres_temp, adres;
    wire buyruk_bitti, islem_bitti, yaz_bitti;
    
    // outputlar icin assign islemleri
    assign cikis = cikis_reg;
    assign cikis_gecerli = cikis_gecerli_mi_reg;
    
    // gelen buyrugu ayirmak icin olusturulan modul
    buyruk_ayir ayirma_modulu(clk, rst, buyruk, adres_temp, sayi1, sayi2, islem_turu, buyruk_bitti);
    
    // buyruk ayirma modulunden gelen sayi1, sayi2 ve islem turu ile gerekli islem yapilir
    islem islem_modulu(clk, rst, buyruk_bitti, sayi1, sayi2, islem_turu, adres_temp, sonuc, adres, islem_bitti);
    
    // islemler bitince bellegin belirtilen adresine yazma islemi tamamlanýr
    // cikis_reg'e atamalar yapilir
    always@(posedge islem_bitti) begin
        sonuc_bellegi[adres] = sonuc;
        cikis_reg = sonuc;
        cikis_gecerli_mi_reg = 1;
    end
    
endmodule
