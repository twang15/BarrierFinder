; ModuleID = 'FFT.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.GlobalMemory = type { i32, %union.pthread_mutex_t, %struct.barrier_t, i32*, i32*, i32, i32, i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.barrier_t = type { i32, i64 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@P = internal global i32 1, align 4
@M = internal global i32 10, align 4
@test_result = internal global i32 0, align 4
@doprint = internal global i32 0, align 4
@dostats = internal global i32 0, align 4
@transtime = internal global i32 0, align 4
@transtime2 = internal global i32 0, align 4
@avgtranstime = internal global i32 0, align 4
@avgcomptime = internal global i32 0, align 4
@transstart = internal global i32 0, align 4
@transend = internal global i32 0, align 4
@maxtotal = internal global i32 0, align 4
@mintotal = internal global i32 0, align 4
@maxfrac = internal global double 0.000000e+00, align 8
@minfrac = internal global double 0.000000e+00, align 8
@avgfractime = internal global double 0.000000e+00, align 8
@orig_num_lines = internal global i32 65536, align 4
@num_cache_lines = internal global i32 65536, align 4
@log2_line_size = internal global i32 4, align 4
@optarg = external global i8*, align 8
@N = internal global i32 0, align 4
@rootN = internal global i32 0, align 4
@rowsperproc = internal global i32 0, align 4
@line_size = internal global i32 0, align 4
@pad_length = internal global i32 0, align 4
@Global = internal global %struct.GlobalMemory* null, align 8
@x = internal global double* null, align 8
@trans = internal global double* null, align 8
@umain = internal global double* null, align 8
@umain2 = internal global double* null, align 8
@ck1 = internal global double 0.000000e+00, align 8
@ck3 = internal global double 0.000000e+00, align 8
@stdout = external global %struct._IO_FILE*, align 8
@stderr = external global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [13 x i8] c"p:m:n:l:stoh\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"P must be >= 1\0A\00", align 1
@.str.2 = private unnamed_addr constant [24 x i8] c"P must be a power of 2\0A\00", align 1
@.str.3 = private unnamed_addr constant [16 x i8] c"M must be even\0A\00", align 1
@.str.4 = private unnamed_addr constant [36 x i8] c"Number of cache lines must be >= 1\0A\00", align 1
@.str.5 = private unnamed_addr constant [55 x i8] c"Log base 2 of cache line length in bytes must be >= 0\0A\00", align 1
@.str.6 = private unnamed_addr constant [23 x i8] c"Usage: FFT <options>\0A\0A\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"options:\0A\00", align 1
@.str.8 = private unnamed_addr constant [71 x i8] c"  -mM : M = even integer; 2**M total complex data points transformed.\0A\00", align 1
@.str.9 = private unnamed_addr constant [57 x i8] c"  -pP : P = number of processors; Must be a power of 2.\0A\00", align 1
@.str.10 = private unnamed_addr constant [36 x i8] c"  -nN : N = number of cache lines.\0A\00", align 1
@.str.11 = private unnamed_addr constant [55 x i8] c"  -lL : L = Log base 2 of cache line length in bytes.\0A\00", align 1
@.str.12 = private unnamed_addr constant [55 x i8] c"  -s  : Print individual processor timing statistics.\0A\00", align 1
@.str.13 = private unnamed_addr constant [68 x i8] c"  -t  : Perform FFT and inverse FFT.  Test output by comparing the\0A\00", align 1
@.str.14 = private unnamed_addr constant [72 x i8] c"        integral of the original data to the integral of the data that\0A\00", align 1
@.str.15 = private unnamed_addr constant [58 x i8] c"        results from performing the FFT and inverse FFT.\0A\00", align 1
@.str.16 = private unnamed_addr constant [40 x i8] c"  -o  : Print out complex data points.\0A\00", align 1
@.str.17 = private unnamed_addr constant [42 x i8] c"  -h  : Print out command line options.\0A\0A\00", align 1
@.str.18 = private unnamed_addr constant [38 x i8] c"Default: FFT -m%1d -p%1d -n%1d -l%1d\0A\00", align 1
@.str.19 = private unnamed_addr constant [48 x i8] c"Matrix not large enough. 2**(M/2) must be >= P\0A\00", align 1
@.str.20 = private unnamed_addr constant [54 x i8] c"WARNING: Each element is a complex double (%d bytes)\0A\00", align 1
@.str.21 = private unnamed_addr constant [43 x i8] c"  => Less than one element per cache line\0A\00", align 1
@.str.22 = private unnamed_addr constant [42 x i8] c"     Computing transpose blocking factor\0A\00", align 1
@.str.23 = private unnamed_addr constant [32 x i8] c"Padding algorithm unsuccessful\0A\00", align 1
@.str.24 = private unnamed_addr constant [7 x i8] c"x: %p\0A\00", align 1
@.str.25 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for Global\0A\00", align 1
@.str.26 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for x\0A\00", align 1
@.str.27 = private unnamed_addr constant [35 x i8] c"Could not malloc memory for trans\0A\00", align 1
@.str.28 = private unnamed_addr constant [35 x i8] c"Could not malloc memory for umain\0A\00", align 1
@.str.29 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for umain2\0A\00", align 1
@.str.30 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.31 = private unnamed_addr constant [29 x i8] c"FFT with Blocking Transpose\0A\00", align 1
@.str.32 = private unnamed_addr constant [23 x i8] c"   %d Complex Doubles\0A\00", align 1
@.str.33 = private unnamed_addr constant [18 x i8] c"   %d Processors\0A\00", align 1
@.str.34 = private unnamed_addr constant [19 x i8] c"   %d Cache lines\0A\00", align 1
@.str.35 = private unnamed_addr constant [42 x i8] c"   %d Cache lines for blocking transpose\0A\00", align 1
@.str.36 = private unnamed_addr constant [22 x i8] c"   %d Byte line size\0A\00", align 1
@.str.37 = private unnamed_addr constant [22 x i8] c"   %d Bytes per page\0A\00", align 1
@.str.38 = private unnamed_addr constant [23 x i8] c"Original data values:\0A\00", align 1
@.str.39 = private unnamed_addr constant [9 x i8] c"main %d\0A\00", align 1
@.str.40 = private unnamed_addr constant [32 x i8] c"Data values after inverse FFT:\0A\00", align 1
@.str.41 = private unnamed_addr constant [24 x i8] c"Data values after FFT:\0A\00", align 1
@.str.42 = private unnamed_addr constant [37 x i8] c"                 PROCESS STATISTICS\0A\00", align 1
@.str.43 = private unnamed_addr constant [54 x i8] c"            Computation      Transpose     Transpose\0A\00", align 1
@.str.44 = private unnamed_addr constant [53 x i8] c" Proc          Time            Time        Fraction\0A\00", align 1
@.str.45 = private unnamed_addr constant [39 x i8] c"    0        %10d     %10d      %8.5f\0A\00", align 1
@.str.46 = private unnamed_addr constant [39 x i8] c"  %3d        %10d     %10d      %8.5f\0A\00", align 1
@.str.47 = private unnamed_addr constant [43 x i8] c"  Avg        %10.0f     %10.0f      %8.5f\0A\00", align 1
@.str.48 = private unnamed_addr constant [39 x i8] c"  Max        %10d     %10d      %8.5f\0A\00", align 1
@.str.49 = private unnamed_addr constant [39 x i8] c"  Min        %10d     %10d      %8.5f\0A\00", align 1
@.str.50 = private unnamed_addr constant [37 x i8] c"                 TIMING INFORMATION\0A\00", align 1
@.str.51 = private unnamed_addr constant [42 x i8] c"Start time                        : %16d\0A\00", align 1
@.str.52 = private unnamed_addr constant [42 x i8] c"Initialization finish time        : %16d\0A\00", align 1
@.str.53 = private unnamed_addr constant [42 x i8] c"Overall finish time               : %16d\0A\00", align 1
@.str.54 = private unnamed_addr constant [42 x i8] c"Total time with initialization    : %16d\0A\00", align 1
@.str.55 = private unnamed_addr constant [42 x i8] c"Total time without initialization : %16d\0A\00", align 1
@.str.56 = private unnamed_addr constant [42 x i8] c"Overall transpose time            : %16d\0A\00", align 1
@.str.57 = private unnamed_addr constant [44 x i8] c"Overall transpose fraction        : %16.5f\0A\00", align 1
@.str.58 = private unnamed_addr constant [40 x i8] c"              INVERSE FFT TEST RESULTS\0A\00", align 1
@.str.59 = private unnamed_addr constant [42 x i8] c"Checksum difference is %.3f (%.3f, %.3f)\0A\00", align 1
@.str.60 = private unnamed_addr constant [13 x i8] c"TEST PASSED\0A\00", align 1
@.str.61 = private unnamed_addr constant [13 x i8] c"TEST FAILED\0A\00", align 1
@.str.66 = private unnamed_addr constant [11 x i8] c"ERROR: %s\0A\00", align 1
@.str.62 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.63 = private unnamed_addr constant [43 x i8] c"Proc %d could not malloc memory for upriv\0A\00", align 1
@.str.64 = private unnamed_addr constant [13 x i8] c" %4.2f %4.2f\00", align 1
@.str.65 = private unnamed_addr constant [2 x i8] c",\00", align 1
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
@.str.67 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %c = alloca i32, align 4
  %m1 = alloca i32, align 4
  %factor = alloca i32, align 4
  %pages = alloca i32, align 4
  %start = alloca i32, align 4
  %t = alloca i64, align 8
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i64 @time(i64* null)
  %conv = trunc i64 %call to i32
  store i32 %conv, i32* %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %0 = load i32* %argc.addr, align 4
  %1 = load i8*** %argv.addr, align 8
  %call1 = call i32 (i32, i8**, i8*, ...) *bitcast (i32 (...)* @getopt to i32 (i32, i8**, i8*, ...)*)(i32 %0, i8** %1, i8* getelementptr inbounds ([13 x i8]* @.str, i32 0, i32 0))
  store i32 %call1, i32* %c, align 4
  %cmp = icmp ne i32 %call1, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %c, align 4
  switch i32 %2, label %sw.epilog [
    i32 112, label %sw.bb
    i32 109, label %sw.bb.11
    i32 110, label %sw.bb.17
    i32 108, label %sw.bb.23
    i32 115, label %sw.bb.29
    i32 116, label %sw.bb.30
    i32 111, label %sw.bb.34
    i32 104, label %sw.bb.38
  ]

sw.bb:                                            ; preds = %while.body
  %3 = load i8** @optarg, align 8
  %call3 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %3)
  store i32 %call3, i32* @P, align 4
  %4 = load i32* @P, align 4
  %cmp4 = icmp slt i32 %4, 1
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %sw.bb
  call void @printerr(i8* getelementptr inbounds ([16 x i8]* @.str.1, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %sw.bb
  %5 = load i32* @P, align 4
  %call6 = call i32 @log_2(i32 %5)
  %cmp7 = icmp eq i32 %call6, -1
  br i1 %cmp7, label %if.then.9, label %if.end.10

if.then.9:                                        ; preds = %if.end
  call void @printerr(i8* getelementptr inbounds ([24 x i8]* @.str.2, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.10:                                        ; preds = %if.end
  br label %sw.epilog

sw.bb.11:                                         ; preds = %while.body
  %6 = load i8** @optarg, align 8
  %call12 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %6)
  store i32 %call12, i32* @M, align 4
  %7 = load i32* @M, align 4
  %div = sdiv i32 %7, 2
  store i32 %div, i32* %m1, align 4
  %8 = load i32* %m1, align 4
  %mul = mul nsw i32 2, %8
  %9 = load i32* @M, align 4
  %cmp13 = icmp ne i32 %mul, %9
  br i1 %cmp13, label %if.then.15, label %if.end.16

if.then.15:                                       ; preds = %sw.bb.11
  call void @printerr(i8* getelementptr inbounds ([16 x i8]* @.str.3, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.16:                                        ; preds = %sw.bb.11
  br label %sw.epilog

sw.bb.17:                                         ; preds = %while.body
  %10 = load i8** @optarg, align 8
  %call18 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %10)
  store i32 %call18, i32* @num_cache_lines, align 4
  %11 = load i32* @num_cache_lines, align 4
  store i32 %11, i32* @orig_num_lines, align 4
  %12 = load i32* @num_cache_lines, align 4
  %cmp19 = icmp slt i32 %12, 1
  br i1 %cmp19, label %if.then.21, label %if.end.22

if.then.21:                                       ; preds = %sw.bb.17
  call void @printerr(i8* getelementptr inbounds ([36 x i8]* @.str.4, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.22:                                        ; preds = %sw.bb.17
  br label %sw.epilog

sw.bb.23:                                         ; preds = %while.body
  %13 = load i8** @optarg, align 8
  %call24 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %13)
  store i32 %call24, i32* @log2_line_size, align 4
  %14 = load i32* @log2_line_size, align 4
  %cmp25 = icmp slt i32 %14, 0
  br i1 %cmp25, label %if.then.27, label %if.end.28

if.then.27:                                       ; preds = %sw.bb.23
  call void @printerr(i8* getelementptr inbounds ([55 x i8]* @.str.5, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.28:                                        ; preds = %sw.bb.23
  br label %sw.epilog

sw.bb.29:                                         ; preds = %while.body
  %15 = load i32* @dostats, align 4
  %tobool = icmp ne i32 %15, 0
  %lnot = xor i1 %tobool, true
  %lnot.ext = zext i1 %lnot to i32
  store i32 %lnot.ext, i32* @dostats, align 4
  br label %sw.epilog

sw.bb.30:                                         ; preds = %while.body
  %16 = load i32* @test_result, align 4
  %tobool31 = icmp ne i32 %16, 0
  %lnot32 = xor i1 %tobool31, true
  %lnot.ext33 = zext i1 %lnot32 to i32
  store i32 %lnot.ext33, i32* @test_result, align 4
  br label %sw.epilog

sw.bb.34:                                         ; preds = %while.body
  %17 = load i32* @doprint, align 4
  %tobool35 = icmp ne i32 %17, 0
  %lnot36 = xor i1 %tobool35, true
  %lnot.ext37 = zext i1 %lnot36 to i32
  store i32 %lnot.ext37, i32* @doprint, align 4
  br label %sw.epilog

sw.bb.38:                                         ; preds = %while.body
  %call39 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([23 x i8]* @.str.6, i32 0, i32 0))
  %call40 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([10 x i8]* @.str.7, i32 0, i32 0))
  %call41 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([71 x i8]* @.str.8, i32 0, i32 0))
  %call42 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.9, i32 0, i32 0))
  %call43 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([36 x i8]* @.str.10, i32 0, i32 0))
  %call44 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.11, i32 0, i32 0))
  %call45 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.12, i32 0, i32 0))
  %call46 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([68 x i8]* @.str.13, i32 0, i32 0))
  %call47 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([72 x i8]* @.str.14, i32 0, i32 0))
  %call48 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([58 x i8]* @.str.15, i32 0, i32 0))
  %call49 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([40 x i8]* @.str.16, i32 0, i32 0))
  %call50 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.17, i32 0, i32 0))
  %call51 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([38 x i8]* @.str.18, i32 0, i32 0), i32 10, i32 1, i32 65536, i32 4)
  call void @exit(i32 0)
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %sw.bb.34, %sw.bb.30, %sw.bb.29, %if.end.28, %if.end.22, %if.end.16, %if.end.10, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %18 = load i32* @M, align 4
  %shl = shl i32 1, %18
  store i32 %shl, i32* @N, align 4
  %19 = load i32* @M, align 4
  %div52 = sdiv i32 %19, 2
  %shl53 = shl i32 1, %div52
  store i32 %shl53, i32* @rootN, align 4
  %20 = load i32* @rootN, align 4
  %21 = load i32* @P, align 4
  %div54 = sdiv i32 %20, %21
  store i32 %div54, i32* @rowsperproc, align 4
  %22 = load i32* @rowsperproc, align 4
  %cmp55 = icmp eq i32 %22, 0
  br i1 %cmp55, label %if.then.57, label %if.end.58

if.then.57:                                       ; preds = %while.end
  call void @printerr(i8* getelementptr inbounds ([48 x i8]* @.str.19, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.58:                                        ; preds = %while.end
  %23 = load i32* @log2_line_size, align 4
  %shl59 = shl i32 1, %23
  store i32 %shl59, i32* @line_size, align 4
  %24 = load i32* @line_size, align 4
  %conv60 = sext i32 %24 to i64
  %cmp61 = icmp ult i64 %conv60, 16
  br i1 %cmp61, label %if.then.63, label %if.end.71

if.then.63:                                       ; preds = %if.end.58
  %call64 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([54 x i8]* @.str.20, i32 0, i32 0), i64 16)
  %call65 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([43 x i8]* @.str.21, i32 0, i32 0))
  %call66 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.22, i32 0, i32 0))
  %25 = load i32* @line_size, align 4
  %conv67 = sext i32 %25 to i64
  %div68 = udiv i64 16, %conv67
  %conv69 = trunc i64 %div68 to i32
  store i32 %conv69, i32* %factor, align 4
  %26 = load i32* @orig_num_lines, align 4
  %27 = load i32* %factor, align 4
  %div70 = sdiv i32 %26, %27
  store i32 %div70, i32* @num_cache_lines, align 4
  br label %if.end.71

if.end.71:                                        ; preds = %if.then.63, %if.end.58
  %28 = load i32* @line_size, align 4
  %conv72 = sext i32 %28 to i64
  %cmp73 = icmp ule i64 %conv72, 16
  br i1 %cmp73, label %if.then.75, label %if.else

if.then.75:                                       ; preds = %if.end.71
  store i32 1, i32* @pad_length, align 4
  br label %if.end.79

if.else:                                          ; preds = %if.end.71
  %29 = load i32* @line_size, align 4
  %conv76 = sext i32 %29 to i64
  %div77 = udiv i64 %conv76, 16
  %conv78 = trunc i64 %div77 to i32
  store i32 %conv78, i32* @pad_length, align 4
  br label %if.end.79

if.end.79:                                        ; preds = %if.else, %if.then.75
  %30 = load i32* @rowsperproc, align 4
  %31 = load i32* @rootN, align 4
  %mul80 = mul nsw i32 %30, %31
  %mul81 = mul nsw i32 %mul80, 2
  %conv82 = sext i32 %mul81 to i64
  %mul83 = mul i64 %conv82, 8
  %cmp84 = icmp uge i64 %mul83, 4096
  br i1 %cmp84, label %if.then.86, label %if.else.111

if.then.86:                                       ; preds = %if.end.79
  %32 = load i32* @pad_length, align 4
  %mul87 = mul nsw i32 2, %32
  %conv88 = sext i32 %mul87 to i64
  %mul89 = mul i64 %conv88, 8
  %33 = load i32* @rowsperproc, align 4
  %conv90 = sext i32 %33 to i64
  %mul91 = mul i64 %mul89, %conv90
  %div92 = udiv i64 %mul91, 4096
  %conv93 = trunc i64 %div92 to i32
  store i32 %conv93, i32* %pages, align 4
  %34 = load i32* %pages, align 4
  %mul94 = mul nsw i32 %34, 4096
  %conv95 = sext i32 %mul94 to i64
  %35 = load i32* @pad_length, align 4
  %mul96 = mul nsw i32 2, %35
  %conv97 = sext i32 %mul96 to i64
  %mul98 = mul i64 %conv97, 8
  %36 = load i32* @rowsperproc, align 4
  %conv99 = sext i32 %36 to i64
  %mul100 = mul i64 %mul98, %conv99
  %cmp101 = icmp ne i64 %conv95, %mul100
  br i1 %cmp101, label %if.then.103, label %if.end.104

if.then.103:                                      ; preds = %if.then.86
  %37 = load i32* %pages, align 4
  %inc = add nsw i32 %37, 1
  store i32 %inc, i32* %pages, align 4
  br label %if.end.104

if.end.104:                                       ; preds = %if.then.103, %if.then.86
  %38 = load i32* %pages, align 4
  %mul105 = mul nsw i32 %38, 4096
  %conv106 = sext i32 %mul105 to i64
  %39 = load i32* @rowsperproc, align 4
  %conv107 = sext i32 %39 to i64
  %mul108 = mul i64 16, %conv107
  %div109 = udiv i64 %conv106, %mul108
  %conv110 = trunc i64 %div109 to i32
  store i32 %conv110, i32* @pad_length, align 4
  br label %if.end.133

if.else.111:                                      ; preds = %if.end.79
  %40 = load i32* @rowsperproc, align 4
  %41 = load i32* @rootN, align 4
  %mul112 = mul nsw i32 %40, %41
  %mul113 = mul nsw i32 %mul112, 2
  %conv114 = sext i32 %mul113 to i64
  %mul115 = mul i64 %conv114, 8
  %sub = sub i64 4096, %mul115
  %42 = load i32* @rowsperproc, align 4
  %conv116 = sext i32 %42 to i64
  %mul117 = mul i64 16, %conv116
  %div118 = udiv i64 %sub, %mul117
  %conv119 = trunc i64 %div118 to i32
  store i32 %conv119, i32* @pad_length, align 4
  %43 = load i32* @pad_length, align 4
  %conv120 = sext i32 %43 to i64
  %44 = load i32* @rowsperproc, align 4
  %conv121 = sext i32 %44 to i64
  %mul122 = mul i64 16, %conv121
  %mul123 = mul i64 %conv120, %mul122
  %45 = load i32* @rowsperproc, align 4
  %46 = load i32* @rootN, align 4
  %mul124 = mul nsw i32 %45, %46
  %mul125 = mul nsw i32 %mul124, 2
  %conv126 = sext i32 %mul125 to i64
  %mul127 = mul i64 %conv126, 8
  %sub128 = sub i64 4096, %mul127
  %cmp129 = icmp ne i64 %mul123, %sub128
  br i1 %cmp129, label %if.then.131, label %if.end.132

