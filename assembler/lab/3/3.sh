#!/usr/bin/env bash
make
echo ""
echo "inc_thread_test_naive"
./inc_thread_test_naive 3 100000
echo "inc_thread_test_lock"
./inc_thread_test_lock 3 100000
echo ""

make clean