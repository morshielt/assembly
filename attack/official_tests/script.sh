#!/usr/bin/env bash

nasm -g -f elf64 -o attack.o attack.asm
ld --fatal-warnings -o attack attack.o

attack _test_1.0
echo $?
attack _test_2.0
echo $?
attack _test_3.0
echo $?
attack _test_4.0
echo $?
attack _test_5.0
echo $?
attack _test_6.0
echo $?
attack _test_7.0
echo $?
attack _test_8.0
echo $?
attack _test_9.0
echo $?
attack _test_10.0
echo $?

echo "granica"

attack
echo $?
attack _test_1.0 x
echo $?
attack attack
echo $?
attack abcdefghijklmnopqrstuvwxyz
echo $?
attack "!@#$%^&*()_+-=,./<>?:"
echo $?
attack _test_1.1
echo $?
attack _test_2.1
echo $?
attack _test_3.1
echo $?
attack _test_4.1
echo $?
attack _test_5.1
echo $?
attack _test_6.1
echo $?
attack _test_7.1
echo $?
attack _test_8.1
echo $?
attack _test_9.1
echo $?
attack _test_10.1
echo $?