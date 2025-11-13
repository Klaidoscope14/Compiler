# Lex & Yacc Parser

This project implements a lexical analyzer and parser using **LEX** and **YACC** for validating simple C-style declarations and assignment statements. The program identifies tokens, checks syntax, reports detailed errors, and prints a summary of valid/invalid statements.

---

## ✔️ Features

* Recognizes keywords: `int`, `float`, `char`
* Identifies identifiers, numbers, character literals
* Handles assignment statements and declarations
* Supports arithmetic expressions with `+` and `*`
* Processes parentheses and detects unmatched `(` or `)`
* Detailed error reporting:

  * Missing identifier
  * Missing operand after `+` or `*`
  * Missing `)`
  * Invalid or unknown tokens
  * Invalid expressions inside parentheses
* Shows whether each statement is **VALID** or **INVALID**
* Prints a summary:

  * Total lines processed
  * Valid statements
  * Invalid statements

---

## 📁 Files Included

### **1. Assignment8.l**

LEX file that performs tokenization and prints token types.

### **2. Assignment8.y**

YACC file that defines grammar rules, handles errors, and validates statements.

Both files are comment-free as requested.

---

## ▶️ How to Compile and Run

Follow these steps in your terminal:

### **Step 1: Generate Parser (YACC)**

```
yacc -d Assignment8.y
```

This produces:

* `y.tab.c`
* `y.tab.h`

### **Step 2: Generate Lexer (LEX)**

```
lex Assignment8.l
```

This produces:

* `lex.yy.c`

### **Step 3: Compile Both Together**

```
gcc lex.yy.c y.tab.c -o Assignment8
```

### **Step 4: Run**

```
./Assignment8
```

Enter statements followed by `;`.
Press **Ctrl + D** to end input.

---

## 🧪 Example Input

```
int a;
a = 5 + 7;
float x = 3 * ;
char c = 'A';
```

## 🧾 Example Output (Simplified)

```
Token: int Type: KEYWORD
Token: a Type: IDENTIFIER
Token: ; Type: SEMICOLON
=> VALID STATEMENT

Token: a Type: IDENTIFIER
Token: = Type: ASSIGNMENT_OP
Token: 5 Type: NUMBER
Token: + Type: PLUS
Token: 7 Type: NUMBER
Token: ; Type: SEMICOLON
=> VALID STATEMENT

Token: float Type: KEYWORD
Token: x Type: IDENTIFIER
Token: = Type: ASSIGNMENT_OP
Token: 3 Type: NUMBER
Token: * Type: MUL
Token: ; Type: SEMICOLON
Syntax Error: missing operand after '*'
=> INVALID STATEMENT

Token: char Type: KEYWORD
Token: c Type: IDENTIFIER
Token: = Type: ASSIGNMENT_OP
Token: 'A' Type: CHAR_LITERAL
Token: ; Type: SEMICOLON
=> VALID STATEMENT

-------------------------------------------------------
Parsing completed.
Total lines processed : 4
Valid statements      : 3
Invalid statements    : 1
-------------------------------------------------------
```

---

## 📌 Notes

* Parentheses depth is tracked automatically.
* Unknown tokens are reported immediately.
* Error handling is designed to match assignment requirements.