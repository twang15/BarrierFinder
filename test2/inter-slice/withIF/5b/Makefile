build:
#	clang -O0 -save-temps -flto -v -Xlinker -plugin-opt=save-temps barrier.c -lpthread
	#clang -O0 -save-temps -flto -v -Xlinker -plugin-opt=save-temps fft.c print.c -lpthread -lm
	#clang -O0 -save-temps -flto -v -Xlinker -plugin-opt=save-temps fft.c lib.c -lpthread -lm
	clang -O0 -save-temps -flto -v -Xlinker -plugin-opt=save-temps fft.c print2.c -lpthread -lm
	#opt -simplifycfg -dce -dse a.out.opt.bc -o a.out.opt.simple.bc
	#opt -simplifycfg -dce -dse -dot-cfg a.out.opt.bc 
	#llvm-dis a.out.opt.simple.bc -o a.out.ll
	#opt -dot-cfg a.out.opt.simple.bc
	opt -dot-cfg a.out.opt.bc
	llvm-dis a.out.opt.bc -o a.out.ll
	#xdot cfg.SlaveStart.dot

clean:
	rm -f *.ll *.bc *.dot *.sliced *.o *.i  *.out
