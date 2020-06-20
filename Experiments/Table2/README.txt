# The experiments here are semi-automated.

# ID: manual
# Actual: manual
# Characterized: auto
# Deadlock: semi-auto w/ gdb to inspect the stack trace (?)
# Violation trace: semi-auto, generated automatically and selected manually
# Violation sequence ID: semi-auto, generated automatically and selected manually
# Atomic: manual
# Description: manual

# The following provides an example for carrying out the experiments.

8 barrier code: $HOME/BarrierFinder/splash2/Code.Table2 
1 allAB code: $HOME/BarrierFinder/splash2/Code.Table2/AllAB

#For allAB, row 9 of table 2
cd $HOME/BarrierFinder/splash2/Code.Table2/AllAB
bash cmd.sh

cd $HOME/Cloud9/src/cloud9

# manually inspect traces.log to verify that all traces are XXXY
# ignore "******** hang (possible deadlock?)"
# because it is raised by pthread_exit, which means the program is terminating.


# For barrier code
# v0, row 1
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v0
bash cmd.sh

# v1, row 2
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v1
bash cmd.sh

# v2, row 3
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v2
bash cmd.sh

# use gdb to inspect the stack
#cd $HOME/Cloud9/src/cloud9
#cp gdbfile gdbfile.old
#cp $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v2/gdbfile .
#cp gdbfile.old gdbfile

# now launch gdb with the gdbfile
# inspect the interpretee's call stack at the breakpoint Executor_Threading.cpp:126
rm -fr test-prod-cons/
gdb 
  so gdbfile
  p state.dumpStacks ()
#trace below shows deadlock in Klee on Executor_Threading.cpp:126 (see gdbfile)
#since both threads are disabled, which refers to Tab.2 row 3 test case

# both threads are disabled.
# call stack
  0x51449a0 ===Thread ID: 0 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=0) asm:625
  #4 00000664 in __user_main (argc=1, argv=140733018341376) asm:664
  #5 00001453 in __uClibc_main (main=28491392, argc=1, argv=140733018341376, app_init=0, app_fini=0, rtld_fini=0, stack_end=0) at /home/tao/Cloud9/src/klee-uclibc/libc/misc/internals/__uClibc_main.c:402 asm:1453
  #6 00004452 in main (=1, =140733018341376) asm:4452

-->> Current Thread
  0x511b4b0 ===Thread ID: 1 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=140733018354884) asm:625


# v3, row 4
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v3
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v4 row 5
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v4
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v5 row 6
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v5
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYXYX

# use gdb to inspect the interpretee's stack, similarly as in v2

# v6
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v6
rm -fr test-prod-cons/
bash cmd.sh

# use gdb to inspect the interpretee's stack, similarly as in v2
rm -fr test-prod-cons/
gdb 
  so gdbfile
  p state.dumpStacks ()
#trace below shows deadlock in Klee on Executor_Threading.cpp:126 (see gdbfile)
#since both threads are disabled, which refers to Tab.2 row 3 test case

# both threads are disabled.
# call stack
  0x51449a0 ===Thread ID: 0 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=0) asm:625
  #4 00000664 in __user_main (argc=1, argv=140733018341376) asm:664
  #5 00001453 in __uClibc_main (main=28491392, argc=1, argv=140733018341376, app_init=0, app_fini=0, rtld_fini=0, stack_end=0) at /home/tao/Cloud9/src/klee-uclibc/libc/misc/internals/__uClibc_main.c:402 asm:1453
  #6 00004452 in main (=1, =140733018341376) asm:4452

-->> Current Thread
  0x511b4b0 ===Thread ID: 1 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=140733018354884) asm:625


# v3, row 4
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v3
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v4 row 5
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v4
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v5 row 6
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v5
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYXYX

# use gdb to inspect the interpretee's stack, similarly as in v2

# v6
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v6
rm -fr test-prod-cons/
bash cmd.sh

# use gdb to inspect the interpretee's stack, similarly as in v2
rm -fr test-prod-cons/
gdb 
  so gdbfile
  p state.dumpStacks ()
#trace below shows deadlock in Klee on Executor_Threading.cpp:126 (see gdbfile)
#since both threads are disabled, which refers to Tab.2 row 3 test case

# both threads are disabled.
# call stack
  0x51449a0 ===Thread ID: 0 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=0) asm:625
  #4 00000664 in __user_main (argc=1, argv=140733018341376) asm:664
  #5 00001453 in __uClibc_main (main=28491392, argc=1, argv=140733018341376, app_init=0, app_fini=0, rtld_fini=0, stack_end=0) at /home/tao/Cloud9/src/klee-uclibc/libc/misc/internals/__uClibc_main.c:402 asm:1453
  #6 00004452 in main (=1, =140733018341376) asm:4452

-->> Current Thread
  0x511b4b0 ===Thread ID: 1 , mystring: XYY 
 pc: 
  ret void, !dbg !3269

entry:
  call void @klee_thread_preempt(i32 %yield) nounwind, !dbg !3267
  ret void, !dbg !3269

, disabled
  #0 00006961 in __thread_preempt (yield=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/multiprocess.h:180 asm:6961
  #1 00006955 in mySleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:56 asm:6955
  #2 00007029 in sleep (seconds=2) at /home/tao/Cloud9/src/cloud9/runtime/POSIX/misc.c:92 asm:7029
  #3 00000625 in flexHammerThread (pArg=140733018354884) asm:625


# v3, row 4
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v3
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v4 row 5
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v4
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYYXY

# v5 row 6
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v5
rm -fr test-prod-cons/
bash cmd.sh
#output should indicate a violation string: XYYXYX

# use gdb to inspect the interpretee's stack, similarly as in v2

# v6 row 7
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v6
rm -fr test-prod-cons/
bash cmd.sh

# use gdb to inspect the interpretee's stack, similarly as in v2
rm -fr test-prod-cons/
gdb 
  so gdbfile
  p state.dumpStacks ()
#2  threads disabled, deadlock

# v7 row 8
cd $HOME/BarrierFinder/splash2/Code.Table2/Barriers/v7
rm -fr test-prod-cons/
bash cmd.sh

# use gdb to inspect the interpretee's stack, similarly as in v2
gdb 
  so gdbfile
  p state.dumpStacks ()
#2  threads disabled, deadlock
