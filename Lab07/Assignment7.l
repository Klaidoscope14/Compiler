%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Declare functions and counters implemented in procmd.cpp (C++). Use C linkage. */
#ifdef __cplusplus
extern "C" {
#endif

/* counters and helpers implemented in driver */
void inc_atx_heading(int level);
void inc_setext_heading(int level);
void inc_fenced_code_blocks();
void inc_inline_code_spans();
void add_link(const char* text, const char* url);
void add_image(const char* alt, const char* url);
void inc_bold();
void inc_italic();
void inc_unordered();
void inc_ordered();
void inc_blockquote();
void inc_hr();
void add_html_comment(const char* text);
void add_inline_html_tag(const char* tag);
void report_token(int line, const char* type, const char* lexeme);
void report_error(int line, const char* desc, const char* nearlexeme);

#ifdef __cplusplus
}
#endif

/* helper for accumulating previous non-empty line (for Setext) */
char prev_line[8192];
int prev_line_len = 0;

%}

/* Start conditions */
%x FENCE

/* Patterns */
BACKSLASHED \\.
ATX        ^[ \t]*\#{1,6}[ ]    /* ATX heading start */
SETEXT_EQ  ^[ \t]*={3,}[ \t]*$
SETEXT_DASH ^[ \t]*-{3,}[ \t]*$
FENCE_OPEN ^[ \t]*```[^\n\r]*$
FENCE_CLOSE ^[ \t]*```[ \t]*$
INLINE_CODE  `[^`\n\r]+`
LINK_IMAGE   !?\[[^\]]+\]\([^\)]+\)
BOLD_ASTER  \*\*[^*\n\r]+\*\*
BOLD_UNDER  __[^_\n\r]+__
ITALIC_ASTER \*[^*\n\r]+\*
ITALIC_UNDER _[^_\n\r]+_
UL_ITEM     ^[ \t]*([-+*])[ \t]+
OL_ITEM     ^[ \t]*[0-9]+[.][ \t]+
BLOCKQUOTE  ^[ \t]*>[ \t]?
HR_LINE     ^[ \t]*((-{3,})|(_{3,})|(\*{3,}))[ \t]*$
HTML_COMMENT_OPEN <!--
INLINE_HTML_TAG <[A-Za-z][A-Za-z0-9]*(\s[^>]*)?>
ESCAPED_HASH \\#

%%

/* Keep track of whole lines for setext detection */
\n {
    /* store an empty line as prev_line */
    prev_line_len = 0;
    prev_line[0] = '\0';
    /* report newline as nothing */
}

/* Lines (capture whole-line content to check setext) */
^[^\n\r]*\n {
    /* Copy current line content trimmed of trailing newline */
    char *line = strdup(yytext);
    /* remove trailing newline */
    int L = strlen(line);
    if (L>0 && line[L-1]=='\n') line[L-1]='\0';

    /* Check ATX heading */
    if (sscanf(line, "%*[ \t]#%n", &L) == 0) {
        /* nothing */
    }
    /* ATX: count number of leading # then a space */
    {
        const char *p = line;
        while (*p==' ' || *p=='\t') p++;
        int hashes = 0;
        while (*p == '#') { hashes++; p++; }
        if (hashes>=1 && hashes<=6 && *p==' ') {
            inc_atx_heading(hashes);
            report_token( yylineno, "ATX_HEADING", line );
            free(line);
            prev_line_len = 0;
            prev_line[0]='\0';
            continue;
        }
    }

    /* Horizontal rule (line of --- or *** or ___) */
    if (strncmp(line, "---", 3)==0 || strncmp(line, "***",3)==0 || strncmp(line, "___",3)==0) {
        /* Rough detection: if mostly -,*,_ */
        int count = 0; int i;
        for (i=0; line[i]; ++i) if (line[i]=='-'||line[i]=='*'||line[i]=='_') count++;
        if (count >= 3) {
            inc_hr();
            report_token(yylineno, "HORIZONTAL_RULE", line);
            free(line);
            prev_line_len = 0;
            prev_line[0]='\0';
            continue;
        }
    }

    /* Blockquote */
    {
        const char *p = line;
        while (*p==' ') p++;
        if (*p == '>') {
            inc_blockquote();
            report_token(yylineno, "BLOCKQUOTE", line);
            free(line);
            prev_line_len = 0;
            prev_line[0]='\0';
            continue;
        }
    }

    /* Unordered list item */
    {
        const char *p = line;
        while (*p==' '||*p=='\t') p++;
        if (*p=='-'||*p=='+'||*p=='*') {
            const char *q = p+1;
            if (*q==' '||*q=='\t') {
                inc_unordered();
                report_token(yylineno, "UNORDERED_LIST_ITEM", line);
                free(line);
                prev_line_len = 0;
                prev_line[0]='\0';
                continue;
            }
        }
    }

    /* Ordered list item */
    {
        const char *p = line;
        while (*p==' '||*p=='\t') p++;
        if (isdigit((unsigned char)*p)) {
            const char *q = p;
            while (isdigit((unsigned char)*q)) q++;
            if (*q=='.') {
                inc_ordered();
                report_token(yylineno, "ORDERED_LIST_ITEM", line);
                free(line);
                prev_line_len = 0;
                prev_line[0]='\0';
                continue;
            }
        }
    }

    /* Fenced code block open */
    {
        const char *p = line;
        while (*p==' '||*p=='\t') p++;
        if (strncmp(p, "```", 3)==0) {
            inc_fenced_code_blocks();
            report_token(yylineno, "FENCED_CODE_OPEN", line);
            /* Enter FENCE state; consume until closing ``` */
            BEGIN(FENCE);
            free(line);
            prev_line_len = 0;
            prev_line[0]='\0';
            continue;
        }
    }

    /* Links and images inline detection within line: use simpler scanning */
    {
        char *s = line;
        char *pos = s;
        while ((pos = strchr(pos, '[')) != NULL) {
            /* check if image (![ ) */
            int is_image = (pos> s && *(pos-1)=='!');
            char *close_br = strchr(pos, ']');
            if (!close_br) break;
            if (*(close_br+1) == '(') {
                char *close_par = strchr(close_br+2, ')');
                if (!close_par) { pos = close_br+1; continue; }
                /* extract text and url */
                int tlen = close_br - (pos+1);
                int ulen = close_par - (close_br+2);
                char textbuf[4096] = {0}, urlbuf[4096] = {0};
                if (tlen>0) strncpy(textbuf, pos+1, tlen);
                if (ulen>0) strncpy(urlbuf, close_br+2, ulen);
                if (is_image) {
                    add_image(textbuf, urlbuf);
                    report_token(yylineno, "IMAGE", pos);
                } else {
                    add_link(textbuf, urlbuf);
                    report_token(yylineno, "LINK", pos);
                }
                pos = close_par + 1;
            } else {
                pos = close_br + 1;
            }
        }
    }

    /* Inline code spans */
    {
        const char *p = line;
        while ((p = strchr(p, '`')) != NULL) {
            const char *q = strchr(p+1, '`');
            if (!q) break;
            inc_inline_code_spans();
            /* produce token */
            char tmp[256] = {0};
            int l = q - p + 1;
            if (l < 255) {
                strncpy(tmp, p, l);
                tmp[l]=0;
                report_token(yylineno, "INLINE_CODE", tmp);
            } else report_token(yylineno, "INLINE_CODE", "`...`");
            p = q + 1;
        }
    }

    /* Bold (approx) */
    {
        char *p = line;
        while ((p = strstr(p, "**")) != NULL) {
            char *q = strstr(p+2, "**");
            if (!q) break;
            inc_bold();
            report_token(yylineno, "BOLD", p);
            p = q + 2;
        }
        p = line;
        while ((p = strstr(p, "__")) != NULL) {
            char *q = strstr(p+2, "__");
            if (!q) break;
            inc_bold();
            report_token(yylineno, "BOLD", p);
            p = q + 2;
        }
    }

    /* Italic (approx) */
    {
        char *p = line;
        while ((p = strchr(p, '*')) != NULL) {
            /* skip if part of bold ** handled earlier */
            if (*(p+1)=='*') { p+=2; continue; }
            char *q = strchr(p+1, '*');
            if (!q) break;
            inc_italic();
            report_token(yylineno, "ITALIC", p);
            p = q + 1;
        }
        p = line;
        while ((p = strchr(p, '_')) != NULL) {
            if (*(p+1)=='_') { p+=2; continue; }
            char *q = strchr(p+1, '_');
            if (!q) break;
            inc_italic();
            report_token(yylineno, "ITALIC", p);
            p = q + 1;
        }
    }

    /* HTML comment inline detection */
    if (strstr(line, "<!--") != NULL) {
        /* find end */
        char *start = strstr(line, "<!--");
        char *end = strstr(start, "-->");
        if (end) {
            int len = end - start + 3;
            char *buf = (char*)malloc(len+1);
            strncpy(buf, start, len);
            buf[len]=0;
            add_html_comment(buf);
            report_token(yylineno, "HTML_COMMENT", buf);
            free(buf);
        } else {
            add_html_comment(start);
            report_token(yylineno, "HTML_COMMENT", start);
        }
        free(line);
        prev_line_len = 0;
        prev_line[0]='\0';
        continue;
    }

    /* Inline HTML tag detection */
    if (strchr(line, '<')) {
        /* naive: find tags like <tag ...> */
        char *p = line;
        while ((p = strchr(p, '<')) != NULL) {
            if (isalpha((unsigned char)*(p+1))) {
                char *q = strchr(p, '>');
                if (q) {
                    int len = q - p + 1;
                    char *buf = (char*)malloc(len+1);
                    strncpy(buf, p, len);
                    buf[len]=0;
                    add_inline_html_tag(buf);
                    report_token(yylineno, "INLINE_HTML_TAG", buf);
                    free(buf);
                    p = q+1;
                } else break;
            } else p++;
        }
    }

    /* Setext heading detection: if previous non-empty line exists and this line is === or --- */
    {
        if (prev_line_len > 0) {
            /* check if this current line is === (h1) or --- (h2) */
            int only_eq = 1, only_dash = 1;
            int i; 
            for (i=0; line[i]; ++i){
                if (line[i] != '=' && line[i] != ' ' && line[i] != '\t') only_eq = 0;
                if (line[i] != '-' && line[i] != ' ' && line[i] != '\t') only_dash = 0;
            }
            if (only_eq) {
                inc_setext_heading(1);
                report_token(yylineno, "SETEXT_H1", prev_line);
                /* clear prev_line */
                prev_line_len = 0; prev_line[0] = '\0';
                free(line);
                continue;
            } else if (only_dash) {
                inc_setext_heading(2);
                report_token(yylineno, "SETEXT_H2", prev_line);
                prev_line_len = 0; prev_line[0] = '\0';
                free(line);
                continue;
            }
        }
    }

    /* If reached here, store non-empty line as prev_line for possible setext */
    {
        /* check if line has non-whitespace */
        int has_nonws = 0; int i;
        for (i=0; line[i]; ++i) if (line[i] != ' ' && line[i] != '\t') { has_nonws = 1; break; }
        if (has_nonws) {
            strncpy(prev_line, line, sizeof(prev_line)-1);
            prev_line_len = strlen(prev_line);
        } else {
            prev_line_len = 0;
            prev_line[0] = '\0';
        }
    }

    /* report generic line token */
    report_token(yylineno, "LINE", line);
    free(line);
}

/* FENCE state: consume lines until closing ``` */
<FENCE>{
    ^[^\n\r]*\n {
        char *line = strdup(yytext);
        /* check closing fence */
        const char *p=line;
        while (*p==' '||*p=='\t') p++;
        if (strncmp(p, "```", 3)==0) {
            report_token(yylineno, "FENCED_CODE_CLOSE", p);
            BEGIN(INITIAL);
            free(line);
            continue;
        } else {
            /* inside code block: ignore markdown constructs, but optionally report CODE_LINE */
            report_token(yylineno, "FENCED_CODE_LINE", p);
            free(line);
            continue;
        }
    }
}

/* ESCAPED characters: ignore and output as text token */
{BACKSLASHED} { report_token(yylineno, "ESCAPED", yytext); }

/* Anything else (single chars) */
.   { /* ignore or report if printable */ }

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}