if.then.131:                                      ; preds = %if.else.111
  call void @printerr(i8* getelementptr inbounds ([32 x i8]* @.str.23, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.132:                                       ; preds = %if.else.111
  br label %if.end.133

if.end.133:                                       ; preds = %if.end.132, %if.end.104
  %call134 = call i8* @malloc(i64 96)
  %47 = bitcast i8* %call134 to %struct.GlobalMemory*
  store %struct.GlobalMemory* %47, %struct.GlobalMemory** @Global, align 8
  %48 = load i32* @N, align 4
  %49 = load i32* @rootN, align 4
  %50 = load i32* @pad_length, align 4
  %mul135 = mul nsw i32 %49, %50
  %add = add nsw i32 %48, %mul135
  %mul136 = mul nsw i32 2, %add
  %conv137 = sext i32 %mul136 to i64
  %mul138 = mul i64 %conv137, 8
  %add139 = add i64 %mul138, 4096
  %call140 = call i8* @malloc(i64 %add139)
  %51 = bitcast i8* %call140 to double*
  store double* %51, double** @x, align 8
  %52 = load double** @x, align 8
  %call141 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([7 x i8]* @.str.24, i32 0, i32 0), double* %52)
  %53 = load i32* @N, align 4
  %54 = load i32* @rootN, align 4
  %55 = load i32* @pad_length, align 4
  %mul142 = mul nsw i32 %54, %55
  %add143 = add nsw i32 %53, %mul142
  %mul144 = mul nsw i32 2, %add143
  %conv145 = sext i32 %mul144 to i64
  %mul146 = mul i64 %conv145, 8
  %add147 = add i64 %mul146, 4096
  %call148 = call i8* @malloc(i64 %add147)
  %56 = bitcast i8* %call148 to double*
  store double* %56, double** @trans, align 8
  %57 = load i32* @rootN, align 4
  %mul149 = mul nsw i32 2, %57
  %conv150 = sext i32 %mul149 to i64
  %mul151 = mul i64 %conv150, 8
  %call152 = call i8* @malloc(i64 %mul151)
  %58 = bitcast i8* %call152 to double*
  store double* %58, double** @umain, align 8
  %59 = load i32* @N, align 4
  %60 = load i32* @rootN, align 4
  %61 = load i32* @pad_length, align 4
  %mul153 = mul nsw i32 %60, %61
  %add154 = add nsw i32 %59, %mul153
  %mul155 = mul nsw i32 2, %add154
  %conv156 = sext i32 %mul155 to i64
  %mul157 = mul i64 %conv156, 8
  %add158 = add i64 %mul157, 4096
  %call159 = call i8* @malloc(i64 %add158)
  %62 = bitcast i8* %call159 to double*
  store double* %62, double** @umain2, align 8
  %63 = load i32* @P, align 4
  %conv160 = sext i32 %63 to i64
  %mul161 = mul i64 %conv160, 4
  %call162 = call i8* @malloc(i64 %mul161)
  %64 = bitcast i8* %call162 to i32*
  %65 = load %struct.GlobalMemory** @Global, align 8
  %transtimes = getelementptr inbounds %struct.GlobalMemory* %65, i32 0, i32 3
  store i32* %64, i32** %transtimes, align 8
  %66 = load i32* @P, align 4
  %conv163 = sext i32 %66 to i64
  %mul164 = mul i64 %conv163, 4
  %call165 = call i8* @malloc(i64 %mul164)
  %67 = bitcast i8* %call165 to i32*
  %68 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes = getelementptr inbounds %struct.GlobalMemory* %68, i32 0, i32 4
  store i32* %67, i32** %totaltimes, align 8
  %69 = load %struct.GlobalMemory** @Global, align 8
  %cmp166 = icmp eq %struct.GlobalMemory* %69, null
  br i1 %cmp166, label %if.then.168, label %if.else.169

if.then.168:                                      ; preds = %if.end.133
  call void @printerr(i8* getelementptr inbounds ([36 x i8]* @.str.25, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.else.169:                                      ; preds = %if.end.133
  %70 = load double** @x, align 8
  %cmp170 = icmp eq double* %70, null
  br i1 %cmp170, label %if.then.172, label %if.else.173

if.then.172:                                      ; preds = %if.else.169
  call void @printerr(i8* getelementptr inbounds ([31 x i8]* @.str.26, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.else.173:                                      ; preds = %if.else.169
  %71 = load double** @trans, align 8
  %cmp174 = icmp eq double* %71, null
  br i1 %cmp174, label %if.then.176, label %if.else.177

if.then.176:                                      ; preds = %if.else.173
  call void @printerr(i8* getelementptr inbounds ([35 x i8]* @.str.27, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.else.177:                                      ; preds = %if.else.173
  %72 = load double** @umain, align 8
  %cmp178 = icmp eq double* %72, null
  br i1 %cmp178, label %if.then.180, label %if.else.181

if.then.180:                                      ; preds = %if.else.177
  call void @printerr(i8* getelementptr inbounds ([35 x i8]* @.str.28, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.else.181:                                      ; preds = %if.else.177
  %73 = load double** @umain2, align 8
  %cmp182 = icmp eq double* %73, null
  br i1 %cmp182, label %if.then.184, label %if.end.185

if.then.184:                                      ; preds = %if.else.181
  call void @printerr(i8* getelementptr inbounds ([36 x i8]* @.str.29, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

if.end.185:                                       ; preds = %if.else.181
  br label %if.end.186

if.end.186:                                       ; preds = %if.end.185
  br label %if.end.187

if.end.187:                                       ; preds = %if.end.186
  br label %if.end.188

if.end.188:                                       ; preds = %if.end.187
  br label %if.end.189

if.end.189:                                       ; preds = %if.end.188
  %74 = load double** @x, align 8
  %75 = ptrtoint double* %74 to i64
  %add190 = add nsw i64 %75, 4096
  %76 = load double** @x, align 8
  %77 = ptrtoint double* %76 to i64
  %rem = srem i64 %77, 4096
  %sub191 = sub nsw i64 %add190, %rem
  %78 = inttoptr i64 %sub191 to double*
  store double* %78, double** @x, align 8
  %79 = load double** @x, align 8
  %call192 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([7 x i8]* @.str.24, i32 0, i32 0), double* %79)
  %80 = load double** @trans, align 8
  %81 = ptrtoint double* %80 to i64
  %add193 = add nsw i64 %81, 4096
  %82 = load double** @trans, align 8
  %83 = ptrtoint double* %82 to i64
  %rem194 = srem i64 %83, 4096
  %sub195 = sub nsw i64 %add193, %rem194
  %84 = inttoptr i64 %sub195 to double*
  store double* %84, double** @trans, align 8
  %85 = load double** @umain2, align 8
  %86 = ptrtoint double* %85 to i64
  %add196 = add nsw i64 %86, 4096
  %87 = load double** @umain2, align 8
  %88 = ptrtoint double* %87 to i64
  %rem197 = srem i64 %88, 4096
  %sub198 = sub nsw i64 %add196, %rem197
  %89 = inttoptr i64 %sub198 to double*
  store double* %89, double** @umain2, align 8
  %call199 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %call200 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([29 x i8]* @.str.31, i32 0, i32 0))
  %90 = load i32* @N, align 4
  %call201 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([23 x i8]* @.str.32, i32 0, i32 0), i32 %90)
  %91 = load i32* @P, align 4
  %call202 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([18 x i8]* @.str.33, i32 0, i32 0), i32 %91)
  %92 = load i32* @num_cache_lines, align 4
  %93 = load i32* @orig_num_lines, align 4
  %cmp203 = icmp ne i32 %92, %93
  br i1 %cmp203, label %if.then.205, label %if.else.208

if.then.205:                                      ; preds = %if.end.189
  %94 = load i32* @orig_num_lines, align 4
  %call206 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([19 x i8]* @.str.34, i32 0, i32 0), i32 %94)
  %95 = load i32* @num_cache_lines, align 4
  %call207 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.35, i32 0, i32 0), i32 %95)
  br label %if.end.210

if.else.208:                                      ; preds = %if.end.189
  %96 = load i32* @num_cache_lines, align 4
  %call209 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([19 x i8]* @.str.34, i32 0, i32 0), i32 %96)
  br label %if.end.210

if.end.210:                                       ; preds = %if.else.208, %if.then.205
  %97 = load i32* @log2_line_size, align 4
  %shl211 = shl i32 1, %97
  %call212 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str.36, i32 0, i32 0), i32 %shl211)
  %call213 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str.37, i32 0, i32 0), i32 4096)
  %call214 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %98 = load %struct.GlobalMemory** @Global, align 8
  %start215 = getelementptr inbounds %struct.GlobalMemory* %98, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start215, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %99 = load %struct.GlobalMemory** @Global, align 8
  %start216 = getelementptr inbounds %struct.GlobalMemory* %99, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start216, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  %100 = load %struct.GlobalMemory** @Global, align 8
  %idlock = getelementptr inbounds %struct.GlobalMemory* %100, i32 0, i32 1
  %call217 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* %idlock, %union.pthread_mutexattr_t* null)
  %101 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %101, i32 0, i32 0
  store i32 0, i32* %id, align 4
  %102 = load i32* @N, align 4
  %103 = load double** @x, align 8
  %call218 = call i32 @InitX(i32 %102, double* %103)
  %104 = load i32* @test_result, align 4
  %tobool219 = icmp ne i32 %104, 0
  br i1 %tobool219, label %if.then.220, label %if.end.222

if.then.220:                                      ; preds = %if.end.210
  %105 = load i32* @N, align 4
  %106 = load double** @x, align 8
  %call221 = call double @CheckSum(i32 %105, double* %106)
  store double %call221, double* @ck1, align 8
  br label %if.end.222

if.end.222:                                       ; preds = %if.then.220, %if.end.210
  %107 = load i32* @doprint, align 4
  %tobool223 = icmp ne i32 %107, 0
  br i1 %tobool223, label %if.then.224, label %if.end.227

if.then.224:                                      ; preds = %if.end.222
  %call225 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([23 x i8]* @.str.38, i32 0, i32 0))
  %108 = load i32* @N, align 4
  %109 = load double** @x, align 8
  %call226 = call i32 @PrintArray(i32 %108, double* %109)
  br label %if.end.227

if.end.227:                                       ; preds = %if.then.224, %if.end.222
  store i32 2, i32* @P
  %110 = load i32* @N, align 4
  %111 = load double** @umain, align 8
  %call228 = call i32 @InitU(i32 %110, double* %111)
  %112 = load i32* @N, align 4
  %113 = load double** @umain2, align 8
  %114 = load i32* @rootN, align 4
  %call229 = call i32 @InitU2(i32 %112, double* %113, i32 %114)
  %call230 = call i64 *@pthread_self()
  %call231 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([9 x i8]* @.str.39, i32 0, i32 0), i64 %call230)
  store i32 1, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.227
  %115 = load i32* %i, align 4
  %116 = load i32* @P, align 4
  %cmp232 = icmp slt i32 %115, %116
  br i1 %cmp232, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call234 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %117 = load i32* %i, align 4
  %inc235 = add nsw i32 %117, 1
  store i32 %inc235, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @SlaveStart()
  %118 = load i32* @doprint, align 4
  %tobool236 = icmp ne i32 %118, 0
  br i1 %tobool236, label %if.then.237, label %if.end.245

if.then.237:                                      ; preds = %for.end
  %119 = load i32* @test_result, align 4
  %tobool238 = icmp ne i32 %119, 0
  br i1 %tobool238, label %if.then.239, label %if.else.241

if.then.239:                                      ; preds = %if.then.237
  %call240 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([32 x i8]* @.str.40, i32 0, i32 0))
  br label %if.end.243

if.else.241:                                      ; preds = %if.then.237
  %call242 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([24 x i8]* @.str.41, i32 0, i32 0))
  br label %if.end.243

if.end.243:                                       ; preds = %if.else.241, %if.then.239
  %120 = load i32* @N, align 4
  %121 = load double** @x, align 8
  %call244 = call i32 @PrintArray(i32 %120, double* %121)
  br label %if.end.245

if.end.245:                                       ; preds = %if.end.243, %for.end
  %122 = load %struct.GlobalMemory** @Global, align 8
  %transtimes246 = getelementptr inbounds %struct.GlobalMemory* %122, i32 0, i32 3
  %123 = load i32** %transtimes246, align 8
  %arrayidx = getelementptr inbounds i32* %123, i64 0
  %124 = load i32* %arrayidx, align 4
  store i32 %124, i32* @transtime, align 4
  %call247 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %call248 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([37 x i8]* @.str.42, i32 0, i32 0))
  %call249 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([54 x i8]* @.str.43, i32 0, i32 0))
  %call250 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([53 x i8]* @.str.44, i32 0, i32 0))
  %125 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes251 = getelementptr inbounds %struct.GlobalMemory* %125, i32 0, i32 4
  %126 = load i32** %totaltimes251, align 8
  %arrayidx252 = getelementptr inbounds i32* %126, i64 0
  %127 = load i32* %arrayidx252, align 4
  %128 = load %struct.GlobalMemory** @Global, align 8
  %transtimes253 = getelementptr inbounds %struct.GlobalMemory* %128, i32 0, i32 3
  %129 = load i32** %transtimes253, align 8
  %arrayidx254 = getelementptr inbounds i32* %129, i64 0
  %130 = load i32* %arrayidx254, align 4
  %131 = load %struct.GlobalMemory** @Global, align 8
  %transtimes255 = getelementptr inbounds %struct.GlobalMemory* %131, i32 0, i32 3
  %132 = load i32** %transtimes255, align 8
  %arrayidx256 = getelementptr inbounds i32* %132, i64 0
  %133 = load i32* %arrayidx256, align 4
  %conv257 = sitofp i32 %133 to double
  %134 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes258 = getelementptr inbounds %struct.GlobalMemory* %134, i32 0, i32 4
  %135 = load i32** %totaltimes258, align 8
  %arrayidx259 = getelementptr inbounds i32* %135, i64 0
  %136 = load i32* %arrayidx259, align 4
  %conv260 = sitofp i32 %136 to double
  %div261 = fdiv double %conv257, %conv260
  %call262 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([39 x i8]* @.str.45, i32 0, i32 0), i32 %127, i32 %130, double %div261)
  %137 = load i32* @dostats, align 4
  %tobool263 = icmp ne i32 %137, 0
  br i1 %tobool263, label %if.then.264, label %if.end.431

if.then.264:                                      ; preds = %if.end.245
  %138 = load %struct.GlobalMemory** @Global, align 8
  %transtimes265 = getelementptr inbounds %struct.GlobalMemory* %138, i32 0, i32 3
  %139 = load i32** %transtimes265, align 8
  %arrayidx266 = getelementptr inbounds i32* %139, i64 0
  %140 = load i32* %arrayidx266, align 4
  store i32 %140, i32* @transtime2, align 4
  %141 = load %struct.GlobalMemory** @Global, align 8
  %transtimes267 = getelementptr inbounds %struct.GlobalMemory* %141, i32 0, i32 3
  %142 = load i32** %transtimes267, align 8
  %arrayidx268 = getelementptr inbounds i32* %142, i64 0
  %143 = load i32* %arrayidx268, align 4
  store i32 %143, i32* @avgtranstime, align 4
  %144 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes269 = getelementptr inbounds %struct.GlobalMemory* %144, i32 0, i32 4
  %145 = load i32** %totaltimes269, align 8
  %arrayidx270 = getelementptr inbounds i32* %145, i64 0
  %146 = load i32* %arrayidx270, align 4
  store i32 %146, i32* @avgcomptime, align 4
  %147 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes271 = getelementptr inbounds %struct.GlobalMemory* %147, i32 0, i32 4
  %148 = load i32** %totaltimes271, align 8
  %arrayidx272 = getelementptr inbounds i32* %148, i64 0
  %149 = load i32* %arrayidx272, align 4
  store i32 %149, i32* @maxtotal, align 4
  %150 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes273 = getelementptr inbounds %struct.GlobalMemory* %150, i32 0, i32 4
  %151 = load i32** %totaltimes273, align 8
  %arrayidx274 = getelementptr inbounds i32* %151, i64 0
  %152 = load i32* %arrayidx274, align 4
  store i32 %152, i32* @mintotal, align 4
  %153 = load %struct.GlobalMemory** @Global, align 8
  %transtimes275 = getelementptr inbounds %struct.GlobalMemory* %153, i32 0, i32 3
  %154 = load i32** %transtimes275, align 8
  %arrayidx276 = getelementptr inbounds i32* %154, i64 0
  %155 = load i32* %arrayidx276, align 4
  %conv277 = sitofp i32 %155 to double
  %156 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes278 = getelementptr inbounds %struct.GlobalMemory* %156, i32 0, i32 4
  %157 = load i32** %totaltimes278, align 8
  %arrayidx279 = getelementptr inbounds i32* %157, i64 0
  %158 = load i32* %arrayidx279, align 4
  %conv280 = sitofp i32 %158 to double
  %div281 = fdiv double %conv277, %conv280
  store double %div281, double* @maxfrac, align 8
  %159 = load %struct.GlobalMemory** @Global, align 8
  %transtimes282 = getelementptr inbounds %struct.GlobalMemory* %159, i32 0, i32 3
  %160 = load i32** %transtimes282, align 8
  %arrayidx283 = getelementptr inbounds i32* %160, i64 0
  %161 = load i32* %arrayidx283, align 4
  %conv284 = sitofp i32 %161 to double
  %162 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes285 = getelementptr inbounds %struct.GlobalMemory* %162, i32 0, i32 4
  %163 = load i32** %totaltimes285, align 8
  %arrayidx286 = getelementptr inbounds i32* %163, i64 0
  %164 = load i32* %arrayidx286, align 4
  %conv287 = sitofp i32 %164 to double
  %div288 = fdiv double %conv284, %conv287
  store double %div288, double* @minfrac, align 8
  %165 = load %struct.GlobalMemory** @Global, align 8
  %transtimes289 = getelementptr inbounds %struct.GlobalMemory* %165, i32 0, i32 3
  %166 = load i32** %transtimes289, align 8
  %arrayidx290 = getelementptr inbounds i32* %166, i64 0
  %167 = load i32* %arrayidx290, align 4
  %conv291 = sitofp i32 %167 to double
  %168 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes292 = getelementptr inbounds %struct.GlobalMemory* %168, i32 0, i32 4
  %169 = load i32** %totaltimes292, align 8
  %arrayidx293 = getelementptr inbounds i32* %169, i64 0
  %170 = load i32* %arrayidx293, align 4
  %conv294 = sitofp i32 %170 to double
  %div295 = fdiv double %conv291, %conv294
  store double %div295, double* @avgfractime, align 8
  store i32 1, i32* %i, align 4
  br label %for.cond.296

for.cond.296:                                     ; preds = %for.inc.417, %if.then.264
  %171 = load i32* %i, align 4
  %172 = load i32* @P, align 4
  %cmp297 = icmp slt i32 %171, %172
  br i1 %cmp297, label %for.body.299, label %for.end.419

for.body.299:                                     ; preds = %for.cond.296
  %173 = load i32* %i, align 4
  %idxprom = sext i32 %173 to i64
  %174 = load %struct.GlobalMemory** @Global, align 8
  %transtimes300 = getelementptr inbounds %struct.GlobalMemory* %174, i32 0, i32 3
  %175 = load i32** %transtimes300, align 8
  %arrayidx301 = getelementptr inbounds i32* %175, i64 %idxprom
  %176 = load i32* %arrayidx301, align 4
  %177 = load i32* @transtime, align 4
  %cmp302 = icmp sgt i32 %176, %177
  br i1 %cmp302, label %if.then.304, label %if.end.308

if.then.304:                                      ; preds = %for.body.299
  %178 = load i32* %i, align 4
  %idxprom305 = sext i32 %178 to i64
  %179 = load %struct.GlobalMemory** @Global, align 8
  %transtimes306 = getelementptr inbounds %struct.GlobalMemory* %179, i32 0, i32 3
  %180 = load i32** %transtimes306, align 8
  %arrayidx307 = getelementptr inbounds i32* %180, i64 %idxprom305
  %181 = load i32* %arrayidx307, align 4
  store i32 %181, i32* @transtime, align 4
  br label %if.end.308

if.end.308:                                       ; preds = %if.then.304, %for.body.299
  %182 = load i32* %i, align 4
  %idxprom309 = sext i32 %182 to i64
  %183 = load %struct.GlobalMemory** @Global, align 8
  %transtimes310 = getelementptr inbounds %struct.GlobalMemory* %183, i32 0, i32 3
  %184 = load i32** %transtimes310, align 8
  %arrayidx311 = getelementptr inbounds i32* %184, i64 %idxprom309
  %185 = load i32* %arrayidx311, align 4
  %186 = load i32* @transtime2, align 4
  %cmp312 = icmp slt i32 %185, %186
  br i1 %cmp312, label %if.then.314, label %if.end.318

if.then.314:                                      ; preds = %if.end.308
  %187 = load i32* %i, align 4
  %idxprom315 = sext i32 %187 to i64
  %188 = load %struct.GlobalMemory** @Global, align 8
  %transtimes316 = getelementptr inbounds %struct.GlobalMemory* %188, i32 0, i32 3
  %189 = load i32** %transtimes316, align 8
  %arrayidx317 = getelementptr inbounds i32* %189, i64 %idxprom315
  %190 = load i32* %arrayidx317, align 4
  store i32 %190, i32* @transtime2, align 4
  br label %if.end.318

if.end.318:                                       ; preds = %if.then.314, %if.end.308
  %191 = load i32* %i, align 4
  %idxprom319 = sext i32 %191 to i64
  %192 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes320 = getelementptr inbounds %struct.GlobalMemory* %192, i32 0, i32 4
  %193 = load i32** %totaltimes320, align 8
  %arrayidx321 = getelementptr inbounds i32* %193, i64 %idxprom319
  %194 = load i32* %arrayidx321, align 4
  %195 = load i32* @maxtotal, align 4
  %cmp322 = icmp sgt i32 %194, %195
  br i1 %cmp322, label %if.then.324, label %if.end.328

if.then.324:                                      ; preds = %if.end.318
  %196 = load i32* %i, align 4
  %idxprom325 = sext i32 %196 to i64
  %197 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes326 = getelementptr inbounds %struct.GlobalMemory* %197, i32 0, i32 4
  %198 = load i32** %totaltimes326, align 8
  %arrayidx327 = getelementptr inbounds i32* %198, i64 %idxprom325
  %199 = load i32* %arrayidx327, align 4
  store i32 %199, i32* @maxtotal, align 4
  br label %if.end.328

if.end.328:                                       ; preds = %if.then.324, %if.end.318
  %200 = load i32* %i, align 4
  %idxprom329 = sext i32 %200 to i64
  %201 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes330 = getelementptr inbounds %struct.GlobalMemory* %201, i32 0, i32 4
  %202 = load i32** %totaltimes330, align 8
  %arrayidx331 = getelementptr inbounds i32* %202, i64 %idxprom329
  %203 = load i32* %arrayidx331, align 4
  %204 = load i32* @mintotal, align 4
  %cmp332 = icmp slt i32 %203, %204
  br i1 %cmp332, label %if.then.334, label %if.end.338

if.then.334:                                      ; preds = %if.end.328
  %205 = load i32* %i, align 4
  %idxprom335 = sext i32 %205 to i64
  %206 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes336 = getelementptr inbounds %struct.GlobalMemory* %206, i32 0, i32 4
  %207 = load i32** %totaltimes336, align 8
  %arrayidx337 = getelementptr inbounds i32* %207, i64 %idxprom335
  %208 = load i32* %arrayidx337, align 4
  store i32 %208, i32* @mintotal, align 4
  br label %if.end.338

if.end.338:                                       ; preds = %if.then.334, %if.end.328
  %209 = load i32* %i, align 4
  %idxprom339 = sext i32 %209 to i64
  %210 = load %struct.GlobalMemory** @Global, align 8
  %transtimes340 = getelementptr inbounds %struct.GlobalMemory* %210, i32 0, i32 3
  %211 = load i32** %transtimes340, align 8
  %arrayidx341 = getelementptr inbounds i32* %211, i64 %idxprom339
  %212 = load i32* %arrayidx341, align 4
  %conv342 = sitofp i32 %212 to double
  %213 = load i32* %i, align 4
  %idxprom343 = sext i32 %213 to i64
  %214 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes344 = getelementptr inbounds %struct.GlobalMemory* %214, i32 0, i32 4
  %215 = load i32** %totaltimes344, align 8
  %arrayidx345 = getelementptr inbounds i32* %215, i64 %idxprom343
  %216 = load i32* %arrayidx345, align 4
  %conv346 = sitofp i32 %216 to double
  %div347 = fdiv double %conv342, %conv346
  %217 = load double* @maxfrac, align 8
  %cmp348 = fcmp ogt double %div347, %217
  br i1 %cmp348, label %if.then.350, label %if.end.360

