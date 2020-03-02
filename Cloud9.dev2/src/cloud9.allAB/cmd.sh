Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr -c9-dump-traces --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ../testing_targets/out/Default/barrier.bc

rm -rf traces.log test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr -c9-dump-traces --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc
rm -rf test-prod-cons traces.log; time Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ../testing_targets/out/Default/pthread13.bc

export GLOG_logtostderr=1

#with trace parsing, with trace dump
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr -c9-dump-traces --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc



#without tracing and dump. Interpretor + printf + I/O redirection (fprintf does not work). 6m
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc&>>traces.log

#with full trace parsing, no trace dump. 2m5s  
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#with partial trace parsing, no trace dump. 28.20,  
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#without trace parsing, without trace dump, hybrid interpretor and native. 18.25
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc



#partial trace parsing, no trace dump. pthread_exit(0), 9m50
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#full trace parsing, no trace dump. pthread_exit(0), 11m31
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc


###discard  options####
###Difficult to implement: more analysis and instrumentation work.####
#a. pthread_join + for in fft.c
#b. pthread_exit(0) + pthread_detached in fft.c

#raytrace
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/test/SynCat/raytrace/RAYTRACE.opt.bc /home/tao/test/13.llvm.3.1/balls4.env





##########   2019.3.31 for ISSTA
#allAB
rm -rf test-prod-cons/ traces.log ; Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/2019Spring/ICSME2019/a.out.bc

### C9 does not work for fft and other benchmarks in our paper.
### So I want to do a series of tests to figure out the root cause.
### To begin with a clean version, I create a new branch (ISSTA) from branch SynCat, then stash all
### the changes that I have made, with git stash list show: stash@{0}: WIP on ISSTA: 98d5f1b Coding, (also made a hard copy at /home/tao/2019Spring/ICSME2019/allAB)
Test successful:

#1 barrier on fft w/o invariant derivation
rm -rf test-prod-cons/ traces.log ; Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/test2/invariant/1b/a.out.bc

#2 barriers on fft w/ invariant derivation (by uncomment line 61 in print2.c, DecrementCounter();)
rm -rf test-prod-cons/ traces.log ; Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/test2/invariant/2b/a.out.bc

Test unsuccessful:
#1 1 barrier on fft w/o invariant derivation
# after dump 7 traces into traces.log, c9 does not make any further progress.
rm -rf test-prod-cons/ traces.log ; Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/kernels/fft/debug.criteria.1/a.out.bc

#diagnosis
after compare the source code of /home/tao/splash2/codes/kernels/fft/debug.criteria.1/fft.c and /home/tao/test2/invariant/1b/fft.c,
I found that replacing
  for (i=1; i<Global->nprocs; i++) // in the unsuccessufl version
with
  for (i=1; i<P; i++) //in the successful version

solve the problem.
Not sure why I created the debug version of fft.c

From now on, I will just stick to original version w/ P as the number of threads.


To reproduce experiments that are in our paper, the following questions need to be answered.

1. How to enable printf version, i.e, the non-intrusive tracing

printf for non-intrusive tracing is in print.c, e.g,
/home/tao/splash2/codes/kernels/fft/print.c

comparison of print.c and print2.c shows us that flushAll
is the major difference for non-intrusive tracing.
In print.c, flushAll invokes printf directly, not file I/O
because it is not supported by cloud9.
In print2.c, there is no invocation to printf, but only intrusive
tracing in ./lib/Cloud9/Worker/JobManager.cpp by retrieving
content of interpretee buffer mystring directly and write it out.

So, to enable intrusive tracing, we have to use
print2.c, and enable the code in ./lib/Cloud9/Worker/JobManager.cpp.

Conversely, to enable non-intrusive tracing, we have to use print.c,
and disable, i.e., by commenting out, the code in ./lib/Cloud9/Worker/JobManager.cpp.


the interpreter-interpretee boundary crossing for tracing (and snapshot) is
realized in two parts:
a. in the front-end library print2.c w/ named buffers and APIs to manipulated
   these buffers, such as 

   char mystring[LEN];

   printX()
   printY()
   snapshot
   snapshot64

   ...
b. in the middle end, findInvariant and 

