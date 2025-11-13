// SimpleLexer.cpp
// Name: Shreyas Kumar Jaiswal
// Roll No: 2301CS52
// CS3104 Compiler Lab, Autumn 2025 - Assignment 4
#include <iostream>
using namespace std;
extern "C" int yywrap();
extern "C" int yylex();
extern int token_count;

int main()
{
  yylex();
  return 0;
}