if.then.350:                                      ; preds = %if.end.338
  %218 = load i32* %i, align 4
  %idxprom351 = sext i32 %218 to i64
  %219 = load %struct.GlobalMemory** @Global, align 8
  %transtimes352 = getelementptr inbounds %struct.GlobalMemory* %219, i32 0, i32 3
  %220 = load i32** %transtimes352, align 8
  %arrayidx353 = getelementptr inbounds i32* %220, i64 %idxprom351
  %221 = load i32* %arrayidx353, align 4
  %conv354 = sitofp i32 %221 to double
  %222 = load i32* %i, align 4
  %idxprom355 = sext i32 %222 to i64
  %223 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes356 = getelementptr inbounds %struct.GlobalMemory* %223, i32 0, i32 4
  %224 = load i32** %totaltimes356, align 8
  %arrayidx357 = getelementptr inbounds i32* %224, i64 %idxprom355
  %225 = load i32* %arrayidx357, align 4
  %conv358 = sitofp i32 %225 to double
  %div359 = fdiv double %conv354, %conv358
  store double %div359, double* @maxfrac, align 8
  br label %if.end.360

if.end.360:                                       ; preds = %if.then.350, %if.end.338
  %226 = load i32* %i, align 4
  %idxprom361 = sext i32 %226 to i64
  %227 = load %struct.GlobalMemory** @Global, align 8
  %transtimes362 = getelementptr inbounds %struct.GlobalMemory* %227, i32 0, i32 3
  %228 = load i32** %transtimes362, align 8
  %arrayidx363 = getelementptr inbounds i32* %228, i64 %idxprom361
  %229 = load i32* %arrayidx363, align 4
  %conv364 = sitofp i32 %229 to double
  %230 = load i32* %i, align 4
  %idxprom365 = sext i32 %230 to i64
  %231 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes366 = getelementptr inbounds %struct.GlobalMemory* %231, i32 0, i32 4
  %232 = load i32** %totaltimes366, align 8
  %arrayidx367 = getelementptr inbounds i32* %232, i64 %idxprom365
  %233 = load i32* %arrayidx367, align 4
  %conv368 = sitofp i32 %233 to double
  %div369 = fdiv double %conv364, %conv368
  %234 = load double* @minfrac, align 8
  %cmp370 = fcmp olt double %div369, %234
  br i1 %cmp370, label %if.then.372, label %if.end.382

if.then.372:                                      ; preds = %if.end.360
  %235 = load i32* %i, align 4
  %idxprom373 = sext i32 %235 to i64
  %236 = load %struct.GlobalMemory** @Global, align 8
  %transtimes374 = getelementptr inbounds %struct.GlobalMemory* %236, i32 0, i32 3
  %237 = load i32** %transtimes374, align 8
  %arrayidx375 = getelementptr inbounds i32* %237, i64 %idxprom373
  %238 = load i32* %arrayidx375, align 4
  %conv376 = sitofp i32 %238 to double
  %239 = load i32* %i, align 4
  %idxprom377 = sext i32 %239 to i64
  %240 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes378 = getelementptr inbounds %struct.GlobalMemory* %240, i32 0, i32 4
  %241 = load i32** %totaltimes378, align 8
  %arrayidx379 = getelementptr inbounds i32* %241, i64 %idxprom377
  %242 = load i32* %arrayidx379, align 4
  %conv380 = sitofp i32 %242 to double
  %div381 = fdiv double %conv376, %conv380
  store double %div381, double* @minfrac, align 8
  br label %if.end.382

if.end.382:                                       ; preds = %if.then.372, %if.end.360
  %243 = load i32* %i, align 4
  %244 = load i32* %i, align 4
  %idxprom383 = sext i32 %244 to i64
  %245 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes384 = getelementptr inbounds %struct.GlobalMemory* %245, i32 0, i32 4
  %246 = load i32** %totaltimes384, align 8
  %arrayidx385 = getelementptr inbounds i32* %246, i64 %idxprom383
  %247 = load i32* %arrayidx385, align 4
  %248 = load i32* %i, align 4
  %idxprom386 = sext i32 %248 to i64
  %249 = load %struct.GlobalMemory** @Global, align 8
  %transtimes387 = getelementptr inbounds %struct.GlobalMemory* %249, i32 0, i32 3
  %250 = load i32** %transtimes387, align 8
  %arrayidx388 = getelementptr inbounds i32* %250, i64 %idxprom386
  %251 = load i32* %arrayidx388, align 4
  %252 = load i32* %i, align 4
  %idxprom389 = sext i32 %252 to i64
  %253 = load %struct.GlobalMemory** @Global, align 8
  %transtimes390 = getelementptr inbounds %struct.GlobalMemory* %253, i32 0, i32 3
  %254 = load i32** %transtimes390, align 8
  %arrayidx391 = getelementptr inbounds i32* %254, i64 %idxprom389
  %255 = load i32* %arrayidx391, align 4
  %conv392 = sitofp i32 %255 to double
  %256 = load i32* %i, align 4
  %idxprom393 = sext i32 %256 to i64
  %257 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes394 = getelementptr inbounds %struct.GlobalMemory* %257, i32 0, i32 4
  %258 = load i32** %totaltimes394, align 8
  %arrayidx395 = getelementptr inbounds i32* %258, i64 %idxprom393
  %259 = load i32* %arrayidx395, align 4
  %conv396 = sitofp i32 %259 to double
  %div397 = fdiv double %conv392, %conv396
  %call398 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([39 x i8]* @.str.46, i32 0, i32 0), i32 %243, i32 %247, i32 %251, double %div397)
  %260 = load i32* %i, align 4
  %idxprom399 = sext i32 %260 to i64
  %261 = load %struct.GlobalMemory** @Global, align 8
  %transtimes400 = getelementptr inbounds %struct.GlobalMemory* %261, i32 0, i32 3
  %262 = load i32** %transtimes400, align 8
  %arrayidx401 = getelementptr inbounds i32* %262, i64 %idxprom399
  %263 = load i32* %arrayidx401, align 4
  %264 = load i32* @avgtranstime, align 4
  %add402 = add nsw i32 %264, %263
  store i32 %add402, i32* @avgtranstime, align 4
  %265 = load i32* %i, align 4
  %idxprom403 = sext i32 %265 to i64
  %266 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes404 = getelementptr inbounds %struct.GlobalMemory* %266, i32 0, i32 4
  %267 = load i32** %totaltimes404, align 8
  %arrayidx405 = getelementptr inbounds i32* %267, i64 %idxprom403
  %268 = load i32* %arrayidx405, align 4
  %269 = load i32* @avgcomptime, align 4
  %add406 = add nsw i32 %269, %268
  store i32 %add406, i32* @avgcomptime, align 4
  %270 = load i32* %i, align 4
  %idxprom407 = sext i32 %270 to i64
  %271 = load %struct.GlobalMemory** @Global, align 8
  %transtimes408 = getelementptr inbounds %struct.GlobalMemory* %271, i32 0, i32 3
  %272 = load i32** %transtimes408, align 8
  %arrayidx409 = getelementptr inbounds i32* %272, i64 %idxprom407
  %273 = load i32* %arrayidx409, align 4
  %conv410 = sitofp i32 %273 to double
  %274 = load i32* %i, align 4
  %idxprom411 = sext i32 %274 to i64
  %275 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes412 = getelementptr inbounds %struct.GlobalMemory* %275, i32 0, i32 4
  %276 = load i32** %totaltimes412, align 8
  %arrayidx413 = getelementptr inbounds i32* %276, i64 %idxprom411
  %277 = load i32* %arrayidx413, align 4
  %conv414 = sitofp i32 %277 to double
  %div415 = fdiv double %conv410, %conv414
  %278 = load double* @avgfractime, align 8
  %add416 = fadd double %278, %div415
  store double %add416, double* @avgfractime, align 8
  br label %for.inc.417

for.inc.417:                                      ; preds = %if.end.382
  %279 = load i32* %i, align 4
  %inc418 = add nsw i32 %279, 1
  store i32 %inc418, i32* %i, align 4
  br label %for.cond.296

for.end.419:                                      ; preds = %for.cond.296
  %280 = load i32* @avgcomptime, align 4
  %conv420 = sitofp i32 %280 to double
  %281 = load i32* @P, align 4
  %conv421 = sitofp i32 %281 to double
  %div422 = fdiv double %conv420, %conv421
  %282 = load i32* @avgtranstime, align 4
  %conv423 = sitofp i32 %282 to double
  %283 = load i32* @P, align 4
  %conv424 = sitofp i32 %283 to double
  %div425 = fdiv double %conv423, %conv424
  %284 = load double* @avgfractime, align 8
  %285 = load i32* @P, align 4
  %conv426 = sitofp i32 %285 to double
  %div427 = fdiv double %284, %conv426
  %call428 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([43 x i8]* @.str.47, i32 0, i32 0), double %div422, double %div425, double %div427)
  %286 = load i32* @maxtotal, align 4
  %287 = load i32* @transtime, align 4
  %288 = load double* @maxfrac, align 8
  %call429 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([39 x i8]* @.str.48, i32 0, i32 0), i32 %286, i32 %287, double %288)
  %289 = load i32* @mintotal, align 4
  %290 = load i32* @transtime2, align 4
  %291 = load double* @minfrac, align 8
  %call430 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([39 x i8]* @.str.49, i32 0, i32 0), i32 %289, i32 %290, double %291)
  br label %if.end.431

if.end.431:                                       ; preds = %for.end.419, %if.end.245
  %292 = load i32* %start, align 4
  %293 = load %struct.GlobalMemory** @Global, align 8
  %starttime = getelementptr inbounds %struct.GlobalMemory* %293, i32 0, i32 5
  store i32 %292, i32* %starttime, align 4
  %call432 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %call433 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([37 x i8]* @.str.50, i32 0, i32 0))
  %294 = load %struct.GlobalMemory** @Global, align 8
  %starttime434 = getelementptr inbounds %struct.GlobalMemory* %294, i32 0, i32 5
  %295 = load i32* %starttime434, align 4
  %call435 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.51, i32 0, i32 0), i32 %295)
  %296 = load %struct.GlobalMemory** @Global, align 8
  %initdonetime = getelementptr inbounds %struct.GlobalMemory* %296, i32 0, i32 7
  %297 = load i32* %initdonetime, align 4
  %call436 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.52, i32 0, i32 0), i32 %297)
  %298 = load %struct.GlobalMemory** @Global, align 8
  %finishtime = getelementptr inbounds %struct.GlobalMemory* %298, i32 0, i32 6
  %299 = load i32* %finishtime, align 4
  %call437 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.53, i32 0, i32 0), i32 %299)
  %300 = load %struct.GlobalMemory** @Global, align 8
  %finishtime438 = getelementptr inbounds %struct.GlobalMemory* %300, i32 0, i32 6
  %301 = load i32* %finishtime438, align 4
  %302 = load %struct.GlobalMemory** @Global, align 8
  %starttime439 = getelementptr inbounds %struct.GlobalMemory* %302, i32 0, i32 5
  %303 = load i32* %starttime439, align 4
  %sub440 = sub nsw i32 %301, %303
  %call441 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.54, i32 0, i32 0), i32 %sub440)
  %304 = load %struct.GlobalMemory** @Global, align 8
  %finishtime442 = getelementptr inbounds %struct.GlobalMemory* %304, i32 0, i32 6
  %305 = load i32* %finishtime442, align 4
  %306 = load %struct.GlobalMemory** @Global, align 8
  %initdonetime443 = getelementptr inbounds %struct.GlobalMemory* %306, i32 0, i32 7
  %307 = load i32* %initdonetime443, align 4
  %sub444 = sub nsw i32 %305, %307
  %call445 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.55, i32 0, i32 0), i32 %sub444)
  %308 = load i32* @transtime, align 4
  %call446 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.56, i32 0, i32 0), i32 %308)
  %309 = load i32* @transtime, align 4
  %conv447 = sitofp i32 %309 to double
  %310 = load %struct.GlobalMemory** @Global, align 8
  %finishtime448 = getelementptr inbounds %struct.GlobalMemory* %310, i32 0, i32 6
  %311 = load i32* %finishtime448, align 4
  %312 = load %struct.GlobalMemory** @Global, align 8
  %initdonetime449 = getelementptr inbounds %struct.GlobalMemory* %312, i32 0, i32 7
  %313 = load i32* %initdonetime449, align 4
  %sub450 = sub nsw i32 %311, %313
  %conv451 = sitofp i32 %sub450 to double
  %div452 = fdiv double %conv447, %conv451
  %call453 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([44 x i8]* @.str.57, i32 0, i32 0), double %div452)
  %call454 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %314 = load i32* @test_result, align 4
  %tobool455 = icmp ne i32 %314, 0
  br i1 %tobool455, label %if.then.456, label %if.end.470

if.then.456:                                      ; preds = %if.end.431
  %315 = load i32* @N, align 4
  %316 = load double** @x, align 8
  %call457 = call double @CheckSum(i32 %315, double* %316)
  store double %call457, double* @ck3, align 8
  %call458 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([40 x i8]* @.str.58, i32 0, i32 0))
  %317 = load double* @ck1, align 8
  %318 = load double* @ck3, align 8
  %sub459 = fsub double %317, %318
  %319 = load double* @ck1, align 8
  %320 = load double* @ck3, align 8
  %call460 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.59, i32 0, i32 0), double %sub459, double %319, double %320)
  %321 = load double* @ck1, align 8
  %322 = load double* @ck3, align 8
  %sub461 = fsub double %321, %322
  %call462 = call double @fabs(double %sub461)
  %cmp463 = fcmp olt double %call462, 1.000000e-03
  br i1 %cmp463, label %if.then.465, label %if.else.467

if.then.465:                                      ; preds = %if.then.456
  %call466 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([13 x i8]* @.str.60, i32 0, i32 0))
  br label %if.end.469

if.else.467:                                      ; preds = %if.then.456
  %call468 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([13 x i8]* @.str.61, i32 0, i32 0))
  br label %if.end.469

if.end.469:                                       ; preds = %if.else.467, %if.then.465
  br label %if.end.470

if.end.470:                                       ; preds = %if.end.469, %if.end.431
  %323 = load %struct._IO_FILE** @stdout, align 8
  %call471 = call i32 @fflush(%struct._IO_FILE* %323)
  call void @exit(i32 0)
  br label %UnifiedUnreachableBlock

return:                                           ; No predecessors!
  %324 = load i32* %retval
  call void @waitForAll()
  ret i32 %324

UnifiedUnreachableBlock:                          ; preds = %if.end.470, %if.then.184, %if.then.180, %if.then.176, %if.then.172, %if.then.168, %if.then.131, %if.then.57, %sw.bb.38, %if.then.27, %if.then.21, %if.then.15, %if.then.9, %if.then
  call void @waitForAll()
  call void @waitForAll()
  unreachable
}

; Function Attrs: nounwind
declare i64 @time(i64*)

declare i32 @getopt(...)

declare i32 @atoi(...)

; Function Attrs: nounwind uwtable
define internal void @printerr(i8* %s) {
entry:
  %s.addr = alloca i8*, align 8
  store i8* %s, i8** %s.addr, align 8
  %0 = load %struct._IO_FILE** @stderr, align 8
  %1 = load i8** %s.addr, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([11 x i8]* @.str.66, i32 0, i32 0), i8* %1)
  ret void
}

; Function Attrs: noreturn
declare void @exit(i32)

; Function Attrs: nounwind uwtable
define internal i32 @log_2(i32 %number) {
entry:
  %retval = alloca i32, align 4
  %number.addr = alloca i32, align 4
  %cumulative = alloca i32, align 4
  %out = alloca i32, align 4
  %done = alloca i32, align 4
  store i32 %number, i32* %number.addr, align 4
  store i32 1, i32* %cumulative, align 4
  store i32 0, i32* %out, align 4
  store i32 0, i32* %done, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32* %cumulative, align 4
  %1 = load i32* %number.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %land.lhs.true, label %land.end

land.lhs.true:                                    ; preds = %while.cond
  %2 = load i32* %done, align 4
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %land.end, label %land.rhs

land.rhs:                                         ; preds = %land.lhs.true
  %3 = load i32* %out, align 4
  %cmp1 = icmp slt i32 %3, 50
  br label %land.end

land.end:                                         ; preds = %land.rhs, %land.lhs.true, %while.cond
  %4 = phi i1 [ false, %land.lhs.true ], [ false, %while.cond ], [ %cmp1, %land.rhs ]
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %5 = load i32* %cumulative, align 4
  %6 = load i32* %number.addr, align 4
  %cmp2 = icmp eq i32 %5, %6
  br i1 %cmp2, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  store i32 1, i32* %done, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %7 = load i32* %cumulative, align 4
  %mul = mul nsw i32 %7, 2
  store i32 %mul, i32* %cumulative, align 4
  %8 = load i32* %out, align 4
  %inc = add nsw i32 %8, 1
  store i32 %inc, i32* %out, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond

while.end:                                        ; preds = %land.end
  %9 = load i32* %cumulative, align 4
  %10 = load i32* %number.addr, align 4
  %cmp3 = icmp eq i32 %9, %10
  br i1 %cmp3, label %if.then.4, label %if.else.5

if.then.4:                                        ; preds = %while.end
  %11 = load i32* %out, align 4
  store i32 %11, i32* %retval
  br label %return

if.else.5:                                        ; preds = %while.end
  store i32 -1, i32* %retval
  br label %return

return:                                           ; preds = %if.else.5, %if.then.4
  %12 = load i32* %retval
  ret i32 %12
}

declare i32 @printf(i8*, ...)

declare i8* @malloc(i64)

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*)

; Function Attrs: nounwind readnone
declare i64 @pthread_self()

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: nounwind readnone
declare double @fabs(double)

declare i32 @fflush(%struct._IO_FILE*)

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
  %start = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 2
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
  %start3 = getelementptr inbounds %struct.GlobalMemory* %5, i32 0, i32 2
  %count4 = getelementptr inbounds %struct.barrier_t* %start3, i32 0, i32 1
  call void @RecordSyncVariable()
  store volatile i64 %conv2, i64* %count4, align 8
  call void @snapshot64(i64 %conv2, i32 0)
  %6 = load i32* %oldcount.addr, align 4
  store i32 %6, i32* %updatedcount, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %7 = load %struct.GlobalMemory** @Global, align 8
  %start5 = getelementptr inbounds %struct.GlobalMemory* %7, i32 0, i32 2
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
  %MyNum = alloca i32, align 4
  %error = alloca double, align 8
  %upriv = alloca double*, align 8
  %initdone = alloca i32, align 4
  %finish = alloca i32, align 4
  %l_transtime = alloca i32, align 4
  %MyFirst = alloca i32, align 4
  %MyLast = alloca i32, align 4
  %k = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense49 = alloca i32, align 4
  %oldcount54 = alloca i32, align 4
  %newcount58 = alloca i32, align 4
  %updatedcount60 = alloca i32, align 4
  store i32 0, i32* %l_transtime, align 4
  %call = call i64 *@pthread_self()
  %call1 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([4 x i8]* @.str.62, i32 0, i32 0), i64 %call)
  %0 = load %struct.GlobalMemory** @Global, align 8
  %idlock = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 1
  %call2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %idlock)
  %1 = load %struct.GlobalMemory** @Global, align 8
  %id = getelementptr inbounds %struct.GlobalMemory* %1, i32 0, i32 0
  %2 = load i32* %id, align 4
  store i32 %2, i32* %MyNum, align 4
  %3 = load %struct.GlobalMemory** @Global, align 8
  %id3 = getelementptr inbounds %struct.GlobalMemory* %3, i32 0, i32 0
  %4 = load i32* %id3, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %id3, align 4
  %5 = load %struct.GlobalMemory** @Global, align 8
  %idlock4 = getelementptr inbounds %struct.GlobalMemory* %5, i32 0, i32 1
  %call5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %idlock4)
  %6 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %6, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 1)
  call void @IncrementCounter()
  call void @printChar(i8 signext 49)
  call void @printChar(i8 signext 90)
  %7 = load volatile i32* %gsense, align 4
  store i32 %7, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.21, %entry
  %8 = load %struct.GlobalMemory** @Global, align 8
  %start6 = getelementptr inbounds %struct.GlobalMemory* %8, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start6, i32 0, i32 1
  %9 = load volatile i64* %count, align 8
  %call3 = call i32 @sleep(i32 1)
  %conv = trunc i64 %9 to i32
  store i32 %conv, i32* %oldcount, align 4
  %10 = load i32* %oldcount, align 4
  %11 = load i32* %lsense, align 4
  %add = add nsw i32 %10, %11
  store i32 %add, i32* %newcount, align 4
  %12 = load i32* %oldcount, align 4
  %13 = load i32* %newcount, align 4
  %call7 = call i32 @atomic_cmpxchg(i32 %12, i32 %13)
  %call10 = call i32 @sleep(i32 1)
  store i32 %call7, i32* %updatedcount, align 4
  %14 = load i32* %updatedcount, align 4
  %15 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %14, %15
  br i1 %cmp, label %if.then, label %if.end.21

if.then:                                          ; preds = %while.body
  %16 = load i32* %newcount, align 4
  %17 = load i32* @P, align 4
  %call4 = call i32 @sleep(i32 1)
  %cmp9 = icmp eq i32 %16, %17
  br i1 %cmp9, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %18 = load i32* %lsense, align 4
  %cmp11 = icmp eq i32 %18, 1
  br i1 %cmp11, label %if.then.18, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %19 = load i32* %newcount, align 4
  %cmp13 = icmp eq i32 %19, 0
  br i1 %cmp13, label %land.lhs.true.15, label %if.end

land.lhs.true.15:                                 ; preds = %lor.lhs.false
  %20 = load i32* %lsense, align 4
  %cmp16 = icmp eq i32 %20, -1
  br i1 %cmp16, label %if.then.18, label %if.end

if.then.18:                                       ; preds = %land.lhs.true.15, %land.lhs.true
  %21 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %21
  %22 = load %struct.GlobalMemory** @Global, align 8
  %start19 = getelementptr inbounds %struct.GlobalMemory* %22, i32 0, i32 2
  %gsense20 = getelementptr inbounds %struct.barrier_t* %start19, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub, i32* %gsense20, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call6 = call i32 @sleep(i32 3)
  br label %if.end

if.end:                                           ; preds = %if.then.18, %land.lhs.true.15, %lor.lhs.false
  br label %while.end

if.end.21:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.26, %while.end
  %23 = load %struct.GlobalMemory** @Global, align 8
  %start22 = getelementptr inbounds %struct.GlobalMemory* %23, i32 0, i32 2
  %gsense23 = getelementptr inbounds %struct.barrier_t* %start22, i32 0, i32 0
  %24 = load volatile i32* %gsense23, align 4
  %25 = load i32* %lsense, align 4
  %cmp24 = icmp eq i32 %24, %25
  br i1 %cmp24, label %while.body.26, label %while.end.27

while.body.26:                                    ; preds = %while.cond
  %call8 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.27:                                     ; preds = %while.cond
  call void @printY()
  %call9 = call i32 @sleep(i32 4)
  %26 = load i32* @rootN, align 4
  %sub28 = sub nsw i32 %26, 1
  %mul = mul nsw i32 2, %sub28
  %conv29 = sext i32 %mul to i64
  %mul30 = mul i64 %conv29, 8
  %call31 = call i8* @malloc(i64 %mul30)
  %27 = bitcast i8* %call31 to double*
  store double* %27, double** %upriv, align 8
  %28 = load double** %upriv, align 8
  %cmp32 = icmp eq double* %28, null
  br i1 %cmp32, label %if.then.34, label %if.end.36

