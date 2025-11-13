# Variable-Based Calculator

## Overview

This project implements an interactive variable-based calculator supporting:

* Single-letter variables (case-sensitive)
* Integer arithmetic operations: +, -, *, /, %
* Parentheses for precedence
* Unary + and -
* Variable assignment using the format: `x = expression`
* Error handling for invalid syntax, undefined variables, and division by zero
* Commands `quit` and `exit` to leave the program

---

## How to Compile

Use any C compiler such as GCC:

```sh
gcc Assignment2.c -o calc
```

This produces an executable named `calc`.

---

## How to Run

Execute the program using:

```sh
./calc
```

You will see a prompt:

```
>
```

Enter expressions or variable assignments here.

---

## Examples

### Variable Assignment

```
> x = 10
x = 10
```

### Using Variables

```
> x + 5
15
```

### Parentheses and Precedence

```
> (10 + 2) * 3
36
```

### Undefined Variable Error

```
> y + 5
Error: Variable 'y' is not defined
```

### Division by Zero

```
> 10 / 0
Error: Division by zero
```

### Exit Command

```
> quit
Goodbye!
```

---

## File Structure

```
Assignment2.c   → Main calculator program
README.md       → Documentation
```

---

## Notes

* All operations are integer-based.
* Variables are case-sensitive.
* Any extra characters after a valid expression trigger a syntax error.