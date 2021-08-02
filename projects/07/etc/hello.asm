@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-EQUAL1
D;JEQ
@0
M=A
@END-EQUAL1
0;JMP
(IF-EQUAL1)
@0
A=A-1
M=A
(END-EQUAL1)
@SP
M=M+1 //SP = SP + 1 PUSH
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-EQUAL2
D;JEQ
@0
M=A
@END-EQUAL2
0;JMP
(IF-EQUAL2)
@0
A=A-1
M=A
(END-EQUAL2)
@SP
M=M+1 //SP = SP + 1 PUSH
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-EQUAL3
D;JEQ
@0
M=A
@END-EQUAL3
0;JMP
(IF-EQUAL3)
@0
A=A-1
M=A
(END-EQUAL3)
@SP
M=M+1 //SP = SP + 1 PUSH
