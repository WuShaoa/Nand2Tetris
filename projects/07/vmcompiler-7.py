from VMCompiler.Parser import Parser
from VMCompiler.CodeWriter import CodeWriter
import sys, os

path = sys.argv[1]
ps = Parser(path)
cw = CodeWriter(os.path.join(ps.dirname, ps.filename))

if __name__ == "__main__":
    #cw.writeInit()
    while ps.hasMoreCommands():
        if ps.commandType() == "C_ARITHMETIC":
            cw.writeArithmetic(ps.arg1())
        else:
            cw.writePushPop(ps.commandType(), ps.arg1(), ps.arg2())
    #cw.writeEnd()
    cw.close()
