#!/usr/bin/env bash
rm attack 2> /dev/null
nasm -g -f elf64 -o attack.o attack.asm
ld --fatal-warnings -o attack attack.o

./attack testy/_test_1.0
echo "_test_1.0     [0]" $?

./attack testy/_test_1.1
echo "_test_1.1     [1]" $?

./attack testy/nieistnieje
echo "nieistnieje   [1]" $?

./attack testy/_test_2.1
echo "_test_2.1     [1]" $?

./attack testy/zla_dlugosc
echo "zla_dlugosc   [1]" $?

./attack testy/alfabet
echo "alfabet       [1]" $?

./attack testy/be_68020
echo "be_68020      [1]" $?

./attack testy/le_68020
echo "le_68020      [1]" $?