if.then.34:                                       ; preds = %while.end.27
  %29 = load %struct._IO_FILE** @stderr, align 8
  %30 = load i32* %MyNum, align 4
  %call35 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([43 x i8]* @.str.63, i32 0, i32 0), i32 %30)
  call void @exit(i32 -1)
  unreachable

if.end.36:                                        ; preds = %while.end.27
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.36
  %31 = load i32* %i, align 4
  %32 = load i32* @rootN, align 4
  %sub37 = sub nsw i32 %32, 1
  %mul38 = mul nsw i32 2, %sub37
  %cmp39 = icmp slt i32 %31, %mul38
  br i1 %cmp39, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %33 = load i32* %i, align 4
  %idxprom = sext i32 %33 to i64
  %34 = load double** @umain, align 8
  %arrayidx = getelementptr inbounds double* %34, i64 %idxprom
  %35 = load double* %arrayidx, align 8
  %36 = load i32* %i, align 4
  %idxprom41 = sext i32 %36 to i64
  %37 = load double** %upriv, align 8
  %arrayidx42 = getelementptr inbounds double* %37, i64 %idxprom41
  store double %35, double* %arrayidx42, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %38 = load i32* %i, align 4
  %inc43 = add nsw i32 %38, 1
  store i32 %inc43, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %39 = load i32* @rootN, align 4
  %40 = load i32* %MyNum, align 4
  %mul44 = mul nsw i32 %39, %40
  %41 = load i32* @P, align 4
  %div = sdiv i32 %mul44, %41
  store i32 %div, i32* %MyFirst, align 4
  %42 = load i32* @rootN, align 4
  %43 = load i32* %MyNum, align 4
  %add45 = add nsw i32 %43, 1
  %mul46 = mul nsw i32 %42, %add45
  %44 = load i32* @P, align 4
  %div47 = sdiv i32 %mul46, %44
  store i32 %div47, i32* %MyLast, align 4
  %45 = load double** @x, align 8
  %46 = load double** @trans, align 8
  %47 = load double** @umain2, align 8
  %48 = load double** %upriv, align 8
  %49 = load i32* @N, align 4
  %50 = load i32* %MyNum, align 4
  %51 = load i32* %MyFirst, align 4
  %52 = load i32* %MyLast, align 4
  %call48 = call double @TouchArray(double* %45, double* %46, double* %47, double* %48, i32 %49, i32 %50, i32 %51, i32 %52)
  %53 = load %struct.GlobalMemory** @Global, align 8
  %start50 = getelementptr inbounds %struct.GlobalMemory* %53, i32 0, i32 2
  %gsense51 = getelementptr inbounds %struct.barrier_t* %start50, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 2)
  call void @IncrementCounter()
  call void @printChar(i8 signext 50)
  call void @printChar(i8 signext 90)
  %54 = load volatile i32* %gsense51, align 4
  store i32 %54, i32* %lsense49, align 4
  br label %while.body.53

while.body.53:                                    ; preds = %if.end.81, %for.end
  %55 = load %struct.GlobalMemory** @Global, align 8
  %start55 = getelementptr inbounds %struct.GlobalMemory* %55, i32 0, i32 2
  %count56 = getelementptr inbounds %struct.barrier_t* %start55, i32 0, i32 1
  %56 = load volatile i64* %count56, align 8
  %call11 = call i32 @sleep(i32 1)
  %conv57 = trunc i64 %56 to i32
  store i32 %conv57, i32* %oldcount54, align 4
  %57 = load i32* %oldcount54, align 4
  %58 = load i32* %lsense49, align 4
  %add59 = add nsw i32 %57, %58
  store i32 %add59, i32* %newcount58, align 4
  %59 = load i32* %oldcount54, align 4
  %60 = load i32* %newcount58, align 4
  %call61 = call i32 @atomic_cmpxchg(i32 %59, i32 %60)
  %call16 = call i32 @sleep(i32 1)
  store i32 %call61, i32* %updatedcount60, align 4
  %61 = load i32* %updatedcount60, align 4
  %62 = load i32* %oldcount54, align 4
  %cmp62 = icmp eq i32 %61, %62
  br i1 %cmp62, label %if.then.64, label %if.end.81

if.then.64:                                       ; preds = %while.body.53
  %63 = load i32* %newcount58, align 4
  %64 = load i32* @P, align 4
  %call12 = call i32 @sleep(i32 1)
  %cmp65 = icmp eq i32 %63, %64
  br i1 %cmp65, label %land.lhs.true.67, label %lor.lhs.false.70

land.lhs.true.67:                                 ; preds = %if.then.64
  %65 = load i32* %lsense49, align 4
  %cmp68 = icmp eq i32 %65, 1
  br i1 %cmp68, label %if.then.76, label %lor.lhs.false.70

lor.lhs.false.70:                                 ; preds = %land.lhs.true.67, %if.then.64
  %66 = load i32* %newcount58, align 4
  %cmp71 = icmp eq i32 %66, 0
  br i1 %cmp71, label %land.lhs.true.73, label %if.end.80

land.lhs.true.73:                                 ; preds = %lor.lhs.false.70
  %67 = load i32* %lsense49, align 4
  %cmp74 = icmp eq i32 %67, -1
  br i1 %cmp74, label %if.then.76, label %if.end.80

if.then.76:                                       ; preds = %land.lhs.true.73, %land.lhs.true.67
  %68 = load i32* %lsense49, align 4
  %sub77 = sub nsw i32 0, %68
  %69 = load %struct.GlobalMemory** @Global, align 8
  %start78 = getelementptr inbounds %struct.GlobalMemory* %69, i32 0, i32 2
  %gsense79 = getelementptr inbounds %struct.barrier_t* %start78, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub77, i32* %gsense79, align 4
  call void @snapshot(i32 %sub77, i32 1)
  %call13 = call i32 @sleep(i32 3)
  br label %if.end.80

if.end.80:                                        ; preds = %if.then.76, %land.lhs.true.73, %lor.lhs.false.70
  br label %while.end.82

if.end.81:                                        ; preds = %while.body.53
  br label %while.body.53

while.end.82:                                     ; preds = %if.end.80
  br label %while.cond.83

while.cond.83:                                    ; preds = %while.body.88, %while.end.82
  %70 = load %struct.GlobalMemory** @Global, align 8
  %start84 = getelementptr inbounds %struct.GlobalMemory* %70, i32 0, i32 2
  %gsense85 = getelementptr inbounds %struct.barrier_t* %start84, i32 0, i32 0
  %71 = load volatile i32* %gsense85, align 4
  %72 = load i32* %lsense49, align 4
  %cmp86 = icmp eq i32 %71, %72
  br i1 %cmp86, label %while.body.88, label %while.end.89

while.body.88:                                    ; preds = %while.cond.83
  %call14 = call i32 @sleep(i32 2)
  br label %while.cond.83

while.end.89:                                     ; preds = %while.cond.83
  call void @printY()
  %call15 = call i32 @sleep(i32 4)
  %73 = load i32* %MyNum, align 4
  %cmp90 = icmp eq i32 %73, 0
  br i1 %cmp90, label %if.then.93, label %lor.lhs.false.92

lor.lhs.false.92:                                 ; preds = %while.end.89
  %74 = load i32* @dostats, align 4
  %tobool = icmp ne i32 %74, 0
  br i1 %tobool, label %if.then.93, label %if.end.96

if.then.93:                                       ; preds = %lor.lhs.false.92, %while.end.89
  %call94 = call i64 @time(i64* null)
  %conv95 = trunc i64 %call94 to i32
  store i32 %conv95, i32* %initdone, align 4
  br label %if.end.96

if.end.96:                                        ; preds = %if.then.93, %lor.lhs.false.92
  %75 = load i32* @M, align 4
  %76 = load i32* @N, align 4
  %77 = load double** @x, align 8
  %78 = load double** @trans, align 8
  %79 = load double** %upriv, align 8
  %80 = load double** @umain2, align 8
  %81 = load i32* %MyNum, align 4
  %82 = load i32* %MyFirst, align 4
  %83 = load i32* %MyLast, align 4
  %84 = load i32* @pad_length, align 4
  %85 = load i32* @P, align 4
  %86 = load i32* @test_result, align 4
  %87 = load i32* @doprint, align 4
  %88 = load i32* @dostats, align 4
  %89 = load %struct.GlobalMemory** @Global, align 8
  call void @FFT1D(i32 1, i32 %75, i32 %76, double* %77, double* %78, double* %79, double* %80, i32 %81, i32* %l_transtime, i32 %82, i32 %83, i32 %84, i32 %85, i32 %86, i32 %87, i32 %88, %struct.GlobalMemory* %89)
  %90 = load i32* @test_result, align 4
  %tobool97 = icmp ne i32 %90, 0
  br i1 %tobool97, label %if.then.98, label %if.end.99

if.then.98:                                       ; preds = %if.end.96
  %91 = load i32* @M, align 4
  %92 = load i32* @N, align 4
  %93 = load double** @x, align 8
  %94 = load double** @trans, align 8
  %95 = load double** %upriv, align 8
  %96 = load double** @umain2, align 8
  %97 = load i32* %MyNum, align 4
  %98 = load i32* %MyFirst, align 4
  %99 = load i32* %MyLast, align 4
  %100 = load i32* @pad_length, align 4
  %101 = load i32* @P, align 4
  %102 = load i32* @test_result, align 4
  %103 = load i32* @doprint, align 4
  %104 = load i32* @dostats, align 4
  %105 = load %struct.GlobalMemory** @Global, align 8
  call void @FFT1D(i32 -1, i32 %91, i32 %92, double* %93, double* %94, double* %95, double* %96, i32 %97, i32* %l_transtime, i32 %98, i32 %99, i32 %100, i32 %101, i32 %102, i32 %103, i32 %104, %struct.GlobalMemory* %105)
  br label %if.end.99

if.end.99:                                        ; preds = %if.then.98, %if.end.96
  %106 = load i32* %MyNum, align 4
  %cmp100 = icmp eq i32 %106, 0
  br i1 %cmp100, label %if.then.104, label %lor.lhs.false.102

lor.lhs.false.102:                                ; preds = %if.end.99
  %107 = load i32* @dostats, align 4
  %tobool103 = icmp ne i32 %107, 0
  br i1 %tobool103, label %if.then.104, label %if.end.112

if.then.104:                                      ; preds = %lor.lhs.false.102, %if.end.99
  %call105 = call i64 @time(i64* null)
  %conv106 = trunc i64 %call105 to i32
  store i32 %conv106, i32* %finish, align 4
  %108 = load i32* %l_transtime, align 4
  %109 = load i32* %MyNum, align 4
  %idxprom107 = sext i32 %109 to i64
  %110 = load %struct.GlobalMemory** @Global, align 8
  %transtimes = getelementptr inbounds %struct.GlobalMemory* %110, i32 0, i32 3
  %111 = load i32** %transtimes, align 8
  %arrayidx108 = getelementptr inbounds i32* %111, i64 %idxprom107
  store i32 %108, i32* %arrayidx108, align 4
  %112 = load i32* %finish, align 4
  %113 = load i32* %initdone, align 4
  %sub109 = sub nsw i32 %112, %113
  %114 = load i32* %MyNum, align 4
  %idxprom110 = sext i32 %114 to i64
  %115 = load %struct.GlobalMemory** @Global, align 8
  %totaltimes = getelementptr inbounds %struct.GlobalMemory* %115, i32 0, i32 4
  %116 = load i32** %totaltimes, align 8
  %arrayidx111 = getelementptr inbounds i32* %116, i64 %idxprom110
  store i32 %sub109, i32* %arrayidx111, align 4
  br label %if.end.112

if.end.112:                                       ; preds = %if.then.104, %lor.lhs.false.102
  %117 = load i32* %MyNum, align 4
  %cmp113 = icmp eq i32 %117, 0
  br i1 %cmp113, label %if.then.115, label %if.end.116

if.then.115:                                      ; preds = %if.end.112
  %118 = load i32* %finish, align 4
  %119 = load %struct.GlobalMemory** @Global, align 8
  %finishtime = getelementptr inbounds %struct.GlobalMemory* %119, i32 0, i32 6
  store i32 %118, i32* %finishtime, align 4
  %120 = load i32* %initdone, align 4
  %121 = load %struct.GlobalMemory** @Global, align 8
  %initdonetime = getelementptr inbounds %struct.GlobalMemory* %121, i32 0, i32 7
  store i32 %120, i32* %initdonetime, align 4
  br label %if.end.116

if.end.116:                                       ; preds = %if.then.115, %if.end.112
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

declare void @Criteria(i32)

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

; Function Attrs: nounwind uwtable
define internal double @TouchArray(double* %x, double* %scratch, double* %u, double* %upriv, i32 %N, i32 %MyNum, i32 %MyFirst, i32 %MyLast) {
entry:
  %x.addr = alloca double*, align 8
  %scratch.addr = alloca double*, align 8
  %u.addr = alloca double*, align 8
  %upriv.addr = alloca double*, align 8
  %N.addr = alloca i32, align 4
  %MyNum.addr = alloca i32, align 4
  %MyFirst.addr = alloca i32, align 4
  %MyLast.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %tot = alloca double, align 8
  store double* %x, double** %x.addr, align 8
  store double* %scratch, double** %scratch.addr, align 8
  store double* %u, double** %u.addr, align 8
  store double* %upriv, double** %upriv.addr, align 8
  store i32 %N, i32* %N.addr, align 4
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store i32 %MyFirst, i32* %MyFirst.addr, align 4
  store i32 %MyLast, i32* %MyLast.addr, align 4
  store double 0.000000e+00, double* %tot, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %j, align 4
  %1 = load i32* @rootN, align 4
  %sub = sub nsw i32 %1, 1
  %mul = mul nsw i32 2, %sub
  %cmp = icmp slt i32 %0, %mul
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %idxprom = sext i32 %2 to i64
  %3 = load double** %upriv.addr, align 8
  %arrayidx = getelementptr inbounds double* %3, i64 %idxprom
  %4 = load double* %arrayidx, align 8
  %5 = load double* %tot, align 8
  %add = fadd double %5, %4
  store double %add, double* %tot, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %6 = load i32* %j, align 4
  %inc = add nsw i32 %6, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %7 = load i32* %MyFirst.addr, align 4
  store i32 %7, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.45, %for.end
  %8 = load i32* %j, align 4
  %9 = load i32* %MyLast.addr, align 4
  %cmp2 = icmp slt i32 %8, %9
  br i1 %cmp2, label %for.body.3, label %for.end.47

for.body.3:                                       ; preds = %for.cond.1
  %10 = load i32* %j, align 4
  %11 = load i32* @rootN, align 4
  %12 = load i32* @pad_length, align 4
  %add4 = add nsw i32 %11, %12
  %mul5 = mul nsw i32 %10, %add4
  store i32 %mul5, i32* %k, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.6

for.cond.6:                                       ; preds = %for.inc.42, %for.body.3
  %13 = load i32* %i, align 4
  %14 = load i32* @rootN, align 4
  %cmp7 = icmp slt i32 %13, %14
  br i1 %cmp7, label %for.body.8, label %for.end.44

for.body.8:                                       ; preds = %for.cond.6
  %15 = load i32* %k, align 4
  %16 = load i32* %i, align 4
  %add9 = add nsw i32 %15, %16
  %mul10 = mul nsw i32 2, %add9
  %idxprom11 = sext i32 %mul10 to i64
  %17 = load double** %x.addr, align 8
  %arrayidx12 = getelementptr inbounds double* %17, i64 %idxprom11
  %18 = load double* %arrayidx12, align 8
  %19 = load i32* %k, align 4
  %20 = load i32* %i, align 4
  %add13 = add nsw i32 %19, %20
  %mul14 = mul nsw i32 2, %add13
  %add15 = add nsw i32 %mul14, 1
  %idxprom16 = sext i32 %add15 to i64
  %21 = load double** %x.addr, align 8
  %arrayidx17 = getelementptr inbounds double* %21, i64 %idxprom16
  %22 = load double* %arrayidx17, align 8
  %add18 = fadd double %18, %22
  %23 = load i32* %k, align 4
  %24 = load i32* %i, align 4
  %add19 = add nsw i32 %23, %24
  %mul20 = mul nsw i32 2, %add19
  %idxprom21 = sext i32 %mul20 to i64
  %25 = load double** %scratch.addr, align 8
  %arrayidx22 = getelementptr inbounds double* %25, i64 %idxprom21
  %26 = load double* %arrayidx22, align 8
  %add23 = fadd double %add18, %26
  %27 = load i32* %k, align 4
  %28 = load i32* %i, align 4
  %add24 = add nsw i32 %27, %28
  %mul25 = mul nsw i32 2, %add24
  %add26 = add nsw i32 %mul25, 1
  %idxprom27 = sext i32 %add26 to i64
  %29 = load double** %scratch.addr, align 8
  %arrayidx28 = getelementptr inbounds double* %29, i64 %idxprom27
  %30 = load double* %arrayidx28, align 8
  %add29 = fadd double %add23, %30
  %31 = load i32* %k, align 4
  %32 = load i32* %i, align 4
  %add30 = add nsw i32 %31, %32
  %mul31 = mul nsw i32 2, %add30
  %idxprom32 = sext i32 %mul31 to i64
  %33 = load double** %u.addr, align 8
  %arrayidx33 = getelementptr inbounds double* %33, i64 %idxprom32
  %34 = load double* %arrayidx33, align 8
  %add34 = fadd double %add29, %34
  %35 = load i32* %k, align 4
  %36 = load i32* %i, align 4
  %add35 = add nsw i32 %35, %36
  %mul36 = mul nsw i32 2, %add35
  %add37 = add nsw i32 %mul36, 1
  %idxprom38 = sext i32 %add37 to i64
  %37 = load double** %u.addr, align 8
  %arrayidx39 = getelementptr inbounds double* %37, i64 %idxprom38
  %38 = load double* %arrayidx39, align 8
  %add40 = fadd double %add34, %38
  %39 = load double* %tot, align 8
  %add41 = fadd double %39, %add40
  store double %add41, double* %tot, align 8
  br label %for.inc.42

for.inc.42:                                       ; preds = %for.body.8
  %40 = load i32* %i, align 4
  %inc43 = add nsw i32 %40, 1
  store i32 %inc43, i32* %i, align 4
  br label %for.cond.6

for.end.44:                                       ; preds = %for.cond.6
  br label %for.inc.45

for.inc.45:                                       ; preds = %for.end.44
  %41 = load i32* %j, align 4
  %inc46 = add nsw i32 %41, 1
  store i32 %inc46, i32* %j, align 4
  br label %for.cond.1

for.end.47:                                       ; preds = %for.cond.1
  %42 = load double* %tot, align 8
  ret double %42
}

; Function Attrs: nounwind uwtable
define internal void @FFT1D(i32 %direction, i32 %M, i32 %N, double* %x, double* %scratch, double* %upriv, double* %umain2, i32 %MyNum, i32* %l_transtime, i32 %MyFirst, i32 %MyLast, i32 %pad_length, i32 %P, i32 %test_result, i32 %doprint, i32 %dostats, %struct.GlobalMemory* %Global) {
entry:
  %direction.addr = alloca i32, align 4
  %M.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %scratch.addr = alloca double*, align 8
  %upriv.addr = alloca double*, align 8
  %umain2.addr = alloca double*, align 8
  %MyNum.addr = alloca i32, align 4
  %l_transtime.addr = alloca i32*, align 8
  %MyFirst.addr = alloca i32, align 4
  %MyLast.addr = alloca i32, align 4
  %pad_length.addr = alloca i32, align 4
  %P.addr = alloca i32, align 4
  %test_result.addr = alloca i32, align 4
  %doprint.addr = alloca i32, align 4
  %dostats.addr = alloca i32, align 4
  %Global.addr = alloca %struct.GlobalMemory*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %m1 = alloca i32, align 4
  %n1 = alloca i32, align 4
  %flag = alloca i32, align 4
  %clocktime1 = alloca i32, align 4
  %clocktime2 = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %lsense51 = alloca i32, align 4
  %oldcount56 = alloca i32, align 4
  %newcount60 = alloca i32, align 4
  %updatedcount62 = alloca i32, align 4
  %lsense134 = alloca i32, align 4
  %oldcount139 = alloca i32, align 4
  %newcount143 = alloca i32, align 4
  %updatedcount145 = alloca i32, align 4
  %lsense194 = alloca i32, align 4
  %oldcount199 = alloca i32, align 4
  %newcount203 = alloca i32, align 4
  %updatedcount205 = alloca i32, align 4
  %lsense258 = alloca i32, align 4
  %oldcount263 = alloca i32, align 4
  %newcount267 = alloca i32, align 4
  %updatedcount269 = alloca i32, align 4
  store i32 %direction, i32* %direction.addr, align 4
  store i32 %M, i32* %M.addr, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %x, double** %x.addr, align 8
  store double* %scratch, double** %scratch.addr, align 8
  store double* %upriv, double** %upriv.addr, align 8
  store double* %umain2, double** %umain2.addr, align 8
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store i32* %l_transtime, i32** %l_transtime.addr, align 8
  store i32 %MyFirst, i32* %MyFirst.addr, align 4
  store i32 %MyLast, i32* %MyLast.addr, align 4
  store i32 %pad_length, i32* %pad_length.addr, align 4
  store i32 %P, i32* %P.addr, align 4
  store i32 %test_result, i32* %test_result.addr, align 4
  store i32 %doprint, i32* %doprint.addr, align 4
  store i32 %dostats, i32* %dostats.addr, align 4
  store %struct.GlobalMemory* %Global, %struct.GlobalMemory** %Global.addr, align 8
  store i32 0, i32* %flag, align 4
  %0 = load i32* %M.addr, align 4
  %div = sdiv i32 %0, 2
  store i32 %div, i32* %m1, align 4
  %1 = load i32* %m1, align 4
  %shl = shl i32 1, %1
  store i32 %shl, i32* %n1, align 4
  %2 = load %struct.GlobalMemory** %Global.addr, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 3)
  call void @IncrementCounter()
  call void @printChar(i8 signext 51)
  call void @printChar(i8 signext 90)
  %3 = load volatile i32* %gsense, align 4
  store i32 %3, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.15, %entry
  %4 = load %struct.GlobalMemory** %Global.addr, align 8
  %start1 = getelementptr inbounds %struct.GlobalMemory* %4, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start1, i32 0, i32 1
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
  %call = call i32 @atomic_cmpxchg(i32 %8, i32 %9)
  %call5 = call i32 @sleep(i32 1)
  store i32 %call, i32* %updatedcount, align 4
  %10 = load i32* %updatedcount, align 4
  %11 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %10, %11
  br i1 %cmp, label %if.then, label %if.end.15

if.then:                                          ; preds = %while.body
  %12 = load i32* %newcount, align 4
  %13 = load i32* %P.addr, align 4
  %cmp3 = icmp eq i32 %12, %13
  br i1 %cmp3, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %14 = load i32* %lsense, align 4
  %cmp5 = icmp eq i32 %14, 1
  br i1 %cmp5, label %if.then.12, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %15 = load i32* %newcount, align 4
  %cmp7 = icmp eq i32 %15, 0
  br i1 %cmp7, label %land.lhs.true.9, label %if.end

