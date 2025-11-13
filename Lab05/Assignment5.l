%option noyywrap
%option yylineno
%{
/* Shared token codes (match with driver) */
#define KEYWORD 256
#define IDENTIFIER 257
#define INTEGER 258
#define FLOAT 259
#define STRING 260
#define DOLLAR_STRING 261
#define HEX_STRING 262
#define PARAM 263
#define OPERATOR 264
#define DELIM 265
#define COMMENT_SINGLE 266
#define COMMENT_MULTI 267
#define ERROR_TOKEN 268

#include <string.h>
#include <stdio.h>

/* helper to normalize keywords to uppercase for driver convenience */
void uppercase(char *s) { for(char *p=s; *p; ++p) if(*p>='a' && *p<='z') *p = *p - 'a' + 'A'; }
%}

DIGIT          [0-9]
HEX            [0-9A-Fa-f]
ID_START       [A-Za-z_]
ID_CONT        [A-Za-z0-9_]
KW             (SELECT|INSERT|UPDATE|DELETE|CREATE|TABLE|INTO|VALUES|WHERE|AND|OR|NOT|LIKE|IN|BETWEEN|JOIN|ON|AS|GROUP|BY|ORDER|ASC|DESC|LIMIT|OFFSET|NULL|TRUE|FALSE)

%x DOLLAR QBCOMMENT

%%

/* Whitespace */
[ \t\r]+          { /* ignore */ }
"\n"              { /* newline handled by yylineno */ }

"--"[^\n]*        { /* single-line comment */ return COMMENT_SINGLE; }

"/*"               { BEGIN(QBCOMMENT); yytext[yyleng]=0; /* start block comment */ }
<QBCOMMENT>([^*]|\*+[^*/])*"*/"  { BEGIN(INITIAL); return COMMENT_MULTI; }
<QBCOMMENT>.        { /* consume */ }
<QBCOMMENT>\n       { /* newline consumed; yylineno increments automatically */ }

/* Dollar-quoted strings: $$...$$ or $tag$...$tag$ */
\$\$              { BEGIN(DOLLAR); yyless(0); /* enter DOLLAR start condition */ }
\$[A-Za-z0-9_]+\$  { BEGIN(DOLLAR); yyless(0); }

<DOLLAR>\$\$      { /* closing $$ */ BEGIN(INITIAL); return DOLLAR_STRING; }
<DOLLAR>\$[A-Za-z0-9_]+\$  { /* closing $tag$ */ BEGIN(INITIAL); return DOLLAR_STRING; }
<DOLLAR>(.|\n)+?   { /* collect until closer — let closing rule fire */ ; }

/* Quoted identifiers (double quotes) with doubled-quote escaping */
\"([^"]|\"\")*\"  { return IDENTIFIER; }
\[[^\]]+\]        { return IDENTIFIER; }

/* Hex byte string X'AB12' */
[Xx]'([0-9A-Fa-f]{2})+'  { return HEX_STRING; }
[Xx]'([0-9A-Fa-f])+'     { /* odd-length or non-even pairs */ return ERROR_TOKEN; }

/* Strings: single-quoted, support '' escaping and backslash escapes */
\'([^\\\']|\\[ntr'\\]|\'\')*\'  { return STRING; }

/* Parameters: :name, @name or ? */
\:[A-Za-z_][A-Za-z0-9_]*   { return PARAM; }
\@[A-Za-z_][A-Za-z0-9_]*   { return PARAM; }
\?                        { return PARAM; }

/* Numbers: integer and floats (simple) */
{DIGIT}+\.[{DIGIT}]*([eE][+-]?{DIGIT}+)?  { return FLOAT; }
{DIGIT}+([eE][+-]?{DIGIT}+)?               { return INTEGER; }

/* Operators and delimiters */
"<>"|"!="|"<="|">="  { return OPERATOR; }
[=<>+\-*/%]               { return OPERATOR; }
"||"                     { return OPERATOR; }
[(),;\.]                  { return DELIM; }

/* Keywords (case-insensitive) */
(?i){KW}                   { /* make sure driver sees original lexeme in yytext */ return KEYWORD; }

/* Identifiers */
{ID_START}{ID_CONT}*      { return IDENTIFIER; }

/* Anything else */
.                          { return ERROR_TOKEN; }

%%

/* No additional C code here — driver will read yytext and yylineno and process tokens */

int yywrap(void) { return 1; }