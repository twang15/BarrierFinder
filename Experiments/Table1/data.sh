#!/bin/bash

app_names=(FFT Cholesky Raytrace Radix LU FMM)
apps=(fft cholesky raytrace radix lu fmm)
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

setEnv31_debug() {
  backupEnvs
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  source $HOME/Cloud9.dev2/src/testing_targets/build/prepare_build_env.sh >& /dev/null
}

## Benchmarks
benchmark() {
  cd $HOME/BarrierFinder/splash2
  rm -f column.benchmark
  for name in ${app_names[@]}
  do
    echo $name >> column.benchmark
  done
}

# LOC.
LOC() {
  cd $HOME/BarrierFinder/splash2
  rm -f column.loc
  wc -l fft/origin/fft.c | awk '{print $1}' >> column.loc

  cd cholesky
  ls *.c *.h | xargs wc -l | tail -1 | awk '{print $1}' >> ../column.loc
  cd -

  cd raytrace/origin
  ls *.c *.h | xargs wc -l | tail -1 | awk '{print $1}' >> ../../column.loc
  cd -
  wc -l radix/radix.c | awk '{print $1}' >> column.loc
  wc -l lu/origin/lu.c | awk '{print $1}' >> column.loc

  cd fmm/origin
  ls *.c *.h | xargs wc -l | tail -1 | awk '{print $1}' >> ../../column.loc
  cd -
}

# LOB.
# disable slicing
LOB() {
  cd $HOME/BarrierFinder/splash2
  sed -i "674s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  cd $HOME/build.llvm3.7.optO2/
  make install

  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  rm -f column.LOB
  cd $HOME/BarrierFinder/splash2
  for app in ${apps[@]}
  do
    cd $app
    make clean
    make
    llvm-dis ${app^^}.opt.bc -o a.out.ll
    wc -l a.out.ll | awk '{print $1}' > ../column.LOB
    cd -
  done
}

# step 1. slicing
slicing() {
  # configure source
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  cd $HOME/build.llvm3.7.optO2/
  make install

  # set up environment
  setEnv37

  cd $HOME/BarrierFinder/splash2
  for app in ${apps[@]}
  do
    cd $app
    make clean
    make >& log
    slicingTime=`tail -1 log | awk '{printf "%.4f\n", $3}'`
    for i in {1..9}
    do
      make clean
      make >& log
      slicingTime="$slicingTime `tail -1 log | awk '{printf "%.4f\n", $3}'`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$slicingTime" > slicingTime
    cd -
  done
}

# Slicing time
slicingTimes() {
  rm -f slicingTime
  cd $HOME/BarrierFinder/splash2
  for app in ${apps[@]}
  do
    cat $app/slicingTime >> slicingTime
  done  
}

# translate
From37To31_T() {
  # step 3. configure front-end
  # no slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "61s/.*/#if 0/" print2.c
  sed -i "71s/.*/#if 1/" print2.c
  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i "s/*@pthread_self/@pthread_self/" a.out.ll
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../cholesky
  #cd ../raytrace

  cd ../radix
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 0/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = 2;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../lu
  
  cd ../fmm
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 0/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}

# T (w/o slicing)
T() {
  # step 1. configure cloud9
  # no IR, see "disable IR" in From37To31_T

  # no IA
  sed -i "312s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # no tracing
  sed -i "1314s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make

  # step 3-5: From37To31_T 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >$HOME/BarrierFinder/splash2/column.T
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.T
  fi

  # cholesky
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.T

  # raytrace
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.T
  
  # radix
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >>$HOME/BarrierFinder/splash2/column.T
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.T
  fi
  
  # lu
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.T
  
  # fmm
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >>$HOME/BarrierFinder/splash2/column.T
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.T
  fi
}

From37To31_Ts() {
  # step 3. configure front-end
  # no slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "61s/.*/#if 0/" print2.c
  sed -i "71s/.*/#if 1/" print2.c
  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i "s/*@pthread_self/@pthread_self/" a.out.ll
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../cholesky
  #cd ../raytrace

  cd ../radix
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 0/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = 2;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../lu
  
  cd ../fmm
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 0/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}

