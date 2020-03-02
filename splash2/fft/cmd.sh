#compile and disassemble w/ LLVM3.7
make
llvm-dis FFT.opt.bc -o a.out.ll;

#switch to another terminal
#import enviroment variables for LLVM3.1
source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh
export GLOG_logtostderr=1
