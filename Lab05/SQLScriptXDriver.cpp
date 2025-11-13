#include <bits/stdc++.h>
using namespace std;

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

extern "C" int yylex();
extern "C" char *yytext;
extern "C" int yylineno;

int main(int argc, char **argv) {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    unordered_map<int,string> typeName = {
        {KEYWORD, "KEYWORD"}, {IDENTIFIER, "IDENTIFIER"}, {INTEGER, "INTEGER"},
        {FLOAT, "FLOAT"}, {STRING, "STRING"}, {DOLLAR_STRING, "DOLLAR_STRING"},
        {HEX_STRING, "HEX_STRING"}, {PARAM, "PARAM"}, {OPERATOR, "OPERATOR"},
        {DELIM, "DELIM"}, {COMMENT_SINGLE, "COMMENT_SINGLE"}, {COMMENT_MULTI, "COMMENT_MULTI"},
        {ERROR_TOKEN, "ERROR"}
    };

    unordered_map<string,int> keywordFreq;
    unordered_set<string> identifiers;
    unordered_map<string,int> counts;

    int tok;
    // We will call yylex repeatedly and process tokens
    while ((tok = yylex()) != 0) {
        string lex(yytext ? yytext : "");
        string tname = typeName.count(tok) ? typeName[tok] : to_string(tok);

        // Print token line (grouped by current yylineno)
        cout << "Line " << yylineno << ": " << tname << "(" << lex << ")\n";

        // Update counts
        counts[tname]++;

        if (tok == KEYWORD) {
            string up = lex;
            for (auto &c: up) c = toupper((unsigned char)c);
            keywordFreq[up]++;
        } else if (tok == IDENTIFIER) {
            identifiers.insert(lex);
        }

        if (tok == ERROR_TOKEN) {
            cerr << "Line " << yylineno << ": ERROR -- malformed token near '" << lex << "'\n";
        }
    }

    // Summary
    cout << "\n--- SUMMARY ---\n";
    int total = 0;
    for (auto &p: counts) total += p.second;
    cout << "Total tokens: " << total << "\n";
    cout << "Per-type counts:\n";
    for (auto &p: counts) cout << "  " << p.first << ": " << p.second << "\n";

    cout << "\nKeyword frequencies:\n";
    for (auto &p: keywordFreq) cout << "  " << p.first << ": " << p.second << "\n";

    cout << "\nDistinct identifiers: " << identifiers.size() << "\n";

    return 0;
  }