/* #include<iostream>
#include<fstream>
#include<string>
using namespace std; */

/* typedef enum COMMANDS {
    A_COMMAND,
    C_COMMAND,
    L_COMMAND
} Command_Type; */

/* class Parser
{
    private:
        ifstream asmfile;
        string presentInstruction;
    public:
        Parser(string filename);
        bool hasMoreCommands();
        void advance();
        Command_Type commandType();
        string symbol();
        string dest();
        string comp();
        string jump();
};
 */
#include "Compiler.h"
//NO ERROR CHECK!!!
Parser::Parser(string filename)
{
    asmfile.open(".\\" + filename + ".asm", ios::in);
    presentInstruction = "";
}

bool Parser::hasMoreCommands()
{
    if (asmfile.eof()) return false;
    else //asmfile.good() 
        return true;
}

void Parser::advance()
{
    if (hasMoreCommands()) getline(asmfile, presentInstruction);
    string::size_type pos = presentInstruction.find("//");
    if (pos == 0)
        presentInstruction = "";
    else if (pos == string::npos)//no comments, pass
        //cout << presentInstruction << endl
        ;
    else
        presentInstruction = presentInstruction.substr(0, pos);
}

Command_Type Parser::commandType()//No regexp check!!!
{
    Command_Type ct;
    //string::iterator insit = presentInstruction.begin();
    if (presentInstruction.empty()) ct = null;
    else if(presentInstruction.at(0) == '@')
        //int flag = 0;
        //insit++;
        //while((*insit >= 0 && *insit <= 9) || (*insit >= 'a' && *insit <= 'z') || (*insit >= 'A' && *insit <= 'Z'))
        ct = A_COMMAND;
    else if (presentInstruction.at(0) == '(') ct = L_COMMAND;
    else ct = C_COMMAND;

    return ct;
}

string Parser::symbol()
{
    string sym = "";
    if (commandType() == A_COMMAND)
        sym = presentInstruction.substr(1, presentInstruction.length());
    else if (commandType() == L_COMMAND)
        sym = presentInstruction.substr(1, presentInstruction.length() - 1);
    //else cerr << "Parser-symbol command type error!";
 
    return sym;
}

string Parser::dest()
{
    string destination = "";
    string::size_type pos;
    if (commandType() == C_COMMAND) {
        if ((pos = presentInstruction.find('=')) != presentInstruction.npos)
            destination = presentInstruction.substr(0, pos);
    }
    //else cerr << "Parser-dest command type error!";

    return destination;
}

string Parser::comp()
{
    string computation;
    string::size_type pos, begin = 0, end = presentInstruction.length();

    if (commandType() == C_COMMAND) {
        if ((pos = presentInstruction.find('=')) != presentInstruction.npos)
            begin = pos + 1;
        if ((pos = presentInstruction.find(';')) != presentInstruction.npos)
            end = pos;
        computation = presentInstruction.substr(begin, end);
    }
    //else cerr << "Parser-comp command type error!";
    //cout << computation << endl;
    return computation;
}

string Parser::jump()
{
    string jumps;
    string::size_type pos;
    if (commandType() == C_COMMAND) {
        if ((pos = presentInstruction.find(';')) != presentInstruction.npos)
            jumps = presentInstruction.substr(pos + 1, presentInstruction.length());
        else
            jumps = "";
    }
    //else cerr << "Parser-jump command type error!";

    return jumps;
}
