# SimpleLang Lexer 

## Overview

This repository contains a Flex lexical analyzer for **SimpleLang** . The lexer recognizes keywords, identifiers, integers, floats (including scientific notation), hexadecimal integers, string literals with escape sequences, operators, delimiters, comments (single- and multi-line), and simple preprocessor directives (`#include`). It reports tokens with line numbers, handles basic error recovery, and prints statistics at the end.

## Files

* `Assignment4.l` — Flex lexer source (main submission file)
* `SimpleLexer.cpp` — C++ driver that invokes the lexer and prints statistics
* `program.sl` — (optional) example/test input (create locally to test)

## Features

* Token categories: KEYWORD, IDENTIFIER, INTEGER, FLOAT, HEX_INTEGER, STRING, OPERATOR, DELIMITER, PREPROCESSOR, COMMENT_SINGLE, COMMENT_MULTI
* String support with escape sequences: `\n`, `\t`, `\"`, `\\`
* Numeric formats: decimal integers, floats (with optional scientific notation), hex literals `0x...`
* Comment handling: `//` single-line and `/* ... */` multi-line (with unterminated comment error)
* Preprocessor recognition for `#include` lines
* Error reporting with line numbers for unknown tokens, unterminated strings/comments
* Token statistics printed after lexing: counts per category and totals

## Build Instructions

1. Generate the lexer C source using `flex`:

```bash
flex Assignment4.l
```

2. Compile the generated `lex.yy.c` together with the C++ driver:

```bash
g++ lex.yy.c SimpleLexer.cpp -o simplelexer -lfl
```

3. Run the lexer on an input file (`program.sl`) or interactively:

```bash
./simplelexer < program.sl
# or
./simplelexer
```

## Example Output Format

Tokens are printed as:

```
Line <n>: <TOKEN_TYPE> (<lexeme>)
```

At the end, a statistics summary is printed showing totals and distribution across token types.

## Testing Suggestions

Create `program.sl` with examples covering:

* Keywords and identifiers
* Integers, floats (including `1.23e4`) and hex (`0xABCD`)
* Strings with `\n`, `\"` and an unterminated string test
* Single-line `//` and multi-line `/* */` comments and an unterminated comment test
* Operators `==`, `!=`, `&&`, `||`, `+`, `-`, `*`, `/`, `=`, `<`, `>`
* Delimiters `(`, `)`, `{`, `}`, `;`, `,`

## Notes & Hints

* The lexer uses Flex exclusive start conditions for proper handling of string and comment modes.
* Whitespace is ignored except for tracking line numbers.
* If you need the code adapted to a C driver (`SimpleLexer.c`) or want tokens printed with column offsets or CSV output for automated grading, request an update.