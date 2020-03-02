; ModuleID = 'a.out.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.GlobalMemory = type { i32, %union.pthread_mutex_t, %struct.barrier_t, i32*, i32*, i32, i32, i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.barrier_t = type { i32, i64 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }

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
@.str.24 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for Global\0A\00", align 1
@.str.25 = private unnamed_addr constant [31 x i8] c"Could not malloc memory for x\0A\00", align 1
@.str.26 = private unnamed_addr constant [35 x i8] c"Could not malloc memory for trans\0A\00", align 1
@.str.27 = private unnamed_addr constant [35 x i8] c"Could not malloc memory for umain\0A\00", align 1
@.str.28 = private unnamed_addr constant [36 x i8] c"Could not malloc memory for umain2\0A\00", align 1
@.str.29 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.30 = private unnamed_addr constant [29 x i8] c"FFT with Blocking Transpose\0A\00", align 1
@.str.31 = private unnamed_addr constant [23 x i8] c"   %d Complex Doubles\0A\00", align 1
@.str.32 = private unnamed_addr constant [18 x i8] c"   %d Processors\0A\00", align 1
@.str.33 = private unnamed_addr constant [19 x i8] c"   %d Cache lines\0A\00", align 1
@.str.34 = private unnamed_addr constant [42 x i8] c"   %d Cache lines for blocking transpose\0A\00", align 1
@.str.35 = private unnamed_addr constant [22 x i8] c"   %d Byte line size\0A\00", align 1
@.str.36 = private unnamed_addr constant [22 x i8] c"   %d Bytes per page\0A\00", align 1
@.str.37 = private unnamed_addr constant [23 x i8] c"Original data values:\0A\00", align 1
@.str.38 = private unnamed_addr constant [9 x i8] c"main %d\0A\00", align 1
@.str.39 = private unnamed_addr constant [32 x i8] c"Data values after inverse FFT:\0A\00", align 1
@.str.40 = private unnamed_addr constant [24 x i8] c"Data values after FFT:\0A\00", align 1
@.str.41 = private unnamed_addr constant [37 x i8] c"                 PROCESS STATISTICS\0A\00", align 1
@.str.42 = private unnamed_addr constant [54 x i8] c"            Computation      Transpose     Transpose\0A\00", align 1
@.str.43 = private unnamed_addr constant [53 x i8] c" Proc          Time            Time        Fraction\0A\00", align 1
@.str.44 = private unnamed_addr constant [39 x i8] c"    0        %10d     %10d      %8.5f\0A\00", align 1
@.str.45 = private unnamed_addr constant [39 x i8] c"  %3d        %10d     %10d      %8.5f\0A\00", align 1
@.str.46 = private unnamed_addr constant [43 x i8] c"  Avg        %10.0f     %10.0f      %8.5f\0A\00", align 1
@.str.47 = private unnamed_addr constant [39 x i8] c"  Max        %10d     %10d      %8.5f\0A\00", align 1
@.str.48 = private unnamed_addr constant [39 x i8] c"  Min        %10d     %10d      %8.5f\0A\00", align 1
@.str.49 = private unnamed_addr constant [37 x i8] c"                 TIMING INFORMATION\0A\00", align 1
@.str.50 = private unnamed_addr constant [42 x i8] c"Start time                        : %16d\0A\00", align 1
@.str.51 = private unnamed_addr constant [42 x i8] c"Initialization finish time        : %16d\0A\00", align 1
@.str.52 = private unnamed_addr constant [42 x i8] c"Overall finish time               : %16d\0A\00", align 1
@.str.53 = private unnamed_addr constant [42 x i8] c"Total time with initialization    : %16d\0A\00", align 1
@.str.54 = private unnamed_addr constant [42 x i8] c"Total time without initialization : %16d\0A\00", align 1
@.str.55 = private unnamed_addr constant [42 x i8] c"Overall transpose time            : %16d\0A\00", align 1
@.str.56 = private unnamed_addr constant [44 x i8] c"Overall transpose fraction        : %16.5f\0A\00", align 1
@.str.57 = private unnamed_addr constant [40 x i8] c"              INVERSE FFT TEST RESULTS\0A\00", align 1
@.str.58 = private unnamed_addr constant [42 x i8] c"Checksum difference is %.3f (%.3f, %.3f)\0A\00", align 1
@.str.59 = private unnamed_addr constant [13 x i8] c"TEST PASSED\0A\00", align 1
@.str.60 = private unnamed_addr constant [13 x i8] c"TEST FAILED\0A\00", align 1
@.str.65 = private unnamed_addr constant [11 x i8] c"ERROR: %s\0A\00", align 1
@.str.61 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.62 = private unnamed_addr constant [43 x i8] c"Proc %d could not malloc memory for upriv\0A\00", align 1
@.str.63 = private unnamed_addr constant [13 x i8] c" %4.2f %4.2f\00", align 1
@.str.64 = private unnamed_addr constant [2 x i8] c",\00", align 1
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
  %c = alloca i32, align 4
  %m1 = alloca i32, align 4
  %factor = alloca i32, align 4
  %pages = alloca i32, align 4
  %start = alloca i32, align 4
  %t = alloca i64, align 8
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
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
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %sw.bb
  %5 = load i32* @P, align 4
  %call6 = call i32 @log_2(i32 %5)
  %cmp7 = icmp eq i32 %call6, -1
  br i1 %cmp7, label %if.then.9, label %if.end.10

if.then.9:                                        ; preds = %if.end
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
  br label %UnifiedUnreachableBlock

