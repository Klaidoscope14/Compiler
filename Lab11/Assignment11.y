%{
// Name: Shreyas Kumar Jaiswal
// Roll: 2301CS52
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* -------- Parse Tree Structure -------- */
typedef struct Node {
    char name[50];
    struct Node *left;
    struct Node *right;
    struct Node *next;   // for multiple statements
} Node;

/* Function declarations */
Node* makeNode(char *name, Node *left, Node *right);
void printTree(Node *tree, int level);
void yyerror(const char *msg);
int yylex(void);
extern int line_no;

Node *root = NULL;
%}

/* -------- Union for YYSTYPE -------- */
%union {
    char *str;
    struct Node *node;
}

/* -------- Token Declarations -------- */
%token IF ELSE WHILE
%token <str> ID NUM RELOP
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGNOP
%token PLUS MINUS MUL DIV

/* -------- Type Associations -------- */
%type <node> S ST IF_ST WHILE_ST ASSIGN C E T F

%left PLUS MINUS
%left MUL DIV
%right ASSIGNOP

%%
/* -------- Grammar Rules -------- */

S
    : S ST                     { 
                                  printf("Reducing by: S → S ST\n");
                                  Node *temp = $1;
                                  while (temp->next) temp = temp->next;
                                  temp->next = $2;
                                  $$ = $1;
                                  root = $$;
                                }
    | ST                       { 
                                  printf("Reducing by: S → ST\n");
                                  $$ = $1; 
                                  root = $$;
                                }
    ;

ST
    : IF_ST                    { printf("Reducing by: ST → IF_ST\n"); $$ = $1; }
    | WHILE_ST                 { printf("Reducing by: ST → WHILE_ST\n"); $$ = $1; }
    | ASSIGN SEMI              { printf("Reducing by: ST → ASSIGN ;\n"); $$ = $1; }
    ;

IF_ST
    : IF LPAREN C RPAREN LBRACE S RBRACE
                                { 
                                  printf("Reducing by: IF_ST → if ( C ) { S }\n");
                                  $$ = makeNode("IF_ST", $3, $6);
                                }
    | IF LPAREN C RPAREN LBRACE S RBRACE ELSE LBRACE S RBRACE
                                { 
                                  printf("Reducing by: IF_ST → if ( C ) { S } else { S }\n");
                                  Node *ifnode = makeNode("IF_ST", $3, $6);
                                  ifnode->right = $10;
                                  $$ = ifnode;
                                }
    ;

WHILE_ST
    : WHILE LPAREN C RPAREN LBRACE S RBRACE
                                { 
                                  printf("Reducing by: WHILE_ST → while ( C ) { S }\n");
                                  $$ = makeNode("WHILE_ST", $3, $6);
                                }
    ;

ASSIGN
    : ID ASSIGNOP E             { 
                                  printf("Reducing by: ASSIGN → id = E\n");
                                  char buf[100];
                                  sprintf(buf, "ASSIGN(%s)", $1);
                                  $$ = makeNode(buf, $3, NULL);
                                }
    ;

C
    : ID RELOP ID
        {
            printf("Reducing by: C → id RELOP id\n");
            char buf[80];
            snprintf(buf, sizeof(buf), "COND(%s %s %s)", $1, $2, $3);
            $$ = makeNode(buf, NULL, NULL);
        }
    | ID RELOP NUM
        {
            printf("Reducing by: C → id RELOP num\n");
            char buf[80];
            snprintf(buf, sizeof(buf), "COND(%s %s %s)", $1, $2, $3);
            $$ = makeNode(buf, NULL, NULL);
        }
    | NUM RELOP ID
        {
            printf("Reducing by: C → num RELOP id\n");
            char buf[80];
            snprintf(buf, sizeof(buf), "COND(%s %s %s)", $1, $2, $3);
            $$ = makeNode(buf, NULL, NULL);
        }
    | NUM RELOP NUM
        {
            printf("Reducing by: C → num RELOP num\n");
            char buf[80];
            snprintf(buf, sizeof(buf), "COND(%s %s %s)", $1, $2, $3);
            $$ = makeNode(buf, NULL, NULL);
        }
    | ID
        {
            printf("Reducing by: C → id\n");
            char buf[40];
            snprintf(buf, sizeof(buf), "COND(%s)", $1);
            $$ = makeNode(buf, NULL, NULL);
        }
    ;

E
    : E PLUS T                  { 
                                  printf("Reducing by: E → E + T\n");
                                  $$ = makeNode("+", $1, $3);
                                }
    | E MINUS T                 { 
                                  printf("Reducing by: E → E - T\n");
                                  $$ = makeNode("-", $1, $3);
                                }
    | T                         { 
                                  printf("Reducing by: E → T\n");
                                  $$ = $1;
                                }
    ;

T
    : T MUL F                   { 
                                  printf("Reducing by: T → T * F\n");
                                  $$ = makeNode("*", $1, $3);
                                }
    | T DIV F                   { 
                                  printf("Reducing by: T → T / F\n");
                                  $$ = makeNode("/", $1, $3);
                                }
    | F                         { 
                                  printf("Reducing by: T → F\n");
                                  $$ = $1;
                                }
    ;

F
    : ID                        { 
                                  printf("Reducing by: F → id\n");
                                  $$ = makeNode($1, NULL, NULL);
                                }
    | NUM                       { 
                                  printf("Reducing by: F → num\n");
                                  $$ = makeNode($1, NULL, NULL);
                                }
    ;
%%

/* -------- Helper Functions -------- */

Node* makeNode(char *name, Node *left, Node *right) {
    Node *newnode = (Node*)malloc(sizeof(Node));
    strcpy(newnode->name, name);
    newnode->left = left;
    newnode->right = right;
    newnode->next = NULL;
    return newnode;
}

void printTree(Node *tree, int level) {
    if (!tree) return;
    for (int i = 0; i < level; i++) printf("    ");
    printf("|-- %s\n", tree->name);

    if (tree->left)  printTree(tree->left, level + 1);
    if (tree->right) printTree(tree->right, level + 1);
    if (tree->next)  printTree(tree->next, level);
}

void yyerror(const char *msg) {
    fprintf(stderr, "\nSyntax Error: %s at line %d\n", msg, line_no);
}

int main() {
    if (!yyparse()) {
        printf("\n----- Final Parse Tree -----\n");
        printTree(root, 0);
    }
    return 0;
}
