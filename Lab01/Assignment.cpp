// Name : Chaitanya Saagar
// Roll No : 2301CS77

#include <bits/stdc++.h>
using namespace std;

int eval(string& expr, int& pos); 

bool valid(const string& s) {
    stack<char> st;
    for (char ch : s) {
        if (ch == '(') st.push(ch);
        else if (ch == ')') {
            if (st.empty()) return false;
            st.pop();
        }
    }
    return st.empty();
}

int parseNumber(string& expr, int& pos) {
    int num = 0;
    while (pos < expr.length() && isdigit(expr[pos])) {
        num = num * 10 + (expr[pos] - '0');
        pos++;
    }
    return num;
}

int eval(string& expr, int& pos) {
    int result = 0;
    int current = 0;
    int mult = 1;

    while (pos < expr.length()) {
        char ch = expr[pos];

        if (isspace(ch)) {
            pos++;
            continue;
        }

        if (isdigit(ch)) {
            current = parseNumber(expr, pos);
        }
        else if (ch == '(') {
            pos++; 
            current = eval(expr, pos);
            if (pos >= expr.length() || expr[pos] != ')') {
                cout << "Error: missing closing parenthesis\n";
                exit(1);
            }
            pos++;
        }
        else if (ch == '+') {
            result += mult * current;
            current = 0;
            mult = 1;
            pos++;
        }
        else if (ch == '*') {
            mult *= current;
            current = 0;
            pos++;
        }
        else if (ch == ')') {
            break;
        }
        else {
            cout << "Error: unexpected character '" << ch << "'\n";
            exit(1);
        }
    }

    result += mult * current;
    return result;
}

int main() {
    string input;
    getline(cin, input);

    if (!valid(input)) {
        cout << "Error: Unbalanced parentheses\n";
        return 1;
    }

    int pos = 0;
    int result = eval(input, pos);
    cout << "Result: " << result << endl;
    return 0;
}