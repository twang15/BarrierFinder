; ModuleID = 'LU.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.GlobalMemory = type { double*, double*, double*, double*, double*, i32, i32, i32, i32, i32, %struct.barrier_t, %union.pthread_mutex_t }
%struct.barrier_t = type { i32, i64 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%struct.LocalCopies = type { double, double, double, double }

@n = internal global i32 512, align 4
@P = internal global i32 2, align 4
@block_size = internal global i32 16, align 4
@test_result = internal global i32 0, align 4
@doprint = internal global i32 0, align 4
@dostats = internal global i32 0, align 4
@optarg = external global i8*
@num_rows = internal global i32 0, align 4
@num_cols = internal global i32 0, align 4
@nblocks = internal global i32 0, align 4
@proc_bytes = internal global i32* null, align 8
@last_malloc = internal global double** null, align 8
@stderr = external global %struct._IO_FILE*
@a = internal global double** null, align 8
@rhs = internal global double* null, align 8
@Global = internal global %struct.GlobalMemory* null, align 8
@stdout = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [12 x i8] c"n:p:b:cstoh\00", align 1
@.str1 = private unnamed_addr constant [22 x i8] c"Usage: LU <options>\0A\0A\00", align 1
@.str2 = private unnamed_addr constant [10 x i8] c"options:\0A\00", align 1
@.str3 = private unnamed_addr constant [31 x i8] c"  -nN : Decompose NxN matrix.\0A\00", align 1
@.str4 = private unnamed_addr constant [35 x i8] c"  -pP : P = number of processors.\0A\00", align 1
@.str5 = private unnamed_addr constant [70 x i8] c"  -bB : Use a block size of B. BxB elements should fit in cache for \0A\00", align 1
@.str6 = private unnamed_addr constant [68 x i8] c"        good performance. Small block sizes (B=8, B=16) work well.\0A\00", align 1
@.str7 = private unnamed_addr constant [71 x i8] c"  -c  : Copy non-locally allocated blocks to local memory before use.\0A\00", align 1
@.str8 = private unnamed_addr constant [55 x i8] c"  -s  : Print individual processor timing statistics.\0A\00", align 1
@.str9 = private unnamed_addr constant [22 x i8] c"  -t  : Test output.\0A\00", align 1
@.str10 = private unnamed_addr constant [34 x i8] c"  -o  : Print out matrix values.\0A\00", align 1
@.str11 = private unnamed_addr constant [42 x i8] c"  -h  : Print out command line options.\0A\0A\00", align 1
@.str12 = private unnamed_addr constant [31 x i8] c"Default: LU -n%1d -p%1d -b%1d\0A\00", align 1
@.str13 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str14 = private unnamed_addr constant [32 x i8] c"Blocked Dense LU Factorization\0A\00", align 1
@.str15 = private unnamed_addr constant [22 x i8] c"     %d by %d Matrix\0A\00", align 1
@.str16 = private unnamed_addr constant [20 x i8] c"     %d Processors\0A\00", align 1
@.str17 = private unnamed_addr constant [30 x i8] c"     %d by %d Element Blocks\0A\00", align 1
@.str18 = private unnamed_addr constant [44 x i8] c"Could not malloc memory blocks for proc %d\0A\00", align 1
@.str19 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for a\0A\00", align 1
@.str20 = private unnamed_addr constant [33 x i8] c"Could not malloc memory for rhs\0A\00", align 1
@.str21 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for Global\0A\00", align 1
@.str22 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_fac\0A\00", align 1
@.str23 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_mod\0A\00", align 1
@.str24 = private unnamed_addr constant [48 x i8] c"Could not malloc memory for Global->t_in_solve\0A\00", align 1
@.str25 = private unnamed_addr constant [46 x i8] c"Could not malloc memory for Global->t_in_bar\0A\00", align 1
@.str26 = private unnamed_addr constant [48 x i8] c"Could not malloc memory for Global->completion\0A\00", align 1
@.str27 = private unnamed_addr constant [30 x i8] c"Matrix before decomposition:\0A\00", align 1
@.str28 = private unnamed_addr constant [30 x i8] c"\0AMatrix after decomposition:\0A\00", align 1
@.str29 = private unnamed_addr constant [48 x i8] c"                            PROCESS STATISTICS\0A\00", align 1
@.str30 = private unnamed_addr constant [77 x i8] c"              Total      Diagonal     Perimeter      Interior       Barrier\0A\00", align 1
@.str31 = private unnamed_addr constant [75 x i8] c" Proc         Time         Time         Time           Time          Time\0A\00", align 1
@.str32 = private unnamed_addr constant [57 x i8] c"    0    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str33 = private unnamed_addr constant [57 x i8] c"  %3d    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str34 = private unnamed_addr constant [57 x i8] c"  Avg    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str35 = private unnamed_addr constant [57 x i8] c"  Min    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str36 = private unnamed_addr constant [57 x i8] c"  Max    %10.0f    %10.0f    %10.0f    %10.0f    %10.0f\0A\00", align 1
@.str37 = private unnamed_addr constant [48 x i8] c"                            TIMING INFORMATION\0A\00", align 1
@.str38 = private unnamed_addr constant [42 x i8] c"Start time                        : %16d\0A\00", align 1
@.str39 = private unnamed_addr constant [42 x i8] c"Initialization finish time        : %16d\0A\00", align 1
@.str40 = private unnamed_addr constant [42 x i8] c"Overall finish time               : %16d\0A\00", align 1
@.str41 = private unnamed_addr constant [42 x i8] c"Total time with initialization    : %16d\0A\00", align 1
@.str42 = private unnamed_addr constant [42 x i8] c"Total time without initialization : %16d\0A\00", align 1
@.str43 = private unnamed_addr constant [46 x i8] c"                             TESTING RESULTS\0A\00", align 1
@.str49 = private unnamed_addr constant [11 x i8] c"ERROR: %s\0A\00", align 1
@.str46 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for y\0A\00", align 1
@.str47 = private unnamed_addr constant [26 x i8] c"TEST FAILED: (%.5f diff)\0A\00", align 1
@.str48 = private unnamed_addr constant [13 x i8] c"TEST PASSED\0A\00", align 1
@.str44 = private unnamed_addr constant [40 x i8] c"Proc %d could not malloc memory for lc\0A\00", align 1
@.str45 = private unnamed_addr constant [7 x i8] c"%8.1f \00", align 1

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
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  store i32 0, i32* %MyNum, align 4
  %call = call i64 @time(i64* null)
  %conv = trunc i64 %call to i32
  store i32 %conv, i32* %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %0 = load i32* %argc.addr, align 4
  %1 = load i8*** %argv.addr, align 8
  %call1 = call i32 (...) @getopt(i32 %0, i8** %1, i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0))
  store i32 %call1, i32* %ch, align 4
  %cmp = icmp ne i32 %call1, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %ch, align 4
  switch i32 %2, label %sw.epilog [
    i32 110, label %sw.bb
    i32 112, label %sw.bb4
    i32 98, label %sw.bb6
    i32 115, label %sw.bb8
    i32 116, label %sw.bb9
    i32 111, label %sw.bb10
    i32 104, label %sw.bb14
  ]

sw.bb:                                            ; preds = %while.body
  %3 = load i8** @optarg, align 8
  %call3 = call i32 @atoi(i8* %3)
  store i32 %call3, i32* @n, align 4
  br label %sw.epilog

sw.bb4:                                           ; preds = %while.body
  %4 = load i8** @optarg, align 8
  %call5 = call i32 @atoi(i8* %4)
  store i32 %call5, i32* @P, align 4
  br label %sw.epilog

sw.bb6:                                           ; preds = %while.body
  %5 = load i8** @optarg, align 8
  %call7 = call i32 @atoi(i8* %5)
  store i32 %call7, i32* @block_size, align 4
  br label %sw.epilog

sw.bb8:                                           ; preds = %while.body
  store i32 1, i32* @dostats, align 4
  br label %sw.epilog

sw.bb9:                                           ; preds = %while.body
  %6 = load i32* @test_result, align 4
  %tobool = icmp ne i32 %6, 0
  %lnot = xor i1 %tobool, true
  %lnot.ext = zext i1 %lnot to i32
  store i32 %lnot.ext, i32* @test_result, align 4
  br label %sw.epilog

sw.bb10:                                          ; preds = %while.body
  %7 = load i32* @doprint, align 4
  %tobool11 = icmp ne i32 %7, 0
  %lnot12 = xor i1 %tobool11, true
  %lnot.ext13 = zext i1 %lnot12 to i32
  store i32 %lnot.ext13, i32* @doprint, align 4
  br label %sw.epilog

sw.bb14:                                          ; preds = %while.body
  %call15 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str1, i32 0, i32 0))
  %call16 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([10 x i8]* @.str2, i32 0, i32 0))
  %call17 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([31 x i8]* @.str3, i32 0, i32 0))
  %call18 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([35 x i8]* @.str4, i32 0, i32 0))
  %call19 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([70 x i8]* @.str5, i32 0, i32 0))
  %call20 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([68 x i8]* @.str6, i32 0, i32 0))
  %call21 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([71 x i8]* @.str7, i32 0, i32 0))
  %call22 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str8, i32 0, i32 0))
  %call23 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str9, i32 0, i32 0))
  %call24 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([34 x i8]* @.str10, i32 0, i32 0))
  %call25 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str11, i32 0, i32 0))
  %call26 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([31 x i8]* @.str12, i32 0, i32 0), i32 512, i32 2, i32 16)
  call void @exit(i32 0)
  unreachable

sw.epilog:                                        ; preds = %sw.bb10, %sw.bb9, %sw.bb8, %sw.bb6, %sw.bb4, %sw.bb, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %call27 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  %call28 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([32 x i8]* @.str14, i32 0, i32 0))
  %8 = load i32* @n, align 4
  %9 = load i32* @n, align 4
  %call29 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str15, i32 0, i32 0), i32 %8, i32 %9)
  %10 = load i32* @P, align 4
  %call30 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([20 x i8]* @.str16, i32 0, i32 0), i32 %10)
  %11 = load i32* @block_size, align 4
  %12 = load i32* @block_size, align 4
  %call31 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str17, i32 0, i32 0), i32 %11, i32 %12)
  %call32 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  %call33 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  %13 = load i32* @P, align 4
  %conv34 = sitofp i32 %13 to double
  %call35 = call double @sqrt(double %conv34)
  %conv36 = fptosi double %call35 to i32
  store i32 %conv36, i32* @num_rows, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.end, %while.end
  %14 = load i32* @P, align 4
  %15 = load i32* @num_rows, align 4
  %div = sdiv i32 %14, %15
  store i32 %div, i32* @num_cols, align 4
  %16 = load i32* @num_rows, align 4
  %17 = load i32* @num_cols, align 4
  %mul = mul nsw i32 %16, %17
  %18 = load i32* @P, align 4
  %cmp37 = icmp eq i32 %mul, %18
  br i1 %cmp37, label %if.then, label %if.end

if.then:                                          ; preds = %for.cond
  br label %for.end

if.end:                                           ; preds = %for.cond
  %19 = load i32* @num_rows, align 4
  %dec = add nsw i32 %19, -1
  store i32 %dec, i32* @num_rows, align 4
  br label %for.cond

for.end:                                          ; preds = %if.then
  %20 = load i32* @n, align 4
  %21 = load i32* @block_size, align 4
  %div39 = sdiv i32 %20, %21
  store i32 %div39, i32* @nblocks, align 4
  %22 = load i32* @block_size, align 4
  %23 = load i32* @nblocks, align 4
  %mul40 = mul nsw i32 %22, %23
  %24 = load i32* @n, align 4
  %cmp41 = icmp ne i32 %mul40, %24
  br i1 %cmp41, label %if.then43, label %if.end44

if.then43:                                        ; preds = %for.end
  %25 = load i32* @nblocks, align 4
  %inc = add nsw i32 %25, 1
  store i32 %inc, i32* @nblocks, align 4
  br label %if.end44

if.end44:                                         ; preds = %if.then43, %for.end
  %26 = load i32* @n, align 4
  %27 = load i32* @block_size, align 4
  %rem = srem i32 %26, %27
  store i32 %rem, i32* %edge, align 4
  %28 = load i32* %edge, align 4
  %cmp45 = icmp eq i32 %28, 0
  br i1 %cmp45, label %if.then47, label %if.end48

if.then47:                                        ; preds = %if.end44
  %29 = load i32* @block_size, align 4
  store i32 %29, i32* %edge, align 4
  br label %if.end48

if.end48:                                         ; preds = %if.then47, %if.end44
  %30 = load i32* @P, align 4
  %conv49 = sext i32 %30 to i64
  %mul50 = mul i64 %conv49, 4
  %call51 = call noalias i8* @malloc(i64 %mul50)
  %31 = bitcast i8* %call51 to i32*
  store i32* %31, i32** @proc_bytes, align 8
  %32 = load i32* @P, align 4
  %conv52 = sext i32 %32 to i64
  %mul53 = mul i64 %conv52, 8
  %call54 = call noalias i8* @malloc(i64 %mul53)
  %33 = bitcast i8* %call54 to double**
  store double** %33, double*** @last_malloc, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond55

for.cond55:                                       ; preds = %for.inc, %if.end48
  %34 = load i32* %i, align 4
  %35 = load i32* @P, align 4
  %cmp56 = icmp slt i32 %34, %35
  br i1 %cmp56, label %for.body, label %for.end61

for.body:                                         ; preds = %for.cond55
  %36 = load i32* %i, align 4
  %idxprom = sext i32 %36 to i64
  %37 = load i32** @proc_bytes, align 8
  %arrayidx = getelementptr inbounds i32* %37, i64 %idxprom
  store i32 0, i32* %arrayidx, align 4
  %38 = load i32* %i, align 4
  %idxprom58 = sext i32 %38 to i64
  %39 = load double*** @last_malloc, align 8
  %arrayidx59 = getelementptr inbounds double** %39, i64 %idxprom58
  store double* null, double** %arrayidx59, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %40 = load i32* %i, align 4
  %inc60 = add nsw i32 %40, 1
  store i32 %inc60, i32* %i, align 4
  br label %for.cond55

for.end61:                                        ; preds = %for.cond55
  store i32 0, i32* %i, align 4
  br label %for.cond62

for.cond62:                                       ; preds = %for.inc99, %for.end61
  %41 = load i32* %i, align 4
  %42 = load i32* @nblocks, align 4
  %cmp63 = icmp slt i32 %41, %42
  br i1 %cmp63, label %for.body65, label %for.end101

for.body65:                                       ; preds = %for.cond62
  store i32 0, i32* %j, align 4
  br label %for.cond66

for.cond66:                                       ; preds = %for.inc96, %for.body65
  %43 = load i32* %j, align 4
  %44 = load i32* @nblocks, align 4
  %cmp67 = icmp slt i32 %43, %44
  br i1 %cmp67, label %for.body69, label %for.end98

for.body69:                                       ; preds = %for.cond66
  %45 = load i32* %i, align 4
  %46 = load i32* %j, align 4
  %call70 = call i32 @BlockOwner(i32 %45, i32 %46)
  store i32 %call70, i32* %proc_num, align 4
  %47 = load i32* %i, align 4
  %48 = load i32* @nblocks, align 4
  %sub = sub nsw i32 %48, 1
  %cmp71 = icmp eq i32 %47, %sub
  br i1 %cmp71, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %for.body69
  %49 = load i32* %j, align 4
  %50 = load i32* @nblocks, align 4
  %sub73 = sub nsw i32 %50, 1
  %cmp74 = icmp eq i32 %49, %sub73
  br i1 %cmp74, label %if.then76, label %if.else

if.then76:                                        ; preds = %land.lhs.true
  %51 = load i32* %edge, align 4
  %52 = load i32* %edge, align 4
  %mul77 = mul nsw i32 %51, %52
  store i32 %mul77, i32* %size, align 4
  br label %if.end89

if.else:                                          ; preds = %land.lhs.true, %for.body69
  %53 = load i32* %i, align 4
  %54 = load i32* @nblocks, align 4
  %sub78 = sub nsw i32 %54, 1
  %cmp79 = icmp eq i32 %53, %sub78
  br i1 %cmp79, label %if.then84, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.else
  %55 = load i32* %j, align 4
  %56 = load i32* @nblocks, align 4
  %sub81 = sub nsw i32 %56, 1
  %cmp82 = icmp eq i32 %55, %sub81
  br i1 %cmp82, label %if.then84, label %if.else86

if.then84:                                        ; preds = %lor.lhs.false, %if.else
  %57 = load i32* %edge, align 4
  %58 = load i32* @block_size, align 4
  %mul85 = mul nsw i32 %57, %58
  store i32 %mul85, i32* %size, align 4
  br label %if.end88

if.else86:                                        ; preds = %lor.lhs.false
  %59 = load i32* @block_size, align 4
  %60 = load i32* @block_size, align 4
  %mul87 = mul nsw i32 %59, %60
  store i32 %mul87, i32* %size, align 4
  br label %if.end88

if.end88:                                         ; preds = %if.else86, %if.then84
  br label %if.end89

if.end89:                                         ; preds = %if.end88, %if.then76
  %61 = load i32* %size, align 4
  %conv90 = sext i32 %61 to i64
  %mul91 = mul i64 %conv90, 8
  %62 = load i32* %proc_num, align 4
  %idxprom92 = sext i32 %62 to i64
  %63 = load i32** @proc_bytes, align 8
  %arrayidx93 = getelementptr inbounds i32* %63, i64 %idxprom92
  %64 = load i32* %arrayidx93, align 4
  %conv94 = sext i32 %64 to i64
  %add = add i64 %conv94, %mul91
  %conv95 = trunc i64 %add to i32
  store i32 %conv95, i32* %arrayidx93, align 4
  br label %for.inc96

for.inc96:                                        ; preds = %if.end89
  %65 = load i32* %j, align 4
  %inc97 = add nsw i32 %65, 1
  store i32 %inc97, i32* %j, align 4
  br label %for.cond66

for.end98:                                        ; preds = %for.cond66
  br label %for.inc99

for.inc99:                                        ; preds = %for.end98
  %66 = load i32* %i, align 4
  %inc100 = add nsw i32 %66, 1
  store i32 %inc100, i32* %i, align 4
  br label %for.cond62

for.end101:                                       ; preds = %for.cond62
  store i32 0, i32* %i, align 4
  br label %for.cond102

for.cond102:                                      ; preds = %for.inc130, %for.end101
  %67 = load i32* %i, align 4
  %68 = load i32* @P, align 4
  %cmp103 = icmp slt i32 %67, %68
  br i1 %cmp103, label %for.body105, label %for.end132

for.body105:                                      ; preds = %for.cond102
  %69 = load i32* %i, align 4
  %idxprom106 = sext i32 %69 to i64
  %70 = load i32** @proc_bytes, align 8
  %arrayidx107 = getelementptr inbounds i32* %70, i64 %idxprom106
  %71 = load i32* %arrayidx107, align 4
  %add108 = add nsw i32 %71, 4096
  %conv109 = sext i32 %add108 to i64
  %call110 = call noalias i8* @malloc(i64 %conv109)
  %72 = bitcast i8* %call110 to double*
  %73 = load i32* %i, align 4
  %idxprom111 = sext i32 %73 to i64
  %74 = load double*** @last_malloc, align 8
  %arrayidx112 = getelementptr inbounds double** %74, i64 %idxprom111
  store double* %72, double** %arrayidx112, align 8
  %75 = load i32* %i, align 4
  %idxprom113 = sext i32 %75 to i64
  %76 = load double*** @last_malloc, align 8
  %arrayidx114 = getelementptr inbounds double** %76, i64 %idxprom113
  %77 = load double** %arrayidx114, align 8
  %cmp115 = icmp eq double* %77, null
  br i1 %cmp115, label %if.then117, label %if.end119

if.then117:                                       ; preds = %for.body105
  %78 = load %struct._IO_FILE** @stderr, align 8
  %79 = load i32* %i, align 4
  %call118 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %78, i8* getelementptr inbounds ([44 x i8]* @.str18, i32 0, i32 0), i32 %79)
  call void @exit(i32 -1)
  unreachable

