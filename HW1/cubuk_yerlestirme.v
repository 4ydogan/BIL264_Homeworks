`timescale 1ns / 1ps

module cubuk_yerlestirme(
    input [1:0] a, b,
    input [2:0] t,
    output f
    );
    
    wire [3:0] p, s;
    wire [2:0] temp, temp2;
    wire [5:0] x, y, z;
    wire [5:0] k, l, m;
    wire car1, car2;
    wire n = 1'b0;
    
    // a^2
    and (p[0], a[0], a[0]);
    
    and (temp[0], a[1], a[0]);
    and (temp[1], a[0], a[1]);
    
    xor (p[1], temp[0], temp[1]);
    and (car1, temp[0], temp[1]);
    
    and (temp[2], a[1], a[1]);
    
    xor (p[2], car1, temp[2]);
    and (p[3], car1, temp[2]);
       
    // b^2
    and (s[0], b[0], b[0]);
    
    and (temp2[0], b[1], b[0]);
    and (temp2[1], b[0], b[1]);
    
    xor (s[1], temp2[0], temp2[1]);
    and (car2, temp2[0], temp2[1]);
    
    and (temp2[2], b[1], b[1]);
    
    xor (s[2], car2, temp2[2]);
    and (s[3], car2, temp2[2]);
    
    // t^2
    and (x[0], t[0], t[0]);
    and (x[1], t[1], t[0]);
    and (x[2], t[2], t[0]);
    and (x[3], n, n);
    and (x[4], n, n);
    
    and (y[0], n, n);
    and (y[1], t[0], t[1]);
    and (y[2], t[1], t[1]);
    and (y[3], t[2], t[1]);
    and (y[4], n, n);
     
    and (z[0], n, n);
    and (z[1], n, n);
    and (z[2], t[0], t[2]);
    and (z[3], t[1], t[2]);
    and (z[4], t[2], t[2]);
    
    // x + y = k
    wire [2:0] temp3, temp4, temp5, temp6, temp7;
    wire [4:0] car3;
    
    xor (temp3[0], x[0], y[0]);
    xor (k[0], temp3[0], n);
    and (temp3[1], temp3[0], n);
    and (temp3[2], x[0], y[0]);
    or (car3[0], temp3[1], temp3[2]);
    
    xor (temp4[0], x[1], y[1]);
    xor (k[1], temp4[0], car3[0]);
    and (temp4[1], temp4[0], car3[0]);
    and (temp4[2], x[1], y[1]);
    or (car3[1], temp4[1], temp4[2]);
    
    xor (temp5[0], x[2], y[2]);
    xor (k[2], temp5[0], car3[1]);
    and (temp5[1], temp5[0], car3[1]);
    and (temp5[2], x[2], y[2]);
    or (car3[2], temp5[1], temp5[2]);
    
    xor (temp6[0], x[3], y[3]);
    xor (k[3], temp6[0], car3[2]);
    and (temp6[1], temp6[0], car3[2]);
    and (temp6[2], x[3], y[3]);
    or (car3[3], temp6[1], temp6[2]);
    
    xor (temp7[0], x[4], y[4]);
    xor (k[4], temp7[0], car3[3]);
    and (temp7[1], temp7[0], car3[3]);
    and (temp7[2], x[4], y[4]);
    or (k[5], temp7[1], temp7[2]);
 
    // k + z = l
    wire [2:0] temp8, temp9, temp10, temp11, temp12;
    wire [4:0] car4;
    
    xor (temp8[0], k[0], z[0]);
    xor (l[0], temp8[0], n);
    and (temp8[1], temp8[0], n);
    and (temp8[2], k[0], z[0]);
    or (car4[0], temp8[1], temp8[2]);
    
    xor (temp9[0], k[1], z[1]);
    xor (l[1], temp9[0], car4[0]);
    and (temp9[1], temp9[0], car4[0]);
    and (temp9[2], x[1], z[1]);
    or (car4[1], temp9[1], temp9[2]);
    
    xor (temp10[0], k[2], z[2]);
    xor (l[2], temp10[0], car4[1]);
    and (temp10[1], temp10[0], car4[1]);
    and (temp10[2], k[2], z[2]);
    or (car4[2], temp10[1], temp10[2]);
    
    xor (temp11[0], k[3], z[3]);
    xor (l[3], temp11[0], car4[2]);
    and (temp11[1], temp11[0], car4[2]);
    and (temp11[2], k[3], z[3]);
    or (car4[3], temp11[1], temp11[2]);
    
    xor (temp12[0], k[4], z[4]);
    xor (l[4], temp12[0], car4[3]);
    and (temp12[1], temp12[0], car4[3]);
    and (temp12[2], k[4], z[4]);
    or (l[5], temp12[1], temp12[2]);
   
    // a^2 + b^2 = m
    wire [2:0] temp13, temp14, temp15, temp16, temp17;
    wire [4:0] car5;
    
    xor (temp13[0], p[0], s[0]);
    xor (m[0], temp13[0], n);
    and (temp13[1], temp13[0], n);
    and (temp13[2], p[0], s[0]);
    or (car5[0], temp13[1], temp13[2]);
    
    xor (temp14[0], p[1], s[1]);
    xor (m[1], temp14[0], car5[0]);
    and (temp14[1], temp14[0], car5[0]);
    and (temp14[2], p[1], s[1]);
    or (car5[1], temp14[1], temp14[2]);
    
    xor (temp15[0], p[2], s[2]);
    xor (m[2], temp15[0], car5[1]);
    and (temp15[1], temp15[0], car5[1]);
    and (temp15[2], p[2], s[2]);
    or (car5[2], temp15[1], temp15[2]);
    
    xor (temp16[0], p[3], s[3]);
    xor (m[3], temp16[0], car5[2]);
    and (temp16[1], temp16[0], car5[2]);
    and (temp16[2], p[3], s[3]);
    or (m[4], temp16[1], temp16[2]);
    
    and (m[5], n, n);

    // control l <= m
    wire [5:0] e, eN, es, esit;
    wire [5:0] nL, nM, r, d;
    
    not (nL[0], l[0]);
    not (nL[1], l[1]);
    not (nL[2], l[2]);
    not (nL[3], l[3]);
    not (nL[4], l[4]);
    not (nL[5], l[5]);
    
    not (nM[0], m[0]);
    not (nM[1], m[1]);
    not (nM[2], m[2]);
    not (nM[3], m[3]);
    not (nM[4], m[4]);
    not (nM[5], m[5]);
    
    and (e[0], l[0], m[0]);
    and (e[1], l[1], m[1]);
    and (e[2], l[2], m[2]);
    and (e[3], l[3], m[3]);
    and (e[4], l[4], m[4]);
    and (e[5], l[5], m[5]);

    and (eN[0], nL[0], nM[0]);
    and (eN[1], nL[1], nM[1]);
    and (eN[2], nL[2], nM[2]);
    and (eN[3], nL[3], nM[3]);
    and (eN[4], nL[4], nM[4]);
    and (eN[5], nL[5], nM[5]);
    
    or (es[0], eN[0], e[0]);
    or (es[1], eN[1], e[1]);
    or (es[2], eN[2], e[2]);
    or (es[3], eN[3], e[3]);
    or (es[4], eN[4], e[4]);
    or (es[5], eN[5], e[5]);
    
    and (r[5], nL[5], m[5]);
    and (r[4], nL[4], m[4]);
    and (r[3], nL[3], m[3]);
    and (r[2], nL[2], m[2]);
    and (r[1], nL[1], m[1]);
    and (r[0], nL[0], m[0]);
    
    and (esit[5], es[5], es[5]);
    and (esit[4], es[4], esit[5]);
    and (esit[3], es[3], esit[4]);
    and (esit[2], es[2], esit[3]);
    and (esit[1], es[1], esit[2]);
    and (esit[0], es[0], esit[1]);
    
    wire last, last2, last3;  
   
    and (d[0], r[5], 1'b1);
    and (d[1], esit[5], r[4]);
    and (d[2], esit[4], r[3]);
    and (d[3], esit[3], r[2]);
    and (d[4], esit[2], r[1]);
    and (d[5], esit[1], r[0]);
     
    or (last, d[0], d[1], d[2]);
    or (last2, d[3], d[4], d[5]);
    
    or (f, last, last2, esit[0]);
    
endmodule
