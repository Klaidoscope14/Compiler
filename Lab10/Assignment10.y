%{
    // Name: Shreyas Kumar Jaiswal
    // Roll: 2301CS52
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    typedef struct Node {
        char label[20];
        struct Node *left, *right;
    } Node;

    Node* makeNode(const char *label, Node *left, Node *right);
    void printTree(Node *root, int level);
    void yyerror(const char *s);
    int yylex(void);

    Node *finalTree = NULL;
%}

%union {
    struct Node *node;
}

%token ID OR AND XOR NOT LPAREN RPAREN INVALID

%type <node> input E T F

%left OR XOR
%left AND
%right NOT

%%

input
    : E { finalTree = $1; }
    ;

E
    : E OR T
        {
            printf("Reducing by: E → E || T\n");
            $$ = makeNode("||", $1, $3);
        }
    | E XOR T
        {
            printf("Reducing by: E → E ^^ T\n");
            $$ = makeNode("^^", $1, $3);
        }
    | T
        {
            printf("Reducing by: E → T\n");
            $$ = $1;
        }
    ;

T
    : T AND F
        {
            printf("Reducing by: T → T && F\n");
            $$ = makeNode("&&", $1, $3);
        }
    | F
        {
            printf("Reducing by: T → F\n");
            $$ = $1;
        }
    ;

F
    : NOT F
        {
            printf("Reducing by: F → !F\n");
            $$ = makeNode("!", $2, NULL);
        }
    | LPAREN E RPAREN
        {
            printf("Reducing by: F → (E)\n");
            $$ = $2;
        }
    | ID
        {
            printf("Reducing by: F → id\n");
            $$ = makeNode("id", NULL, NULL);
        }
    | INVALID
        {
            yyerror("Invalid token encountered");
            YYABORT;
        }
    ;

%%


Node* makeNode(const char *label, Node *left, Node *right) {
    Node *n = (Node*)malloc(sizeof(Node));
    if (!n) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    strncpy(n->label, label, sizeof(n->label)-1);
    n->label[sizeof(n->label)-1] = '\0';
    n->left = left;
    n->right = right;
    return n;
}

void printTree(Node *root, int level) {
    if (!root) return;

    void printAscii(Node *node, const char *prefix, int isLast, int isRoot) {
        if (!node) return;
        if (isRoot) {
            printf("%s\n", node->label);
        } else {
            printf("%s%s %s\n", prefix, (isLast ? "`--" : "|--"), node->label);
        }

        char newprefix[256];
        if (isRoot) {
            newprefix[0] = '\0';
        } else {
            snprintf(newprefix, sizeof(newprefix), "%s%s", prefix, (isLast ? "    " : "|   "));
        }

        Node *children[2];
        int cnt = 0;
        if (node->left)  children[cnt++] = node->left;
        if (node->right) children[cnt++] = node->right;

        for (int i = 0; i < cnt; ++i) {
            printAscii(children[i], newprefix, (i == cnt - 1), 0);
        }
    }

    printAscii(root, "", 1, 1);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    if (yyparse() == 0 && finalTree != NULL) {
        printf("----- Final Parse Tree -----\n");
        printTree(finalTree, 0);
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}
