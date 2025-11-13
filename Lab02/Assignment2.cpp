/*
Name: Chaitanya Saagar
Roll No: 2301CS77
Assignment 2 - CS3104 Compiler Lab, Autumn 2025
*/

#include <bits/stdc++.h>
using namespace std;

struct Symbol {
    string name;
    int value;
    bool defined;
};

map<string, int> symbolTable;

class Calculator {
public:
    string input;
    size_t pos;

    Calculator() : pos(0) {}

    void trim() {
        while (pos < input.size() && isspace(input[pos])) pos++;
    }

    bool isVariableChar(char c) {
        return isalpha(c);
    }

    int parseNumber() {
        trim();
        int num = 0;
        if (pos >= input.size() || !isdigit(input[pos])) {
            throw runtime_error("Invalid syntax");
        }
        while (pos < input.size() && isdigit(input[pos])) {
            num = num * 10 + (input[pos] - '0');
            pos++;
        }
        return num;
    }

    int parseFactor() {
        trim();
        if (pos >= input.size()) throw runtime_error("Invalid syntax");

        if (input[pos] == '(') {
            pos++;
            int val = parseExpression();
            trim();
            if (pos >= input.size() || input[pos] != ')')
                throw runtime_error("Invalid syntax");
            pos++;
            return val;
        }
        else if (isVariableChar(input[pos])) {
            string var;
            var += input[pos++];
            if (symbolTable.find(var) == symbolTable.end())
                throw runtime_error("Variable '" + var + "' is not defined");
            return symbolTable[var];
        }
        else if (isdigit(input[pos])) {
            return parseNumber();
        }
        else {
            throw runtime_error("Invalid syntax");
        }
    }

    int parseTerm() {
        int val = parseFactor();
        while (true) {
            trim();
            if (pos >= input.size()) break;
            char op = input[pos];
            if (op == '*' || op == '/' || op == '%') {
                pos++;
                int right = parseFactor();
                if (op == '*') val *= right;
                else if (op == '/') {
                    if (right == 0) throw runtime_error("Division by zero");
                    val /= right;
                }
                else if (op == '%') {
                    if (right == 0) throw runtime_error("Division by zero");
                    val %= right;
                }
            }
            else break;
        }
        return val;
    }

    int parseExpression() {
        int val = parseTerm();
        while (true) {
            trim();
            if (pos >= input.size()) break;
            char op = input[pos];
            if (op == '+' || op == '-') {
                pos++;
                int right = parseTerm();
                if (op == '+') val += right;
                else val -= right;
            }
            else break;
        }
        return val;
    }

    void parseStatement() {
        trim();
        if (pos < input.size() && isVariableChar(input[pos])) {
            string var;
            var += input[pos++];
            trim();
            if (pos < input.size() && input[pos] == '=') {
                pos++;
                int val = parseExpression();
                symbolTable[var] = val;
                cout << var << " = " << val << "\n";
            }
            else {
                pos = 0;
                int val = parseExpression();
                cout << val << "\n";
            }
        }
        else {
            int val = parseExpression();
            cout << val << "\n";
        }
    }
};

int main() {
    Calculator calc;
    string line;
    while (true) {
        cout << "> ";
        if (!getline(cin, line)) break;
        if (line == "quit" || line == "exit") {
            cout << "Goodbye!\n";
            break;
        }
        calc.input = line;
        calc.pos = 0;
        try {
            calc.parseStatement();
        }
        catch (runtime_error &e) {
            cout << "Error: " << e.what() << "\n";
        }
    }
    return 0;
}