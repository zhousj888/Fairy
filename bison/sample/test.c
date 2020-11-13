#include "for_gcc_build.hh" // only for gcc, TinyC will ignore it.

int main() {
    int i;
    i = 0;
    while (i < 10) {
        a();
    }
    return 0;
}

int factor(int n) {
    if (n < 2) {
        return 1;
    }
    return n * factor(n - 1);
}