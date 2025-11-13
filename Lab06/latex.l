%{
#include <stdio.h>
#include <string.h>

extern void add_command(const char *cmd);
extern void add_environment(const char *env);
extern void inc_inline_math();
extern void inc_display_math();
extern void inc_comment();

int display_math_mode = 0;
%}

%%

"\\begin{"[a-zA-Z*]+ "}" {
    char env[128];
    sscanf(yytext, "\\begin{%127[^}]", env);
    add_environment(env);
}

"\\end{"[a-zA-Z*]+ "}"   { /* ignore end */ }

"\\[" { display_math_mode = 1; inc_display_math(); }
"\\]" { display_math_mode = 0; }

"\$\$" {
    if (!display_math_mode) {
        display_math_mode = 1;
        inc_display_math();
    } else {
        display_math_mode = 0;
    }
}

"\$" { inc_inline_math(); }

"%"[^\n]*   { inc_comment(); }

"\\~"        { add_command("~"); }
"~"         { add_command("~"); }

"\\\\"      { add_command("\\"); }

"\\"[a-zA-Z]+ {
    add_command(yytext);
}

"\\". {
    char cmd[3];
    cmd[0] = yytext[1];
    cmd[1] = '\0';
    add_command(cmd);
}

.|\n ;

%%

int yywrap() { return 1; }