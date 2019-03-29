#!/usr/bin/env bash
make -B
./euron
objdump -h euron.o
rm *.o