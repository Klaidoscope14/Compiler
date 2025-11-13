%{
    /*
        Name: Shreyas Kumar Jaiswal
        Roll: 2301CS52
    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// TreeNode structure definition
typedef struct TreeNode
{
    char *data;
    struct TreeNode *left, *right;
} TreeNode;

// Function prototypes
TreeNode* createNode(const char *label);
TreeNode* createNodeWithChildren(const char *label, TreeNode *left, TreeNode *right);
void printTree(TreeNode *node, int depth);
void freeTree(TreeNode *tree);
void yyerror(const char *msg);
int yylex(void);

TreeNode *final_tree = NULL; // Global variable to store the final parse tree
%}

%union
{
    TreeNode *node;   // Known because typedef above
}

%token <node> ID
%type <node> E T F

%%


E: E '+' T
{
        printf("Reducing by: E -> E + T\n");
        $$ = createNodeWithChildren("+", $1, $3);
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | E '-' T
 {
        printf("Reducing by: E -> E - T\n");
        $$ = createNodeWithChildren("-", $1, $3);
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | T
 {
        printf("Reducing by: E -> T\n");
        $$ = $1;
        printTree($$, 0);
        printf("-----------------------\n");
    }
 ;

T: T '*' F
{
        printf("Reducing by: T -> T * F\n");
        $$ = createNodeWithChildren("*", $1, $3);
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | T '/' F
 {
        printf("Reducing by: T -> T / F\n");
        $$ = createNodeWithChildren("/", $1, $3);
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | F
 {
        printf("Reducing by: T -> F\n");
        $$ = $1;
        printTree($$, 0);
        printf("-----------------------\n");
    }
 ;

F: '(' E ')'
{
        printf("Reducing by: F -> ( E )\n");
        $$ = $2;
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | '-' F
 {
        printf("Reducing by: F -> - F\n");
        $$ = createNodeWithChildren("-", NULL, $2);
        printTree($$, 0);
        printf("-----------------------\n");
    }
 | ID
 {
        printf("Reducing by: F -> id\n");
        $$ = $1;
        printTree($$, 0);
        printf("-----------------------\n");
    }
 ;

%%

// Tree function implementations

TreeNode* createNode(const char *label)
{
    TreeNode *node = (TreeNode*)malloc(sizeof(TreeNode));
    node->data = strdup(label);
    node->left = node->right = NULL;
    return node;
}

TreeNode* createNodeWithChildren(const char *label, TreeNode *left, TreeNode *right)
{
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->data = strdup(label);
    node->left = left;
    node->right = right;
    return node;
}

void printTree(TreeNode *node, int depth)
{
    if (node == NULL) return;

    // Print indentation for the current depth
    for (int i = 0; i < depth; i++)
    {
        if (i == depth - 1)
        {
            printf("|-- ");
        }
        else
        {
            printf("|   ");
        }
    }

    // Print the current node's data
    printf("%s\n", node->data);

    // Recursively print the left and right children
    printTree(node->left, depth + 1);
    printTree(node->right, depth + 1);
}

void freeTree(TreeNode *tree)
{
    if (tree == NULL) return;
    freeTree(tree->left);
    freeTree(tree->right);
    free(tree->data);
    free(tree);
}

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main()
{
    if (yyparse() == 0)
    {
        printf("----- Final Parse Tree -----\n");
        // Final parse tree is printed during last reduction
    }
    else
    {
        printf("Parsing failed due to syntax error.\n");
    }
    freeTree(final_tree); // Free the memory used by the parse tree
    return 0;
}
