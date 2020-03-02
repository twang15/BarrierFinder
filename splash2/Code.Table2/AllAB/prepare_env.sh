#!/bin/bash

# This script is used to switch between two sets of environments.
# one set is for clang-3.7, the other is for clang-3.1

# backup all the current environment variables that are to be modified 
# by Cloud9/src/testing_targets/build/prepare_build_env.sh
backupEnvs() {
  CC_old=$CC
  CXX_old=$CXX
  AR_old=$AR
  RANLIB_old=$RANLIB
  NM_old=$NM

  LDFLAGS_old=$LDFLAGS
  ARFLAGS_old=$ARFLAGS
  AR_FLAGS_old=$AR_FLAGS

  PATH_old=$PATH
}

recoverEnvs() {
  export CC=$CC_old
  export CXX=$CXX_old
  export AR=$AR_old
  export RANLIB=$RANLIB_old
  export NM=$NM_old

  export LDFLAGS=$LDFLAGS_old
  export ARFLAGS=$ARFLAGS_old
  export AR_FLAGS=$AR_FLAGS_old

  export PATH=$PATH_old
}

# set up environment variables for clang 3.7
setEnv37() {
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH
}

# set up environment variables for clang 3.1
setEnv31() {

  backupEnvs
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh >& /dev/null

}

# step 1. front-end slicing and instrumentation
cd /home/tao/splash2/codes/kernels/fft
sed -i "622s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
cd $HOME/build.llvm3.7.optO2/
make install
setEnv37

make clean
make >& log

# step 2. translate from llvm 3.7 to 3.1 for language compatibility.

# from llvm 3.7 bitcode to llvm 3.7 assembly
llvm-dis FFT.opt.bc -o a.out.ll
setEnv31

# from llvm 3.7 assembly to llvm 3.1 bitcode
llvm-as a.out.ll -o a.out.bc

# step 3. middle-end experiments
cd /home/tao/Cloud9.dev2/src/cloud9
rm -rf test-prod-cons/ traces.log
Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/CodeWalk/splash2/fft/a.out.bc

# step 4. report
python analyze.py

# step 5. recover environment (may be unnecessary)
recoverEnvs
