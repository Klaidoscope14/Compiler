#include <bits/stdc++.h>
using namespace std;

// Declare yylex() from Flex
extern "C" int yylex();
extern FILE* yyin;

// Global counters
int h[7] = {0}; // h1..h6
int setext_h1 = 0, setext_h2 = 0;
int fenced_code_blocks = 0, inline_code_spans = 0;
int bold_cnt = 0, italic_cnt = 0;
int unordered_items = 0, ordered_items = 0;
int blockquotes = 0, horizontal_rules = 0;
int links = 0, images = 0;
int html_comments = 0, html_tags = 0;

// === Implement the functions you declared in the .l file ===
void count_heading(int level) {
    if (level >= 1 && level <= 6) h[level]++;
}
void count_fenced_code() { fenced_code_blocks++; }
void count_inline_code() { inline_code_spans++; }
void count_bold() { bold_cnt++; }
void count_italic() { italic_cnt++; }
void count_unordered() { unordered_items++; }
void count_ordered() { ordered_items++; }
void count_blockquote() { blockquotes++; }
void count_hr() { horizontal_rules++; }
void count_html_comment() { html_comments++; }
void count_html_tag() { html_tags++; }

// Stubs for now — later you’ll extract proper text + url
void add_link(char *text, char *url) { links++; }
void add_image(char *alt, char *url) { images++; }

// === Driver ===
int main(int argc, char** argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            cerr << "Error: cannot open file " << argv[1] << endl;
            return 1;
        }
    }
    yylex();

    cout << "Headings\n";
    cout << "h1: " << h[1] << ", h2: " << h[2] << ", h3: " << h[3]
         << ", h4: " << h[4] << ", h5: " << h[5] << ", h6: " << h[6] << "\n";
    cout << "setext_h1: " << setext_h1 << ", setext_h2: " << setext_h2 << "\n";

    cout << "Code\n";
    cout << "fenced_code_blocks: " << fenced_code_blocks << "\n";
    cout << "inline_code_spans: " << inline_code_spans << "\n";

    cout << "Emphasis\n";
    cout << "bold: " << bold_cnt << ", italic: " << italic_cnt << "\n";

    cout << "Lists\n";
    cout << "unordered_items: " << unordered_items
         << ", ordered_items: " << ordered_items << "\n";

    cout << "Block elements\n";
    cout << "blockquotes: " << blockquotes
         << ", horizontal_rules: " << horizontal_rules << "\n";

    cout << "Links & Images\n";
    cout << "links: " << links << ", images: " << images << "\n";

    cout << "HTML\n";
    cout << "html_comments: " << html_comments
         << ", inline_html_tags: " << html_tags << "\n";

    return 0;
}
