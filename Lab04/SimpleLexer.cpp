#include <cstdio>

extern "C" int yylex(void);
extern "C" void print_stats(void);

int main(int argc, char **argv) {
    yylex();
    print_stats();
    return 0;
}