from VMCompiler.Parser import Parser
from VMCompiler.CodeWriter import CodeWriter
import sys, os

def translate(parser, codewriter):
    while parser.hasMoreCommands():
        ct = parser.commandType()
        if ct == "C_ARITHMETIC":
            codewriter.writeArithmetic(parser.arg1())
        elif ct == "C_PUSH" or ct == "C_POP":
            codewriter.writePushPop(parser.commandType(), parser.arg1(), parser.arg2())
        elif ct == "C_LABEL":
            codewriter.writeLabel(parser.arg1())
        elif ct == "C_GOTO":
            codewriter.writeGoto(parser.arg1())
        elif ct == "C_IF":
            codewriter.writeIf(parser.arg1())
        elif ct == "C_FUNCTION":
            codewriter.writeFunction(parser.arg1(), parser.arg2())
        elif ct == "C_CALL":
            codewriter.writeCall(parser.arg1(), parser.arg2())
        elif ct == "C_RETURN":
            codewriter.writeReturn()
        else: pass

if __name__ == "__main__":
    basename = sys.argv[1].split(os.path.sep)[-2] # if arg is a path    
    cw = CodeWriter(os.path.join(sys.argv[1], basename), mode='a+')
    
    cw.writeInit()
    
    for root, dirs, files in os.walk(sys.argv[1]):
        for file in files:
            if file.endswith(".vm"):
                ps = Parser(os.path.join(root, file))
                cw.classname = ps.filename # make sure the static variables' scope independent among classis
                translate(ps, cw)
                ps.close()
    
    cw.close()
