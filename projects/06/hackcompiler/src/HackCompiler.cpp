/* #include<iostream>
#include<fstream>
#include<string>
using namespace std; */

#include "Compiler.h"
#include <stdlib.h>
int main(int argc, char* argv[]) {
    Command_Type ct;
    ofstream hackfile;

    string symtbin(string sym);
    string addrtbin(int address);

    if (argc > 1) {
        hackfile.open(".\\" + string(argv[1]) + ".hack", ios::out);
        if (hackfile.eof())
            cerr << "Empty file!!!";
        
        SymbolTable symboltable;
        
        Parser* preparser = new Parser(string(argv[1]));
        int count = 0;//here count refers to the addr in instruction mem
        while (preparser->hasMoreCommands()) {
            preparser->advance();
            ct = preparser->commandType();
            string symbol;
            int address;
            switch (ct)
            {
            case L_COMMAND:
                symbol = preparser->symbol();
                symboltable.addEntry(symbol, count);

                //!cout << count << ":" << symbol << endl;!
                break;
            default://pass or some marco?
                break;
            }
            if (preparser->commandType() != null && preparser->commandType() != L_COMMAND)
                count++;
        }
        //preparser->~Parser();
        delete preparser;

        Parser* parser = new Parser(string(argv[1]));
        Code coder;
        count = 16;//here count refers to the addr in data mem, and MUST starts from 16 (because first 15 were already predefined)
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
                if (symbol.at(0) >= '0' && symbol.at(0) <= '9')//a pure address, all numbers
                    bincode.append(symtbin(symbol));
                else if (symboltable.contains(symbol)) //a pre-reserved/parsered ROM address or an old variable
                    bincode.append(addrtbin(symboltable.GetAddress(symbol)));
                else if (!symboltable.contains(symbol)) {//a new variable
                    symboltable.addEntry(symbol, count);
                    bincode.append(addrtbin(count));
                    count++;
                }
                else cerr<<"A command error!!!";
                break;
            case C_COMMAND:
                bincode.append("111");
                bincode.append(coder.comp(parser->comp()) + coder.dest(parser->dest()) + coder.jump(parser->jump()));
                break;
            default://pass
                break;
            }
            if(ct != null && ct != L_COMMAND)//Very important!!!
                hackfile << bincode << endl;
            /*!if (count == 16) {
                cout << "instruction:";
                parser->_printins();
            } !*/
        }
        //parser->~Parser();
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
        int intsym = atoi(sym.c_str());
        char bits[16];
        _itoa(intsym, bits, 2);
        bin = string(bits);
        //cout << "binpre:" << bin << endl;
        if (bin.length() < 15) {
            for (int i = bin.length(); i < 15; i++) {
                bin.insert(0, "0");
            }
        }
        //cout << "bin:" << bin << endl;
    }
    return bin;//not a number just return the symbol
}

string addrtbin(int address)
{
    string bin;
    char bits[16];
    _itoa(address, bits, 2);
    bin = string(bits);
    if (bin.length() < 15) {
        for (int i = bin.length(); i < 15; i++) {
            bin.insert(0, "0");
        }
    }
    return bin;
}
//sissymbol()
//sisnum()