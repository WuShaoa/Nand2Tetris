// init
@256 //SP = 256
D=A
@SP
M=D
@Sys.init //call Sys.init 0 which can't be recurisive and has no return command
0;JMP
(__Sys.init$return__)
{infloop}
 
@LCL //TODO:
@ARG //TODO:

@16383 //TODO: heap
D=A
@THIS
M=D
@THAT
M=D

@{main} //TODO: main
0;JMP

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

//label label
({functionname}${label})

//goto label
@{functionname}${label}
0;JMP

//if-goto label
@SP //pop
M=M-1
A=M
D=M
@{functionname}${label}
D;JNE //true : -1

//call f nArgs
@__{functionname}$return{cnt_return}__
D=A
{push}
@LCL //saved
D=M
{push}
@ARG
D=M
{push}
@THIS
D=M
{push}
@THAT
D=M
{push}
@SP
D=M
@{nArgs}
D=D-A
@5 //5 push-es for saving
D=D-A
@ARG
M=D //ARG = SP - n - 5
@SP
D=M
@LCL //local = SP
M=D
@{functionname}
0;JMP
(__{functionname}$return{cnt_return}__)

//function f kVars
({functionname})
{for i in range(kVars):} //initialize the local variables
    D=0
    {push}

//return
@LCL
D=M
@R14
M=D //FRAME = LCL
@5
A=D-A 
D=M //D = *(FRAME-5)
@R15 //RET
M=D //RET = *(FRAME-5)
{pop} //--> D
@ARG
A=M
M=D //*ARG = pop()
@ARG
D=M+1
@SP
M=D //SP = ARG + 1
{frame%(1,"THAT")} //THAT = *(FRAME-1)
{frame%(2,"THIS")} //THIS = *(FRAME-2)
{frame%(3,"ARG")} //ARG = *(FRAME-3)
{frame%(4,"LCL")} //LCL = *(FRAME-4)
@R15
A=M
0;JMP // goto return

//pop
@SP //pop --> D
M=M-1
A=M
D=M

//push
@SP //push <-- D
A=M
M=D
@SP
M=M+1

//frame
@R14 //%s = *(Frame - %d)
D=M
@%d
A=D-A
D=M
@%s
M=D