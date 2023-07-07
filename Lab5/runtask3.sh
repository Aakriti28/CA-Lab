#!/bin/bash
mkdir shared_folder
mkdir shared_folder/prefetch_throttling_result

## declare an array variable
declare -a arr=("0.25" "0.5" "0.75")

## now loop through the above array
for i in "${arr[@]}"
do
   sed -i "s/#define THRESHOLD_L1D.*/#define THRESHOLD_L1D ${i}/" ./prefetcher/ip_stride.l1d_pref
   sed -i "s/#define THRESHOLD_L2C.*/#define THRESHOLD_L2C ${i}/" ./prefetcher/ip_stride.l2c_pref

   ./build_champsim.sh bimodal no ip_stride ip_stride no lru 1
   ./run_champsim.sh bimodal-no-ip_stride-ip_stride-no-lru-1core 10 10 trace.champsimtrace.xz

   cp ./results_10M/trace.champsimtrace.xz-bimodal-no-ip_stride-ip_stride-no-lru-1core.txt "./shared_folder/prefetch_throttling_result/trace.champsimtrace.xz-bimodal-no-ip_stride-ip_stride-no-lru-1core-threshold-${i}.txt"
done

exit 0