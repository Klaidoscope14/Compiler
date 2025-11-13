# Lex + Yacc parser

---

## Description

This project implements a Lex + Yacc parser that recognizes a simplified C-like subset containing `if-else`, `while`, and assignment statements. The parser dynamically builds and displays a parse tree as the grammar rules are reduced and prints a final parse tree when parsing completes.

Key behaviors:

* Shows tokens as they are scanned (`Shifting:`)
* Prints grammar rule reductions (`Reducing by:`)
* Displays the partial parse tree after each reduction
* Prints the final parse tree at the end
* Reports syntax errors (missing braces/parentheses/keywords)

---

## Prerequisites

* Linux / macOS terminal
* `lex` (flex) and `yacc` (bison or original yacc) installed
* `gcc` compiler

---

## Compile & Run

Run these commands in the project directory:

```bash
yacc -d Assignment11.y
lex Assignment11.l
gcc lex.yy.c y.tab.c -o Assignment11 -ll
./Assignment11
```

When the program runs it will prompt for input. Enter a C-like statement (or sequence of statements) ending with semicolons and braces as required.

---

## Supported Grammar (summary)

* `if ( C ) { S }`
* `if ( C ) { S } else { S }`
* `while ( C ) { S }`
* `id = E;` where `E` supports `+`, `-`, `*`, `/` and numeric literals
* `C` supports relational operators: `< > <= >= == !=` and single `id` conditions

---

## Example Inputs

```
if ( x > y ) { x = x + 1; } else { y = y + 1; }

while (i < n) { if (a > b) { a = b; } }
```

## Example Output (high-level)

Program prints lines like:

* `Shifting: if` (when tokens are scanned)
* `Reducing by: C → id RELOP id` (when a reduction occurs)
* A small partial parse tree after each reduction
* `----- Final Parse Tree -----` followed by the full tree

---

## Error Handling

The parser reports syntax errors such as:

* Missing parentheses `(` or `)`
* Missing braces `{` or `}`
* Unexpected / invalid tokens

Example invalid input: `if ( x > y { x = x + 1; }` will produce a syntax error report.

---

## Testing Tips

* Test nested constructs (if inside while, while inside if).
* Test assignments with chained arithmetic expressions to ensure operator reductions print correctly.
* Add deliberate syntax mistakes to verify error messages.

---

## Notes

* Replace the placeholder roll number at the top of each source file as required by the assignment instructions.
* Keep `yywrap()` and memory allocation behavior in mind if testing many inputs; the example implementation uses `strdup` and `malloc`.