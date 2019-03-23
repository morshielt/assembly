#!/usr/bin/env bash
nasm -f elf64 -o $1.o $1.asm
ld --fatal-warnings -o $1 $1.o
./$1
echo $?