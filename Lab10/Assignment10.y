%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    char val[50];
    struct node *left, *right;
} node;

node* make(char *v, node *l, node *r) {
    node *t = malloc(sizeof(node));
    strcpy(t->val, v);
    t->left = l;
    t->right = r;
    return t;
}

void printTree(node *t, int d) {
    if (!t) return;
    for (int i = 0; i < d; i++) printf("    ");
    printf("%s\n", t->val);
    printTree(t->left, d + 1);
    printTree(t->right, d + 1);
}

int yylex();
void yyerror(const char *s) { printf("Error: %s\n", s); }
%}

%union {
    struct node *nd;
    char *str;
}

%token ID
%token AND OR XOR NOT
%type <nd> E T F
%type <str> ID

%left OR
%left XOR
%left AND
%right NOT

%%

S : E {
        printf("\n----- Final Parse Tree -----\n");
        printTree($1, 0);
    }
;

E : E OR T {
        printf("Reducing by: E → E || T\n");
        $$ = make("||", $1, $3);
    }
  | E XOR T {
        printf("Reducing by: E → E ^^ T\n");
        $$ = make("^^", $1, $3);
    }
  | T {
        printf("Reducing by: E → T\n");
        $$ = $1;
    }
;

T : T AND F {
        printf("Reducing by: T → T && F\n");
        $$ = make("&&", $1, $3);
    }
  | F {
        printf("Reducing by: T → F\n");
        $$ = $1;
    }
;

F : NOT F {
        printf("Reducing by: F → !F\n");
        $$ = make("!", $2, NULL);
    }
  | '(' E ')' {
        printf("Reducing by: F → (E)\n");
        $$ = $2;
    }
  | ID {
        printf("Reducing by: F → id\n");
        $$ = make($1, NULL, NULL);
    }
;

%%

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}