if.end.16:                                        ; preds = %sw.bb.11
  br label %sw.epilog

sw.bb.17:                                         ; preds = %while.body
  %10 = load i8** @optarg, align 8
  %call18 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %10)
  store i32 %call18, i32* @num_cache_lines, align 4
  %11 = load i32* @num_cache_lines, align 4
  %cmp19 = icmp slt i32 %11, 1
  br i1 %cmp19, label %if.then.21, label %if.end.22

if.then.21:                                       ; preds = %sw.bb.17
  br label %UnifiedUnreachableBlock

if.end.22:                                        ; preds = %sw.bb.17
  br label %sw.epilog

sw.bb.23:                                         ; preds = %while.body
  %12 = load i8** @optarg, align 8
  %call24 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %12)
  store i32 %call24, i32* @log2_line_size, align 4
  %13 = load i32* @log2_line_size, align 4
  %cmp25 = icmp slt i32 %13, 0
  br i1 %cmp25, label %if.then.27, label %if.end.28

if.then.27:                                       ; preds = %sw.bb.23
  br label %UnifiedUnreachableBlock

if.end.28:                                        ; preds = %sw.bb.23
  br label %sw.epilog

sw.bb.29:                                         ; preds = %while.body
  br label %sw.epilog

sw.bb.30:                                         ; preds = %while.body
  %14 = load i32* @test_result, align 4
  %tobool31 = icmp ne i32 %14, 0
  %lnot32 = xor i1 %tobool31, true
  %lnot.ext33 = zext i1 %lnot32 to i32
  store i32 %lnot.ext33, i32* @test_result, align 4
  br label %sw.epilog

sw.bb.34:                                         ; preds = %while.body
  %15 = load i32* @doprint, align 4
  %tobool35 = icmp ne i32 %15, 0
  %lnot36 = xor i1 %tobool35, true
  %lnot.ext37 = zext i1 %lnot36 to i32
  store i32 %lnot.ext37, i32* @doprint, align 4
  br label %sw.epilog

sw.bb.38:                                         ; preds = %while.body
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %sw.bb.34, %sw.bb.30, %sw.bb.29, %if.end.28, %if.end.22, %if.end.16, %if.end.10, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %16 = load i32* @M, align 4
  %shl = shl i32 1, %16
  store i32 %shl, i32* @N, align 4
  %17 = load i32* @M, align 4
  %div52 = sdiv i32 %17, 2
  %shl53 = shl i32 1, %div52
  store i32 %shl53, i32* @rootN, align 4
  %18 = load i32* @rootN, align 4
  %19 = load i32* @P, align 4
  %div54 = sdiv i32 %18, %19
  store i32 %div54, i32* @rowsperproc, align 4
  %20 = load i32* @rowsperproc, align 4
  %cmp55 = icmp eq i32 %20, 0
  br i1 %cmp55, label %if.then.57, label %if.end.58

if.then.57:                                       ; preds = %while.end
  br label %UnifiedUnreachableBlock

if.end.58:                                        ; preds = %while.end
  %21 = load i32* @log2_line_size, align 4
  %shl59 = shl i32 1, %21
  store i32 %shl59, i32* @line_size, align 4
  br label %if.end.71

if.then.63:                                       ; No predecessors!
  br label %if.end.71

if.end.71:                                        ; preds = %if.end.58, %if.then.63
  %22 = load i32* @line_size, align 4
  %conv72 = sext i32 %22 to i64
  %cmp73 = icmp ule i64 %conv72, 16
  br i1 %cmp73, label %if.then.75, label %if.else

if.then.75:                                       ; preds = %if.end.71
  store i32 1, i32* @pad_length, align 4
  br label %if.end.79

if.else:                                          ; preds = %if.end.71
  %23 = load i32* @line_size, align 4
  %conv76 = sext i32 %23 to i64
  %div77 = udiv i64 %conv76, 16
  %conv78 = trunc i64 %div77 to i32
  store i32 %conv78, i32* @pad_length, align 4
  br label %if.end.79

if.end.79:                                        ; preds = %if.else, %if.then.75
  %24 = load i32* @rowsperproc, align 4
  %25 = load i32* @rootN, align 4
  %mul80 = mul nsw i32 %24, %25
  %mul81 = mul nsw i32 %mul80, 2
  %conv82 = sext i32 %mul81 to i64
  %mul83 = mul i64 %conv82, 8
  %cmp84 = icmp uge i64 %mul83, 4096
  br i1 %cmp84, label %if.then.86, label %if.else.111

if.then.86:                                       ; preds = %if.end.79
  %26 = load i32* @pad_length, align 4
  %mul87 = mul nsw i32 2, %26
  %conv88 = sext i32 %mul87 to i64
  %mul89 = mul i64 %conv88, 8
  %27 = load i32* @rowsperproc, align 4
  %conv90 = sext i32 %27 to i64
  %mul91 = mul i64 %mul89, %conv90
  %div92 = udiv i64 %mul91, 4096
  %conv93 = trunc i64 %div92 to i32
  store i32 %conv93, i32* %pages, align 4
  %28 = load i32* %pages, align 4
  %mul94 = mul nsw i32 %28, 4096
  %conv95 = sext i32 %mul94 to i64
  %29 = load i32* @pad_length, align 4
  %mul96 = mul nsw i32 2, %29
  %conv97 = sext i32 %mul96 to i64
  %mul98 = mul i64 %conv97, 8
  %30 = load i32* @rowsperproc, align 4
  %conv99 = sext i32 %30 to i64
  %mul100 = mul i64 %mul98, %conv99
  %cmp101 = icmp ne i64 %conv95, %mul100
  br i1 %cmp101, label %if.then.103, label %if.end.104

