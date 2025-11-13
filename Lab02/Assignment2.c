#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>

#define MAX_LINE 1024

static const char *input;
static int pos;
static char err_msg[128];
static int err_flag;

typedef struct {
    int defined;
    int value;
} Var;

static Var symbols[52];

static void set_error(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(err_msg, sizeof(err_msg), fmt, ap);
    va_end(ap);
    err_flag = 1;
}

static int var_index(char c) {
    if (c >= 'A' && c <= 'Z') return c - 'A';
    if (c >= 'a' && c <= 'z') return 26 + (c - 'a');
    return -1;
}

static void skip_ws() {
    while (input[pos] && isspace((unsigned char)input[pos])) pos++;
}

static char peek_char() {
    skip_ws();
    return input[pos];
}

static int match_char(char c) {
    skip_ws();
    if (input[pos] == c) { pos++; return 1; }
    return 0;
}

static long parseExpression();

static long parseNumber() {
    skip_ws();
    if (!isdigit((unsigned char)input[pos])) {
        set_error("Error: Invalid syntax");
        return 0;
    }
    long val = 0;
    while (isdigit((unsigned char)input[pos])) {
        val = val * 10 + (input[pos] - '0');
        pos++;
    }
    return val;
}

static long parseFactor() {
    skip_ws();
    if (err_flag) return 0;
    char c = input[pos];
    if (c == '(') {
        pos++;
        long val = parseExpression();
        if (err_flag) return 0;
        skip_ws();
        if (input[pos] != ')') {
            set_error("Error: Invalid syntax");
            return 0;
        }
        pos++;
        return val;
    }
    if (c == '+' || c == '-') {
        pos++;
        long f = parseFactor();
        if (err_flag) return 0;
        return (c == '-') ? -f : f;
    }
    if (isalpha((unsigned char)c)) {
        pos++;
        int idx = var_index(c);
        if (idx < 0) { set_error("Error: Invalid variable"); return 0; }
        if (!symbols[idx].defined) {
            char msg[64];
            snprintf(msg, sizeof(msg), "Error: Variable '%c' is not defined", c);
            set_error("%s", msg);
            return 0;
        }
        return symbols[idx].value;
    }
    if (isdigit((unsigned char)c)) {
        return parseNumber();
    }
    set_error("Error: Invalid syntax");
    return 0;
}

static long parseTerm() {
    skip_ws();
    long val = parseFactor();
    if (err_flag) return 0;
    while (1) {
        skip_ws();
        char op = input[pos];
        if (op == '*' || op == '/' || op == '%') {
            pos++;
            long rhs = parseFactor();
            if (err_flag) return 0;
            if (op == '*') val = val * rhs;
            else if (op == '/') {
                if (rhs == 0) { set_error("Error: Division by zero"); return 0; }
                val = val / rhs;
            } else {
                if (rhs == 0) { set_error("Error: Division by zero"); return 0; }
                val = val % rhs;
            }
        } else break;
    }
    return val;
}

static long parseExpression() {
    skip_ws();
    long val = parseTerm();
    if (err_flag) return 0;
    while (1) {
        skip_ws();
        char op = input[pos];
        if (op == '+' || op == '-') {
            pos++;
            long rhs = parseTerm();
            if (err_flag) return 0;
            if (op == '+') val = val + rhs;
            else val = val - rhs;
        } else break;
    }
    return val;
}

static int is_all_word(const char *s, const char *word) {
    int wlen = strlen(word);
    int i = 0;
    while (s[i] && isspace((unsigned char)s[i])) i++;
    for (int j = 0; j < wlen; ++j) {
        if (s[i+j] != word[j]) return 0;
    }
    i += wlen;
    while (s[i] && isspace((unsigned char)s[i])) i++;
    return s[i] == '\0';
}

int main() {
    char line[MAX_LINE];
    while (1) {
        printf("> ");
        if (!fgets(line, sizeof(line), stdin)) {
            printf("\n");
            break;
        }
        size_t ln = strlen(line);
        if (ln > 0 && line[ln-1] == '\n') line[ln-1] = '\0';

        if (is_all_word(line, "quit") || is_all_word(line, "exit")) {
            printf("Goodbye!\n");
            break;
        }

        input = line;
        pos = 0;
        err_flag = 0;
        err_msg[0] = '\0';

        skip_ws();
        char first = input[pos];

        if (isalpha((unsigned char)first)) {
            int saved_pos = pos;
            pos++;
            skip_ws();
            if (input[pos] == '=') {
                char var = input[saved_pos];
                pos++;
                long val = parseExpression();
                if (!err_flag) {
                    skip_ws();
                    if (input[pos] != '\0') set_error("Error: Invalid syntax");
                }
                if (err_flag) {
                    printf("%s\n", err_msg);
                    continue;
                }
                int idx = var_index(var);
                symbols[idx].defined = 1;
                symbols[idx].value = (int)val;
                printf("%c = %d\n", var, (int)val);
                continue;
            } else {
                pos = 0;
            }
        }

        long result = parseExpression();
        if (!err_flag) {
            skip_ws();
            if (input[pos] != '\0') set_error("Error: Invalid syntax");
        }
        if (err_flag) {
            printf("%s\n", err_msg);
        } else {
            printf("%ld\n", result);
        }
    }
    return 0;
}