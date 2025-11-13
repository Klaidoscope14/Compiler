%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    char label[20];
    struct node* left;
    struct node* right;
} Node;

Node* make(char* label, Node* left, Node* right) {
    Node* n = malloc(sizeof(Node));
    strcpy(n->label, label);
    n->left = left;
    n->right = right;
    return n;
}

void printTree(Node* n, int depth) {
    if (!n) return;
    for (int i = 0; i < depth; i++) printf("|   ");
    printf("%s\n", n->label);
    printTree(n->left, depth + 1);
    printTree(n->right, depth + 1);
}

void printPartial(Node* root) {
    printf("Current Partial Tree:\n");
    printTree(root, 0);
    printf("-----------------------\n");
}

Node* root;
%}

%union {
    char* str;
    Node* node;
}

%token ID
%type <node> E T F

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

S : E { root = $1; printf("----- Final Parse Tree -----\n"); printTree(root,0); }
  ;

E : E '+' T {
        printf("Reducing by: E -> E + T\n");
        $$ = make("+", $1, $3);
        printPartial($$);
    }
  | E '-' T {
        printf("Reducing by: E -> E - T\n");
        $$ = make("-", $1, $3);
        printPartial($$);
    }
  | T {
        printf("Reducing by: E -> T\n");
        $$ = $1;
        printPartial($$);
    }
  ;

T : T '*' F {
        printf("Reducing by: T -> T * F\n");
        $$ = make("*", $1, $3);
        printPartial($$);
    }
  | T '/' F {
        printf("Reducing by: T -> T / F\n");
        $$ = make("/", $1, $3);
        printPartial($$);
    }
  | F {
        printf("Reducing by: T -> F\n");
        $$ = $1;
        printPartial($$);
    }
  ;

F : '(' E ')' {
        printf("Reducing by: F -> ( E )\n");
        $$ = $2;
        printPartial($$);
    }
  | '-' F %prec UMINUS {
        printf("Reducing by: F -> - F\n");
        $$ = make("neg", $2, NULL);
        printPartial($$);
    }
  | ID {
        printf("Reducing by: F -> id\n");
        $$ = make("id", NULL, NULL);
        printPartial($$);
    }
  ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror() {
    printf("Syntax Error\n");
    exit(1);
}