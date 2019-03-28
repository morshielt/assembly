void bar(int);

void foo(void) {
    int i;
    for (i = 0; i < 100; ++i)
        bar(i);
}