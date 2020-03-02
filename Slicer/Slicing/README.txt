11/19/2019
This is to document the problems seen by codewalk process.
The code was developed so long ago that I forgot most of it.

Following the instructions in reproduce, I am seeing a crash when making
$HOME/test/inter-slice/withIF/1b

stack trace:
#0  0x00007ffff7538267 in __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:55
#1  0x00007ffff7539eca in __GI_abort () at abort.c:89
#2  0x00007ffff753103d in __assert_fail_base (fmt=0x7ffff7693028 "%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", 
    assertion=assertion@entry=0x7ffff64e45b8 "(Args.size() == FTy->getNumParams() || (FTy->isVarArg() && Args.size() > FTy->getNumParams())) && \"Calling a function with bad signature!\"", file=file@entry=0x7ffff64e4508 "/home/tao/llvm-3.7.0.src/lib/IR/Instructions.cpp", line=line@entry=234, 
    function=function@entry=0x7ffff64e7cc0 <llvm::CallInst::init(llvm::FunctionType*, llvm::Value*, llvm::ArrayRef<llvm::Value*>, llvm::Twine const&)::__PRETTY_FUNCTION__> "void llvm::CallInst::init(llvm::FunctionType*, llvm::Value*, llvm::ArrayRef<llvm::Value*>, const llvm::Twine&)") at assert.c:92
#3  0x00007ffff75310f2 in __GI___assert_fail (
    assertion=0x7ffff64e45b8 "(Args.size() == FTy->getNumParams() || (FTy->isVarArg() && Args.size() > FTy->getNumParams())) && \"Calling a function with bad signature!\"", file=0x7ffff64e4508 "/home/tao/llvm-3.7.0.src/lib/IR/Instructions.cpp", line=234, 
    function=0x7ffff64e7cc0 <llvm::CallInst::init(llvm::FunctionType*, llvm::Value*, llvm::ArrayRef<llvm::Value*>, llvm::Twine const&)::__PRETTY_FUNCTION__> "void llvm::CallInst::init(llvm::FunctionType*, llvm::Value*, llvm::ArrayRef<llvm::Value*>, const llvm::Twine&)") at assert.c:101
#4  0x00007ffff5587d95 in llvm::CallInst::init (this=0x10673b0, FTy=0xf9c930, Func=0xf99328, Args=..., NameStr=...) at /home/tao/llvm-3.7.0.src/lib/IR/Instructions.cpp:232
#5  0x00007ffff40c77d9 in llvm::CallInst::CallInst (this=0x10673b0, Ty=0xf9c930, Func=0xf99328, Args=..., NameStr=..., InsertBefore=0xff9988)
    at /home/tao/llvm-3.7.0.src/include/llvm/IR/Instructions.h:1711
#6  0x00007ffff40c76a0 in llvm::CallInst::Create (Ty=0xf9c930, Func=0xf99328, Args=..., NameStr=..., InsertBefore=0xff9988)
    at /home/tao/llvm-3.7.0.src/include/llvm/IR/Instructions.h:1402
#7  0x00007ffff41e177f in llvm::CallInst::Create (Func=0xf99328, Args=..., NameStr=..., InsertBefore=0xff9988)
    at /home/tao/llvm-3.7.0.src/include/llvm/IR/Instructions.h:1396
#8  0x00007ffff4af13a9 in insertInitialization (mod=0xf94970, insertBefore=0xff9988, initializer=...)
    at /home/tao/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/Instrumenter.cpp:911
#9  0x00007ffff4ad5a92 in llvm::interSlice::Slicer::insertSyncID (this=0xfa3100, mod=...) at /home/tao/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/StaticSlicer.cpp:2709
#10 0x00007ffff4ad606f in llvm::interSlice::Slicer::instrumentSlice (this=0xfa3100, mod=..., F=0x0)

Solution: update front-end library print2.c. 
Copy the one in repo /home/tao/llvm-3.7.0.src/lib/Transforms/Slicer/Slicing/lib/print2.c to /home/tao/test2/inter-slice/withIF/1b

RCA: the front-end library has print.c and print2.c. When they were developed, they were not maintained in git for some reason (under
continuous redesign and reimplementation, in contrast to relative stable design in industry scenario).
There will be more bugs showing up because of this inconsistency.
Pay extra attention to this aspect!!!
