; ModuleID = 'LU.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.GlobalMemory = type { double*, double*, double*, double*, double*, i32, i32, i32, i32, i32, %struct.barrier_t, %union.pthread_mutex_t }
%struct.barrier_t = type { i32, i64 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%struct.LocalCopies = type { double, double, double, double }

@n = internal global i32 1, align 4
@P = internal global i32 2, align 4
@block_size = internal global i32 16, align 4
@test_result = internal global i32 0, align 4
@doprint = internal global i32 0, align 4
@dostats = internal global i32 0, align 4
@optarg = external global i8*, align 8
@num_rows = internal global i32 0, align 4
@num_cols = internal global i32 0, align 4
@nblocks = internal global i32 0, align 4
@proc_bytes = internal global i32* null, align 8
@last_malloc = internal global double** null, align 8
@stderr = external global %struct._IO_FILE*, align 8
@a = internal global double** null, align 8
@rhs = internal global double* null, align 8
@Global = internal global %struct.GlobalMemory* null, align 8
@stdout = external global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [12 x i8] c"n:p:b:cstoh\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"Usage: LU <options>\0A\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"options:\0A\00", align 1
@.str.3 = private unnamed_addr constant [31 x i8] c"  -nN : Decompose NxN matrix.\0A\00", align 1
@.str.4 = private unnamed_addr constant [35 x i8] c"  -pP : P = number of processors.\0A\00", align 1
@.str.5 = private unnamed_addr constant [70 x i8] c"  -bB : Use a block size of B. BxB elements should fit in cache for \0A\00", align 1
@.str.6 = private unnamed_addr constant [68 x i8] c"        good performance. Small block sizes (B=8, B=16) work well.\0A\00", align 1
@.str.7 = private unnamed_addr constant [71 x i8] c"  -c  : Copy non-locally allocated blocks to local memory before use.\0A\00", align 1
@.str.8 = private unnamed_addr constant [55 x i8] c"  -s  : Print individual processor timing statistics.\0A\00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"  -t  : Test output.\0A\00", align 1
@.str.10 = private unnamed_addr constant [34 x i8] c"  -o  : Print out matrix values.\0A\00", align 1
@.str.11 = private unnamed_addr constant [42 x i8] c"  -h  : Print out command line options.\0A\0A\00", align 1
@.str.12 = private unnamed_addr constant [31 x i8] c"Default: LU -n%1d -p%1d -b%1d\0A\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.14 = private unnamed_addr constant [32 x i8] c"Blocked Dense LU Factorization\0A\00", align 1
@.str.15 = private unnamed_addr constant [22 x i8] c"     %d by %d Matrix\0A\00", align 1
@.str.16 = private unnamed_addr constant [20 x i8] c"     %d Processors\0A\00", align 1
@.str.17 = private unnamed_addr constant [30 x i8] c"     %d by %d Element Blocks\0A\00", align 1
@.str.18 = private unnamed_addr constant [44 x i8] c"Could not malloc memory blocks for proc %d\0A\00", align 1
@.str.19 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for a\0A\00", align 1
@.str.20 = private unnamed_addr constant [33 x i8] c"Could not malloc memory for rhs\0A\00", align 1
@.str.21 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for Global\0A\00", align 1
@.str.22 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_fac\0A\00", align 1
@.str.23 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_mod\0A\00", align 1
@.str.24 = private unnamed_addr constant [48 x i8] c"Could not malloc memory for Global->t_in_solve\0A\00", align 1
@.str.25 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_bar\0A\00", align 1
@.str.26 = private unnamed_addr constant [48 x i8] c"Could not malloc memory for Global->completion\0A\00", align 1
@.str.27 = private unnamed_addr constant [30 x i8] c"Matrix before decomposition:\0A\00", align 1
@.str.28 = private unnamed_addr constant [30 x i8] c"\0AMatrix after decomposition:\0A\00", align 1
@.str.29 = private unnamed_addr constant [48 x i8] c"                            PROCESS STATISTICS\0A\00", align 1
@.str.30 = private unnamed_addr constant [77 x i8] c"              Total      Diagonal     Perimeter      Interior       Barrier\0A\00", align 1
@.str.31 = private unnamed_addr constant [75 x i8] c" Proc         Time         Time         Time           Time          Time\0A\00", align 1
@.str.32 = private unnamed_addr constant [57 x i8] c"    0    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str.33 = private unnamed_addr constant [57 x i8] c"  %3d    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str.34 = private unnamed_addr constant [57 x i8] c"  Avg    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str.35 = private unnamed_addr constant [57 x i8] c"  Min    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str.36 = private unnamed_addr constant [57 x i8] c"  Max    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str.37 = private unnamed_addr constant [48 x i8] c"                            TIMING INFORMATION\0A\00", align 1
@.str.38 = private unnamed_addr constant [42 x i8] c"Start time                        : %16d\0A\00", align 1
@.str.39 = private unnamed_addr constant [42 x i8] c"Initialization finish time        : %16d\0A\00", align 1
@.str.40 = private unnamed_addr constant [42 x i8] c"Overall finish time               : %16d\0A\00", align 1
@.str.41 = private unnamed_addr constant [42 x i8] c"Total time with initialization    : %16d\0A\00", align 1
@.str.42 = private unnamed_addr constant [42 x i8] c"Total time without initialization : %16d\0A\00", align 1
@.str.43 = private unnamed_addr constant [46 x i8] c"                             TESTING RESULTS\0A\00", align 1
@.str.49 = private unnamed_addr constant [11 x i8] c"ERROR: %s\0A\00", align 1
@.str.46 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for y\0A\00", align 1
@.str.47 = private unnamed_addr constant [26 x i8] c"TEST FAILED: (%.5f diff)\0A\00", align 1
@.str.48 = private unnamed_addr constant [13 x i8] c"TEST PASSED\0A\00", align 1
@.str.44 = private unnamed_addr constant [40 x i8] c"Proc %d could not malloc memory for lc\0A\00", align 1
@.str.45 = private unnamed_addr constant [7 x i8] c"%8.1f \00", align 1
@index_out = internal global i32 0, align 4
@gSyncVar_0 = internal global i32 0, align 4
@gSyncVar_1 = internal global i32 0, align 4
@gSyncVar_2 = internal global i32 0, align 4
@gSyncVarsTotalNum = internal global i32 0, align 4
@counter0 = internal global i32 0, align 4
@counter1 = internal global i32 0, align 4
@firstSync = internal global i8 1, align 1
@mystring = internal global [200 x i8] zeroinitializer, align 16
@switches = internal global [3 x i8] zeroinitializer, align 1
@syncID = internal global [3 x i32] zeroinitializer, align 4

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %ch = alloca i32, align 4
  %MyNum = alloca i32, align 4
  %mint = alloca double, align 8
  %maxt = alloca double, align 8
  %avgt = alloca double, align 8
  %min_fac = alloca double, align 8
  %min_solve = alloca double, align 8
  %min_mod = alloca double, align 8
  %min_bar = alloca double, align 8
  %max_fac = alloca double, align 8
  %max_solve = alloca double, align 8
  %max_mod = alloca double, align 8
  %max_bar = alloca double, align 8
  %avg_fac = alloca double, align 8
  %avg_solve = alloca double, align 8
  %avg_mod = alloca double, align 8
  %avg_bar = alloca double, align 8
  %last_page = alloca i32, align 4
  %proc_num = alloca i32, align 4
  %edge = alloca i32, align 4
  %size = alloca i32, align 4
  %start = alloca i32, align 4
  %t = alloca i64, align 8
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %0 = load i32* %argc.addr, align 4
  %1 = load i8*** %argv.addr, align 8
  %call1 = call i32 (i32, i8**, i8*, ...) *bitcast (i32 (...)* @getopt to i32 (i32, i8**, i8*, ...)*)(i32 %0, i8** %1, i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0))
  store i32 %call1, i32* %ch, align 4
  %cmp = icmp ne i32 %call1, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %ch, align 4
  switch i32 %2, label %sw.epilog [
    i32 110, label %sw.bb
    i32 112, label %sw.bb.4
    i32 98, label %sw.bb.6
    i32 115, label %sw.bb.8
    i32 116, label %sw.bb.9
    i32 111, label %sw.bb.10
    i32 104, label %sw.bb.14
  ]

sw.bb:                                            ; preds = %while.body
  %call3 = call i32 @atoi(i8* undef)
  store i32 %call3, i32* @n, align 4
  br label %sw.epilog

sw.bb.4:                                          ; preds = %while.body
  %call5 = call i32 @atoi(i8* undef)
  store i32 %call5, i32* @P, align 4
  br label %sw.epilog

sw.bb.6:                                          ; preds = %while.body
  %call7 = call i32 @atoi(i8* undef)
  store i32 %call7, i32* @block_size, align 4
  br label %sw.epilog

sw.bb.8:                                          ; preds = %while.body
  br label %sw.epilog

sw.bb.9:                                          ; preds = %while.body
  br label %sw.epilog

sw.bb.10:                                         ; preds = %while.body
  %3 = load i32* @doprint, align 4
  %tobool11 = icmp ne i32 %3, 0
  %lnot12 = xor i1 %tobool11, true
  %lnot.ext13 = zext i1 %lnot12 to i32
  store i32 %lnot.ext13, i32* @doprint, align 4
  br label %sw.epilog

sw.bb.14:                                         ; preds = %while.body
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %sw.bb.10, %sw.bb.9, %sw.bb.8, %sw.bb.6, %sw.bb.4, %sw.bb, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %4 = load i32* @P, align 4
  %conv34 = sitofp i32 %4 to double
  %call35 = call double @sqrt(double %conv34)
  %conv36 = fptosi double %call35 to i32
  store i32 %conv36, i32* @num_rows, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end, %while.end
  %5 = load i32* @P, align 4
  %6 = load i32* @num_rows, align 4
  %div = sdiv i32 %5, %6
  store i32 %div, i32* @num_cols, align 4
  %7 = load i32* @num_rows, align 4
  %8 = load i32* @num_cols, align 4
  %mul = mul nsw i32 %7, %8
  %9 = load i32* @P, align 4
  %cmp37 = icmp eq i32 %mul, %9
  br i1 %cmp37, label %if.then, label %if.end

if.then:                                          ; preds = %for.cond
  br label %for.end

if.end:                                           ; preds = %for.cond
  %10 = load i32* @num_rows, align 4
  %dec = add nsw i32 %10, -1
  store i32 %dec, i32* @num_rows, align 4
  br label %for.cond

for.end:                                          ; preds = %if.then
  %11 = load i32* @n, align 4
  %12 = load i32* @block_size, align 4
  %div39 = sdiv i32 %11, %12
  store i32 %div39, i32* @nblocks, align 4
  %13 = load i32* @block_size, align 4
  %14 = load i32* @nblocks, align 4
  %mul40 = mul nsw i32 %13, %14
  %15 = load i32* @n, align 4
  %cmp41 = icmp ne i32 %mul40, %15
  br i1 %cmp41, label %if.then.43, label %if.end.44

if.then.43:                                       ; preds = %for.end
  %16 = load i32* @nblocks, align 4
  %inc = add nsw i32 %16, 1
  store i32 %inc, i32* @nblocks, align 4
  br label %if.end.44

if.end.44:                                        ; preds = %if.then.43, %for.end
  %17 = load i32* @n, align 4
  %18 = load i32* @block_size, align 4
  %rem = srem i32 %17, %18
  store i32 %rem, i32* %edge, align 4
  %19 = load i32* %edge, align 4
  %cmp45 = icmp eq i32 %19, 0
  br i1 %cmp45, label %if.then.47, label %if.end.48

if.then.47:                                       ; preds = %if.end.44
  %20 = load i32* @block_size, align 4
  store i32 %20, i32* %edge, align 4
  br label %if.end.48

