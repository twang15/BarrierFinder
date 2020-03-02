#w/ llvm 3.7 and slicer
make clean
make
llvm-dis FFT.opt.bc -o a.out.ll

#w/ llvm 3.1
#switch to another terminal
#import enviroment variables for LLVM3.1
source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh

llvm-as a.out.ll -o a.out.bc

#Go to Cloud9
cd /home/tao/Cloud9.dev2/src/cloud9
rm -rf test-prod-cons/ traces.log 
Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/kernels/fft/E1/a.out.bc

#Trace in traces.log
