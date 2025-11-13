# Boolean Expression Parser using LEX & YACC

## 📌 Overview

Implements a complete **Boolean Expression Parser** using **LEX** and **YACC**, supporting operator precedence, associativity, lexical scanning, bottom-up parsing, and dynamic parse-tree construction.

The parser evaluates Boolean expressions containing:

* Identifiers (`id`)
* Logical operators: `||`, `&&`, `^^`, `!`
* Parentheses: `(` and `)`

The grammar extends Boolean operations by adding the **exclusive-OR (`^^`)** operator.

---

## 🧩 Features Implemented

### ✔ Lexical Scanning

LEX identifies tokens and prints each token passed to the parser.

### ✔ Bottom-Up Parsing (LALR)

YACC displays:

* **Shifting** actions
* **Reducing by** grammar rules

### ✔ Dynamic Parse Tree Construction

After every reduction, a subtree is formed, and finally the **complete parse tree** is printed.

### ✔ Error Handling

Invalid expressions trigger descriptive error messages.

---

## 📚 Grammar Used

```
E → E || T | E ^^ T | T
T → T && F | F
F → !F | (E) | id
```

### Operator Precedence (High → Low)

1. `!`
2. `&&`
3. `||`, `^^`

All operators are **left-associative**, except unary `!`.

---

## 🛠 Files to Submit

* `Assignment10.l` – LEX source file
* `Assignment10.y` – YACC source file

No additional C/C++ files should be created.

---

## 📝 How to Compile & Run

Run the following commands in order:

```
yacc -d Assignment10.y
lex Assignment10.l
gcc lex.yy.c y.tab.c -o Assignment10 -ll
./Assignment10
```

---

## 🧪 Example Inputs

Try the following expressions:

* `id || id && id`
* `!( id ^^ id ) && id`
* `id && !id || id`
* `! ( id && id ) ^^ id`
* `id ^^ && id` (Invalid)

---

## 📤 Output Format

Your output will include:

1. **Shifting** tokens
2. **Reducing** grammar rules
3. **Partial parse-tree fragments** after each reduction
4. **Final Parse Tree**
5. **Error message** if input is invalid