#!/usr/bin/env bash
 make ks_stress_test_rs
ks_stress_test_rs 100 10 >my.out
diff my.out test_100_10.out
#
#./ks_stress_test_rs 2 2 >2_2.out
#./ks_stress_test_rs 5 5 >5_5.out
#./ks_stress_test_rs 10 10 >10_10.out
#./ks_stress_test_rs 20 20 >20_20.out
#./ks_stress_test_rs 30 30 >30_30.out
#./ks_stress_test_rs 40 40 >40_40.out
#./ks_stress_test_rs 50 50 >50_50.out
#./ks_stress_test_rs 100 10 >100_10.out

echo $?