land.lhs.true.9:                                  ; preds = %lor.lhs.false
  %16 = load i32* %lsense, align 4
  %cmp10 = icmp eq i32 %16, -1
  br i1 %cmp10, label %if.then.12, label %if.end

if.then.12:                                       ; preds = %land.lhs.true.9, %land.lhs.true
  %17 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %17
  %18 = load %struct.GlobalMemory** %Global.addr, align 8
  %start13 = getelementptr inbounds %struct.GlobalMemory* %18, i32 0, i32 2
  %gsense14 = getelementptr inbounds %struct.barrier_t* %start13, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub, i32* %gsense14, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call2 = call i32 @sleep(i32 3)
  br label %if.end

if.end:                                           ; preds = %if.then.12, %land.lhs.true.9, %lor.lhs.false
  br label %while.end

if.end.15:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.20, %while.end
  %19 = load %struct.GlobalMemory** %Global.addr, align 8
  %start16 = getelementptr inbounds %struct.GlobalMemory* %19, i32 0, i32 2
  %gsense17 = getelementptr inbounds %struct.barrier_t* %start16, i32 0, i32 0
  %20 = load volatile i32* %gsense17, align 4
  %21 = load i32* %lsense, align 4
  %cmp18 = icmp eq i32 %20, %21
  br i1 %cmp18, label %while.body.20, label %while.end.21

while.body.20:                                    ; preds = %while.cond
  %call3 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.21:                                     ; preds = %while.cond
  call void @printY()
  %call4 = call i32 @sleep(i32 4)
  %22 = load i32* %MyNum.addr, align 4
  %cmp22 = icmp eq i32 %22, 0
  br i1 %cmp22, label %if.then.25, label %lor.lhs.false.24

lor.lhs.false.24:                                 ; preds = %while.end.21
  %23 = load i32* %dostats.addr, align 4
  %tobool = icmp ne i32 %23, 0
  br i1 %tobool, label %if.then.25, label %if.end.28

if.then.25:                                       ; preds = %lor.lhs.false.24, %while.end.21
  %call26 = call i64 @time(i64* null)
  %conv27 = trunc i64 %call26 to i32
  store i32 %conv27, i32* %clocktime1, align 4
  br label %if.end.28

if.end.28:                                        ; preds = %if.then.25, %lor.lhs.false.24
  %24 = load i32* %n1, align 4
  %25 = load double** %x.addr, align 8
  %26 = load double** %scratch.addr, align 8
  %27 = load i32* %MyNum.addr, align 4
  %28 = load i32* %MyFirst.addr, align 4
  %29 = load i32* %MyLast.addr, align 4
  %30 = load i32* %pad_length.addr, align 4
  %call29 = call i32 @Transpose(i32 %24, double* %25, double* %26, i32 %27, i32 %28, i32 %29, i32 %30)
  %31 = load i32* %MyNum.addr, align 4
  %cmp30 = icmp eq i32 %31, 0
  br i1 %cmp30, label %if.then.34, label %lor.lhs.false.32

lor.lhs.false.32:                                 ; preds = %if.end.28
  %32 = load i32* %dostats.addr, align 4
  %tobool33 = icmp ne i32 %32, 0
  br i1 %tobool33, label %if.then.34, label %if.end.39

if.then.34:                                       ; preds = %lor.lhs.false.32, %if.end.28
  %call35 = call i64 @time(i64* null)
  %conv36 = trunc i64 %call35 to i32
  store i32 %conv36, i32* %clocktime2, align 4
  %33 = load i32* %clocktime2, align 4
  %34 = load i32* %clocktime1, align 4
  %sub37 = sub i32 %33, %34
  %35 = load i32** %l_transtime.addr, align 8
  %36 = load i32* %35, align 4
  %add38 = add i32 %36, %sub37
  store i32 %add38, i32* %35, align 4
  br label %if.end.39

if.end.39:                                        ; preds = %if.then.34, %lor.lhs.false.32
  %37 = load i32* %MyFirst.addr, align 4
  store i32 %37, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.39
  %38 = load i32* %j, align 4
  %39 = load i32* %MyLast.addr, align 4
  %cmp40 = icmp slt i32 %38, %39
  br i1 %cmp40, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %40 = load i32* %direction.addr, align 4
  %41 = load i32* %m1, align 4
  %42 = load i32* %n1, align 4
  %43 = load double** %upriv.addr, align 8
  %44 = load i32* %j, align 4
  %mul = mul nsw i32 2, %44
  %45 = load i32* %n1, align 4
  %46 = load i32* %pad_length.addr, align 4
  %add42 = add nsw i32 %45, %46
  %mul43 = mul nsw i32 %mul, %add42
  %idxprom = sext i32 %mul43 to i64
  %47 = load double** %scratch.addr, align 8
  %arrayidx = getelementptr inbounds double* %47, i64 %idxprom
  %call44 = call i32 @FFT1DOnce(i32 %40, i32 %41, i32 %42, double* %43, double* %arrayidx)
  %48 = load i32* %direction.addr, align 4
  %49 = load i32* %n1, align 4
  %50 = load i32* %N.addr, align 4
  %51 = load i32* %j, align 4
  %52 = load double** %umain2.addr, align 8
  %53 = load i32* %j, align 4
  %mul45 = mul nsw i32 2, %53
  %54 = load i32* %n1, align 4
  %55 = load i32* %pad_length.addr, align 4
  %add46 = add nsw i32 %54, %55
  %mul47 = mul nsw i32 %mul45, %add46
  %idxprom48 = sext i32 %mul47 to i64
  %56 = load double** %scratch.addr, align 8
  %arrayidx49 = getelementptr inbounds double* %56, i64 %idxprom48
  %57 = load i32* %pad_length.addr, align 4
  %call50 = call i32 @TwiddleOneCol(i32 %48, i32 %49, i32 %50, i32 %51, double* %52, double* %arrayidx49, i32 %57)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %58 = load i32* %j, align 4
  %inc = add nsw i32 %58, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %59 = load %struct.GlobalMemory** %Global.addr, align 8
  %start52 = getelementptr inbounds %struct.GlobalMemory* %59, i32 0, i32 2
  %gsense53 = getelementptr inbounds %struct.barrier_t* %start52, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 4)
  call void @IncrementCounter()
  call void @printChar(i8 signext 52)
  call void @printChar(i8 signext 90)
  %60 = load volatile i32* %gsense53, align 4
  store i32 %60, i32* %lsense51, align 4
  br label %while.body.55

while.body.55:                                    ; preds = %if.end.83, %for.end
  %61 = load %struct.GlobalMemory** %Global.addr, align 8
  %start57 = getelementptr inbounds %struct.GlobalMemory* %61, i32 0, i32 2
  %count58 = getelementptr inbounds %struct.barrier_t* %start57, i32 0, i32 1
  %62 = load volatile i64* %count58, align 8
  %call6 = call i32 @sleep(i32 1)
  %conv59 = trunc i64 %62 to i32
  store i32 %conv59, i32* %oldcount56, align 4
  %63 = load i32* %oldcount56, align 4
  %64 = load i32* %lsense51, align 4
  %add61 = add nsw i32 %63, %64
  store i32 %add61, i32* %newcount60, align 4
  %65 = load i32* %oldcount56, align 4
  %66 = load i32* %newcount60, align 4
  %call63 = call i32 @atomic_cmpxchg(i32 %65, i32 %66)
  %call10 = call i32 @sleep(i32 1)
  store i32 %call63, i32* %updatedcount62, align 4
  %67 = load i32* %updatedcount62, align 4
  %68 = load i32* %oldcount56, align 4
  %cmp64 = icmp eq i32 %67, %68
  br i1 %cmp64, label %if.then.66, label %if.end.83

if.then.66:                                       ; preds = %while.body.55
  %69 = load i32* %newcount60, align 4
  %70 = load i32* %P.addr, align 4
  %cmp67 = icmp eq i32 %69, %70
  br i1 %cmp67, label %land.lhs.true.69, label %lor.lhs.false.72

land.lhs.true.69:                                 ; preds = %if.then.66
  %71 = load i32* %lsense51, align 4
  %cmp70 = icmp eq i32 %71, 1
  br i1 %cmp70, label %if.then.78, label %lor.lhs.false.72

lor.lhs.false.72:                                 ; preds = %land.lhs.true.69, %if.then.66
  %72 = load i32* %newcount60, align 4
  %cmp73 = icmp eq i32 %72, 0
  br i1 %cmp73, label %land.lhs.true.75, label %if.end.82

land.lhs.true.75:                                 ; preds = %lor.lhs.false.72
  %73 = load i32* %lsense51, align 4
  %cmp76 = icmp eq i32 %73, -1
  br i1 %cmp76, label %if.then.78, label %if.end.82

if.then.78:                                       ; preds = %land.lhs.true.75, %land.lhs.true.69
  %74 = load i32* %lsense51, align 4
  %sub79 = sub nsw i32 0, %74
  %75 = load %struct.GlobalMemory** %Global.addr, align 8
  %start80 = getelementptr inbounds %struct.GlobalMemory* %75, i32 0, i32 2
  %gsense81 = getelementptr inbounds %struct.barrier_t* %start80, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub79, i32* %gsense81, align 4
  call void @snapshot(i32 %sub79, i32 1)
  %call7 = call i32 @sleep(i32 3)
  br label %if.end.82

if.end.82:                                        ; preds = %if.then.78, %land.lhs.true.75, %lor.lhs.false.72
  br label %while.end.84

if.end.83:                                        ; preds = %while.body.55
  br label %while.body.55

while.end.84:                                     ; preds = %if.end.82
  br label %while.cond.85

while.cond.85:                                    ; preds = %while.body.90, %while.end.84
  %76 = load %struct.GlobalMemory** %Global.addr, align 8
  %start86 = getelementptr inbounds %struct.GlobalMemory* %76, i32 0, i32 2
  %gsense87 = getelementptr inbounds %struct.barrier_t* %start86, i32 0, i32 0
  %77 = load volatile i32* %gsense87, align 4
  %78 = load i32* %lsense51, align 4
  %cmp88 = icmp eq i32 %77, %78
  br i1 %cmp88, label %while.body.90, label %while.end.91

while.body.90:                                    ; preds = %while.cond.85
  %call8 = call i32 @sleep(i32 2)
  br label %while.cond.85

while.end.91:                                     ; preds = %while.cond.85
  call void @printY()
  %call9 = call i32 @sleep(i32 4)
  %79 = load i32* %MyNum.addr, align 4
  %cmp92 = icmp eq i32 %79, 0
  br i1 %cmp92, label %if.then.96, label %lor.lhs.false.94

lor.lhs.false.94:                                 ; preds = %while.end.91
  %80 = load i32* %dostats.addr, align 4
  %tobool95 = icmp ne i32 %80, 0
  br i1 %tobool95, label %if.then.96, label %if.end.99

if.then.96:                                       ; preds = %lor.lhs.false.94, %while.end.91
  %call97 = call i64 @time(i64* null)
  %conv98 = trunc i64 %call97 to i32
  store i32 %conv98, i32* %clocktime1, align 4
  br label %if.end.99

if.end.99:                                        ; preds = %if.then.96, %lor.lhs.false.94
  %81 = load i32* %n1, align 4
  %82 = load double** %scratch.addr, align 8
  %83 = load double** %x.addr, align 8
  %84 = load i32* %MyNum.addr, align 4
  %85 = load i32* %MyFirst.addr, align 4
  %86 = load i32* %MyLast.addr, align 4
  %87 = load i32* %pad_length.addr, align 4
  %call100 = call i32 @Transpose(i32 %81, double* %82, double* %83, i32 %84, i32 %85, i32 %86, i32 %87)
  %88 = load i32* %MyNum.addr, align 4
  %cmp101 = icmp eq i32 %88, 0
  br i1 %cmp101, label %if.then.105, label %lor.lhs.false.103

lor.lhs.false.103:                                ; preds = %if.end.99
  %89 = load i32* %dostats.addr, align 4
  %tobool104 = icmp ne i32 %89, 0
  br i1 %tobool104, label %if.then.105, label %if.end.110

if.then.105:                                      ; preds = %lor.lhs.false.103, %if.end.99
  %call106 = call i64 @time(i64* null)
  %conv107 = trunc i64 %call106 to i32
  store i32 %conv107, i32* %clocktime2, align 4
  %90 = load i32* %clocktime2, align 4
  %91 = load i32* %clocktime1, align 4
  %sub108 = sub i32 %90, %91
  %92 = load i32** %l_transtime.addr, align 8
  %93 = load i32* %92, align 4
  %add109 = add i32 %93, %sub108
  store i32 %add109, i32* %92, align 4
  br label %if.end.110

if.end.110:                                       ; preds = %if.then.105, %lor.lhs.false.103
  %94 = load i32* %MyFirst.addr, align 4
  store i32 %94, i32* %j, align 4
  br label %for.cond.111

for.cond.111:                                     ; preds = %for.inc.131, %if.end.110
  %95 = load i32* %j, align 4
  %96 = load i32* %MyLast.addr, align 4
  %cmp112 = icmp slt i32 %95, %96
  br i1 %cmp112, label %for.body.114, label %for.end.133

for.body.114:                                     ; preds = %for.cond.111
  %97 = load i32* %direction.addr, align 4
  %98 = load i32* %m1, align 4
  %99 = load i32* %n1, align 4
  %100 = load double** %upriv.addr, align 8
  %101 = load i32* %j, align 4
  %mul115 = mul nsw i32 2, %101
  %102 = load i32* %n1, align 4
  %103 = load i32* %pad_length.addr, align 4
  %add116 = add nsw i32 %102, %103
  %mul117 = mul nsw i32 %mul115, %add116
  %idxprom118 = sext i32 %mul117 to i64
  %104 = load double** %x.addr, align 8
  %arrayidx119 = getelementptr inbounds double* %104, i64 %idxprom118
  %call120 = call i32 @FFT1DOnce(i32 %97, i32 %98, i32 %99, double* %100, double* %arrayidx119)
  %105 = load i32* %direction.addr, align 4
  %cmp121 = icmp eq i32 %105, -1
  br i1 %cmp121, label %if.then.123, label %if.end.130

if.then.123:                                      ; preds = %for.body.114
  %106 = load i32* %n1, align 4
  %107 = load i32* %N.addr, align 4
  %108 = load i32* %j, align 4
  %mul124 = mul nsw i32 2, %108
  %109 = load i32* %n1, align 4
  %110 = load i32* %pad_length.addr, align 4
  %add125 = add nsw i32 %109, %110
  %mul126 = mul nsw i32 %mul124, %add125
  %idxprom127 = sext i32 %mul126 to i64
  %111 = load double** %x.addr, align 8
  %arrayidx128 = getelementptr inbounds double* %111, i64 %idxprom127
  %call129 = call i32 @Scale(i32 %106, i32 %107, double* %arrayidx128)
  br label %if.end.130

if.end.130:                                       ; preds = %if.then.123, %for.body.114
  br label %for.inc.131

for.inc.131:                                      ; preds = %if.end.130
  %112 = load i32* %j, align 4
  %inc132 = add nsw i32 %112, 1
  store i32 %inc132, i32* %j, align 4
  br label %for.cond.111

for.end.133:                                      ; preds = %for.cond.111
  %113 = load %struct.GlobalMemory** %Global.addr, align 8
  %start135 = getelementptr inbounds %struct.GlobalMemory* %113, i32 0, i32 2
  %gsense136 = getelementptr inbounds %struct.barrier_t* %start135, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 5)
  call void @IncrementCounter()
  call void @printChar(i8 signext 53)
  call void @printChar(i8 signext 90)
  %114 = load volatile i32* %gsense136, align 4
  store i32 %114, i32* %lsense134, align 4
  br label %while.body.138

while.body.138:                                   ; preds = %if.end.166, %for.end.133
  %115 = load %struct.GlobalMemory** %Global.addr, align 8
  %start140 = getelementptr inbounds %struct.GlobalMemory* %115, i32 0, i32 2
  %count141 = getelementptr inbounds %struct.barrier_t* %start140, i32 0, i32 1
  %116 = load volatile i64* %count141, align 8
  %call11 = call i32 @sleep(i32 1)
  %conv142 = trunc i64 %116 to i32
  store i32 %conv142, i32* %oldcount139, align 4
  %117 = load i32* %oldcount139, align 4
  %118 = load i32* %lsense134, align 4
  %add144 = add nsw i32 %117, %118
  store i32 %add144, i32* %newcount143, align 4
  %119 = load i32* %oldcount139, align 4
  %120 = load i32* %newcount143, align 4
  %call146 = call i32 @atomic_cmpxchg(i32 %119, i32 %120)
  %call15 = call i32 @sleep(i32 1)
  store i32 %call146, i32* %updatedcount145, align 4
  %121 = load i32* %updatedcount145, align 4
  %122 = load i32* %oldcount139, align 4
  %cmp147 = icmp eq i32 %121, %122
  br i1 %cmp147, label %if.then.149, label %if.end.166

if.then.149:                                      ; preds = %while.body.138
  %123 = load i32* %newcount143, align 4
  %124 = load i32* %P.addr, align 4
  %cmp150 = icmp eq i32 %123, %124
  br i1 %cmp150, label %land.lhs.true.152, label %lor.lhs.false.155

land.lhs.true.152:                                ; preds = %if.then.149
  %125 = load i32* %lsense134, align 4
  %cmp153 = icmp eq i32 %125, 1
  br i1 %cmp153, label %if.then.161, label %lor.lhs.false.155

lor.lhs.false.155:                                ; preds = %land.lhs.true.152, %if.then.149
  %126 = load i32* %newcount143, align 4
  %cmp156 = icmp eq i32 %126, 0
  br i1 %cmp156, label %land.lhs.true.158, label %if.end.165

land.lhs.true.158:                                ; preds = %lor.lhs.false.155
  %127 = load i32* %lsense134, align 4
  %cmp159 = icmp eq i32 %127, -1
  br i1 %cmp159, label %if.then.161, label %if.end.165

if.then.161:                                      ; preds = %land.lhs.true.158, %land.lhs.true.152
  %128 = load i32* %lsense134, align 4
  %sub162 = sub nsw i32 0, %128
  %129 = load %struct.GlobalMemory** %Global.addr, align 8
  %start163 = getelementptr inbounds %struct.GlobalMemory* %129, i32 0, i32 2
  %gsense164 = getelementptr inbounds %struct.barrier_t* %start163, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub162, i32* %gsense164, align 4
  call void @snapshot(i32 %sub162, i32 1)
  %call12 = call i32 @sleep(i32 3)
  br label %if.end.165

if.end.165:                                       ; preds = %if.then.161, %land.lhs.true.158, %lor.lhs.false.155
  br label %while.end.167

if.end.166:                                       ; preds = %while.body.138
  br label %while.body.138

while.end.167:                                    ; preds = %if.end.165
  br label %while.cond.168

while.cond.168:                                   ; preds = %while.body.173, %while.end.167
  %130 = load %struct.GlobalMemory** %Global.addr, align 8
  %start169 = getelementptr inbounds %struct.GlobalMemory* %130, i32 0, i32 2
  %gsense170 = getelementptr inbounds %struct.barrier_t* %start169, i32 0, i32 0
  %131 = load volatile i32* %gsense170, align 4
  %132 = load i32* %lsense134, align 4
  %cmp171 = icmp eq i32 %131, %132
  br i1 %cmp171, label %while.body.173, label %while.end.174

while.body.173:                                   ; preds = %while.cond.168
  %call13 = call i32 @sleep(i32 2)
  br label %while.cond.168

while.end.174:                                    ; preds = %while.cond.168
  call void @printY()
  %call14 = call i32 @sleep(i32 4)
  %133 = load i32* %MyNum.addr, align 4
  %cmp175 = icmp eq i32 %133, 0
  br i1 %cmp175, label %if.then.179, label %lor.lhs.false.177

lor.lhs.false.177:                                ; preds = %while.end.174
  %134 = load i32* %dostats.addr, align 4
  %tobool178 = icmp ne i32 %134, 0
  br i1 %tobool178, label %if.then.179, label %if.end.182

if.then.179:                                      ; preds = %lor.lhs.false.177, %while.end.174
  %call180 = call i64 @time(i64* null)
  %conv181 = trunc i64 %call180 to i32
  store i32 %conv181, i32* %clocktime1, align 4
  br label %if.end.182

if.end.182:                                       ; preds = %if.then.179, %lor.lhs.false.177
  %135 = load i32* %n1, align 4
  %136 = load double** %x.addr, align 8
  %137 = load double** %scratch.addr, align 8
  %138 = load i32* %MyNum.addr, align 4
  %139 = load i32* %MyFirst.addr, align 4
  %140 = load i32* %MyLast.addr, align 4
  %141 = load i32* %pad_length.addr, align 4
  %call183 = call i32 @Transpose(i32 %135, double* %136, double* %137, i32 %138, i32 %139, i32 %140, i32 %141)
  %142 = load i32* %MyNum.addr, align 4
  %cmp184 = icmp eq i32 %142, 0
  br i1 %cmp184, label %if.then.188, label %lor.lhs.false.186

lor.lhs.false.186:                                ; preds = %if.end.182
  %143 = load i32* %dostats.addr, align 4
  %tobool187 = icmp ne i32 %143, 0
  br i1 %tobool187, label %if.then.188, label %if.end.193

if.then.188:                                      ; preds = %lor.lhs.false.186, %if.end.182
  %call189 = call i64 @time(i64* null)
  %conv190 = trunc i64 %call189 to i32
  store i32 %conv190, i32* %clocktime2, align 4
  %144 = load i32* %clocktime2, align 4
  %145 = load i32* %clocktime1, align 4
  %sub191 = sub i32 %144, %145
  %146 = load i32** %l_transtime.addr, align 8
  %147 = load i32* %146, align 4
  %add192 = add i32 %147, %sub191
  store i32 %add192, i32* %146, align 4
  br label %if.end.193

if.end.193:                                       ; preds = %if.then.188, %lor.lhs.false.186
  %148 = load %struct.GlobalMemory** %Global.addr, align 8
  %start195 = getelementptr inbounds %struct.GlobalMemory* %148, i32 0, i32 2
  %gsense196 = getelementptr inbounds %struct.barrier_t* %start195, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 6)
  call void @IncrementCounter()
  call void @printChar(i8 signext 54)
  call void @printChar(i8 signext 90)
  %149 = load volatile i32* %gsense196, align 4
  store i32 %149, i32* %lsense194, align 4
  br label %while.body.198

while.body.198:                                   ; preds = %if.end.226, %if.end.193
  %150 = load %struct.GlobalMemory** %Global.addr, align 8
  %start200 = getelementptr inbounds %struct.GlobalMemory* %150, i32 0, i32 2
  %count201 = getelementptr inbounds %struct.barrier_t* %start200, i32 0, i32 1
  %151 = load volatile i64* %count201, align 8
  %call16 = call i32 @sleep(i32 1)
  %conv202 = trunc i64 %151 to i32
  store i32 %conv202, i32* %oldcount199, align 4
  %152 = load i32* %oldcount199, align 4
  %153 = load i32* %lsense194, align 4
  %add204 = add nsw i32 %152, %153
  store i32 %add204, i32* %newcount203, align 4
  %154 = load i32* %oldcount199, align 4
  %155 = load i32* %newcount203, align 4
  %call206 = call i32 @atomic_cmpxchg(i32 %154, i32 %155)
  %call20 = call i32 @sleep(i32 1)
  store i32 %call206, i32* %updatedcount205, align 4
  %156 = load i32* %updatedcount205, align 4
  %157 = load i32* %oldcount199, align 4
  %cmp207 = icmp eq i32 %156, %157
  br i1 %cmp207, label %if.then.209, label %if.end.226