if.end119:                                        ; preds = %for.body105
  %80 = load i32* %i, align 4
  %idxprom120 = sext i32 %80 to i64
  %81 = load double*** @last_malloc, align 8
  %arrayidx121 = getelementptr inbounds double** %81, i64 %idxprom120
  %82 = load double** %arrayidx121, align 8
  %83 = ptrtoint double* %82 to i32
  %add122 = add i32 %83, 4096
  %84 = load i32* %i, align 4
  %idxprom123 = sext i32 %84 to i64
  %85 = load double*** @last_malloc, align 8
  %arrayidx124 = getelementptr inbounds double** %85, i64 %idxprom123
  %86 = load double** %arrayidx124, align 8
  %87 = ptrtoint double* %86 to i32
  %rem125 = urem i32 %87, 4096
  %sub126 = sub i32 %add122, %rem125
  %conv127 = zext i32 %sub126 to i64
  %88 = inttoptr i64 %conv127 to double*
  %89 = load i32* %i, align 4
  %idxprom128 = sext i32 %89 to i64
  %90 = load double*** @last_malloc, align 8
  %arrayidx129 = getelementptr inbounds double** %90, i64 %idxprom128
  store double* %88, double** %arrayidx129, align 8
  br label %for.inc130

for.inc130:                                       ; preds = %if.end119
  %91 = load i32* %i, align 4
  %inc131 = add nsw i32 %91, 1
  store i32 %inc131, i32* %i, align 4
  br label %for.cond102

for.end132:                                       ; preds = %for.cond102
  %92 = load i32* @nblocks, align 4
  %93 = load i32* @nblocks, align 4
  %mul133 = mul nsw i32 %92, %93
  %conv134 = sext i32 %mul133 to i64
  %mul135 = mul i64 %conv134, 8
  %call136 = call noalias i8* @malloc(i64 %mul135)
  %94 = bitcast i8* %call136 to double**
  store double** %94, double*** @a, align 8
  %95 = load double*** @a, align 8
  %cmp137 = icmp eq double** %95, null
  br i1 %cmp137, label %if.then139, label %if.end140

if.then139:                                       ; preds = %for.end132
  call void @printerr(i8* getelementptr inbounds ([31 x i8]* @.str19, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end140:                                        ; preds = %for.end132
  store i32 0, i32* %i, align 4
  br label %for.cond141

for.cond141:                                      ; preds = %for.inc184, %if.end140
  %96 = load i32* %i, align 4
  %97 = load i32* @nblocks, align 4
  %cmp142 = icmp slt i32 %96, %97
  br i1 %cmp142, label %for.body144, label %for.end186

for.body144:                                      ; preds = %for.cond141
  store i32 0, i32* %j, align 4
  br label %for.cond145

for.cond145:                                      ; preds = %for.inc181, %for.body144
  %98 = load i32* %j, align 4
  %99 = load i32* @nblocks, align 4
  %cmp146 = icmp slt i32 %98, %99
  br i1 %cmp146, label %for.body148, label %for.end183

for.body148:                                      ; preds = %for.cond145
  %100 = load i32* %i, align 4
  %101 = load i32* %j, align 4
  %call149 = call i32 @BlockOwner(i32 %100, i32 %101)
  store i32 %call149, i32* %proc_num, align 4
  %102 = load i32* %proc_num, align 4
  %idxprom150 = sext i32 %102 to i64
  %103 = load double*** @last_malloc, align 8
  %arrayidx151 = getelementptr inbounds double** %103, i64 %idxprom150
  %104 = load double** %arrayidx151, align 8
  %105 = load i32* %i, align 4
  %106 = load i32* %j, align 4
  %107 = load i32* @nblocks, align 4
  %mul152 = mul nsw i32 %106, %107
  %add153 = add nsw i32 %105, %mul152
  %idxprom154 = sext i32 %add153 to i64
  %108 = load double*** @a, align 8
  %arrayidx155 = getelementptr inbounds double** %108, i64 %idxprom154
  store double* %104, double** %arrayidx155, align 8
  %109 = load i32* %i, align 4
  %110 = load i32* @nblocks, align 4
  %sub156 = sub nsw i32 %110, 1
  %cmp157 = icmp eq i32 %109, %sub156
  br i1 %cmp157, label %land.lhs.true159, label %if.else165

land.lhs.true159:                                 ; preds = %for.body148
  %111 = load i32* %j, align 4
  %112 = load i32* @nblocks, align 4
  %sub160 = sub nsw i32 %112, 1
  %cmp161 = icmp eq i32 %111, %sub160
  br i1 %cmp161, label %if.then163, label %if.else165

if.then163:                                       ; preds = %land.lhs.true159
  %113 = load i32* %edge, align 4
  %114 = load i32* %edge, align 4
  %mul164 = mul nsw i32 %113, %114
  store i32 %mul164, i32* %size, align 4
  br label %if.end178

if.else165:                                       ; preds = %land.lhs.true159, %for.body148
  %115 = load i32* %i, align 4
  %116 = load i32* @nblocks, align 4
  %sub166 = sub nsw i32 %116, 1
  %cmp167 = icmp eq i32 %115, %sub166
  br i1 %cmp167, label %if.then173, label %lor.lhs.false169

lor.lhs.false169:                                 ; preds = %if.else165
  %117 = load i32* %j, align 4
  %118 = load i32* @nblocks, align 4
  %sub170 = sub nsw i32 %118, 1
  %cmp171 = icmp eq i32 %117, %sub170
  br i1 %cmp171, label %if.then173, label %if.else175

if.then173:                                       ; preds = %lor.lhs.false169, %if.else165
  %119 = load i32* %edge, align 4
  %120 = load i32* @block_size, align 4
  %mul174 = mul nsw i32 %119, %120
  store i32 %mul174, i32* %size, align 4
  br label %if.end177

if.else175:                                       ; preds = %lor.lhs.false169
  %121 = load i32* @block_size, align 4
  %122 = load i32* @block_size, align 4
  %mul176 = mul nsw i32 %121, %122
  store i32 %mul176, i32* %size, align 4
  br label %if.end177

if.end177:                                        ; preds = %if.else175, %if.then173
  br label %if.end178

if.end178:                                        ; preds = %if.end177, %if.then163
  %123 = load i32* %size, align 4
  %124 = load i32* %proc_num, align 4
  %idxprom179 = sext i32 %124 to i64
  %125 = load double*** @last_malloc, align 8
  %arrayidx180 = getelementptr inbounds double** %125, i64 %idxprom179
  %126 = load double** %arrayidx180, align 8
  %idx.ext = sext i32 %123 to i64
  %add.ptr = getelementptr inbounds double* %126, i64 %idx.ext
  store double* %add.ptr, double** %arrayidx180, align 8
  br label %for.inc181

for.inc181:                                       ; preds = %if.end178
  %127 = load i32* %j, align 4
  %inc182 = add nsw i32 %127, 1
  store i32 %inc182, i32* %j, align 4
  br label %for.cond145

for.end183:                                       ; preds = %for.cond145
  br label %for.inc184

for.inc184:                                       ; preds = %for.end183
  %128 = load i32* %i, align 4
  %inc185 = add nsw i32 %128, 1
  store i32 %inc185, i32* %i, align 4
  br label %for.cond141

for.end186:                                       ; preds = %for.cond141
  %129 = load i32* @n, align 4
  %conv187 = sext i32 %129 to i64
  %mul188 = mul i64 %conv187, 8
  %call189 = call noalias i8* @malloc(i64 %mul188)
  %130 = bitcast i8* %call189 to double*
  store double* %130, double** @rhs, align 8
  %131 = load double** @rhs, align 8
  %cmp190 = icmp eq double* %131, null
  br i1 %cmp190, label %if.then192, label %if.end193

if.then192:                                       ; preds = %for.end186
  call void @printerr(i8* getelementptr inbounds ([33 x i8]* @.str20, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end193:                                        ; preds = %for.end186
  %call194 = call noalias i8* @malloc(i64 120)
  %132 = bitcast i8* %call194 to %struct.GlobalMemory*
  store %struct.GlobalMemory* %132, %struct.GlobalMemory** @Global, align 8
  %133 = load i32* @P, align 4
  %conv195 = sext i32 %133 to i64
  %mul196 = mul i64 %conv195, 8
  %call197 = call noalias i8* @malloc(i64 %mul196)
  %134 = bitcast i8* %call197 to double*
  %135 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac = getelementptr inbounds %struct.GlobalMemory* %135, i32 0, i32 0
  store double* %134, double** %t_in_fac, align 8
  %136 = load i32* @P, align 4
  %conv198 = sext i32 %136 to i64
  %mul199 = mul i64 %conv198, 8
  %call200 = call noalias i8* @malloc(i64 %mul199)
  %137 = bitcast i8* %call200 to double*
  %138 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod = getelementptr inbounds %struct.GlobalMemory* %138, i32 0, i32 2
  store double* %137, double** %t_in_mod, align 8
  %139 = load i32* @P, align 4
  %conv201 = sext i32 %139 to i64
  %mul202 = mul i64 %conv201, 8
  %call203 = call noalias i8* @malloc(i64 %mul202)
  %140 = bitcast i8* %call203 to double*
  %141 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve = getelementptr inbounds %struct.GlobalMemory* %141, i32 0, i32 1
  store double* %140, double** %t_in_solve, align 8
  %142 = load i32* @P, align 4
  %conv204 = sext i32 %142 to i64
  %mul205 = mul i64 %conv204, 8
  %call206 = call noalias i8* @malloc(i64 %mul205)
  %143 = bitcast i8* %call206 to double*
  %144 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar = getelementptr inbounds %struct.GlobalMemory* %144, i32 0, i32 3
  store double* %143, double** %t_in_bar, align 8
  %145 = load i32* @P, align 4
  %conv207 = sext i32 %145 to i64
  %mul208 = mul i64 %conv207, 8
  %call209 = call noalias i8* @malloc(i64 %mul208)
  %146 = bitcast i8* %call209 to double*
  %147 = load %struct.GlobalMemory** @Global, align 8
  %completion = getelementptr inbounds %struct.GlobalMemory* %147, i32 0, i32 4
  store double* %146, double** %completion, align 8
  %148 = load %struct.GlobalMemory** @Global, align 8
  %cmp210 = icmp eq %struct.GlobalMemory* %148, null
  br i1 %cmp210, label %if.then212, label %if.else213

if.then212:                                       ; preds = %if.end193
  call void @printerr(i8* getelementptr inbounds ([36 x i8]* @.str21, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.else213:                                       ; preds = %if.end193
  %149 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac214 = getelementptr inbounds %struct.GlobalMemory* %149, i32 0, i32 0
  %150 = load double** %t_in_fac214, align 8
  %cmp215 = icmp eq double* %150, null
  br i1 %cmp215, label %if.then217, label %if.else218

if.then217:                                       ; preds = %if.else213
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str22, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.else218:                                       ; preds = %if.else213
  %151 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod219 = getelementptr inbounds %struct.GlobalMemory* %151, i32 0, i32 2
  %152 = load double** %t_in_mod219, align 8
  %cmp220 = icmp eq double* %152, null
  br i1 %cmp220, label %if.then222, label %if.else223

if.then222:                                       ; preds = %if.else218
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str23, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.else223:                                       ; preds = %if.else218
  %153 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve224 = getelementptr inbounds %struct.GlobalMemory* %153, i32 0, i32 1
  %154 = load double** %t_in_solve224, align 8
  %cmp225 = icmp eq double* %154, null
  br i1 %cmp225, label %if.then227, label %if.else228

if.then227:                                       ; preds = %if.else223
  call void @printerr(i8* getelementptr inbounds ([48 x i8]* @.str24, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.else228:                                       ; preds = %if.else223
  %155 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar229 = getelementptr inbounds %struct.GlobalMemory* %155, i32 0, i32 3
  %156 = load double** %t_in_bar229, align 8
  %cmp230 = icmp eq double* %156, null
  br i1 %cmp230, label %if.then232, label %if.else233

if.then232:                                       ; preds = %if.else228
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str25, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.else233:                                       ; preds = %if.else228
  %157 = load %struct.GlobalMemory** @Global, align 8
  %completion234 = getelementptr inbounds %struct.GlobalMemory* %157, i32 0, i32 4
  %158 = load double** %completion234, align 8
  %cmp235 = icmp eq double* %158, null
  br i1 %cmp235, label %if.then237, label %if.end238

if.then237:                                       ; preds = %if.else233
  call void @printerr(i8* getelementptr inbounds ([48 x i8]* @.str26, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end238:                                        ; preds = %if.else233
  br label %if.end239

if.end239:                                        ; preds = %if.end238
  br label %if.end240

if.end240:                                        ; preds = %if.end239
  br label %if.end241

if.end241:                                        ; preds = %if.end240
  br label %if.end242

if.end242:                                        ; preds = %if.end241
  br label %if.end243

if.end243:                                        ; preds = %if.end242
  %159 = load %struct.GlobalMemory** @Global, align 8
  %start244 = getelementptr inbounds %struct.GlobalMemory* %159, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start244, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %160 = load %struct.GlobalMemory** @Global, align 8
  %start245 = getelementptr inbounds %struct.GlobalMemory* %160, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start245, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  %161 = load %struct.GlobalMemory** @Global, align 8
  %idlock = getelementptr inbounds %struct.GlobalMemory* %161, i32 0, i32 11
  %call246 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* %idlock, %union.pthread_mutexattr_t* null)
  %162 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %162, i32 0, i32 9
  store i32 0, i32* %id, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond247

for.cond247:                                      ; preds = %for.inc252, %if.end243
  %163 = load i32* %i, align 4
  %164 = load i32* @P, align 4
  %cmp248 = icmp slt i32 %163, %164
  br i1 %cmp248, label %for.body250, label %for.end254

for.body250:                                      ; preds = %for.cond247
  %call251 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %for.inc252

for.inc252:                                       ; preds = %for.body250
  %165 = load i32* %i, align 4
  %inc253 = add nsw i32 %165, 1
  store i32 %inc253, i32* %i, align 4
  br label %for.cond247

for.end254:                                       ; preds = %for.cond247
  %166 = load double** @rhs, align 8
  call void @InitA(double* %166)
  %167 = load i32* @doprint, align 4
  %tobool255 = icmp ne i32 %167, 0
  br i1 %tobool255, label %if.then256, label %if.end258

if.then256:                                       ; preds = %for.end254
  %call257 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str27, i32 0, i32 0))
  call void @PrintA()
  br label %if.end258

if.end258:                                        ; preds = %if.then256, %for.end254
  %168 = load i32* %MyNum, align 4
  call void @SlaveStart()
  %169 = load i32* @doprint, align 4
  %tobool259 = icmp ne i32 %169, 0
  br i1 %tobool259, label %if.then260, label %if.end262

if.then260:                                       ; preds = %if.end258
  %call261 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str28, i32 0, i32 0))
  call void @PrintA()
  br label %if.end262

if.end262:                                        ; preds = %if.then260, %if.end258
  %170 = load i32* @dostats, align 4
  %tobool263 = icmp ne i32 %170, 0
  br i1 %tobool263, label %if.then264, label %if.end419

if.then264:                                       ; preds = %if.end262
  %171 = load %struct.GlobalMemory** @Global, align 8
  %completion265 = getelementptr inbounds %struct.GlobalMemory* %171, i32 0, i32 4
  %172 = load double** %completion265, align 8
  %arrayidx266 = getelementptr inbounds double* %172, i64 0
  %173 = load double* %arrayidx266, align 8
  store double %173, double* %mint, align 8
  store double %173, double* %avgt, align 8
  store double %173, double* %maxt, align 8
  store i32 1, i32* %i, align 4
  br label %for.cond267

for.cond267:                                      ; preds = %for.inc295, %if.then264
  %174 = load i32* %i, align 4
  %175 = load i32* @P, align 4
  %cmp268 = icmp slt i32 %174, %175
  br i1 %cmp268, label %for.body270, label %for.end297

for.body270:                                      ; preds = %for.cond267
  %176 = load i32* %i, align 4
  %idxprom271 = sext i32 %176 to i64
  %177 = load %struct.GlobalMemory** @Global, align 8
  %completion272 = getelementptr inbounds %struct.GlobalMemory* %177, i32 0, i32 4
  %178 = load double** %completion272, align 8
  %arrayidx273 = getelementptr inbounds double* %178, i64 %idxprom271
  %179 = load double* %arrayidx273, align 8
  %180 = load double* %maxt, align 8
  %cmp274 = fcmp ogt double %179, %180
  br i1 %cmp274, label %if.then276, label %if.end280

if.then276:                                       ; preds = %for.body270
  %181 = load i32* %i, align 4
  %idxprom277 = sext i32 %181 to i64
  %182 = load %struct.GlobalMemory** @Global, align 8
  %completion278 = getelementptr inbounds %struct.GlobalMemory* %182, i32 0, i32 4
  %183 = load double** %completion278, align 8
  %arrayidx279 = getelementptr inbounds double* %183, i64 %idxprom277
  %184 = load double* %arrayidx279, align 8
  store double %184, double* %maxt, align 8
  br label %if.end280

if.end280:                                        ; preds = %if.then276, %for.body270
  %185 = load i32* %i, align 4
  %idxprom281 = sext i32 %185 to i64
  %186 = load %struct.GlobalMemory** @Global, align 8
  %completion282 = getelementptr inbounds %struct.GlobalMemory* %186, i32 0, i32 4
  %187 = load double** %completion282, align 8
  %arrayidx283 = getelementptr inbounds double* %187, i64 %idxprom281
  %188 = load double* %arrayidx283, align 8
  %189 = load double* %mint, align 8
  %cmp284 = fcmp olt double %188, %189
  br i1 %cmp284, label %if.then286, label %if.end290

if.then286:                                       ; preds = %if.end280
  %190 = load i32* %i, align 4
  %idxprom287 = sext i32 %190 to i64
  %191 = load %struct.GlobalMemory** @Global, align 8
  %completion288 = getelementptr inbounds %struct.GlobalMemory* %191, i32 0, i32 4
  %192 = load double** %completion288, align 8
  %arrayidx289 = getelementptr inbounds double* %192, i64 %idxprom287
  %193 = load double* %arrayidx289, align 8
  store double %193, double* %mint, align 8
  br label %if.end290

if.end290:                                        ; preds = %if.then286, %if.end280
  %194 = load i32* %i, align 4
  %idxprom291 = sext i32 %194 to i64
  %195 = load %struct.GlobalMemory** @Global, align 8
  %completion292 = getelementptr inbounds %struct.GlobalMemory* %195, i32 0, i32 4
  %196 = load double** %completion292, align 8
  %arrayidx293 = getelementptr inbounds double* %196, i64 %idxprom291
  %197 = load double* %arrayidx293, align 8
  %198 = load double* %avgt, align 8
  %add294 = fadd double %198, %197
  store double %add294, double* %avgt, align 8
  br label %for.inc295

for.inc295:                                       ; preds = %if.end290
  %199 = load i32* %i, align 4
  %inc296 = add nsw i32 %199, 1
  store i32 %inc296, i32* %i, align 4
  br label %for.cond267

for.end297:                                       ; preds = %for.cond267
  %200 = load double* %avgt, align 8
  %201 = load i32* @P, align 4
  %conv298 = sitofp i32 %201 to double
  %div299 = fdiv double %200, %conv298
  store double %div299, double* %avgt, align 8
  %202 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac300 = getelementptr inbounds %struct.GlobalMemory* %202, i32 0, i32 0
  %203 = load double** %t_in_fac300, align 8
  %arrayidx301 = getelementptr inbounds double* %203, i64 0
  %204 = load double* %arrayidx301, align 8
  store double %204, double* %avg_fac, align 8
  store double %204, double* %max_fac, align 8
  store double %204, double* %min_fac, align 8
  %205 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve302 = getelementptr inbounds %struct.GlobalMemory* %205, i32 0, i32 1
  %206 = load double** %t_in_solve302, align 8
  %arrayidx303 = getelementptr inbounds double* %206, i64 0
  %207 = load double* %arrayidx303, align 8
  store double %207, double* %avg_solve, align 8
  store double %207, double* %max_solve, align 8
  store double %207, double* %min_solve, align 8
  %208 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod304 = getelementptr inbounds %struct.GlobalMemory* %208, i32 0, i32 2
  %209 = load double** %t_in_mod304, align 8
  %arrayidx305 = getelementptr inbounds double* %209, i64 0
  %210 = load double* %arrayidx305, align 8
  store double %210, double* %avg_mod, align 8
  store double %210, double* %max_mod, align 8
  store double %210, double* %min_mod, align 8
  %211 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar306 = getelementptr inbounds %struct.GlobalMemory* %211, i32 0, i32 3
  %212 = load double** %t_in_bar306, align 8
  %arrayidx307 = getelementptr inbounds double* %212, i64 0
  %213 = load double* %arrayidx307, align 8
  store double %213, double* %avg_bar, align 8
  store double %213, double* %max_bar, align 8
  store double %213, double* %min_bar, align 8
  store i32 1, i32* %i, align 4
  br label %for.cond308

for.cond308:                                      ; preds = %for.inc408, %for.end297
  %214 = load i32* %i, align 4
  %215 = load i32* @P, align 4
  %cmp309 = icmp slt i32 %214, %215
  br i1 %cmp309, label %for.body311, label %for.end410

for.body311:                                      ; preds = %for.cond308
  %216 = load i32* %i, align 4
  %idxprom312 = sext i32 %216 to i64
  %217 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac313 = getelementptr inbounds %struct.GlobalMemory* %217, i32 0, i32 0
  %218 = load double** %t_in_fac313, align 8
  %arrayidx314 = getelementptr inbounds double* %218, i64 %idxprom312
  %219 = load double* %arrayidx314, align 8
  %220 = load double* %max_fac, align 8
  %cmp315 = fcmp ogt double %219, %220
  br i1 %cmp315, label %if.then317, label %if.end321

if.then317:                                       ; preds = %for.body311
  %221 = load i32* %i, align 4
  %idxprom318 = sext i32 %221 to i64
  %222 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac319 = getelementptr inbounds %struct.GlobalMemory* %222, i32 0, i32 0
  %223 = load double** %t_in_fac319, align 8
  %arrayidx320 = getelementptr inbounds double* %223, i64 %idxprom318
  %224 = load double* %arrayidx320, align 8
  store double %224, double* %max_fac, align 8
  br label %if.end321

if.end321:                                        ; preds = %if.then317, %for.body311
  %225 = load i32* %i, align 4
  %idxprom322 = sext i32 %225 to i64
  %226 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac323 = getelementptr inbounds %struct.GlobalMemory* %226, i32 0, i32 0
  %227 = load double** %t_in_fac323, align 8
  %arrayidx324 = getelementptr inbounds double* %227, i64 %idxprom322
  %228 = load double* %arrayidx324, align 8
  %229 = load double* %min_fac, align 8
  %cmp325 = fcmp olt double %228, %229
  br i1 %cmp325, label %if.then327, label %if.end331

if.then327:                                       ; preds = %if.end321
  %230 = load i32* %i, align 4
  %idxprom328 = sext i32 %230 to i64
  %231 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac329 = getelementptr inbounds %struct.GlobalMemory* %231, i32 0, i32 0
  %232 = load double** %t_in_fac329, align 8
  %arrayidx330 = getelementptr inbounds double* %232, i64 %idxprom328
  %233 = load double* %arrayidx330, align 8
  store double %233, double* %min_fac, align 8
  br label %if.end331

if.end331:                                        ; preds = %if.then327, %if.end321
  %234 = load i32* %i, align 4
  %idxprom332 = sext i32 %234 to i64
  %235 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve333 = getelementptr inbounds %struct.GlobalMemory* %235, i32 0, i32 1
  %236 = load double** %t_in_solve333, align 8
  %arrayidx334 = getelementptr inbounds double* %236, i64 %idxprom332
  %237 = load double* %arrayidx334, align 8
  %238 = load double* %max_solve, align 8
  %cmp335 = fcmp ogt double %237, %238
  br i1 %cmp335, label %if.then337, label %if.end341

if.then337:                                       ; preds = %if.end331
  %239 = load i32* %i, align 4
  %idxprom338 = sext i32 %239 to i64
  %240 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve339 = getelementptr inbounds %struct.GlobalMemory* %240, i32 0, i32 1
  %241 = load double** %t_in_solve339, align 8
  %arrayidx340 = getelementptr inbounds double* %241, i64 %idxprom338
  %242 = load double* %arrayidx340, align 8
  store double %242, double* %max_solve, align 8
  br label %if.end341

if.end341:                                        ; preds = %if.then337, %if.end331
  %243 = load i32* %i, align 4
  %idxprom342 = sext i32 %243 to i64
  %244 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve343 = getelementptr inbounds %struct.GlobalMemory* %244, i32 0, i32 1
  %245 = load double** %t_in_solve343, align 8
  %arrayidx344 = getelementptr inbounds double* %245, i64 %idxprom342
  %246 = load double* %arrayidx344, align 8
  %247 = load double* %min_solve, align 8
  %cmp345 = fcmp olt double %246, %247
  br i1 %cmp345, label %if.then347, label %if.end351

if.then347:                                       ; preds = %if.end341
  %248 = load i32* %i, align 4
  %idxprom348 = sext i32 %248 to i64
  %249 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve349 = getelementptr inbounds %struct.GlobalMemory* %249, i32 0, i32 1
  %250 = load double** %t_in_solve349, align 8
  %arrayidx350 = getelementptr inbounds double* %250, i64 %idxprom348
  %251 = load double* %arrayidx350, align 8
  store double %251, double* %min_solve, align 8
  br label %if.end351

if.end351:                                        ; preds = %if.then347, %if.end341
  %252 = load i32* %i, align 4
  %idxprom352 = sext i32 %252 to i64
  %253 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod353 = getelementptr inbounds %struct.GlobalMemory* %253, i32 0, i32 2
  %254 = load double** %t_in_mod353, align 8
  %arrayidx354 = getelementptr inbounds double* %254, i64 %idxprom352
  %255 = load double* %arrayidx354, align 8
  %256 = load double* %max_mod, align 8
  %cmp355 = fcmp ogt double %255, %256
  br i1 %cmp355, label %if.then357, label %if.end361

if.then357:                                       ; preds = %if.end351
  %257 = load i32* %i, align 4
  %idxprom358 = sext i32 %257 to i64
  %258 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod359 = getelementptr inbounds %struct.GlobalMemory* %258, i32 0, i32 2
  %259 = load double** %t_in_mod359, align 8
  %arrayidx360 = getelementptr inbounds double* %259, i64 %idxprom358
  %260 = load double* %arrayidx360, align 8
  store double %260, double* %max_mod, align 8
  br label %if.end361

if.end361:                                        ; preds = %if.then357, %if.end351
  %261 = load i32* %i, align 4
  %idxprom362 = sext i32 %261 to i64
  %262 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod363 = getelementptr inbounds %struct.GlobalMemory* %262, i32 0, i32 2
  %263 = load double** %t_in_mod363, align 8
  %arrayidx364 = getelementptr inbounds double* %263, i64 %idxprom362
  %264 = load double* %arrayidx364, align 8
  %265 = load double* %min_mod, align 8
  %cmp365 = fcmp olt double %264, %265
  br i1 %cmp365, label %if.then367, label %if.end371

if.then367:                                       ; preds = %if.end361
  %266 = load i32* %i, align 4
  %idxprom368 = sext i32 %266 to i64
  %267 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod369 = getelementptr inbounds %struct.GlobalMemory* %267, i32 0, i32 2
  %268 = load double** %t_in_mod369, align 8
  %arrayidx370 = getelementptr inbounds double* %268, i64 %idxprom368
  %269 = load double* %arrayidx370, align 8
  store double %269, double* %min_mod, align 8
  br label %if.end371

if.end371:                                        ; preds = %if.then367, %if.end361
  %270 = load i32* %i, align 4
  %idxprom372 = sext i32 %270 to i64
  %271 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar373 = getelementptr inbounds %struct.GlobalMemory* %271, i32 0, i32 3
  %272 = load double** %t_in_bar373, align 8
  %arrayidx374 = getelementptr inbounds double* %272, i64 %idxprom372
  %273 = load double* %arrayidx374, align 8
  %274 = load double* %max_bar, align 8
  %cmp375 = fcmp ogt double %273, %274
  br i1 %cmp375, label %if.then377, label %if.end381

if.then377:                                       ; preds = %if.end371
  %275 = load i32* %i, align 4
  %idxprom378 = sext i32 %275 to i64
  %276 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar379 = getelementptr inbounds %struct.GlobalMemory* %276, i32 0, i32 3
  %277 = load double** %t_in_bar379, align 8
  %arrayidx380 = getelementptr inbounds double* %277, i64 %idxprom378
  %278 = load double* %arrayidx380, align 8
  store double %278, double* %max_bar, align 8
  br label %if.end381

if.end381:                                        ; preds = %if.then377, %if.end371
  %279 = load i32* %i, align 4
  %idxprom382 = sext i32 %279 to i64
  %280 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar383 = getelementptr inbounds %struct.GlobalMemory* %280, i32 0, i32 3
  %281 = load double** %t_in_bar383, align 8
  %arrayidx384 = getelementptr inbounds double* %281, i64 %idxprom382
  %282 = load double* %arrayidx384, align 8
  %283 = load double* %min_bar, align 8
  %cmp385 = fcmp olt double %282, %283
  br i1 %cmp385, label %if.then387, label %if.end391

if.then387:                                       ; preds = %if.end381
  %284 = load i32* %i, align 4
  %idxprom388 = sext i32 %284 to i64
  %285 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar389 = getelementptr inbounds %struct.GlobalMemory* %285, i32 0, i32 3
  %286 = load double** %t_in_bar389, align 8
  %arrayidx390 = getelementptr inbounds double* %286, i64 %idxprom388
  %287 = load double* %arrayidx390, align 8
  store double %287, double* %min_bar, align 8
  br label %if.end391

if.end391:                                        ; preds = %if.then387, %if.end381
  %288 = load i32* %i, align 4
  %idxprom392 = sext i32 %288 to i64
  %289 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac393 = getelementptr inbounds %struct.GlobalMemory* %289, i32 0, i32 0
  %290 = load double** %t_in_fac393, align 8
  %arrayidx394 = getelementptr inbounds double* %290, i64 %idxprom392
  %291 = load double* %arrayidx394, align 8
  %292 = load double* %avg_fac, align 8
  %add395 = fadd double %292, %291
  store double %add395, double* %avg_fac, align 8
  %293 = load i32* %i, align 4
  %idxprom396 = sext i32 %293 to i64
  %294 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve397 = getelementptr inbounds %struct.GlobalMemory* %294, i32 0, i32 1
  %295 = load double** %t_in_solve397, align 8
  %arrayidx398 = getelementptr inbounds double* %295, i64 %idxprom396
  %296 = load double* %arrayidx398, align 8
  %297 = load double* %avg_solve, align 8
  %add399 = fadd double %297, %296
  store double %add399, double* %avg_solve, align 8
  %298 = load i32* %i, align 4
  %idxprom400 = sext i32 %298 to i64
  %299 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod401 = getelementptr inbounds %struct.GlobalMemory* %299, i32 0, i32 2
  %300 = load double** %t_in_mod401, align 8
  %arrayidx402 = getelementptr inbounds double* %300, i64 %idxprom400
  %301 = load double* %arrayidx402, align 8
  %302 = load double* %avg_mod, align 8
  %add403 = fadd double %302, %301
  store double %add403, double* %avg_mod, align 8
  %303 = load i32* %i, align 4
  %idxprom404 = sext i32 %303 to i64
  %304 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar405 = getelementptr inbounds %struct.GlobalMemory* %304, i32 0, i32 3
  %305 = load double** %t_in_bar405, align 8
  %arrayidx406 = getelementptr inbounds double* %305, i64 %idxprom404
  %306 = load double* %arrayidx406, align 8
  %307 = load double* %avg_bar, align 8
  %add407 = fadd double %307, %306
  store double %add407, double* %avg_bar, align 8
  br label %for.inc408

for.inc408:                                       ; preds = %if.end391
  %308 = load i32* %i, align 4
  %inc409 = add nsw i32 %308, 1
  store i32 %inc409, i32* %i, align 4
  br label %for.cond308

for.end410:                                       ; preds = %for.cond308
  %309 = load double* %avg_fac, align 8
  %310 = load i32* @P, align 4
  %conv411 = sitofp i32 %310 to double
  %div412 = fdiv double %309, %conv411
  store double %div412, double* %avg_fac, align 8
  %311 = load double* %avg_solve, align 8
  %312 = load i32* @P, align 4
  %conv413 = sitofp i32 %312 to double
  %div414 = fdiv double %311, %conv413
  store double %div414, double* %avg_solve, align 8
  %313 = load double* %avg_mod, align 8
  %314 = load i32* @P, align 4
  %conv415 = sitofp i32 %314 to double
  %div416 = fdiv double %313, %conv415
  store double %div416, double* %avg_mod, align 8
  %315 = load double* %avg_bar, align 8
  %316 = load i32* @P, align 4
  %conv417 = sitofp i32 %316 to double
  %div418 = fdiv double %315, %conv417
  store double %div418, double* %avg_bar, align 8
  br label %if.end419

if.end419:                                        ; preds = %for.end410, %if.end262
  %call420 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([48 x i8]* @.str29, i32 0, i32 0))
  %call421 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([77 x i8]* @.str30, i32 0, i32 0))
  %call422 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([75 x i8]* @.str31, i32 0, i32 0))
  %317 = load %struct.GlobalMemory** @Global, align 8
  %completion423 = getelementptr inbounds %struct.GlobalMemory* %317, i32 0, i32 4
  %318 = load double** %completion423, align 8
  %arrayidx424 = getelementptr inbounds double* %318, i64 0
  %319 = load double* %arrayidx424, align 8
  %320 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac425 = getelementptr inbounds %struct.GlobalMemory* %320, i32 0, i32 0
  %321 = load double** %t_in_fac425, align 8
  %arrayidx426 = getelementptr inbounds double* %321, i64 0
  %322 = load double* %arrayidx426, align 8
  %323 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve427 = getelementptr inbounds %struct.GlobalMemory* %323, i32 0, i32 1
  %324 = load double** %t_in_solve427, align 8
  %arrayidx428 = getelementptr inbounds double* %324, i64 0
  %325 = load double* %arrayidx428, align 8
  %326 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod429 = getelementptr inbounds %struct.GlobalMemory* %326, i32 0, i32 2
  %327 = load double** %t_in_mod429, align 8
  %arrayidx430 = getelementptr inbounds double* %327, i64 0
  %328 = load double* %arrayidx430, align 8
  %329 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar431 = getelementptr inbounds %struct.GlobalMemory* %329, i32 0, i32 3
  %330 = load double** %t_in_bar431, align 8
  %arrayidx432 = getelementptr inbounds double* %330, i64 0
  %331 = load double* %arrayidx432, align 8
  %call433 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str32, i32 0, i32 0), double %319, double %322, double %325, double %328, double %331)
  %332 = load i32* @dostats, align 4
  %tobool434 = icmp ne i32 %332, 0
  br i1 %tobool434, label %if.then435, label %if.end462

