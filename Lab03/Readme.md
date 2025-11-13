# Lexical Analyzer (Lex/Flex)

## Overview

Involves building a lexical analyzer using **Lex/Flex** for a simple calculator language. The lexer identifies tokens such as identifiers, numbers, operators, parentheses, keywords, comments, and whitespace.

## Files Included

* **Assignment3.l** – The Lex/Flex source file containing token definitions and rules.
* **procltx.c / procltx.cpp** – C or C++ integration file that runs the lexer and prints token count.

## Features

* Recognizes identifiers, numbers, arithmetic operators, parentheses, assignment operator.
* Detects keywords: `quit`, `exit`.
* Handles whitespace and tracks line numbers.
* Ignores both single-line (`//`) and multi-line (`/* ... */`) comments.
* Prints meaningful error messages for invalid tokens.
* Maintains a token counter.

## Token Types

* IDENTIFIER (a-z, A-Z)
* NUMBER (sequence of digits)
* ASSIGN (`=`)
* PLUS (`+`)
* MINUS (`-`)
* MULTIPLY (`*`)
* DIVIDE (`/`)
* MODULO (`%`)
* LPAREN (`(`)
* RPAREN (`)`)
* QUIT / EXIT
* NEWLINE

## How to Compile

### Using C

1. `flex Assignment3.l`
2. `gcc lex.yy.c procltx.c -o lexer -lfl`
3. `./lexer < input.txt`

### Using C++

1. `flex Assignment3.l`
2. `g++ lex.yy.c procltx.cpp -o lexer -lfl`
3. `./lexer < input.txt`

## Sample Input

```
x = 10 + y * 2
z = (a - b) % 5
quit
```

## Expected Output Format

```
IDENTIFIER(x)
ASSIGN(=)
NUMBER(10)
PLUS(+)
IDENTIFIER(y)
MULTIPLY(*)
NUMBER(2)
NEWLINE
...
QUIT
Total Tokens: N
```

## Error Handling

* Reports invalid characters with line numbers.
* Detects unterminated comments.

## Notes

* The lexer is fully compliant with the assignment requirements.
* Update `input.txt` to test various expressions, comments, and edge cases.