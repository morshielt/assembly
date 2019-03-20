#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <zconf.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>

#define N 2

struct arg_struct {
    uint64_t n;
    char const *prog;
} typedef arg_struct;

uint64_t euron(uint64_t n, char const *prog) {
    printf("euron(%lu, %s)\n", n, prog);
}

void *euron_wrapper(void *vargs) {
    arg_struct *args = (arg_struct *) vargs;
    printf("wrapping euron %lu\n", args->n);
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
    pthread_t th[N];
    char const *prog = "01234n+P56789E-+D+*G*1n-+S2ED+E1-+75+-BC";
    uint64_t i;
    pthread_t tid;
    arg_struct args[N];

    for (i = 0; i < N; ++i) {
        args[i].prog = prog;
        args[i].n = i;

        pthread_create(&tid, NULL, euron_wrapper, (void *) &args[i]);
    }

    pthread_exit(NULL);
    return 0;
}