if.then435:                                       ; preds = %if.end419
  store i32 1, i32* %i, align 4
  br label %for.cond436

for.cond436:                                      ; preds = %for.inc456, %if.then435
  %333 = load i32* %i, align 4
  %334 = load i32* @P, align 4
  %cmp437 = icmp slt i32 %333, %334
  br i1 %cmp437, label %for.body439, label %for.end458

for.body439:                                      ; preds = %for.cond436
  %335 = load i32* %i, align 4
  %336 = load i32* %i, align 4
  %idxprom440 = sext i32 %336 to i64
  %337 = load %struct.GlobalMemory** @Global, align 8
  %completion441 = getelementptr inbounds %struct.GlobalMemory* %337, i32 0, i32 4
  %338 = load double** %completion441, align 8
  %arrayidx442 = getelementptr inbounds double* %338, i64 %idxprom440
  %339 = load double* %arrayidx442, align 8
  %340 = load i32* %i, align 4
  %idxprom443 = sext i32 %340 to i64
  %341 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac444 = getelementptr inbounds %struct.GlobalMemory* %341, i32 0, i32 0
  %342 = load double** %t_in_fac444, align 8
  %arrayidx445 = getelementptr inbounds double* %342, i64 %idxprom443
  %343 = load double* %arrayidx445, align 8
  %344 = load i32* %i, align 4
  %idxprom446 = sext i32 %344 to i64
  %345 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve447 = getelementptr inbounds %struct.GlobalMemory* %345, i32 0, i32 1
  %346 = load double** %t_in_solve447, align 8
  %arrayidx448 = getelementptr inbounds double* %346, i64 %idxprom446
  %347 = load double* %arrayidx448, align 8
  %348 = load i32* %i, align 4
  %idxprom449 = sext i32 %348 to i64
  %349 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod450 = getelementptr inbounds %struct.GlobalMemory* %349, i32 0, i32 2
  %350 = load double** %t_in_mod450, align 8
  %arrayidx451 = getelementptr inbounds double* %350, i64 %idxprom449
  %351 = load double* %arrayidx451, align 8
  %352 = load i32* %i, align 4
  %idxprom452 = sext i32 %352 to i64
  %353 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar453 = getelementptr inbounds %struct.GlobalMemory* %353, i32 0, i32 3
  %354 = load double** %t_in_bar453, align 8
  %arrayidx454 = getelementptr inbounds double* %354, i64 %idxprom452
  %355 = load double* %arrayidx454, align 8
  %call455 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str33, i32 0, i32 0), i32 %335, double %339, double %343, double %347, double %351, double %355)
  br label %for.inc456

for.inc456:                                       ; preds = %for.body439
  %356 = load i32* %i, align 4
  %inc457 = add nsw i32 %356, 1
  store i32 %inc457, i32* %i, align 4
  br label %for.cond436

for.end458:                                       ; preds = %for.cond436
  %357 = load double* %avgt, align 8
  %358 = load double* %avg_fac, align 8
  %359 = load double* %avg_solve, align 8
  %360 = load double* %avg_mod, align 8
  %361 = load double* %avg_bar, align 8
  %call459 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str34, i32 0, i32 0), double %357, double %358, double %359, double %360, double %361)
  %362 = load double* %mint, align 8
  %363 = load double* %min_fac, align 8
  %364 = load double* %min_solve, align 8
  %365 = load double* %min_mod, align 8
  %366 = load double* %min_bar, align 8
  %call460 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str35, i32 0, i32 0), double %362, double %363, double %364, double %365, double %366)
  %367 = load double* %maxt, align 8
  %368 = load double* %max_fac, align 8
  %369 = load double* %max_solve, align 8
  %370 = load double* %max_mod, align 8
  %371 = load double* %max_bar, align 8
  %call461 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str36, i32 0, i32 0), double %367, double %368, double %369, double %370, double %371)
  br label %if.end462

if.end462:                                        ; preds = %for.end458, %if.end419
  %call463 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  %372 = load i32* %start, align 4
  %373 = load %struct.GlobalMemory** @Global, align 8
  %starttime = getelementptr inbounds %struct.GlobalMemory* %373, i32 0, i32 5
  store i32 %372, i32* %starttime, align 4
  %call464 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([48 x i8]* @.str37, i32 0, i32 0))
  %374 = load %struct.GlobalMemory** @Global, align 8
  %starttime465 = getelementptr inbounds %struct.GlobalMemory* %374, i32 0, i32 5
  %375 = load i32* %starttime465, align 4
  %call466 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str38, i32 0, i32 0), i32 %375)
  %376 = load %struct.GlobalMemory** @Global, align 8
  %rs = getelementptr inbounds %struct.GlobalMemory* %376, i32 0, i32 7
  %377 = load i32* %rs, align 4
  %call467 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str39, i32 0, i32 0), i32 %377)
  %378 = load %struct.GlobalMemory** @Global, align 8
  %rf = getelementptr inbounds %struct.GlobalMemory* %378, i32 0, i32 6
  %379 = load i32* %rf, align 4
  %call468 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str40, i32 0, i32 0), i32 %379)
  %380 = load %struct.GlobalMemory** @Global, align 8
  %rf469 = getelementptr inbounds %struct.GlobalMemory* %380, i32 0, i32 6
  %381 = load i32* %rf469, align 4
  %382 = load %struct.GlobalMemory** @Global, align 8
  %starttime470 = getelementptr inbounds %struct.GlobalMemory* %382, i32 0, i32 5
  %383 = load i32* %starttime470, align 4
  %sub471 = sub i32 %381, %383
  %call472 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str41, i32 0, i32 0), i32 %sub471)
  %384 = load %struct.GlobalMemory** @Global, align 8
  %rf473 = getelementptr inbounds %struct.GlobalMemory* %384, i32 0, i32 6
  %385 = load i32* %rf473, align 4
  %386 = load %struct.GlobalMemory** @Global, align 8
  %rs474 = getelementptr inbounds %struct.GlobalMemory* %386, i32 0, i32 7
  %387 = load i32* %rs474, align 4
  %sub475 = sub i32 %385, %387
  %call476 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str42, i32 0, i32 0), i32 %sub475)
  %call477 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  %388 = load i32* @test_result, align 4
  %tobool478 = icmp ne i32 %388, 0
  br i1 %tobool478, label %if.then479, label %if.end481

