import os
class CodeWriter():
    def __init__(self, filename):
        self.filename = filename
        self.asmfile = open(filename + '.asm', 'w+')
        self.initVM = "@256\nD=A\n@SP\nM=D\n@2048\nD=A\n@LCL\nM=D\n@ARG\n@16383\nD=A\n@THIS\nM=D\n@THAT\nM=D\n" # VM init on hack
        self.cnt_eq = 0
        self.cnt_gt = 0
        self.cnt_lt = 0
        self.infloop = "(__END_ALL__)\n@__END_ALL__\n0;JMP\n" # infinite loop

    def writeInit(self):
        return self.asmfile.write(self.initVM)
    
    def writeEnd(self):
        return self.asmfile.write(self.infloop)

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
                return self.asmfile.write(asm_push%"@{filename}.{index}\nD=M".format(filename=os.path.basename(self.filename), index=index))
            elif commandtype =='C_POP':
                return self.asmfile.write(asm_pop%"@{filename}.{index}\nD=A\n@R15\nM=D".format(filename=os.path.basename(self.filename), index=index))
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

    def close(self):
        return self.asmfile.close()