if.end.48:                                        ; preds = %if.then.47, %if.end.44
  %21 = load i32* @P, align 4
  %conv49 = sext i32 %21 to i64
  %mul50 = mul i64 %conv49, 4
  %call51 = call noalias i8* @malloc(i64 %mul50)
  %22 = bitcast i8* %call51 to i32*
  store i32* %22, i32** @proc_bytes, align 8
  %23 = load i32* @P, align 4
  %conv52 = sext i32 %23 to i64
  %mul53 = mul i64 %conv52, 8
  %call54 = call noalias i8* @malloc(i64 %mul53)
  %24 = bitcast i8* %call54 to double**
  store double** %24, double*** @last_malloc, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond.55

for.cond.55:                                      ; preds = %for.inc, %if.end.48
  %25 = load i32* %i, align 4
  %26 = load i32* @P, align 4
  %cmp56 = icmp slt i32 %25, %26
  br i1 %cmp56, label %for.body, label %for.end.61

for.body:                                         ; preds = %for.cond.55
  %27 = load i32* %i, align 4
  %idxprom = sext i32 %27 to i64
  %28 = load i32** @proc_bytes, align 8
  %arrayidx = getelementptr inbounds i32* %28, i64 %idxprom
  store i32 0, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %29 = load i32* %i, align 4
  %inc60 = add nsw i32 %29, 1
  store i32 %inc60, i32* %i, align 4
  br label %for.cond.55

for.end.61:                                       ; preds = %for.cond.55
  store i32 0, i32* %i, align 4
  br label %for.cond.62

for.cond.62:                                      ; preds = %for.inc.99, %for.end.61
  %30 = load i32* %i, align 4
  %31 = load i32* @nblocks, align 4
  %cmp63 = icmp slt i32 %30, %31
  br i1 %cmp63, label %for.body.65, label %for.end.101

for.body.65:                                      ; preds = %for.cond.62
  store i32 0, i32* %j, align 4
  br label %for.cond.66

for.cond.66:                                      ; preds = %for.inc.96, %for.body.65
  %32 = load i32* %j, align 4
  %33 = load i32* @nblocks, align 4
  %cmp67 = icmp slt i32 %32, %33
  br i1 %cmp67, label %for.body.69, label %for.end.98

for.body.69:                                      ; preds = %for.cond.66
  %34 = load i32* %i, align 4
  %35 = load i32* %j, align 4
  %call70 = call i32 @BlockOwner(i32 %34, i32 %35)
  store i32 %call70, i32* %proc_num, align 4
  %36 = load i32* %i, align 4
  %37 = load i32* @nblocks, align 4
  %sub = sub nsw i32 %37, 1
  %cmp71 = icmp eq i32 %36, %sub
  br i1 %cmp71, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %for.body.69
  %38 = load i32* %j, align 4
  %39 = load i32* @nblocks, align 4
  %sub73 = sub nsw i32 %39, 1
  %cmp74 = icmp eq i32 %38, %sub73
  br i1 %cmp74, label %if.then.76, label %if.else

if.then.76:                                       ; preds = %land.lhs.true
  %40 = load i32* %edge, align 4
  %41 = load i32* %edge, align 4
  %mul77 = mul nsw i32 %40, %41
  store i32 %mul77, i32* %size, align 4
  br label %if.end.89

if.else:                                          ; preds = %land.lhs.true, %for.body.69
  %42 = load i32* %i, align 4
  %43 = load i32* @nblocks, align 4
  %sub78 = sub nsw i32 %43, 1
  %cmp79 = icmp eq i32 %42, %sub78
  br i1 %cmp79, label %if.then.84, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.else
  %44 = load i32* %j, align 4
  %45 = load i32* @nblocks, align 4
  %sub81 = sub nsw i32 %45, 1
  %cmp82 = icmp eq i32 %44, %sub81
  br i1 %cmp82, label %if.then.84, label %if.else.86

if.then.84:                                       ; preds = %lor.lhs.false, %if.else
  %46 = load i32* %edge, align 4
  %47 = load i32* @block_size, align 4
  %mul85 = mul nsw i32 %46, %47
  store i32 %mul85, i32* %size, align 4
  br label %if.end.88

if.else.86:                                       ; preds = %lor.lhs.false
  %48 = load i32* @block_size, align 4
  %49 = load i32* @block_size, align 4
  %mul87 = mul nsw i32 %48, %49
  store i32 %mul87, i32* %size, align 4
  br label %if.end.88

if.end.88:                                        ; preds = %if.else.86, %if.then.84
  br label %if.end.89

if.end.89:                                        ; preds = %if.end.88, %if.then.76
  %50 = load i32* %size, align 4
  %conv90 = sext i32 %50 to i64
  %mul91 = mul i64 %conv90, 8
  %51 = load i32* %proc_num, align 4
  %idxprom92 = sext i32 %51 to i64
  %52 = load i32** @proc_bytes, align 8
  %arrayidx93 = getelementptr inbounds i32* %52, i64 %idxprom92
  %53 = load i32* %arrayidx93, align 4
  %conv94 = sext i32 %53 to i64
  %add = add i64 %conv94, %mul91
  %conv95 = trunc i64 %add to i32
  store i32 %conv95, i32* %arrayidx93, align 4
  br label %for.inc.96

for.inc.96:                                       ; preds = %if.end.89
  %54 = load i32* %j, align 4
  %inc97 = add nsw i32 %54, 1
  store i32 %inc97, i32* %j, align 4
  br label %for.cond.66

for.end.98:                                       ; preds = %for.cond.66
  br label %for.inc.99

for.inc.99:                                       ; preds = %for.end.98
  %55 = load i32* %i, align 4
  %inc100 = add nsw i32 %55, 1
  store i32 %inc100, i32* %i, align 4
  br label %for.cond.62

for.end.101:                                      ; preds = %for.cond.62
  store i32 0, i32* %i, align 4
  br label %for.cond.102

for.cond.102:                                     ; preds = %for.inc.130, %for.end.101
  %56 = load i32* %i, align 4
  %57 = load i32* @P, align 4
  %cmp103 = icmp slt i32 %56, %57
  br i1 %cmp103, label %for.body.105, label %for.end.132

for.body.105:                                     ; preds = %for.cond.102
  %58 = load i32* %i, align 4
  %idxprom106 = sext i32 %58 to i64
  %59 = load i32** @proc_bytes, align 8
  %arrayidx107 = getelementptr inbounds i32* %59, i64 %idxprom106
  %60 = load i32* %arrayidx107, align 4
  %add108 = add nsw i32 %60, 4096
  %conv109 = sext i32 %add108 to i64
  %call110 = call noalias i8* @malloc(i64 %conv109)
  %61 = bitcast i8* %call110 to double*
  %62 = load i32* %i, align 4
  %idxprom111 = sext i32 %62 to i64
  %63 = load double*** @last_malloc, align 8
  %arrayidx112 = getelementptr inbounds double** %63, i64 %idxprom111
  store double* %61, double** %arrayidx112, align 8
  %64 = load i32* %i, align 4
  %idxprom113 = sext i32 %64 to i64
  %65 = load double*** @last_malloc, align 8
  %arrayidx114 = getelementptr inbounds double** %65, i64 %idxprom113
  %66 = load double** %arrayidx114, align 8
  %cmp115 = icmp eq double* %66, null
  br i1 %cmp115, label %if.then.117, label %if.end.119

if.then.117:                                      ; preds = %for.body.105
  br label %UnifiedUnreachableBlock

if.end.119:                                       ; preds = %for.body.105
  br label %for.inc.130

for.inc.130:                                      ; preds = %if.end.119
  %67 = load i32* %i, align 4
  %inc131 = add nsw i32 %67, 1
  store i32 %inc131, i32* %i, align 4
  br label %for.cond.102

for.end.132:                                      ; preds = %for.cond.102
  %68 = load i32* @nblocks, align 4
  %69 = load i32* @nblocks, align 4
  %mul133 = mul nsw i32 %68, %69
  %conv134 = sext i32 %mul133 to i64
  %mul135 = mul i64 %conv134, 8
  %call136 = call noalias i8* @malloc(i64 %mul135)
  %70 = bitcast i8* %call136 to double**
  store double** %70, double*** @a, align 8
  %71 = load double*** @a, align 8
  %cmp137 = icmp eq double** %71, null
  br i1 %cmp137, label %if.then.139, label %if.end.140

if.then.139:                                      ; preds = %for.end.132
  br label %UnifiedUnreachableBlock

if.end.140:                                       ; preds = %for.end.132
  store i32 0, i32* %i, align 4
  br label %for.cond.141

for.cond.141:                                     ; preds = %for.inc.184, %if.end.140
  %72 = load i32* %i, align 4
  %73 = load i32* @nblocks, align 4
  %cmp142 = icmp slt i32 %72, %73
  br i1 %cmp142, label %for.body.144, label %for.end.186

for.body.144:                                     ; preds = %for.cond.141
  store i32 0, i32* %j, align 4
  br label %for.cond.145

for.cond.145:                                     ; preds = %for.inc.181, %for.body.144
  %74 = load i32* %j, align 4
  %75 = load i32* @nblocks, align 4
  %cmp146 = icmp slt i32 %74, %75
  br i1 %cmp146, label %for.body.148, label %for.end.183

for.body.148:                                     ; preds = %for.cond.145
  %76 = load i32* %i, align 4
  %77 = load i32* %j, align 4
  %call149 = call i32 @BlockOwner(i32 %76, i32 %77)
  br label %if.end.178

land.lhs.true.159:                                ; No predecessors!
  br label %if.end.178

if.then.163:                                      ; No predecessors!
  br label %if.end.178

if.else.165:                                      ; No predecessors!
  br label %if.end.177

lor.lhs.false.169:                                ; No predecessors!
  br label %if.end.177

if.then.173:                                      ; No predecessors!
  br label %if.end.177

if.else.175:                                      ; No predecessors!
  br label %if.end.177

if.end.177:                                       ; preds = %lor.lhs.false.169, %if.else.165, %if.else.175, %if.then.173
  br label %if.end.178

if.end.178:                                       ; preds = %land.lhs.true.159, %for.body.148, %if.end.177, %if.then.163
  br label %for.inc.181

for.inc.181:                                      ; preds = %if.end.178
  %78 = load i32* %j, align 4
  %inc182 = add nsw i32 %78, 1
  store i32 %inc182, i32* %j, align 4
  br label %for.cond.145

for.end.183:                                      ; preds = %for.cond.145
  br label %for.inc.184

for.inc.184:                                      ; preds = %for.end.183
  %79 = load i32* %i, align 4
  %inc185 = add nsw i32 %79, 1
  store i32 %inc185, i32* %i, align 4
  br label %for.cond.141

for.end.186:                                      ; preds = %for.cond.141
  %80 = load i32* @n, align 4
  %conv187 = sext i32 %80 to i64
  %mul188 = mul i64 %conv187, 8
  %call189 = call noalias i8* @malloc(i64 %mul188)
  %81 = bitcast i8* %call189 to double*
  store double* %81, double** @rhs, align 8
  %82 = load double** @rhs, align 8
  %cmp190 = icmp eq double* %82, null
  br i1 %cmp190, label %if.then.192, label %if.end.193

if.then.192:                                      ; preds = %for.end.186
  br label %UnifiedUnreachableBlock

