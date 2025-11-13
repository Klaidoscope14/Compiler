#include <iostream>
using namespace std;

int yylex();
extern int token_count;

int main() {
    yylex();
    cout << "Total Tokens: " << token_count << endl;
    return 0;
}