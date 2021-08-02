// init
@256
D=A
@SP
M=D

@2048
D=A
@LCL
M=D

@ARG

@16383
D=A
@THIS
M=D
@THAT
M=D

//Arithmwtic & Logic
@SP //pop arg2
M=M-1
A=M // A now at the top of the stack 

    M=-M //neg
    M=!M //not
    @SP
    M=M+1

D=M //arg2
@SP //pop arg1
M=M-1
A=M

D=D+M //add
D=M-D //sub
D=D&M //and
D=D|M //or

D=M-D

//D=M-D //eq
@eq_true_{eq_true}
D;JEQ
D=0 //eq_false
@eq_end_{eq_end}
0;JMP
(eq_true_{eq_true})
D=-1
(eq_end_{eq_end})

//D=M-D //gt
@gt_true_{gt_true}
D;JGT
D=0 //gt_false
@gt_end_{gt_end}
0;JMP
(gt_true_{gt_true})
D=-1
(gt_end_{gt_end})

//D=M-D //lt
@lt_true_{lt_true}
D;JLT
D=0 //gt_false
@lt_end_{lt_end}
0;JMP
(lt_true_{lt_true})
D=-1
(lt_end_{lt_end})

@SP //push end
A=M
M=D
@SP
M=M+1

//Push & Pop
//push segment index
//argument    @ARG\nD=M\n@{index}\nA=D+A\nD=M
//local       @LCL\nD=M\n@{index}\nA=D+A\nD=M
//static      @{filename}.{index}\nD=M
//constant    @{index}\nD=A
//this        @THIS\nD=M\n@{index}\nA=D+A\nD=M
//that        @THAT\nD=M\n@{index}\nA=D+A\nD=M
//pointer 0 1 @{index+3}\nD=M  //%if 0% @THIS D=M %elif 1% @THAT D=M
//temp        @{index+5}\nD=M
%s
@SP
A=M
M=D
@SP
M=M+1

//pop segment index
//argument    @ARG\nD=M\n@{index}\nD=D+A\n@R15\nM=D
//local       @LCL\nD=M\n@{index}\nD=D+A\n@R15\nM=D
//static      @{filename}.{index}\nD=A\n@R15\nM=D
//constant    @{index}\nD=A //meaningless
//this        @THIS\nD=M\n@{index}\nD=D+A\n@R15\nM=D
//that        @THAT\nD=M\n@{index}\nD=D+A\n@R15\nM=D
//pointer 0 1 @{index+3}\nD=A\n@R15\nM=D  //%if 0% @THIS D=M %elif 1% @THAT D=M
//temp        @{index+5}\nD=A\n@R15\nM=D

%s
@SP
M=M-1
A=M
D=M
@R15
A=M
M=D