if.then479:                                       ; preds = %if.end462
  %call480 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([46 x i8]* @.str43, i32 0, i32 0))
  %389 = load i32* @n, align 4
  %390 = load double*** @a, align 8
  %391 = load double** @rhs, align 8
  call void @CheckResult(i32 %389, double** %390, double* %391)
  br label %if.end481

if.end481:                                        ; preds = %if.then479, %if.end462
  call void @exit(i32 0)
  unreachable

return:                                           ; No predecessors!
  %392 = load i32* %retval
  ret i32 %392
}

; Function Attrs: nounwind
declare i64 @time(i64*)

declare i32 @getopt(...)

; Function Attrs: nounwind readonly
declare i32 @atoi(i8*)

declare i32 @printf(i8*, ...)

; Function Attrs: noreturn nounwind
declare void @exit(i32)

; Function Attrs: nounwind readnone
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
  store i8* %s, i8** %s.addr, align 8
  %0 = load %struct._IO_FILE** @stderr, align 8
  %1 = load i8** %s.addr, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([11 x i8]* @.str49, i32 0, i32 0), i8* %1)
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
  store double* %rhs, double** %rhs.addr, align 8
  call void @srand48(i64 1)
  %0 = load i32* @n, align 4
  %1 = load i32* @block_size, align 4
  %rem = srem i32 %0, %1
  store i32 %rem, i32* %edge, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc29, %entry
  %2 = load i32* %j, align 4
  %3 = load i32* @n, align 4
  %cmp = icmp slt i32 %2, %3
  br i1 %cmp, label %for.body, label %for.end31

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %i, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %4 = load i32* %i, align 4
  %5 = load i32* @n, align 4
  %cmp2 = icmp slt i32 %4, %5
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %6 = load i32* @n, align 4
  %7 = load i32* %i, align 4
  %sub = sub nsw i32 %6, %7
  %8 = load i32* %edge, align 4
  %cmp4 = icmp sle i32 %sub, %8
  br i1 %cmp4, label %if.then, label %if.else

if.then:                                          ; preds = %for.body3
  %9 = load i32* %edge, align 4
  store i32 %9, i32* %ibs, align 4
  %10 = load i32* @n, align 4
  %11 = load i32* %edge, align 4
  %sub5 = sub nsw i32 %10, %11
  store i32 %sub5, i32* %ibs, align 4
  %12 = load i32* %edge, align 4
  store i32 %12, i32* %skip, align 4
  br label %if.end

if.else:                                          ; preds = %for.body3
  %13 = load i32* @block_size, align 4
  store i32 %13, i32* %ibs, align 4
  %14 = load i32* @block_size, align 4
  store i32 %14, i32* %skip, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %15 = load i32* @n, align 4
  %16 = load i32* %j, align 4
  %sub6 = sub nsw i32 %15, %16
  %17 = load i32* %edge, align 4
  %cmp7 = icmp sle i32 %sub6, %17
  br i1 %cmp7, label %if.then8, label %if.else10

if.then8:                                         ; preds = %if.end
  %18 = load i32* %edge, align 4
  store i32 %18, i32* %jbs, align 4
  %19 = load i32* @n, align 4
  %20 = load i32* %edge, align 4
  %sub9 = sub nsw i32 %19, %20
  store i32 %sub9, i32* %jbs, align 4
  br label %if.end11

if.else10:                                        ; preds = %if.end
  %21 = load i32* @block_size, align 4
  store i32 %21, i32* %jbs, align 4
  br label %if.end11

if.end11:                                         ; preds = %if.else10, %if.then8
  %22 = load i32* %i, align 4
  %23 = load i32* @block_size, align 4
  %div = sdiv i32 %22, %23
  %24 = load i32* %j, align 4
  %25 = load i32* @block_size, align 4
  %div12 = sdiv i32 %24, %25
  %26 = load i32* @nblocks, align 4
  %mul = mul nsw i32 %div12, %26
  %add = add nsw i32 %div, %mul
  store i32 %add, i32* %ii, align 4
  %27 = load i32* %i, align 4
  %28 = load i32* %ibs, align 4
  %rem13 = srem i32 %27, %28
  %29 = load i32* %j, align 4
  %30 = load i32* %jbs, align 4
  %rem14 = srem i32 %29, %30
  %31 = load i32* %skip, align 4
  %mul15 = mul nsw i32 %rem14, %31
  %add16 = add nsw i32 %rem13, %mul15
  store i32 %add16, i32* %jj, align 4
  %call = call i64 @lrand48()
  %conv = sitofp i64 %call to double
  %div17 = fdiv double %conv, 3.276700e+04
  %32 = load i32* %jj, align 4
  %idxprom = sext i32 %32 to i64
  %33 = load i32* %ii, align 4
  %idxprom18 = sext i32 %33 to i64
  %34 = load double*** @a, align 8
  %arrayidx = getelementptr inbounds double** %34, i64 %idxprom18
  %35 = load double** %arrayidx, align 8
  %arrayidx19 = getelementptr inbounds double* %35, i64 %idxprom
  store double %div17, double* %arrayidx19, align 8
  %36 = load i32* %i, align 4
  %37 = load i32* %j, align 4
  %cmp20 = icmp eq i32 %36, %37
  br i1 %cmp20, label %if.then22, label %if.end28

if.then22:                                        ; preds = %if.end11
  %38 = load i32* %jj, align 4
  %idxprom23 = sext i32 %38 to i64
  %39 = load i32* %ii, align 4
  %idxprom24 = sext i32 %39 to i64
  %40 = load double*** @a, align 8
  %arrayidx25 = getelementptr inbounds double** %40, i64 %idxprom24
  %41 = load double** %arrayidx25, align 8
  %arrayidx26 = getelementptr inbounds double* %41, i64 %idxprom23
  %42 = load double* %arrayidx26, align 8
  %mul27 = fmul double %42, 1.000000e+01
  store double %mul27, double* %arrayidx26, align 8
  br label %if.end28

if.end28:                                         ; preds = %if.then22, %if.end11
  br label %for.inc

for.inc:                                          ; preds = %if.end28
  %43 = load i32* %i, align 4
  %inc = add nsw i32 %43, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc29

for.inc29:                                        ; preds = %for.end
  %44 = load i32* %j, align 4
  %inc30 = add nsw i32 %44, 1
  store i32 %inc30, i32* %j, align 4
  br label %for.cond

for.end31:                                        ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond32

for.cond32:                                       ; preds = %for.inc38, %for.end31
  %45 = load i32* %j, align 4
  %46 = load i32* @n, align 4
  %cmp33 = icmp slt i32 %45, %46
  br i1 %cmp33, label %for.body35, label %for.end40

for.body35:                                       ; preds = %for.cond32
  %47 = load i32* %j, align 4
  %idxprom36 = sext i32 %47 to i64
  %48 = load double** %rhs.addr, align 8
  %arrayidx37 = getelementptr inbounds double* %48, i64 %idxprom36
  store double 0.000000e+00, double* %arrayidx37, align 8
  br label %for.inc38

for.inc38:                                        ; preds = %for.body35
  %49 = load i32* %j, align 4
  %inc39 = add nsw i32 %49, 1
  store i32 %inc39, i32* %j, align 4
  br label %for.cond32

for.end40:                                        ; preds = %for.cond32
  store i32 0, i32* %j, align 4
  br label %for.cond41

for.cond41:                                       ; preds = %for.inc81, %for.end40
  %50 = load i32* %j, align 4
  %51 = load i32* @n, align 4
  %cmp42 = icmp slt i32 %50, %51
  br i1 %cmp42, label %for.body44, label %for.end83

for.body44:                                       ; preds = %for.cond41
  store i32 0, i32* %i, align 4
  br label %for.cond45

for.cond45:                                       ; preds = %for.inc78, %for.body44
  %52 = load i32* %i, align 4
  %53 = load i32* @n, align 4
  %cmp46 = icmp slt i32 %52, %53
  br i1 %cmp46, label %for.body48, label %for.end80

for.body48:                                       ; preds = %for.cond45
  %54 = load i32* @n, align 4
  %55 = load i32* %i, align 4
  %sub49 = sub nsw i32 %54, %55
  %56 = load i32* %edge, align 4
  %cmp50 = icmp sle i32 %sub49, %56
  br i1 %cmp50, label %if.then52, label %if.else54

if.then52:                                        ; preds = %for.body48
  %57 = load i32* %edge, align 4
  store i32 %57, i32* %ibs, align 4
  %58 = load i32* @n, align 4
  %59 = load i32* %edge, align 4
  %sub53 = sub nsw i32 %58, %59
  store i32 %sub53, i32* %ibs, align 4
  %60 = load i32* %edge, align 4
  store i32 %60, i32* %skip, align 4
  br label %if.end55

if.else54:                                        ; preds = %for.body48
  %61 = load i32* @block_size, align 4
  store i32 %61, i32* %ibs, align 4
  %62 = load i32* @block_size, align 4
  store i32 %62, i32* %skip, align 4
  br label %if.end55

if.end55:                                         ; preds = %if.else54, %if.then52
  %63 = load i32* @n, align 4
  %64 = load i32* %j, align 4
  %sub56 = sub nsw i32 %63, %64
  %65 = load i32* %edge, align 4
  %cmp57 = icmp sle i32 %sub56, %65
  br i1 %cmp57, label %if.then59, label %if.else61

if.then59:                                        ; preds = %if.end55
  %66 = load i32* %edge, align 4
  store i32 %66, i32* %jbs, align 4
  %67 = load i32* @n, align 4
  %68 = load i32* %edge, align 4
  %sub60 = sub nsw i32 %67, %68
  store i32 %sub60, i32* %jbs, align 4
  br label %if.end62

if.else61:                                        ; preds = %if.end55
  %69 = load i32* @block_size, align 4
  store i32 %69, i32* %jbs, align 4
  br label %if.end62

if.end62:                                         ; preds = %if.else61, %if.then59
  %70 = load i32* %i, align 4
  %71 = load i32* @block_size, align 4
  %div63 = sdiv i32 %70, %71
  %72 = load i32* %j, align 4
  %73 = load i32* @block_size, align 4
  %div64 = sdiv i32 %72, %73
  %74 = load i32* @nblocks, align 4
  %mul65 = mul nsw i32 %div64, %74
  %add66 = add nsw i32 %div63, %mul65
  store i32 %add66, i32* %ii, align 4
  %75 = load i32* %i, align 4
  %76 = load i32* %ibs, align 4
  %rem67 = srem i32 %75, %76
  %77 = load i32* %j, align 4
  %78 = load i32* %jbs, align 4
  %rem68 = srem i32 %77, %78
  %79 = load i32* %skip, align 4
  %mul69 = mul nsw i32 %rem68, %79
  %add70 = add nsw i32 %rem67, %mul69
  store i32 %add70, i32* %jj, align 4
  %80 = load i32* %jj, align 4
  %idxprom71 = sext i32 %80 to i64
  %81 = load i32* %ii, align 4
  %idxprom72 = sext i32 %81 to i64
  %82 = load double*** @a, align 8
  %arrayidx73 = getelementptr inbounds double** %82, i64 %idxprom72
  %83 = load double** %arrayidx73, align 8
  %arrayidx74 = getelementptr inbounds double* %83, i64 %idxprom71
  %84 = load double* %arrayidx74, align 8
  %85 = load i32* %i, align 4
  %idxprom75 = sext i32 %85 to i64
  %86 = load double** %rhs.addr, align 8
  %arrayidx76 = getelementptr inbounds double* %86, i64 %idxprom75
  %87 = load double* %arrayidx76, align 8
  %add77 = fadd double %87, %84
  store double %add77, double* %arrayidx76, align 8
  br label %for.inc78

for.inc78:                                        ; preds = %if.end62
  %88 = load i32* %i, align 4
  %inc79 = add nsw i32 %88, 1
  store i32 %inc79, i32* %i, align 4
  br label %for.cond45

for.end80:                                        ; preds = %for.cond45
  br label %for.inc81

for.inc81:                                        ; preds = %for.end80
  %89 = load i32* %j, align 4
  %inc82 = add nsw i32 %89, 1
  store i32 %inc82, i32* %j, align 4
  br label %for.cond41

for.end83:                                        ; preds = %for.cond41
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
  store i32 %n, i32* %n.addr, align 4
  store double** %a, double*** %a.addr, align 8
  store double* %rhs, double** %rhs.addr, align 8
  store i32 0, i32* %bogus, align 4
  %0 = load i32* %n.addr, align 4
  %1 = load i32* @block_size, align 4
  %rem = srem i32 %0, %1
  store i32 %rem, i32* %edge, align 4
  %2 = load i32* %n.addr, align 4
  %conv = sext i32 %2 to i64
  %mul = mul i64 %conv, 8
  %call = call noalias i8* @malloc(i64 %mul)
  %3 = bitcast i8* %call to double*
  store double* %3, double** %y, align 8
  %4 = load double** %y, align 8
  %cmp = icmp eq double* %4, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @printerr(i8* getelementptr inbounds ([31 x i8]* @.str46, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end:                                           ; preds = %entry
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %5 = load i32* %j, align 4
  %6 = load i32* %n.addr, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %7 = load i32* %j, align 4
  %idxprom = sext i32 %7 to i64
  %8 = load double** %rhs.addr, align 8
  %arrayidx = getelementptr inbounds double* %8, i64 %idxprom
  %9 = load double* %arrayidx, align 8
  %10 = load i32* %j, align 4
  %idxprom4 = sext i32 %10 to i64
  %11 = load double** %y, align 8
  %arrayidx5 = getelementptr inbounds double* %11, i64 %idxprom4
  store double %9, double* %arrayidx5, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %12 = load i32* %j, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond6

for.cond6:                                        ; preds = %for.inc63, %for.end
  %13 = load i32* %j, align 4
  %14 = load i32* %n.addr, align 4
  %cmp7 = icmp slt i32 %13, %14
  br i1 %cmp7, label %for.body9, label %for.end65

for.body9:                                        ; preds = %for.cond6
  %15 = load i32* %n.addr, align 4
  %16 = load i32* %j, align 4
  %sub = sub nsw i32 %15, %16
  %17 = load i32* %edge, align 4
  %cmp10 = icmp sle i32 %sub, %17
  br i1 %cmp10, label %if.then12, label %if.else

if.then12:                                        ; preds = %for.body9
  %18 = load i32* %edge, align 4
  store i32 %18, i32* %jbs, align 4
  %19 = load i32* %n.addr, align 4
  %20 = load i32* %edge, align 4
  %sub13 = sub nsw i32 %19, %20
  store i32 %sub13, i32* %jbs, align 4
  %21 = load i32* %edge, align 4
  store i32 %21, i32* %skip, align 4
  br label %if.end14

if.else:                                          ; preds = %for.body9
  %22 = load i32* @block_size, align 4
  store i32 %22, i32* %jbs, align 4
  %23 = load i32* @block_size, align 4
  store i32 %23, i32* %skip, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.else, %if.then12
  %24 = load i32* %j, align 4
  %25 = load i32* @block_size, align 4
  %div = sdiv i32 %24, %25
  %26 = load i32* %j, align 4
  %27 = load i32* @block_size, align 4
  %div15 = sdiv i32 %26, %27
  %28 = load i32* @nblocks, align 4
  %mul16 = mul nsw i32 %div15, %28
  %add = add nsw i32 %div, %mul16
  store i32 %add, i32* %ii, align 4
  %29 = load i32* %j, align 4
  %30 = load i32* %jbs, align 4
  %rem17 = srem i32 %29, %30
  %31 = load i32* %j, align 4
  %32 = load i32* %jbs, align 4
  %rem18 = srem i32 %31, %32
  %33 = load i32* %skip, align 4
  %mul19 = mul nsw i32 %rem18, %33
  %add20 = add nsw i32 %rem17, %mul19
  store i32 %add20, i32* %jj, align 4
  %34 = load i32* %j, align 4
  %idxprom21 = sext i32 %34 to i64
  %35 = load double** %y, align 8
  %arrayidx22 = getelementptr inbounds double* %35, i64 %idxprom21
  %36 = load double* %arrayidx22, align 8
  %37 = load i32* %jj, align 4
  %idxprom23 = sext i32 %37 to i64
  %38 = load i32* %ii, align 4
  %idxprom24 = sext i32 %38 to i64
  %39 = load double*** %a.addr, align 8
  %arrayidx25 = getelementptr inbounds double** %39, i64 %idxprom24
  %40 = load double** %arrayidx25, align 8
  %arrayidx26 = getelementptr inbounds double* %40, i64 %idxprom23
  %41 = load double* %arrayidx26, align 8
  %div27 = fdiv double %36, %41
  %42 = load i32* %j, align 4
  %idxprom28 = sext i32 %42 to i64
  %43 = load double** %y, align 8
  %arrayidx29 = getelementptr inbounds double* %43, i64 %idxprom28
  store double %div27, double* %arrayidx29, align 8
  %44 = load i32* %j, align 4
  %add30 = add nsw i32 %44, 1
  store i32 %add30, i32* %i, align 4
  br label %for.cond31

for.cond31:                                       ; preds = %for.inc60, %if.end14
  %45 = load i32* %i, align 4
  %46 = load i32* %n.addr, align 4
  %cmp32 = icmp slt i32 %45, %46
  br i1 %cmp32, label %for.body34, label %for.end62

for.body34:                                       ; preds = %for.cond31
  %47 = load i32* %n.addr, align 4
  %48 = load i32* %i, align 4
  %sub35 = sub nsw i32 %47, %48
  %49 = load i32* %edge, align 4
  %cmp36 = icmp sle i32 %sub35, %49
  br i1 %cmp36, label %if.then38, label %if.else40

if.then38:                                        ; preds = %for.body34
  %50 = load i32* %edge, align 4
  store i32 %50, i32* %ibs, align 4
  %51 = load i32* %n.addr, align 4
  %52 = load i32* %edge, align 4
  %sub39 = sub nsw i32 %51, %52
  store i32 %sub39, i32* %ibs, align 4
  %53 = load i32* %edge, align 4
  store i32 %53, i32* %skip, align 4
  br label %if.end41

if.else40:                                        ; preds = %for.body34
  %54 = load i32* @block_size, align 4
  store i32 %54, i32* %ibs, align 4
  %55 = load i32* @block_size, align 4
  store i32 %55, i32* %skip, align 4
  br label %if.end41

if.end41:                                         ; preds = %if.else40, %if.then38
  %56 = load i32* %i, align 4
  %57 = load i32* @block_size, align 4
  %div42 = sdiv i32 %56, %57
  %58 = load i32* %j, align 4
  %59 = load i32* @block_size, align 4
  %div43 = sdiv i32 %58, %59
  %60 = load i32* @nblocks, align 4
  %mul44 = mul nsw i32 %div43, %60
  %add45 = add nsw i32 %div42, %mul44
  store i32 %add45, i32* %ii, align 4
  %61 = load i32* %i, align 4
  %62 = load i32* %ibs, align 4
  %rem46 = srem i32 %61, %62
  %63 = load i32* %j, align 4
  %64 = load i32* %jbs, align 4
  %rem47 = srem i32 %63, %64
  %65 = load i32* %skip, align 4
  %mul48 = mul nsw i32 %rem47, %65
  %add49 = add nsw i32 %rem46, %mul48
  store i32 %add49, i32* %jj, align 4
  %66 = load i32* %jj, align 4
  %idxprom50 = sext i32 %66 to i64
  %67 = load i32* %ii, align 4
  %idxprom51 = sext i32 %67 to i64
  %68 = load double*** %a.addr, align 8
  %arrayidx52 = getelementptr inbounds double** %68, i64 %idxprom51
  %69 = load double** %arrayidx52, align 8
  %arrayidx53 = getelementptr inbounds double* %69, i64 %idxprom50
  %70 = load double* %arrayidx53, align 8
  %71 = load i32* %j, align 4
  %idxprom54 = sext i32 %71 to i64
  %72 = load double** %y, align 8
  %arrayidx55 = getelementptr inbounds double* %72, i64 %idxprom54
  %73 = load double* %arrayidx55, align 8
  %mul56 = fmul double %70, %73
  %74 = load i32* %i, align 4
  %idxprom57 = sext i32 %74 to i64
  %75 = load double** %y, align 8
  %arrayidx58 = getelementptr inbounds double* %75, i64 %idxprom57
  %76 = load double* %arrayidx58, align 8
  %sub59 = fsub double %76, %mul56
  store double %sub59, double* %arrayidx58, align 8
  br label %for.inc60

for.inc60:                                        ; preds = %if.end41
  %77 = load i32* %i, align 4
  %inc61 = add nsw i32 %77, 1
  store i32 %inc61, i32* %i, align 4
  br label %for.cond31

for.end62:                                        ; preds = %for.cond31
  br label %for.inc63

for.inc63:                                        ; preds = %for.end62
  %78 = load i32* %j, align 4
  %inc64 = add nsw i32 %78, 1
  store i32 %inc64, i32* %j, align 4
  br label %for.cond6

for.end65:                                        ; preds = %for.cond6
  %79 = load i32* %n.addr, align 4
  %sub66 = sub nsw i32 %79, 1
  store i32 %sub66, i32* %j, align 4
  br label %for.cond67

for.cond67:                                       ; preds = %for.inc110, %for.end65
  %80 = load i32* %j, align 4
  %cmp68 = icmp sge i32 %80, 0
  br i1 %cmp68, label %for.body70, label %for.end111

for.body70:                                       ; preds = %for.cond67
  store i32 0, i32* %i, align 4
  br label %for.cond71

for.cond71:                                       ; preds = %for.inc107, %for.body70
  %81 = load i32* %i, align 4
  %82 = load i32* %j, align 4
  %cmp72 = icmp slt i32 %81, %82
  br i1 %cmp72, label %for.body74, label %for.end109

for.body74:                                       ; preds = %for.cond71
  %83 = load i32* %n.addr, align 4
  %84 = load i32* %i, align 4
  %sub75 = sub nsw i32 %83, %84
  %85 = load i32* %edge, align 4
  %cmp76 = icmp sle i32 %sub75, %85
  br i1 %cmp76, label %if.then78, label %if.else80

if.then78:                                        ; preds = %for.body74
  %86 = load i32* %edge, align 4
  store i32 %86, i32* %ibs, align 4
  %87 = load i32* %n.addr, align 4
  %88 = load i32* %edge, align 4
  %sub79 = sub nsw i32 %87, %88
  store i32 %sub79, i32* %ibs, align 4
  %89 = load i32* %edge, align 4
  store i32 %89, i32* %skip, align 4
  br label %if.end81

if.else80:                                        ; preds = %for.body74
  %90 = load i32* @block_size, align 4
  store i32 %90, i32* %ibs, align 4
  %91 = load i32* @block_size, align 4
  store i32 %91, i32* %skip, align 4
  br label %if.end81

if.end81:                                         ; preds = %if.else80, %if.then78
  %92 = load i32* %n.addr, align 4
  %93 = load i32* %j, align 4
  %sub82 = sub nsw i32 %92, %93
  %94 = load i32* %edge, align 4
  %cmp83 = icmp sle i32 %sub82, %94
  br i1 %cmp83, label %if.then85, label %if.else87

if.then85:                                        ; preds = %if.end81
  %95 = load i32* %edge, align 4
  store i32 %95, i32* %jbs, align 4
  %96 = load i32* %n.addr, align 4
  %97 = load i32* %edge, align 4
  %sub86 = sub nsw i32 %96, %97
  store i32 %sub86, i32* %jbs, align 4
  br label %if.end88

if.else87:                                        ; preds = %if.end81
  %98 = load i32* @block_size, align 4
  store i32 %98, i32* %jbs, align 4
  br label %if.end88

if.end88:                                         ; preds = %if.else87, %if.then85
  %99 = load i32* %i, align 4
  %100 = load i32* @block_size, align 4
  %div89 = sdiv i32 %99, %100
  %101 = load i32* %j, align 4
  %102 = load i32* @block_size, align 4
  %div90 = sdiv i32 %101, %102
  %103 = load i32* @nblocks, align 4
  %mul91 = mul nsw i32 %div90, %103
  %add92 = add nsw i32 %div89, %mul91
  store i32 %add92, i32* %ii, align 4
  %104 = load i32* %i, align 4
  %105 = load i32* %ibs, align 4
  %rem93 = srem i32 %104, %105
  %106 = load i32* %j, align 4
  %107 = load i32* %jbs, align 4
  %rem94 = srem i32 %106, %107
  %108 = load i32* %skip, align 4
  %mul95 = mul nsw i32 %rem94, %108
  %add96 = add nsw i32 %rem93, %mul95
  store i32 %add96, i32* %jj, align 4
  %109 = load i32* %jj, align 4
  %idxprom97 = sext i32 %109 to i64
  %110 = load i32* %ii, align 4
  %idxprom98 = sext i32 %110 to i64
  %111 = load double*** %a.addr, align 8
  %arrayidx99 = getelementptr inbounds double** %111, i64 %idxprom98
  %112 = load double** %arrayidx99, align 8
  %arrayidx100 = getelementptr inbounds double* %112, i64 %idxprom97
  %113 = load double* %arrayidx100, align 8
  %114 = load i32* %j, align 4
  %idxprom101 = sext i32 %114 to i64
  %115 = load double** %y, align 8
  %arrayidx102 = getelementptr inbounds double* %115, i64 %idxprom101
  %116 = load double* %arrayidx102, align 8
  %mul103 = fmul double %113, %116
  %117 = load i32* %i, align 4
  %idxprom104 = sext i32 %117 to i64
  %118 = load double** %y, align 8
  %arrayidx105 = getelementptr inbounds double* %118, i64 %idxprom104
  %119 = load double* %arrayidx105, align 8
  %sub106 = fsub double %119, %mul103
  store double %sub106, double* %arrayidx105, align 8
  br label %for.inc107

for.inc107:                                       ; preds = %if.end88
  %120 = load i32* %i, align 4
  %inc108 = add nsw i32 %120, 1
  store i32 %inc108, i32* %i, align 4
  br label %for.cond71

for.end109:                                       ; preds = %for.cond71
  br label %for.inc110

for.inc110:                                       ; preds = %for.end109
  %121 = load i32* %j, align 4
  %dec = add nsw i32 %121, -1
  store i32 %dec, i32* %j, align 4
  br label %for.cond67

for.end111:                                       ; preds = %for.cond67
  store double 0.000000e+00, double* %max_diff, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond112

for.cond112:                                      ; preds = %for.inc124, %for.end111
  %122 = load i32* %j, align 4
  %123 = load i32* %n.addr, align 4
  %cmp113 = icmp slt i32 %122, %123
  br i1 %cmp113, label %for.body115, label %for.end126

for.body115:                                      ; preds = %for.cond112
  %124 = load i32* %j, align 4
  %idxprom116 = sext i32 %124 to i64
  %125 = load double** %y, align 8
  %arrayidx117 = getelementptr inbounds double* %125, i64 %idxprom116
  %126 = load double* %arrayidx117, align 8
  %sub118 = fsub double %126, 1.000000e+00
  store double %sub118, double* %diff, align 8
  %127 = load double* %diff, align 8
  %call119 = call double @fabs(double %127)
  %cmp120 = fcmp ogt double %call119, 1.000000e-05
  br i1 %cmp120, label %if.then122, label %if.end123

if.then122:                                       ; preds = %for.body115
  store i32 1, i32* %bogus, align 4
  %128 = load double* %diff, align 8
  store double %128, double* %max_diff, align 8
  br label %if.end123

if.end123:                                        ; preds = %if.then122, %for.body115
  br label %for.inc124

for.inc124:                                       ; preds = %if.end123
  %129 = load i32* %j, align 4
  %inc125 = add nsw i32 %129, 1
  store i32 %inc125, i32* %j, align 4
  br label %for.cond112

for.end126:                                       ; preds = %for.cond112
  %130 = load i32* %bogus, align 4
  %tobool = icmp ne i32 %130, 0
  br i1 %tobool, label %if.then127, label %if.else129

if.then127:                                       ; preds = %for.end126
  %131 = load double* %max_diff, align 8
  %call128 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([26 x i8]* @.str47, i32 0, i32 0), double %131)
  br label %if.end131

if.else129:                                       ; preds = %for.end126
  %call130 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([13 x i8]* @.str48, i32 0, i32 0))
  br label %if.end131