if.end.193:                                       ; preds = %for.end.186
  %call194 = call noalias i8* @malloc(i64 120)
  %83 = bitcast i8* %call194 to %struct.GlobalMemory*
  store %struct.GlobalMemory* %83, %struct.GlobalMemory** @Global, align 8
  %84 = load i32* @P, align 4
  %conv195 = sext i32 %84 to i64
  %mul196 = mul i64 %conv195, 8
  %call197 = call noalias i8* @malloc(i64 %mul196)
  %85 = bitcast i8* %call197 to double*
  %86 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac = getelementptr inbounds %struct.GlobalMemory* %86, i32 0, i32 0
  store double* %85, double** %t_in_fac, align 8
  %87 = load i32* @P, align 4
  %conv198 = sext i32 %87 to i64
  %mul199 = mul i64 %conv198, 8
  %call200 = call noalias i8* @malloc(i64 %mul199)
  %88 = bitcast i8* %call200 to double*
  %89 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod = getelementptr inbounds %struct.GlobalMemory* %89, i32 0, i32 2
  store double* %88, double** %t_in_mod, align 8
  %90 = load i32* @P, align 4
  %conv201 = sext i32 %90 to i64
  %mul202 = mul i64 %conv201, 8
  %call203 = call noalias i8* @malloc(i64 %mul202)
  %91 = bitcast i8* %call203 to double*
  %92 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve = getelementptr inbounds %struct.GlobalMemory* %92, i32 0, i32 1
  store double* %91, double** %t_in_solve, align 8
  %93 = load i32* @P, align 4
  %conv204 = sext i32 %93 to i64
  %mul205 = mul i64 %conv204, 8
  %call206 = call noalias i8* @malloc(i64 %mul205)
  %94 = bitcast i8* %call206 to double*
  %95 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar = getelementptr inbounds %struct.GlobalMemory* %95, i32 0, i32 3
  store double* %94, double** %t_in_bar, align 8
  %96 = load i32* @P, align 4
  %conv207 = sext i32 %96 to i64
  %mul208 = mul i64 %conv207, 8
  %call209 = call noalias i8* @malloc(i64 %mul208)
  %97 = bitcast i8* %call209 to double*
  %98 = load %struct.GlobalMemory** @Global, align 8
  %completion = getelementptr inbounds %struct.GlobalMemory* %98, i32 0, i32 4
  store double* %97, double** %completion, align 8
  %99 = load %struct.GlobalMemory** @Global, align 8
  %cmp210 = icmp eq %struct.GlobalMemory* %99, null
  br i1 %cmp210, label %if.then.212, label %if.else.213

if.then.212:                                      ; preds = %if.end.193
  br label %UnifiedUnreachableBlock

if.else.213:                                      ; preds = %if.end.193
  %100 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac214 = getelementptr inbounds %struct.GlobalMemory* %100, i32 0, i32 0
  %101 = load double** %t_in_fac214, align 8
  %cmp215 = icmp eq double* %101, null
  br i1 %cmp215, label %if.then.217, label %if.else.218

if.then.217:                                      ; preds = %if.else.213
  br label %UnifiedUnreachableBlock

if.else.218:                                      ; preds = %if.else.213
  %102 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod219 = getelementptr inbounds %struct.GlobalMemory* %102, i32 0, i32 2
  %103 = load double** %t_in_mod219, align 8
  %cmp220 = icmp eq double* %103, null
  br i1 %cmp220, label %if.then.222, label %if.else.223

if.then.222:                                      ; preds = %if.else.218
  br label %UnifiedUnreachableBlock

if.else.223:                                      ; preds = %if.else.218
  %104 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve224 = getelementptr inbounds %struct.GlobalMemory* %104, i32 0, i32 1
  %105 = load double** %t_in_solve224, align 8
  %cmp225 = icmp eq double* %105, null
  br i1 %cmp225, label %if.then.227, label %if.else.228

if.then.227:                                      ; preds = %if.else.223
  br label %UnifiedUnreachableBlock

if.else.228:                                      ; preds = %if.else.223
  %106 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar229 = getelementptr inbounds %struct.GlobalMemory* %106, i32 0, i32 3
  %107 = load double** %t_in_bar229, align 8
  %cmp230 = icmp eq double* %107, null
  br i1 %cmp230, label %if.then.232, label %if.else.233

if.then.232:                                      ; preds = %if.else.228
  br label %UnifiedUnreachableBlock

if.else.233:                                      ; preds = %if.else.228
  %108 = load %struct.GlobalMemory** @Global, align 8
  %completion234 = getelementptr inbounds %struct.GlobalMemory* %108, i32 0, i32 4
  %109 = load double** %completion234, align 8
  %cmp235 = icmp eq double* %109, null
  br i1 %cmp235, label %if.then.237, label %if.end.238

if.then.237:                                      ; preds = %if.else.233
  br label %UnifiedUnreachableBlock

if.end.238:                                       ; preds = %if.else.233
  br label %if.end.239

if.end.239:                                       ; preds = %if.end.238
  br label %if.end.240

if.end.240:                                       ; preds = %if.end.239
  br label %if.end.241

if.end.241:                                       ; preds = %if.end.240
  br label %if.end.242

if.end.242:                                       ; preds = %if.end.241
  br label %if.end.243

if.end.243:                                       ; preds = %if.end.242
  store i32 2, i32* @P
  %110 = load %struct.GlobalMemory** @Global, align 8
  %start244 = getelementptr inbounds %struct.GlobalMemory* %110, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start244, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %111 = load %struct.GlobalMemory** @Global, align 8
  %start245 = getelementptr inbounds %struct.GlobalMemory* %111, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start245, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  %112 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %112, i32 0, i32 9
  store i32 0, i32* %id, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond.247

for.cond.247:                                     ; preds = %for.inc.252, %if.end.243
  %113 = load i32* %i, align 4
  %114 = load i32* @P, align 4
  %cmp248 = icmp slt i32 %113, %114
  br i1 %cmp248, label %for.body.250, label %for.end.254

for.body.250:                                     ; preds = %for.cond.247
  %call251 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %for.inc.252

for.inc.252:                                      ; preds = %for.body.250
  %115 = load i32* %i, align 4
  %inc253 = add nsw i32 %115, 1
  store i32 %inc253, i32* %i, align 4
  br label %for.cond.247

for.end.254:                                      ; preds = %for.cond.247
  br label %if.end.258

if.then.256:                                      ; No predecessors!
  br label %if.end.258

if.end.258:                                       ; preds = %for.end.254, %if.then.256
  call void @SlaveStart()
  %116 = load i32* @doprint, align 4
  %tobool259 = icmp ne i32 %116, 0
  br i1 %tobool259, label %if.then.260, label %if.end.262

if.then.260:                                      ; preds = %if.end.258
  call void @PrintA()
  br label %if.end.262

if.end.262:                                       ; preds = %if.then.260, %if.end.258
  br label %if.end.419

if.then.264:                                      ; No predecessors!
  br label %for.cond.267

for.cond.267:                                     ; preds = %for.inc.295, %if.then.264
  br label %for.end.297

for.body.270:                                     ; No predecessors!
  br label %if.end.280

if.then.276:                                      ; No predecessors!
  br label %if.end.280

if.end.280:                                       ; preds = %for.body.270, %if.then.276
  br label %if.end.290

if.then.286:                                      ; No predecessors!
  br label %if.end.290

if.end.290:                                       ; preds = %if.end.280, %if.then.286
  br label %for.inc.295

for.inc.295:                                      ; preds = %if.end.290
  br label %for.cond.267

for.end.297:                                      ; preds = %for.cond.267
  br label %for.cond.308

for.cond.308:                                     ; preds = %for.inc.408, %for.end.297
  br label %for.end.410

for.body.311:                                     ; No predecessors!
  br label %if.end.321

if.then.317:                                      ; No predecessors!
  br label %if.end.321

if.end.321:                                       ; preds = %for.body.311, %if.then.317
  br label %if.end.331

if.then.327:                                      ; No predecessors!
  br label %if.end.331

if.end.331:                                       ; preds = %if.end.321, %if.then.327
  br label %if.end.341

if.then.337:                                      ; No predecessors!
  br label %if.end.341

if.end.341:                                       ; preds = %if.end.331, %if.then.337
  br label %if.end.351

if.then.347:                                      ; No predecessors!
  br label %if.end.351

if.end.351:                                       ; preds = %if.end.341, %if.then.347
  br label %if.end.361

if.then.357:                                      ; No predecessors!
  br label %if.end.361

if.end.361:                                       ; preds = %if.end.351, %if.then.357
  br label %if.end.371

if.then.367:                                      ; No predecessors!
  br label %if.end.371

if.end.371:                                       ; preds = %if.end.361, %if.then.367
  br label %if.end.381

if.then.377:                                      ; No predecessors!
  br label %if.end.381

if.end.381:                                       ; preds = %if.end.371, %if.then.377
  br label %if.end.391

if.then.387:                                      ; No predecessors!
  br label %if.end.391

if.end.391:                                       ; preds = %if.end.381, %if.then.387
  br label %for.inc.408

for.inc.408:                                      ; preds = %if.end.391
  br label %for.cond.308

for.end.410:                                      ; preds = %for.cond.308
  br label %if.end.419

if.end.419:                                       ; preds = %if.end.262, %for.end.410
  br label %if.end.462

if.then.435:                                      ; No predecessors!
  br label %for.cond.436

for.cond.436:                                     ; preds = %for.inc.456, %if.then.435
  br label %for.end.458

for.body.439:                                     ; No predecessors!
  br label %for.inc.456

for.inc.456:                                      ; preds = %for.body.439
  br label %for.cond.436

for.end.458:                                      ; preds = %for.cond.436
  br label %if.end.462

if.end.462:                                       ; preds = %if.end.419, %for.end.458
  br label %if.end.481

if.then.479:                                      ; No predecessors!
  br label %if.end.481

if.end.481:                                       ; preds = %if.end.462, %if.then.479
  br label %UnifiedUnreachableBlock

return:                                           ; No predecessors!
  ret i32 undef

UnifiedUnreachableBlock:                          ; preds = %if.end.481, %if.then.237, %if.then.232, %if.then.227, %if.then.222, %if.then.217, %if.then.212, %if.then.192, %if.then.139, %if.then.117, %sw.bb.14
  call void @waitForAll()
  unreachable
}

; Function Attrs: nounwind
declare i64 @time(i64*)

declare i32 @getopt(...)

; Function Attrs: nounwind readonly
declare i32 @atoi(i8*)

declare i32 @printf(i8*, ...)

; Function Attrs: noreturn nounwind
declare void @exit(i32)

; Function Attrs: nounwind
declare double @sqrt(double)

; Function Attrs: nounwind
declare noalias i8* @malloc(i64)

