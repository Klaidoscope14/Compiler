#include <stdio.h>

int yylex();
extern int token_count;

int main() {
    yylex();
    printf("Total Tokens: %d\n", token_count);
    return 0;
}