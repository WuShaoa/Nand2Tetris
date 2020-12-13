/* #include<iostream>
#include<fstream>
#include<string>
using namespace std; */

#include "Compiler.h"

int main(int argc, char* argv[]) {
    Command_Type ct;
    ofstream hackfile;

    string symtbin(string sym);

    if (argc > 1) {
        hackfile.open(".\\" + string(argv[1]) + ".hack", ios::out);
        Parser* parser = new Parser(string(argv[1]));
        Code coder;

        while (parser->hasMoreCommands()) {
            parser->advance();
            ct = parser->commandType();
            string bincode = "";
            string symbol = "";
            switch (ct)
            {
            case A_COMMAND:
                bincode.append("0");
                symbol = parser->symbol();
                bincode.append(symtbin(symbol));
                break;
            case C_COMMAND:
                bincode.append("111");
                bincode.append(coder.comp(parser->comp()) + coder.dest(parser->dest()) + coder.jump(parser->jump()));
                break;
            default://pass
                break;
            }
            if(ct != null)//Very important!!!
                hackfile << bincode << endl;
        }

        delete parser;
        hackfile.close();
    }
    else {
        system("echo no argument!");
        system("pause");
        system("exit");
    }
    return 0;
}

string symtbin(string sym)
{
    string bin = sym;
    if (sym.at(0) >= '0' && sym.at(0) <= '9') {
        int intsym = atoi(sym.c_str());//no bound check!!!
        char bits[16];//may have no '\0' in the end???
        _itoa(intsym, bits, 2);//trans intsym into binary digits
        bin = string(bits);
        //cout << "binpre:" << bin << endl;
        if (bin.length() < 15) {
            for (int i = bin.length(); i < 15; i++) {
                bin.insert(0, "0");//not long enough: insert 0 at first
            }
        }
        //cout << "bin:" << bin << endl;
    }
    return bin;
}