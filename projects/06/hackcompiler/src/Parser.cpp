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

Parser::Parser(string filename)
{
    asmfile.open(".\\" + filename + ".asm", ios::in);
    presentInstruction = "";
}

Parser::~Parser()
{
    asmfile.close();
}

bool Parser::hasMoreCommands()
{
    if (asmfile.eof()) return false;
    else //asmfile.good() 
        return true;
}

void Parser::advance()
{
    if (hasMoreCommands()) {
        getline(asmfile, presentInstruction);
        string::size_type pos = presentInstruction.find("//");//remove the comments;
        if (pos == 0)
            presentInstruction = "";
        else if (pos == string::npos)//pass
            //cout << presentInstruction << endl
            ;
        else
            presentInstruction = presentInstruction.substr(0, pos);

        presentInstruction = trim();//has some weired phenomena
    }
}

Command_Type Parser::commandType()
{
    Command_Type ct;
    //string::iterator insit = presentInstruction.begin();
    if (presentInstruction.empty()) ct = null;
    else if(presentInstruction.at(0) == '@')//no RegExp check!!!
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
    if (commandType() == A_COMMAND)//@Value
        sym = presentInstruction.substr(1, presentInstruction.length() - 1);
    else if (commandType() == L_COMMAND)//(Lable)
        sym = presentInstruction.substr(1, presentInstruction.length() - 2);
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
    string::size_type pos, begin = 0, length = presentInstruction.length();

    if (commandType() == C_COMMAND) {
        if ((pos = presentInstruction.find('=')) != presentInstruction.npos)
            begin = pos + 1;
        if ((pos = presentInstruction.find(';')) != presentInstruction.npos)
            length = pos - begin;
        computation = presentInstruction.substr(begin, length);//an error in use of substr() has been repaired
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
            jumps = presentInstruction.substr(pos + 1, presentInstruction.length() - pos);
        else
            jumps = "";
    }
    //else cerr << "Parser-jump command type error!";

    return jumps;
}

string Parser::trim()//remove all spaces
{
	int index = 0;
    string temp = presentInstruction;
	if (!presentInstruction.empty())
	{
		while ((index = temp.find(' ')) != temp.npos || (index = temp.find('\t')) != temp.npos)
		{
			temp.erase(index, 1);
		}
        /*if(temp.find(' ') != temp.npos)
            cout << "\"" << s << "\"" << endl;*/
	}

    return temp;
}