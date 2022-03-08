`timescale 1ns / 1ps

// Engineer: Mustafa Aydogan
// Number: 191101002

module islemci(
    input saat,
    input reset,
    input [31:0] buyruk,
    output [31:0] y_on
    );
    
    // veri belleði
    reg [256:0] bellek [7:0] = 0;
    
    // yazmaclar (32 adet)
    reg [31:0]  yazmac [31:0] = 0;
    
    // program sayaci
    reg [31:0] program_sayaci = 0;
    
    // veri bellegi islemleri icin adres degeri
    reg [31:0] adres;
    
    // buyrugun parcalari
    reg [6:0]  opcode;
    reg [4:0]  rd;
    reg [2:0]  funct3;
    reg [6:0]  funct7;
    reg [4:0]  rs1;
    reg [4:0]  rs1;
    reg [11:0] immadiate;
    
    assign y_on = yazmac[10];
    
    always@(posedge clk) begin
    
        // reset
        if(rst == 1'b1) begin
            program_sayaci = 0;
            adres = 0;
            opcode = 0;                     
            rd = 0;                         
            funct3 = 0;                     
            funct7 = 0;                     
            rs1 = 0;                        
            rs1 = 0;                        
            immadiate = 0;       
        end
        
        else begin
    
            // islem kodu belirlenir
            opcode = buyruk[6:0];
            
            // ADD, SUB, SLL
            if(opcode == 7'b0110011) begin
                
                // buyruk cozulur
                rd = buyruk[11:7];
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                rs2 = buyruk[24:20];
                funct7 = buyruk[31:25];
                
                
                // Aritmetik mantik islemi yapilir
                            
                // ADD
                if(funct3 == 3'b000 && funct7 == 7'b0000000) begin
                    yazmac[rd] = yazmac[rs1] + yazmac[rs2];            
                end
        
                // SUB            
                else if(funct3 == 3'b000 && funct7 == 7'b0100000) begin
                    yazmac[rd] = yazmac[rs1] - yazmac[rs2];            
                end
                
                // SLL
                else if(funct3 == 3'b001 && funct7 == 7'b0000000) begin
                    yazmac[rd] = yazmac[rs1] << yazmac[rs2];            
                end
                
                // program sayaci guncellenir
                program_sayaci = program_sayaci + 4;
            end
    
            // JALR        
            else if(opcode == 7'b1100111) begin
            
                // buyruk cozulur
                rd = buyruk[11:7];
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                immadiate = buyruk[31:20];
                
                // program sayaci rd yazmacina yazilir
                yazmac[rd] = program_sayaci;
                
                // program sayaci guncellenir
                program_sayaci = yazmac[rs1] + immadiate;
            end
            
            // BEQ
            else if(opcode == 7'b1100011) begin
            
                // buyruk cozulur
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                rs2 = buyruk[24:20];
                immadiate = {buyruk[31], buyruk[7], buyruk[30:25], buyruk[11:8]};
                
                // karsilastirma yapilir
                // yazmactaki degerlerin esit olmasi durumunda program sayaci guncellenir
                if(yazmac[rs1] == yazmac[rs2]) begin
                    program_sayaci = program_sayaci + {immadiate, 1'b0};
                end
                
                // esit degilse program sayaci 4 artirilir
                else begin
                    program_sayaci = program_sayaci + 4;
                end
            end
            
            // LW        
            else if(opcode == 7'b0000011) begin
            
                // buyruk cozulur
                rd = buyruk[11:7];
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                immadiate = buyruk[31:20];
                
                // anlik deger ile yazmactaki deger toplanir ve bellek adresi elde edilir
                adres = yazmac[rs1] + immadiate;
                
                // elde edilen adresteki veri yazmaca yazilir
                yazmac[rd][7:0]   = bellek[adres];
                yazmac[rd][15:8]  = bellek[adres+1];
                yazmac[rd][23:16] = bellek[adres+2];
                yazmac[rd][31:24] = bellek[adres+3];
               
                // program sayaci guncellenir
                program_sayaci = program_sayaci + 4;
            end
            
            // SW
            else if(opcode == 7'b0100011) begin
            
                // buyruk cozulur
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                rs2 = buyruk[24:20];
                immadiate = {buyruk[31:25], buyruk[11:7]};
                
                // anlik deger ile yazmactaki deger toplanir ve bellek adresi elde edilir
                adres = yazmac[rs1] + immadiate;
                
                // yazmactaki veri elde edilen adrese yazilir
                bellek[adres]   = yazmac[rd][7:0];
                bellek[adres+1] = yazmac[rd][15:8];
                bellek[adres+2] = yazmac[rd][23:16];
                bellek[adres+3] = yazmac[rd][31:24];
                
                // program sayaci guncellenir
                program_sayaci = program_sayaci + 4;
            end
    
            // ADDI        
            else if(opcode == 7'b0010011) begin
            
                // buyruk cozulur
                rd = buyruk[11:7];
                funct3 = buyruk[14:12];
                rs1 = buyruk[19:15];
                immadiate = buyruk[31:20];
                
                // Aritmetik mantik islemi yapilir
                yazmac[rd] = yazmac[rs1] + immadiate; 
                
                // program sayaci guncellenir
                program_sayaci = program_sayaci + 4;
            end
        end
    end
endmodule
