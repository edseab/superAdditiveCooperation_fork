// sudo apt update
// sudo apt install build-essential gnustep gnustep-devel gnustep-make gnustep-base-common gnustep-base-runtime libgnustep-base-dev gobjc
// sudo apt-get install libgsl-dev
// . /usr/share/GNUstep/Makefiles/GNUstep.sh
// mkdir -p ~/reciprocity_model
// ADD FILES TO THIS FOLDER
// cd ~/reciprocity_model

// gcc -c mt19937ar.c -o mt19937ar.o
gcc `gnustep-config --objc-flags` -c main.m -o main.o
gcc `gnustep-config --objc-flags` -c ContGroupAgent.m -o ContGroupAgent.o
gcc -o main main.o ContGroupAgent.o mt19937ar.o -lgnustep-base -lobjc -lgsl -lgslcblas -lm

// Normal model
./main 150001 5 2.0 100.0 0.5 100 0.0 0 999 999 0 0.02 1 16 3 1 0 0.0 "output_disagg.txt" "output_agg.txt" "output_diff.txt" 

// Categorical model
./main 150001 5 2.0 100.0 0.5 100 0.0 0 999 999 0 0.02 1 16 3 1 1 0.0 "output_disagg_cat.txt" "output_agg_cat.txt" "output_diff_cat.txt" 

// Model with max number of steps of 20 (i.e. max possible difference between parent and mutant of 20*0.025 = 0.5)
./main 150001 5 2.0 100.0 0.5 100 0.0 0 999 999 0 0.02 20 16 3 1 1 0.0 "output_disagg_range.txt" "output_agg_range.txt" "output_diff_range.txt" 

// Model with Payback Parameter
./main 150001 5 2.0 100.0 0.5 100 0.0 0 999 999 0 0.02 1 16 3 1 0 10.0 "output_disagg.txt" "output_agg.txt" "output_diff.txt" 
