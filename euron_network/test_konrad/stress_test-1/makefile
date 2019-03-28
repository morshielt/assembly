CC = gcc
CFLAGS = -Wall
NFLAG = -DN=999


err.o: err.c err.h
	$(CC) -c $(CFLAGS) -o $@ $<


euron.o: euron.asm
	nasm -f elf64 $(NFLAG) -o $@ $<

ks_stress_test_rs.o: ks_stress_test_rs.c
	$(CC) -c $(CFLAGS) $(NFLAG) -pthread -o $@ $^

ks_stress_test_rs: ks_stress_test_rs.o err.o euron.o
	$(CC) -pthread -o $@ $^