if.end131:                                        ; preds = %if.else129, %if.then127
  %132 = load double** %y, align 8
  %133 = bitcast double* %132 to i8*
  call void @free(i8* %133)
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
  %idlock = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 11
  %call = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %idlock)
  %1 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %1, i32 0, i32 9
  %2 = load i32* %id, align 4
  store i32 %2, i32* %MyNum, align 4
  %3 = load %struct.GlobalMemory** @Global, align 8
  %id1 = getelementptr inbounds %struct.GlobalMemory* %3, i32 0, i32 9
  %4 = load i32* %id1, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %id1, align 4
  %5 = load %struct.GlobalMemory** @Global, align 8
  %idlock2 = getelementptr inbounds %struct.GlobalMemory* %5, i32 0, i32 11
  %call3 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %idlock2)
  %6 = load i32* @n, align 4
  %7 = load i32* @block_size, align 4
  %8 = load double*** @a, align 8
  %9 = load i32* %MyNum, align 4
  %10 = load i32* @dostats, align 4
  call void @OneSolve(i32 %6, i32 %7, double** %8, i32 %9, i32 %10)
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
  store double** %a, double*** %a.addr, align 8
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store i32 %dostats, i32* %dostats.addr, align 4
  %call = call noalias i8* @malloc(i64 32)
  %0 = bitcast i8* %call to %struct.LocalCopies*
  store %struct.LocalCopies* %0, %struct.LocalCopies** %lc, align 8
  %1 = load %struct.LocalCopies** %lc, align 8
  %cmp = icmp eq %struct.LocalCopies* %1, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %2 = load %struct._IO_FILE** @stderr, align 8
  %3 = load i32* %MyNum.addr, align 4
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([40 x i8]* @.str44, i32 0, i32 0), i32 %3)
  call void @exit(i32 -1)
  unreachable

if.end:                                           ; preds = %entry
  %4 = load %struct.LocalCopies** %lc, align 8
  %t_in_fac = getelementptr inbounds %struct.LocalCopies* %4, i32 0, i32 0
  store double 0.000000e+00, double* %t_in_fac, align 8
  %5 = load %struct.LocalCopies** %lc, align 8
  %t_in_solve = getelementptr inbounds %struct.LocalCopies* %5, i32 0, i32 1
  store double 0.000000e+00, double* %t_in_solve, align 8
  %6 = load %struct.LocalCopies** %lc, align 8
  %t_in_mod = getelementptr inbounds %struct.LocalCopies* %6, i32 0, i32 2
  store double 0.000000e+00, double* %t_in_mod, align 8
  %7 = load %struct.LocalCopies** %lc, align 8
  %t_in_bar = getelementptr inbounds %struct.LocalCopies* %7, i32 0, i32 3
  store double 0.000000e+00, double* %t_in_bar, align 8
  %8 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %8, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  %9 = load volatile i32* %gsense, align 4
  store i32 %9, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end20, %if.end
  %10 = load %struct.GlobalMemory** @Global, align 8
  %start2 = getelementptr inbounds %struct.GlobalMemory* %10, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start2, i32 0, i32 1
  %11 = load volatile i64* %count, align 8
  %conv = trunc i64 %11 to i32
  store i32 %conv, i32* %oldcount, align 4
  %12 = load i32* %oldcount, align 4
  %13 = load i32* %lsense, align 4
  %add = add nsw i32 %12, %13
  store i32 %add, i32* %newcount, align 4
  %14 = load i32* %oldcount, align 4
  %15 = load i32* %newcount, align 4
  %call3 = call i32 @atomic_cmpxchg(i32 %14, i32 %15)
  store i32 %call3, i32* %updatedcount, align 4
  %16 = load i32* %updatedcount, align 4
  %17 = load i32* %oldcount, align 4
  %cmp4 = icmp eq i32 %16, %17
  br i1 %cmp4, label %if.then6, label %if.end20

if.then6:                                         ; preds = %while.body
  %18 = load i32* %newcount, align 4
  %19 = load i32* @P, align 4
  %cmp7 = icmp eq i32 %18, %19
  br i1 %cmp7, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then6
  %20 = load i32* %lsense, align 4
  %cmp9 = icmp eq i32 %20, 1
  br i1 %cmp9, label %if.then16, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then6
  %21 = load i32* %newcount, align 4
  %cmp11 = icmp eq i32 %21, 0
  br i1 %cmp11, label %land.lhs.true13, label %if.end19

land.lhs.true13:                                  ; preds = %lor.lhs.false
  %22 = load i32* %lsense, align 4
  %cmp14 = icmp eq i32 %22, -1
  br i1 %cmp14, label %if.then16, label %if.end19

if.then16:                                        ; preds = %land.lhs.true13, %land.lhs.true
  %23 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %23
  %24 = load %struct.GlobalMemory** @Global, align 8
  %start17 = getelementptr inbounds %struct.GlobalMemory* %24, i32 0, i32 10
  %gsense18 = getelementptr inbounds %struct.barrier_t* %start17, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense18, align 4
  call void @Criteria(i32 1)
  br label %if.end19

if.end19:                                         ; preds = %if.then16, %land.lhs.true13, %lor.lhs.false
  br label %while.end

if.end20:                                         ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end19
  br label %while.cond

while.cond:                                       ; preds = %while.body25, %while.end
  %25 = load %struct.GlobalMemory** @Global, align 8
  %start21 = getelementptr inbounds %struct.GlobalMemory* %25, i32 0, i32 10
  %gsense22 = getelementptr inbounds %struct.barrier_t* %start21, i32 0, i32 0
  %26 = load volatile i32* %gsense22, align 4
  %27 = load i32* %lsense, align 4
  %cmp23 = icmp eq i32 %26, %27
  br i1 %cmp23, label %while.body25, label %while.end26

while.body25:                                     ; preds = %while.cond
  br label %while.cond

while.end26:                                      ; preds = %while.cond
  call void @Criteria(i32 1)
  %28 = load i32* %block_size.addr, align 4
  %29 = load i32* %MyNum.addr, align 4
  %call27 = call double @TouchA(i32 %28, i32 %29)
  %30 = load %struct.GlobalMemory** @Global, align 8
  %start29 = getelementptr inbounds %struct.GlobalMemory* %30, i32 0, i32 10
  %gsense30 = getelementptr inbounds %struct.barrier_t* %start29, i32 0, i32 0
  %31 = load volatile i32* %gsense30, align 4
  store i32 %31, i32* %lsense28, align 4
  br label %while.body32

while.body32:                                     ; preds = %if.end61, %while.end26
  %32 = load %struct.GlobalMemory** @Global, align 8
  %start34 = getelementptr inbounds %struct.GlobalMemory* %32, i32 0, i32 10
  %count35 = getelementptr inbounds %struct.barrier_t* %start34, i32 0, i32 1
  %33 = load volatile i64* %count35, align 8
  %conv36 = trunc i64 %33 to i32
  store i32 %conv36, i32* %oldcount33, align 4
  %34 = load i32* %oldcount33, align 4
  %35 = load i32* %lsense28, align 4
  %add38 = add nsw i32 %34, %35
  store i32 %add38, i32* %newcount37, align 4
  %36 = load i32* %oldcount33, align 4
  %37 = load i32* %newcount37, align 4
  %call41 = call i32 @atomic_cmpxchg(i32 %36, i32 %37)
  store i32 %call41, i32* %updatedcount39, align 4
  %38 = load i32* %updatedcount39, align 4
  %39 = load i32* %oldcount33, align 4
  %cmp42 = icmp eq i32 %38, %39
  br i1 %cmp42, label %if.then44, label %if.end61

if.then44:                                        ; preds = %while.body32
  %40 = load i32* %newcount37, align 4
  %41 = load i32* @P, align 4
  %cmp45 = icmp eq i32 %40, %41
  br i1 %cmp45, label %land.lhs.true47, label %lor.lhs.false50

land.lhs.true47:                                  ; preds = %if.then44
  %42 = load i32* %lsense28, align 4
  %cmp48 = icmp eq i32 %42, 1
  br i1 %cmp48, label %if.then56, label %lor.lhs.false50

lor.lhs.false50:                                  ; preds = %land.lhs.true47, %if.then44
  %43 = load i32* %newcount37, align 4
  %cmp51 = icmp eq i32 %43, 0
  br i1 %cmp51, label %land.lhs.true53, label %if.end60

land.lhs.true53:                                  ; preds = %lor.lhs.false50
  %44 = load i32* %lsense28, align 4
  %cmp54 = icmp eq i32 %44, -1
  br i1 %cmp54, label %if.then56, label %if.end60

if.then56:                                        ; preds = %land.lhs.true53, %land.lhs.true47
  %45 = load i32* %lsense28, align 4
  %sub57 = sub nsw i32 0, %45
  %46 = load %struct.GlobalMemory** @Global, align 8
  %start58 = getelementptr inbounds %struct.GlobalMemory* %46, i32 0, i32 10
  %gsense59 = getelementptr inbounds %struct.barrier_t* %start58, i32 0, i32 0
  store volatile i32 %sub57, i32* %gsense59, align 4
  call void @Criteria(i32 2)
  br label %if.end60

if.end60:                                         ; preds = %if.then56, %land.lhs.true53, %lor.lhs.false50
  br label %while.end62

if.end61:                                         ; preds = %while.body32
  br label %while.body32

while.end62:                                      ; preds = %if.end60
  br label %while.cond63

while.cond63:                                     ; preds = %while.body68, %while.end62
  %47 = load %struct.GlobalMemory** @Global, align 8
  %start64 = getelementptr inbounds %struct.GlobalMemory* %47, i32 0, i32 10
  %gsense65 = getelementptr inbounds %struct.barrier_t* %start64, i32 0, i32 0
  %48 = load volatile i32* %gsense65, align 4
  %49 = load i32* %lsense28, align 4
  %cmp66 = icmp eq i32 %48, %49
  br i1 %cmp66, label %while.body68, label %while.end69

while.body68:                                     ; preds = %while.cond63
  br label %while.cond63

while.end69:                                      ; preds = %while.cond63
  call void @Criteria(i32 2)
  %50 = load i32* %MyNum.addr, align 4
  %cmp70 = icmp eq i32 %50, 0
  br i1 %cmp70, label %if.then73, label %lor.lhs.false72

lor.lhs.false72:                                  ; preds = %while.end69
  %51 = load i32* %dostats.addr, align 4
  %tobool = icmp ne i32 %51, 0
  br i1 %tobool, label %if.then73, label %if.end76

if.then73:                                        ; preds = %lor.lhs.false72, %while.end69
  %call74 = call i64 @time(i64* null)
  %conv75 = trunc i64 %call74 to i32
  store i32 %conv75, i32* %myrs, align 4
  br label %if.end76

if.end76:                                         ; preds = %if.then73, %lor.lhs.false72
  %52 = load i32* %n.addr, align 4
  %53 = load i32* %block_size.addr, align 4
  %54 = load i32* %MyNum.addr, align 4
  %55 = load %struct.LocalCopies** %lc, align 8
  %56 = load i32* %dostats.addr, align 4
  call void @lu(i32 %52, i32 %53, i32 %54, %struct.LocalCopies* %55, i32 %56)
  %57 = load i32* %MyNum.addr, align 4
  %cmp77 = icmp eq i32 %57, 0
  br i1 %cmp77, label %if.then81, label %lor.lhs.false79

lor.lhs.false79:                                  ; preds = %if.end76
  %58 = load i32* %dostats.addr, align 4
  %tobool80 = icmp ne i32 %58, 0
  br i1 %tobool80, label %if.then81, label %if.end84

if.then81:                                        ; preds = %lor.lhs.false79, %if.end76
  %call82 = call i64 @time(i64* null)
  %conv83 = trunc i64 %call82 to i32
  store i32 %conv83, i32* %mydone, align 4
  br label %if.end84

if.end84:                                         ; preds = %if.then81, %lor.lhs.false79
  %59 = load %struct.GlobalMemory** @Global, align 8
  %start86 = getelementptr inbounds %struct.GlobalMemory* %59, i32 0, i32 10
  %gsense87 = getelementptr inbounds %struct.barrier_t* %start86, i32 0, i32 0
  %60 = load volatile i32* %gsense87, align 4
  store i32 %60, i32* %lsense85, align 4
  br label %while.body89

