#!/bin/bash

apps=(radix lu fmm)
configs=(IR IA ET)

TIMEFORMAT=%R

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
  #source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh >& /dev/null
  source $HOME/temp/ori/src/testing_targets/build/prepare_build_env.sh >& /dev/null
}

# IR, tracing
# $1:
PrepareFrontEnd() {
  # slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  if [ $1 -eq 1 ];
  then
    sed -i "2740s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  else
    sed -i "2740s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  fi

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH
}

From37To31_radix() {
  numDigits=$1

  # step 5. compile each benchmark  
  cd $HOME/CodeWalk/splash2/radix

  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "38s/.*/#if 0/" print2.c
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 0/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = $numDigits;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
}

From37To31_lu() {
  defaultN=$1

  # step 5. compile each benchmark  
  cd $HOME/CodeWalk/splash2/lu

  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37
  
  # enable IR
  if [ $2 -eq 1 ]; then
    sed -i "38s/.*/#if 0/" print2.c
  else
    sed -i "38s/.*/#if 1/" print2.c
  fi
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 0/" print2.c
  sed -i "213s/.*/#if 0/" print2.c
  sed -i "241s/.*/#if 0/" print2.c
  sed -i "68s/.*/#define DEFAULT_N       $defaultN/" lu.c
  make clean
  make
  llvm-dis LU.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
}

From37To31_fmm() {
  timeSteps=$1
  # step 5. compile each benchmark  

  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37
  
  # enable IR
  if [ $2 -eq 1 ]; then
    cd $HOME/CodeWalk/splash2/fmm
    sed -i "38s/.*/#if 0/" print2.c
    sed -i "89s/.*/#if 1/" print2.c
    sed -i "98s/.*/#if 0/" print2.c
    sed -i "213s/.*/#if 0/" print2.c
    sed -i "241s/.*/#if 0/" print2.c
    sed -i "617s/.*/Time_Steps = $timeSteps;/" fmm.c
  else
    cd $HOME/CodeWalk/splash2/fmm.inlined
    if [ $timeSteps -eq 1 ];
    then
      sed -i "38s/.*/#if 0/" print2.c
    else
      sed -i "38s/.*/#if 1/" print2.c
    fi

    sed -i "918s/.*/Time_Steps = $timeSteps;/" fmm.c
  fi
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}

PrepareCloud9_IR() {
  # step 1. configure cloud9
  # no IA
  sed -i "312s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # tracing
  sed -i "1314s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make
}

PrepareCloud9_IA() {
  # step 1. configure cloud9
  # no IA
  sed -i "312s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # tracing
  sed -i "1314s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make
}

PrepareCloud9_ET() {
  # step 1. configure cloud9
  # no IA
  sed -i "312s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # tracing
  sed -i "1314s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make
}

radix_IR() {
  PrepareCloud9_IR
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/radix.IR

  ns=(1 2 4 8 16 32)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_radix $n
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.IR
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.IR
    fi
  done
}

radix_IA() {
  PrepareCloud9_IA
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/radix.IA
  
  ns=(1 2 4 8 16 32 64 128 256 512 1024)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_radix $n
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.IA
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.IA
    fi
  done
}

radix_ET() {
  PrepareCloud9_ET
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/radix.ET
  
  ns=(1 2 4 8 16 32 64 128 256 512 1024)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_radix $n
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/radix/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.ET
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/radix.ET
    fi
  done
}

lu_IR() {
  PrepareCloud9_IR
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/lu.IR

  ns=(16 32 64 128)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_lu $n 1
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.IR
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.IR
    fi
  done
}

lu_IA() {
  PrepareCloud9_IA
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/lu.IA
  
  ns=(16 32 64 128 256 512)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_lu $n 1
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.IA
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.IA
    fi
  done
}

lu_ET() {
  PrepareCloud9_ET
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/lu.ET
  
  ns=(16 32 64 128 256 512)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_lu $n 1
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/lu/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.ET
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/lu.ET
    fi
  done
}

fmm_IR() {
  PrepareCloud9_IR
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IR
  
  ns=(1 2 4 5 10)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_fmm $n 1
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm/a.out.bc
        runTime="$runTime `tail -1 traces.log`"

      done
      
      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IR
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IR
    fi
  done
}

fmm_IA() {
  PrepareCloud9_IA
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IA
  
  ns=(1 2 4 5 10 100 500 1000)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_fmm $n
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm.inlined/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm.inlined/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IA
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.IA
    fi
  done
}

fmm_ET() {
  PrepareCloud9_ET
  rm -f $HOME/CodeWalk/Experiments/Fig7/Data/fmm.ET
  
  ns=(1 2 4 5 10 100 500 1000)
  ns=(3)
  for n in ${ns[@]}
  do
    # prepare bc file
    From37To31_fmm $n
    
    cd $HOME/temp/ori/src/cloud9
    rm -rf test-prod-cons/ traces.log
    timeout 5m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm.inlined/a.out.bc

    # report
    if [ $? -eq 0 ];then
      runTime=`tail -1 traces.log`

      # 9 more runs
      for i in {1..9}
      do
        rm -rf test-prod-cons/ traces.log
        Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/CodeWalk/splash2/fmm.inlined/a.out.bc
        runTime="$runTime `tail -1 traces.log`"
      done

      # calculate mean and stdev
      awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
      printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.ET
    else
      echo "OOR" >> $HOME/CodeWalk/Experiments/Fig7/Data/fmm.ET
    fi
  done
}

radix() {
  #data collection
  radix_IR
  radix_IA
  radix_ET
}

lu() {
  #data collection
  lu_IR
  lu_IA
  lu_ET
}

fmm() {
  #data collection
  fmm_IR
  fmm_IA
  fmm_ET
}

FormatData() {
  cd $HOME/CodeWalk/Experiments/Fig7/Data

  for app in ${apps[@]}
  do
    awk -F'(' '{print $1}' $app.IR > ir
    awk -F'(' '{print $1}' $app.IA > ia
    awk -F'(' '{print $1}' $app.ET > et

    paste -d" " ir ia et > $app
  done
}

Experiments() {
  PrepareFrontEnd

  radix
  lu
  fmm

  FormatData
}

test() {
#  PrepareFrontEnd 1
#  lu_IR
#  PrepareFrontEnd 0
#  lu_IA
#  lu_ET
#
#  PrepareFrontEnd 1
#  radix_IR
#  PrepareFrontEnd 0
#  radix_IA
#  radix_ET
#
#
#  PrepareFrontEnd 1
#  fmm_IR
  PrepareFrontEnd 0
#  fmm_IA
  fmm_ET
}

test
#Experiments
