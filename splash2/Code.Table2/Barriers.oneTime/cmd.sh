#compile and disassemble w/ LLVM3.7
make clean
make
llvm-dis exe.opt.bc -o a.out.ll
opt -dot-cfg exe.opt.bc

#switch to another terminal
#import enviroment variables for LLVM3.1
source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh
export GLOG_logtostderr=1

llvm-as a.out.ll -o a.out 
#quickly generate command line
sed -i "8s/.*/@P = internal global i32 3, align 4/" a.out.ll; llvm-as a.out.ll -o a.out.bc ; exe=`realpath a.out.bc `; echo "rm -rf test-prod-cons/ traces.log ; time Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $exe"
