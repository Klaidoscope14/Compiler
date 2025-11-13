#include <bits/stdc++.h>
using namespace std;

/* Global counters */
extern "C" {
    int g_h[7] = {0}; /* h[1]..h[6] */
    int g_setext_h1 = 0;
    int g_setext_h2 = 0;
    int g_fenced_code_blocks = 0;
    int g_inline_code_spans = 0;
    int g_bold = 0;
    int g_italic = 0;
    int g_unordered = 0;
    int g_ordered = 0;
    int g_blockquotes = 0;
    int g_horizontal_rules = 0;
    int g_links = 0;
    int g_images = 0;
    int g_html_comments = 0;
    int g_inline_html_tags = 0;
}

/* Tables */
static unordered_map<string,int> link_text_counts;
static unordered_map<string,int> domain_counts;
static unordered_map<string,int> image_alt_counts;

/* Utility: extract domain from URL (basic) */
static string extract_domain(const string &url) {
    // naive extraction: remove scheme, then get host upto / or :
    size_t i = 0;
    if (url.compare(0, 7, "http://")==0) i = 7;
    else if (url.compare(0, 8, "https://")==0) i = 8;
    else if (url.compare(0, 4, "www.")==0) i = 0;
    string rem = url.substr(i);
    size_t slash = rem.find('/');
    if (slash != string::npos) rem = rem.substr(0, slash);
    // remove possible credentials or port
    size_t at = rem.find('@');
    if (at != string::npos) rem = rem.substr(at+1);
    size_t colon = rem.find(':');
    if (colon != string::npos) rem = rem.substr(0, colon);
    // lowercase
    string dom;
    dom.reserve(rem.size());
    for (char c: rem) dom.push_back(tolower((unsigned char)c));
    return dom;
}

/* Functions used by lexer (C linkage) */
extern "C" {

void inc_atx_heading(int level) {
    if (level>=1 && level<=6) g_h[level]++;
}
void inc_setext_heading(int level) {
    if (level==1) g_setext_h1++;
    else if (level==2) g_setext_h2++;
}
void inc_fenced_code_blocks() { g_fenced_code_blocks++; }
void inc_inline_code_spans() { g_inline_code_spans++; }
void add_link(const char* text, const char* url) {
    g_links++;
    string t = text ? text : "";
    string u = url ? url : "";
    if (t.size()==0) t = "<empty>";
    link_text_counts[t]++;
    string d = extract_domain(u);
    if (d.size()==0) d = "<unknown>";
    domain_counts[d]++;
}
void add_image(const char* alt, const char* url) {
    g_images++;
    string a = alt ? alt : "";
    if (a.size()==0) a = "<empty>";
    image_alt_counts[a]++;
}
void inc_bold() { g_bold++; }
void inc_italic() { g_italic++; }
void inc_unordered() { g_unordered++; }
void inc_ordered() { g_ordered++; }
void inc_blockquote() { g_blockquotes++; }
void inc_hr() { g_horizontal_rules++; }
void add_html_comment(const char* text) { g_html_comments++; (void)text; }
void add_inline_html_tag(const char* tag) { g_inline_html_tags++; (void)tag; }

/* Reporting: for each token the lexer calls this to print Line X: TYPE(lexeme) */
void report_token(int line, const char* type, const char* lexeme) {
    if (!type) return;
    string lex = lexeme ? lexeme : "";
    // Trim newline for printing
    size_t p = lex.find('\n');
    if (p != string::npos) lex = lex.substr(0,p);
    cout << "Line " << line << ": " << type << "(" << lex << ")" << "\n";
}
void report_error(int line, const char* desc, const char* nearlexeme) {
    string near = nearlexeme ? nearlexeme : "";
    cout << "Line " << line << ": ERROR -- " << desc << " (near " << near << ")\n";
}

} // extern "C"

/* Helper to print top N from map */
static vector<pair<string,int>> top_n(const unordered_map<string,int>& m, int n) {
    vector<pair<string,int>> v(m.begin(), m.end());
    sort(v.begin(), v.end(), [](auto &a, auto &b){
        if (a.second != b.second) return a.second > b.second;
        return a.first < b.first;
    });
    if ((int)v.size() > n) v.resize(n);
    return v;
}

/* At program exit, print summary exactly in required order */
static void print_summary() {
    // Headings
    cout << "\n";
    cout << "h1: " << g_h[1] << ", h2: " << g_h[2] << ", h3: " << g_h[3]
         << ", h4: " << g_h[4] << ", h5: " << g_h[5] << ", h6: " << g_h[6] << "\n";
    cout << "setext_h1: " << g_setext_h1 << ", setext_h2: " << g_setext_h2 << "\n\n";

    // Code
    cout << "fenced_code_blocks: " << g_fenced_code_blocks << "\n\n";
    cout << "inline_code_spans: " << g_inline_code_spans << "\n\n";

    // Emphasis
    cout << "bold: " << g_bold << ", italic: " << g_italic << "\n\n";

    // Lists
    cout << "unordered_items: " << g_unordered << ", ordered_items: " << g_ordered << "\n\n";

    // Block elements
    cout << "blockquotes: " << g_blockquotes << ", horizontal_rules: " << g_horizontal_rules << "\n\n";

    // Links & Images
    cout << "links: " << g_links << ", images: " << g_images << "\n\n";

    // Top 10 link texts
    cout << "Top 10 link texts\n";
    auto top_links = top_n(link_text_counts, 10);
    for (auto &p: top_links) {
        cout << "- " << p.first << " (" << p.second << ")\n";
    }
    if (top_links.empty()) cout << "(none)\n";
    cout << "\n";

    // Top 10 domains
    cout << "Top 10 domains\n";
    auto top_domains = top_n(domain_counts, 10);
    for (auto &p: top_domains) {
        cout << "- " << p.first << " (" << p.second << ")\n";
    }
    if (top_domains.empty()) cout << "(none)\n";
    cout << "\n";

    // Top 10 image alt texts
    cout << "Top 10 image alt texts\n";
    auto top_imgs = top_n(image_alt_counts, 10);
    for (auto &p: top_imgs) {
        cout << "- " << p.first << " (" << p.second << ")\n";
    }
    if (top_imgs.empty()) cout << "(none)\n";
    cout << "\n";

    // HTML
    cout << "html_comments: " << g_html_comments << ", inline_html_tags: " << g_inline_html_tags << "\n";
}

/* Register atexit handler */
static void at_exit_wrapper() {
    print_summary();
}

int main(int argc, char** argv) {
    atexit(at_exit_wrapper);
}