while.body89:                                     ; preds = %if.end118, %if.end84
  %61 = load %struct.GlobalMemory** @Global, align 8
  %start91 = getelementptr inbounds %struct.GlobalMemory* %61, i32 0, i32 10
  %count92 = getelementptr inbounds %struct.barrier_t* %start91, i32 0, i32 1
  %62 = load volatile i64* %count92, align 8
  %conv93 = trunc i64 %62 to i32
  store i32 %conv93, i32* %oldcount90, align 4
  %63 = load i32* %oldcount90, align 4
  %64 = load i32* %lsense85, align 4
  %add95 = add nsw i32 %63, %64
  store i32 %add95, i32* %newcount94, align 4
  %65 = load i32* %oldcount90, align 4
  %66 = load i32* %newcount94, align 4
  %call98 = call i32 @atomic_cmpxchg(i32 %65, i32 %66)
  store i32 %call98, i32* %updatedcount96, align 4
  %67 = load i32* %updatedcount96, align 4
  %68 = load i32* %oldcount90, align 4
  %cmp99 = icmp eq i32 %67, %68
  br i1 %cmp99, label %if.then101, label %if.end118

if.then101:                                       ; preds = %while.body89
  %69 = load i32* %newcount94, align 4
  %70 = load i32* @P, align 4
  %cmp102 = icmp eq i32 %69, %70
  br i1 %cmp102, label %land.lhs.true104, label %lor.lhs.false107

land.lhs.true104:                                 ; preds = %if.then101
  %71 = load i32* %lsense85, align 4
  %cmp105 = icmp eq i32 %71, 1
  br i1 %cmp105, label %if.then113, label %lor.lhs.false107

lor.lhs.false107:                                 ; preds = %land.lhs.true104, %if.then101
  %72 = load i32* %newcount94, align 4
  %cmp108 = icmp eq i32 %72, 0
  br i1 %cmp108, label %land.lhs.true110, label %if.end117

land.lhs.true110:                                 ; preds = %lor.lhs.false107
  %73 = load i32* %lsense85, align 4
  %cmp111 = icmp eq i32 %73, -1
  br i1 %cmp111, label %if.then113, label %if.end117

if.then113:                                       ; preds = %land.lhs.true110, %land.lhs.true104
  %74 = load i32* %lsense85, align 4
  %sub114 = sub nsw i32 0, %74
  %75 = load %struct.GlobalMemory** @Global, align 8
  %start115 = getelementptr inbounds %struct.GlobalMemory* %75, i32 0, i32 10
  %gsense116 = getelementptr inbounds %struct.barrier_t* %start115, i32 0, i32 0
  store volatile i32 %sub114, i32* %gsense116, align 4
  call void @Criteria(i32 3)
  br label %if.end117

if.end117:                                        ; preds = %if.then113, %land.lhs.true110, %lor.lhs.false107
  br label %while.end119

if.end118:                                        ; preds = %while.body89
  br label %while.body89

while.end119:                                     ; preds = %if.end117
  br label %while.cond120

while.cond120:                                    ; preds = %while.body125, %while.end119
  %76 = load %struct.GlobalMemory** @Global, align 8
  %start121 = getelementptr inbounds %struct.GlobalMemory* %76, i32 0, i32 10
  %gsense122 = getelementptr inbounds %struct.barrier_t* %start121, i32 0, i32 0
  %77 = load volatile i32* %gsense122, align 4
  %78 = load i32* %lsense85, align 4
  %cmp123 = icmp eq i32 %77, %78
  br i1 %cmp123, label %while.body125, label %while.end126

while.body125:                                    ; preds = %while.cond120
  br label %while.cond120

while.end126:                                     ; preds = %while.cond120
  call void @Criteria(i32 3)
  %79 = load i32* %MyNum.addr, align 4
  %cmp127 = icmp eq i32 %79, 0
  br i1 %cmp127, label %if.then131, label %lor.lhs.false129

lor.lhs.false129:                                 ; preds = %while.end126
  %80 = load i32* %dostats.addr, align 4
  %tobool130 = icmp ne i32 %80, 0
  br i1 %tobool130, label %if.then131, label %if.end150

if.then131:                                       ; preds = %lor.lhs.false129, %while.end126
  %81 = load %struct.LocalCopies** %lc, align 8
  %t_in_fac132 = getelementptr inbounds %struct.LocalCopies* %81, i32 0, i32 0
  %82 = load double* %t_in_fac132, align 8
  %83 = load i32* %MyNum.addr, align 4
  %idxprom = sext i32 %83 to i64
  %84 = load %struct.GlobalMemory** @Global, align 8
  %t_in_fac133 = getelementptr inbounds %struct.GlobalMemory* %84, i32 0, i32 0
  %85 = load double** %t_in_fac133, align 8
  %arrayidx = getelementptr inbounds double* %85, i64 %idxprom
  store double %82, double* %arrayidx, align 8
  %86 = load %struct.LocalCopies** %lc, align 8
  %t_in_solve134 = getelementptr inbounds %struct.LocalCopies* %86, i32 0, i32 1
  %87 = load double* %t_in_solve134, align 8
  %88 = load i32* %MyNum.addr, align 4
  %idxprom135 = sext i32 %88 to i64
  %89 = load %struct.GlobalMemory** @Global, align 8
  %t_in_solve136 = getelementptr inbounds %struct.GlobalMemory* %89, i32 0, i32 1
  %90 = load double** %t_in_solve136, align 8
  %arrayidx137 = getelementptr inbounds double* %90, i64 %idxprom135
  store double %87, double* %arrayidx137, align 8
  %91 = load %struct.LocalCopies** %lc, align 8
  %t_in_mod138 = getelementptr inbounds %struct.LocalCopies* %91, i32 0, i32 2
  %92 = load double* %t_in_mod138, align 8
  %93 = load i32* %MyNum.addr, align 4
  %idxprom139 = sext i32 %93 to i64
  %94 = load %struct.GlobalMemory** @Global, align 8
  %t_in_mod140 = getelementptr inbounds %struct.GlobalMemory* %94, i32 0, i32 2
  %95 = load double** %t_in_mod140, align 8
  %arrayidx141 = getelementptr inbounds double* %95, i64 %idxprom139
  store double %92, double* %arrayidx141, align 8
  %96 = load %struct.LocalCopies** %lc, align 8
  %t_in_bar142 = getelementptr inbounds %struct.LocalCopies* %96, i32 0, i32 3
  %97 = load double* %t_in_bar142, align 8
  %98 = load i32* %MyNum.addr, align 4
  %idxprom143 = sext i32 %98 to i64
  %99 = load %struct.GlobalMemory** @Global, align 8
  %t_in_bar144 = getelementptr inbounds %struct.GlobalMemory* %99, i32 0, i32 3
  %100 = load double** %t_in_bar144, align 8
  %arrayidx145 = getelementptr inbounds double* %100, i64 %idxprom143
  store double %97, double* %arrayidx145, align 8
  %101 = load i32* %mydone, align 4
  %102 = load i32* %myrs, align 4
  %sub146 = sub i32 %101, %102
  %conv147 = uitofp i32 %sub146 to double
  %103 = load i32* %MyNum.addr, align 4
  %idxprom148 = sext i32 %103 to i64
  %104 = load %struct.GlobalMemory** @Global, align 8
  %completion = getelementptr inbounds %struct.GlobalMemory* %104, i32 0, i32 4
  %105 = load double** %completion, align 8
  %arrayidx149 = getelementptr inbounds double* %105, i64 %idxprom148
  store double %conv147, double* %arrayidx149, align 8
  br label %if.end150

if.end150:                                        ; preds = %if.then131, %lor.lhs.false129
  %106 = load i32* %MyNum.addr, align 4
  %cmp151 = icmp eq i32 %106, 0
  br i1 %cmp151, label %if.then153, label %if.end156

if.then153:                                       ; preds = %if.end150
  %call154 = call i64 @time(i64* null)
  %conv155 = trunc i64 %call154 to i32
  store i32 %conv155, i32* %myrf, align 4
  %107 = load i32* %myrs, align 4
  %108 = load %struct.GlobalMemory** @Global, align 8
  %rs = getelementptr inbounds %struct.GlobalMemory* %108, i32 0, i32 7
  store i32 %107, i32* %rs, align 4
  %109 = load i32* %mydone, align 4
  %110 = load %struct.GlobalMemory** @Global, align 8
  %done = getelementptr inbounds %struct.GlobalMemory* %110, i32 0, i32 8
  store i32 %109, i32* %done, align 4
  %111 = load i32* %myrf, align 4
  %112 = load %struct.GlobalMemory** @Global, align 8
  %rf = getelementptr inbounds %struct.GlobalMemory* %112, i32 0, i32 6
  store i32 %111, i32* %rf, align 4
  br label %if.end156

if.end156:                                        ; preds = %if.then153, %if.end150
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
  store i32 %bs, i32* %bs.addr, align 4
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store double 0.000000e+00, double* %tot, align 8
  store i32 0, i32* %J, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc37, %entry
  %0 = load i32* %J, align 4
  %1 = load i32* @nblocks, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end39

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %I, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc34, %for.body
  %2 = load i32* %I, align 4
  %3 = load i32* @nblocks, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body3, label %for.end36

for.body3:                                        ; preds = %for.cond1
  %4 = load i32* %I, align 4
  %5 = load i32* %J, align 4
  %call = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %4, i32 %5)
  %6 = load i32* %MyNum.addr, align 4
  %cmp4 = icmp eq i32 %call, %6
  br i1 %cmp4, label %if.then, label %if.end33

if.then:                                          ; preds = %for.body3
  %7 = load i32* %J, align 4
  %8 = load i32* @nblocks, align 4
  %sub = sub nsw i32 %8, 1
  %cmp5 = icmp eq i32 %7, %sub
  br i1 %cmp5, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.then
  %9 = load i32* @n, align 4
  %10 = load i32* %bs.addr, align 4
  %rem = srem i32 %9, %10
  store i32 %rem, i32* %jbs, align 4
  %11 = load i32* %jbs, align 4
  %cmp7 = icmp eq i32 %11, 0
  br i1 %cmp7, label %if.then8, label %if.end

if.then8:                                         ; preds = %if.then6
  %12 = load i32* %bs.addr, align 4
  store i32 %12, i32* %jbs, align 4
  br label %if.end

if.end:                                           ; preds = %if.then8, %if.then6
  br label %if.end9

if.else:                                          ; preds = %if.then
  %13 = load i32* %bs.addr, align 4
  store i32 %13, i32* %jbs, align 4
  br label %if.end9

if.end9:                                          ; preds = %if.else, %if.end
  %14 = load i32* %I, align 4
  %15 = load i32* @nblocks, align 4
  %sub10 = sub nsw i32 %15, 1
  %cmp11 = icmp eq i32 %14, %sub10
  br i1 %cmp11, label %if.then12, label %if.else17

if.then12:                                        ; preds = %if.end9
  %16 = load i32* @n, align 4
  %17 = load i32* %bs.addr, align 4
  %rem13 = srem i32 %16, %17
  store i32 %rem13, i32* %ibs, align 4
  %18 = load i32* %ibs, align 4
  %cmp14 = icmp eq i32 %18, 0
  br i1 %cmp14, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.then12
  %19 = load i32* %bs.addr, align 4
  store i32 %19, i32* %ibs, align 4
  br label %if.end16

if.end16:                                         ; preds = %if.then15, %if.then12
  br label %if.end18

if.else17:                                        ; preds = %if.end9
  %20 = load i32* %bs.addr, align 4
  store i32 %20, i32* %ibs, align 4
  br label %if.end18

if.end18:                                         ; preds = %if.else17, %if.end16
  store i32 0, i32* %j, align 4
  br label %for.cond19

for.cond19:                                       ; preds = %for.inc30, %if.end18
  %21 = load i32* %j, align 4
  %22 = load i32* %jbs, align 4
  %cmp20 = icmp slt i32 %21, %22
  br i1 %cmp20, label %for.body21, label %for.end32

for.body21:                                       ; preds = %for.cond19
  store i32 0, i32* %i, align 4
  br label %for.cond22

for.cond22:                                       ; preds = %for.inc, %for.body21
  %23 = load i32* %i, align 4
  %24 = load i32* %ibs, align 4
  %cmp23 = icmp slt i32 %23, %24
  br i1 %cmp23, label %for.body24, label %for.end

for.body24:                                       ; preds = %for.cond22
  %25 = load i32* %i, align 4
  %26 = load i32* %j, align 4
  %27 = load i32* %ibs, align 4
  %mul = mul nsw i32 %26, %27
  %add = add nsw i32 %25, %mul
  %idxprom = sext i32 %add to i64
  %28 = load i32* %I, align 4
  %29 = load i32* %J, align 4
  %30 = load i32* @nblocks, align 4
  %mul25 = mul nsw i32 %29, %30
  %add26 = add nsw i32 %28, %mul25
  %idxprom27 = sext i32 %add26 to i64
  %31 = load double*** @a, align 8
  %arrayidx = getelementptr inbounds double** %31, i64 %idxprom27
  %32 = load double** %arrayidx, align 8
  %arrayidx28 = getelementptr inbounds double* %32, i64 %idxprom
  %33 = load double* %arrayidx28, align 8
  %34 = load double* %tot, align 8
  %add29 = fadd double %34, %33
  store double %add29, double* %tot, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body24
  %35 = load i32* %i, align 4
  %inc = add nsw i32 %35, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond22

for.end:                                          ; preds = %for.cond22
  br label %for.inc30

for.inc30:                                        ; preds = %for.end
  %36 = load i32* %j, align 4
  %inc31 = add nsw i32 %36, 1
  store i32 %inc31, i32* %j, align 4
  br label %for.cond19

for.end32:                                        ; preds = %for.cond19
  br label %if.end33

if.end33:                                         ; preds = %for.end32, %for.body3
  br label %for.inc34

for.inc34:                                        ; preds = %if.end33
  %37 = load i32* %I, align 4
  %inc35 = add nsw i32 %37, 1
  store i32 %inc35, i32* %I, align 4
  br label %for.cond1

for.end36:                                        ; preds = %for.cond1
  br label %for.inc37

for.inc37:                                        ; preds = %for.end36
  %38 = load i32* %J, align 4
  %inc38 = add nsw i32 %38, 1
  store i32 %inc38, i32* %J, align 4
  br label %for.cond

for.end39:                                        ; preds = %for.cond
  %39 = load double* %tot, align 8
  ret double %39
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
  store %struct.LocalCopies* %lc, %struct.LocalCopies** %lc.addr, align 8
  store i32 %dostats, i32* %dostats.addr, align 4
  store i32 0, i32* %k, align 4
  store i32 0, i32* %K, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc237, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end240

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
  %10 = load i32* %MyNum.addr, align 4
  %cmp2 = icmp eq i32 %10, 0
  br i1 %cmp2, label %if.then3, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end
  %11 = load i32* %dostats.addr, align 4
  %tobool = icmp ne i32 %11, 0
  br i1 %tobool, label %if.then3, label %if.end4

if.then3:                                         ; preds = %lor.lhs.false, %if.end
  %call = call i64 @time(i64* null)
  %conv = trunc i64 %call to i32
  store i32 %conv, i32* %t1, align 4
  br label %if.end4

if.end4:                                          ; preds = %if.then3, %lor.lhs.false
  %12 = load i32* %K, align 4
  %13 = load i32* %K, align 4
  %call5 = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %12, i32 %13)
  store i32 %call5, i32* %diagowner, align 4
  %14 = load i32* %diagowner, align 4
  %15 = load i32* %MyNum.addr, align 4
  %cmp6 = icmp eq i32 %14, %15
  br i1 %cmp6, label %if.then8, label %if.end10

if.then8:                                         ; preds = %if.end4
  %16 = load i32* %K, align 4
  %17 = load i32* %K, align 4
  %18 = load i32* @nblocks, align 4
  %mul = mul nsw i32 %17, %18
  %add9 = add nsw i32 %16, %mul
  %idxprom = sext i32 %add9 to i64
  %19 = load double*** @a, align 8
  %arrayidx = getelementptr inbounds double** %19, i64 %idxprom
  %20 = load double** %arrayidx, align 8
  store double* %20, double** %A, align 8
  %21 = load double** %A, align 8
  %22 = load i32* %strK, align 4
  %23 = load i32* %strK, align 4
  call void (...) *bitcast (void (double*, i32, i32)* @lu0 to void (...)*)(double* %21, i32 %22, i32 %23)
  br label %if.end10

if.end10:                                         ; preds = %if.then8, %if.end4
  %24 = load i32* %MyNum.addr, align 4
  %cmp11 = icmp eq i32 %24, 0
  br i1 %cmp11, label %if.then15, label %lor.lhs.false13

lor.lhs.false13:                                  ; preds = %if.end10
  %25 = load i32* %dostats.addr, align 4
  %tobool14 = icmp ne i32 %25, 0
  br i1 %tobool14, label %if.then15, label %if.end18

if.then15:                                        ; preds = %lor.lhs.false13, %if.end10
  %call16 = call i64 @time(i64* null)
  %conv17 = trunc i64 %call16 to i32
  store i32 %conv17, i32* %t11, align 4
  br label %if.end18

if.end18:                                         ; preds = %if.then15, %lor.lhs.false13
  %26 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %26, i32 0, i32 10
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  %27 = load volatile i32* %gsense, align 4
  store i32 %27, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end41, %if.end18
  %28 = load %struct.GlobalMemory** @Global, align 8
  %start19 = getelementptr inbounds %struct.GlobalMemory* %28, i32 0, i32 10
  %count = getelementptr inbounds %struct.barrier_t* %start19, i32 0, i32 1
  %29 = load volatile i64* %count, align 8
  %conv20 = trunc i64 %29 to i32
  store i32 %conv20, i32* %oldcount, align 4
  %30 = load i32* %oldcount, align 4
  %31 = load i32* %lsense, align 4
  %add21 = add nsw i32 %30, %31
  store i32 %add21, i32* %newcount, align 4
  %32 = load i32* %oldcount, align 4
  %33 = load i32* %newcount, align 4
  %call22 = call i32 @atomic_cmpxchg(i32 %32, i32 %33)
  store i32 %call22, i32* %updatedcount, align 4
  %34 = load i32* %updatedcount, align 4
  %35 = load i32* %oldcount, align 4
  %cmp23 = icmp eq i32 %34, %35
  br i1 %cmp23, label %if.then25, label %if.end41

if.then25:                                        ; preds = %while.body
  %36 = load i32* %newcount, align 4
  %37 = load i32* @P, align 4
  %cmp26 = icmp eq i32 %36, %37
  br i1 %cmp26, label %land.lhs.true, label %lor.lhs.false30

land.lhs.true:                                    ; preds = %if.then25
  %38 = load i32* %lsense, align 4
  %cmp28 = icmp eq i32 %38, 1
  br i1 %cmp28, label %if.then36, label %lor.lhs.false30

lor.lhs.false30:                                  ; preds = %land.lhs.true, %if.then25
  %39 = load i32* %newcount, align 4
  %cmp31 = icmp eq i32 %39, 0
  br i1 %cmp31, label %land.lhs.true33, label %if.end40

land.lhs.true33:                                  ; preds = %lor.lhs.false30
  %40 = load i32* %lsense, align 4
  %cmp34 = icmp eq i32 %40, -1
  br i1 %cmp34, label %if.then36, label %if.end40

if.then36:                                        ; preds = %land.lhs.true33, %land.lhs.true
  %41 = load i32* %lsense, align 4
  %sub37 = sub nsw i32 0, %41
  %42 = load %struct.GlobalMemory** @Global, align 8
  %start38 = getelementptr inbounds %struct.GlobalMemory* %42, i32 0, i32 10
  %gsense39 = getelementptr inbounds %struct.barrier_t* %start38, i32 0, i32 0
  store volatile i32 %sub37, i32* %gsense39, align 4
  call void @Criteria(i32 4)
  br label %if.end40

if.end40:                                         ; preds = %if.then36, %land.lhs.true33, %lor.lhs.false30
  br label %while.end

if.end41:                                         ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end40
  br label %while.cond

while.cond:                                       ; preds = %while.body46, %while.end
  %43 = load %struct.GlobalMemory** @Global, align 8
  %start42 = getelementptr inbounds %struct.GlobalMemory* %43, i32 0, i32 10
  %gsense43 = getelementptr inbounds %struct.barrier_t* %start42, i32 0, i32 0
  %44 = load volatile i32* %gsense43, align 4
  %45 = load i32* %lsense, align 4
  %cmp44 = icmp eq i32 %44, %45
  br i1 %cmp44, label %while.body46, label %while.end47

while.body46:                                     ; preds = %while.cond
  br label %while.cond