# Ts (w/ slicing)
Ts() {
  # step 1. configure cloud9
  # no IR, see "disable IR" in From37To31_T

  # no IA
  sed -i "312s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # no tracing
  sed -i "1314s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make

  # step 3-5: From37To31_T 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >$HOME/BarrierFinder/splash2/column.Ts
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.Ts
  fi

  # cholesky
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Ts

  # raytrace
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Ts
  
  # radix
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >>$HOME/BarrierFinder/splash2/column.Ts
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Ts
  fi
  
  # lu
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Ts
  
  # fmm
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >>$HOME/BarrierFinder/splash2/column.Ts
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Ts
  fi
}


From37To31_Tr() {
  # step 3. configure front-end
  # no slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 1/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i "s/*@pthread_self/@pthread_self/" a.out.ll
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../cholesky
  #cd ../raytrace

  cd ../radix
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = 2;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../lu
  
  cd ../fmm
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}

# Tr (w/ IR)
Tr() {
  # no slicing
  From37To31_Tr

  # IR only
  # step 1. configure cloud9
  # no IA
  sed -i "312s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # no tracing
  sed -i "1314s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make

  # step 3-5: From37To31_T 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" > $HOME/BarrierFinder/splash2/column.Tr

    #grep "7Z7Z" traces.log | tail -1 >data.log
    #mv data.log traces.log
    #python analyze.py | head -1 | awk '{print $3}'
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.Tr
  fi

  # cholesky
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Tr

  # raytrace
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Tr
  
  # radix
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tr
  fi
  
  # lu
  echo "N/A" >>$HOME/BarrierFinder/splash2/column.Tr
  
  # fmm
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tr
  fi

}

From37To31_Tst() {
  # step 3. configure front-end
  # no slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "61s/.*/#if 0/" print2.c

  # enable tracing
  sed -i "71s/.*/#if 0/" print2.c
  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i "s/*@pthread_self/@pthread_self/" a.out.ll
  llvm-as a.out.ll -o a.out.bc
  
  #cd ../cholesky
  cd ../raytrace
  # disable IR
  sed -i "61s/.*/#if 0/" print2.c
  # enable tracing
  sed -i "71s/.*/#if 0/" print2.c
  make clean
  make
  llvm-dis RAYTRACE.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31_debug
  llvm-as a.out.ll -o a.out.bc
  #cd ../radix
  #cd ../lu
  #cd ../fmm
}

# Tst (w/ slicing, w/ IT)
Tst() {
  # step 1. configure cloud9
  # no IR, see "disable IR" in From37To31_T
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

  # step 3-5: From37To31_Tst 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc

  # report
  if [ $? -eq 0 ];then
    #python analyze.py | head -1 | awk '{print $3}'
    tail traces.log >$HOME/BarrierFinder/splash2/column.Tst
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.Tst
  fi

  # cholesky
  echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst

  # raytrace
  rm -rf test-prod-cons/ traces.log
  cd $HOME/Cloud9.dev2/src/cloud9
  # no IA
  sed -i "312s/.*/#if 1/" lib/Core/Executor_Memory.cpp
  # no ET
  sed -i "1237s/.*/#if 0/" lib/Core/SpecialFunctionHandler.cpp
  # tracing
  sed -i "1314s/.*/#if 1/" lib/Cloud9/Worker/JobManager.cpp
  
  # rebuild
  make
  
  
  timeout 7m Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tst
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst
  fi
  
  # radix
  echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst
  
  # lu
  echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst
  
  # fmm
  echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst
}

From37To31_Tsr() {
  # step 3. configure front-end
  # slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "2740s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 1/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../cholesky
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 1/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis CHOLESKY.opt.bc -o a.out.ll
  lineNo=`grep -n "ReadSparse" a.out.ll | grep call | awk -F: '{print $1}'`
  sed -i "${lineNo}s/^/;/" a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../raytrace
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 1/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis RAYTRACE.opt.bc -o a.out.ll
  
  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc

  cd ../radix
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = 2;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../lu
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "68s/.*/#define DEFAULT_N       16/" lu.c
  make clean
  make
  llvm-dis LU.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../fmm
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "617/.*/Time_Steps = 5;/" fmm.c
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}

