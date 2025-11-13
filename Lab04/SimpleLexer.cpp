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

