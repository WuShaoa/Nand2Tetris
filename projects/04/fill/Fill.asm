// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel; 
// Put your code here.
// BEGIN:
// while(true)
//     *scr = SCREEN //'*' means scr is a pointer 
//     count = 32 * 256
//     if(M[KBD] != 0)
//          while(count != 0)
//              M[scr] = 0
//              M[scr] = !M[scr]
//              scr++
//              count--
//     else
//          while(count != 0)
//              M[scr] = 0
//              scr++
//              count--
// END BEGIN

(BEGIN)

@SCREEN
D=A
@scr
M=D
//32 * 256
@8192
D=A 
@count
M=D

@KBD
D=M
@NOP
D;JEQ

//A bottom has been pressed
(LOOPY)
@count
D=M
@BEGIN
D;JEQ

@scr
A=M //make scr a pointer(address)

M=0
M=!M

@scr
M=M+1
@count
M=M-1

@LOOPY
0;JMP

(NOP)

(LOOPN)
@count
D=M
@BEGIN
D;JEQ

@scr
A=M

M=0

@scr
M=M+1
@count
M=M-1

@LOOPN
0;JMP
