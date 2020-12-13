// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
// BEGIN:
// M[R2] = 0
// while(M[R0] != 0) 
//     if(M[R0] > 0) 
//          M[R2] = M[R2] + M[R1] 
//          M[R0]--
//     else
//          M[R2] = M[R2] - M[R1] 
//          M[R0]++
// END BEGIN  

@R2
M=0

(LOOP)
@R0
D=M
@END
D;JEQ

@R0
D=M
@LTZERO
D;JLT

//GTZERO
@R1
D=M
@R2
M=D+M
@R0
M=M-1
@LOOP
0;JMP

(LTZERO)
@R1
D=M
@R2
M=M-D
@R0
M=M+1
@LOOP
0;JMP

(END)
@END
0;JMP
