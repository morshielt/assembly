#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>
#include "err.h"

#define MIN(a, b) (a < b ? a : b)

#define PUT_BUFFER_SIZE 10000

uint64_t euron(uint64_t n, char const *prog);

struct euronData {
    uint64_t n;
    uint64_t result;
    uint64_t putData[PUT_BUFFER_SIZE];
    uint64_t putDataSize;
    volatile uint64_t state;
    volatile uint64_t state2;
    volatile uint64_t state3;
    const char *prog;
} euronData[N];
int numOfEurons;
int iterations = 100;
int leaderJmp;
void *start_euron(void *d) {
    struct euronData *ed = (struct euronData *) d;
    uint64_t res = euron(ed->n, ed->prog);
    ed->result = res;
    return NULL;
}

void put_value(uint64_t n, uint64_t v) {
    euronData[n].putData[(euronData[n].putDataSize++) % PUT_BUFFER_SIZE] = v;
    assert(n < N);
}

uint64_t get_value(uint64_t n) {
    assert(n < N);
    struct euronData *ed = euronData + n;
    uint64_t res = 0;
    if (n == 0) {

        if (ed->state2 > 0) {
            if (ed->state2 == 2) {
                ed->state3++;

                res = (ed->state3 < iterations ? 1 : 0);

            } else {
                res = leaderJmp;
            }

            ed->state2--;
        } else {
            res = ed->state + 1;
            ed->state++;

            if (ed->state == numOfEurons - 1) {
                ed->state2 = 2;
            }

            ed->state %= (numOfEurons - 1);
        }

    } else {

        if (ed->state % 2 == 1) {

            res = -13;
        } else {
            ed->state2++;
            res = (ed->state2 < iterations ? 1 : 0);
        }
        ed->state++;

    }
    //fprintf(stderr, "%lu getting %lu\n", n, res);
    //sleep(1);
    return res;
}

void exchanging(uint64_t kto, uint64_t zkim, uint64_t stos, uint64_t base, uint64_t prog_i, uint64_t prog_val) {
    fprintf(stderr, "I:%lu wymienia %lu             %lu %lu %lu %lu\n", kto, zkim, stos, base, prog_i, prog_val);
}

void exchanging_fin(uint64_t kto, uint64_t zkim, uint64_t stos, uint64_t base) {
    fprintf(stderr, "I:%lu wymienia %lu             %lu %lu\n", kto, zkim, stos, base);
}

pthread_t threads[N];

char leaderProg[4000];
//char *othersProg = "1C1234n+9*E9*0SGGBC";
char *othersProg = "nnCDD*9+D+0SGGBC";

pthread_mutex_t memFlowLock;
int main(int argc, char *argv[]) {
    numOfEurons = atoi(argv[1]);
    iterations = atoi(argv[2]);

    leaderProg[0] = '1';
    leaderProg[1] = '1';
    leaderProg[2] = '2';
    leaderProg[3] = 'C';
    int i;
    for (i = 4; i < 3 + 2 * (numOfEurons - 1); i += 2) {
        leaderProg[i] = 'G';
        leaderProg[i + 1] = 'S';
    }
    leaderProg[i++] = 'G';
    leaderProg[i++] = 'G';
    leaderProg[i++] = 'B';
    leaderProg[i++] = 'C';
    leaderProg[i++] = '\0';

    assert(strlen(leaderProg) == 2 * (numOfEurons - 1) + 8);

    leaderJmp = strlen(leaderProg) - 4;
    leaderJmp = -leaderJmp;

    for (size_t i = 0; i < numOfEurons; ++i) {
        euronData[i].n = i;
        euronData[i].prog = othersProg;
    }

    euronData[0].prog = leaderProg;

    for (size_t i = 0; i < numOfEurons; ++i) {
        if (pthread_create(threads + i, NULL, &start_euron, (void *) &euronData[i])) {
            syserr("Function create_thread failed for thread %d.", i);
        }
    }

    for (size_t i = 0; i < numOfEurons; ++i) {
        if (pthread_join(threads[i], NULL)) {
            syserr("Function join_thread failed for thread %d.", i);
        }
    }

    pthread_mutex_lock(&memFlowLock);
    for (size_t i = 0; i < numOfEurons; ++i) {
        struct euronData *ed = euronData + i;
        printf("For %lu\n", ed->n);
        printf("Result %lu\n", ed->result);
        printf("Data put: %lu\n", ed->putDataSize);
        size_t len = MIN(ed->putDataSize, PUT_BUFFER_SIZE);
        for (size_t j = 0; j < len; ++j) {
            printf("%lu ", ed->putData[j]);
        }
        printf("\n");
    }
    pthread_mutex_unlock(&memFlowLock);

}
