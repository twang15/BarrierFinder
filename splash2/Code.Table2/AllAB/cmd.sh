#!/bin/bash

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
  export LIBRARY_PATH=/usr/lib:/usr/local/lib:$LIBRARY_PATH
}

# set up environment variables for clang 3.1
setEnv31() {

  backupEnvs
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  source $HOME/Cloud9/src/testing_targets/build/prepare_build_env.sh >& /dev/null
  export LIBRARY_PATH=/usr/lib:/usr/local/lib:$LIBRARY_PATH
}

setEnv37
# configure front-end
sed -i "622s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
cd $HOME/build.llvm3.7.optO2/
make install

#compile and disassemble w/ LLVM3.7
cd $HOME/BarrierFinder/splash2/Code.Table2/AllAB
make clean
make
llvm-dis exe.opt.bc -o a.out.ll;

# configure middle end
cd $HOME/Cloud9/src/cloud9/allAB
while read f; do
  fName=`basename $f`

  #backup
  cp ../$f $fName.bak

  # configure
  cp $fName ../$f
done < file

cd ..
make

#switch to another terminal
#import enviroment variables for LLVM3.1
cd $HOME/BarrierFinder/splash2/Code.Table2/AllAB
setEnv31
llvm-as a.out.ll -o a.out.bc 

# interpretation
cd $HOME/Cloud9/src/cloud9
rm -rf test-prod-cons/ traces.log
Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/Code.Table2/AllAB/a.out.bc

tail -2 traces.log

cd $HOME/Cloud9/src/cloud9/allAB
# restore
while read f; do
  fName=`basename $f`

  #backup
  cp $fName.bak ../$f
done < file