if.then.103:                                      ; preds = %if.then.86
  %31 = load i32* %pages, align 4
  %inc = add nsw i32 %31, 1
  store i32 %inc, i32* %pages, align 4
  br label %if.end.104

if.end.104:                                       ; preds = %if.then.103, %if.then.86
  %32 = load i32* %pages, align 4
  %mul105 = mul nsw i32 %32, 4096
  %conv106 = sext i32 %mul105 to i64
  %33 = load i32* @rowsperproc, align 4
  %conv107 = sext i32 %33 to i64
  %mul108 = mul i64 16, %conv107
  %div109 = udiv i64 %conv106, %mul108
  %conv110 = trunc i64 %div109 to i32
  store i32 %conv110, i32* @pad_length, align 4
  br label %if.end.133

if.else.111:                                      ; preds = %if.end.79
  %34 = load i32* @rowsperproc, align 4
  %35 = load i32* @rootN, align 4
  %mul112 = mul nsw i32 %34, %35
  %mul113 = mul nsw i32 %mul112, 2
  %conv114 = sext i32 %mul113 to i64
  %mul115 = mul i64 %conv114, 8
  %sub = sub i64 4096, %mul115
  %36 = load i32* @rowsperproc, align 4
  %conv116 = sext i32 %36 to i64
  %mul117 = mul i64 16, %conv116
  %div118 = udiv i64 %sub, %mul117
  %conv119 = trunc i64 %div118 to i32
  store i32 %conv119, i32* @pad_length, align 4
  %37 = load i32* @pad_length, align 4
  %conv120 = sext i32 %37 to i64
  %38 = load i32* @rowsperproc, align 4
  %conv121 = sext i32 %38 to i64
  %mul122 = mul i64 16, %conv121
  %mul123 = mul i64 %conv120, %mul122
  %39 = load i32* @rowsperproc, align 4
  %40 = load i32* @rootN, align 4
  %mul124 = mul nsw i32 %39, %40
  %mul125 = mul nsw i32 %mul124, 2
  %conv126 = sext i32 %mul125 to i64
  %mul127 = mul i64 %conv126, 8
  %sub128 = sub i64 4096, %mul127
  %cmp129 = icmp ne i64 %mul123, %sub128
  br i1 %cmp129, label %if.then.131, label %if.end.132

if.then.131:                                      ; preds = %if.else.111
  br label %UnifiedUnreachableBlock

if.end.132:                                       ; preds = %if.else.111
  br label %if.end.133

if.end.133:                                       ; preds = %if.end.132, %if.end.104
  %call134 = call i8* @malloc(i64 96)
  %41 = bitcast i8* %call134 to %struct.GlobalMemory*
  store %struct.GlobalMemory* %41, %struct.GlobalMemory** @Global, align 8
  %42 = load i32* @N, align 4
  %43 = load i32* @rootN, align 4
  %44 = load i32* @pad_length, align 4
  %mul135 = mul nsw i32 %43, %44
  %add = add nsw i32 %42, %mul135
  %mul136 = mul nsw i32 2, %add
  %conv137 = sext i32 %mul136 to i64
  %mul138 = mul i64 %conv137, 8
  %add139 = add i64 %mul138, 4096
  %call140 = call i8* @malloc(i64 %add139)
  %45 = bitcast i8* %call140 to double*
  store double* %45, double** @x, align 8
  %46 = load i32* @N, align 4
  %47 = load i32* @rootN, align 4
  %48 = load i32* @pad_length, align 4
  %mul141 = mul nsw i32 %47, %48
  %add142 = add nsw i32 %46, %mul141
  %mul143 = mul nsw i32 2, %add142
  %conv144 = sext i32 %mul143 to i64
  %mul145 = mul i64 %conv144, 8
  %add146 = add i64 %mul145, 4096
  %call147 = call i8* @malloc(i64 %add146)
  %49 = bitcast i8* %call147 to double*
  store double* %49, double** @trans, align 8
  %50 = load i32* @rootN, align 4
  %mul148 = mul nsw i32 2, %50
  %conv149 = sext i32 %mul148 to i64
  %mul150 = mul i64 %conv149, 8
  %call151 = call i8* @malloc(i64 %mul150)
  %51 = bitcast i8* %call151 to double*
  store double* %51, double** @umain, align 8
  %52 = load i32* @N, align 4
  %53 = load i32* @rootN, align 4
  %54 = load i32* @pad_length, align 4
  %mul152 = mul nsw i32 %53, %54
  %add153 = add nsw i32 %52, %mul152
  %mul154 = mul nsw i32 2, %add153
  %conv155 = sext i32 %mul154 to i64
  %mul156 = mul i64 %conv155, 8
  %add157 = add i64 %mul156, 4096
  %call158 = call i8* @malloc(i64 %add157)
  %55 = bitcast i8* %call158 to double*
  store double* %55, double** @umain2, align 8
  %56 = load %struct.GlobalMemory** @Global, align 8
  %cmp165 = icmp eq %struct.GlobalMemory* %56, null
  br i1 %cmp165, label %if.then.167, label %if.else.168

if.then.167:                                      ; preds = %if.end.133
  br label %UnifiedUnreachableBlock

if.else.168:                                      ; preds = %if.end.133
  %57 = load double** @x, align 8
  %cmp169 = icmp eq double* %57, null
  br i1 %cmp169, label %if.then.171, label %if.else.172

