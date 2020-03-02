==========================O0======================================
#full trace parsing, no trace dump. pthread_exit(0), 11m31
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#partial trace parsing, no trace dump. pthread_exit(0), 9m50
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#without tracing and dump. Interpretor + printf + I/O redirection (fprintf does not work). 6m
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc&>>traces.log

#with full trace parsing, no trace dump. 2m5s  
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#with partial trace parsing, no trace dump. 28.20,  
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#without trace parsing, without trace dump, hybrid interpretor and native. 18.25
rm -f traces.log; rm -rf test-prod-cons/; time Debug+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

###discard  options####
###Difficult to implement: more analysis and instrumentation work.####
#a. pthread_join + for in fft.c
#b. pthread_exit(0) + pthread_detached in fft.c

==========================O2======================================
####link with lib.c, enable pthread_exit(0)

#full trace parsing, no trace dump. pthread_exit(0), 1m53
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#partial trace parsing, no trace dump. pthread_exit(0), 1m49
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with print.c

#without tracing and dump. Interpretor + printf + I/O redirection (fprintf does not work). 1m29 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with lib.c, enable pthread_join(0, 0).

#with full trace parsing, no trace dump. 7.5s 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc


#with partial trace parsing, no trace dump 4.6s
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with print2.c
#without trace parsing, without trace dump, hybrid interpretor and native. 4.15s 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt  --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc


==========================O3======================================

####link with lib.c, enable pthread_exit(0)

#full trace parsing, no trace dump. pthread_exit(0), 1m53
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#partial trace parsing, no trace dump. pthread_exit(0), 1m49
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with print.c

#without tracing and dump. Interpretor + printf + I/O redirection (fprintf does not work). 1m29, pthread_join(0, 0) 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

#without tracing and dump. Interpretor + printf + I/O redirection (fprintf does not work). 1m48, pthread_exit(0).
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with lib.c, enable pthread_join(0, 0).

#with full trace parsing, no trace dump. 4.6s 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -c9-dump-instr -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc


#with partial trace parsing, no trace dump 4.6s
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt -c9-dump-instr --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc

### link with print2.c
#without trace parsing, without trace dump, hybrid interpretor and native. 4.0s 
rm -f traces.log; rm -rf test-prod-cons/; time Release+Asserts/bin/c9-worker -disable-opt  --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons ~/test/13.llvm.3.1/a.out.bc
