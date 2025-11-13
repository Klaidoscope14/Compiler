%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    char val[50];
    struct node* left;
    struct node* right;
} node;

node* make(char* v, node* l, node* r){
    node* n = malloc(sizeof(node));
    strcpy(n->val, v);
    n->left = l;
    n->right = r;
    return n;
}

void printTree(node* n, int d){
    if(!n) return;
    for(int i=0;i<d;i++) printf("  ");
    printf("%s\n", n->val);
    printTree(n->left, d+1);
    printTree(n->right, d+1);
}

void reduce(const char* r){
    printf("Reducing by: %s\n", r);
}

node* root;
int yyerror(const char* s){ printf("Syntax Error: %s\n", s); return 0; }

%}

%union {
    char* str;
    node* nd;
}

%token IF ELSE WHILE ID NUM RELOP
%type <nd> S ST IF_ST WHILE_ST ASSIGN C E T F

%%

S : S ST    { reduce("S → S ST"); $$ = make("S", $1, $2); root = $$; printTree($$,0); }
  | ST      { reduce("S → ST"); $$ = make("S", $1, NULL); root = $$; printTree($$,0); }
  ;

ST : IF_ST          { reduce("ST → IF_ST"); $$ = $1; }
   | WHILE_ST       { reduce("ST → WHILE_ST"); $$ = $1; }
   | ASSIGN ';'     { reduce("ST → ASSIGN ;"); $$ = $1; }
   ;

IF_ST : IF '(' C ')' '{' S '}' {
            reduce("IF_ST → if ( C ) { S }");
            $$ = make("IF", $3, $6);
            printTree($$,0);
        }
      | IF '(' C ')' '{' S '}' ELSE '{' S '}' {
            reduce("IF_ST → if ( C ) { S } else { S }");
            node* elseNode = make("ELSE", NULL, $10);
            $$ = make("IF-ELSE", make("COND",$3,NULL), make("BLOCKS",$6,elseNode));
            printTree($$,0);
        }
      ;

WHILE_ST : WHILE '(' C ')' '{' S '}' {
               reduce("WHILE_ST → while ( C ) { S }");
               $$ = make("WHILE", $3, $6);
               printTree($$,0);
           }
         ;

ASSIGN : ID '=' E {
            reduce("ASSIGN → id = E");
            $$ = make("ASSIGN", make($1,NULL,NULL), $3);
        }
        ;

C : ID RELOP ID {
        reduce("C → id RELOP id");
        node* r = make($2, make($1,NULL,NULL), make($3,NULL,NULL));
        $$ = make("COND", r, NULL);
    }
  | ID {
        reduce("C → id");
        $$ = make("COND", make($1,NULL,NULL), NULL);
    }
  ;

E : E '+' T { reduce("E → E + T"); $$ = make("+",$1,$3); }
  | E '-' T { reduce("E → E - T"); $$ = make("-",$1,$3); }
  | T       { reduce("E → T"); $$ = $1; }
  ;

T : T '*' F { reduce("T → T * F"); $$ = make("*",$1,$3); }
  | T '/' F { reduce("T → T / F"); $$ = make("/",$1,$3); }
  | F       { reduce("T → F"); $$ = $1; }
  ;

F : ID  { reduce("F → id"); $$ = make($1,NULL,NULL); }
  | NUM { reduce("F → num"); $$ = make($1,NULL,NULL); }
  ;

%%

int main(){
    printf("Enter input:\n");
    yyparse();
    printf("\n----- Final Parse Tree -----\n");
    printTree(root, 0);
    return 0;
}