if.then.171:                                      ; preds = %if.else.168
  br label %UnifiedUnreachableBlock

if.else.172:                                      ; preds = %if.else.168
  %58 = load double** @trans, align 8
  %cmp173 = icmp eq double* %58, null
  br i1 %cmp173, label %if.then.175, label %if.else.176

if.then.175:                                      ; preds = %if.else.172
  br label %UnifiedUnreachableBlock

if.else.176:                                      ; preds = %if.else.172
  %59 = load double** @umain, align 8
  %cmp177 = icmp eq double* %59, null
  br i1 %cmp177, label %if.then.179, label %if.else.180

if.then.179:                                      ; preds = %if.else.176
  br label %UnifiedUnreachableBlock

if.else.180:                                      ; preds = %if.else.176
  %60 = load double** @umain2, align 8
  %cmp181 = icmp eq double* %60, null
  br i1 %cmp181, label %if.then.183, label %if.end.184

if.then.183:                                      ; preds = %if.else.180
  br label %UnifiedUnreachableBlock

if.end.184:                                       ; preds = %if.else.180
  br label %if.end.185

if.end.185:                                       ; preds = %if.end.184
  br label %if.end.186

if.end.186:                                       ; preds = %if.end.185
  br label %if.end.187

if.end.187:                                       ; preds = %if.end.186
  br label %if.end.188

if.end.188:                                       ; preds = %if.end.187
  br label %if.end.211

if.then.206:                                      ; No predecessors!
  br label %if.end.211

if.else.209:                                      ; No predecessors!
  br label %if.end.211

if.end.211:                                       ; preds = %if.end.188, %if.else.209, %if.then.206
  %61 = load %struct.GlobalMemory** @Global, align 8
  %start216 = getelementptr inbounds %struct.GlobalMemory* %61, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start216, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %62 = load %struct.GlobalMemory** @Global, align 8
  %start217 = getelementptr inbounds %struct.GlobalMemory* %62, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start217, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  br label %if.end.223

if.then.221:                                      ; No predecessors!
  br label %if.end.223

if.end.223:                                       ; preds = %if.end.211, %if.then.221
  br label %if.end.228

if.then.225:                                      ; No predecessors!
  br label %if.end.228

if.end.228:                                       ; preds = %if.end.223, %if.then.225
  store i32 2, i32* @P
  store i32 1, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.228
  %63 = load i32* %i, align 4
  %64 = load i32* @P, align 4
  %cmp233 = icmp slt i32 %63, %64
  br i1 %cmp233, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call235 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %65 = load i32* %i, align 4
  %inc236 = add nsw i32 %65, 1
  store i32 %inc236, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @SlaveStart()
  %66 = load i32* @doprint, align 4
  %tobool237 = icmp ne i32 %66, 0
  br i1 %tobool237, label %if.then.238, label %if.end.246

if.then.238:                                      ; preds = %for.end
  br label %if.end.244

if.then.240:                                      ; No predecessors!
  br label %if.end.244

if.else.242:                                      ; No predecessors!
  br label %if.end.244

if.end.244:                                       ; preds = %if.then.238, %if.else.242, %if.then.240
  %call245 = call i32 @PrintArray(i32 undef, double* undef)
  br label %if.end.246

if.end.246:                                       ; preds = %if.end.244, %for.end
  br label %if.end.432

if.then.265:                                      ; No predecessors!
  br label %for.cond.297

for.cond.297:                                     ; preds = %for.inc.418, %if.then.265
  br label %for.end.420

for.body.300:                                     ; No predecessors!
  br label %if.end.309

if.then.305:                                      ; No predecessors!
  br label %if.end.309

if.end.309:                                       ; preds = %for.body.300, %if.then.305
  br label %if.end.319

if.then.315:                                      ; No predecessors!
  br label %if.end.319

if.end.319:                                       ; preds = %if.end.309, %if.then.315
  br label %if.end.329

if.then.325:                                      ; No predecessors!
  br label %if.end.329

if.end.329:                                       ; preds = %if.end.319, %if.then.325
  br label %if.end.339

if.then.335:                                      ; No predecessors!
  br label %if.end.339

if.end.339:                                       ; preds = %if.end.329, %if.then.335
  br label %if.end.361

if.then.351:                                      ; No predecessors!
  br label %if.end.361

if.end.361:                                       ; preds = %if.end.339, %if.then.351
  br label %if.end.383

if.then.373:                                      ; No predecessors!
  br label %if.end.383

if.end.383:                                       ; preds = %if.end.361, %if.then.373
  br label %for.inc.418

for.inc.418:                                      ; preds = %if.end.383
  br label %for.cond.297

for.end.420:                                      ; preds = %for.cond.297
  br label %if.end.432

if.end.432:                                       ; preds = %if.end.246, %for.end.420
  %67 = load i32* @test_result, align 4
  %tobool456 = icmp ne i32 %67, 0
  br i1 %tobool456, label %if.then.457, label %if.end.471

if.then.457:                                      ; preds = %if.end.432
  %call458 = call double @CheckSum(i32 undef, double* undef)
  br label %if.end.470

if.then.466:                                      ; No predecessors!
  br label %if.end.470

if.else.468:                                      ; No predecessors!
  br label %if.end.470

if.end.470:                                       ; preds = %if.then.457, %if.else.468, %if.then.466
  br label %if.end.471

if.end.471:                                       ; preds = %if.end.470, %if.end.432
  br label %UnifiedUnreachableBlock

return:                                           ; No predecessors!
  ret i32 undef