while.end47:                                      ; preds = %while.cond
  call void @Criteria(i32 4)
  %46 = load i32* %MyNum.addr, align 4
  %cmp48 = icmp eq i32 %46, 0
  br i1 %cmp48, label %if.then52, label %lor.lhs.false50

lor.lhs.false50:                                  ; preds = %while.end47
  %47 = load i32* %dostats.addr, align 4
  %tobool51 = icmp ne i32 %47, 0
  br i1 %tobool51, label %if.then52, label %if.end55

if.then52:                                        ; preds = %lor.lhs.false50, %while.end47
  %call53 = call i64 @time(i64* null)
  %conv54 = trunc i64 %call53 to i32
  store i32 %conv54, i32* %t2, align 4
  br label %if.end55

if.end55:                                         ; preds = %if.then52, %lor.lhs.false50
  %48 = load i32* %K, align 4
  %49 = load i32* %K, align 4
  %50 = load i32* @nblocks, align 4
  %mul56 = mul nsw i32 %49, %50
  %add57 = add nsw i32 %48, %mul56
  %idxprom58 = sext i32 %add57 to i64
  %51 = load double*** @a, align 8
  %arrayidx59 = getelementptr inbounds double** %51, i64 %idxprom58
  %52 = load double** %arrayidx59, align 8
  store double* %52, double** %D, align 8
  %53 = load i32* %kl, align 4
  store i32 %53, i32* %i, align 4
  %54 = load i32* %K, align 4
  %add60 = add nsw i32 %54, 1
  store i32 %add60, i32* %I, align 4
  br label %for.cond61

for.cond61:                                       ; preds = %for.inc, %if.end55
  %55 = load i32* %i, align 4
  %56 = load i32* %n.addr, align 4
  %cmp62 = icmp slt i32 %55, %56
  br i1 %cmp62, label %for.body64, label %for.end

for.body64:                                       ; preds = %for.cond61
  %57 = load i32* %I, align 4
  %58 = load i32* %K, align 4
  %call65 = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %57, i32 %58)
  %59 = load i32* %MyNum.addr, align 4
  %cmp66 = icmp eq i32 %call65, %59
  br i1 %cmp66, label %if.then68, label %if.end80

if.then68:                                        ; preds = %for.body64
  %60 = load i32* %i, align 4
  %61 = load i32* %bs.addr, align 4
  %add69 = add nsw i32 %60, %61
  store i32 %add69, i32* %il, align 4
  %62 = load i32* %il, align 4
  %63 = load i32* %n.addr, align 4
  %cmp70 = icmp sgt i32 %62, %63
  br i1 %cmp70, label %if.then72, label %if.else74

if.then72:                                        ; preds = %if.then68
  %64 = load i32* %n.addr, align 4
  store i32 %64, i32* %il, align 4
  %65 = load i32* %il, align 4
  %66 = load i32* %i, align 4
  %sub73 = sub nsw i32 %65, %66
  store i32 %sub73, i32* %strI, align 4
  br label %if.end75

if.else74:                                        ; preds = %if.then68
  %67 = load i32* %bs.addr, align 4
  store i32 %67, i32* %strI, align 4
  br label %if.end75

if.end75:                                         ; preds = %if.else74, %if.then72
  %68 = load i32* %I, align 4
  %69 = load i32* %K, align 4
  %70 = load i32* @nblocks, align 4
  %mul76 = mul nsw i32 %69, %70
  %add77 = add nsw i32 %68, %mul76
  %idxprom78 = sext i32 %add77 to i64
  %71 = load double*** @a, align 8
  %arrayidx79 = getelementptr inbounds double** %71, i64 %idxprom78
  %72 = load double** %arrayidx79, align 8
  store double* %72, double** %A, align 8
  %73 = load double** %A, align 8
  %74 = load double** %D, align 8
  %75 = load i32* %strI, align 4
  %76 = load i32* %strK, align 4
  %77 = load i32* %strI, align 4
  %78 = load i32* %strK, align 4
  call void (...) *bitcast (void (double*, double*, i32, i32, i32, i32)* @bdiv to void (...)*)(double* %73, double* %74, i32 %75, i32 %76, i32 %77, i32 %78)
  br label %if.end80

if.end80:                                         ; preds = %if.end75, %for.body64
  br label %for.inc

for.inc:                                          ; preds = %if.end80
  %79 = load i32* %bs.addr, align 4
  %80 = load i32* %i, align 4
  %add81 = add nsw i32 %80, %79
  store i32 %add81, i32* %i, align 4
  %81 = load i32* %I, align 4
  %inc = add nsw i32 %81, 1
  store i32 %inc, i32* %I, align 4
  br label %for.cond61

for.end:                                          ; preds = %for.cond61
  %82 = load i32* %kl, align 4
  store i32 %82, i32* %j, align 4
  %83 = load i32* %K, align 4
  %add82 = add nsw i32 %83, 1
  store i32 %add82, i32* %J, align 4
  br label %for.cond83

for.cond83:                                       ; preds = %for.inc103, %for.end
  %84 = load i32* %j, align 4
  %85 = load i32* %n.addr, align 4
  %cmp84 = icmp slt i32 %84, %85
  br i1 %cmp84, label %for.body86, label %for.end106

for.body86:                                       ; preds = %for.cond83
  %86 = load i32* %K, align 4
  %87 = load i32* %J, align 4
  %call87 = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %86, i32 %87)
  %88 = load i32* %MyNum.addr, align 4
  %cmp88 = icmp eq i32 %call87, %88
  br i1 %cmp88, label %if.then90, label %if.end102

if.then90:                                        ; preds = %for.body86
  %89 = load i32* %j, align 4
  %90 = load i32* %bs.addr, align 4
  %add91 = add nsw i32 %89, %90
  store i32 %add91, i32* %jl, align 4
  %91 = load i32* %jl, align 4
  %92 = load i32* %n.addr, align 4
  %cmp92 = icmp sgt i32 %91, %92
  br i1 %cmp92, label %if.then94, label %if.else96

if.then94:                                        ; preds = %if.then90
  %93 = load i32* %n.addr, align 4
  store i32 %93, i32* %jl, align 4
  %94 = load i32* %jl, align 4
  %95 = load i32* %j, align 4
  %sub95 = sub nsw i32 %94, %95
  store i32 %sub95, i32* %strJ, align 4
  br label %if.end97

if.else96:                                        ; preds = %if.then90
  %96 = load i32* %bs.addr, align 4
  store i32 %96, i32* %strJ, align 4
  br label %if.end97

if.end97:                                         ; preds = %if.else96, %if.then94
  %97 = load i32* %K, align 4
  %98 = load i32* %J, align 4
  %99 = load i32* @nblocks, align 4
  %mul98 = mul nsw i32 %98, %99
  %add99 = add nsw i32 %97, %mul98
  %idxprom100 = sext i32 %add99 to i64
  %100 = load double*** @a, align 8
  %arrayidx101 = getelementptr inbounds double** %100, i64 %idxprom100
  %101 = load double** %arrayidx101, align 8
  store double* %101, double** %A, align 8
  %102 = load double** %D, align 8
  %103 = load double** %A, align 8
  %104 = load i32* %strK, align 4
  %105 = load i32* %strJ, align 4
  %106 = load i32* %strK, align 4
  %107 = load i32* %strK, align 4
  call void (...) *bitcast (void (double*, double*, i32, i32, i32, i32)* @bmodd to void (...)*)(double* %102, double* %103, i32 %104, i32 %105, i32 %106, i32 %107)
  br label %if.end102

if.end102:                                        ; preds = %if.end97, %for.body86
  br label %for.inc103

for.inc103:                                       ; preds = %if.end102
  %108 = load i32* %bs.addr, align 4
  %109 = load i32* %j, align 4
  %add104 = add nsw i32 %109, %108
  store i32 %add104, i32* %j, align 4
  %110 = load i32* %J, align 4
  %inc105 = add nsw i32 %110, 1
  store i32 %inc105, i32* %J, align 4
  br label %for.cond83

for.end106:                                       ; preds = %for.cond83
  %111 = load i32* %MyNum.addr, align 4
  %cmp107 = icmp eq i32 %111, 0
  br i1 %cmp107, label %if.then111, label %lor.lhs.false109

lor.lhs.false109:                                 ; preds = %for.end106
  %112 = load i32* %dostats.addr, align 4
  %tobool110 = icmp ne i32 %112, 0
  br i1 %tobool110, label %if.then111, label %if.end114

if.then111:                                       ; preds = %lor.lhs.false109, %for.end106
  %call112 = call i64 @time(i64* null)
  %conv113 = trunc i64 %call112 to i32
  store i32 %conv113, i32* %t22, align 4
  br label %if.end114

if.end114:                                        ; preds = %if.then111, %lor.lhs.false109
  %113 = load %struct.GlobalMemory** @Global, align 8
  %start116 = getelementptr inbounds %struct.GlobalMemory* %113, i32 0, i32 10
  %gsense117 = getelementptr inbounds %struct.barrier_t* %start116, i32 0, i32 0
  %114 = load volatile i32* %gsense117, align 4
  store i32 %114, i32* %lsense115, align 4
  br label %while.body119

while.body119:                                    ; preds = %if.end148, %if.end114
  %115 = load %struct.GlobalMemory** @Global, align 8
  %start121 = getelementptr inbounds %struct.GlobalMemory* %115, i32 0, i32 10
  %count122 = getelementptr inbounds %struct.barrier_t* %start121, i32 0, i32 1
  %116 = load volatile i64* %count122, align 8
  %conv123 = trunc i64 %116 to i32
  store i32 %conv123, i32* %oldcount120, align 4
  %117 = load i32* %oldcount120, align 4
  %118 = load i32* %lsense115, align 4
  %add125 = add nsw i32 %117, %118
  store i32 %add125, i32* %newcount124, align 4
  %119 = load i32* %oldcount120, align 4
  %120 = load i32* %newcount124, align 4
  %call128 = call i32 @atomic_cmpxchg(i32 %119, i32 %120)
  store i32 %call128, i32* %updatedcount126, align 4
  %121 = load i32* %updatedcount126, align 4
  %122 = load i32* %oldcount120, align 4
  %cmp129 = icmp eq i32 %121, %122
  br i1 %cmp129, label %if.then131, label %if.end148

if.then131:                                       ; preds = %while.body119
  %123 = load i32* %newcount124, align 4
  %124 = load i32* @P, align 4
  %cmp132 = icmp eq i32 %123, %124
  br i1 %cmp132, label %land.lhs.true134, label %lor.lhs.false137

land.lhs.true134:                                 ; preds = %if.then131
  %125 = load i32* %lsense115, align 4
  %cmp135 = icmp eq i32 %125, 1
  br i1 %cmp135, label %if.then143, label %lor.lhs.false137

lor.lhs.false137:                                 ; preds = %land.lhs.true134, %if.then131
  %126 = load i32* %newcount124, align 4
  %cmp138 = icmp eq i32 %126, 0
  br i1 %cmp138, label %land.lhs.true140, label %if.end147

land.lhs.true140:                                 ; preds = %lor.lhs.false137
  %127 = load i32* %lsense115, align 4
  %cmp141 = icmp eq i32 %127, -1
  br i1 %cmp141, label %if.then143, label %if.end147

if.then143:                                       ; preds = %land.lhs.true140, %land.lhs.true134
  %128 = load i32* %lsense115, align 4
  %sub144 = sub nsw i32 0, %128
  %129 = load %struct.GlobalMemory** @Global, align 8
  %start145 = getelementptr inbounds %struct.GlobalMemory* %129, i32 0, i32 10
  %gsense146 = getelementptr inbounds %struct.barrier_t* %start145, i32 0, i32 0
  store volatile i32 %sub144, i32* %gsense146, align 4
  call void @Criteria(i32 5)
  br label %if.end147

if.end147:                                        ; preds = %if.then143, %land.lhs.true140, %lor.lhs.false137
  br label %while.end149

if.end148:                                        ; preds = %while.body119
  br label %while.body119

while.end149:                                     ; preds = %if.end147
  br label %while.cond150

while.cond150:                                    ; preds = %while.body155, %while.end149
  %130 = load %struct.GlobalMemory** @Global, align 8
  %start151 = getelementptr inbounds %struct.GlobalMemory* %130, i32 0, i32 10
  %gsense152 = getelementptr inbounds %struct.barrier_t* %start151, i32 0, i32 0
  %131 = load volatile i32* %gsense152, align 4
  %132 = load i32* %lsense115, align 4
  %cmp153 = icmp eq i32 %131, %132
  br i1 %cmp153, label %while.body155, label %while.end156

while.body155:                                    ; preds = %while.cond150
  br label %while.cond150

while.end156:                                     ; preds = %while.cond150
  call void @Criteria(i32 5)
  %133 = load i32* %MyNum.addr, align 4
  %cmp157 = icmp eq i32 %133, 0
  br i1 %cmp157, label %if.then161, label %lor.lhs.false159

lor.lhs.false159:                                 ; preds = %while.end156
  %134 = load i32* %dostats.addr, align 4
  %tobool160 = icmp ne i32 %134, 0
  br i1 %tobool160, label %if.then161, label %if.end164

if.then161:                                       ; preds = %lor.lhs.false159, %while.end156
  %call162 = call i64 @time(i64* null)
  %conv163 = trunc i64 %call162 to i32
  store i32 %conv163, i32* %t3, align 4
  br label %if.end164

if.end164:                                        ; preds = %if.then161, %lor.lhs.false159
  %135 = load i32* %kl, align 4
  store i32 %135, i32* %i, align 4
  %136 = load i32* %K, align 4
  %add165 = add nsw i32 %136, 1
  store i32 %add165, i32* %I, align 4
  br label %for.cond166

for.cond166:                                      ; preds = %for.inc211, %if.end164
  %137 = load i32* %i, align 4
  %138 = load i32* %n.addr, align 4
  %cmp167 = icmp slt i32 %137, %138
  br i1 %cmp167, label %for.body169, label %for.end214

for.body169:                                      ; preds = %for.cond166
  %139 = load i32* %i, align 4
  %140 = load i32* %bs.addr, align 4
  %add170 = add nsw i32 %139, %140
  store i32 %add170, i32* %il, align 4
  %141 = load i32* %il, align 4
  %142 = load i32* %n.addr, align 4
  %cmp171 = icmp sgt i32 %141, %142
  br i1 %cmp171, label %if.then173, label %if.else175

if.then173:                                       ; preds = %for.body169
  %143 = load i32* %n.addr, align 4
  store i32 %143, i32* %il, align 4
  %144 = load i32* %il, align 4
  %145 = load i32* %i, align 4
  %sub174 = sub nsw i32 %144, %145
  store i32 %sub174, i32* %strI, align 4
  br label %if.end176

if.else175:                                       ; preds = %for.body169
  %146 = load i32* %bs.addr, align 4
  store i32 %146, i32* %strI, align 4
  br label %if.end176

if.end176:                                        ; preds = %if.else175, %if.then173
  %147 = load i32* %I, align 4
  %148 = load i32* %K, align 4
  %call177 = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %147, i32 %148)
  store i32 %call177, i32* %colowner, align 4
  %149 = load i32* %I, align 4
  %150 = load i32* %K, align 4
  %151 = load i32* @nblocks, align 4
  %mul178 = mul nsw i32 %150, %151
  %add179 = add nsw i32 %149, %mul178
  %idxprom180 = sext i32 %add179 to i64
  %152 = load double*** @a, align 8
  %arrayidx181 = getelementptr inbounds double** %152, i64 %idxprom180
  %153 = load double** %arrayidx181, align 8
  store double* %153, double** %A, align 8
  %154 = load i32* %kl, align 4
  store i32 %154, i32* %j, align 4
  %155 = load i32* %K, align 4
  %add182 = add nsw i32 %155, 1
  store i32 %add182, i32* %J, align 4
  br label %for.cond183

for.cond183:                                      ; preds = %for.inc207, %if.end176
  %156 = load i32* %j, align 4
  %157 = load i32* %n.addr, align 4
  %cmp184 = icmp slt i32 %156, %157
  br i1 %cmp184, label %for.body186, label %for.end210

for.body186:                                      ; preds = %for.cond183
  %158 = load i32* %j, align 4
  %159 = load i32* %bs.addr, align 4
  %add187 = add nsw i32 %158, %159
  store i32 %add187, i32* %jl, align 4
  %160 = load i32* %jl, align 4
  %161 = load i32* %n.addr, align 4
  %cmp188 = icmp sgt i32 %160, %161
  br i1 %cmp188, label %if.then190, label %if.else192

if.then190:                                       ; preds = %for.body186
  %162 = load i32* %n.addr, align 4
  store i32 %162, i32* %jl, align 4
  %163 = load i32* %jl, align 4
  %164 = load i32* %j, align 4
  %sub191 = sub nsw i32 %163, %164
  store i32 %sub191, i32* %strJ, align 4
  br label %if.end193

if.else192:                                       ; preds = %for.body186
  %165 = load i32* %bs.addr, align 4
  store i32 %165, i32* %strJ, align 4
  br label %if.end193

if.end193:                                        ; preds = %if.else192, %if.then190
  %166 = load i32* %I, align 4
  %167 = load i32* %J, align 4
  %call194 = call i32 (...) *bitcast (i32 (i32, i32)* @BlockOwner to i32 (...)*)(i32 %166, i32 %167)
  %168 = load i32* %MyNum.addr, align 4
  %cmp195 = icmp eq i32 %call194, %168
  br i1 %cmp195, label %if.then197, label %if.end206

if.then197:                                       ; preds = %if.end193
  %169 = load i32* %K, align 4
  %170 = load i32* %J, align 4
  %171 = load i32* @nblocks, align 4
  %mul198 = mul nsw i32 %170, %171
  %add199 = add nsw i32 %169, %mul198
  %idxprom200 = sext i32 %add199 to i64
  %172 = load double*** @a, align 8
  %arrayidx201 = getelementptr inbounds double** %172, i64 %idxprom200
  %173 = load double** %arrayidx201, align 8
  store double* %173, double** %B, align 8
  %174 = load i32* %I, align 4
  %175 = load i32* %J, align 4
  %176 = load i32* @nblocks, align 4
  %mul202 = mul nsw i32 %175, %176
  %add203 = add nsw i32 %174, %mul202
  %idxprom204 = sext i32 %add203 to i64
  %177 = load double*** @a, align 8
  %arrayidx205 = getelementptr inbounds double** %177, i64 %idxprom204
  %178 = load double** %arrayidx205, align 8
  store double* %178, double** %C, align 8
  %179 = load double** %A, align 8
  %180 = load double** %B, align 8
  %181 = load double** %C, align 8
  %182 = load i32* %strI, align 4
  %183 = load i32* %strJ, align 4
  %184 = load i32* %strK, align 4
  %185 = load i32* %strI, align 4
  %186 = load i32* %strK, align 4
  %187 = load i32* %strI, align 4
  call void (...) *bitcast (void (double*, double*, double*, i32, i32, i32, i32, i32, i32)* @bmod to void (...)*)(double* %179, double* %180, double* %181, i32 %182, i32 %183, i32 %184, i32 %185, i32 %186, i32 %187)
  br label %if.end206

if.end206:                                        ; preds = %if.then197, %if.end193
  br label %for.inc207

for.inc207:                                       ; preds = %if.end206
  %188 = load i32* %bs.addr, align 4
  %189 = load i32* %j, align 4
  %add208 = add nsw i32 %189, %188
  store i32 %add208, i32* %j, align 4
  %190 = load i32* %J, align 4
  %inc209 = add nsw i32 %190, 1
  store i32 %inc209, i32* %J, align 4
  br label %for.cond183

for.end210:                                       ; preds = %for.cond183
  br label %for.inc211

for.inc211:                                       ; preds = %for.end210
  %191 = load i32* %bs.addr, align 4
  %192 = load i32* %i, align 4
  %add212 = add nsw i32 %192, %191
  store i32 %add212, i32* %i, align 4
  %193 = load i32* %I, align 4
  %inc213 = add nsw i32 %193, 1
  store i32 %inc213, i32* %I, align 4
  br label %for.cond166

for.end214:                                       ; preds = %for.cond166
  %194 = load i32* %MyNum.addr, align 4
  %cmp215 = icmp eq i32 %194, 0
  br i1 %cmp215, label %if.then219, label %lor.lhs.false217

lor.lhs.false217:                                 ; preds = %for.end214
  %195 = load i32* %dostats.addr, align 4
  %tobool218 = icmp ne i32 %195, 0
  br i1 %tobool218, label %if.then219, label %if.end236

