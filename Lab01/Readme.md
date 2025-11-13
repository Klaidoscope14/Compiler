# Expression Evaluator – Recursive Descent Parser (C++)

This project implements a simple arithmetic expression evaluator using **recursive descent parsing**.
It supports:

* Integer numbers
* Addition (`+`)
* Multiplication (`*`)
* Parentheses (`(` `)`)
* Automatic error detection for invalid expressions

The grammar used:

```
Sum     → Term { + Term }
Term    → Factor { * Factor }
Factor  → Number | ( Sum )
Number  → Digit { Digit }
```

## Features

* Fully recursive implementation
* Detects malformed expressions
* Ignores whitespace
* Prints `Invalid expression