# Tsr (w/ slicing, w/ IR)
Tsr() {
  # step 1. configure cloud9
  # no IR, see "disable IR" in From37To31_T
  # no IA
  sed -i "312s/.*/#if 1/" $HOME/temp/ori/src/cloud9/lib/Core/Executor_Memory.cpp

  # no ET
  sed -i "1237s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Core/SpecialFunctionHandler.cpp

  # no tracing
  sed -i "1314s/.*/#if 0/" $HOME/temp/ori/src/cloud9/lib/Cloud9/Worker/JobManager.cpp
  
  # step 2. compilation and install
  setEnv37
  cd $HOME/temp/ori/src/cloud9
  make

  # step 3-5: From37To31_Tsr 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" > $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.Tsr
  fi

  # cholesky
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/cholesky/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/cholesky/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tsr
  fi

  # raytrace
  rm -rf test-prod-cons/ traces.log
  cd $HOME/Cloud9.dev2/src/cloud9
  # no IA
  sed -i "312s/.*/#if 1/" lib/Core/Executor_Memory.cpp
  # no ET
  sed -i "1237s/.*/#if 0/" lib/Core/SpecialFunctionHandler.cpp
  # no tracing
  sed -i "1314s/.*/#if 0/" lib/Cloud9/Worker/JobManager.cpp
  
  # rebuild
  make
  
  timeout 7m Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tsr
  fi
  
  # radix
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tsr
  fi
  
  # lu
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/lu/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/lu/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tsr
  fi
  
  # fmm
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc &>> traces.log
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tsr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tsr
  fi
}

From37To31_Tstr() {
  # step 3. configure front-end
  # no slicing
  sed -i "622s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "674s/.*/#if 1/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
  sed -i "2740s/.*/#if 0/" $HOME/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp

  # step 4. compilation and install front-end
  cd $HOME/build.llvm3.7.optO2/
  make install
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
  export PATH=$HOME/tools/binutils.optO2/bin:$HOME/tools/llvm.optO2/bin:$PATH

  # step 5. compile each benchmark  
  cd $HOME/BarrierFinder/splash2

  # FFT
  cd fft/
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # enable tracing
  sed -i "71s/.*/#if 0/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis FFT.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../cholesky
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 0/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis CHOLESKY.opt.bc -o a.out.ll
  lineNo=`grep -n "ReadSparse" a.out.ll | grep call | awk -F: '{print $1}'`
  sed -i "${lineNo}s/^/;/" a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../raytrace
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # enable IR
  sed -i "61s/.*/#if 1/" print2.c

  # disable tracing
  sed -i "71s/.*/#if 0/" print2.c
  sed -i "185s/.*/#if 1/" print2.c
  sed -i "213s/.*/#if 1/" print2.c

  make clean
  make
  llvm-dis RAYTRACE.opt.bc -o a.out.ll
  
  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc

  
  cd ../radix
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 0/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "301s/.*/max_num_digits = 2;/" radix.c
  make clean
  make
  llvm-dis RADIX.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../lu
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 0/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "68s/.*/#define DEFAULT_N       16/" lu.c
  make clean
  make
  llvm-dis LU.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  llvm-as a.out.ll -o a.out.bc
  
  cd ../fmm
  # from llvm 3.7 bitcode to llvm 3.7 assembly
  setEnv37

  # disable IR
  sed -i "89s/.*/#if 1/" print2.c
  sed -i "98s/.*/#if 0/" print2.c
  sed -i "213s/.*/#if 1/" print2.c
  sed -i "241s/.*/#if 1/" print2.c
  sed -i "617/.*/Time_Steps = 5;/" fmm.c
  make clean
  make
  llvm-dis FMM.opt.bc -o a.out.ll

  # from llvm 3.7 assembly to llvm 3.1 bitcode
  setEnv31
  sed -i 's/@LockedPrint/*@LockedPrint/' a.out.ll
  sed -i 's/void \*@LockedPrint/void @LockedPrint/' a.out.ll
  llvm-as a.out.ll -o a.out.bc
}
# Tstr (w/ slicing, IR, IT)
Tstr() {
  # step 1. configure cloud9
  # no IR, see "disable IR" in From37To31_T
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

  # step 3-5: From37To31_Tsr 

  # step 6. Experiments in cloud9
  # set env 3.1
  setEnv31
  
  # fft
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >traces.log.fft

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fft/a.out.bc
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" > $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >$HOME/BarrierFinder/splash2/column.Tstr
  fi

  # cholesky
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/cholesky/a.out.bc

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >traces.log.cholesky

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/cholesky/a.out.bc
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tstr
  fi

  # raytrace
  rm -rf test-prod-cons/ traces.log
  cd $HOME/Cloud9.dev2/src/cloud9
  # no IA
  sed -i "312s/.*/#if 1/" lib/Core/Executor_Memory.cpp
  # no ET
  sed -i "1237s/.*/#if 0/" lib/Core/SpecialFunctionHandler.cpp
  # tracing
  sed -i "1314s/.*/#if 1/" lib/Cloud9/Worker/JobManager.cpp
  
  # rebuild
  make
  
  timeout 7m Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >$HOME/temp/ori/src/cloud9/traces.log.raytrace

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/raytrace/a.out.bc $HOME/BarrierFinder/splash2/raytrace/balls4.env
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tst
  fi
  
  # radix
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >traces.log.radix

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/radix/a.out.bc
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tstr
  fi
  
  # lu
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/lu/a.out.bc

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >traces.log.lu

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/lu/a.out.bc
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tstr
  fi
  
  # fmm
  rm -rf test-prod-cons/ traces.log
  timeout 7m Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc

  # report
  if [ $? -eq 0 ];then
    runTime=`tail -1 traces.log`
    grep "1Z1Z" traces.log >traces.log.fmm

    # 9 more runs
    for i in {1..9}
    do
      rm -rf test-prod-cons/ traces.log
      Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons $HOME/BarrierFinder/splash2/fmm/a.out.bc
      runTime="$runTime `tail -1 traces.log`"
    done

    # calculate mean and stdev
    awk '{sum=0; square=0; for(i=1; i<=10; i++) { sum += $i; square += $i*$i }; 
    printf "%.4f(%.4f)\n", sum/10, sqrt((square-sum*sum/10)/10)}' <<< "$runTime" >> $HOME/BarrierFinder/splash2/column.Tstr
  else
    echo "OOR" >>$HOME/BarrierFinder/splash2/column.Tstr
  fi
}

