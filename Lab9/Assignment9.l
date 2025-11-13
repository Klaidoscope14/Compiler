%{
    /*
        Name: Shreyas Kumar Jaiswal
        Roll: 2301CS52
    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// TreeNode structure definition
typedef struct TreeNode {
    char *data;
    struct TreeNode *left, *right;
} TreeNode;

// Function prototypes
TreeNode* createNode(const char *label);
TreeNode* createNodeWithChildren(const char *label, TreeNode *left, TreeNode *right);
void printTree(TreeNode *node, int depth);
void freeTree(TreeNode *tree);
#include "y.tab.h"
%}

%%

[ \t\n]                 ; // Ignore whitespace
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.node = createNode(yytext); return ID; }
"("                     { return '('; }
")"                     { return ')'; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }

.                       { return yytext[0]; } // Return any other character as itself

%%

int yywrap() {
    return 1;
}