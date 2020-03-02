#compile and disassemble w/ LLVM3.7
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
#compile and disassemble w/ LLVM3.7
setEnv37
make clean
make
llvm-dis exe.opt.bc -o a.out.ll
cd $HOME/Cloud9/src/cloud9
make -j10
cd -
#opt -dot-cfg exe.opt.bc

#switch to another terminal
#import enviroment variables for LLVM3.1
source $HOME/Cloud9/src/testing_targets/build/prepare_build_env.sh
#export GLOG_logtostderr=1

llvm-as a.out.ll -o a.out.bc 
#quickly generate command line
#sed -i "8s/.*/@P = internal global i32 3, align 4/" a.out.ll; 
#exe=`realpath a.out.bc`
cd $HOME/Cloud9/src/cloud9
rm -rf test-prod-cons/ traces.log
timeout 20s Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/Code.Table2/Barriers/v5/a.out.bc
sed -n "19 p" traces.log
