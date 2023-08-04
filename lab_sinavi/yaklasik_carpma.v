`timescale 1ns / 1ps

// Engineer: Mustafa Aydogan
// Number: 191101002


module yaklasik_carpma(
        input clk,
        input  [31:0] sayi1,
        input  [31:0] sayi2,
        output [63:0] tahmini_sonuc
    );
    
    // yazmaclar
    reg [31:0] sayi1_reg;       
    reg [31:0] sayi2_reg;       
    reg [63:0] tahmini_sonuc_reg = 0;
    
    // cevrim ve cevrim_sonraki yazmaclari
    reg [32:0] cevrim = 0, cevrim_sonraki = 1;  
    
    // bellek yazmaci
    reg [71:0] bellek [7:0];
    
    // bellekte var mi
    reg bellekte_var_mi = 0;
    
    // hangi satirda oldugunu belirten bellek adresi
    reg [32:0] adres;
    
    // aranacak oge
    reg [7:0] aranacak_oge = 0;
    
    // bellegin hangi satirina eklenecek
    reg [32:0] satir = 0;
    
    // integer olusturma
    integer i = 0;
    
    //assign
    assign tahmini_sonuc = tahmini_sonuc_reg;
    
    always@(cevrim) begin
        if(cevrim == 1) begin
            aranacak_oge = {sayi1[31:28] , sayi2[31:28]};
            for(i = 0; i < 8; i = i + 1) begin 
                if( bellek[i][71:64] == aranacak_oge) begin
                    bellekte_var_mi = 1;
                    adres = i;
                end
            end
            
            cevrim_sonraki = cevrim + 1;
        end
        
        else if(cevrim == 2) begin
            if(bellekte_var_mi == 1'b1) begin
                tahmini_sonuc_reg = bellek[adres][63:0];
            end
            
            else begin
                tahmini_sonuc_reg = sayi1 * sayi2;
                
                bellek[satir][63:0] = tahmini_sonuc_reg;
                bellek[satir][71:64] = aranacak_oge;
                
                if(satir == 7) begin 
                    satir = 0;
                end
                
                else begin 
                    satir = satir + 1;
                end
            end
            
            aranacak_oge = 0;
            bellekte_var_mi = 0;
            
            cevrim_sonraki = 1; 
        end
    end
    
    
    always@(posedge clk) begin
        cevrim <= cevrim_sonraki;
    end
    
    
    
endmodule
