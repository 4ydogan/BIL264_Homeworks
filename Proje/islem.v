`timescale 1ns / 1ps

module islem(
        input clk,
        input rst,
        input enable,
        input [31:0] sayi1,
        input [31:0] sayi2,
        input [1:0] islem_turu,
        input [12:0] adres_temp,
        output [31:0] sonuc,
        output [12:0] adres,
        output islem_bitti
    );
    
    // kolaylik icin localparam tanimlandi.
    localparam toplama=2'b00;
    localparam carpma=2'b01;
    localparam cikarma=2'b10;
    localparam bolme=2'b11;
    
    // tum islemler icin gerekli yazmaclar
    reg [31:0] max = 0;
    reg [31:0] min = 0;
    reg [31:0] sonuc_reg = 0;
    reg islem_bitti_mi = 0;
    reg [1:0] islem_turu_reg;
    
    // exponentlar ve farki icin yazmaclar
    reg [7:0] max_exponent;
    reg [7:0] min_exponent;
    reg [7:0] fark_exponent;
    
    // cevrim ve cevrim_sonraki icin yazmaclar
    reg [31:0] cevrim = 0;
    reg [31:0] cevrim_sonraki = 1;
    
    // max ve min icin mantissalar
    reg [24:0] max_mantissa = 0;
    reg [24:0] min_mantissa = 0;
    
    // toplama icin
    reg [25:0] sum_mantissa = 0;
    
    // carpma icin
    reg [47:0] carpim_mantissa = 0;
    
    // cikarma icin
    reg [25:0] cikar_mantissa = 0;
    
    // bolme icin
    reg [47:0] bolum_mantissa = 0;
       
    // outputlar icin assign islemleri
    assign sonuc = sonuc_reg;
    assign adres = adres_temp;
    assign islem_bitti = islem_bitti_mi;
    
    always@(cevrim) begin
        
        // sonraki cevrim degeri olusturulur
        cevrim_sonraki = cevrim + 1;
        
        // son cevrimde max, min, max_mantissa, min_mantissa, max_exponent ve min_exponent atandi.
        // exponent farki hesaplanip fark_exponent yazmacina atandi
        if(cevrim == 24) begin
        
            // islem turu yazmaca yazilir
            islem_turu_reg = islem_turu;
        
            // sayi1 us degeri > sayi2 us degeri 
            if(sayi1[30:23] > sayi2[30:23])begin
                max = sayi1;
                min = sayi2;
            end
            
            // sayi1 us degeri = sayi2 us degeri
            else if(sayi1[30:23] == sayi2[30:23])begin
                max = (sayi1[22:0] > sayi2[22:0]) ? sayi1 : sayi2;
                min = (sayi1[22:0] > sayi2[22:0]) ? sayi2 : sayi1;
            end
                        
            // sayi1 us degeri < sayi2 us degeri 
            else begin
                max = sayi2;
                min = sayi1;
            end 
        
            max_mantissa = {1'b1, max[22:0]};
            min_mantissa = {1'b1, min[22:0]};
            
            max_exponent = max[30:23];
            min_exponent = min[30:23];
        
            // usler arasinda fark 
            fark_exponent = max_exponent - min_exponent;
            
            islem_bitti_mi = 1;
        end
        
        else if(cevrim == 25) begin
            cevrim_sonraki = 1;
            
            islem_bitti_mi = 0;
        end
    
        else begin
            // islem turune gore islem yapilir.
            case(islem_turu_reg)
                toplama : begin // Toplama
                    
                    // usler arasindaki fark kadar kaydirma islemi yapilir
                    min_mantissa = min_mantissa >> fark_exponent;
                    sonuc_reg[31] = max[31];
                    
                    // + + veya - - 
                    // bu durumda isaret biti degismez iki deger toplanir
                    if(max[31]~^min[31])begin 
                        
                        // usler esit oldugu icin mantissalar toplanabilir
                        sum_mantissa = max_mantissa + min_mantissa;
                        
                        // eger tasma varsa kaydirma yapilir, exponent'a 1 eklenir
                        if(sum_mantissa[24] == 1'b1) begin
                            sonuc_reg[30:23] = max_exponent + 1'b1;
                            sonuc_reg[22:0] = sum_mantissa[23:1];
                        end
                        
                        // tasma yoksa normal atama yapilir
                        else begin
                            sonuc_reg[30:23] = max_exponent; 
                            sonuc_reg[22:0] = sum_mantissa[22:0];
                        end
                    end
                    
                    // + - veya - +
                    // isaret biti buyuk olan degere gore belirlenir
                    // cikarma yapilir
                    else begin
                    
                        // usler esit oldugu icin cikarma yapilabilir
                        // ikiye tumleyeni alinip toplama yapilir
                        min_mantissa = ~min_mantissa + 1'b1;
                        sum_mantissa = max_mantissa + min_mantissa;
                        
                        // elde 1 ise oldugu gibi atama yapilir
                        if(sum_mantissa[25] == 1'b1) begin
                            sonuc_reg[30:23] = max_exponent;
                            sonuc_reg[22:0] = sum_mantissa[22:0];
                        end
                        
                        // elde 1 degilse ikilik tabanda gosterime gecilir
                        else begin
                            sonuc_reg[30:23] = max_exponent; 
                            sonuc_reg[22:0] = ~sum_mantissa[22:0] + 1;
                        end
                    end
                end
                
                carpma : begin // Carpma
                    
                    // isaret biti belirlenir
                    sonuc_reg[31] = max[31]^min[31];
                    
                    // mantissalar carpilir
                    carpim_mantissa = max_mantissa * min_mantissa;
                    sonuc_reg[22:0] = carpim_mantissa[46:24];
                    
                    // tasma varsa exponent'a 1 eklenir, kaydirma yapilir
                    if(carpim_mantissa[47] == 1'b1)begin
                        sonuc_reg[30:23] = max_exponent + min_exponent - 8'd126;
                        sonuc_reg[22:0] = carpim_mantissa[46:24];
                    end
                    
                    // tasma yoksa normal atama yapilir
                    else if(carpim_mantissa[46] == 1'b1) begin
                        sonuc_reg[30:23] = max_exponent + min_exponent - 8'd127;
                        sonuc_reg[22:0] = carpim_mantissa[45:23];
                    end
                end
                
                cikarma : begin // Cikarma
                    
                    // usler arasindaki fark kadar kaydirma islemi yapilir
                    min_mantissa = min_mantissa >> fark_exponent;
                    sonuc_reg[31] = max[31];
                    
                    // + + veya - -
                    // bu durumda isaret biti degismez cikarma yapilir
                    if( max[31]~^min[31]) begin
                    
                        if(cevrim == 1) begin
                            // usler esit oldugu icin cikarma yapilabilir
                            // ikiye tumleyeni alinip toplama yapilir
                            min_mantissa = ~min_mantissa + 1'b1;
                            cikar_mantissa = 0;
                            cikar_mantissa = cikar_mantissa + {1'b0, max_mantissa[23:0]};
                            cikar_mantissa = cikar_mantissa + {1'b1, min_mantissa[23:0]};
                            
                            // elde 1 ise oldugu gibi atama yapilir
                            if(cikar_mantissa[25] == 1'b1) begin
                                cikar_mantissa[25] = 1'b0 ;
                            end
                            
                            // elde 1 degilse ikilik tabanda gosterime gecilir
                            else begin
                                cikar_mantissa[22:0] = ~cikar_mantissa[22:0] + 1;
                            end
                        end
                        
                        else begin
                            if(cikar_mantissa[23] != 1'b1) begin
                                cikar_mantissa = cikar_mantissa << 1;
                                max_exponent = max_exponent - 1;
                            end
                        end
                        
                         sonuc_reg[30:23] = max_exponent;
                         sonuc_reg[22:0] = cikar_mantissa[22:0] ;
                        
                    end
          
                    // - + veya + -
                    // bu durumda isaret biti degismez toplama yapilir
                    else begin
                    
                        // usler esit oldugu icin mantissalar toplanir
                        cikar_mantissa = max_mantissa + min_mantissa;
                        
                        // eger tasma varsa kaydirma yapilir, exponent'a 1 eklenir
                        if(cikar_mantissa[24] == 1'b1) begin
                            sonuc_reg[30:23] = max_exponent + 1'b1;
                            sonuc_reg[22:0] = cikar_mantissa[23:1];
                        end
                        
                        // tasma yoksa normal atama yapilir
                        else begin
                            sonuc_reg[30:23] = max_exponent; 
                            sonuc_reg[22:0] = cikar_mantissa[22:0];
                        end
                    end
                end
                
                bolme : begin // Bolme
                    
                    if(cevrim == 1) begin
                        // isaret biti belirlenir
                        sonuc_reg[31] = max[31]^min[31];
                        
                        // bolme yapilir ve atama yapilir
                        bolum_mantissa = max_mantissa / min_mantissa;
                        sonuc_reg[22:0] = bolum_mantissa[22:0];
                    end
                    
                    else begin
                        // virgul kaydirma islemi yapilir
                        if(bolum_mantissa[23] != 1'b1) begin
                            bolum_mantissa = bolum_mantissa << 1;
                            max_exponent = max_exponent - 1;
                        end
                    end
                    
                    sonuc_reg[30:23] = max_exponent - min_exponent + 8'd127;
                    sonuc_reg[22:0] = bolum_mantissa[22:0];
                end
            endcase
        end
    end
    
    always@ (posedge clk) begin
    
        // resetlemek icin
        if(rst) begin
            cevrim <= 1;
            cevrim_sonraki <= 1;
            max <= 0;           
            min <= 0;           
            sonuc_reg <= 0;     
            islem_bitti_mi <= 0;       
            islem_turu_reg <= 0;    
            max_exponent <= 0;   
            min_exponent <= 0;     
            fark_exponent <= 0;    
            cevrim <= 0;        
            cevrim_sonraki <= 1;
            max_mantissa <= 0;  
            min_mantissa <= 0;  
            sum_mantissa <= 0;  
            carpim_mantissa <= 0;
            cikar_mantissa <= 0;
            bolum_mantissa <= 0;
        end
    
        else cevrim <= cevrim_sonraki;
    end
    
endmodule