; Function Attrs: nounwind uwtable
define internal i32 @BlockOwner(i32 %I, i32 %J) {
entry:
  %I.addr = alloca i32, align 4
  %J.addr = alloca i32, align 4
  store i32 %I, i32* %I.addr, align 4
  store i32 %J, i32* %J.addr, align 4
  %0 = load i32* %J.addr, align 4
  %1 = load i32* @num_cols, align 4
  %rem = srem i32 %0, %1
  %2 = load i32* %I.addr, align 4
  %3 = load i32* @num_rows, align 4
  %rem1 = srem i32 %2, %3
  %4 = load i32* @num_cols, align 4
  %mul = mul nsw i32 %rem1, %4
  %add = add nsw i32 %rem, %mul
  ret i32 %add
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

; Function Attrs: nounwind uwtable
define internal void @printerr(i8* %s) {
entry:
  %s.addr = alloca i8*, align 8
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*)

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: nounwind uwtable
define internal void @InitA(double* %rhs) {
entry:
  %rhs.addr = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %ii = alloca i32, align 4
  %jj = alloca i32, align 4
  %edge = alloca i32, align 4
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  %skip = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.29, %entry
  br label %for.end.31

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body.3, %if.else, %if.then
  br label %if.end.11

if.then.8:                                        ; No predecessors!
  br label %if.end.11

if.else.10:                                       ; No predecessors!
  br label %if.end.11

if.end.11:                                        ; preds = %if.end, %if.else.10, %if.then.8
  br label %if.end.28

if.then.22:                                       ; No predecessors!
  br label %if.end.28

if.end.28:                                        ; preds = %if.end.11, %if.then.22
  br label %for.inc

for.inc:                                          ; preds = %if.end.28
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.29

for.inc.29:                                       ; preds = %for.end
  br label %for.cond

for.end.31:                                       ; preds = %for.cond
  br label %for.cond.32

for.cond.32:                                      ; preds = %for.inc.38, %for.end.31
  br label %for.end.40

for.body.35:                                      ; No predecessors!
  br label %for.inc.38

for.inc.38:                                       ; preds = %for.body.35
  br label %for.cond.32

for.end.40:                                       ; preds = %for.cond.32
  br label %for.cond.41

for.cond.41:                                      ; preds = %for.inc.81, %for.end.40
  br label %for.end.83

for.body.44:                                      ; No predecessors!
  br label %for.cond.45

for.cond.45:                                      ; preds = %for.inc.78, %for.body.44
  br label %for.end.80

for.body.48:                                      ; No predecessors!
  br label %if.end.55

if.then.52:                                       ; No predecessors!
  br label %if.end.55

if.else.54:                                       ; No predecessors!
  br label %if.end.55

if.end.55:                                        ; preds = %for.body.48, %if.else.54, %if.then.52
  br label %if.end.62

if.then.59:                                       ; No predecessors!
  br label %if.end.62

if.else.61:                                       ; No predecessors!
  br label %if.end.62

if.end.62:                                        ; preds = %if.end.55, %if.else.61, %if.then.59
  br label %for.inc.78

for.inc.78:                                       ; preds = %if.end.62
  br label %for.cond.45

for.end.80:                                       ; preds = %for.cond.45
  br label %for.inc.81

for.inc.81:                                       ; preds = %for.end.80
  br label %for.cond.41

for.end.83:                                       ; preds = %for.cond.41
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckResult(i32 %n, double** %a, double* %rhs) {
entry:
  %n.addr = alloca i32, align 4
  %a.addr = alloca double**, align 8
  %rhs.addr = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %bogus = alloca i32, align 4
  %y = alloca double*, align 8
  %diff = alloca double, align 8
  %max_diff = alloca double, align 8
  %ii = alloca i32, align 4
  %jj = alloca i32, align 4
  %edge = alloca i32, align 4
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  %skip = alloca i32, align 4
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %for.cond.6

for.cond.6:                                       ; preds = %for.inc.63, %for.end
  br label %for.end.65

for.body.9:                                       ; No predecessors!
  br label %if.end.14

if.then.12:                                       ; No predecessors!
  br label %if.end.14

if.else:                                          ; No predecessors!
  br label %if.end.14

if.end.14:                                        ; preds = %for.body.9, %if.else, %if.then.12
  br label %for.cond.31

for.cond.31:                                      ; preds = %for.inc.60, %if.end.14
  br label %for.end.62

for.body.34:                                      ; No predecessors!
  br label %if.end.41

if.then.38:                                       ; No predecessors!
  br label %if.end.41

if.else.40:                                       ; No predecessors!
  br label %if.end.41

if.end.41:                                        ; preds = %for.body.34, %if.else.40, %if.then.38
  br label %for.inc.60

for.inc.60:                                       ; preds = %if.end.41
  br label %for.cond.31

for.end.62:                                       ; preds = %for.cond.31
  br label %for.inc.63

for.inc.63:                                       ; preds = %for.end.62
  br label %for.cond.6

for.end.65:                                       ; preds = %for.cond.6
  br label %for.cond.67

for.cond.67:                                      ; preds = %for.inc.110, %for.end.65
  br label %for.end.111

for.body.70:                                      ; No predecessors!
  br label %for.cond.71

for.cond.71:                                      ; preds = %for.inc.107, %for.body.70
  br label %for.end.109

for.body.74:                                      ; No predecessors!
  br label %if.end.81

if.then.78:                                       ; No predecessors!
  br label %if.end.81

if.else.80:                                       ; No predecessors!
  br label %if.end.81

if.end.81:                                        ; preds = %for.body.74, %if.else.80, %if.then.78
  br label %if.end.88

if.then.85:                                       ; No predecessors!
  br label %if.end.88

if.else.87:                                       ; No predecessors!
  br label %if.end.88

if.end.88:                                        ; preds = %if.end.81, %if.else.87, %if.then.85
  br label %for.inc.107

for.inc.107:                                      ; preds = %if.end.88
  br label %for.cond.71

for.end.109:                                      ; preds = %for.cond.71
  br label %for.inc.110

for.inc.110:                                      ; preds = %for.end.109
  br label %for.cond.67

for.end.111:                                      ; preds = %for.cond.67
  br label %for.cond.112

for.cond.112:                                     ; preds = %for.inc.124, %for.end.111
  br label %for.end.126

for.body.115:                                     ; No predecessors!
  br label %if.end.123

if.then.122:                                      ; No predecessors!
  br label %if.end.123

if.end.123:                                       ; preds = %for.body.115, %if.then.122
  br label %for.inc.124

for.inc.124:                                      ; preds = %if.end.123
  br label %for.cond.112

for.end.126:                                      ; preds = %for.cond.112
  br label %if.end.131

if.then.127:                                      ; No predecessors!
  br label %if.end.131

if.else.129:                                      ; No predecessors!
  br label %if.end.131

if.end.131:                                       ; preds = %for.end.126, %if.else.129, %if.then.127
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @atomic_cmpxchg(i32 %oldcount, i32 %newcount) {
entry:
  %oldcount.addr = alloca i32, align 4
  %newcount.addr = alloca i32, align 4
  %temp = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  store i32 %oldcount, i32* %oldcount.addr, align 4
  store i32 %newcount, i32* %newcount.addr, align 4
  %0 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 1
  %1 = load volatile i64* %count, align 8
  %conv = trunc i64 %1 to i32
  store i32 %conv, i32* %temp, align 4
  %2 = load i32* %oldcount.addr, align 4
  %3 = load i32* %temp, align 4
  %cmp = icmp eq i32 %2, %3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %4 = load i32* %newcount.addr, align 4
  %conv2 = sext i32 %4 to i64
  %5 = load %struct.GlobalMemory** @Global, align 8
  %start3 = getelementptr inbounds %struct.GlobalMemory* %5, i32 0, i32 10
  %count4 = getelementptr inbounds %struct.barrier_t* %start3, i32 0, i32 1
  store volatile i64 %conv2, i64* %count4, align 8
  call void @snapshot64(i64 %conv2, i32 0)
  %6 = load i32* %oldcount.addr, align 4
  store i32 %6, i32* %updatedcount, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %7 = load %struct.GlobalMemory** @Global, align 8
  %start5 = getelementptr inbounds %struct.GlobalMemory* %7, i32 0, i32 10
  %count6 = getelementptr inbounds %struct.barrier_t* %start5, i32 0, i32 1
  %8 = load volatile i64* %count6, align 8
  %conv7 = trunc i64 %8 to i32
  store i32 %conv7, i32* %updatedcount, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %9 = load i32* %updatedcount, align 4
  ret i32 %9
}

; Function Attrs: nounwind uwtable
define internal void @SlaveStart() {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cluster = alloca i32, align 4
  %max_block = alloca i32, align 4
  %MyNum = alloca i32, align 4
  %0 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 9
  %1 = load i32* %id, align 4
  store i32 %1, i32* %MyNum, align 4
  %2 = load %struct.GlobalMemory** @Global, align 8
  %id1 = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 9
  %3 = load i32* %id1, align 4
  %inc = add nsw i32 %3, 1
  store i32 %inc, i32* %id1, align 4
  %4 = load i32* @n, align 4
  %5 = load i32* @block_size, align 4
  %6 = load i32* %MyNum, align 4
  call void @OneSolve(i32 %4, i32 %5, double** undef, i32 %6, i32 undef)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

; Function Attrs: nounwind uwtable
define internal void @OneSolve(i32 %n, i32 %block_size, double** %a, i32 %MyNum, i32 %dostats) {
entry:
  %n.addr = alloca i32, align 4
  %block_size.addr = alloca i32, align 4
  %a.addr = alloca double**, align 8
  %MyNum.addr = alloca i32, align 4
  %dostats.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %myrs = alloca i32, align 4
  %myrf = alloca i32, align 4
  %mydone = alloca i32, align 4
  %lc = alloca %struct.LocalCopies*, align 8
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense28 = alloca i32, align 4
  %oldcount33 = alloca i32, align 4
  %newcount37 = alloca i32, align 4
  %updatedcount39 = alloca i32, align 4
  %retVal40 = alloca i32, align 4
  %lsense85 = alloca i32, align 4
  %oldcount90 = alloca i32, align 4
  %newcount94 = alloca i32, align 4
  %updatedcount96 = alloca i32, align 4
  %retVal97 = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  store i32 %block_size, i32* %block_size.addr, align 4
  store i32 %MyNum, i32* %MyNum.addr, align 4
  %call = call noalias i8* @malloc(i64 32)
  %0 = bitcast i8* %call to %struct.LocalCopies*
  store %struct.LocalCopies* %0, %struct.LocalCopies** %lc, align 8
  %1 = load %struct.LocalCopies** %lc, align 8
  %cmp = icmp eq %struct.LocalCopies* %1, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  %2 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  call void @printChar(i8 signext 49)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %3 = load volatile i32* %gsense, align 4
  store i32 %3, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.20, %if.end
  %4 = load %struct.GlobalMemory** @Global, align 8
  %start2 = getelementptr inbounds %struct.GlobalMemory* %4, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start2, i32 0, i32 1
  %5 = load volatile i64* %count, align 8
  %call1 = call i32 @sleep(i32 1)
  %conv = trunc i64 %5 to i32
  store i32 %conv, i32* %oldcount, align 4
  %6 = load i32* %oldcount, align 4
  %7 = load i32* %lsense, align 4
  %add = add nsw i32 %6, %7
  store i32 %add, i32* %newcount, align 4
  %8 = load i32* %oldcount, align 4
  %9 = load i32* %newcount, align 4
  %call3 = call i32 @atomic_cmpxchg(i32 %8, i32 %9)
  %call7 = call i32 @sleep(i32 1)
  store i32 %call3, i32* %updatedcount, align 4
  %10 = load i32* %updatedcount, align 4
  %11 = load i32* %oldcount, align 4
  %cmp4 = icmp eq i32 %10, %11
  br i1 %cmp4, label %if.then.6, label %if.end.20

if.then.6:                                        ; preds = %while.body
  %12 = load i32* %newcount, align 4
  %13 = load i32* @P, align 4
  %call2 = call i32 @sleep(i32 1)
  %cmp7 = icmp eq i32 %12, %13
  br i1 %cmp7, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then.6
  %14 = load i32* %lsense, align 4
  %cmp9 = icmp eq i32 %14, 1
  br i1 %cmp9, label %if.then.16, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then.6
  %15 = load i32* %newcount, align 4
  %cmp11 = icmp eq i32 %15, 0
  br i1 %cmp11, label %land.lhs.true.13, label %if.end.19

land.lhs.true.13:                                 ; preds = %lor.lhs.false
  %16 = load i32* %lsense, align 4
  %cmp14 = icmp eq i32 %16, -1
  br i1 %cmp14, label %if.then.16, label %if.end.19

if.then.16:                                       ; preds = %land.lhs.true.13, %land.lhs.true
  %17 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %17
  %18 = load %struct.GlobalMemory** @Global, align 8
  %start17 = getelementptr inbounds %struct.GlobalMemory* %18, i32 0, i32 10
  %gsense18 = getelementptr inbounds %struct.barrier_t* %start17, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub, i32* %gsense18, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call4 = call i32 @sleep(i32 3)
  br label %if.end.19

if.end.19:                                        ; preds = %if.then.16, %land.lhs.true.13, %lor.lhs.false
  br label %while.end

if.end.20:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.19
  br label %while.cond

while.cond:                                       ; preds = %while.body.25, %while.end
  %19 = load %struct.GlobalMemory** @Global, align 8
  %start21 = getelementptr inbounds %struct.GlobalMemory* %19, i32 0, i32 10
  %gsense22 = getelementptr inbounds %struct.barrier_t* %start21, i32 0, i32 0
  %20 = load volatile i32* %gsense22, align 4
  %21 = load i32* %lsense, align 4
  %cmp23 = icmp eq i32 %20, %21
  br i1 %cmp23, label %while.body.25, label %while.end.26

while.body.25:                                    ; preds = %while.cond
  %call5 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.26:                                     ; preds = %while.cond
  call void @printY()
  %call6 = call i32 @sleep(i32 1)
  %call27 = call double @TouchA(i32 undef, i32 undef)
  %22 = load %struct.GlobalMemory** @Global, align 8
  %start29 = getelementptr inbounds %struct.GlobalMemory* %22, i32 0, i32 10
  %gsense30 = getelementptr inbounds %struct.barrier_t* %start29, i32 0, i32 0
  call void @printChar(i8 signext 50)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %23 = load volatile i32* %gsense30, align 4
  store i32 %23, i32* %lsense28, align 4
  br label %while.body.32

while.body.32:                                    ; preds = %if.end.61, %while.end.26
  %24 = load %struct.GlobalMemory** @Global, align 8
  %start34 = getelementptr inbounds %struct.GlobalMemory* %24, i32 0, i32 10
  %count35 = getelementptr inbounds %struct.barrier_t* %start34, i32 0, i32 1
  %25 = load volatile i64* %count35, align 8
  %call8 = call i32 @sleep(i32 1)
  %conv36 = trunc i64 %25 to i32
  store i32 %conv36, i32* %oldcount33, align 4
  %26 = load i32* %oldcount33, align 4
  %27 = load i32* %lsense28, align 4
  %add38 = add nsw i32 %26, %27
  store i32 %add38, i32* %newcount37, align 4
  %28 = load i32* %oldcount33, align 4
  %29 = load i32* %newcount37, align 4
  %call41 = call i32 @atomic_cmpxchg(i32 %28, i32 %29)
  %call13 = call i32 @sleep(i32 1)
  store i32 %call41, i32* %updatedcount39, align 4
  %30 = load i32* %updatedcount39, align 4
  %31 = load i32* %oldcount33, align 4
  %cmp42 = icmp eq i32 %30, %31
  br i1 %cmp42, label %if.then.44, label %if.end.61

if.then.44:                                       ; preds = %while.body.32
  %32 = load i32* %newcount37, align 4
  %33 = load i32* @P, align 4
  %call9 = call i32 @sleep(i32 1)
  %cmp45 = icmp eq i32 %32, %33
  br i1 %cmp45, label %land.lhs.true.47, label %lor.lhs.false.50

land.lhs.true.47:                                 ; preds = %if.then.44
  %34 = load i32* %lsense28, align 4
  %cmp48 = icmp eq i32 %34, 1
  br i1 %cmp48, label %if.then.56, label %lor.lhs.false.50

lor.lhs.false.50:                                 ; preds = %land.lhs.true.47, %if.then.44
  %35 = load i32* %newcount37, align 4
  %cmp51 = icmp eq i32 %35, 0
  br i1 %cmp51, label %land.lhs.true.53, label %if.end.60

land.lhs.true.53:                                 ; preds = %lor.lhs.false.50
  %36 = load i32* %lsense28, align 4
  %cmp54 = icmp eq i32 %36, -1
  br i1 %cmp54, label %if.then.56, label %if.end.60

if.then.56:                                       ; preds = %land.lhs.true.53, %land.lhs.true.47
  %37 = load i32* %lsense28, align 4
  %sub57 = sub nsw i32 0, %37
  %38 = load %struct.GlobalMemory** @Global, align 8
  %start58 = getelementptr inbounds %struct.GlobalMemory* %38, i32 0, i32 10
  %gsense59 = getelementptr inbounds %struct.barrier_t* %start58, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub57, i32* %gsense59, align 4
  call void @snapshot(i32 %sub57, i32 1)
  %call10 = call i32 @sleep(i32 3)
  br label %if.end.60

if.end.60:                                        ; preds = %if.then.56, %land.lhs.true.53, %lor.lhs.false.50
  br label %while.end.62

if.end.61:                                        ; preds = %while.body.32
  br label %while.body.32

while.end.62:                                     ; preds = %if.end.60
  br label %while.cond.63

while.cond.63:                                    ; preds = %while.body.68, %while.end.62
  %39 = load %struct.GlobalMemory** @Global, align 8
  %start64 = getelementptr inbounds %struct.GlobalMemory* %39, i32 0, i32 10
  %gsense65 = getelementptr inbounds %struct.barrier_t* %start64, i32 0, i32 0
  %40 = load volatile i32* %gsense65, align 4
  %41 = load i32* %lsense28, align 4
  %cmp66 = icmp eq i32 %40, %41
  br i1 %cmp66, label %while.body.68, label %while.end.69

while.body.68:                                    ; preds = %while.cond.63
  %call11 = call i32 @sleep(i32 2)
  br label %while.cond.63

while.end.69:                                     ; preds = %while.cond.63
  call void @printY()
  %call12 = call i32 @sleep(i32 1)
  br label %if.end.76

lor.lhs.false.72:                                 ; No predecessors!
  br label %if.end.76

if.then.73:                                       ; No predecessors!
  br label %if.end.76

if.end.76:                                        ; preds = %lor.lhs.false.72, %while.end.69, %if.then.73
  %42 = load i32* %n.addr, align 4
  %43 = load i32* %block_size.addr, align 4
  %44 = load i32* %MyNum.addr, align 4
  call void @lu(i32 %42, i32 %43, i32 %44, %struct.LocalCopies* undef, i32 undef)
  br label %if.end.84

lor.lhs.false.79:                                 ; No predecessors!
  br label %if.end.84

if.then.81:                                       ; No predecessors!
  br label %if.end.84

if.end.84:                                        ; preds = %lor.lhs.false.79, %if.end.76, %if.then.81
  %45 = load %struct.GlobalMemory** @Global, align 8
  %start86 = getelementptr inbounds %struct.GlobalMemory* %45, i32 0, i32 10
  %gsense87 = getelementptr inbounds %struct.barrier_t* %start86, i32 0, i32 0
  call void @printChar(i8 signext 51)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %46 = load volatile i32* %gsense87, align 4
  store i32 %46, i32* %lsense85, align 4
  br label %while.body.89

while.body.89:                                    ; preds = %if.end.118, %if.end.84
  %47 = load %struct.GlobalMemory** @Global, align 8
  %start91 = getelementptr inbounds %struct.GlobalMemory* %47, i32 0, i32 10
  %count92 = getelementptr inbounds %struct.barrier_t* %start91, i32 0, i32 1
  %48 = load volatile i64* %count92, align 8
  %call14 = call i32 @sleep(i32 1)
  %conv93 = trunc i64 %48 to i32
  store i32 %conv93, i32* %oldcount90, align 4
  %49 = load i32* %oldcount90, align 4
  %50 = load i32* %lsense85, align 4
  %add95 = add nsw i32 %49, %50
  store i32 %add95, i32* %newcount94, align 4
  %51 = load i32* %oldcount90, align 4
  %52 = load i32* %newcount94, align 4
  %call98 = call i32 @atomic_cmpxchg(i32 %51, i32 %52)
  %call19 = call i32 @sleep(i32 1)
  store i32 %call98, i32* %updatedcount96, align 4
  %53 = load i32* %updatedcount96, align 4
  %54 = load i32* %oldcount90, align 4
  %cmp99 = icmp eq i32 %53, %54
  br i1 %cmp99, label %if.then.101, label %if.end.118

if.then.101:                                      ; preds = %while.body.89
  %55 = load i32* %newcount94, align 4
  %56 = load i32* @P, align 4
  %call15 = call i32 @sleep(i32 1)
  %cmp102 = icmp eq i32 %55, %56
  br i1 %cmp102, label %land.lhs.true.104, label %lor.lhs.false.107

land.lhs.true.104:                                ; preds = %if.then.101
  %57 = load i32* %lsense85, align 4
  %cmp105 = icmp eq i32 %57, 1
  br i1 %cmp105, label %if.then.113, label %lor.lhs.false.107

lor.lhs.false.107:                                ; preds = %land.lhs.true.104, %if.then.101
  %58 = load i32* %newcount94, align 4
  %cmp108 = icmp eq i32 %58, 0
  br i1 %cmp108, label %land.lhs.true.110, label %if.end.117

land.lhs.true.110:                                ; preds = %lor.lhs.false.107
  %59 = load i32* %lsense85, align 4
  %cmp111 = icmp eq i32 %59, -1
  br i1 %cmp111, label %if.then.113, label %if.end.117

if.then.113:                                      ; preds = %land.lhs.true.110, %land.lhs.true.104
  %60 = load i32* %lsense85, align 4
  %sub114 = sub nsw i32 0, %60
  %61 = load %struct.GlobalMemory** @Global, align 8
  %start115 = getelementptr inbounds %struct.GlobalMemory* %61, i32 0, i32 10
  %gsense116 = getelementptr inbounds %struct.barrier_t* %start115, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub114, i32* %gsense116, align 4
  call void @snapshot(i32 %sub114, i32 1)
  %call16 = call i32 @sleep(i32 3)
  br label %if.end.117

if.end.117:                                       ; preds = %if.then.113, %land.lhs.true.110, %lor.lhs.false.107
  br label %while.end.119

if.end.118:                                       ; preds = %while.body.89
  br label %while.body.89

while.end.119:                                    ; preds = %if.end.117
  br label %while.cond.120

while.cond.120:                                   ; preds = %while.body.125, %while.end.119
  %62 = load %struct.GlobalMemory** @Global, align 8
  %start121 = getelementptr inbounds %struct.GlobalMemory* %62, i32 0, i32 10
  %gsense122 = getelementptr inbounds %struct.barrier_t* %start121, i32 0, i32 0
  %63 = load volatile i32* %gsense122, align 4
  %64 = load i32* %lsense85, align 4
  %cmp123 = icmp eq i32 %63, %64
  br i1 %cmp123, label %while.body.125, label %while.end.126

while.body.125:                                   ; preds = %while.cond.120
  %call17 = call i32 @sleep(i32 2)
  br label %while.cond.120

while.end.126:                                    ; preds = %while.cond.120
  call void @printY()
  %call18 = call i32 @sleep(i32 1)
  br label %if.end.150

lor.lhs.false.129:                                ; No predecessors!
  br label %if.end.150

if.then.131:                                      ; No predecessors!
  br label %if.end.150

if.end.150:                                       ; preds = %lor.lhs.false.129, %while.end.126, %if.then.131
  br label %if.end.156

if.then.153:                                      ; No predecessors!
  br label %if.end.156

if.end.156:                                       ; preds = %if.end.150, %if.then.153
  ret void
}

declare void @Criteria(i32)

; Function Attrs: nounwind uwtable
define internal double @TouchA(i32 %bs, i32 %MyNum) {
entry:
  %bs.addr = alloca i32, align 4
  %MyNum.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %I = alloca i32, align 4
  %J = alloca i32, align 4
  %tot = alloca double, align 8
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  store i32 0, i32* %J, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.37, %entry
  %0 = load i32* %J, align 4
  %1 = load i32* @nblocks, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.39

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %I, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.34, %for.body
  %2 = load i32* %I, align 4
  %3 = load i32* @nblocks, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body.3, label %for.end.36

for.body.3:                                       ; preds = %for.cond.1
  %4 = load i32* %I, align 4
  %5 = load i32* %J, align 4
  %call = call i32 @BlockOwner(i32 %4, i32 %5)
  br label %if.end.33

if.then:                                          ; No predecessors!
  br label %if.end.9

if.then.6:                                        ; No predecessors!
  br label %if.end

if.then.8:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then.6, %if.then.8
  br label %if.end.9

if.else:                                          ; No predecessors!
  br label %if.end.9

if.end.9:                                         ; preds = %if.then, %if.else, %if.end
  br label %if.end.18

if.then.12:                                       ; No predecessors!
  br label %if.end.16

if.then.15:                                       ; No predecessors!
  br label %if.end.16

if.end.16:                                        ; preds = %if.then.12, %if.then.15
  br label %if.end.18

if.else.17:                                       ; No predecessors!
  br label %if.end.18

if.end.18:                                        ; preds = %if.end.9, %if.else.17, %if.end.16
  br label %for.cond.19

for.cond.19:                                      ; preds = %for.inc.30, %if.end.18
  br label %for.end.32

for.body.21:                                      ; No predecessors!
  br label %for.cond.22

for.cond.22:                                      ; preds = %for.inc, %for.body.21
  br label %for.end

for.body.24:                                      ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.24
  br label %for.cond.22

for.end:                                          ; preds = %for.cond.22
  br label %for.inc.30

for.inc.30:                                       ; preds = %for.end
  br label %for.cond.19

for.end.32:                                       ; preds = %for.cond.19
  br label %if.end.33

if.end.33:                                        ; preds = %for.body.3, %for.end.32
  br label %for.inc.34

for.inc.34:                                       ; preds = %if.end.33
  %6 = load i32* %I, align 4
  %inc35 = add nsw i32 %6, 1
  store i32 %inc35, i32* %I, align 4
  br label %for.cond.1

for.end.36:                                       ; preds = %for.cond.1
  br label %for.inc.37

for.inc.37:                                       ; preds = %for.end.36
  %7 = load i32* %J, align 4
  %inc38 = add nsw i32 %7, 1
  store i32 %inc38, i32* %J, align 4
  br label %for.cond

for.end.39:                                       ; preds = %for.cond
  ret double undef
}

; Function Attrs: nounwind uwtable
define internal void @lu(i32 %n, i32 %bs, i32 %MyNum, %struct.LocalCopies* %lc, i32 %dostats) {
entry:
  %n.addr = alloca i32, align 4
  %bs.addr = alloca i32, align 4
  %MyNum.addr = alloca i32, align 4
  %lc.addr = alloca %struct.LocalCopies*, align 8
  %dostats.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %il = alloca i32, align 4
  %j = alloca i32, align 4
  %jl = alloca i32, align 4
  %k = alloca i32, align 4
  %kl = alloca i32, align 4
  %I = alloca i32, align 4
  %J = alloca i32, align 4
  %K = alloca i32, align 4
  %A = alloca double*, align 8
  %B = alloca double*, align 8
  %C = alloca double*, align 8
  %D = alloca double*, align 8
  %dimI = alloca i32, align 4
  %dimJ = alloca i32, align 4
  %dimK = alloca i32, align 4
  %strI = alloca i32, align 4
  %strJ = alloca i32, align 4
  %strK = alloca i32, align 4
  %t1 = alloca i32, align 4
  %t2 = alloca i32, align 4
  %t3 = alloca i32, align 4
  %t4 = alloca i32, align 4
  %t11 = alloca i32, align 4
  %t22 = alloca i32, align 4
  %diagowner = alloca i32, align 4
  %colowner = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense115 = alloca i32, align 4
  %oldcount120 = alloca i32, align 4
  %newcount124 = alloca i32, align 4
  %updatedcount126 = alloca i32, align 4
  %retVal127 = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  store i32 %bs, i32* %bs.addr, align 4
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store i32 0, i32* %k, align 4
  store i32 0, i32* %K, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.237, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.240

for.body:                                         ; preds = %for.cond
  %2 = load i32* %k, align 4
  %3 = load i32* %bs.addr, align 4
  %add = add nsw i32 %2, %3
  store i32 %add, i32* %kl, align 4
  %4 = load i32* %kl, align 4
  %5 = load i32* %n.addr, align 4
  %cmp1 = icmp sgt i32 %4, %5
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %6 = load i32* %n.addr, align 4
  store i32 %6, i32* %kl, align 4
  %7 = load i32* %kl, align 4
  %8 = load i32* %k, align 4
  %sub = sub nsw i32 %7, %8
  store i32 %sub, i32* %strK, align 4
  br label %if.end

if.else:                                          ; preds = %for.body
  %9 = load i32* %bs.addr, align 4
  store i32 %9, i32* %strK, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %if.end.4

lor.lhs.false:                                    ; No predecessors!
  br label %if.end.4

if.then.3:                                        ; No predecessors!
  br label %if.end.4

if.end.4:                                         ; preds = %lor.lhs.false, %if.end, %if.then.3
  %10 = load i32* %K, align 4
  %11 = load i32* %K, align 4
  %call5 = call i32 @BlockOwner(i32 %10, i32 %11)
  store i32 %call5, i32* %diagowner, align 4
  %12 = load i32* %diagowner, align 4
  %13 = load i32* %MyNum.addr, align 4
  %cmp6 = icmp eq i32 %12, %13
  br i1 %cmp6, label %if.then.8, label %if.end.10

if.then.8:                                        ; preds = %if.end.4
  %14 = load i32* %strK, align 4
  call void @lu0(double* undef, i32 %14, i32 undef)
  br label %if.end.10

if.end.10:                                        ; preds = %if.then.8, %if.end.4
  br label %if.end.18

lor.lhs.false.13:                                 ; No predecessors!
  br label %if.end.18

if.then.15:                                       ; No predecessors!
  br label %if.end.18

if.end.18:                                        ; preds = %lor.lhs.false.13, %if.end.10, %if.then.15
  %15 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %15, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  call void @printChar(i8 signext 52)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %16 = load volatile i32* %gsense, align 4
  store i32 %16, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.41, %if.end.18
  %17 = load %struct.GlobalMemory** @Global, align 8
  %start19 = getelementptr inbounds %struct.GlobalMemory* %17, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start19, i32 0, i32 1
  %18 = load volatile i64* %count, align 8
  %call = call i32 @sleep(i32 1)
  %conv20 = trunc i64 %18 to i32
  store i32 %conv20, i32* %oldcount, align 4
  %19 = load i32* %oldcount, align 4
  %20 = load i32* %lsense, align 4
  %add21 = add nsw i32 %19, %20
  store i32 %add21, i32* %newcount, align 4
  %21 = load i32* %oldcount, align 4
  %22 = load i32* %newcount, align 4
  %call22 = call i32 @atomic_cmpxchg(i32 %21, i32 %22)
  %call6 = call i32 @sleep(i32 1)
  store i32 %call22, i32* %updatedcount, align 4
  %23 = load i32* %updatedcount, align 4
  %24 = load i32* %oldcount, align 4
  %cmp23 = icmp eq i32 %23, %24
  br i1 %cmp23, label %if.then.25, label %if.end.41

if.then.25:                                       ; preds = %while.body
  %25 = load i32* %newcount, align 4
  %26 = load i32* @P, align 4
  %call1 = call i32 @sleep(i32 1)
  %cmp26 = icmp eq i32 %25, %26
  br i1 %cmp26, label %land.lhs.true, label %lor.lhs.false.30

land.lhs.true:                                    ; preds = %if.then.25
  %27 = load i32* %lsense, align 4
  %cmp28 = icmp eq i32 %27, 1
  br i1 %cmp28, label %if.then.36, label %lor.lhs.false.30

lor.lhs.false.30:                                 ; preds = %land.lhs.true, %if.then.25
  %28 = load i32* %newcount, align 4
  %cmp31 = icmp eq i32 %28, 0
  br i1 %cmp31, label %land.lhs.true.33, label %if.end.40

land.lhs.true.33:                                 ; preds = %lor.lhs.false.30
  %29 = load i32* %lsense, align 4
  %cmp34 = icmp eq i32 %29, -1
  br i1 %cmp34, label %if.then.36, label %if.end.40

if.then.36:                                       ; preds = %land.lhs.true.33, %land.lhs.true
  %30 = load i32* %lsense, align 4
  %sub37 = sub nsw i32 0, %30
  %31 = load %struct.GlobalMemory** @Global, align 8
  %start38 = getelementptr inbounds %struct.GlobalMemory* %31, i32 0, i32 10
  %gsense39 = getelementptr inbounds %struct.barrier_t* %start38, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub37, i32* %gsense39, align 4
  call void @snapshot(i32 %sub37, i32 1)
  %call2 = call i32 @sleep(i32 3)
  br label %if.end.40

if.end.40:                                        ; preds = %if.then.36, %land.lhs.true.33, %lor.lhs.false.30
  br label %while.end

if.end.41:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.40
  br label %while.cond

while.cond:                                       ; preds = %while.body.46, %while.end
  %32 = load %struct.GlobalMemory** @Global, align 8
  %start42 = getelementptr inbounds %struct.GlobalMemory* %32, i32 0, i32 10
  %gsense43 = getelementptr inbounds %struct.barrier_t* %start42, i32 0, i32 0
  %33 = load volatile i32* %gsense43, align 4
  %34 = load i32* %lsense, align 4
  %cmp44 = icmp eq i32 %33, %34
  br i1 %cmp44, label %while.body.46, label %while.end.47

while.body.46:                                    ; preds = %while.cond
  %call3 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.47:                                     ; preds = %while.cond
  call void @printY()
  %call4 = call i32 @sleep(i32 1)
  br label %if.end.55

lor.lhs.false.50:                                 ; No predecessors!
  br label %if.end.55

if.then.52:                                       ; No predecessors!
  br label %if.end.55

if.end.55:                                        ; preds = %lor.lhs.false.50, %while.end.47, %if.then.52
  %35 = load i32* %kl, align 4
  store i32 %35, i32* %i, align 4
  %36 = load i32* %K, align 4
  %add60 = add nsw i32 %36, 1
  store i32 %add60, i32* %I, align 4
  br label %for.cond.61

for.cond.61:                                      ; preds = %for.inc, %if.end.55
  %37 = load i32* %i, align 4
  %38 = load i32* %n.addr, align 4
  %cmp62 = icmp slt i32 %37, %38
  br i1 %cmp62, label %for.body.64, label %for.end

for.body.64:                                      ; preds = %for.cond.61
  %39 = load i32* %I, align 4
  %40 = load i32* %K, align 4
  %call65 = call i32 @BlockOwner(i32 %39, i32 %40)
  %41 = load i32* %MyNum.addr, align 4
  %cmp66 = icmp eq i32 %call65, %41
  br i1 %cmp66, label %if.then.68, label %if.end.80

if.then.68:                                       ; preds = %for.body.64
  br label %if.end.75

if.then.72:                                       ; No predecessors!
  br label %if.end.75

if.else.74:                                       ; No predecessors!
  br label %if.end.75

if.end.75:                                        ; preds = %if.then.68, %if.else.74, %if.then.72
  %42 = load i32* %strK, align 4
  call void @bdiv(double* undef, double* undef, i32 undef, i32 undef, i32 undef, i32 %42)
  br label %if.end.80

if.end.80:                                        ; preds = %if.end.75, %for.body.64
  br label %for.inc

for.inc:                                          ; preds = %if.end.80
  %43 = load i32* %bs.addr, align 4
  %44 = load i32* %i, align 4
  %add81 = add nsw i32 %44, %43
  store i32 %add81, i32* %i, align 4
  %45 = load i32* %I, align 4
  %inc = add nsw i32 %45, 1
  store i32 %inc, i32* %I, align 4
  br label %for.cond.61

for.end:                                          ; preds = %for.cond.61
  %46 = load i32* %kl, align 4
  store i32 %46, i32* %j, align 4
  %47 = load i32* %K, align 4
  %add82 = add nsw i32 %47, 1
  store i32 %add82, i32* %J, align 4
  br label %for.cond.83

for.cond.83:                                      ; preds = %for.inc.103, %for.end
  %48 = load i32* %j, align 4
  %49 = load i32* %n.addr, align 4
  %cmp84 = icmp slt i32 %48, %49
  br i1 %cmp84, label %for.body.86, label %for.end.106

for.body.86:                                      ; preds = %for.cond.83
  %50 = load i32* %K, align 4
  %51 = load i32* %J, align 4
  %call87 = call i32 @BlockOwner(i32 %50, i32 %51)
  %52 = load i32* %MyNum.addr, align 4
  %cmp88 = icmp eq i32 %call87, %52
  br i1 %cmp88, label %if.then.90, label %if.end.102

if.then.90:                                       ; preds = %for.body.86
  %53 = load i32* %j, align 4
  %54 = load i32* %bs.addr, align 4
  %add91 = add nsw i32 %53, %54
  store i32 %add91, i32* %jl, align 4
  %55 = load i32* %jl, align 4
  %56 = load i32* %n.addr, align 4
  %cmp92 = icmp sgt i32 %55, %56
  br i1 %cmp92, label %if.then.94, label %if.else.96

if.then.94:                                       ; preds = %if.then.90
  %57 = load i32* %n.addr, align 4
  store i32 %57, i32* %jl, align 4
  %58 = load i32* %jl, align 4
  %59 = load i32* %j, align 4
  %sub95 = sub nsw i32 %58, %59
  store i32 %sub95, i32* %strJ, align 4
  br label %if.end.97

if.else.96:                                       ; preds = %if.then.90
  %60 = load i32* %bs.addr, align 4
  store i32 %60, i32* %strJ, align 4
  br label %if.end.97

if.end.97:                                        ; preds = %if.else.96, %if.then.94
  %61 = load i32* %strK, align 4
  %62 = load i32* %strJ, align 4
  call void @bmodd(double* undef, double* undef, i32 %61, i32 %62, i32 undef, i32 undef)
  br label %if.end.102

if.end.102:                                       ; preds = %if.end.97, %for.body.86
  br label %for.inc.103

for.inc.103:                                      ; preds = %if.end.102
  %63 = load i32* %bs.addr, align 4
  %64 = load i32* %j, align 4
  %add104 = add nsw i32 %64, %63
  store i32 %add104, i32* %j, align 4
  %65 = load i32* %J, align 4
  %inc105 = add nsw i32 %65, 1
  store i32 %inc105, i32* %J, align 4
  br label %for.cond.83

for.end.106:                                      ; preds = %for.cond.83
  br label %if.end.114

lor.lhs.false.109:                                ; No predecessors!
  br label %if.end.114

if.then.111:                                      ; No predecessors!
  br label %if.end.114

if.end.114:                                       ; preds = %lor.lhs.false.109, %for.end.106, %if.then.111
  %66 = load %struct.GlobalMemory** @Global, align 8
  %start116 = getelementptr inbounds %struct.GlobalMemory* %66, i32 0, i32 10
  %gsense117 = getelementptr inbounds %struct.barrier_t* %start116, i32 0, i32 0
  call void @printChar(i8 signext 53)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %67 = load volatile i32* %gsense117, align 4
  store i32 %67, i32* %lsense115, align 4
  br label %while.body.119

while.body.119:                                   ; preds = %if.end.148, %if.end.114
  %68 = load %struct.GlobalMemory** @Global, align 8
  %start121 = getelementptr inbounds %struct.GlobalMemory* %68, i32 0, i32 10
  %count122 = getelementptr inbounds %struct.barrier_t* %start121, i32 0, i32 1
  %69 = load volatile i64* %count122, align 8
  %call7 = call i32 @sleep(i32 1)
  %conv123 = trunc i64 %69 to i32
  store i32 %conv123, i32* %oldcount120, align 4
  %70 = load i32* %oldcount120, align 4
  %71 = load i32* %lsense115, align 4
  %add125 = add nsw i32 %70, %71
  store i32 %add125, i32* %newcount124, align 4
  %72 = load i32* %oldcount120, align 4
  %73 = load i32* %newcount124, align 4
  %call128 = call i32 @atomic_cmpxchg(i32 %72, i32 %73)
  %call12 = call i32 @sleep(i32 1)
  store i32 %call128, i32* %updatedcount126, align 4
  %74 = load i32* %updatedcount126, align 4
  %75 = load i32* %oldcount120, align 4
  %cmp129 = icmp eq i32 %74, %75
  br i1 %cmp129, label %if.then.131, label %if.end.148

if.then.131:                                      ; preds = %while.body.119
  %76 = load i32* %newcount124, align 4
  %77 = load i32* @P, align 4
  %call8 = call i32 @sleep(i32 1)
  %cmp132 = icmp eq i32 %76, %77
  br i1 %cmp132, label %land.lhs.true.134, label %lor.lhs.false.137

land.lhs.true.134:                                ; preds = %if.then.131
  %78 = load i32* %lsense115, align 4
  %cmp135 = icmp eq i32 %78, 1
  br i1 %cmp135, label %if.then.143, label %lor.lhs.false.137

lor.lhs.false.137:                                ; preds = %land.lhs.true.134, %if.then.131
  %79 = load i32* %newcount124, align 4
  %cmp138 = icmp eq i32 %79, 0
  br i1 %cmp138, label %land.lhs.true.140, label %if.end.147

land.lhs.true.140:                                ; preds = %lor.lhs.false.137
  %80 = load i32* %lsense115, align 4
  %cmp141 = icmp eq i32 %80, -1
  br i1 %cmp141, label %if.then.143, label %if.end.147

if.then.143:                                      ; preds = %land.lhs.true.140, %land.lhs.true.134
  %81 = load i32* %lsense115, align 4
  %sub144 = sub nsw i32 0, %81
  %82 = load %struct.GlobalMemory** @Global, align 8
  %start145 = getelementptr inbounds %struct.GlobalMemory* %82, i32 0, i32 10
  %gsense146 = getelementptr inbounds %struct.barrier_t* %start145, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub144, i32* %gsense146, align 4
  call void @snapshot(i32 %sub144, i32 1)
  %call9 = call i32 @sleep(i32 3)
  br label %if.end.147

if.end.147:                                       ; preds = %if.then.143, %land.lhs.true.140, %lor.lhs.false.137
  br label %while.end.149

if.end.148:                                       ; preds = %while.body.119
  br label %while.body.119

while.end.149:                                    ; preds = %if.end.147
  br label %while.cond.150

while.cond.150:                                   ; preds = %while.body.155, %while.end.149
  %83 = load %struct.GlobalMemory** @Global, align 8
  %start151 = getelementptr inbounds %struct.GlobalMemory* %83, i32 0, i32 10
  %gsense152 = getelementptr inbounds %struct.barrier_t* %start151, i32 0, i32 0
  %84 = load volatile i32* %gsense152, align 4
  %85 = load i32* %lsense115, align 4
  %cmp153 = icmp eq i32 %84, %85
  br i1 %cmp153, label %while.body.155, label %while.end.156

while.body.155:                                   ; preds = %while.cond.150
  %call10 = call i32 @sleep(i32 2)
  br label %while.cond.150

while.end.156:                                    ; preds = %while.cond.150
  call void @printY()
  %call11 = call i32 @sleep(i32 1)
  br label %if.end.164

lor.lhs.false.159:                                ; No predecessors!
  br label %if.end.164

if.then.161:                                      ; No predecessors!
  br label %if.end.164

if.end.164:                                       ; preds = %lor.lhs.false.159, %while.end.156, %if.then.161
  %86 = load i32* %kl, align 4
  store i32 %86, i32* %i, align 4
  %87 = load i32* %K, align 4
  %add165 = add nsw i32 %87, 1
  store i32 %add165, i32* %I, align 4
  br label %for.cond.166

for.cond.166:                                     ; preds = %for.inc.211, %if.end.164
  %88 = load i32* %i, align 4
  %89 = load i32* %n.addr, align 4
  %cmp167 = icmp slt i32 %88, %89
  br i1 %cmp167, label %for.body.169, label %for.end.214

for.body.169:                                     ; preds = %for.cond.166
  br label %if.end.176

if.then.173:                                      ; No predecessors!
  br label %if.end.176

if.else.175:                                      ; No predecessors!
  br label %if.end.176

if.end.176:                                       ; preds = %for.body.169, %if.else.175, %if.then.173
  %90 = load i32* %I, align 4
  %91 = load i32* %K, align 4
  %call177 = call i32 @BlockOwner(i32 %90, i32 %91)
  %92 = load i32* %kl, align 4
  store i32 %92, i32* %j, align 4
  %93 = load i32* %K, align 4
  %add182 = add nsw i32 %93, 1
  store i32 %add182, i32* %J, align 4
  br label %for.cond.183

for.cond.183:                                     ; preds = %for.inc.207, %if.end.176
  %94 = load i32* %j, align 4
  %95 = load i32* %n.addr, align 4
  %cmp184 = icmp slt i32 %94, %95
  br i1 %cmp184, label %for.body.186, label %for.end.210

for.body.186:                                     ; preds = %for.cond.183
  %96 = load i32* %j, align 4
  %97 = load i32* %bs.addr, align 4
  %add187 = add nsw i32 %96, %97
  store i32 %add187, i32* %jl, align 4
  %98 = load i32* %jl, align 4
  %99 = load i32* %n.addr, align 4
  %cmp188 = icmp sgt i32 %98, %99
  br i1 %cmp188, label %if.then.190, label %if.else.192

if.then.190:                                      ; preds = %for.body.186
  %100 = load i32* %n.addr, align 4
  store i32 %100, i32* %jl, align 4
  %101 = load i32* %jl, align 4
  %102 = load i32* %j, align 4
  %sub191 = sub nsw i32 %101, %102
  store i32 %sub191, i32* %strJ, align 4
  br label %if.end.193

if.else.192:                                      ; preds = %for.body.186
  %103 = load i32* %bs.addr, align 4
  store i32 %103, i32* %strJ, align 4
  br label %if.end.193

if.end.193:                                       ; preds = %if.else.192, %if.then.190
  %104 = load i32* %I, align 4
  %105 = load i32* %J, align 4
  %call194 = call i32 @BlockOwner(i32 %104, i32 %105)
  %106 = load i32* %MyNum.addr, align 4
  %cmp195 = icmp eq i32 %call194, %106
  br i1 %cmp195, label %if.then.197, label %if.end.206

if.then.197:                                      ; preds = %if.end.193
  %107 = load i32* %strJ, align 4
  %108 = load i32* %strK, align 4
  call void @bmod(double* undef, double* undef, double* undef, i32 undef, i32 %107, i32 %108, i32 undef, i32 undef, i32 undef)
  br label %if.end.206

if.end.206:                                       ; preds = %if.then.197, %if.end.193
  br label %for.inc.207

for.inc.207:                                      ; preds = %if.end.206
  %109 = load i32* %bs.addr, align 4
  %110 = load i32* %j, align 4
  %add208 = add nsw i32 %110, %109
  store i32 %add208, i32* %j, align 4
  %111 = load i32* %J, align 4
  %inc209 = add nsw i32 %111, 1
  store i32 %inc209, i32* %J, align 4
  br label %for.cond.183

for.end.210:                                      ; preds = %for.cond.183
  br label %for.inc.211

for.inc.211:                                      ; preds = %for.end.210
  %112 = load i32* %bs.addr, align 4
  %113 = load i32* %i, align 4
  %add212 = add nsw i32 %113, %112
  store i32 %add212, i32* %i, align 4
  %114 = load i32* %I, align 4
  %inc213 = add nsw i32 %114, 1
  store i32 %inc213, i32* %I, align 4
  br label %for.cond.166

for.end.214:                                      ; preds = %for.cond.166
  br label %if.end.236

lor.lhs.false.217:                                ; No predecessors!
  br label %if.end.236

if.then.219:                                      ; No predecessors!
  br label %if.end.236

if.end.236:                                       ; preds = %lor.lhs.false.217, %for.end.214, %if.then.219
  br label %for.inc.237

for.inc.237:                                      ; preds = %if.end.236
  %115 = load i32* %bs.addr, align 4
  %116 = load i32* %k, align 4
  %add238 = add nsw i32 %116, %115
  store i32 %add238, i32* %k, align 4
  %117 = load i32* %K, align 4
  %inc239 = add nsw i32 %117, 1
  store i32 %inc239, i32* %K, align 4
  br label %for.cond

for.end.240:                                      ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @lu0(double* %a, i32 %n, i32 %stride) {
entry:
  %a.addr = alloca double*, align 8
  %n.addr = alloca i32, align 4
  %stride.addr = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %length = alloca i32, align 4
  %alpha = alloca double, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.27, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.29

for.body:                                         ; preds = %for.cond
  %2 = load i32* %k, align 4
  %add = add nsw i32 %2, 1
  store i32 %add, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %3 = load i32* %j, align 4
  %4 = load i32* %n.addr, align 4
  %cmp2 = icmp slt i32 %3, %4
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  call void @daxpy(double* undef, double* undef, i32 undef, double undef)
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %5 = load i32* %j, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.27

for.inc.27:                                       ; preds = %for.end
  %6 = load i32* %k, align 4
  %inc28 = add nsw i32 %6, 1
  store i32 %inc28, i32* %k, align 4
  br label %for.cond

for.end.29:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @daxpy(double* %a, double* %b, i32 %n, double %alpha) {
entry:
  %a.addr = alloca double*, align 8
  %b.addr = alloca double*, align 8
  %n.addr = alloca i32, align 4
  %alpha.addr = alloca double, align 8
  %i = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bdiv(double* %a, double* %diag, i32 %stride_a, i32 %stride_diag, i32 %dimi, i32 %dimk) {
entry:
  %a.addr = alloca double*, align 8
  %diag.addr = alloca double*, align 8
  %stride_a.addr = alloca i32, align 4
  %stride_diag.addr = alloca i32, align 4
  %dimi.addr = alloca i32, align 4
  %dimk.addr = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %alpha = alloca double, align 8
  store i32 %dimk, i32* %dimk.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.11, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimk.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.13

for.body:                                         ; preds = %for.cond
  %2 = load i32* %k, align 4
  %add = add nsw i32 %2, 1
  store i32 %add, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %3 = load i32* %j, align 4
  %4 = load i32* %dimk.addr, align 4
  %cmp2 = icmp slt i32 %3, %4
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  call void @daxpy(double* undef, double* undef, i32 undef, double undef)
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %5 = load i32* %j, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.11

for.inc.11:                                       ; preds = %for.end
  %6 = load i32* %k, align 4
  %inc12 = add nsw i32 %6, 1
  store i32 %inc12, i32* %k, align 4
  br label %for.cond

for.end.13:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bmodd(double* %a, double* %c, i32 %dimi, i32 %dimj, i32 %stride_a, i32 %stride_c) {
entry:
  %a.addr = alloca double*, align 8
  %c.addr = alloca double*, align 8
  %dimi.addr = alloca i32, align 4
  %dimj.addr = alloca i32, align 4
  %stride_a.addr = alloca i32, align 4
  %stride_c.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %length = alloca i32, align 4
  %alpha = alloca double, align 8
  store i32 %dimi, i32* %dimi.addr, align 4
  store i32 %dimj, i32* %dimj.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.26, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimi.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.28

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %3 = load i32* %dimj.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  call void @daxpy(double* undef, double* undef, i32 undef, double undef)
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %4 = load i32* %j, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.26

for.inc.26:                                       ; preds = %for.end
  %5 = load i32* %k, align 4
  %inc27 = add nsw i32 %5, 1
  store i32 %inc27, i32* %k, align 4
  br label %for.cond

for.end.28:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bmod(double* %a, double* %b, double* %c, i32 %dimi, i32 %dimj, i32 %dimk, i32 %stridea, i32 %strideb, i32 %stridec) {
entry:
  %a.addr = alloca double*, align 8
  %b.addr = alloca double*, align 8
  %c.addr = alloca double*, align 8
  %dimi.addr = alloca i32, align 4
  %dimj.addr = alloca i32, align 4
  %dimk.addr = alloca i32, align 4
  %stridea.addr = alloca i32, align 4
  %strideb.addr = alloca i32, align 4
  %stridec.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %alpha = alloca double, align 8
  store i32 %dimj, i32* %dimj.addr, align 4
  store i32 %dimk, i32* %dimk.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.10, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimk.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.12

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %3 = load i32* %dimj.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  call void @daxpy(double* undef, double* undef, i32 undef, double undef)
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %4 = load i32* %j, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.10

for.inc.10:                                       ; preds = %for.end
  %5 = load i32* %k, align 4
  %inc11 = add nsw i32 %5, 1
  store i32 %inc11, i32* %k, align 4
  br label %for.cond

for.end.12:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind
declare void @srand48(i64)

; Function Attrs: nounwind
declare i64 @lrand48()

; Function Attrs: nounwind uwtable
define internal void @PrintA() {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %ii = alloca i32, align 4
  %jj = alloca i32, align 4
  %edge = alloca i32, align 4
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  %skip = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.20, %entry
  br label %for.end.22

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body.3, %if.else, %if.then
  br label %if.end.11

if.then.8:                                        ; No predecessors!
  br label %if.end.11

if.else.10:                                       ; No predecessors!
  br label %if.end.11

if.end.11:                                        ; preds = %if.end, %if.else.10, %if.then.8
  br label %for.inc

for.inc:                                          ; preds = %if.end.11
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.20

for.inc.20:                                       ; preds = %for.end
  br label %for.cond

for.end.22:                                       ; preds = %for.cond
  ret void
}

declare i32 @fflush(%struct._IO_FILE*)

; Function Attrs: nounwind readnone
declare double @fabs(double)

; Function Attrs: nounwind
declare void @free(i8*)

; Function Attrs: nounwind uwtable
define internal void @DeriveInvariant() {
entry:
  ret void
}

define internal void @printX() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 88, i8* %arrayidx, align 1
  %1 = load i32* @index_out, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

define internal void @printY() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 89, i8* %arrayidx, align 1
  %1 = load i32* @index_out, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* @index_out, align 4
  call void @DecrementCounter()
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DecrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %i13 = alloca i32, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom
  store i8 0, i8* %arrayidx, align 1
  %1 = load i32* %idx, align 4
  %idxprom1 = zext i32 %1 to i64
  %arrayidx2 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom1
  %2 = load i32* %arrayidx2, align 4
  %cmp = icmp eq i32 %2, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %3 = load i32* @counter0, align 4
  %dec = add nsw i32 %3, -1
  store i32 %dec, i32* @counter0, align 4
  %4 = load i32* @counter0, align 4
  %cmp3 = icmp eq i32 %4, 0
  br i1 %cmp3, label %if.then.4, label %if.end

if.then.4:                                        ; preds = %if.then
  call void @DeriveInvariant()
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.4
  %5 = load i32* %i, align 4
  %cmp5 = icmp slt i32 %5, 3
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4
  %idxprom6 = sext i32 %6 to i64
  %arrayidx7 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom6
  store i8 1, i8* %arrayidx7, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end

if.end:                                           ; preds = %for.end, %if.then
  %8 = load i32* %idx, align 4
  %idxprom8 = zext i32 %8 to i64
  %arrayidx9 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom8
  store i32 1, i32* %arrayidx9, align 4
  br label %if.end.25

if.else:                                          ; preds = %entry
  %9 = load i32* @counter1, align 4
  %dec10 = add nsw i32 %9, -1
  store i32 %dec10, i32* @counter1, align 4
  %10 = load i32* @counter1, align 4
  %cmp11 = icmp eq i32 %10, 0
  br i1 %cmp11, label %if.then.12, label %if.end.22

if.then.12:                                       ; preds = %if.else
  call void @DeriveInvariant()
  store i32 0, i32* %i13, align 4
  br label %for.cond.14

for.cond.14:                                      ; preds = %for.inc.19, %if.then.12
  %11 = load i32* %i13, align 4
  %cmp15 = icmp slt i32 %11, 3
  br i1 %cmp15, label %for.body.16, label %for.end.21

for.body.16:                                      ; preds = %for.cond.14
  %12 = load i32* %i13, align 4
  %idxprom17 = sext i32 %12 to i64
  %arrayidx18 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom17
  store i8 1, i8* %arrayidx18, align 1
  br label %for.inc.19

for.inc.19:                                       ; preds = %for.body.16
  %13 = load i32* %i13, align 4
  %inc20 = add nsw i32 %13, 1
  store i32 %inc20, i32* %i13, align 4
  br label %for.cond.14

for.end.21:                                       ; preds = %for.cond.14
  br label %if.end.22

if.end.22:                                        ; preds = %for.end.21, %if.else
  %14 = load i32* %idx, align 4
  %idxprom23 = zext i32 %14 to i64
  %arrayidx24 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom23
  store i32 0, i32* %arrayidx24, align 4
  br label %if.end.25

if.end.25:                                        ; preds = %if.end.22, %if.end
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @flushAll() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 0, i8* %arrayidx, align 1
  ret void
}

define internal void @printChar(i8 signext %ch) {
entry:
  %ch.addr = alloca i8, align 1
  store i8 %ch, i8* %ch.addr, align 1
  %0 = load i8* %ch.addr, align 1
  %1 = load i32* @index_out, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 %0, i8* %arrayidx, align 1
  %2 = load i32* @index_out, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

define internal void @waitForAll() {
entry:
  %call = call i32 (i32, i32, ...) *bitcast (i32 (...)* @pthread_join to i32 (i32, i32, ...)*)(i32 0, i32 0)
  call void @flushAll()
  ret void
}

declare i32 @pthread_join(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot(i32 %gvar, i32 %index) {
entry:
  %gvar.addr = alloca i32, align 4
  %index.addr = alloca i32, align 4
  %idx = alloca i32, align 4
  store i32 %gvar, i32* %gvar.addr, align 4
  store i32 %index, i32* %index.addr, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom
  %1 = load i8* %arrayidx, align 1
  %tobool = trunc i8 %1 to i1
  br i1 %tobool, label %if.then, label %if.end.5

if.then:                                          ; preds = %entry
  %2 = load i32* %index.addr, align 4
  switch i32 %2, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb.1
    i32 2, label %sw.bb.2
  ]

sw.bb:                                            ; preds = %if.then
  %3 = load i32* %gvar.addr, align 4
  store i32 %3, i32* @gSyncVar_0, align 4
  br label %sw.epilog

sw.bb.1:                                          ; preds = %if.then
  %4 = load i32* %gvar.addr, align 4
  store i32 %4, i32* @gSyncVar_1, align 4
  br label %sw.epilog

sw.bb.2:                                          ; preds = %if.then
  %5 = load i32* %gvar.addr, align 4
  store i32 %5, i32* @gSyncVar_2, align 4
  br label %sw.default

sw.default:                                       ; preds = %sw.bb.2, %if.then
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb.1, %sw.bb
  %6 = load i32* %index.addr, align 4
  %add = add nsw i32 %6, 1
  %7 = load i32* @gSyncVarsTotalNum, align 4
  %cmp = icmp sgt i32 %add, %7
  br i1 %cmp, label %if.then.3, label %if.end

if.then.3:                                        ; preds = %sw.epilog
  %8 = load i32* %index.addr, align 4
  %add4 = add nsw i32 %8, 1
  store i32 %add4, i32* @gSyncVarsTotalNum, align 4
  br label %if.end

if.end:                                           ; preds = %if.then.3, %sw.epilog
  br label %if.end.5

if.end.5:                                         ; preds = %if.end, %entry
  ret void
}

declare i32 @pthread_self(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot64(i64 %gvar, i32 %index) {
entry:
  %gvar.addr = alloca i64, align 8
  %index.addr = alloca i32, align 4
  store i64 %gvar, i64* %gvar.addr, align 8
  store i32 %index, i32* %index.addr, align 4
  %0 = load i64* %gvar.addr, align 8
  %conv = trunc i64 %0 to i32
  %1 = load i32* %index.addr, align 4
  call void @snapshot(i32 %conv, i32 %1)
  ret void
}

define internal void @InitializeSwitchesAndCounter() {
entry:
  ret void
}

define internal void @IncrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom
  %1 = load i32* %arrayidx, align 4
  %cmp = icmp eq i32 %1, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %2 = load i32* @counter0, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* @counter0, align 4
  %3 = load i8* @firstSync, align 1
  %tobool = trunc i8 %3 to i1
  br i1 %tobool, label %if.then.1, label %if.end

if.then.1:                                        ; preds = %if.then
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.1
  %4 = load i32* %i, align 4
  %cmp2 = icmp slt i32 %4, 3
  br i1 %cmp2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load i32* %i, align 4
  %idxprom3 = sext i32 %5 to i64
  %arrayidx4 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom3
  store i8 1, i8* %arrayidx4, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %6 = load i32* %i, align 4
  %inc5 = add nsw i32 %6, 1
  store i32 %inc5, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i8 0, i8* @firstSync, align 1
  br label %if.end

if.end:                                           ; preds = %for.end, %if.then
  br label %if.end.7

if.else:                                          ; preds = %entry
  %7 = load i32* @counter1, align 4
  %inc6 = add nsw i32 %7, 1
  store i32 %inc6, i32* @counter1, align 4
  br label %if.end.7

if.end.7:                                         ; preds = %if.else, %if.end
  ret void
}

declare i32 @sleep(i32)