UnifiedUnreachableBlock:                          ; preds = %if.end.471, %if.then.183, %if.then.179, %if.then.175, %if.then.171, %if.then.167, %if.then.131, %if.then.57, %sw.bb.38, %if.then.27, %if.then.21, %if.then.15, %if.then.9, %if.then
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
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense49 = alloca i32, align 4
  %oldcount54 = alloca i32, align 4
  %newcount58 = alloca i32, align 4
  %updatedcount60 = alloca i32, align 4
  call void @printChar(i8 signext 49)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %0 = load %struct.GlobalMemory** @Global, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  %1 = load volatile i32* %gsense, align 4
  %call = call i32 @sleep(i32 1)
  store i32 %1, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.21, %entry
  %2 = load %struct.GlobalMemory** @Global, align 8
  %start6 = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start6, i32 0, i32 1
  %3 = load volatile i64* %count, align 8
  %call1 = call i32 @sleep(i32 1)
  %conv = trunc i64 %3 to i32
  store i32 %conv, i32* %oldcount, align 4
  %4 = load i32* %oldcount, align 4
  %5 = load i32* %lsense, align 4
  %add = add nsw i32 %4, %5
  store i32 %add, i32* %newcount, align 4
  %6 = load i32* %oldcount, align 4
  %7 = load i32* %newcount, align 4
  %call7 = call i32 @atomic_cmpxchg(i32 %6, i32 %7)
  %call6 = call i32 @sleep(i32 1)
  store i32 %call7, i32* %updatedcount, align 4
  %8 = load i32* %updatedcount, align 4
  %9 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %8, %9
  br i1 %cmp, label %if.then, label %if.end.21

if.then:                                          ; preds = %while.body
  %10 = load i32* %newcount, align 4
  %11 = load i32* @P, align 4
  %call2 = call i32 @sleep(i32 1)
  %cmp9 = icmp eq i32 %10, %11
  br i1 %cmp9, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %12 = load i32* %lsense, align 4
  %cmp11 = icmp eq i32 %12, 1
  br i1 %cmp11, label %if.then.18, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %13 = load i32* %newcount, align 4
  %cmp13 = icmp eq i32 %13, 0
  br i1 %cmp13, label %land.lhs.true.15, label %if.end

land.lhs.true.15:                                 ; preds = %lor.lhs.false
  %14 = load i32* %lsense, align 4
  %cmp16 = icmp eq i32 %14, -1
  br i1 %cmp16, label %if.then.18, label %if.end

if.then.18:                                       ; preds = %land.lhs.true.15, %land.lhs.true
  %15 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %15
  %16 = load %struct.GlobalMemory** @Global, align 8
  %start19 = getelementptr inbounds %struct.GlobalMemory* %16, i32 0, i32 2
  %gsense20 = getelementptr inbounds %struct.barrier_t* %start19, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub, i32* %gsense20, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call3 = call i32 @sleep(i32 3)
  br label %if.end

if.end:                                           ; preds = %if.then.18, %land.lhs.true.15, %lor.lhs.false
  br label %while.end

if.end.21:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.26, %while.end
  %17 = load %struct.GlobalMemory** @Global, align 8
  %start22 = getelementptr inbounds %struct.GlobalMemory* %17, i32 0, i32 2
  %gsense23 = getelementptr inbounds %struct.barrier_t* %start22, i32 0, i32 0
  %18 = load volatile i32* %gsense23, align 4
  %19 = load i32* %lsense, align 4
  %cmp24 = icmp eq i32 %18, %19
  br i1 %cmp24, label %while.body.26, label %while.end.27

while.body.26:                                    ; preds = %while.cond
  %call4 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.27:                                     ; preds = %while.cond
  call void @printY()
  %call5 = call i32 @sleep(i32 1)
  %20 = load i32* @rootN, align 4
  %sub28 = sub nsw i32 %20, 1
  %mul = mul nsw i32 2, %sub28
  %conv29 = sext i32 %mul to i64
  %mul30 = mul i64 %conv29, 8
  %call31 = call i8* @malloc(i64 %mul30)
  %21 = bitcast i8* %call31 to double*
  store double* %21, double** %upriv, align 8
  %22 = load double** %upriv, align 8
  %cmp32 = icmp eq double* %22, null
  br i1 %cmp32, label %if.then.34, label %if.end.36

if.then.34:                                       ; preds = %while.end.27
  unreachable

if.end.36:                                        ; preds = %while.end.27
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.36
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @printChar(i8 signext 50)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %23 = load %struct.GlobalMemory** @Global, align 8
  %start50 = getelementptr inbounds %struct.GlobalMemory* %23, i32 0, i32 2
  %gsense51 = getelementptr inbounds %struct.barrier_t* %start50, i32 0, i32 0
  %24 = load volatile i32* %gsense51, align 4
  %call8 = call i32 @sleep(i32 1)
  store i32 %24, i32* %lsense49, align 4
  br label %while.body.53

while.body.53:                                    ; preds = %if.end.81, %for.end
  %25 = load %struct.GlobalMemory** @Global, align 8
  %start55 = getelementptr inbounds %struct.GlobalMemory* %25, i32 0, i32 2
  %count56 = getelementptr inbounds %struct.barrier_t* %start55, i32 0, i32 1
  %26 = load volatile i64* %count56, align 8
  %call9 = call i32 @sleep(i32 1)
  %conv57 = trunc i64 %26 to i32
  store i32 %conv57, i32* %oldcount54, align 4
  %27 = load i32* %oldcount54, align 4
  %28 = load i32* %lsense49, align 4
  %add59 = add nsw i32 %27, %28
  store i32 %add59, i32* %newcount58, align 4
  %29 = load i32* %oldcount54, align 4
  %30 = load i32* %newcount58, align 4
  %call61 = call i32 @atomic_cmpxchg(i32 %29, i32 %30)
  %call14 = call i32 @sleep(i32 1)
  store i32 %call61, i32* %updatedcount60, align 4
  %31 = load i32* %updatedcount60, align 4
  %32 = load i32* %oldcount54, align 4
  %cmp62 = icmp eq i32 %31, %32
  br i1 %cmp62, label %if.then.64, label %if.end.81

