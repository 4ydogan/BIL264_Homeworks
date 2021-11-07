`timescale 1ns / 1ps

module carpici(input clk, reset, input [31:0] sayi1, sayi2, output reg [31:0] sonuc);
    
    reg[47:0] sum, carpim;
    reg[23:0] s1, s2;
    reg[4:0] basamak;
    reg [30:0] sifir, sonsuz;

    // baslangic ve reset aninda calisir
    always@(sayi1 or sayi2 or reset) begin      
        sifir  = 31'b0000000000000000000000000000000;   // sifir degiskeni
        sonsuz = 31'b1111111100000000000000000000000;   // sonsuz degiskeni
        s1 = {1'b1, sayi1[0 +:23]};                     // sayi1 value kismi
        s2 = {1'b1, sayi2[0 +:23]};                     // sayi2 value kismi

        sonuc[31] = sayi1[31] ^ sayi2[31];              // sonuc isaret biti    
        basamak = 23;                                   // carpilan basamak
        carpim = (s1*(s2[basamak])) << basamak;         // carpim
        sum = carpim;                                   // sum ilk deger atamasi
    end
    
    // clk posedge aninda calisir 
    always@(posedge clk) begin

        if( sayi1[30:23] == sonsuz[30:23] && sayi1[22:0] != sonsuz[22:0]) begin             // NaN
            sonuc = 32'b01111111110000000000000000000000;
        end else if( sayi2[30:23] == sonsuz[30:23] && sayi2[22:0] != sonsuz[22:0]) begin    // NaN
            sonuc = 32'b01111111110000000000000000000000;
        end else if(sayi1[30:0] == sifir && sayi2[30:0] != sonsuz) begin                    // sifir * !sonsuz
            sonuc[30:0] = sifir;
        end else if(sayi2[30:0] == sifir && sayi1[30:0] != sonsuz) begin                    // !sonsuz * sifir
            sonuc[30:0] = sifir;
        end else if(sayi1[30:0] != sifir && sayi2[30:0] == sonsuz) begin                    // !sifir * sonsuz
            sonuc[30:0] = sonsuz;
        end else if(sayi2[30:0] != sifir && sayi1[30:0] == sonsuz) begin                    // sonsuz * !sifir
            sonuc[30:0] = sonsuz;
        end else if(sayi2[30:0] == sifir && sayi1[30:0] == sonsuz) begin                    // sonsuz * sifir
            sonuc = 32'b01111111110000000000000000000000;
        end else if(sayi2[30:0] == sifir && sayi1[30:0] == sonsuz) begin                    // sifir * sonsuz
            sonuc = 32'b01111111110000000000000000000000;
        end else if(sum[47:46] == 0) begin                                                  // virgulden once basamak 0 
            sonuc[0 +:23] = sum[45 -:23];
            sonuc[30 -:8] = sayi1[30 -:8] + sayi2[30 -:8] -127;                                 
        end else if(sum[47:46] == 1)begin                                                   // virgulden once basamak 1
            sonuc[0 +:23] = sum[45 -:23];
            sonuc[30 -:8] = sayi1[30 -:8] + sayi2[30 -:8] -127;
        end else if(sum[47:46] == 2)begin                                                   // virgulden once basamak 2
            sonuc[0 +:23] = sum[46 -:23];
            sonuc[30 -:8] = sayi1[30 -:8] + sayi2[30 -:8] -126;
        end else if(sum[47:46] == 3)begin                                                   // virgulden once basamak 2
            sonuc[0 +:23] = sum[46 -:23];
            sonuc[30 -:8] = sayi1[30 -:8] + sayi2[30 -:8] -126;
        end
        
        if(reset) begin     // reset
            sonuc = 0;
            carpim = 0;
            sum = 0;
            s1 = 0;
            s2 = 0;
            basamak = 23;
        end
        if(basamak >= 0) begin    
            basamak = basamak - 1;                          // sonraki cevirim icin gerekli
            carpim = (s1*(s2[basamak])) << basamak;         // sonraki cevirim icin gerekli
            sum = sum + carpim;                             // sonraki cevirim icin gerekli
        end
    end
endmodule
