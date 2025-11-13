# SQLScriptX Lexer (Flex) + Driver + README

This canvas contains three files you can copy into your project:

1. `Assignment5.l` — Flex lexer for SQLScriptX
2. `SQLScriptXDriver.cpp` — C++ driver that calls the lexer, prints token lines, reports errors, and prints statistics
3. `README.md` — build / run instructions and notes

---

# SQLScriptX Lexer (Assignment5)

Files provided in this canvas:
- `Assignment5.l` — Flex lexer
- `SQLScriptXDriver.cpp` — C++ driver that prints tokens and collects statistics

## Build

```bash
flex Assignment5.l
g++ lex.yy.c SQLScriptXDriver.cpp -o sqlscriptx -lfl -std=c++17
````

If your system uses `libfl`, link with `-lfl`. On some systems flex already generates a C scanner which links without extra flags.

## Run

```bash
# Tokenize a SQL script
./sqlscriptx < script.sql

./sqlscriptx
```

## Notes & Implementation details

* The lexer attempts to recognize: keywords, identifiers (quoted and bracketed), integers, floats, single-quoted strings (with SQL-style escaping), dollar-quoted strings, hex byte strings (X'...'), parameters (:name, @name, ?), comments (-- and /* ... */), operators, and delimiters.
* The driver prints a line for each token in the format: `Line X: TYPE(lexeme)`.
* Errors are reported as `ERROR -- malformed token` to stderr and emitted as `ERROR` token in the stream.
* The driver collects statistics: total tokens, counts per type, keyword frequencies, and distinct identifiers.

## Limitations & Extensions

* Dollar-quoted and multi-line comment handling in this flex file uses start conditions but is intentionally concise. For production, you may want to improve buffering for large dollar tags and stronger validation (e.g., verify matching tags exactly in the lexer C code).
* Hex-string odd-length detection is handled approximately; you may want to validate exact even-byte length inside the lexer action and report precise error messages.