if.then.64:                                       ; preds = %while.body.53
  %33 = load i32* %newcount58, align 4
  %34 = load i32* @P, align 4
  %call10 = call i32 @sleep(i32 1)
  %cmp65 = icmp eq i32 %33, %34
  br i1 %cmp65, label %land.lhs.true.67, label %lor.lhs.false.70

land.lhs.true.67:                                 ; preds = %if.then.64
  %35 = load i32* %lsense49, align 4
  %cmp68 = icmp eq i32 %35, 1
  br i1 %cmp68, label %if.then.76, label %lor.lhs.false.70

lor.lhs.false.70:                                 ; preds = %land.lhs.true.67, %if.then.64
  %36 = load i32* %newcount58, align 4
  %cmp71 = icmp eq i32 %36, 0
  br i1 %cmp71, label %land.lhs.true.73, label %if.end.80

land.lhs.true.73:                                 ; preds = %lor.lhs.false.70
  %37 = load i32* %lsense49, align 4
  %cmp74 = icmp eq i32 %37, -1
  br i1 %cmp74, label %if.then.76, label %if.end.80

if.then.76:                                       ; preds = %land.lhs.true.73, %land.lhs.true.67
  %38 = load i32* %lsense49, align 4
  %sub77 = sub nsw i32 0, %38
  %39 = load %struct.GlobalMemory** @Global, align 8
  %start78 = getelementptr inbounds %struct.GlobalMemory* %39, i32 0, i32 2
  %gsense79 = getelementptr inbounds %struct.barrier_t* %start78, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub77, i32* %gsense79, align 4
  call void @snapshot(i32 %sub77, i32 1)
  %call11 = call i32 @sleep(i32 3)
  br label %if.end.80

if.end.80:                                        ; preds = %if.then.76, %land.lhs.true.73, %lor.lhs.false.70
  br label %while.end.82

if.end.81:                                        ; preds = %while.body.53
  br label %while.body.53

while.end.82:                                     ; preds = %if.end.80
  br label %while.cond.83

while.cond.83:                                    ; preds = %while.body.88, %while.end.82
  %40 = load %struct.GlobalMemory** @Global, align 8
  %start84 = getelementptr inbounds %struct.GlobalMemory* %40, i32 0, i32 2
  %gsense85 = getelementptr inbounds %struct.barrier_t* %start84, i32 0, i32 0
  %41 = load volatile i32* %gsense85, align 4
  %42 = load i32* %lsense49, align 4
  %cmp86 = icmp eq i32 %41, %42
  br i1 %cmp86, label %while.body.88, label %while.end.89

while.body.88:                                    ; preds = %while.cond.83
  %call12 = call i32 @sleep(i32 2)
  br label %while.cond.83

while.end.89:                                     ; preds = %while.cond.83
  call void @printY()
  %call13 = call i32 @sleep(i32 1)
  br label %if.end.96

lor.lhs.false.92:                                 ; No predecessors!
  br label %if.end.96

if.then.93:                                       ; No predecessors!
  br label %if.end.96

if.end.96:                                        ; preds = %lor.lhs.false.92, %while.end.89, %if.then.93
  %43 = load i32* @test_result, align 4
  %tobool97 = icmp ne i32 %43, 0
  br i1 %tobool97, label %if.then.98, label %if.end.99

if.then.98:                                       ; preds = %if.end.96
  %44 = load i32* @P, align 4
  %45 = load %struct.GlobalMemory** @Global, align 8
  call void @FFT1D(i32 -1, i32 undef, i32 undef, double* undef, double* undef, double* undef, double* undef, i32 undef, i32* %l_transtime, i32 undef, i32 undef, i32 undef, i32 %44, i32 undef, i32 undef, i32 undef, %struct.GlobalMemory* %45)
  br label %if.end.99

if.end.99:                                        ; preds = %if.then.98, %if.end.96
  br label %if.end.112

lor.lhs.false.102:                                ; No predecessors!
  br label %if.end.112

if.then.104:                                      ; No predecessors!
  br label %if.end.112

if.end.112:                                       ; preds = %lor.lhs.false.102, %if.end.99, %if.then.104
  br label %if.end.116

if.then.115:                                      ; No predecessors!
  br label %if.end.116

if.end.116:                                       ; preds = %if.end.112, %if.then.115
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.45, %for.end
  br label %for.end.47

for.body.3:                                       ; No predecessors!
  br label %for.cond.6

for.cond.6:                                       ; preds = %for.inc.42, %for.body.3
  br label %for.end.44

for.body.8:                                       ; No predecessors!
  br label %for.inc.42

for.inc.42:                                       ; preds = %for.body.8
  br label %for.cond.6

for.end.44:                                       ; preds = %for.cond.6
  br label %for.inc.45

for.inc.45:                                       ; preds = %for.end.44
  br label %for.cond.1

