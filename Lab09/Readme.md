# Lex & Yacc Live Parse Tree Construction

## Overview

A bottom-up parser using **LEX** and **YACC** that dynamically constructs and displays a parse tree for arithmetic expressions. The grammar includes addition, subtraction, multiplication, division, unary minus, parentheses, and identifiers.

The system shows:

* **Shifting operations** performed by the lexer
* **Grammar rule reductions** performed by the parser
* **Dynamic partial parse tree** after each reduction
* **Final parse tree** after successful parsing
* **Syntax error detection** for invalid expressions

---

## Grammar Used

```
E → E + T | E - T | T
T → T * F | T / F | F
F → ( E ) | - F | id
```

---

## Requirements

Both files compile using:

```
yacc -d Assignment9.y
lex Assignment9.l
gcc lex.yy.c y.tab.c -o Assignment9 -ll
./Assignment9
```

No extra C/C++ files are needed — YACC generates all required code.

---

## Features Implemented

### ✔ Lexical Scanning

* Identifies tokens: id, +, -, *, /, (, )
* Prints **Shifting:** for each token matched

### ✔ Bottom-up Parsing (LALR(1))

* Displays every grammar rule reduction using **Reducing by:**

### ✔ Dynamic Parse Tree Construction

* After each reduction, prints a partial tree
* At completion, prints the full parse tree in a hierarchical format

### ✔ Error Handling

* Invalid expressions trigger: `Syntax Error`

---

## Example Input

```
( id + id ) * id
```

## Example Output (Excerpt)

```
Shifting: (
Shifting: id
Reducing by: F -> id
Current Partial Tree:
id
-----------------------
...
----- Final Parse Tree -----
*
|-- +
|   |-- id
|   |-- id
|-- id
```

---

## Running the Program

1. Compile YACC file:

```
yacc -d Assignment9.y
```

2. Compile Lex file:

```
lex Assignment9.l
```

3. Generate executable:

```
gcc lex.yy.c y.tab.c -o Assignment9 -ll
```

4. Run:

```
./Assignment9
```

Then input any valid arithmetic expression.

---

## Notes

* Unary minus is handled with `%prec UMINUS`.
* Identifiers follow regex: `[a-zA-Z][a-zA-Z0-9]*`
* Tree output follows left-child/right-child structure.