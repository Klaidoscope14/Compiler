# Markdown Structural Analyzer

Implements a Markdown structural analyzer using **Flex (Lex)** and **C++**. The analyzer scans a Markdown file and identifies various structural components such as headings, code blocks, links, emphasis markers, lists, HTML tags, and more. It also outputs a summary report of all elements detected.

---

## 📂 Project Files

### **1. Assignment7.l**

* Flex (Lex) specification file.
* Implements token recognition for Markdown constructs.
* Handles:

  * ATX headings (`#`)
  * Setext headings (`===`, `---`)
  * Fenced code blocks (```)
  * Inline code spans
  * Links & images
  * Bold & italic text
  * Ordered & unordered lists
  * Horizontal rules
  * Blockquotes
  * HTML comments & inline HTML tags
* Uses start conditions to handle fenced code blocks.

### **2. procmd.cpp**

* C++ driver that:

  * Maintains counters and tables.
  * Defines helper functions invoked by the lexer.
  * Prints per-token output: `Line X: TOKEN(lexeme)`.
  * Prints the final summary report (headings, code blocks, links, stats, etc.).

---

## 🛠️ How to Build

Ensure you have **Flex** and **g++** installed.

### **Step 1: Generate the Lexer**

```bash
flex -o lex.yy.c Assignment7.l
```

### **Step 2: Compile**

```bash
g++ -std=c++17 procmd.cpp lex.yy.c -lfl -o procmd
```

### **Step 3: Run with Input Markdown File**

```bash
./procmd < sample.md
```

---

## 📌 Output Format

During scanning, the lexer prints:

````
Line 3: ATX_HEADING(# Introduction)
Line 7: LINK([xyz](https://xyz.com))
Line 12: FENCED_CODE_OPEN(```)
...
````

At EOF, the summary is printed:

```
h1: X, h2: Y, h3: Z, ...
setext_h1: A, setext_h2: B

fenced_code_blocks: N
inline_code_spans: M

bold: P, italic: Q

unordered_items: R, ordered_items: S

blockquotes: T, horizontal_rules: U

links: V, images: W

Top 10 link texts
- text1 (count)
- text2 (count)
...

Top 10 domains
...

Top 10 image alt texts
...

html_comments: H, inline_html_tags: I
```

---

## 📄 Notes

* Setext headings are detected based on previous non-empty line.
* Code blocks use `FENCE` state to correctly capture content until closing ```.
* URL domain extraction is simplified but handles standard URLs.
* Bold/italic detection uses simple pattern matches.
* The analyzer prints **every recognized token** as required by the assignment.