for.end.47:                                       ; preds = %for.cond.1
  ret double undef
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
  store i32 %P, i32* %P.addr, align 4
  store %struct.GlobalMemory* %Global, %struct.GlobalMemory** %Global.addr, align 8
  call void @printChar(i8 signext 51)
  call void @printChar(i8 signext 90)
  call void @InitializeSwitchesAndCounter()
  call void @IncrementCounter()
  %0 = load %struct.GlobalMemory** %Global.addr, align 8
  %start = getelementptr inbounds %struct.GlobalMemory* %0, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  %1 = load volatile i32* %gsense, align 4
  %call1 = call i32 @sleep(i32 1)
  store i32 %1, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.15, %entry
  %2 = load %struct.GlobalMemory** %Global.addr, align 8
  %start1 = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start1, i32 0, i32 1
  %3 = load volatile i64* %count, align 8
  %call2 = call i32 @sleep(i32 1)
  %conv = trunc i64 %3 to i32
  store i32 %conv, i32* %oldcount, align 4
  %4 = load i32* %oldcount, align 4
  %5 = load i32* %lsense, align 4
  %add = add nsw i32 %4, %5
  store i32 %add, i32* %newcount, align 4
  %6 = load i32* %oldcount, align 4
  %7 = load i32* %newcount, align 4
  %call = call i32 @atomic_cmpxchg(i32 %6, i32 %7)
  %call6 = call i32 @sleep(i32 1)
  store i32 %call, i32* %updatedcount, align 4
  %8 = load i32* %updatedcount, align 4
  %9 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %8, %9
  br i1 %cmp, label %if.then, label %if.end.15

if.then:                                          ; preds = %while.body
  %10 = load i32* %newcount, align 4
  %11 = load i32* %P.addr, align 4
  %cmp3 = icmp eq i32 %10, %11
  br i1 %cmp3, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %12 = load i32* %lsense, align 4
  %cmp5 = icmp eq i32 %12, 1
  br i1 %cmp5, label %if.then.12, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %13 = load i32* %newcount, align 4
  %cmp7 = icmp eq i32 %13, 0
  br i1 %cmp7, label %land.lhs.true.9, label %if.end

land.lhs.true.9:                                  ; preds = %lor.lhs.false
  %14 = load i32* %lsense, align 4
  %cmp10 = icmp eq i32 %14, -1
  br i1 %cmp10, label %if.then.12, label %if.end

if.then.12:                                       ; preds = %land.lhs.true.9, %land.lhs.true
  %15 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %15
  %16 = load %struct.GlobalMemory** %Global.addr, align 8
  %start13 = getelementptr inbounds %struct.GlobalMemory* %16, i32 0, i32 2
  %gsense14 = getelementptr inbounds %struct.barrier_t* %start13, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub, i32* %gsense14, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call3 = call i32 @sleep(i32 3)
  br label %if.end

if.end:                                           ; preds = %if.then.12, %land.lhs.true.9, %lor.lhs.false
  br label %while.end

if.end.15:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.20, %while.end
  %17 = load %struct.GlobalMemory** %Global.addr, align 8
  %start16 = getelementptr inbounds %struct.GlobalMemory* %17, i32 0, i32 2
  %gsense17 = getelementptr inbounds %struct.barrier_t* %start16, i32 0, i32 0
  %18 = load volatile i32* %gsense17, align 4
  %19 = load i32* %lsense, align 4
  %cmp18 = icmp eq i32 %18, %19
  br i1 %cmp18, label %while.body.20, label %while.end.21

while.body.20:                                    ; preds = %while.cond
  %call4 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.21:                                     ; preds = %while.cond
  call void @printY()
  %call5 = call i32 @sleep(i32 1)
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.13, %entry
  br label %for.end.15

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.13

for.inc.13:                                       ; preds = %for.end
  br label %for.cond

for.end.15:                                       ; preds = %for.cond
  ret double undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.13, %entry
  br label %for.end.15

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.13

for.inc.13:                                       ; preds = %for.end
  br label %for.cond

for.end.15:                                       ; preds = %for.cond
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.23, %entry
  br label %for.end.25

for.body:                                         ; No predecessors!
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc, %for.body
  br label %for.end.25

for.body.4:                                       ; No predecessors!
  br label %for.end.25

if.then:                                          ; No predecessors!
  br label %for.end.25

if.end:                                           ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond.2

for.end:                                          ; No predecessors!
  br label %for.inc.23

for.inc.23:                                       ; preds = %for.end
  br label %for.cond

for.end.25:                                       ; preds = %for.body.4, %for.cond.2, %for.cond, %if.then
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.22, %entry
  br label %for.end.24

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.22

for.inc.22:                                       ; preds = %for.end
  br label %for.cond

