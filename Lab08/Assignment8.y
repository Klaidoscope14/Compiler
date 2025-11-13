%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lineno = 1;
int paren_depth = 0;

int total_lines = 0;
int valid_statements = 0;
int invalid_statements = 0;

int current_valid;

void yyerror(const char *s);
int yylex(void);
extern int paren_depth;
%}

%token INT_T FLOAT_T CHAR_T
%token IDENTIFIER NUMBER CHAR_LITERAL
%token ASSIGN
%token PLUS MUL
%token LPAREN RPAREN
%token SEMI

%start input

%left PLUS
%left MUL

%%

input:
      /* empty */
    | input line
    ;

line:
      statement SEMI    {
                          total_lines++;
                          if(paren_depth != 0){
                              yyerror("missing ')' in expression");
                          }
                          if(current_valid){
                              printf("=> VALID STATEMENT\n\n");
                              valid_statements++;
                          } else {
                              printf("=> INVALID STATEMENT\n\n");
                              invalid_statements++;
                          }
                          current_valid = 1;
                        }
    | error SEMI       {
                          total_lines++;
                          current_valid = 0;
                          printf("=> INVALID STATEMENT\n\n");
                          yyerrok();
                        }
    ;

statement:
      declaration
    | assignment
    ;

declaration:
      type IDENTIFIER opt_assign
    | type {
          yyerror("missing identifier after type declaration");
          current_valid = 0;
        }
    ;

opt_assign:
      /* empty */
    | ASSIGN expr
    ;

assignment:
      IDENTIFIER ASSIGN expr
    ;

expr:
      term
    | expr PLUS term
    ;

term:
      factor
    | term MUL factor
    ;

factor:
      NUMBER
    | IDENTIFIER
    | CHAR_LITERAL
    | LPAREN expr RPAREN
    | LPAREN error RPAREN { yyerror("syntax error inside parentheses"); current_valid = 0; yyerrok(); }
    | error { yyerror("missing operand or invalid token in expression"); current_valid = 0; yyerrok(); }
    ;

expr:
    expr PLUS error { yyerror("missing operand after '+'"); current_valid = 0; yyerrok(); }
  | expr error { yyerror("missing operator or operand in expression"); current_valid = 0; yyerrok(); }
  ;

term:
    term MUL error { yyerror("missing operand after '*'"); current_valid = 0; yyerrok(); }
  ;

%%

void yyerror(const char *s){
    printf("Syntax Error: %s\n", s);
    current_valid = 0;
}

int main(void){
    current_valid = 1;
    printf("\n");
    yyparse();

    printf("-------------------------------------------------------\n");
    printf("Parsing completed.\n");
    printf("Total lines processed : %d\n", total_lines);
    printf("Valid statements      : %d\n", valid_statements);
    printf("Invalid statements    : %d\n", invalid_statements);
    printf("-------------------------------------------------------\n");
    return 0;
}