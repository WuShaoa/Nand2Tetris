import re, os

class Parser():
    __doc__ = '''Command Types:
    A&L commands:
        add
        sub
        neg
        eq
        gt
        lt
        and
        or
        not
    Mem access commands:
        push segment index
        pop segment index
    Program flow & func call commands:
        label symbol
        goto symbol
        if-goto symbol
        
        function name nlocals
        call name nargs
        return
    '''
    def __init__(self, path):
        self.command_tab = {
        "add"      : "C_ARITHMETIC",
        "sub"      : "C_ARITHMETIC",
        "neg"      : "C_ARITHMETIC",
        "eq"       : "C_ARITHMETIC",
        "gt"       : "C_ARITHMETIC",
        "lt"       : "C_ARITHMETIC",
        "and"      : "C_ARITHMETIC",
        "or"       : "C_ARITHMETIC",
        "not"      : "C_ARITHMETIC",
        "push"     : "C_PUSH",
        "pop"      : "C_POP",
        "label"    : "C_LABEL",
        "goto"     : "C_GOTO",
        "if-goto"  : "C_IF",
        "function" : "C_FUNCTION",
        "call"     : "C_CALL",
        "return"   : "C_RETURN", 
        }
        
        # path name test
        try:
            bn = os.path.basename(path)
            match = re.match(r"[ ]*(.+)\.[vV][mM][ ]*", bn) # make sure this is a .vm file
        except re.error as e:
            print("ERROR: not a .vm file!", e.msg)
        else:
            self.filename = match.group(1)
            self.dirname = os.path.dirname(path)
            self.rp = re.compile(r"//.*$")
        
        # file open test
        try:
            self.vmfile = open(path, 'r')
        except IOError as e:
            print("ERROR: file not found!", e.errno)
        
        self.present_command = ''

        # return nothing
    
    def hasMoreCommands(self):
        buf = self.rp.sub(' ', self.vmfile.readline()) # remove all comments

        if buf == '':
            return False
        elif not buf.isspace():
            self.present_command = buf
            return True
        else:
            return self.hasMoreCommands()

    def advance(self, advance=False):
        if not advance:
            return self.present_command
        else:
            if(self.hasMoreCommands()):
                return self.present_command 
            return False

    def commandType(self):
        return self.command_tab[self.present_command.split()[0]]

    def arg1(self):
        type = self.commandType()
        if type == 'C_RETURN':
            return False
        elif type == 'C_ARITHMETIC':
            return self.present_command.split()[0]
        else:
            return self.present_command.split()[1]

    def arg2(self):
        type = self.commandType()
        for t in ['C_PUSH', 'C_POP', "C_FUNCTION", "C_CALL"]:
            if type == t: return int(self.present_command.split()[2])
        return False
    
    def close(self):
        return self.vmfile.close()
