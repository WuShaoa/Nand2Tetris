import os
class CodeWriter():
    def __init__(self, outputfilename="vmproject", mode='w+'):
        self.classname = outputfilename # the VM-file under compiling (initial: suppose vm/asm file have the same name) 
        self.asmfile = open(outputfilename + '.asm', mode) # for writing out 
        self.cnt_eq = 0
        self.cnt_gt = 0
        self.cnt_lt = 0
        self.cnt_return = 0
        
        self.func_scope = [''] # for nested function definition label's static lexical scope (a stack list -- env)
    
    def writeInit(self):
        # codes commented below treat Sys.init as a special function which neither has function call nor has return (stack clean while Main being called)
        # infloop = "(__Sys.init$return__)\n@__Sys.init$return__\n0;JMP\n" # infinite loop
        # return self.asmfile.write("@256\nD=A\n@SP\nM=D\n@Sys.init\n0;JMP\n")  #+infloop
        
        self.asmfile.write("@256\nD=A\n@SP\nM=D\n") # initialize the stack: SP=256
        # treat Sys.init as a regular function (more natural) (Stack Pointer at 261 (SP0+5) while Main being called) (?allowing nested VM initialization)
        return self.writeCall("Sys.init", 0) # call Sys.init 0
    def writeArithmetic(self, command):
        asm_al_1 = "@SP\nM=M-1\nA=M\n%s\n@SP\nM=M+1\n"
        if command == 'neg':
            return self.asmfile.write(asm_al_1%"M=-M")
        elif command == 'not':
            return self.asmfile.write(asm_al_1%"M=!M")

        asm_al_2 = "@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\n%s\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        if command == 'add':
            return self.asmfile.write(asm_al_2%"D=D+M")
        elif command == 'sub':
            return self.asmfile.write(asm_al_2%"D=M-D")
        elif command == 'and':
            return self.asmfile.write(asm_al_2%"D=D&M")
        elif command == 'or':
            return self.asmfile.write(asm_al_2%"D=D|M")

        asm_comp = "@SP\nM=M-1\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n%s\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        if command == 'eq':
            self.cnt_eq += 1
            return self.asmfile.write(asm_comp%"@eq_true_{eq_true}\nD;JEQ\nD=0\n@eq_end_{eq_end}\n0;JMP\n(eq_true_{eq_true})\nD=-1\n(eq_end_{eq_end})".format(eq_true=self.cnt_eq, eq_end=self.cnt_eq))
        elif command == 'gt':
            self.cnt_gt += 1
            return self.asmfile.write(asm_comp%"@gt_true_{gt_true}\nD;JGT\nD=0\n@gt_end_{gt_end}\n0;JMP\n(gt_true_{gt_true})\nD=-1\n(gt_end_{gt_end})".format(gt_true=self.cnt_gt, gt_end=self.cnt_gt))
        elif command == 'lt':
            self.cnt_lt += 1
            return self.asmfile.write(asm_comp%"@lt_true_{lt_true}\nD;JLT\nD=0\n@lt_end_{lt_end}\n0;JMP\n(lt_true_{lt_true})\nD=-1\n(lt_end_{lt_end})".format(lt_true=self.cnt_lt, lt_end=self.cnt_lt))
        
        return False

    def writePushPop(self, commandtype, segment, index):
        asm_push = "%s\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
        asm_pop = "%s\n@SP\nM=M-1\nA=M\nD=M\n@R15\nA=M\nM=D\n"
        if segment == 'argument':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@ARG\nD=M\n@{index}\nA=D+A\nD=M".format(index=index))
            elif commandtype == 'C_POP':
                return self.asmfile.write(asm_pop%"@ARG\nD=M\n@{index}\nD=D+A\n@R15\nM=D".format(index=index))
        if segment == 'local':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@LCL\nD=M\n@{index}\nA=D+A\nD=M".format(index=index))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@LCL\nD=M\n@{index}\nD=D+A\n@R15\nM=D".format(index=index))
        if segment == 'static':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@{classname}.{index}\nD=M".format(classname=os.path.basename(self.classname), index=index))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@{classname}.{index}\nD=A\n@R15\nM=D".format(classname=os.path.basename(self.classname), index=index))
        if segment == 'constant':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@{index}\nD=A".format(index=index))
            elif commandtype =='C_POP': # pop constant, pop to the arbiturary addr of constant
                return self.asmfile.write(asm_pop%"@{index}\nD=A\n@R15\nM=D".format(index=index))
        if segment == 'this':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@THIS\nD=M\n@{index}\nA=D+A\nD=M".format(index=index))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@THIS\nD=M\n@{index}\nD=D+A\n@R15\nM=D".format(index=index))
        if segment == 'that':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@THAT\nD=M\n@{index}\nA=D+A\nD=M".format(index=index))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@THAT\nD=M\n@{index}\nD=D+A\n@R15\nM=D".format(index=index))
        if segment == 'pointer': # pointer of this and that from addr 3
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@{index}\nD=M".format(index=index+3))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@{index}\nD=A\n@R15\nM=D".format(index=index+3))
        if segment == 'temp':
            if commandtype == 'C_PUSH':
                return self.asmfile.write(asm_push%"@{index}\nD=M".format(index=index+5))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@{index}\nD=A\n@R15\nM=D".format(index=index+5))
        
        return False

    def writeLabel(self, label):
        return self.asmfile.write("({functionname}${label})\n".format(functionname=self.func_scope[0], label=label))

    def writeGoto(self, label):
        return self.asmfile.write("@{functionname}${label}\n0;JMP\n".format(functionname=self.func_scope[0], label=label))
    
    def writeIf(self, label):
        pop = "@SP\nM=M-1\nA=M\nD=M"
        return self.asmfile.write("{pop}\n@{functionname}${label}\nD;JNE\n".format(pop=pop, functionname=self.func_scope[0], label=label))
    
    def writeCall(self, functionName, numArgs):
        push = "@SP\nA=M\nM=D\n@SP\nM=M+1"
        self.cnt_return += 1
        return self.asmfile.write("@__{functionname}$return{cnt_return}__\nD=A\n{push}\n@LCL\nD=M\n{push}\n@ARG\nD=M\n{push}\n@THIS\nD=M\n{push}\n@THAT\nD=M\n{push}\n@SP\nD=M\n@{nArgs}\nD=D-A\n@5\nD=D-A\n@ARG\nM=D\n@SP\nD=M\n@LCL\nM=D\n@{functionname}\n0;JMP\n(__{functionname}$return{cnt_return}__)\n".format(functionname=functionName, nArgs=numArgs, push=push, cnt_return=self.cnt_return))

    def writeReturn(self):
        pop = "@SP\nM=M-1\nA=M\nD=M"
        frame = "@R14\nD=M\n@%d\nA=D-A\nD=M\n@%s\nM=D"
        self.asmfile.write("@LCL\nD=M\n@R14\nM=D\n@5\nA=D-A\nD=M\n@R15\nM=D\n{pop}\n@ARG\nA=M\nM=D\n@ARG\nD=M+1\n@SP\nM=D\n{frame_1_THAT}\n{frame_2_THIS}\n{frame_3_ARG}\n{frame_4_LCL}\n@R15\nA=M\n0;JMP\n".format(pop=pop, frame_1_THAT=frame%(1,"THAT"), frame_2_THIS=frame%(2,"THIS"), frame_3_ARG=frame%(3,"ARG"), frame_4_LCL=frame%(4,"LCL")))
        return self.func_scope.pop()
    
    def writeFunction(self, functionName, numLocals):
        push = "@SP\nA=M\nM=D\n@SP\nM=M+1"
        self.asmfile.write("({functionname})\n".format(functionname=functionName))
        for i in range(numLocals):
            self.asmfile.write("D=0\n{push}\n".format(push=push))
        return self.func_scope.insert(0, functionName)

    def close(self):
        return self.asmfile.close()