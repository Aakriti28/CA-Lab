#!/bin/bash
mkdir ${1}
mkdir ${1}/prefetch_throttling_result

## declare an array variable
declare -a arr=("0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9")

## now loop through the above array
for i in "${arr[@]}"
do
    sed -i "s/#define THRESHOLD_L1D.*/#define THRESHOLD_L1D ${i}/" ./prefetcher/ip_stride.l1d_pref

    for j in "${arr[@]}"
    do
        sed -i "s/#define THRESHOLD_L2C.*/#define THRESHOLD_L2C ${j}/" ./prefetcher/ip_stride.l2c_pref

        ./build_champsim.sh bimodal no ip_stride ip_stride no lru 1
        ./run_champsim.sh bimodal-no-ip_stride-ip_stride-no-lru-1core 10 10 trace.champsimtrace.xz

        cp ./results_10M/trace.champsimtrace.xz-bimodal-no-ip_stride-ip_stride-no-lru-1core.txt "./${1}/prefetch_throttling_result/trace.champsimtrace.xz-bimodal-no-ip_stride-ip_stride-no-lru-1core-threshold-l1d${i}-l2c${j}.txt"
    done

done

exit 0