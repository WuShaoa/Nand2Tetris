
#ifndef __COMPILEER__H__

#include<iostream>
#include<fstream>
#include<string>
using namespace std;

typedef enum COMMANDS {
    null,
    A_COMMAND,
    C_COMMAND,
    L_COMMAND
} Command_Type;

class Parser
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

class Code //coder
{
public:
    Code() {};
    string dest(string);
    string comp(string);
    string jump(string);
};



#endif