if.then.209:                                      ; preds = %while.body.198
  %158 = load i32* %newcount203, align 4
  %159 = load i32* %P.addr, align 4
  %cmp210 = icmp eq i32 %158, %159
  br i1 %cmp210, label %land.lhs.true.212, label %lor.lhs.false.215

land.lhs.true.212:                                ; preds = %if.then.209
  %160 = load i32* %lsense194, align 4
  %cmp213 = icmp eq i32 %160, 1
  br i1 %cmp213, label %if.then.221, label %lor.lhs.false.215

lor.lhs.false.215:                                ; preds = %land.lhs.true.212, %if.then.209
  %161 = load i32* %newcount203, align 4
  %cmp216 = icmp eq i32 %161, 0
  br i1 %cmp216, label %land.lhs.true.218, label %if.end.225

land.lhs.true.218:                                ; preds = %lor.lhs.false.215
  %162 = load i32* %lsense194, align 4
  %cmp219 = icmp eq i32 %162, -1
  br i1 %cmp219, label %if.then.221, label %if.end.225

if.then.221:                                      ; preds = %land.lhs.true.218, %land.lhs.true.212
  %163 = load i32* %lsense194, align 4
  %sub222 = sub nsw i32 0, %163
  %164 = load %struct.GlobalMemory** %Global.addr, align 8
  %start223 = getelementptr inbounds %struct.GlobalMemory* %164, i32 0, i32 2
  %gsense224 = getelementptr inbounds %struct.barrier_t* %start223, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub222, i32* %gsense224, align 4
  call void @snapshot(i32 %sub222, i32 1)
  %call17 = call i32 @sleep(i32 3)
  br label %if.end.225

if.end.225:                                       ; preds = %if.then.221, %land.lhs.true.218, %lor.lhs.false.215
  br label %while.end.227

if.end.226:                                       ; preds = %while.body.198
  br label %while.body.198

while.end.227:                                    ; preds = %if.end.225
  br label %while.cond.228

while.cond.228:                                   ; preds = %while.body.233, %while.end.227
  %165 = load %struct.GlobalMemory** %Global.addr, align 8
  %start229 = getelementptr inbounds %struct.GlobalMemory* %165, i32 0, i32 2
  %gsense230 = getelementptr inbounds %struct.barrier_t* %start229, i32 0, i32 0
  %166 = load volatile i32* %gsense230, align 4
  %167 = load i32* %lsense194, align 4
  %cmp231 = icmp eq i32 %166, %167
  br i1 %cmp231, label %while.body.233, label %while.end.234

while.body.233:                                   ; preds = %while.cond.228
  %call18 = call i32 @sleep(i32 2)
  br label %while.cond.228

while.end.234:                                    ; preds = %while.cond.228
  call void @printY()
  %call19 = call i32 @sleep(i32 4)
  %168 = load i32* %test_result.addr, align 4
  %tobool235 = icmp ne i32 %168, 0
  br i1 %tobool235, label %if.then.238, label %lor.lhs.false.236

lor.lhs.false.236:                                ; preds = %while.end.234
  %169 = load i32* %doprint.addr, align 4
  %tobool237 = icmp ne i32 %169, 0
  br i1 %tobool237, label %if.then.238, label %if.end.257

if.then.238:                                      ; preds = %lor.lhs.false.236, %while.end.234
  %170 = load i32* %MyFirst.addr, align 4
  store i32 %170, i32* %j, align 4
  br label %for.cond.239

for.cond.239:                                     ; preds = %for.inc.254, %if.then.238
  %171 = load i32* %j, align 4
  %172 = load i32* %MyLast.addr, align 4
  %cmp240 = icmp slt i32 %171, %172
  br i1 %cmp240, label %for.body.242, label %for.end.256

for.body.242:                                     ; preds = %for.cond.239
  %173 = load i32* %n1, align 4
  %174 = load i32* %j, align 4
  %mul243 = mul nsw i32 2, %174
  %175 = load i32* %n1, align 4
  %176 = load i32* %pad_length.addr, align 4
  %add244 = add nsw i32 %175, %176
  %mul245 = mul nsw i32 %mul243, %add244
  %idxprom246 = sext i32 %mul245 to i64
  %177 = load double** %scratch.addr, align 8
  %arrayidx247 = getelementptr inbounds double* %177, i64 %idxprom246
  %178 = load i32* %j, align 4
  %mul248 = mul nsw i32 2, %178
  %179 = load i32* %n1, align 4
  %180 = load i32* %pad_length.addr, align 4
  %add249 = add nsw i32 %179, %180
  %mul250 = mul nsw i32 %mul248, %add249
  %idxprom251 = sext i32 %mul250 to i64
  %181 = load double** %x.addr, align 8
  %arrayidx252 = getelementptr inbounds double* %181, i64 %idxprom251
  %call253 = call i32 @CopyColumn(i32 %173, double* %arrayidx247, double* %arrayidx252)
  br label %for.inc.254

for.inc.254:                                      ; preds = %for.body.242
  %182 = load i32* %j, align 4
  %inc255 = add nsw i32 %182, 1
  store i32 %inc255, i32* %j, align 4
  br label %for.cond.239

for.end.256:                                      ; preds = %for.cond.239
  br label %if.end.257

if.end.257:                                       ; preds = %for.end.256, %lor.lhs.false.236
  %183 = load %struct.GlobalMemory** %Global.addr, align 8
  %start259 = getelementptr inbounds %struct.GlobalMemory* %183, i32 0, i32 2
  %gsense260 = getelementptr inbounds %struct.barrier_t* %start259, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 7)
  call void @IncrementCounter()
  call void @printChar(i8 signext 55)
  call void @printChar(i8 signext 90)
  %184 = load volatile i32* %gsense260, align 4
  store i32 %184, i32* %lsense258, align 4
  br label %while.body.262

while.body.262:                                   ; preds = %if.end.290, %if.end.257
  %185 = load %struct.GlobalMemory** %Global.addr, align 8
  %start264 = getelementptr inbounds %struct.GlobalMemory* %185, i32 0, i32 2
  %count265 = getelementptr inbounds %struct.barrier_t* %start264, i32 0, i32 1
  %186 = load volatile i64* %count265, align 8
  %call21 = call i32 @sleep(i32 1)
  %conv266 = trunc i64 %186 to i32
  store i32 %conv266, i32* %oldcount263, align 4
  %187 = load i32* %oldcount263, align 4
  %188 = load i32* %lsense258, align 4
  %add268 = add nsw i32 %187, %188
  store i32 %add268, i32* %newcount267, align 4
  %189 = load i32* %oldcount263, align 4
  %190 = load i32* %newcount267, align 4
  %call270 = call i32 @atomic_cmpxchg(i32 %189, i32 %190)
  %call25 = call i32 @sleep(i32 1)
  store i32 %call270, i32* %updatedcount269, align 4
  %191 = load i32* %updatedcount269, align 4
  %192 = load i32* %oldcount263, align 4
  %cmp271 = icmp eq i32 %191, %192
  br i1 %cmp271, label %if.then.273, label %if.end.290

if.then.273:                                      ; preds = %while.body.262
  %193 = load i32* %newcount267, align 4
  %194 = load i32* %P.addr, align 4
  %cmp274 = icmp eq i32 %193, %194
  br i1 %cmp274, label %land.lhs.true.276, label %lor.lhs.false.279

land.lhs.true.276:                                ; preds = %if.then.273
  %195 = load i32* %lsense258, align 4
  %cmp277 = icmp eq i32 %195, 1
  br i1 %cmp277, label %if.then.285, label %lor.lhs.false.279

lor.lhs.false.279:                                ; preds = %land.lhs.true.276, %if.then.273
  %196 = load i32* %newcount267, align 4
  %cmp280 = icmp eq i32 %196, 0
  br i1 %cmp280, label %land.lhs.true.282, label %if.end.289

land.lhs.true.282:                                ; preds = %lor.lhs.false.279
  %197 = load i32* %lsense258, align 4
  %cmp283 = icmp eq i32 %197, -1
  br i1 %cmp283, label %if.then.285, label %if.end.289

if.then.285:                                      ; preds = %land.lhs.true.282, %land.lhs.true.276
  %198 = load i32* %lsense258, align 4
  %sub286 = sub nsw i32 0, %198
  %199 = load %struct.GlobalMemory** %Global.addr, align 8
  %start287 = getelementptr inbounds %struct.GlobalMemory* %199, i32 0, i32 2
  %gsense288 = getelementptr inbounds %struct.barrier_t* %start287, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub286, i32* %gsense288, align 4
  call void @snapshot(i32 %sub286, i32 1)
  %call22 = call i32 @sleep(i32 3)
  br label %if.end.289

if.end.289:                                       ; preds = %if.then.285, %land.lhs.true.282, %lor.lhs.false.279
  br label %while.end.291

if.end.290:                                       ; preds = %while.body.262
  br label %while.body.262

while.end.291:                                    ; preds = %if.end.289
  br label %while.cond.292

while.cond.292:                                   ; preds = %while.body.297, %while.end.291
  %200 = load %struct.GlobalMemory** %Global.addr, align 8
  %start293 = getelementptr inbounds %struct.GlobalMemory* %200, i32 0, i32 2
  %gsense294 = getelementptr inbounds %struct.barrier_t* %start293, i32 0, i32 0
  %201 = load volatile i32* %gsense294, align 4
  %202 = load i32* %lsense258, align 4
  %cmp295 = icmp eq i32 %201, %202
  br i1 %cmp295, label %while.body.297, label %while.end.298

while.body.297:                                   ; preds = %while.cond.292
  %call23 = call i32 @sleep(i32 2)
  br label %while.cond.292

while.end.298:                                    ; preds = %while.cond.292
  call void @printY()
  %call24 = call i32 @sleep(i32 4)
  ret void
}

; Function Attrs: nounwind uwtable
define internal double @CheckSum(i32 %N, double* %x) {
entry:
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %cks = alloca double, align 8
  store i32 %N, i32* %N.addr, align 4
  store double* %x, double** %x.addr, align 8
  store double 0.000000e+00, double* %cks, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.13, %entry
  %0 = load i32* %j, align 4
  %1 = load i32* @rootN, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.15

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %3 = load i32* @rootN, align 4
  %4 = load i32* @pad_length, align 4
  %add = add nsw i32 %3, %4
  %mul = mul nsw i32 %2, %add
  store i32 %mul, i32* %k, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %5 = load i32* %i, align 4
  %6 = load i32* @rootN, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %7 = load i32* %k, align 4
  %8 = load i32* %i, align 4
  %add4 = add nsw i32 %7, %8
  %mul5 = mul nsw i32 2, %add4
  %idxprom = sext i32 %mul5 to i64
  %9 = load double** %x.addr, align 8
  %arrayidx = getelementptr inbounds double* %9, i64 %idxprom
  %10 = load double* %arrayidx, align 8
  %11 = load i32* %k, align 4
  %12 = load i32* %i, align 4
  %add6 = add nsw i32 %11, %12
  %mul7 = mul nsw i32 2, %add6
  %add8 = add nsw i32 %mul7, 1
  %idxprom9 = sext i32 %add8 to i64
  %13 = load double** %x.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %13, i64 %idxprom9
  %14 = load double* %arrayidx10, align 8
  %add11 = fadd double %10, %14
  %15 = load double* %cks, align 8
  %add12 = fadd double %15, %add11
  store double %add12, double* %cks, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %16 = load i32* %i, align 4
  %inc = add nsw i32 %16, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.13

for.inc.13:                                       ; preds = %for.end
  %17 = load i32* %j, align 4
  %inc14 = add nsw i32 %17, 1
  store i32 %inc14, i32* %j, align 4
  br label %for.cond

for.end.15:                                       ; preds = %for.cond
  %18 = load double* %cks, align 8
  ret double %18
}

; Function Attrs: nounwind uwtable
define internal i32 @InitX(i32 %N, double* %x) {
entry:
  %retval = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %x, double** %x.addr, align 8
  %call = call i32 (i32, ...) *bitcast (i32 (...)* @srand48 to i32 (i32, ...)*)(i32 0)
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.13, %entry
  %0 = load i32* %j, align 4
  %1 = load i32* @rootN, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.15

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %3 = load i32* @rootN, align 4
  %4 = load i32* @pad_length, align 4
  %add = add nsw i32 %3, %4
  %mul = mul nsw i32 %2, %add
  store i32 %mul, i32* %k, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %5 = load i32* %i, align 4
  %6 = load i32* @rootN, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %call4 = call double (...) *@drand48()
  %7 = load i32* %k, align 4
  %8 = load i32* %i, align 4
  %add5 = add nsw i32 %7, %8
  %mul6 = mul nsw i32 2, %add5
  %idxprom = sext i32 %mul6 to i64
  %9 = load double** %x.addr, align 8
  %arrayidx = getelementptr inbounds double* %9, i64 %idxprom
  store double %call4, double* %arrayidx, align 8
  %call7 = call double (...) *@drand48()
  %10 = load i32* %k, align 4
  %11 = load i32* %i, align 4
  %add8 = add nsw i32 %10, %11
  %mul9 = mul nsw i32 2, %add8
  %add10 = add nsw i32 %mul9, 1
  %idxprom11 = sext i32 %add10 to i64
  %12 = load double** %x.addr, align 8
  %arrayidx12 = getelementptr inbounds double* %12, i64 %idxprom11
  store double %call7, double* %arrayidx12, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %13 = load i32* %i, align 4
  %inc = add nsw i32 %13, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.13

for.inc.13:                                       ; preds = %for.end
  %14 = load i32* %j, align 4
  %inc14 = add nsw i32 %14, 1
  store i32 %inc14, i32* %j, align 4
  br label %for.cond

for.end.15:                                       ; preds = %for.cond
  %15 = load i32* %retval
  ret i32 %15
}

declare i32 @srand48(...)

declare double @drand48(...)

; Function Attrs: nounwind uwtable
define internal i32 @InitU(i32 %N, double* %u) {
entry:
  %retval = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %u.addr = alloca double*, align 8
  %q = alloca i32, align 4
  %j = alloca i32, align 4
  %base = alloca i32, align 4
  %n1 = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %u, double** %u.addr, align 8
  store i32 0, i32* %q, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.23, %entry
  %0 = load i32* %q, align 4
  %shl = shl i32 1, %0
  %1 = load i32* %N.addr, align 4
  %cmp = icmp slt i32 %shl, %1
  br i1 %cmp, label %for.body, label %for.end.25

for.body:                                         ; preds = %for.cond
  %2 = load i32* %q, align 4
  %shl1 = shl i32 1, %2
  store i32 %shl1, i32* %n1, align 4
  %3 = load i32* %n1, align 4
  %sub = sub nsw i32 %3, 1
  store i32 %sub, i32* %base, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc, %for.body
  %4 = load i32* %j, align 4
  %5 = load i32* %n1, align 4
  %cmp3 = icmp slt i32 %4, %5
  br i1 %cmp3, label %for.body.4, label %for.end

for.body.4:                                       ; preds = %for.cond.2
  %6 = load i32* %base, align 4
  %7 = load i32* %j, align 4
  %add = add nsw i32 %6, %7
  %8 = load i32* @rootN, align 4
  %sub5 = sub nsw i32 %8, 1
  %cmp6 = icmp sgt i32 %add, %sub5
  br i1 %cmp6, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.4
  store i32 0, i32* %retval
  br label %for.end.25

if.end:                                           ; preds = %for.body.4
  %9 = load i32* %j, align 4
  %conv = sitofp i32 %9 to double
  %mul = fmul double 6.283200e+00, %conv
  %10 = load i32* %n1, align 4
  %mul7 = mul nsw i32 2, %10
  %conv8 = sitofp i32 %mul7 to double
  %div = fdiv double %mul, %conv8
  %call = call double @cos(double %div)
  %11 = load i32* %base, align 4
  %12 = load i32* %j, align 4
  %add9 = add nsw i32 %11, %12
  %mul10 = mul nsw i32 2, %add9
  %idxprom = sext i32 %mul10 to i64
  %13 = load double** %u.addr, align 8
  %arrayidx = getelementptr inbounds double* %13, i64 %idxprom
  store double %call, double* %arrayidx, align 8
  %14 = load i32* %j, align 4
  %conv11 = sitofp i32 %14 to double
  %mul12 = fmul double 6.283200e+00, %conv11
  %15 = load i32* %n1, align 4
  %mul13 = mul nsw i32 2, %15
  %conv14 = sitofp i32 %mul13 to double
  %div15 = fdiv double %mul12, %conv14
  %call16 = call double @sin(double %div15)
  %sub17 = fsub double -0.000000e+00, %call16
  %16 = load i32* %base, align 4
  %17 = load i32* %j, align 4
  %add18 = add nsw i32 %16, %17
  %mul19 = mul nsw i32 2, %add18
  %add20 = add nsw i32 %mul19, 1
  %idxprom21 = sext i32 %add20 to i64
  %18 = load double** %u.addr, align 8
  %arrayidx22 = getelementptr inbounds double* %18, i64 %idxprom21
  store double %sub17, double* %arrayidx22, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %19 = load i32* %j, align 4
  %inc = add nsw i32 %19, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.2

for.end:                                          ; preds = %for.cond.2
  br label %for.inc.23

for.inc.23:                                       ; preds = %for.end
  %20 = load i32* %q, align 4
  %inc24 = add nsw i32 %20, 1
  store i32 %inc24, i32* %q, align 4
  br label %for.cond

for.end.25:                                       ; preds = %if.then, %for.cond
  %21 = load i32* %retval
  ret i32 %21
}

; Function Attrs: nounwind
declare double @cos(double)

; Function Attrs: nounwind
declare double @sin(double)

; Function Attrs: nounwind uwtable
define internal i32 @InitU2(i32 %N, double* %u, i32 %n1) {
entry:
  %retval = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %u.addr = alloca double*, align 8
  %n1.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %base = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %u, double** %u.addr, align 8
  store i32 %n1, i32* %n1.addr, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.22, %entry
  %0 = load i32* %j, align 4
  %1 = load i32* %n1.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.24

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %3 = load i32* @rootN, align 4
  %4 = load i32* @pad_length, align 4
  %add = add nsw i32 %3, %4
  %mul = mul nsw i32 %2, %add
  store i32 %mul, i32* %k, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %5 = load i32* %i, align 4
  %6 = load i32* %n1.addr, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %7 = load i32* %i, align 4
  %conv = sitofp i32 %7 to double
  %mul4 = fmul double 6.283200e+00, %conv
  %8 = load i32* %j, align 4
  %conv5 = sitofp i32 %8 to double
  %mul6 = fmul double %mul4, %conv5
  %9 = load i32* %N.addr, align 4
  %conv7 = sitofp i32 %9 to double
  %div = fdiv double %mul6, %conv7
  %call = call double @cos(double %div)
  %10 = load i32* %k, align 4
  %11 = load i32* %i, align 4
  %add8 = add nsw i32 %10, %11
  %mul9 = mul nsw i32 2, %add8
  %idxprom = sext i32 %mul9 to i64
  %12 = load double** %u.addr, align 8
  %arrayidx = getelementptr inbounds double* %12, i64 %idxprom
  store double %call, double* %arrayidx, align 8
  %13 = load i32* %i, align 4
  %conv10 = sitofp i32 %13 to double
  %mul11 = fmul double 6.283200e+00, %conv10
  %14 = load i32* %j, align 4
  %conv12 = sitofp i32 %14 to double
  %mul13 = fmul double %mul11, %conv12
  %15 = load i32* %N.addr, align 4
  %conv14 = sitofp i32 %15 to double
  %div15 = fdiv double %mul13, %conv14
  %call16 = call double @sin(double %div15)
  %sub = fsub double -0.000000e+00, %call16
  %16 = load i32* %k, align 4
  %17 = load i32* %i, align 4
  %add17 = add nsw i32 %16, %17
  %mul18 = mul nsw i32 2, %add17
  %add19 = add nsw i32 %mul18, 1
  %idxprom20 = sext i32 %add19 to i64
  %18 = load double** %u.addr, align 8
  %arrayidx21 = getelementptr inbounds double* %18, i64 %idxprom20
  store double %sub, double* %arrayidx21, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %19 = load i32* %i, align 4
  %inc = add nsw i32 %19, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.22

for.inc.22:                                       ; preds = %for.end
  %20 = load i32* %j, align 4
  %inc23 = add nsw i32 %20, 1
  store i32 %inc23, i32* %j, align 4
  br label %for.cond

for.end.24:                                       ; preds = %for.cond
  %21 = load i32* %retval
  ret i32 %21
}

; Function Attrs: nounwind uwtable
define internal i32 @BitReverse(i32 %M, i32 %k) {
entry:
  %M.addr = alloca i32, align 4
  %k.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 %M, i32* %M.addr, align 4
  store i32 %k, i32* %k.addr, align 4
  store i32 0, i32* %j, align 4
  %0 = load i32* %k.addr, align 4
  store i32 %0, i32* %tmp, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %M.addr, align 4
  %cmp = icmp slt i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32* %j, align 4
  %mul = mul nsw i32 2, %3
  %4 = load i32* %tmp, align 4
  %and = and i32 %4, 1
  %add = add nsw i32 %mul, %and
  store i32 %add, i32* %j, align 4
  %5 = load i32* %tmp, align 4
  %shr = ashr i32 %5, 1
  store i32 %shr, i32* %tmp, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %6 = load i32* %i, align 4
  %inc = add nsw i32 %6, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %7 = load i32* %j, align 4
  ret i32 %7
}

