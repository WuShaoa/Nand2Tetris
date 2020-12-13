#include "Compiler.h"

SymbolTable::SymbolTable() 
{ 
	symboltable.insert(map<string, int>::value_type("SP", 0));
	symboltable.insert(map<string, int>::value_type("LCL", 1));
	symboltable.insert(map<string, int>::value_type("ARG", 2));
	symboltable.insert(map<string, int>::value_type("THIS", 3));
	symboltable.insert(map<string, int>::value_type("THAT", 4));
	symboltable.insert(map<string, int>::value_type("R0", 0));
	symboltable.insert(map<string, int>::value_type("R1", 1));
	symboltable.insert(map<string, int>::value_type("R2", 2));
	symboltable.insert(map<string, int>::value_type("R3", 3));
	symboltable.insert(map<string, int>::value_type("R4", 4));
	symboltable.insert(map<string, int>::value_type("R5", 5));
	symboltable.insert(map<string, int>::value_type("R6", 6));
	symboltable.insert(map<string, int>::value_type("R7", 7));
	symboltable.insert(map<string, int>::value_type("R8", 8));
	symboltable.insert(map<string, int>::value_type("R9", 9));
	symboltable.insert(map<string, int>::value_type("R10", 10));
	symboltable.insert(map<string, int>::value_type("R11", 11));
	symboltable.insert(map<string, int>::value_type("R12", 12));
	symboltable.insert(map<string, int>::value_type("R13", 13));
	symboltable.insert(map<string, int>::value_type("R14", 14));
	symboltable.insert(map<string, int>::value_type("R15", 15));
	symboltable.insert(map<string, int>::value_type("SCREEN", 16384));
	symboltable.insert(map<string, int>::value_type("KBD", 24576));
}

void SymbolTable::addEntry(string symbol, int address)
{
	symboltable.insert(map<string, int>::value_type(symbol, address));
}

bool SymbolTable::contains(string symbol)
{
	iter = symboltable.find(symbol);
	if (iter == symboltable.end())
		return false;
	else
		return true;
}

int SymbolTable::GetAddress(string symbol)
{
	iter = symboltable.find(symbol);
	if (iter != symboltable.end())
		return iter->second;
	else
		return -1;
}