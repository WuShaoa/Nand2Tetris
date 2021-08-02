function MakeParser (input_file)
    local command_table = {
        ["add"]      = "C_ARITHMETIC",
        ["sub"]      = "C_ARITHMETIC",
        ["neg"]      = "C_ARITHMETIC",
        ["eq"]       = "C_ARITHMETIC",
        ["gt"]       = "C_ARITHMETIC",
        ["lt"]       = "C_ARITHMETIC",
        ["and"]      = "C_ARITHMETIC",
        ["or"]       = "C_ARITHMETIC",
        ["not"]      = "C_ARITHMETIC",
        ["push"]     = "C_PUSH",
        ["pop"]      = "C_POP",
        ["label"]    = "C_LABEL",
        ["goto"]     = "C_GOTO",
        ["if-goto"]  = "C_IF",
        ["function"] = "C_FUNCTION",
        ["call"]     = "C_CALL",
        ["return"]   = "C_RETURN"
    }
    assert(string.match(input_file,".-%.[vV][mM][/%s]*"), "ERROR: Input ".. "\"" .. input_file .. "\"" .. " is Not a valid .vm file!")
    local vm_file = io.open(input_file, "r")

    local Parser = {present_command = "", command_prefix = "", arg1 = "", arg2 = ""}
    
    function Parser:hasMoreCommands () return vm_file:read(0) == "" end
    function Parser:advance ()
        if Parser:hasMoreCommands() then
            Parser.present_command = string.gsub(vm_file:read("l"), "//.*", "") -- remove the comments
            if string.gsub(Parser.present_command, " ", "") == "" then Parser:advance() end
        else
            vm_file:close()
        end
    end
    function Parser:commandType ()
        Parser.command_prefix, Parser.arg1, Parser.arg2 = string.match(Parser.present_command, "%s*(%w+)%s*(%w*)%s*(%w*)%s*")
        return assert(command_table[Parser.command_prefix], "ERROR: " .. "\"" ..Parser.present_command .. "\"" .. " is NOT a valid command!")
    end
    return Parser
end

--[[ test
for file in string.gmatch(io.popen("ls","r"):read("a"), "^%s*(.-lua.*)%s*") do print(file) end

local parser = MakeParser("./hello.vm")

local parserx = MakeParser("./hellox.vm")

while parserx:hasMoreCommands() do
    parserx:advance()
    parser:advance()
    print(parserx.present_command, parserx:commandType(), parserx.arg1, parserx.arg2)
end
--]]