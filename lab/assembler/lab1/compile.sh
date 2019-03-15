#!/usr/bin/env bash
gcc -c -Wall -Wextra -O2 abi_test.c
objdump -d -M intel_mnemonic abi_test.o
