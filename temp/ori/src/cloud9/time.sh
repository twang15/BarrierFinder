rm -f time.txt
rm -f time.txt.reported

for((i=0; i<10; i++))
do
  
  rm -f traces.log 
  rm -rf test-prod-cons
  #{ time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/apps/fmm.inlined/a.out.bc;} 2>> time.txt
  { time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/kernels/lu/contiguous_blocks/a.out.bc;} 2>> time.txt
  #{ time Release+Asserts/bin/c9-worker -disable-opt --stand-alone -debug-sched-history -fork-on-schedule --posix-runtime --output-dir=test-prod-cons /home/tao/splash2/codes/kernels/radix/a.out.bc;} 2>> time.txt
  tail -1 traces.log >> time.txt.reported

done

grep real time.txt
