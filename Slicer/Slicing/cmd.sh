cmake ../llvm-3.7.0.src/ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$HOME/tools/llvm.debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_FLAGS="-v -O0 -ggdb3" -DCMAKE_CXX_FLAGS="-v -O0 -ggdb3" -DLLVM_BINUTILS_INCDIR=$HOME/tools/binutils.debug/include/

#no inline any function
cmake ../llvm-3.7.0.src/ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$HOME/tools/llvm.debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_FLAGS="-v -O0 -ggdb3 -fno-inline-small-functions -fno-inline-functions" -DCMAKE_CXX_FLAGS="-v -O0 -ggdb3 -fno-inline-small-functions -fno-inline-functions" -DLLVM_BINUTILS_INCDIR=$HOME/tools/binutils.debug/include/

git log -L1344,1347:StaticSlicer.cpp
git blame StaticSlicer.cpp -L 1344,1347

1. RecordSyncVariables
RecordSyncVariables is instrumentation for early-termination (ET) fixed-point (FP).
But, there is no such function in print.c, because ET and FP is only useful for sync regions with loop while
fft, cholesky, and raytrace do not have such a case.
Only Radix, lu, and fmm have such a case and need FP and ET.

In print2.c, there is RecordSyncVariables API for ET and FP.
In print.c, there is no RecordSyncVariables, as it was built before ET and FP.

In StaticSlicer.cpp, insertRecordSyncVariables is to instrument RecordSyncVariables for ET and FP.

To use print.c, insertRecordSyncVariables must be commented out.

2. 
