require "Parser"

local MakeCounter = function () local Counter ={c = 0}; function Counter:count() Counter.c = Counter.c + 1 return Counter.c, Counter.c, Counter.c, Counter.c, Counter.c, Counter.c end; return Counter end

function MakeCodeWriter (output_file_path)
    local output_file, asm_file
    local CodeWriter = {}
    local counter = MakeCounter() --For dynamic generate safe labels. Support at most 3 label pairs.
    local arithmetic_asm_table ={
        ["add"] = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //M(M(SP)) -> D  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //*SP = *SP + D 
M=M+D
@SP
M=M+1 //SP = SP + 1 PUSH
]] end,
        ["sub"] = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
M=M-D //*SP = *SP - D 
@SP
M=M+1 //SP = SP + 1 PUSH
]] end,
        ["neg"] = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //*SP = -(*SP) where *SP is Stack[SP]
M=-M
@SP
M=M+1 //SP = SP + 1 PUSH
]] end,
        ["eq"]  = function () return string.format([[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-EQUAL%d
D;JEQ
@0
D=A
@SP
A=M
M=D
@END-EQUAL%d
0;JMP
(IF-EQUAL%d)
@0
D=A-1
@SP
A=M
M=D
(END-EQUAL%d)
@SP
M=M+1 //SP = SP + 1 PUSH
]], counter:count()) end,
        ["gt"]  = function () return string.format([[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-GREATER%d
D;JGT
@0
D=A
@SP
A=M
M=D
@END-GREATER%d
0;JMP
(IF-GREATER%d)
@0
D=A-1
@SP
A=M
M=D
(END-GREATER%d)
@SP
M=M+1 //SP = SP + 1 PUSH
]], counter:count()) end,
        ["lt"]  = function () return string.format([[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
D=M-D
@IF-LESS%d
D;JLT
@0
D=A
@SP
A=M
M=D
@END-LESS%d
0;JMP
(IF-LESS%d)
@0
D=A-1
@SP
A=M
M=D
(END-LESS%d)
@SP
M=M+1 //SP = SP + 1 PUSH
]], counter:count()) end,
        ["and"] = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
M=D&M
@SP
M=M+1 //SP = SP + 1 PUSH
]] end,
        ["or"]  = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //D = *SP where *SP is Stack[SP]
D=M   //arg 2  
@SP
M=M-1 //SP = SP - 1 POP
A=M   //arg1
M=D|M
@SP
M=M+1 //SP = SP + 1 PUSH
]] end,
        ["not"] = function () return [[
@SP
M=M-1 //SP = SP - 1 POP
A=M   //*SP = -(*SP) where *SP is Stack[SP]
M=!M
@SP
M=M+1 //SP = SP + 1 PUSH
]] end
    }
local push_asm_table = {
    ["argument"] = function (index) return [[

    ]] end,
    ["local"]    = function (index) return [[

    ]] end,
    ["static"]   = function (index) return [[

    ]] end,
    ["constant"] = function (index) return [[

    ]] end,
    ["this"]     = function (index) return [[

    ]] end,
    ["that"]     = function (index) return [[

    ]] end,
    ["pointer"]  = function (index) return [[

    ]] end,
    ["temp"]     = function (index) return [[

    ]] end
}
    
    function CodeWriter:setFileName (filename)
        output_file = output_file_path .. filename .. ".asm"
        asm_file = io.open(output_file, "a+")
    end
    function CodeWriter:writeArithmetic (Command)
        asm_file:write(arithmetic_asm_table[Command]())
        asm_file:flush()
    end
    function CodeWriter:WritePushPop (CommandType, segment, index)
        asm_file:write(CommandType == "C_PUSH" and push_asm_table[segment](index) or pop_asm_table[segment](index))
        asm_file:flush()
    end
    function CodeWriter:Close () asm_file:close() end

    return CodeWriter
end

local cw = MakeCodeWriter(".\\")
cw:setFileName("hello")
cw:writeArithmetic("eq")
cw:writeArithmetic("eq")
cw:writeArithmetic("eq")