#include <bits/stdc++.h>
using namespace std;

string s;
int pos, n;
bool err = false;

void skip() {
    while (pos < n && isspace(s[pos])) pos++;
}

long long evalsum();
long long evalterm();

long long number() {
    skip();
    if (pos >= n || !isdigit(s[pos])) {
        err = true;
        return 0;
    }
    long long v = 0;
    while (pos < n && isdigit(s[pos])) {
        v = v * 10 + (s[pos] - '0');
        pos++;
    }
    return v;
}

long long factor() {
    skip();
    if (pos < n && s[pos] == '(') {
        pos++;
        long long v = evalsum();
        skip();
        if (pos >= n || s[pos] != ')') {
            err = true;
            return 0;
        }
        pos++;
        return v;
    }
    return number();
}

long long evalterm() {
    skip();
    long long v = factor();
    while (!err) {
        skip();
        if (pos < n && s[pos] == '*') {
            pos++;
            long long r = factor();
            v *= r;
        } else break;
    }
    return v;
}

long long evalsum() {
    skip();
    long long v = evalterm();
    while (!err) {
        skip();
        if (pos < n && s[pos] == '+') {
            pos++;
            long long r = evalterm();
            v += r;
        } else break;
    }
    return v;
}

int main() {
    getline(cin, s);
    pos = 0;
    n = s.size();
    long long ans = evalsum();
    skip();
    if (err || pos != n) cout << "Invalid expression\n";
    else cout << ans << "\n";
}