for.end.24:                                       ; preds = %for.cond
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define internal i32 @BitReverse(i32 %M, i32 %k) {
entry:
  %M.addr = alloca i32, align 4
  %k.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define internal i32 @Scale(i32 %n1, i32 %N, double* %x) {
entry:
  %retval = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %x.addr = alloca double*, align 8
  %i = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
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
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  br label %for.cond

for.cond:                                         ; preds = %for.inc.54, %if.end
  br label %for.end.56

for.body:                                         ; No predecessors!
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc.51, %for.body
  br label %for.end.53

for.body.10:                                      ; No predecessors!
  br label %for.cond.11

for.cond.11:                                      ; preds = %for.inc.47, %for.body.10
  br label %for.end.49

for.body.13:                                      ; No predecessors!
  br label %for.cond.14

for.cond.14:                                      ; preds = %for.inc.43, %for.body.13
  br label %for.end.45

for.body.16:                                      ; No predecessors!
  br label %for.cond.18

for.cond.18:                                      ; preds = %for.inc, %for.body.16
  br label %for.end

for.body.20:                                      ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.20
  br label %for.cond.18

for.end:                                          ; preds = %for.cond.18
  br label %for.inc.43

for.inc.43:                                       ; preds = %for.end
  br label %for.cond.14

for.end.45:                                       ; preds = %for.cond.14
  br label %for.inc.47

for.inc.47:                                       ; preds = %for.end.45
  br label %for.cond.11

for.end.49:                                       ; preds = %for.cond.11
  br label %for.inc.51

for.inc.51:                                       ; preds = %for.end.49
  br label %for.cond.8

for.end.53:                                       ; preds = %for.cond.8
  br label %for.inc.54

for.inc.54:                                       ; preds = %for.end.53
  br label %for.cond

for.end.56:                                       ; preds = %for.cond
  br label %for.cond.57

for.cond.57:                                      ; preds = %for.inc.111, %for.end.56
  br label %for.end.113

for.body.59:                                      ; No predecessors!
  br label %for.cond.61

for.cond.61:                                      ; preds = %for.inc.108, %for.body.59
  br label %for.end.110

for.body.63:                                      ; No predecessors!
  br label %for.cond.64

for.cond.64:                                      ; preds = %for.inc.104, %for.body.63
  br label %for.end.106

for.body.66:                                      ; No predecessors!
  br label %for.cond.67

for.cond.67:                                      ; preds = %for.inc.100, %for.body.66
  br label %for.end.102

for.body.69:                                      ; No predecessors!
  br label %for.cond.71

for.cond.71:                                      ; preds = %for.inc.97, %for.body.69
  br label %for.end.99

for.body.73:                                      ; No predecessors!
  br label %for.inc.97

for.inc.97:                                       ; preds = %for.body.73
  br label %for.cond.71

for.end.99:                                       ; preds = %for.cond.71
  br label %for.inc.100

for.inc.100:                                      ; preds = %for.end.99
  br label %for.cond.67

for.end.102:                                      ; preds = %for.cond.67
  br label %for.inc.104

for.inc.104:                                      ; preds = %for.end.102
  br label %for.cond.64

for.end.106:                                      ; preds = %for.cond.64
  br label %for.inc.108

for.inc.108:                                      ; preds = %for.end.106
  br label %for.cond.61

for.end.110:                                      ; preds = %for.cond.61
  br label %for.inc.111

for.inc.111:                                      ; preds = %for.end.110
  br label %for.cond.57

for.end.113:                                      ; preds = %for.cond.57
  br label %for.cond.115

for.cond.115:                                     ; preds = %for.inc.162, %for.end.113
  br label %for.end.164

for.body.117:                                     ; No predecessors!
  br label %for.cond.118

for.cond.118:                                     ; preds = %for.inc.158, %for.body.117
  br label %for.end.160

for.body.120:                                     ; No predecessors!
  br label %for.cond.121

for.cond.121:                                     ; preds = %for.inc.154, %for.body.120
  br label %for.end.156

for.body.123:                                     ; No predecessors!
  br label %for.cond.125

for.cond.125:                                     ; preds = %for.inc.151, %for.body.123
  br label %for.end.153

for.body.127:                                     ; No predecessors!
  br label %for.inc.151

for.inc.151:                                      ; preds = %for.body.127
  br label %for.cond.125

for.end.153:                                      ; preds = %for.cond.125
  br label %for.inc.154

for.inc.154:                                      ; preds = %for.end.153
  br label %for.cond.121

for.end.156:                                      ; preds = %for.cond.121
  br label %for.inc.158

for.inc.158:                                      ; preds = %for.end.156
  br label %for.cond.118

for.end.160:                                      ; preds = %for.cond.118
  br label %for.inc.162

for.inc.162:                                      ; preds = %for.end.160
  br label %for.cond.115

for.end.164:                                      ; preds = %for.cond.115
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define internal i32 @CopyColumn(i32 %n1, double* %src, double* %dest) {
entry:
  %retval = alloca i32, align 4
  %n1.addr = alloca i32, align 4
  %src.addr = alloca double*, align 8
  %dest.addr = alloca double*, align 8
  %i = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.65, %entry
  br label %for.end.67

for.body:                                         ; No predecessors!
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc.62, %for.body
  br label %for.end.64

for.body.4:                                       ; No predecessors!
  br label %for.cond.13

for.cond.13:                                      ; preds = %for.inc, %for.body.4
  br label %for.end

for.body.15:                                      ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.15
  br label %for.cond.13

for.end:                                          ; preds = %for.cond.13
  br label %for.inc.62

for.inc.62:                                       ; preds = %for.end
  br label %for.cond.2

for.end.64:                                       ; preds = %for.cond.2
  br label %for.inc.65

for.inc.65:                                       ; preds = %for.end.64
  br label %for.cond

for.end.67:                                       ; preds = %for.cond
  ret i32 undef
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
  br label %for.cond

for.cond:                                         ; preds = %for.inc.22, %entry
  br label %for.end.24

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body.3, %if.then
  br label %if.end.21

if.then.19:                                       ; No predecessors!
  br label %if.end.21

if.end.21:                                        ; preds = %if.end, %if.then.19
  br label %for.inc

for.inc:                                          ; preds = %if.end.21
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.22

for.inc.22:                                       ; preds = %for.end
  br label %for.cond

for.end.24:                                       ; preds = %for.cond
  ret i32 undef
}

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

define internal void @InitializeSwitchesAndCounter() {
entry:
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


