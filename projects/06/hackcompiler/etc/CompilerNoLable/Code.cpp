/*#include<iostream>
#include<string>
//#include<map>
using namespace std;

class Code //coder
{
    public:
        Code(){};
        string dest(string);
        string comp(string);
        string jump(string);
};*/

#include "Compiler.h"
//NO ERROR CHECK!!!
string Code::dest(string sdest)
{
    string bindest;
    if (sdest.empty()) bindest = "000";
    else if (sdest == "M") bindest = "001";
    else if (sdest == "D") bindest = "010";
    else if (sdest == "MD") bindest = "011";
    else if (sdest == "A") bindest = "100";
    else if (sdest == "AM") bindest = "101";
    else if (sdest == "AD") bindest = "110";
    else if (sdest == "AMD") bindest = "111";
    else bindest = "destdest";

    return bindest;
}

string Code::comp(string scomp)
{
    string bincomp;
    if (scomp == "0") bincomp = "0101010";
    else if (scomp == "1") bincomp = "0111111";
    else if (scomp == "-1") bincomp = "0111010";
    else if (scomp == "D") bincomp = "0001100";
    else if (scomp == "A") bincomp = "0110000";
    else if (scomp == "!D") bincomp = "0001101";
    else if (scomp == "!A") bincomp = "0110001";
    else if (scomp == "-D") bincomp = "0001111";
    else if (scomp == "-A") bincomp = "0110011";
    else if (scomp == "D+1") bincomp = "0011111";
    else if (scomp == "A+1") bincomp = "0110111";
    else if (scomp == "D-1") bincomp = "0001110";
    else if (scomp == "A-1") bincomp = "0110010";
    else if (scomp == "D+A") bincomp = "0000010";
    else if (scomp == "D-A") bincomp = "0010011";
    else if (scomp == "A-D") bincomp = "0000111";
    else if (scomp == "D&A") bincomp = "0000000";
    else if (scomp == "D|A") bincomp = "0010101";
    else if (scomp == "M") bincomp = "1110000";
    else if (scomp == "!M") bincomp = "1110001";
    else if (scomp == "-M") bincomp = "1110011";
    else if (scomp == "M+1") bincomp = "1110111";
    else if (scomp == "M-1") bincomp = "1110010";
    else if (scomp == "D+M") bincomp = "1000010";
    else if (scomp == "D-M") bincomp = "1010011";
    else if (scomp == "M-D") bincomp = "1000111";
    else if (scomp == "D&M") bincomp = "1000000";
    else if (scomp == "D|M") bincomp = "1010101";
    else bincomp = "compcomp";

    return bincomp;
}

string Code::jump(string sjump)
{
    string binjump;
    if (sjump.empty()) binjump = "000";
    else if (sjump == "JGT") binjump = "001";
    else if (sjump == "JEQ") binjump = "010";
    else if (sjump == "JGE") binjump = "011";
    else if (sjump == "JLT") binjump = "100";
    else if (sjump == "JNE") binjump = "101";
    else if (sjump == "JLE") binjump = "110";
    else if (sjump == "JMP") binjump = "111";
    else binjump = "jumpjump";

    return binjump;
}