# patterns
patterns() {
  cd $HOME/temp/ori/src/cloud9/
  rm -f $HOME/BarrierFinder/splash2/column.patterns
  for app in ${apps[@]}
  do
    cp traces.log.$app traces.log
    python analyze.py | head -1 | awk '{printf "barriers(%d)\n", $3}' >> $HOME/BarrierFinder/splash2/column.patterns
  done
}

# Tsr/Tstr
TsrOverTstr() {
  cd  $HOME/BarrierFinder/splash2/

  awk -F'(' '{print $1}' $HOME/BarrierFinder/splash2/column.Tsr > sr
  awk -F'(' '{print $1}' $HOME/BarrierFinder/splash2/column.Tstr > str

  paste -d" " sr str >t
  awk '{printf "%.2f\n", $1/$2}' t > column.TsrOverTstr
}

GenerateData() {
  # benchmark
  benchmark
  LOC
  LOB
  slicing
  slicingTimes

  From37To31_T
  T

  From37To31_Ts
  Ts

  From37To31_Tr
  Tr

  From37To31_Tst
  Tst

  From37To31_Tsr
  Tsr

  From37To31_Tstr
  Tstr

  patterns
  TsrOverTstr
}

# table
table() {
  # merge all columns into one file
  paste -d"&" column.benchmark column.loc column.LOB slicingTime column.patterns column.T column.Ts column.Tr column.Tst column.Tsr column.Tstr column.TsrOverTstr > table.data

  rm -f table.newline
  for i in {1..6}
  do
    echo "\\\\" >> table.newline
  done
  
  paste -d" " table.data table.newline >content
  cp content $HOME/BarrierFinder/Experiments/Table1/Data
  cd $HOME/BarrierFinder/Experiments/Table1/Data
  
  cp header table.tex
  cat content >> table.tex
  cat footer >> table.tex

  # compile to generate the table
}

GenerateData
#table