; Function Attrs: nounwind uwtable
define internal i32 @TwiddleOneCol(i32 %direction, i32 %n1, i32 %N, i32 %j, double* %u, double* %x, i32 %pad_length) {
entry:
  %retval = alloca i32, align 4
  %direction.addr = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %j.addr = alloca i32, align 4
  %u.addr = alloca double*, align 8
  %x.addr = alloca double*, align 8
  %pad_length.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %omega_r = alloca double, align 8
  %omega_c = alloca double, align 8
  %x_r = alloca double, align 8
  %x_c = alloca double, align 8
  %r1 = alloca double, align 8
  %c1 = alloca double, align 8
  %r2 = alloca double, align 8
  %c2 = alloca double, align 8
  store i32 %direction, i32* %direction.addr, align 4
  store i32 %n1, i32* %n1.addr, align 4
  store i32 %N, i32* %N.addr, align 4
  store i32 %j, i32* %j.addr, align 4
  store double* %u, double** %u.addr, align 8
  store double* %x, double** %x.addr, align 8
  store i32 %pad_length, i32* %pad_length.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n1.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j.addr, align 4
  %3 = load i32* %n1.addr, align 4
  %4 = load i32* %pad_length.addr, align 4
  %add = add nsw i32 %3, %4
  %mul = mul nsw i32 %2, %add
  %5 = load i32* %i, align 4
  %add1 = add nsw i32 %mul, %5
  %mul2 = mul nsw i32 2, %add1
  %idxprom = sext i32 %mul2 to i64
  %6 = load double** %u.addr, align 8
  %arrayidx = getelementptr inbounds double* %6, i64 %idxprom
  %7 = load double* %arrayidx, align 8
  store double %7, double* %omega_r, align 8
  %8 = load i32* %direction.addr, align 4
  %conv = sitofp i32 %8 to double
  %9 = load i32* %j.addr, align 4
  %10 = load i32* %n1.addr, align 4
  %11 = load i32* %pad_length.addr, align 4
  %add3 = add nsw i32 %10, %11
  %mul4 = mul nsw i32 %9, %add3
  %12 = load i32* %i, align 4
  %add5 = add nsw i32 %mul4, %12
  %mul6 = mul nsw i32 2, %add5
  %add7 = add nsw i32 %mul6, 1
  %idxprom8 = sext i32 %add7 to i64
  %13 = load double** %u.addr, align 8
  %arrayidx9 = getelementptr inbounds double* %13, i64 %idxprom8
  %14 = load double* %arrayidx9, align 8
  %mul10 = fmul double %conv, %14
  store double %mul10, double* %omega_c, align 8
  %15 = load i32* %i, align 4
  %mul11 = mul nsw i32 2, %15
  %idxprom12 = sext i32 %mul11 to i64
  %16 = load double** %x.addr, align 8
  %arrayidx13 = getelementptr inbounds double* %16, i64 %idxprom12
  %17 = load double* %arrayidx13, align 8
  store double %17, double* %x_r, align 8
  %18 = load i32* %i, align 4
  %mul14 = mul nsw i32 2, %18
  %add15 = add nsw i32 %mul14, 1
  %idxprom16 = sext i32 %add15 to i64
  %19 = load double** %x.addr, align 8
  %arrayidx17 = getelementptr inbounds double* %19, i64 %idxprom16
  %20 = load double* %arrayidx17, align 8
  store double %20, double* %x_c, align 8
  %21 = load double* %omega_r, align 8
  %22 = load double* %x_r, align 8
  %mul18 = fmul double %21, %22
  %23 = load double* %omega_c, align 8
  %24 = load double* %x_c, align 8
  %mul19 = fmul double %23, %24
  %sub = fsub double %mul18, %mul19
  %25 = load i32* %i, align 4
  %mul20 = mul nsw i32 2, %25
  %idxprom21 = sext i32 %mul20 to i64
  %26 = load double** %x.addr, align 8
  %arrayidx22 = getelementptr inbounds double* %26, i64 %idxprom21
  store double %sub, double* %arrayidx22, align 8
  %27 = load double* %omega_r, align 8
  %28 = load double* %x_c, align 8
  %mul23 = fmul double %27, %28
  %29 = load double* %omega_c, align 8
  %30 = load double* %x_r, align 8
  %mul24 = fmul double %29, %30
  %add25 = fadd double %mul23, %mul24
  %31 = load i32* %i, align 4
  %mul26 = mul nsw i32 2, %31
  %add27 = add nsw i32 %mul26, 1
  %idxprom28 = sext i32 %add27 to i64
  %32 = load double** %x.addr, align 8
  %arrayidx29 = getelementptr inbounds double* %32, i64 %idxprom28
  store double %add25, double* %arrayidx29, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %33 = load i32* %i, align 4
  %inc = add nsw i32 %33, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %34 = load i32* %retval
  ret i32 %34
}

; Function Attrs: nounwind uwtable
define internal i32 @Scale(i32 %n1, i32 %N, double* %x) {
entry:
  %retval = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %i = alloca i32, align 4
  store i32 %n1, i32* %n1.addr, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %x, double** %x.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n1.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %N.addr, align 4
  %conv = sitofp i32 %2 to double
  %3 = load i32* %i, align 4
  %mul = mul nsw i32 2, %3
  %idxprom = sext i32 %mul to i64
  %4 = load double** %x.addr, align 8
  %arrayidx = getelementptr inbounds double* %4, i64 %idxprom
  %5 = load double* %arrayidx, align 8
  %div = fdiv double %5, %conv
  store double %div, double* %arrayidx, align 8
  %6 = load i32* %N.addr, align 4
  %conv1 = sitofp i32 %6 to double
  %7 = load i32* %i, align 4
  %mul2 = mul nsw i32 2, %7
  %add = add nsw i32 %mul2, 1
  %idxprom3 = sext i32 %add to i64
  %8 = load double** %x.addr, align 8
  %arrayidx4 = getelementptr inbounds double* %8, i64 %idxprom3
  %9 = load double* %arrayidx4, align 8
  %div5 = fdiv double %9, %conv1
  store double %div5, double* %arrayidx4, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %10 = load i32* %i, align 4
  %inc = add nsw i32 %10, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %11 = load i32* %retval
  ret i32 %11
}

; Function Attrs: nounwind uwtable
define internal i32 @Transpose(i32 %n1, double* %src, double* %dest, i32 %MyNum, i32 %MyFirst, i32 %MyLast, i32 %pad_length) {
entry:
  %retval = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %src.addr = alloca double*, align 8
  %dest.addr = alloca double*, align 8
  %MyNum.addr = alloca i32, align 4
  %MyFirst.addr = alloca i32, align 4
  %MyLast.addr = alloca i32, align 4
  %pad_length.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %l = alloca i32, align 4
  %m = alloca i32, align 4
  %blksize = alloca i32, align 4
  %numblks = alloca i32, align 4
  %firstfirst = alloca i32, align 4
  %h_off = alloca i32, align 4
  %v_off = alloca i32, align 4
  %v = alloca i32, align 4
  %h = alloca i32, align 4
  %n1p = alloca i32, align 4
  %row_count = alloca i32, align 4
  store i32 %n1, i32* %n1.addr, align 4
  store double* %src, double** %src.addr, align 8
  store double* %dest, double** %dest.addr, align 8
  store i32 %MyNum, i32* %MyNum.addr, align 4
  store i32 %MyFirst, i32* %MyFirst.addr, align 4
  store i32 %MyLast, i32* %MyLast.addr, align 4
  store i32 %pad_length, i32* %pad_length.addr, align 4
  %0 = load i32* %MyLast.addr, align 4
  %1 = load i32* %MyFirst.addr, align 4
  %sub = sub nsw i32 %0, %1
  store i32 %sub, i32* %blksize, align 4
  %2 = load i32* %blksize, align 4
  %mul = mul nsw i32 2, %2
  %3 = load i32* @num_cache_lines, align 4
  %div = sdiv i32 %mul, %3
  store i32 %div, i32* %numblks, align 4
  %4 = load i32* %numblks, align 4
  %5 = load i32* @num_cache_lines, align 4
  %mul1 = mul nsw i32 %4, %5
  %6 = load i32* %blksize, align 4
  %mul2 = mul nsw i32 2, %6
  %cmp = icmp ne i32 %mul1, %mul2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %7 = load i32* %numblks, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %numblks, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %8 = load i32* %blksize, align 4
  %9 = load i32* %numblks, align 4
  %div3 = sdiv i32 %8, %9
  store i32 %div3, i32* %blksize, align 4
  %10 = load i32* %MyFirst.addr, align 4
  store i32 %10, i32* %firstfirst, align 4
  %11 = load i32* %n1.addr, align 4
  %12 = load i32* @P, align 4
  %div4 = sdiv i32 %11, %12
  store i32 %div4, i32* %row_count, align 4
  %13 = load i32* %n1.addr, align 4
  %14 = load i32* %pad_length.addr, align 4
  %add = add nsw i32 %13, %14
  store i32 %add, i32* %n1p, align 4
  %15 = load i32* %MyNum.addr, align 4
  %add5 = add nsw i32 %15, 1
  store i32 %add5, i32* %l, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.54, %if.end
  %16 = load i32* %l, align 4
  %17 = load i32* @P, align 4
  %cmp6 = icmp slt i32 %16, %17
  br i1 %cmp6, label %for.body, label %for.end.56

for.body:                                         ; preds = %for.cond
  %18 = load i32* %l, align 4
  %19 = load i32* %row_count, align 4
  %mul7 = mul nsw i32 %18, %19
  store i32 %mul7, i32* %v_off, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc.51, %for.body
  %20 = load i32* %k, align 4
  %21 = load i32* %numblks, align 4
  %cmp9 = icmp slt i32 %20, %21
  br i1 %cmp9, label %for.body.10, label %for.end.53

for.body.10:                                      ; preds = %for.cond.8
  %22 = load i32* %firstfirst, align 4
  store i32 %22, i32* %h_off, align 4
  store i32 0, i32* %m, align 4
  br label %for.cond.11

for.cond.11:                                      ; preds = %for.inc.47, %for.body.10
  %23 = load i32* %m, align 4
  %24 = load i32* %numblks, align 4
  %cmp12 = icmp slt i32 %23, %24
  br i1 %cmp12, label %for.body.13, label %for.end.49

for.body.13:                                      ; preds = %for.cond.11
  store i32 0, i32* %i, align 4
  br label %for.cond.14

for.cond.14:                                      ; preds = %for.inc.43, %for.body.13
  %25 = load i32* %i, align 4
  %26 = load i32* %blksize, align 4
  %cmp15 = icmp slt i32 %25, %26
  br i1 %cmp15, label %for.body.16, label %for.end.45

for.body.16:                                      ; preds = %for.cond.14
  %27 = load i32* %v_off, align 4
  %28 = load i32* %i, align 4
  %add17 = add nsw i32 %27, %28
  store i32 %add17, i32* %v, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond.18

for.cond.18:                                      ; preds = %for.inc, %for.body.16
  %29 = load i32* %j, align 4
  %30 = load i32* %blksize, align 4
  %cmp19 = icmp slt i32 %29, %30
  br i1 %cmp19, label %for.body.20, label %for.end

for.body.20:                                      ; preds = %for.cond.18
  %31 = load i32* %h_off, align 4
  %32 = load i32* %j, align 4
  %add21 = add nsw i32 %31, %32
  store i32 %add21, i32* %h, align 4
  %33 = load i32* %v, align 4
  %34 = load i32* %n1p, align 4
  %mul22 = mul nsw i32 %33, %34
  %35 = load i32* %h, align 4
  %add23 = add nsw i32 %mul22, %35
  %mul24 = mul nsw i32 2, %add23
  %idxprom = sext i32 %mul24 to i64
  %36 = load double** %src.addr, align 8
  %arrayidx = getelementptr inbounds double* %36, i64 %idxprom
  %37 = load double* %arrayidx, align 8
  %38 = load i32* %h, align 4
  %39 = load i32* %n1p, align 4
  %mul25 = mul nsw i32 %38, %39
  %40 = load i32* %v, align 4
  %add26 = add nsw i32 %mul25, %40
  %mul27 = mul nsw i32 2, %add26
  %idxprom28 = sext i32 %mul27 to i64
  %41 = load double** %dest.addr, align 8
  %arrayidx29 = getelementptr inbounds double* %41, i64 %idxprom28
  store double %37, double* %arrayidx29, align 8
  %42 = load i32* %v, align 4
  %43 = load i32* %n1p, align 4
  %mul30 = mul nsw i32 %42, %43
  %44 = load i32* %h, align 4
  %add31 = add nsw i32 %mul30, %44
  %mul32 = mul nsw i32 2, %add31
  %add33 = add nsw i32 %mul32, 1
  %idxprom34 = sext i32 %add33 to i64
  %45 = load double** %src.addr, align 8
  %arrayidx35 = getelementptr inbounds double* %45, i64 %idxprom34
  %46 = load double* %arrayidx35, align 8
  %47 = load i32* %h, align 4
  %48 = load i32* %n1p, align 4
  %mul36 = mul nsw i32 %47, %48
  %49 = load i32* %v, align 4
  %add37 = add nsw i32 %mul36, %49
  %mul38 = mul nsw i32 2, %add37
  %add39 = add nsw i32 %mul38, 1
  %idxprom40 = sext i32 %add39 to i64
  %50 = load double** %dest.addr, align 8
  %arrayidx41 = getelementptr inbounds double* %50, i64 %idxprom40
  store double %46, double* %arrayidx41, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.20
  %51 = load i32* %j, align 4
  %inc42 = add nsw i32 %51, 1
  store i32 %inc42, i32* %j, align 4
  br label %for.cond.18

for.end:                                          ; preds = %for.cond.18
  br label %for.inc.43

for.inc.43:                                       ; preds = %for.end
  %52 = load i32* %i, align 4
  %inc44 = add nsw i32 %52, 1
  store i32 %inc44, i32* %i, align 4
  br label %for.cond.14

for.end.45:                                       ; preds = %for.cond.14
  %53 = load i32* %blksize, align 4
  %54 = load i32* %h_off, align 4
  %add46 = add nsw i32 %54, %53
  store i32 %add46, i32* %h_off, align 4
  br label %for.inc.47

for.inc.47:                                       ; preds = %for.end.45
  %55 = load i32* %m, align 4
  %inc48 = add nsw i32 %55, 1
  store i32 %inc48, i32* %m, align 4
  br label %for.cond.11

for.end.49:                                       ; preds = %for.cond.11
  %56 = load i32* %blksize, align 4
  %57 = load i32* %v_off, align 4
  %add50 = add nsw i32 %57, %56
  store i32 %add50, i32* %v_off, align 4
  br label %for.inc.51

for.inc.51:                                       ; preds = %for.end.49
  %58 = load i32* %k, align 4
  %inc52 = add nsw i32 %58, 1
  store i32 %inc52, i32* %k, align 4
  br label %for.cond.8

for.end.53:                                       ; preds = %for.cond.8
  br label %for.inc.54

for.inc.54:                                       ; preds = %for.end.53
  %59 = load i32* %l, align 4
  %inc55 = add nsw i32 %59, 1
  store i32 %inc55, i32* %l, align 4
  br label %for.cond

for.end.56:                                       ; preds = %for.cond
  store i32 0, i32* %l, align 4
  br label %for.cond.57

for.cond.57:                                      ; preds = %for.inc.111, %for.end.56
  %60 = load i32* %l, align 4
  %61 = load i32* %MyNum.addr, align 4
  %cmp58 = icmp slt i32 %60, %61
  br i1 %cmp58, label %for.body.59, label %for.end.113

for.body.59:                                      ; preds = %for.cond.57
  %62 = load i32* %l, align 4
  %63 = load i32* %row_count, align 4
  %mul60 = mul nsw i32 %62, %63
  store i32 %mul60, i32* %v_off, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond.61

for.cond.61:                                      ; preds = %for.inc.108, %for.body.59
  %64 = load i32* %k, align 4
  %65 = load i32* %numblks, align 4
  %cmp62 = icmp slt i32 %64, %65
  br i1 %cmp62, label %for.body.63, label %for.end.110

for.body.63:                                      ; preds = %for.cond.61
  %66 = load i32* %firstfirst, align 4
  store i32 %66, i32* %h_off, align 4
  store i32 0, i32* %m, align 4
  br label %for.cond.64

for.cond.64:                                      ; preds = %for.inc.104, %for.body.63
  %67 = load i32* %m, align 4
  %68 = load i32* %numblks, align 4
  %cmp65 = icmp slt i32 %67, %68
  br i1 %cmp65, label %for.body.66, label %for.end.106

for.body.66:                                      ; preds = %for.cond.64
  store i32 0, i32* %i, align 4
  br label %for.cond.67

for.cond.67:                                      ; preds = %for.inc.100, %for.body.66
  %69 = load i32* %i, align 4
  %70 = load i32* %blksize, align 4
  %cmp68 = icmp slt i32 %69, %70
  br i1 %cmp68, label %for.body.69, label %for.end.102

for.body.69:                                      ; preds = %for.cond.67
  %71 = load i32* %v_off, align 4
  %72 = load i32* %i, align 4
  %add70 = add nsw i32 %71, %72
  store i32 %add70, i32* %v, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond.71

for.cond.71:                                      ; preds = %for.inc.97, %for.body.69
  %73 = load i32* %j, align 4
  %74 = load i32* %blksize, align 4
  %cmp72 = icmp slt i32 %73, %74
  br i1 %cmp72, label %for.body.73, label %for.end.99

for.body.73:                                      ; preds = %for.cond.71
  %75 = load i32* %h_off, align 4
  %76 = load i32* %j, align 4
  %add74 = add nsw i32 %75, %76
  store i32 %add74, i32* %h, align 4
  %77 = load i32* %v, align 4
  %78 = load i32* %n1p, align 4
  %mul75 = mul nsw i32 %77, %78
  %79 = load i32* %h, align 4
  %add76 = add nsw i32 %mul75, %79
  %mul77 = mul nsw i32 2, %add76
  %idxprom78 = sext i32 %mul77 to i64
  %80 = load double** %src.addr, align 8
  %arrayidx79 = getelementptr inbounds double* %80, i64 %idxprom78
  %81 = load double* %arrayidx79, align 8
  %82 = load i32* %h, align 4
  %83 = load i32* %n1p, align 4
  %mul80 = mul nsw i32 %82, %83
  %84 = load i32* %v, align 4
  %add81 = add nsw i32 %mul80, %84
  %mul82 = mul nsw i32 2, %add81
  %idxprom83 = sext i32 %mul82 to i64
  %85 = load double** %dest.addr, align 8
  %arrayidx84 = getelementptr inbounds double* %85, i64 %idxprom83
  store double %81, double* %arrayidx84, align 8
  %86 = load i32* %v, align 4
  %87 = load i32* %n1p, align 4
  %mul85 = mul nsw i32 %86, %87
  %88 = load i32* %h, align 4
  %add86 = add nsw i32 %mul85, %88
  %mul87 = mul nsw i32 2, %add86
  %add88 = add nsw i32 %mul87, 1
  %idxprom89 = sext i32 %add88 to i64
  %89 = load double** %src.addr, align 8
  %arrayidx90 = getelementptr inbounds double* %89, i64 %idxprom89
  %90 = load double* %arrayidx90, align 8
  %91 = load i32* %h, align 4
  %92 = load i32* %n1p, align 4
  %mul91 = mul nsw i32 %91, %92
  %93 = load i32* %v, align 4
  %add92 = add nsw i32 %mul91, %93
  %mul93 = mul nsw i32 2, %add92
  %add94 = add nsw i32 %mul93, 1
  %idxprom95 = sext i32 %add94 to i64
  %94 = load double** %dest.addr, align 8
  %arrayidx96 = getelementptr inbounds double* %94, i64 %idxprom95
  store double %90, double* %arrayidx96, align 8
  br label %for.inc.97

for.inc.97:                                       ; preds = %for.body.73
  %95 = load i32* %j, align 4
  %inc98 = add nsw i32 %95, 1
  store i32 %inc98, i32* %j, align 4
  br label %for.cond.71

for.end.99:                                       ; preds = %for.cond.71
  br label %for.inc.100

for.inc.100:                                      ; preds = %for.end.99
  %96 = load i32* %i, align 4
  %inc101 = add nsw i32 %96, 1
  store i32 %inc101, i32* %i, align 4
  br label %for.cond.67

for.end.102:                                      ; preds = %for.cond.67
  %97 = load i32* %blksize, align 4
  %98 = load i32* %h_off, align 4
  %add103 = add nsw i32 %98, %97
  store i32 %add103, i32* %h_off, align 4
  br label %for.inc.104

for.inc.104:                                      ; preds = %for.end.102
  %99 = load i32* %m, align 4
  %inc105 = add nsw i32 %99, 1
  store i32 %inc105, i32* %m, align 4
  br label %for.cond.64

for.end.106:                                      ; preds = %for.cond.64
  %100 = load i32* %blksize, align 4
  %101 = load i32* %v_off, align 4
  %add107 = add nsw i32 %101, %100
  store i32 %add107, i32* %v_off, align 4
  br label %for.inc.108

for.inc.108:                                      ; preds = %for.end.106
  %102 = load i32* %k, align 4
  %inc109 = add nsw i32 %102, 1
  store i32 %inc109, i32* %k, align 4
  br label %for.cond.61

for.end.110:                                      ; preds = %for.cond.61
  br label %for.inc.111

for.inc.111:                                      ; preds = %for.end.110
  %103 = load i32* %l, align 4
  %inc112 = add nsw i32 %103, 1
  store i32 %inc112, i32* %l, align 4
  br label %for.cond.57

for.end.113:                                      ; preds = %for.cond.57
  %104 = load i32* %MyNum.addr, align 4
  %105 = load i32* %row_count, align 4
  %mul114 = mul nsw i32 %104, %105
  store i32 %mul114, i32* %v_off, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond.115

for.cond.115:                                     ; preds = %for.inc.162, %for.end.113
  %106 = load i32* %k, align 4
  %107 = load i32* %numblks, align 4
  %cmp116 = icmp slt i32 %106, %107
  br i1 %cmp116, label %for.body.117, label %for.end.164

for.body.117:                                     ; preds = %for.cond.115
  %108 = load i32* %firstfirst, align 4
  store i32 %108, i32* %h_off, align 4
  store i32 0, i32* %m, align 4
  br label %for.cond.118

for.cond.118:                                     ; preds = %for.inc.158, %for.body.117
  %109 = load i32* %m, align 4
  %110 = load i32* %numblks, align 4
  %cmp119 = icmp slt i32 %109, %110
  br i1 %cmp119, label %for.body.120, label %for.end.160

for.body.120:                                     ; preds = %for.cond.118
  store i32 0, i32* %i, align 4
  br label %for.cond.121

for.cond.121:                                     ; preds = %for.inc.154, %for.body.120
  %111 = load i32* %i, align 4
  %112 = load i32* %blksize, align 4
  %cmp122 = icmp slt i32 %111, %112
  br i1 %cmp122, label %for.body.123, label %for.end.156

for.body.123:                                     ; preds = %for.cond.121
  %113 = load i32* %v_off, align 4
  %114 = load i32* %i, align 4
  %add124 = add nsw i32 %113, %114
  store i32 %add124, i32* %v, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond.125

for.cond.125:                                     ; preds = %for.inc.151, %for.body.123
  %115 = load i32* %j, align 4
  %116 = load i32* %blksize, align 4
  %cmp126 = icmp slt i32 %115, %116
  br i1 %cmp126, label %for.body.127, label %for.end.153

for.body.127:                                     ; preds = %for.cond.125
  %117 = load i32* %h_off, align 4
  %118 = load i32* %j, align 4
  %add128 = add nsw i32 %117, %118
  store i32 %add128, i32* %h, align 4
  %119 = load i32* %v, align 4
  %120 = load i32* %n1p, align 4
  %mul129 = mul nsw i32 %119, %120
  %121 = load i32* %h, align 4
  %add130 = add nsw i32 %mul129, %121
  %mul131 = mul nsw i32 2, %add130
  %idxprom132 = sext i32 %mul131 to i64
  %122 = load double** %src.addr, align 8
  %arrayidx133 = getelementptr inbounds double* %122, i64 %idxprom132
  %123 = load double* %arrayidx133, align 8
  %124 = load i32* %h, align 4
  %125 = load i32* %n1p, align 4
  %mul134 = mul nsw i32 %124, %125
  %126 = load i32* %v, align 4
  %add135 = add nsw i32 %mul134, %126
  %mul136 = mul nsw i32 2, %add135
  %idxprom137 = sext i32 %mul136 to i64
  %127 = load double** %dest.addr, align 8
  %arrayidx138 = getelementptr inbounds double* %127, i64 %idxprom137
  store double %123, double* %arrayidx138, align 8
  %128 = load i32* %v, align 4
  %129 = load i32* %n1p, align 4
  %mul139 = mul nsw i32 %128, %129
  %130 = load i32* %h, align 4
  %add140 = add nsw i32 %mul139, %130
  %mul141 = mul nsw i32 2, %add140
  %add142 = add nsw i32 %mul141, 1
  %idxprom143 = sext i32 %add142 to i64
  %131 = load double** %src.addr, align 8
  %arrayidx144 = getelementptr inbounds double* %131, i64 %idxprom143
  %132 = load double* %arrayidx144, align 8
  %133 = load i32* %h, align 4
  %134 = load i32* %n1p, align 4
  %mul145 = mul nsw i32 %133, %134
  %135 = load i32* %v, align 4
  %add146 = add nsw i32 %mul145, %135
  %mul147 = mul nsw i32 2, %add146
  %add148 = add nsw i32 %mul147, 1
  %idxprom149 = sext i32 %add148 to i64
  %136 = load double** %dest.addr, align 8
  %arrayidx150 = getelementptr inbounds double* %136, i64 %idxprom149
  store double %132, double* %arrayidx150, align 8
  br label %for.inc.151

for.inc.151:                                      ; preds = %for.body.127
  %137 = load i32* %j, align 4
  %inc152 = add nsw i32 %137, 1
  store i32 %inc152, i32* %j, align 4
  br label %for.cond.125

for.end.153:                                      ; preds = %for.cond.125
  br label %for.inc.154

for.inc.154:                                      ; preds = %for.end.153
  %138 = load i32* %i, align 4
  %inc155 = add nsw i32 %138, 1
  store i32 %inc155, i32* %i, align 4
  br label %for.cond.121

for.end.156:                                      ; preds = %for.cond.121
  %139 = load i32* %blksize, align 4
  %140 = load i32* %h_off, align 4
  %add157 = add nsw i32 %140, %139
  store i32 %add157, i32* %h_off, align 4
  br label %for.inc.158

for.inc.158:                                      ; preds = %for.end.156
  %141 = load i32* %m, align 4
  %inc159 = add nsw i32 %141, 1
  store i32 %inc159, i32* %m, align 4
  br label %for.cond.118

for.end.160:                                      ; preds = %for.cond.118
  %142 = load i32* %blksize, align 4
  %143 = load i32* %v_off, align 4
  %add161 = add nsw i32 %143, %142
  store i32 %add161, i32* %v_off, align 4
  br label %for.inc.162

for.inc.162:                                      ; preds = %for.end.160
  %144 = load i32* %k, align 4
  %inc163 = add nsw i32 %144, 1
  store i32 %inc163, i32* %k, align 4
  br label %for.cond.115

for.end.164:                                      ; preds = %for.cond.115
  %145 = load i32* %retval
  ret i32 %145
}