if.then219:                                       ; preds = %lor.lhs.false217, %for.end214
  %call220 = call i64 @time(i64* null)
  %conv221 = trunc i64 %call220 to i32
  store i32 %conv221, i32* %t4, align 4
  %196 = load i32* %t11, align 4
  %197 = load i32* %t1, align 4
  %sub222 = sub i32 %196, %197
  %conv223 = uitofp i32 %sub222 to double
  %198 = load %struct.LocalCopies** %lc.addr, align 8
  %t_in_fac = getelementptr inbounds %struct.LocalCopies* %198, i32 0, i32 0
  %199 = load double* %t_in_fac, align 8
  %add224 = fadd double %199, %conv223
  store double %add224, double* %t_in_fac, align 8
  %200 = load i32* %t22, align 4
  %201 = load i32* %t2, align 4
  %sub225 = sub i32 %200, %201
  %conv226 = uitofp i32 %sub225 to double
  %202 = load %struct.LocalCopies** %lc.addr, align 8
  %t_in_solve = getelementptr inbounds %struct.LocalCopies* %202, i32 0, i32 1
  %203 = load double* %t_in_solve, align 8
  %add227 = fadd double %203, %conv226
  store double %add227, double* %t_in_solve, align 8
  %204 = load i32* %t4, align 4
  %205 = load i32* %t3, align 4
  %sub228 = sub i32 %204, %205
  %conv229 = uitofp i32 %sub228 to double
  %206 = load %struct.LocalCopies** %lc.addr, align 8
  %t_in_mod = getelementptr inbounds %struct.LocalCopies* %206, i32 0, i32 2
  %207 = load double* %t_in_mod, align 8
  %add230 = fadd double %207, %conv229
  store double %add230, double* %t_in_mod, align 8
  %208 = load i32* %t2, align 4
  %209 = load i32* %t11, align 4
  %sub231 = sub i32 %208, %209
  %210 = load i32* %t3, align 4
  %211 = load i32* %t22, align 4
  %sub232 = sub i32 %210, %211
  %add233 = add i32 %sub231, %sub232
  %conv234 = uitofp i32 %add233 to double
  %212 = load %struct.LocalCopies** %lc.addr, align 8
  %t_in_bar = getelementptr inbounds %struct.LocalCopies* %212, i32 0, i32 3
  %213 = load double* %t_in_bar, align 8
  %add235 = fadd double %213, %conv234
  store double %add235, double* %t_in_bar, align 8
  br label %if.end236

if.end236:                                        ; preds = %if.then219, %lor.lhs.false217
  br label %for.inc237

for.inc237:                                       ; preds = %if.end236
  %214 = load i32* %bs.addr, align 4
  %215 = load i32* %k, align 4
  %add238 = add nsw i32 %215, %214
  store i32 %add238, i32* %k, align 4
  %216 = load i32* %K, align 4
  %inc239 = add nsw i32 %216, 1
  store i32 %inc239, i32* %K, align 4
  br label %for.cond

for.end240:                                       ; preds = %for.cond
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
  store double* %a, double** %a.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 %stride, i32* %stride.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc27, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end29

for.body:                                         ; preds = %for.cond
  %2 = load i32* %k, align 4
  %add = add nsw i32 %2, 1
  store i32 %add, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %3 = load i32* %j, align 4
  %4 = load i32* %n.addr, align 4
  %cmp2 = icmp slt i32 %3, %4
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %5 = load i32* %k, align 4
  %6 = load i32* %k, align 4
  %7 = load i32* %stride.addr, align 4
  %mul = mul nsw i32 %6, %7
  %add4 = add nsw i32 %5, %mul
  %idxprom = sext i32 %add4 to i64
  %8 = load double** %a.addr, align 8
  %arrayidx = getelementptr inbounds double* %8, i64 %idxprom
  %9 = load double* %arrayidx, align 8
  %10 = load i32* %k, align 4
  %11 = load i32* %j, align 4
  %12 = load i32* %stride.addr, align 4
  %mul5 = mul nsw i32 %11, %12
  %add6 = add nsw i32 %10, %mul5
  %idxprom7 = sext i32 %add6 to i64
  %13 = load double** %a.addr, align 8
  %arrayidx8 = getelementptr inbounds double* %13, i64 %idxprom7
  %14 = load double* %arrayidx8, align 8
  %div = fdiv double %14, %9
  store double %div, double* %arrayidx8, align 8
  %15 = load i32* %k, align 4
  %16 = load i32* %j, align 4
  %17 = load i32* %stride.addr, align 4
  %mul9 = mul nsw i32 %16, %17
  %add10 = add nsw i32 %15, %mul9
  %idxprom11 = sext i32 %add10 to i64
  %18 = load double** %a.addr, align 8
  %arrayidx12 = getelementptr inbounds double* %18, i64 %idxprom11
  %19 = load double* %arrayidx12, align 8
  %sub = fsub double -0.000000e+00, %19
  store double %sub, double* %alpha, align 8
  %20 = load i32* %n.addr, align 4
  %21 = load i32* %k, align 4
  %sub13 = sub nsw i32 %20, %21
  %sub14 = sub nsw i32 %sub13, 1
  store i32 %sub14, i32* %length, align 4
  %22 = load i32* %k, align 4
  %add15 = add nsw i32 %22, 1
  %23 = load i32* %j, align 4
  %24 = load i32* %stride.addr, align 4
  %mul16 = mul nsw i32 %23, %24
  %add17 = add nsw i32 %add15, %mul16
  %idxprom18 = sext i32 %add17 to i64
  %25 = load double** %a.addr, align 8
  %arrayidx19 = getelementptr inbounds double* %25, i64 %idxprom18
  %26 = load i32* %k, align 4
  %add20 = add nsw i32 %26, 1
  %27 = load i32* %k, align 4
  %28 = load i32* %stride.addr, align 4
  %mul21 = mul nsw i32 %27, %28
  %add22 = add nsw i32 %add20, %mul21
  %idxprom23 = sext i32 %add22 to i64
  %29 = load double** %a.addr, align 8
  %arrayidx24 = getelementptr inbounds double* %29, i64 %idxprom23
  %30 = load i32* %n.addr, align 4
  %31 = load i32* %k, align 4
  %sub25 = sub nsw i32 %30, %31
  %sub26 = sub nsw i32 %sub25, 1
  %32 = load double* %alpha, align 8
  call void @daxpy(double* %arrayidx19, double* %arrayidx24, i32 %sub26, double %32)
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %33 = load i32* %j, align 4
  %inc = add nsw i32 %33, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc27

for.inc27:                                        ; preds = %for.end
  %34 = load i32* %k, align 4
  %inc28 = add nsw i32 %34, 1
  store i32 %inc28, i32* %k, align 4
  br label %for.cond

for.end29:                                        ; preds = %for.cond
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
  store double* %a, double** %a.addr, align 8
  store double* %b, double** %b.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store double %alpha, double* %alpha.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load double* %alpha.addr, align 8
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load double** %b.addr, align 8
  %arrayidx = getelementptr inbounds double* %4, i64 %idxprom
  %5 = load double* %arrayidx, align 8
  %mul = fmul double %2, %5
  %6 = load i32* %i, align 4
  %idxprom1 = sext i32 %6 to i64
  %7 = load double** %a.addr, align 8
  %arrayidx2 = getelementptr inbounds double* %7, i64 %idxprom1
  %8 = load double* %arrayidx2, align 8
  %add = fadd double %8, %mul
  store double %add, double* %arrayidx2, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %9 = load i32* %i, align 4
  %inc = add nsw i32 %9, 1
  store i32 %inc, i32* %i, align 4
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
  store double* %a, double** %a.addr, align 8
  store double* %diag, double** %diag.addr, align 8
  store i32 %stride_a, i32* %stride_a.addr, align 4
  store i32 %stride_diag, i32* %stride_diag.addr, align 4
  store i32 %dimi, i32* %dimi.addr, align 4
  store i32 %dimk, i32* %dimk.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc11, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimk.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end13

for.body:                                         ; preds = %for.cond
  %2 = load i32* %k, align 4
  %add = add nsw i32 %2, 1
  store i32 %add, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %3 = load i32* %j, align 4
  %4 = load i32* %dimk.addr, align 4
  %cmp2 = icmp slt i32 %3, %4
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %5 = load i32* %k, align 4
  %6 = load i32* %j, align 4
  %7 = load i32* %stride_diag.addr, align 4
  %mul = mul nsw i32 %6, %7
  %add4 = add nsw i32 %5, %mul
  %idxprom = sext i32 %add4 to i64
  %8 = load double** %diag.addr, align 8
  %arrayidx = getelementptr inbounds double* %8, i64 %idxprom
  %9 = load double* %arrayidx, align 8
  %sub = fsub double -0.000000e+00, %9
  store double %sub, double* %alpha, align 8
  %10 = load i32* %j, align 4
  %11 = load i32* %stride_a.addr, align 4
  %mul5 = mul nsw i32 %10, %11
  %idxprom6 = sext i32 %mul5 to i64
  %12 = load double** %a.addr, align 8
  %arrayidx7 = getelementptr inbounds double* %12, i64 %idxprom6
  %13 = load i32* %k, align 4
  %14 = load i32* %stride_a.addr, align 4
  %mul8 = mul nsw i32 %13, %14
  %idxprom9 = sext i32 %mul8 to i64
  %15 = load double** %a.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %15, i64 %idxprom9
  %16 = load i32* %dimi.addr, align 4
  %17 = load double* %alpha, align 8
  call void @daxpy(double* %arrayidx7, double* %arrayidx10, i32 %16, double %17)
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %18 = load i32* %j, align 4
  %inc = add nsw i32 %18, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc11

for.inc11:                                        ; preds = %for.end
  %19 = load i32* %k, align 4
  %inc12 = add nsw i32 %19, 1
  store i32 %inc12, i32* %k, align 4
  br label %for.cond

for.end13:                                        ; preds = %for.cond
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
  store double* %a, double** %a.addr, align 8
  store double* %c, double** %c.addr, align 8
  store i32 %dimi, i32* %dimi.addr, align 4
  store i32 %dimj, i32* %dimj.addr, align 4
  store i32 %stride_a, i32* %stride_a.addr, align 4
  store i32 %stride_c, i32* %stride_c.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc26, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimi.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end28

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %3 = load i32* %dimj.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %4 = load i32* %k, align 4
  %5 = load i32* %k, align 4
  %6 = load i32* %stride_a.addr, align 4
  %mul = mul nsw i32 %5, %6
  %add = add nsw i32 %4, %mul
  %idxprom = sext i32 %add to i64
  %7 = load double** %a.addr, align 8
  %arrayidx = getelementptr inbounds double* %7, i64 %idxprom
  %8 = load double* %arrayidx, align 8
  %9 = load i32* %k, align 4
  %10 = load i32* %j, align 4
  %11 = load i32* %stride_c.addr, align 4
  %mul4 = mul nsw i32 %10, %11
  %add5 = add nsw i32 %9, %mul4
  %idxprom6 = sext i32 %add5 to i64
  %12 = load double** %c.addr, align 8
  %arrayidx7 = getelementptr inbounds double* %12, i64 %idxprom6
  %13 = load double* %arrayidx7, align 8
  %div = fdiv double %13, %8
  store double %div, double* %arrayidx7, align 8
  %14 = load i32* %k, align 4
  %15 = load i32* %j, align 4
  %16 = load i32* %stride_c.addr, align 4
  %mul8 = mul nsw i32 %15, %16
  %add9 = add nsw i32 %14, %mul8
  %idxprom10 = sext i32 %add9 to i64
  %17 = load double** %c.addr, align 8
  %arrayidx11 = getelementptr inbounds double* %17, i64 %idxprom10
  %18 = load double* %arrayidx11, align 8
  %sub = fsub double -0.000000e+00, %18
  store double %sub, double* %alpha, align 8
  %19 = load i32* %dimi.addr, align 4
  %20 = load i32* %k, align 4
  %sub12 = sub nsw i32 %19, %20
  %sub13 = sub nsw i32 %sub12, 1
  store i32 %sub13, i32* %length, align 4
  %21 = load i32* %k, align 4
  %add14 = add nsw i32 %21, 1
  %22 = load i32* %j, align 4
  %23 = load i32* %stride_c.addr, align 4
  %mul15 = mul nsw i32 %22, %23
  %add16 = add nsw i32 %add14, %mul15
  %idxprom17 = sext i32 %add16 to i64
  %24 = load double** %c.addr, align 8
  %arrayidx18 = getelementptr inbounds double* %24, i64 %idxprom17
  %25 = load i32* %k, align 4
  %add19 = add nsw i32 %25, 1
  %26 = load i32* %k, align 4
  %27 = load i32* %stride_a.addr, align 4
  %mul20 = mul nsw i32 %26, %27
  %add21 = add nsw i32 %add19, %mul20
  %idxprom22 = sext i32 %add21 to i64
  %28 = load double** %a.addr, align 8
  %arrayidx23 = getelementptr inbounds double* %28, i64 %idxprom22
  %29 = load i32* %dimi.addr, align 4
  %30 = load i32* %k, align 4
  %sub24 = sub nsw i32 %29, %30
  %sub25 = sub nsw i32 %sub24, 1
  %31 = load double* %alpha, align 8
  call void @daxpy(double* %arrayidx18, double* %arrayidx23, i32 %sub25, double %31)
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %32 = load i32* %j, align 4
  %inc = add nsw i32 %32, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc26

for.inc26:                                        ; preds = %for.end
  %33 = load i32* %k, align 4
  %inc27 = add nsw i32 %33, 1
  store i32 %inc27, i32* %k, align 4
  br label %for.cond

for.end28:                                        ; preds = %for.cond
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
  store double* %a, double** %a.addr, align 8
  store double* %b, double** %b.addr, align 8
  store double* %c, double** %c.addr, align 8
  store i32 %dimi, i32* %dimi.addr, align 4
  store i32 %dimj, i32* %dimj.addr, align 4
  store i32 %dimk, i32* %dimk.addr, align 4
  store i32 %stridea, i32* %stridea.addr, align 4
  store i32 %strideb, i32* %strideb.addr, align 4
  store i32 %stridec, i32* %stridec.addr, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc10, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %dimk.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end12

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %3 = load i32* %dimj.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %4 = load i32* %k, align 4
  %5 = load i32* %j, align 4
  %6 = load i32* %strideb.addr, align 4
  %mul = mul nsw i32 %5, %6
  %add = add nsw i32 %4, %mul
  %idxprom = sext i32 %add to i64
  %7 = load double** %b.addr, align 8
  %arrayidx = getelementptr inbounds double* %7, i64 %idxprom
  %8 = load double* %arrayidx, align 8
  %sub = fsub double -0.000000e+00, %8
  store double %sub, double* %alpha, align 8
  %9 = load i32* %j, align 4
  %10 = load i32* %stridec.addr, align 4
  %mul4 = mul nsw i32 %9, %10
  %idxprom5 = sext i32 %mul4 to i64
  %11 = load double** %c.addr, align 8
  %arrayidx6 = getelementptr inbounds double* %11, i64 %idxprom5
  %12 = load i32* %k, align 4
  %13 = load i32* %stridea.addr, align 4
  %mul7 = mul nsw i32 %12, %13
  %idxprom8 = sext i32 %mul7 to i64
  %14 = load double** %a.addr, align 8
  %arrayidx9 = getelementptr inbounds double* %14, i64 %idxprom8
  %15 = load i32* %dimi.addr, align 4
  %16 = load double* %alpha, align 8
  call void @daxpy(double* %arrayidx6, double* %arrayidx9, i32 %15, double %16)
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %17 = load i32* %j, align 4
  %inc = add nsw i32 %17, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc10

for.inc10:                                        ; preds = %for.end
  %18 = load i32* %k, align 4
  %inc11 = add nsw i32 %18, 1
  store i32 %inc11, i32* %k, align 4
  br label %for.cond

for.end12:                                        ; preds = %for.cond
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
  %0 = load i32* @n, align 4
  %1 = load i32* @block_size, align 4
  %rem = srem i32 %0, %1
  store i32 %rem, i32* %edge, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc20, %entry
  %2 = load i32* %i, align 4
  %3 = load i32* @n, align 4
  %cmp = icmp slt i32 %2, %3
  br i1 %cmp, label %for.body, label %for.end22

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %4 = load i32* %j, align 4
  %5 = load i32* @n, align 4
  %cmp2 = icmp slt i32 %4, %5
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %6 = load i32* @n, align 4
  %7 = load i32* %i, align 4
  %sub = sub nsw i32 %6, %7
  %8 = load i32* %edge, align 4
  %cmp4 = icmp sle i32 %sub, %8
  br i1 %cmp4, label %if.then, label %if.else

if.then:                                          ; preds = %for.body3
  %9 = load i32* %edge, align 4
  store i32 %9, i32* %ibs, align 4
  %10 = load i32* @n, align 4
  %11 = load i32* %edge, align 4
  %sub5 = sub nsw i32 %10, %11
  store i32 %sub5, i32* %ibs, align 4
  %12 = load i32* %edge, align 4
  store i32 %12, i32* %skip, align 4
  br label %if.end

if.else:                                          ; preds = %for.body3
  %13 = load i32* @block_size, align 4
  store i32 %13, i32* %ibs, align 4
  %14 = load i32* @block_size, align 4
  store i32 %14, i32* %skip, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %15 = load i32* @n, align 4
  %16 = load i32* %j, align 4
  %sub6 = sub nsw i32 %15, %16
  %17 = load i32* %edge, align 4
  %cmp7 = icmp sle i32 %sub6, %17
  br i1 %cmp7, label %if.then8, label %if.else10

if.then8:                                         ; preds = %if.end
  %18 = load i32* %edge, align 4
  store i32 %18, i32* %jbs, align 4
  %19 = load i32* @n, align 4
  %20 = load i32* %edge, align 4
  %sub9 = sub nsw i32 %19, %20
  store i32 %sub9, i32* %jbs, align 4
  br label %if.end11

if.else10:                                        ; preds = %if.end
  %21 = load i32* @block_size, align 4
  store i32 %21, i32* %jbs, align 4
  br label %if.end11

if.end11:                                         ; preds = %if.else10, %if.then8
  %22 = load i32* %i, align 4
  %23 = load i32* @block_size, align 4
  %div = sdiv i32 %22, %23
  %24 = load i32* %j, align 4
  %25 = load i32* @block_size, align 4
  %div12 = sdiv i32 %24, %25
  %26 = load i32* @nblocks, align 4
  %mul = mul nsw i32 %div12, %26
  %add = add nsw i32 %div, %mul
  store i32 %add, i32* %ii, align 4
  %27 = load i32* %i, align 4
  %28 = load i32* %ibs, align 4
  %rem13 = srem i32 %27, %28
  %29 = load i32* %j, align 4
  %30 = load i32* %jbs, align 4
  %rem14 = srem i32 %29, %30
  %31 = load i32* %skip, align 4
  %mul15 = mul nsw i32 %rem14, %31
  %add16 = add nsw i32 %rem13, %mul15
  store i32 %add16, i32* %jj, align 4
  %32 = load i32* %jj, align 4
  %idxprom = sext i32 %32 to i64
  %33 = load i32* %ii, align 4
  %idxprom17 = sext i32 %33 to i64
  %34 = load double*** @a, align 8
  %arrayidx = getelementptr inbounds double** %34, i64 %idxprom17
  %35 = load double** %arrayidx, align 8
  %arrayidx18 = getelementptr inbounds double* %35, i64 %idxprom
  %36 = load double* %arrayidx18, align 8
  %call = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([7 x i8]* @.str45, i32 0, i32 0), double %36)
  br label %for.inc

for.inc:                                          ; preds = %if.end11
  %37 = load i32* %j, align 4
  %inc = add nsw i32 %37, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  %call19 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str13, i32 0, i32 0))
  br label %for.inc20

for.inc20:                                        ; preds = %for.end
  %38 = load i32* %i, align 4
  %inc21 = add nsw i32 %38, 1
  store i32 %inc21, i32* %i, align 4
  br label %for.cond

for.end22:                                        ; preds = %for.cond
  %39 = load %struct._IO_FILE** @stdout, align 8
  %call23 = call i32 @fflush(%struct._IO_FILE* %39)
  ret void
}

declare i32 @fflush(%struct._IO_FILE*)

; Function Attrs: nounwind readnone
declare double @fabs(double)

; Function Attrs: nounwind
declare void @free(i8*)
