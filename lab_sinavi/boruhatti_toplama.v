`timescale 1ns / 1ps

// Engineer: Mustafa aydogan
// Number: 191101002

module boruhatti_toplama #(parameter N = 8)(
        input clk,
        input [N-1:0] sayi1,
        input [N-1:0] sayi2,
        input [N-1:0] sayi3,
        input [N-1:0] sayi4,
        input [N-1:0] sayi5,
        input [N-1:0] sayi6,
        input [N-1:0] sayi7,
        input [N-1:0] sayi8,
        input giris_etkin,
        output [N+1:0] sonuc,
        output sonuc_etkin
    );
    
    // yazmaclar
    reg [N+1:0] sum_asama1_1 = 0;
    reg [N+1:0] sum_asama1_2 = 0;
    reg [N+1:0] sum_asama2_1 = 0;
    reg [N+1:0] sum_asama2_2 = 0;
    reg [N+1:0] sum_asama3_1 = 0;
    reg [N+1:0] sum_asama3_2 = 0;
    
    reg [N+1:0] sum_asama1_1_next = 0;
    reg [N+1:0] sum_asama1_2_next = 0;
    reg [N+1:0] sum_asama2_1_next = 0;
    reg [N+1:0] sum_asama2_2_next = 0;
    
    reg [31:0]  cevrim = 0;
    reg [31:0]  cevrim_sonraki = 1;
    reg [N+2:0] sonuc_reg = 0;
    reg sonuc_etkin_reg = 0;
    
    // output assign
    assign sonuc = sonuc_reg;
    assign sonuc_etkin = sonuc_etkin_reg;
    
    // boru hatti icin yazmaclar
    reg [N-1:0] sayi3_now;
    reg [N-1:0] sayi3_next;
    
    reg [N-1:0] sayi4_now;
    reg [N-1:0] sayi4_next;
    reg [N-1:0] sayi4_next_next;
    
    reg [N-1:0] sayi7_now;
    reg [N-1:0] sayi7_next;
    
    reg [N-1:0] sayi8_now;
    reg [N-1:0] sayi8_next;
    reg [N-1:0] sayi8_next_next;
    
    always@(cevrim) begin
    
        // boru hatti icin atamalar
        sayi3_next = sayi3;
        sayi4_next_next = sayi4;
        sayi7_next = sayi7;
        sayi8_next_next = sayi8;
       
        // giris etkin = mantik-1
        if(giris_etkin == 1'b1) begin
            sum_asama1_1_next = sayi1 + sayi2;
            sum_asama1_2_next = sayi5 + sayi6;
            
            sum_asama2_1_next = sayi3_now + sum_asama1_1;
            sum_asama2_2_next = sayi7_now + sum_asama1_2;
                        
            sum_asama3_1 = sayi4_now + sum_asama2_1;
            sum_asama3_2 = sayi8_now + sum_asama2_2;
            
            // buyuk sayidan kucuk sayi cikarilir
            if(sum_asama3_1 > sum_asama3_2) begin
                sonuc_reg = sum_asama3_1 - sum_asama3_2;
            end
            
            else begin
                 sonuc_reg = sum_asama3_2 - sum_asama3_1;
            end
            
            // sonuc etkin atamasi yapilir
            if(cevrim > 3) begin
                sonuc_etkin_reg = 1;
            end
        end
    end
    
    
    always@(posedge clk) begin
        cevrim <= cevrim_sonraki;
        
        // sonraki asama icinatamalar yapilir
        sum_asama1_1 <= sum_asama1_1_next;
        sum_asama1_2 <= sum_asama1_2_next;
        sum_asama2_1 <= sum_asama2_1_next;
        sum_asama2_2 <= sum_asama2_2_next;
        
        // sonraki asama icinatamalar yapilir
        sayi3_now <= sayi3_next;
        sayi4_now <= sayi4_next;
        sayi4_next <= sayi4_next_next;
       
        // sonraki asama icinatamalar yapilir
        sayi7_now <= sayi7_next;
        sayi8_now <= sayi8_next;
        sayi8_next <= sayi8_next_next;
    end
    
    
endmodule