; Function Attrs: nounwind uwtable
define internal i32 @CopyColumn(i32 %n1, double* %src, double* %dest) {
entry:
  %retval = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %src.addr = alloca double*, align 8
  %dest.addr = alloca double*, align 8
  %i = alloca i32, align 4
  store i32 %n1, i32* %n1.addr, align 4
  store double* %src, double** %src.addr, align 8
  store double* %dest, double** %dest.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %n1.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %i, align 4
  %mul = mul nsw i32 2, %2
  %idxprom = sext i32 %mul to i64
  %3 = load double** %src.addr, align 8
  %arrayidx = getelementptr inbounds double* %3, i64 %idxprom
  %4 = load double* %arrayidx, align 8
  %5 = load i32* %i, align 4
  %mul1 = mul nsw i32 2, %5
  %idxprom2 = sext i32 %mul1 to i64
  %6 = load double** %dest.addr, align 8
  %arrayidx3 = getelementptr inbounds double* %6, i64 %idxprom2
  store double %4, double* %arrayidx3, align 8
  %7 = load i32* %i, align 4
  %mul4 = mul nsw i32 2, %7
  %add = add nsw i32 %mul4, 1
  %idxprom5 = sext i32 %add to i64
  %8 = load double** %src.addr, align 8
  %arrayidx6 = getelementptr inbounds double* %8, i64 %idxprom5
  %9 = load double* %arrayidx6, align 8
  %10 = load i32* %i, align 4
  %mul7 = mul nsw i32 2, %10
  %add8 = add nsw i32 %mul7, 1
  %idxprom9 = sext i32 %add8 to i64
  %11 = load double** %dest.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %11, i64 %idxprom9
  store double %9, double* %arrayidx10, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %12 = load i32* %i, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %13 = load i32* %retval
  ret i32 %13
}

; Function Attrs: nounwind uwtable
define internal i32 @Reverse(i32 %N, i32 %M, double* %x) {
entry:
  %retval = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %M.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %tmp = alloca double, align 8
  %tmp12 = alloca double, align 8
  store i32 %N, i32* %N.addr, align 4
  store i32 %M, i32* %M.addr, align 4
  store double* %x, double** %x.addr, align 8
  store i32 0, i32* %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %k, align 4
  %1 = load i32* %N.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %M.addr, align 4
  %3 = load i32* %k, align 4
  %call = call i32 @BitReverse(i32 %2, i32 %3)
  store i32 %call, i32* %j, align 4
  %4 = load i32* %j, align 4
  %5 = load i32* %k, align 4
  %cmp1 = icmp sgt i32 %4, %5
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %6 = load i32* %j, align 4
  %mul = mul nsw i32 2, %6
  %idxprom = sext i32 %mul to i64
  %7 = load double** %x.addr, align 8
  %arrayidx = getelementptr inbounds double* %7, i64 %idxprom
  %8 = load double* %arrayidx, align 8
  store double %8, double* %tmp, align 8
  %9 = load i32* %k, align 4
  %mul2 = mul nsw i32 2, %9
  %idxprom3 = sext i32 %mul2 to i64
  %10 = load double** %x.addr, align 8
  %arrayidx4 = getelementptr inbounds double* %10, i64 %idxprom3
  %11 = load double* %arrayidx4, align 8
  %12 = load i32* %j, align 4
  %mul5 = mul nsw i32 2, %12
  %idxprom6 = sext i32 %mul5 to i64
  %13 = load double** %x.addr, align 8
  %arrayidx7 = getelementptr inbounds double* %13, i64 %idxprom6
  store double %11, double* %arrayidx7, align 8
  %14 = load double* %tmp, align 8
  %15 = load i32* %k, align 4
  %mul8 = mul nsw i32 2, %15
  %idxprom9 = sext i32 %mul8 to i64
  %16 = load double** %x.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %16, i64 %idxprom9
  store double %14, double* %arrayidx10, align 8
  %17 = load i32* %j, align 4
  %mul13 = mul nsw i32 2, %17
  %add = add nsw i32 %mul13, 1
  %idxprom14 = sext i32 %add to i64
  %18 = load double** %x.addr, align 8
  %arrayidx15 = getelementptr inbounds double* %18, i64 %idxprom14
  %19 = load double* %arrayidx15, align 8
  store double %19, double* %tmp12, align 8
  %20 = load i32* %k, align 4
  %mul16 = mul nsw i32 2, %20
  %add17 = add nsw i32 %mul16, 1
  %idxprom18 = sext i32 %add17 to i64
  %21 = load double** %x.addr, align 8
  %arrayidx19 = getelementptr inbounds double* %21, i64 %idxprom18
  %22 = load double* %arrayidx19, align 8
  %23 = load i32* %j, align 4
  %mul20 = mul nsw i32 2, %23
  %add21 = add nsw i32 %mul20, 1
  %idxprom22 = sext i32 %add21 to i64
  %24 = load double** %x.addr, align 8
  %arrayidx23 = getelementptr inbounds double* %24, i64 %idxprom22
  store double %22, double* %arrayidx23, align 8
  %25 = load double* %tmp12, align 8
  %26 = load i32* %k, align 4
  %mul24 = mul nsw i32 2, %26
  %add25 = add nsw i32 %mul24, 1
  %idxprom26 = sext i32 %add25 to i64
  %27 = load double** %x.addr, align 8
  %arrayidx27 = getelementptr inbounds double* %27, i64 %idxprom26
  store double %25, double* %arrayidx27, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %28 = load i32* %k, align 4
  %inc = add nsw i32 %28, 1
  store i32 %inc, i32* %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %29 = load i32* %retval
  ret i32 %29
}

; Function Attrs: nounwind uwtable
define internal i32 @FFT1DOnce(i32 %direction, i32 %M, i32 %N, double* %u, double* %x) {
entry:
  %retval = alloca i32, align 4
  %direction.addr = alloca i32, align 4
  %M.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %u.addr = alloca double*, align 8
  %x.addr = alloca double*, align 8
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %q = alloca i32, align 4
  %L = alloca i32, align 4
  %r = alloca i32, align 4
  %Lstar = alloca i32, align 4
  %u1 = alloca double*, align 8
  %x1 = alloca double*, align 8
  %x2 = alloca double*, align 8
  %omega_r = alloca double, align 8
  %omega_c = alloca double, align 8
  %tau_r = alloca double, align 8
  %tau_c = alloca double, align 8
  %x_r = alloca double, align 8
  %x_c = alloca double, align 8
  store i32 %direction, i32* %direction.addr, align 4
  store i32 %M, i32* %M.addr, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %u, double** %u.addr, align 8
  store double* %x, double** %x.addr, align 8
  %0 = load i32* %N.addr, align 4
  %1 = load i32* %M.addr, align 4
  %2 = load double** %x.addr, align 8
  %call = call i32 @Reverse(i32 %0, i32 %1, double* %2)
  store i32 1, i32* %q, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.65, %entry
  %3 = load i32* %q, align 4
  %4 = load i32* %M.addr, align 4
  %cmp = icmp sle i32 %3, %4
  br i1 %cmp, label %for.body, label %for.end.67

for.body:                                         ; preds = %for.cond
  %5 = load i32* %q, align 4
  %shl = shl i32 1, %5
  store i32 %shl, i32* %L, align 4
  %6 = load i32* %N.addr, align 4
  %7 = load i32* %L, align 4
  %div = sdiv i32 %6, %7
  store i32 %div, i32* %r, align 4
  %8 = load i32* %L, align 4
  %div1 = sdiv i32 %8, 2
  store i32 %div1, i32* %Lstar, align 4
  %9 = load i32* %Lstar, align 4
  %sub = sub nsw i32 %9, 1
  %mul = mul nsw i32 2, %sub
  %idxprom = sext i32 %mul to i64
  %10 = load double** %u.addr, align 8
  %arrayidx = getelementptr inbounds double* %10, i64 %idxprom
  store double* %arrayidx, double** %u1, align 8
  store i32 0, i32* %k, align 4
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc.62, %for.body
  %11 = load i32* %k, align 4
  %12 = load i32* %r, align 4
  %cmp3 = icmp slt i32 %11, %12
  br i1 %cmp3, label %for.body.4, label %for.end.64

for.body.4:                                       ; preds = %for.cond.2
  %13 = load i32* %k, align 4
  %14 = load i32* %L, align 4
  %mul5 = mul nsw i32 %13, %14
  %mul6 = mul nsw i32 2, %mul5
  %idxprom7 = sext i32 %mul6 to i64
  %15 = load double** %x.addr, align 8
  %arrayidx8 = getelementptr inbounds double* %15, i64 %idxprom7
  store double* %arrayidx8, double** %x1, align 8
  %16 = load i32* %k, align 4
  %17 = load i32* %L, align 4
  %mul9 = mul nsw i32 %16, %17
  %18 = load i32* %Lstar, align 4
  %add = add nsw i32 %mul9, %18
  %mul10 = mul nsw i32 2, %add
  %idxprom11 = sext i32 %mul10 to i64
  %19 = load double** %x.addr, align 8
  %arrayidx12 = getelementptr inbounds double* %19, i64 %idxprom11
  store double* %arrayidx12, double** %x2, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond.13

for.cond.13:                                      ; preds = %for.inc, %for.body.4
  %20 = load i32* %j, align 4
  %21 = load i32* %Lstar, align 4
  %cmp14 = icmp slt i32 %20, %21
  br i1 %cmp14, label %for.body.15, label %for.end

for.body.15:                                      ; preds = %for.cond.13
  %22 = load i32* %j, align 4
  %mul16 = mul nsw i32 2, %22
  %idxprom17 = sext i32 %mul16 to i64
  %23 = load double** %u1, align 8
  %arrayidx18 = getelementptr inbounds double* %23, i64 %idxprom17
  %24 = load double* %arrayidx18, align 8
  store double %24, double* %omega_r, align 8
  %25 = load i32* %direction.addr, align 4
  %conv = sitofp i32 %25 to double
  %26 = load i32* %j, align 4
  %mul19 = mul nsw i32 2, %26
  %add20 = add nsw i32 %mul19, 1
  %idxprom21 = sext i32 %add20 to i64
  %27 = load double** %u1, align 8
  %arrayidx22 = getelementptr inbounds double* %27, i64 %idxprom21
  %28 = load double* %arrayidx22, align 8
  %mul23 = fmul double %conv, %28
  store double %mul23, double* %omega_c, align 8
  %29 = load i32* %j, align 4
  %mul24 = mul nsw i32 2, %29
  %idxprom25 = sext i32 %mul24 to i64
  %30 = load double** %x2, align 8
  %arrayidx26 = getelementptr inbounds double* %30, i64 %idxprom25
  %31 = load double* %arrayidx26, align 8
  store double %31, double* %x_r, align 8
  %32 = load i32* %j, align 4
  %mul27 = mul nsw i32 2, %32
  %add28 = add nsw i32 %mul27, 1
  %idxprom29 = sext i32 %add28 to i64
  %33 = load double** %x2, align 8
  %arrayidx30 = getelementptr inbounds double* %33, i64 %idxprom29
  %34 = load double* %arrayidx30, align 8
  store double %34, double* %x_c, align 8
  %35 = load double* %omega_r, align 8
  %36 = load double* %x_r, align 8
  %mul31 = fmul double %35, %36
  %37 = load double* %omega_c, align 8
  %38 = load double* %x_c, align 8
  %mul32 = fmul double %37, %38
  %sub33 = fsub double %mul31, %mul32
  store double %sub33, double* %tau_r, align 8
  %39 = load double* %omega_r, align 8
  %40 = load double* %x_c, align 8
  %mul34 = fmul double %39, %40
  %41 = load double* %omega_c, align 8
  %42 = load double* %x_r, align 8
  %mul35 = fmul double %41, %42
  %add36 = fadd double %mul34, %mul35
  store double %add36, double* %tau_c, align 8
  %43 = load i32* %j, align 4
  %mul37 = mul nsw i32 2, %43
  %idxprom38 = sext i32 %mul37 to i64
  %44 = load double** %x1, align 8
  %arrayidx39 = getelementptr inbounds double* %44, i64 %idxprom38
  %45 = load double* %arrayidx39, align 8
  store double %45, double* %x_r, align 8
  %46 = load i32* %j, align 4
  %mul40 = mul nsw i32 2, %46
  %add41 = add nsw i32 %mul40, 1
  %idxprom42 = sext i32 %add41 to i64
  %47 = load double** %x1, align 8
  %arrayidx43 = getelementptr inbounds double* %47, i64 %idxprom42
  %48 = load double* %arrayidx43, align 8
  store double %48, double* %x_c, align 8
  %49 = load double* %x_r, align 8
  %50 = load double* %tau_r, align 8
  %sub44 = fsub double %49, %50
  %51 = load i32* %j, align 4
  %mul45 = mul nsw i32 2, %51
  %idxprom46 = sext i32 %mul45 to i64
  %52 = load double** %x2, align 8
  %arrayidx47 = getelementptr inbounds double* %52, i64 %idxprom46
  store double %sub44, double* %arrayidx47, align 8
  %53 = load double* %x_c, align 8
  %54 = load double* %tau_c, align 8
  %sub48 = fsub double %53, %54
  %55 = load i32* %j, align 4
  %mul49 = mul nsw i32 2, %55
  %add50 = add nsw i32 %mul49, 1
  %idxprom51 = sext i32 %add50 to i64
  %56 = load double** %x2, align 8
  %arrayidx52 = getelementptr inbounds double* %56, i64 %idxprom51
  store double %sub48, double* %arrayidx52, align 8
  %57 = load double* %x_r, align 8
  %58 = load double* %tau_r, align 8
  %add53 = fadd double %57, %58
  %59 = load i32* %j, align 4
  %mul54 = mul nsw i32 2, %59
  %idxprom55 = sext i32 %mul54 to i64
  %60 = load double** %x1, align 8
  %arrayidx56 = getelementptr inbounds double* %60, i64 %idxprom55
  store double %add53, double* %arrayidx56, align 8
  %61 = load double* %x_c, align 8
  %62 = load double* %tau_c, align 8
  %add57 = fadd double %61, %62
  %63 = load i32* %j, align 4
  %mul58 = mul nsw i32 2, %63
  %add59 = add nsw i32 %mul58, 1
  %idxprom60 = sext i32 %add59 to i64
  %64 = load double** %x1, align 8
  %arrayidx61 = getelementptr inbounds double* %64, i64 %idxprom60
  store double %add57, double* %arrayidx61, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.15
  %65 = load i32* %j, align 4
  %inc = add nsw i32 %65, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.13

for.end:                                          ; preds = %for.cond.13
  br label %for.inc.62

for.inc.62:                                       ; preds = %for.end
  %66 = load i32* %k, align 4
  %inc63 = add nsw i32 %66, 1
  store i32 %inc63, i32* %k, align 4
  br label %for.cond.2

for.end.64:                                       ; preds = %for.cond.2
  br label %for.inc.65

for.inc.65:                                       ; preds = %for.end.64
  %67 = load i32* %q, align 4
  %inc66 = add nsw i32 %67, 1
  store i32 %inc66, i32* %q, align 4
  br label %for.cond

for.end.67:                                       ; preds = %for.cond
  %68 = load i32* %retval
  ret i32 %68
}

; Function Attrs: nounwind uwtable
define internal i32 @PrintArray(i32 %N, double* %x) {
entry:
  %retval = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  store double* %x, double** %x.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.22, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* @rootN, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.24

for.body:                                         ; preds = %for.cond
  %2 = load i32* %i, align 4
  %3 = load i32* @rootN, align 4
  %4 = load i32* @pad_length, align 4
  %add = add nsw i32 %3, %4
  %mul = mul nsw i32 %2, %add
  store i32 %mul, i32* %k, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %5 = load i32* %j, align 4
  %6 = load i32* @rootN, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %7 = load i32* %k, align 4
  %8 = load i32* %j, align 4
  %add4 = add nsw i32 %7, %8
  %mul5 = mul nsw i32 2, %add4
  %idxprom = sext i32 %mul5 to i64
  %9 = load double** %x.addr, align 8
  %arrayidx = getelementptr inbounds double* %9, i64 %idxprom
  %10 = load double* %arrayidx, align 8
  %11 = load i32* %k, align 4
  %12 = load i32* %j, align 4
  %add6 = add nsw i32 %11, %12
  %mul7 = mul nsw i32 2, %add6
  %add8 = add nsw i32 %mul7, 1
  %idxprom9 = sext i32 %add8 to i64
  %13 = load double** %x.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %13, i64 %idxprom9
  %14 = load double* %arrayidx10, align 8
  %call = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([13 x i8]* @.str.64, i32 0, i32 0), double %10, double %14)
  %15 = load i32* %i, align 4
  %16 = load i32* @rootN, align 4
  %mul11 = mul nsw i32 %15, %16
  %17 = load i32* %j, align 4
  %add12 = add nsw i32 %mul11, %17
  %18 = load i32* %N.addr, align 4
  %sub = sub nsw i32 %18, 1
  %cmp13 = icmp ne i32 %add12, %sub
  br i1 %cmp13, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.3
  %call14 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.65, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body.3
  %19 = load i32* %i, align 4
  %20 = load i32* @rootN, align 4
  %mul15 = mul nsw i32 %19, %20
  %21 = load i32* %j, align 4
  %add16 = add nsw i32 %mul15, %21
  %add17 = add nsw i32 %add16, 1
  %rem = srem i32 %add17, 8
  %cmp18 = icmp eq i32 %rem, 0
  br i1 %cmp18, label %if.then.19, label %if.end.21

if.then.19:                                       ; preds = %if.end
  %call20 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  br label %if.end.21

if.end.21:                                        ; preds = %if.then.19, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.21
  %22 = load i32* %j, align 4
  %inc = add nsw i32 %22, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.22

for.inc.22:                                       ; preds = %for.end
  %23 = load i32* %i, align 4
  %inc23 = add nsw i32 %23, 1
  store i32 %inc23, i32* %i, align 4
  br label %for.cond

for.end.24:                                       ; preds = %for.cond
  %call25 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %call26 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.30, i32 0, i32 0))
  %24 = load i32* %retval
  ret i32 %24
}

; Function Attrs: nounwind uwtable
define internal void @DeriveInvariant() {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckInvariant() {
entry:
  ret void
}

define internal void @RecordSyncVariable() {
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

; Function Attrs: nounwind uwtable
define internal void @appendY() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 89, i8* %arrayidx, align 1
  %1 = load i32* @index_out, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

define internal void @printY() {
entry:
  call void @appendY()
  call void @DecrementCounter()
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DecrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %i13 = alloca i32, align 4
  %call = call i32 (...) *bitcast (i64 ()* @pthread_self to i32 (...)*)()
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
  call void @flushAll()
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
  call void @flushAll()
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
  %call = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([4 x i8]* @.str.67, i32 0, i32 0), i8* getelementptr inbounds ([200 x i8]* @mystring, i32 0, i32 0))
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
  %call = call i32 (...) *bitcast (i64 ()* @pthread_self to i32 (...)*)()
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

define internal void @InitializeSwitchesAndCounter(i32 %id) {
entry:
  %id.addr = alloca i32, align 4
  store i32 %id, i32* %id.addr, align 4
  ret void
}

define internal void @IncrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %call = call i32 (...) *bitcast (i64 ()* @pthread_self to i32 (...)*)()
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
  %3 = load i32* @counter0, align 4
  %cmp1 = icmp eq i32 %3, 1
  br i1 %cmp1, label %if.then.2, label %if.end

if.then.2:                                        ; preds = %if.then
  call void @CheckInvariant()
  br label %if.end

if.end:                                           ; preds = %if.then.2, %if.then
  %4 = load i8* @firstSync, align 1
  %tobool = trunc i8 %4 to i1
  br i1 %tobool, label %if.then.3, label %if.end.8

if.then.3:                                        ; preds = %if.end
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.3
  %5 = load i32* %i, align 4
  %cmp4 = icmp slt i32 %5, 3
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4
  %idxprom5 = sext i32 %6 to i64
  %arrayidx6 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom5
  store i8 1, i8* %arrayidx6, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc7 = add nsw i32 %7, 1
  store i32 %inc7, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i8 0, i8* @firstSync, align 1
  br label %if.end.8

if.end.8:                                         ; preds = %for.end, %if.end
  br label %if.end.13

if.else:                                          ; preds = %entry
  %8 = load i32* @counter1, align 4
  %inc9 = add nsw i32 %8, 1
  store i32 %inc9, i32* @counter1, align 4
  %9 = load i32* @counter1, align 4
  %cmp10 = icmp eq i32 %9, 1
  br i1 %cmp10, label %if.then.11, label %if.end.12

if.then.11:                                       ; preds = %if.else
  call void @CheckInvariant()
  br label %if.end.12

if.end.12:                                        ; preds = %if.then.11, %if.else
  br label %if.end.13

if.end.13:                                        ; preds = %if.end.12, %if.end.8
  ret void
}

declare i32 @sleep(i32)


