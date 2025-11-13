#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX 500

typedef struct {
    char name[128];
    int count;
} Item;

Item commands[MAX];
Item envs[MAX];

int command_count = 0;
int env_count = 0;

int inline_math = 0;
int display_math = 0;
int total_comments = 0;

void add_command(const char *cmd) {
    for (int i = 0; i < command_count; i++) {
        if (strcmp(commands[i].name, cmd) == 0) {
            commands[i].count++;
            return;
        }
    }
    strcpy(commands[command_count].name, cmd);
    commands[command_count].count = 1;
    command_count++;
}

void add_environment(const char *env) {
    for (int i = 0; i < env_count; i++) {
        if (strcmp(envs[i].name, env) == 0) {
            envs[i].count++;
            return;
        }
    }
    strcpy(envs[env_count].name, env);
    envs[env_count].count = 1;
    env_count++;
}

void inc_inline_math() { inline_math++; }
void inc_display_math() { display_math++; }
void inc_comment() { total_comments++; }

#include "lex.yy.c"

int main() {
    yylex();

    printf("Commands used:\n");
    for (int i = 0; i < command_count; i++)
        printf("%s (%d)\n", commands[i].name, commands[i].count);

    printf("\nEnvironments used:\n");
    for (int i = 0; i < env_count; i++)
        printf("%s (%d)\n", envs[i].name, envs[i].count);

    printf("\nEquations found:\n");
    printf("%d inline equations found\n", inline_math);
    printf("%d displayed equations found\n", display_math);

    return 0;
}