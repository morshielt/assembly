#!/usr/bin/env bash
nasm -f elf64 -o attack.o attack.asm
ld --fatal-warnings -o attack attack.o
./attack