FillValuesToSyncRecord (for snapshot)

./lib/Cloud9/Worker/JobManager.cpp (for intrusive tracing)
1317     StringRef gVarName = "mystring";
         //mystring is a buffer in interpretee, but the interpreter accesses it directly.
1319     char *outputAddr = (char*)kState->addressSpace().findGlobalVariable(gVarName);
...


2. How to enable or disable slicing

//in /home/tao/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp
//Enable slicing
#if 1
StaticSlicer SS(this, M, PS, CG, MOD);
SS.computeSlice(); 
sliced = SS.sliceModule();
#endif

//Disable slicing
#if 0
StaticSlicer SS(this, M, PS, CG, MOD);
SS.computeSlice(); 
sliced = SS.sliceModule();
#endif

3. How to enable or disable invariant derivation

/home/tao/splash2/codes/kernels/fft/E1/print2.c
in front-end library function printY

//Without commenting-out DecrementCounter(), invariant derivation for barriers are enabled.
void printY()
{
  appendY();
  DecrementCounter();
}

//With commenting-out DecrementCounter(), invariant derivation for barriers are enabled.
void printY()
{
  appendY();
  //DecrementCounter();
}

4. How to enable or disable fixed-point algorithm

To enable fixed-point algorithm, in lib/Core/Executor_Memory.cpp, line 312 must be
commented.

311   //Disable fixed-point algorithm without affecting invariant derivation alg.
312   //return false;

To disable fixed-point algorithm, line 312 must be uncommented.
311   //Disable fixed-point algorithm without affecting invariant derivation alg.
312   return false;


5. How to enable or disable early-termination fixed algorithm
To enable early-termination fixed-point, in SpecialFunctionHandler.cpp,
line 1237 and 1238 must be uncommented.

1236         //2. control transfer to the found loop exit block.
1237         earlyTerminateFixedPointLoop(loopExitBlock, currentBlock, state, executor);
1238         earlyTerminated = true;

To disable early-termination fixed-point, line 1237 and 1238 must be commented.
1236         //2. control transfer to the found loop exit block.
1237         //earlyTerminateFixedPointLoop(loopExitBlock, currentBlock, state, executor);
1238         //earlyTerminated = true;


Note that: invariant derivation is at the end of a sync region when the last thread performs
printY; fixed-point algorithm is at the beginning of a sync region (w/ CheckInvariant API 
instrumentation); Early-termination fixed-point is designed for loop so that not all
loop iterations are explored. 

Note that: Early-termination fixed-point depends on fixed-point algorithm. The
difference between these two are : fixed-point algorithm (FP) lets
the interleavings that reach fixed-point state to perform computation as original program
dictates (the interleaving enumeration are disabled for these interleavings already),
early-termination fixed-point (ET-FP) transfers the control
of current loop to the nearest outer loop or straight-line code if there is no outer loop.

6. What are the source codes to use in the experiments?
The source code are in 
/home/tao/splash2/codes/kernel,  for lu, fft, radix, and cholesky
/home/tao/splash2/codes/apps, for Raytrace and FMM
/home/tao/splash2/ICSME2019, for allAB

7. What comments (manual, especially) are done to source code and llvm assembly respectively?
The source code are modified in the following ways:
a. comments out certain lines (Need to figure out which one)
b. replace inline atomic operation w/ a function
c. insert slicing Criteria

TODO: This parts need clean up

The generated llvm assembly was modified if necessary
a. modify the instruction directly
b. comment out an instruction (?)

TODO: This parts also need clean up


8. What are the commands in script format to use for the experiments?

TODO: need clean up


T

Experiment 1.

1. FFT w/ all 7 barriers. Succeed

front-end: w/ slicing and w/ allAB code
cloud9 code: w/ IR, IA, and ET
source code: /home/tao/splash2/codes/kernel/fft/, fft.c and print2.c
compilation: see cmd.sh
Node other manual source code or llvm assembly modification needed.

cloud9 execution command:
rm -rf test-prod-cons/ traces.log ; Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/kernels/fft/a.out.bc

results:
The longest trace in traces.log should be barrier traces.
Other short traces are intermediate results, meaningless, and should be ignored.

2. other experiments should be described as above in 1.
