#ifndef __HACK_COMPILEER_H__
#define __HACK_COMPILEER_H__

#include<iostream>
#include<fstream>
#include<string>
#include<map>
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
    string trim();
public:
    Parser(string filename);
    ~Parser();
    bool hasMoreCommands();
    void advance();
    Command_Type commandType();
    string symbol();
    string dest();
    string comp();
    string jump();
    void _printins(void) { cout <<"<"<< presentInstruction <<">"<< endl; }
};

class Code //coder
{
public:
    Code() {};
    string dest(string);
    string comp(string);
    string jump(string);
};

class SymbolTable
{
private:
    map<string, int> symboltable;
    map<string, int>::iterator iter;
public:
    SymbolTable();
    void addEntry(string symbol, int address);
    bool contains(string symbol);
    int GetAddress(string symbol);
};

#endif