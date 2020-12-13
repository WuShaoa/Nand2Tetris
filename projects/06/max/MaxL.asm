// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/06/max/MaxL.asm

// Symbol-less version of the Max.asm program.

@12
D=A
@0
M=D
@23
D=A
@1
M=D
@0
D=M
@1
D=D-M
@18
D;JGT
@1
D=M
@20
0;JMP
@0
D=M
@2
M=D
@22
0;JMP
