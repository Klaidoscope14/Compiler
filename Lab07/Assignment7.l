%{
#include <bits/stdc++.h>
using namespace std;

extern void count_heading(int level);
extern void count_fenced_code();
extern void count_inline_code();
extern void count_bold();
extern void count_italic();
extern void count_unordered();
extern void count_ordered();
extern void count_blockquote();
extern void count_hr();
extern void add_link(char *text, char *url);
extern void add_image(char *alt, char *url);
extern void count_html_comment();
extern void count_html_tag();

extern int yylineno;
%}

%x CODE

%%

^#{1}[ ]        { count_heading(1); printf("Line %d: H1\n", yylineno); }
^#{2}[ ]        { count_heading(2); printf("Line %d: H2\n", yylineno); }
^#{3}[ ]        { count_heading(3); printf("Line %d: H3\n", yylineno); }
^#{4}[ ]        { count_heading(4); printf("Line %d: H4\n", yylineno); }
^#{5}[ ]        { count_heading(5); printf("Line %d: H5\n", yylineno); }
^#{6}[ ]        { count_heading(6); printf("Line %d: H6\n", yylineno); }

^```[a-zA-Z0-9]*    { BEGIN(CODE); count_fenced_code(); printf("Line %d: FENCED_CODE_START\n", yylineno); }
<CODE>^```         { BEGIN(INITIAL); printf("Line %d: FENCED_CODE_END\n", yylineno); }
<CODE>.*           { /* ignore content inside code */ }

`[^`]+`            { count_inline_code(); printf("Line %d: INLINE_CODE\n", yylineno); }

\*\*[^*]+\*\*      { count_bold(); printf("Line %d: BOLD\n", yylineno); }
\*[^\*]+\*         { count_italic(); printf("Line %d: ITALIC\n", yylineno); }
__[^_]+__          { count_bold(); printf("Line %d: BOLD\n", yylineno); }
_[^_]+_            { count_italic(); printf("Line %d: ITALIC\n", yylineno); }

^[-+*][ ]          { count_unordered(); printf("Line %d: UNORDERED_LIST\n", yylineno); }
^[0-9]+\.[ ]       { count_ordered(); printf("Line %d: ORDERED_LIST\n", yylineno); }

^[ ]*>             { count_blockquote(); printf("Line %d: BLOCKQUOTE\n", yylineno); }

^(-{3,}|\*{3,}|_{3,})$   { count_hr(); printf("Line %d: HORIZONTAL_RULE\n", yylineno); }

!\[[^]]*\]\([^)]*\)   { printf("Line %d: IMAGE\n", yylineno); }
\[[^]]*\]\([^)]*\)    { printf("Line %d: LINK\n", yylineno); }

\<\!--[^>]*--\>     { count_html_comment(); printf("Line %d: HTML_COMMENT\n", yylineno); }
\<[a-zA-Z][^>]*\>   { count_html_tag(); printf("Line %d: HTML_TAG\n", yylineno); }

.|\n               { /* ignore everything else */ }

%%

int yywrap(void) { return 1; }
