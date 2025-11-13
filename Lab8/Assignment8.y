%{
    /*
    Name: Shreyas Kumar Jaiswal
    Roll: 2301CS52
    Date: 10/10/2025
    */
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
extern int yylineno;

int valid = 0, invalid = 0, lines = 0;
int statement_valid = 1;

void yyerror(const char *s);
%}

%union {
    float fval;
    char* sval;
}

%token <sval> ID
%token <fval> NUMBER
%token <sval> CHAR_LITERAL
%token TYPE ASSIGN PLUS MINUS MUL DIV LPAREN RPAREN SEMICOLON NEWLINE

%type <fval> expr term factor

%%

input:
    program
  | program error {
      printf("=> INVALID STATEMENT \n\n");
      invalid++;
      lines++;
      statement_valid = 1;
      yyerrok;
    }
  ;

program:
    /* empty */
  | program statement statement_end {
      lines++;
      if (statement_valid) {
          printf("=> VALID STATEMENT \n\n");
          valid++;
      } else {
          printf("=> INVALID STATEMENT \n\n");
          invalid++;
      }
      statement_valid = 1;
  }
  | program statement {
      // Handle last statement without semicolon or newline
      lines++;
      if (statement_valid) {
          printf("=> VALID STATEMENT \n\n");
          valid++;
      } else {
          printf("=> INVALID STATEMENT \n\n");
          invalid++;
      }
      statement_valid = 1;
  }
  ;

statement:
      declaration
    | assignment
| error recovery_point {
    printf("Syntax Error: invalid statement skipped until statement end\n\n");
    statement_valid = 0;
    yyerrok;
}

recovery_point:
      SEMICOLON
    | NEWLINE
    | recovery_point SEMICOLON
    | recovery_point NEWLINE
    ;

    ;

statement_end:
      SEMICOLON
    | NEWLINE
    | error {
        printf("Syntax Error1: missing ';' at end of statement\n\n");
        statement_valid = 0;
        yyerrok;
    }
    ;

declaration:
      TYPE ID SEMICOLON
    | TYPE ID ASSIGN expr SEMICOLON
    | TYPE ID ASSIGN error SEMICOLON {
          printf("Syntax Error2: missing value in assignment \n\n");
          statement_valid = 0;
          yyerrok;
      }
    | TYPE ID {
          printf("Syntax Error3: missing ';' after declaration\n\n");
          statement_valid = 0;
          yyerrok;
      }
    | TYPE error SEMICOLON {
          printf("Syntax Error: expected identifier after type\n\n");
          statement_valid = 0;
          yyerrok;
      }
    ;

assignment:
      ID ASSIGN expr SEMICOLON
    | ID ASSIGN error SEMICOLON {
          printf("Syntax Error4: missing value in assignment \n\n");
          statement_valid = 0;
          yyerrok;
      }
    | ID ASSIGN expr {
          printf("Syntax Error5: missing ';' after assignment\n\n");
          statement_valid = 0;
          yyerrok;
      }
    ;

expr:
      expr PLUS term
    | expr MINUS term
    | expr PLUS error {
          printf("Syntax Error: missing operand after '+'\n");
          statement_valid = 0;
          yyerrok;
      }
    | expr MINUS error {
          printf("Syntax Error: missing operand after '-'\n");
          statement_valid = 0;
          yyerrok;
      }
    | term
    ;

term:
      term MUL factor
    | term DIV factor
    | term MUL error {
          printf("Syntax Error: missing operand after '*'\n");
          statement_valid = 0;
          yyerrok;
      }
    | term DIV error {
          printf("Syntax Error: missing operand after '/'\n");
          statement_valid = 0;
          yyerrok;
      }
    | factor
    ;

factor:
      NUMBER                { $$ = $1; }
    | ID                    { $$ = 0; }
    | CHAR_LITERAL          { $$ = 0; }
    | LPAREN expr RPAREN    { $$ = $2; }
    | LPAREN expr error     {
          printf("Syntax Error: missing ')' in expression\n");
          statement_valid = 0;
          yyerrok;
      }
    | LPAREN error RPAREN   {
          printf("Syntax Error: invalid expression inside parentheses\n");
          statement_valid = 0;
          yyerrok;
      }
    ;

%%

void yyerror(const char *s) {
    if(statement_valid) {
        printf("Syntax Error: %s\n", s);
        statement_valid = 0;
    }
}

int main() {
    yyparse();
    printf("-------------------------------------------------------\n");
    printf("Parsing completed.\n");
    printf("Total lines processed : %d\n", lines);
    printf("Valid statements      : %d\n", valid);
    printf("Invalid statements    : %d\n", invalid);
    printf("-------------------------------------------------------\n");
    return 0;
}
