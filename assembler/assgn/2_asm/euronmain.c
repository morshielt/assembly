#include <assert.h>
#include <stdint.h>
#include <zconf.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>

struct arg_struct {
    uint64_t n;
    char const *prog;
} typedef arg_struct;

uint64_t euron(uint64_t n, char const *prog); //{
//    printf("euron(%lu, %s)\n", n, prog);
//}

void *euron_wrapper(void *vargs) {
    arg_struct *args = (arg_struct *) vargs;
//    printf("wrapping euron %lu\n", args->n);
    pthread_exit((void *) (uint64_t) euron(args->n, args->prog));
}

uint64_t get_value(uint64_t n) {
    assert(n < N);
    return n + 1;
}

void put_value(uint64_t n, uint64_t v) {
    assert(n < N);
    assert(v == n + 4);
}

int main() {
    char const *prog = "01234n+P56789E-+D+*G*1n-+S2ED+E1-+75+-BCn";
//    char const *prog = "5n-+1n-+S";

    printf("\n");
    pthread_t th[N];
    pthread_attr_t attr;
    uint64_t i;
    arg_struct args[N];
    int std_err = 2;

    for (i = 0; i < N; ++i) {
        args[i].prog = prog;
        args[i].n = i;
        pthread_create(&th[i], NULL, euron_wrapper, (void *) &args[i]);
    }

    pthread_exit(NULL);

    return 0;
}

void stack_dump(int a, int b, int c, int d, int e, int f, int g, int h, int i) {
    printf("Stack top: · %d · %d · %d · %d · %d · %d · %d · %d · %d\n",
           a, b, c, d, e, f, g, h, i);
}

void register_dump(int rdi, int rsi, int rdx, int rcx, int r8, int r9, int rax, int rbx,
                   int rbp, int rsp, int r10, int r11, int r12, int r13, int r14, char *r15) {
    printf("rax = %d    rbx = %d    rcx = %d    rdx = %d\n"
           "rsi = %d    rdi = %d    rbp = %d    rsp = %d\n"
           "r8  = %d    r9  = %d    r10 = %d    r11 = %d\n"
           "EURON_ID_n = %d    CURR  = %c    ITER = %d    PROG = %s\n",
           rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8, r9, r10, r11, r12, r13, r14, r15);
}