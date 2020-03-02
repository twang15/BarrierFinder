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
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%struct.LocalCopies = type { double, double, double, double }

@n = internal global i32 512, align 4
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
@bFirstThread = internal global i8 1, align 1
@mystring = internal global [1024 x i8] zeroinitializer, align 16
@switches = internal global [3 x i8] zeroinitializer, align 1
@syncID = internal global [3 x i32] zeroinitializer, align 4

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
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
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 0, i32* %MyNum, align 4
  %4 = call i64 @time(i64* null)
  %5 = trunc i64 %4 to i32
  store i32 %5, i32* %start, align 4
  br label %6

; <label>:6                                       ; preds = %46, %0
  %7 = load i32* %2, align 4
  %8 = load i8*** %3, align 8
  %9 = call i32 (i32, i8**, i8*, ...) *bitcast (i32 (...)* @getopt to i32 (i32, i8**, i8*, ...)*)(i32 %7, i8** %8, i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0))
  store i32 %9, i32* %ch, align 4
  %10 = icmp ne i32 %9, -1
  br i1 %10, label %11, label %47

; <label>:11                                      ; preds = %6
  %12 = load i32* %ch, align 4
  switch i32 %12, label %46 [
    i32 110, label %13
    i32 112, label %16
    i32 98, label %19
    i32 115, label %22
    i32 116, label %23
    i32 111, label %28
    i32 104, label %33
  ]

; <label>:13                                      ; preds = %11
  %14 = load i8** @optarg, align 8
  %15 = call i32 @atoi(i8* %14)
  store i32 %15, i32* @n, align 4
  br label %46

; <label>:16                                      ; preds = %11
  %17 = load i8** @optarg, align 8
  %18 = call i32 @atoi(i8* %17)
  store i32 %18, i32* @P, align 4
  br label %46

; <label>:19                                      ; preds = %11
  %20 = load i8** @optarg, align 8
  %21 = call i32 @atoi(i8* %20)
  store i32 %21, i32* @block_size, align 4
  br label %46

; <label>:22                                      ; preds = %11
  store i32 1, i32* @dostats, align 4
  br label %46

; <label>:23                                      ; preds = %11
  %24 = load i32* @test_result, align 4
  %25 = icmp ne i32 %24, 0
  %26 = xor i1 %25, true
  %27 = zext i1 %26 to i32
  store i32 %27, i32* @test_result, align 4
  br label %46

; <label>:28                                      ; preds = %11
  %29 = load i32* @doprint, align 4
  %30 = icmp ne i32 %29, 0
  %31 = xor i1 %30, true
  %32 = zext i1 %31 to i32
  store i32 %32, i32* @doprint, align 4
  br label %46

; <label>:33                                      ; preds = %11
  %34 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str.1, i32 0, i32 0))
  %35 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([10 x i8]* @.str.2, i32 0, i32 0))
  %36 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([31 x i8]* @.str.3, i32 0, i32 0))
  %37 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([35 x i8]* @.str.4, i32 0, i32 0))
  %38 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([70 x i8]* @.str.5, i32 0, i32 0))
  %39 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([68 x i8]* @.str.6, i32 0, i32 0))
  %40 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([71 x i8]* @.str.7, i32 0, i32 0))
  %41 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.8, i32 0, i32 0))
  %42 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str.9, i32 0, i32 0))
  %43 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([34 x i8]* @.str.10, i32 0, i32 0))
  %44 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.11, i32 0, i32 0))
  %45 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([31 x i8]* @.str.12, i32 0, i32 0), i32 512, i32 2, i32 16)
  call void @exit(i32 0)
  br label %UnifiedUnreachableBlock

; <label>:46                                      ; preds = %28, %23, %22, %19, %16, %13, %11
  br label %6

; <label>:47                                      ; preds = %6
  %48 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  %49 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([32 x i8]* @.str.14, i32 0, i32 0))
  %50 = load i32* @n, align 4
  %51 = load i32* @n, align 4
  %52 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([22 x i8]* @.str.15, i32 0, i32 0), i32 %50, i32 %51)
  %53 = load i32* @P, align 4
  %54 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([20 x i8]* @.str.16, i32 0, i32 0), i32 %53)
  %55 = load i32* @block_size, align 4
  %56 = load i32* @block_size, align 4
  %57 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str.17, i32 0, i32 0), i32 %55, i32 %56)
  %58 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  %59 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  %60 = load i32* @P, align 4
  %61 = sitofp i32 %60 to double
  %62 = call double @sqrt(double %61)
  %63 = fptosi double %62 to i32
  store i32 %63, i32* @num_rows, align 4
  br label %64

; <label>:64                                      ; preds = %74, %47
  %65 = load i32* @P, align 4
  %66 = load i32* @num_rows, align 4
  %67 = sdiv i32 %65, %66
  store i32 %67, i32* @num_cols, align 4
  %68 = load i32* @num_rows, align 4
  %69 = load i32* @num_cols, align 4
  %70 = mul nsw i32 %68, %69
  %71 = load i32* @P, align 4
  %72 = icmp eq i32 %70, %71
  br i1 %72, label %73, label %74

; <label>:73                                      ; preds = %64
  br label %77

; <label>:74                                      ; preds = %64
  %75 = load i32* @num_rows, align 4
  %76 = add nsw i32 %75, -1
  store i32 %76, i32* @num_rows, align 4
  br label %64

; <label>:77                                      ; preds = %73
  %78 = load i32* @n, align 4
  %79 = load i32* @block_size, align 4
  %80 = sdiv i32 %78, %79
  store i32 %80, i32* @nblocks, align 4
  %81 = load i32* @block_size, align 4
  %82 = load i32* @nblocks, align 4
  %83 = mul nsw i32 %81, %82
  %84 = load i32* @n, align 4
  %85 = icmp ne i32 %83, %84
  br i1 %85, label %86, label %89

; <label>:86                                      ; preds = %77
  %87 = load i32* @nblocks, align 4
  %88 = add nsw i32 %87, 1
  store i32 %88, i32* @nblocks, align 4
  br label %89

; <label>:89                                      ; preds = %86, %77
  %90 = load i32* @n, align 4
  %91 = load i32* @block_size, align 4
  %92 = srem i32 %90, %91
  store i32 %92, i32* %edge, align 4
  %93 = load i32* %edge, align 4
  %94 = icmp eq i32 %93, 0
  br i1 %94, label %95, label %97

; <label>:95                                      ; preds = %89
  %96 = load i32* @block_size, align 4
  store i32 %96, i32* %edge, align 4
  br label %97

; <label>:97                                      ; preds = %95, %89
  %98 = load i32* @P, align 4
  %99 = sext i32 %98 to i64
  %100 = mul i64 %99, 4
  %101 = call noalias i8* @malloc(i64 %100)
  %102 = bitcast i8* %101 to i32*
  store i32* %102, i32** @proc_bytes, align 8
  %103 = load i32* @P, align 4
  %104 = sext i32 %103 to i64
  %105 = mul i64 %104, 8
  %106 = call noalias i8* @malloc(i64 %105)
  %107 = bitcast i8* %106 to double**
  store double** %107, double*** @last_malloc, align 8
  store i32 0, i32* %i, align 4
  br label %108

; <label>:108                                     ; preds = %121, %97
  %109 = load i32* %i, align 4
  %110 = load i32* @P, align 4
  %111 = icmp slt i32 %109, %110
  br i1 %111, label %112, label %124

; <label>:112                                     ; preds = %108
  %113 = load i32* %i, align 4
  %114 = sext i32 %113 to i64
  %115 = load i32** @proc_bytes, align 8
  %116 = getelementptr inbounds i32* %115, i64 %114
  store i32 0, i32* %116, align 4
  %117 = load i32* %i, align 4
  %118 = sext i32 %117 to i64
  %119 = load double*** @last_malloc, align 8
  %120 = getelementptr inbounds double** %119, i64 %118
  store double* null, double** %120, align 8
  br label %121

; <label>:121                                     ; preds = %112
  %122 = load i32* %i, align 4
  %123 = add nsw i32 %122, 1
  store i32 %123, i32* %i, align 4
  br label %108

; <label>:124                                     ; preds = %108
  store i32 0, i32* %i, align 4
  br label %125

; <label>:125                                     ; preds = %186, %124
  %126 = load i32* %i, align 4
  %127 = load i32* @nblocks, align 4
  %128 = icmp slt i32 %126, %127
  br i1 %128, label %129, label %189

; <label>:129                                     ; preds = %125
  store i32 0, i32* %j, align 4
  br label %130

; <label>:130                                     ; preds = %182, %129
  %131 = load i32* %j, align 4
  %132 = load i32* @nblocks, align 4
  %133 = icmp slt i32 %131, %132
  br i1 %133, label %134, label %185

; <label>:134                                     ; preds = %130
  %135 = load i32* %i, align 4
  %136 = load i32* %j, align 4
  %137 = call i32 @BlockOwner(i32 %135, i32 %136)
  store i32 %137, i32* %proc_num, align 4
  %138 = load i32* %i, align 4
  %139 = load i32* @nblocks, align 4
  %140 = sub nsw i32 %139, 1
  %141 = icmp eq i32 %138, %140
  br i1 %141, label %142, label %151

; <label>:142                                     ; preds = %134
  %143 = load i32* %j, align 4
  %144 = load i32* @nblocks, align 4
  %145 = sub nsw i32 %144, 1
  %146 = icmp eq i32 %143, %145
  br i1 %146, label %147, label %151

; <label>:147                                     ; preds = %142
  %148 = load i32* %edge, align 4
  %149 = load i32* %edge, align 4
  %150 = mul nsw i32 %148, %149
  store i32 %150, i32* %size, align 4
  br label %170

; <label>:151                                     ; preds = %142, %134
  %152 = load i32* %i, align 4
  %153 = load i32* @nblocks, align 4
  %154 = sub nsw i32 %153, 1
  %155 = icmp eq i32 %152, %154
  br i1 %155, label %161, label %156

; <label>:156                                     ; preds = %151
  %157 = load i32* %j, align 4
  %158 = load i32* @nblocks, align 4
  %159 = sub nsw i32 %158, 1
  %160 = icmp eq i32 %157, %159
  br i1 %160, label %161, label %165

; <label>:161                                     ; preds = %156, %151
  %162 = load i32* %edge, align 4
  %163 = load i32* @block_size, align 4
  %164 = mul nsw i32 %162, %163
  store i32 %164, i32* %size, align 4
  br label %169

; <label>:165                                     ; preds = %156
  %166 = load i32* @block_size, align 4
  %167 = load i32* @block_size, align 4
  %168 = mul nsw i32 %166, %167
  store i32 %168, i32* %size, align 4
  br label %169

; <label>:169                                     ; preds = %165, %161
  br label %170

; <label>:170                                     ; preds = %169, %147
  %171 = load i32* %size, align 4
  %172 = sext i32 %171 to i64
  %173 = mul i64 %172, 8
  %174 = load i32* %proc_num, align 4
  %175 = sext i32 %174 to i64
  %176 = load i32** @proc_bytes, align 8
  %177 = getelementptr inbounds i32* %176, i64 %175
  %178 = load i32* %177, align 4
  %179 = sext i32 %178 to i64
  %180 = add i64 %179, %173
  %181 = trunc i64 %180 to i32
  store i32 %181, i32* %177, align 4
  br label %182

; <label>:182                                     ; preds = %170
  %183 = load i32* %j, align 4
  %184 = add nsw i32 %183, 1
  store i32 %184, i32* %j, align 4
  br label %130

; <label>:185                                     ; preds = %130
  br label %186

; <label>:186                                     ; preds = %185
  %187 = load i32* %i, align 4
  %188 = add nsw i32 %187, 1
  store i32 %188, i32* %i, align 4
  br label %125

; <label>:189                                     ; preds = %125
  store i32 0, i32* %i, align 4
  br label %190

; <label>:190                                     ; preds = %240, %189
  %191 = load i32* %i, align 4
  %192 = load i32* @P, align 4
  %193 = icmp slt i32 %191, %192
  br i1 %193, label %194, label %243

; <label>:194                                     ; preds = %190
  %195 = load i32* %i, align 4
  %196 = sext i32 %195 to i64
  %197 = load i32** @proc_bytes, align 8
  %198 = getelementptr inbounds i32* %197, i64 %196
  %199 = load i32* %198, align 4
  %200 = add nsw i32 %199, 4096
  %201 = sext i32 %200 to i64
  %202 = call noalias i8* @malloc(i64 %201)
  %203 = bitcast i8* %202 to double*
  %204 = load i32* %i, align 4
  %205 = sext i32 %204 to i64
  %206 = load double*** @last_malloc, align 8
  %207 = getelementptr inbounds double** %206, i64 %205
  store double* %203, double** %207, align 8
  %208 = load i32* %i, align 4
  %209 = sext i32 %208 to i64
  %210 = load double*** @last_malloc, align 8
  %211 = getelementptr inbounds double** %210, i64 %209
  %212 = load double** %211, align 8
  %213 = icmp eq double* %212, null
  br i1 %213, label %214, label %218

; <label>:214                                     ; preds = %194
  %215 = load %struct._IO_FILE** @stderr, align 8
  %216 = load i32* %i, align 4
  %217 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %215, i8* getelementptr inbounds ([44 x i8]* @.str.18, i32 0, i32 0), i32 %216)
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:218                                     ; preds = %194
  %219 = load i32* %i, align 4
  %220 = sext i32 %219 to i64
  %221 = load double*** @last_malloc, align 8
  %222 = getelementptr inbounds double** %221, i64 %220
  %223 = load double** %222, align 8
  %224 = ptrtoint double* %223 to i32
  %225 = add i32 %224, 4096
  %226 = load i32* %i, align 4
  %227 = sext i32 %226 to i64
  %228 = load double*** @last_malloc, align 8
  %229 = getelementptr inbounds double** %228, i64 %227
  %230 = load double** %229, align 8
  %231 = ptrtoint double* %230 to i32
  %232 = urem i32 %231, 4096
  %233 = sub i32 %225, %232
  %234 = zext i32 %233 to i64
  %235 = inttoptr i64 %234 to double*
  %236 = load i32* %i, align 4
  %237 = sext i32 %236 to i64
  %238 = load double*** @last_malloc, align 8
  %239 = getelementptr inbounds double** %238, i64 %237
  store double* %235, double** %239, align 8
  br label %240

; <label>:240                                     ; preds = %218
  %241 = load i32* %i, align 4
  %242 = add nsw i32 %241, 1
  store i32 %242, i32* %i, align 4
  br label %190

; <label>:243                                     ; preds = %190
  %244 = load i32* @nblocks, align 4
  %245 = load i32* @nblocks, align 4
  %246 = mul nsw i32 %244, %245
  %247 = sext i32 %246 to i64
  %248 = mul i64 %247, 8
  %249 = call noalias i8* @malloc(i64 %248)
  %250 = bitcast i8* %249 to double**
  store double** %250, double*** @a, align 8
  %251 = load double*** @a, align 8
  %252 = icmp eq double** %251, null
  br i1 %252, label %253, label %254

; <label>:253                                     ; preds = %243
  call void @printerr(i8* getelementptr inbounds ([31 x i8]* @.str.19, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:254                                     ; preds = %243
  store i32 0, i32* %i, align 4
  br label %255

; <label>:255                                     ; preds = %326, %254
  %256 = load i32* %i, align 4
  %257 = load i32* @nblocks, align 4
  %258 = icmp slt i32 %256, %257
  br i1 %258, label %259, label %329

; <label>:259                                     ; preds = %255
  store i32 0, i32* %j, align 4
  br label %260

; <label>:260                                     ; preds = %322, %259
  %261 = load i32* %j, align 4
  %262 = load i32* @nblocks, align 4
  %263 = icmp slt i32 %261, %262
  br i1 %263, label %264, label %325

; <label>:264                                     ; preds = %260
  %265 = load i32* %i, align 4
  %266 = load i32* %j, align 4
  %267 = call i32 @BlockOwner(i32 %265, i32 %266)
  store i32 %267, i32* %proc_num, align 4
  %268 = load i32* %proc_num, align 4
  %269 = sext i32 %268 to i64
  %270 = load double*** @last_malloc, align 8
  %271 = getelementptr inbounds double** %270, i64 %269
  %272 = load double** %271, align 8
  %273 = load i32* %i, align 4
  %274 = load i32* %j, align 4
  %275 = load i32* @nblocks, align 4
  %276 = mul nsw i32 %274, %275
  %277 = add nsw i32 %273, %276
  %278 = sext i32 %277 to i64
  %279 = load double*** @a, align 8
  %280 = getelementptr inbounds double** %279, i64 %278
  store double* %272, double** %280, align 8
  %281 = load i32* %i, align 4
  %282 = load i32* @nblocks, align 4
  %283 = sub nsw i32 %282, 1
  %284 = icmp eq i32 %281, %283
  br i1 %284, label %285, label %294

; <label>:285                                     ; preds = %264
  %286 = load i32* %j, align 4
  %287 = load i32* @nblocks, align 4
  %288 = sub nsw i32 %287, 1
  %289 = icmp eq i32 %286, %288
  br i1 %289, label %290, label %294

; <label>:290                                     ; preds = %285
  %291 = load i32* %edge, align 4
  %292 = load i32* %edge, align 4
  %293 = mul nsw i32 %291, %292
  store i32 %293, i32* %size, align 4
  br label %313

; <label>:294                                     ; preds = %285, %264
  %295 = load i32* %i, align 4
  %296 = load i32* @nblocks, align 4
  %297 = sub nsw i32 %296, 1
  %298 = icmp eq i32 %295, %297
  br i1 %298, label %304, label %299

; <label>:299                                     ; preds = %294
  %300 = load i32* %j, align 4
  %301 = load i32* @nblocks, align 4
  %302 = sub nsw i32 %301, 1
  %303 = icmp eq i32 %300, %302
  br i1 %303, label %304, label %308

; <label>:304                                     ; preds = %299, %294
  %305 = load i32* %edge, align 4
  %306 = load i32* @block_size, align 4
  %307 = mul nsw i32 %305, %306
  store i32 %307, i32* %size, align 4
  br label %312

; <label>:308                                     ; preds = %299
  %309 = load i32* @block_size, align 4
  %310 = load i32* @block_size, align 4
  %311 = mul nsw i32 %309, %310
  store i32 %311, i32* %size, align 4
  br label %312

; <label>:312                                     ; preds = %308, %304
  br label %313

; <label>:313                                     ; preds = %312, %290
  %314 = load i32* %size, align 4
  %315 = load i32* %proc_num, align 4
  %316 = sext i32 %315 to i64
  %317 = load double*** @last_malloc, align 8
  %318 = getelementptr inbounds double** %317, i64 %316
  %319 = load double** %318, align 8
  %320 = sext i32 %314 to i64
  %321 = getelementptr inbounds double* %319, i64 %320
  store double* %321, double** %318, align 8
  br label %322

; <label>:322                                     ; preds = %313
  %323 = load i32* %j, align 4
  %324 = add nsw i32 %323, 1
  store i32 %324, i32* %j, align 4
  br label %260

; <label>:325                                     ; preds = %260
  br label %326

; <label>:326                                     ; preds = %325
  %327 = load i32* %i, align 4
  %328 = add nsw i32 %327, 1
  store i32 %328, i32* %i, align 4
  br label %255

; <label>:329                                     ; preds = %255
  %330 = load i32* @n, align 4
  %331 = sext i32 %330 to i64
  %332 = mul i64 %331, 8
  %333 = call noalias i8* @malloc(i64 %332)
  %334 = bitcast i8* %333 to double*
  store double* %334, double** @rhs, align 8
  %335 = load double** @rhs, align 8
  %336 = icmp eq double* %335, null
  br i1 %336, label %337, label %338

; <label>:337                                     ; preds = %329
  call void @printerr(i8* getelementptr inbounds ([33 x i8]* @.str.20, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:338                                     ; preds = %329
  %339 = call noalias i8* @malloc(i64 120)
  %340 = bitcast i8* %339 to %struct.GlobalMemory*
  store %struct.GlobalMemory* %340, %struct.GlobalMemory** @Global, align 8
  %341 = load i32* @P, align 4
  %342 = sext i32 %341 to i64
  %343 = mul i64 %342, 8
  %344 = call noalias i8* @malloc(i64 %343)
  %345 = bitcast i8* %344 to double*
  %346 = load %struct.GlobalMemory** @Global, align 8
  %347 = getelementptr inbounds %struct.GlobalMemory* %346, i32 0, i32 0
  store double* %345, double** %347, align 8
  %348 = load i32* @P, align 4
  %349 = sext i32 %348 to i64
  %350 = mul i64 %349, 8
  %351 = call noalias i8* @malloc(i64 %350)
  %352 = bitcast i8* %351 to double*
  %353 = load %struct.GlobalMemory** @Global, align 8
  %354 = getelementptr inbounds %struct.GlobalMemory* %353, i32 0, i32 2
  store double* %352, double** %354, align 8
  %355 = load i32* @P, align 4
  %356 = sext i32 %355 to i64
  %357 = mul i64 %356, 8
  %358 = call noalias i8* @malloc(i64 %357)
  %359 = bitcast i8* %358 to double*
  %360 = load %struct.GlobalMemory** @Global, align 8
  %361 = getelementptr inbounds %struct.GlobalMemory* %360, i32 0, i32 1
  store double* %359, double** %361, align 8
  %362 = load i32* @P, align 4
  %363 = sext i32 %362 to i64
  %364 = mul i64 %363, 8
  %365 = call noalias i8* @malloc(i64 %364)
  %366 = bitcast i8* %365 to double*
  %367 = load %struct.GlobalMemory** @Global, align 8
  %368 = getelementptr inbounds %struct.GlobalMemory* %367, i32 0, i32 3
  store double* %366, double** %368, align 8
  %369 = load i32* @P, align 4
  %370 = sext i32 %369 to i64
  %371 = mul i64 %370, 8
  %372 = call noalias i8* @malloc(i64 %371)
  %373 = bitcast i8* %372 to double*
  %374 = load %struct.GlobalMemory** @Global, align 8
  %375 = getelementptr inbounds %struct.GlobalMemory* %374, i32 0, i32 4
  store double* %373, double** %375, align 8
  %376 = load %struct.GlobalMemory** @Global, align 8
  %377 = icmp eq %struct.GlobalMemory* %376, null
  br i1 %377, label %378, label %379

; <label>:378                                     ; preds = %338
  call void @printerr(i8* getelementptr inbounds ([36 x i8]* @.str.21, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:379                                     ; preds = %338
  %380 = load %struct.GlobalMemory** @Global, align 8
  %381 = getelementptr inbounds %struct.GlobalMemory* %380, i32 0, i32 0
  %382 = load double** %381, align 8
  %383 = icmp eq double* %382, null
  br i1 %383, label %384, label %385

; <label>:384                                     ; preds = %379
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str.22, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:385                                     ; preds = %379
  %386 = load %struct.GlobalMemory** @Global, align 8
  %387 = getelementptr inbounds %struct.GlobalMemory* %386, i32 0, i32 2
  %388 = load double** %387, align 8
  %389 = icmp eq double* %388, null
  br i1 %389, label %390, label %391

; <label>:390                                     ; preds = %385
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str.23, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:391                                     ; preds = %385
  %392 = load %struct.GlobalMemory** @Global, align 8
  %393 = getelementptr inbounds %struct.GlobalMemory* %392, i32 0, i32 1
  %394 = load double** %393, align 8
  %395 = icmp eq double* %394, null
  br i1 %395, label %396, label %397

; <label>:396                                     ; preds = %391
  call void @printerr(i8* getelementptr inbounds ([48 x i8]* @.str.24, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:397                                     ; preds = %391
  %398 = load %struct.GlobalMemory** @Global, align 8
  %399 = getelementptr inbounds %struct.GlobalMemory* %398, i32 0, i32 3
  %400 = load double** %399, align 8
  %401 = icmp eq double* %400, null
  br i1 %401, label %402, label %403

; <label>:402                                     ; preds = %397
  call void @printerr(i8* getelementptr inbounds ([46 x i8]* @.str.25, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:403                                     ; preds = %397
  %404 = load %struct.GlobalMemory** @Global, align 8
  %405 = getelementptr inbounds %struct.GlobalMemory* %404, i32 0, i32 4
  %406 = load double** %405, align 8
  %407 = icmp eq double* %406, null
  br i1 %407, label %408, label %409

; <label>:408                                     ; preds = %403
  call void @printerr(i8* getelementptr inbounds ([48 x i8]* @.str.26, i32 0, i32 0))
  call void @exit(i32 -1)
  br label %UnifiedUnreachableBlock

; <label>:409                                     ; preds = %403
  br label %410

; <label>:410                                     ; preds = %409
  br label %411

; <label>:411                                     ; preds = %410
  br label %412

; <label>:412                                     ; preds = %411
  br label %413

; <label>:413                                     ; preds = %412
  br label %414

; <label>:414                                     ; preds = %413
  store i32 2, i32* @P
  %415 = load %struct.GlobalMemory** @Global, align 8
  %416 = getelementptr inbounds %struct.GlobalMemory* %415, i32 0, i32 10
  %417 = getelementptr inbounds %struct.barrier_t* %416, i32 0, i32 0
  store volatile i32 1, i32* %417, align 4
  %418 = load %struct.GlobalMemory** @Global, align 8
  %419 = getelementptr inbounds %struct.GlobalMemory* %418, i32 0, i32 10
  %420 = getelementptr inbounds %struct.barrier_t* %419, i32 0, i32 1
  store volatile i64 0, i64* %420, align 8
  %421 = load %struct.GlobalMemory** @Global, align 8
  %422 = getelementptr inbounds %struct.GlobalMemory* %421, i32 0, i32 11
  %423 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* %422, %union.pthread_mutexattr_t* null)
  %424 = load %struct.GlobalMemory** @Global, align 8
  %425 = getelementptr inbounds %struct.GlobalMemory* %424, i32 0, i32 9
  store i32 0, i32* %425, align 4
  store i32 1, i32* %i, align 4
  br label %426

; <label>:426                                     ; preds = %432, %414
  %427 = load i32* %i, align 4
  %428 = load i32* @P, align 4
  %429 = icmp slt i32 %427, %428
  br i1 %429, label %430, label %435

; <label>:430                                     ; preds = %426
  %431 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %432

; <label>:432                                     ; preds = %430
  %433 = load i32* %i, align 4
  %434 = add nsw i32 %433, 1
  store i32 %434, i32* %i, align 4
  br label %426

; <label>:435                                     ; preds = %426
  %436 = load double** @rhs, align 8
  call void @InitA(double* %436)
  %437 = load i32* @doprint, align 4
  %438 = icmp ne i32 %437, 0
  br i1 %438, label %439, label %441

; <label>:439                                     ; preds = %435
  %440 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str.27, i32 0, i32 0))
  call void @PrintA()
  br label %441

; <label>:441                                     ; preds = %439, %435
  %442 = load i32* %MyNum, align 4
  call void @SlaveStart()
  %443 = load i32* @doprint, align 4
  %444 = icmp ne i32 %443, 0
  br i1 %444, label %445, label %447

; <label>:445                                     ; preds = %441
  %446 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([30 x i8]* @.str.28, i32 0, i32 0))
  call void @PrintA()
  br label %447

; <label>:447                                     ; preds = %445, %441
  %448 = load i32* @dostats, align 4
  %449 = icmp ne i32 %448, 0
  br i1 %449, label %450, label %739

; <label>:450                                     ; preds = %447
  %451 = load %struct.GlobalMemory** @Global, align 8
  %452 = getelementptr inbounds %struct.GlobalMemory* %451, i32 0, i32 4
  %453 = load double** %452, align 8
  %454 = getelementptr inbounds double* %453, i64 0
  %455 = load double* %454, align 8
  store double %455, double* %mint, align 8
  store double %455, double* %avgt, align 8
  store double %455, double* %maxt, align 8
  store i32 1, i32* %i, align 4
  br label %456

; <label>:456                                     ; preds = %506, %450
  %457 = load i32* %i, align 4
  %458 = load i32* @P, align 4
  %459 = icmp slt i32 %457, %458
  br i1 %459, label %460, label %509

; <label>:460                                     ; preds = %456
  %461 = load i32* %i, align 4
  %462 = sext i32 %461 to i64
  %463 = load %struct.GlobalMemory** @Global, align 8
  %464 = getelementptr inbounds %struct.GlobalMemory* %463, i32 0, i32 4
  %465 = load double** %464, align 8
  %466 = getelementptr inbounds double* %465, i64 %462
  %467 = load double* %466, align 8
  %468 = load double* %maxt, align 8
  %469 = fcmp ogt double %467, %468
  br i1 %469, label %470, label %478

; <label>:470                                     ; preds = %460
  %471 = load i32* %i, align 4
  %472 = sext i32 %471 to i64
  %473 = load %struct.GlobalMemory** @Global, align 8
  %474 = getelementptr inbounds %struct.GlobalMemory* %473, i32 0, i32 4
  %475 = load double** %474, align 8
  %476 = getelementptr inbounds double* %475, i64 %472
  %477 = load double* %476, align 8
  store double %477, double* %maxt, align 8
  br label %478

; <label>:478                                     ; preds = %470, %460
  %479 = load i32* %i, align 4
  %480 = sext i32 %479 to i64
  %481 = load %struct.GlobalMemory** @Global, align 8
  %482 = getelementptr inbounds %struct.GlobalMemory* %481, i32 0, i32 4
  %483 = load double** %482, align 8
  %484 = getelementptr inbounds double* %483, i64 %480
  %485 = load double* %484, align 8
  %486 = load double* %mint, align 8
  %487 = fcmp olt double %485, %486
  br i1 %487, label %488, label %496

; <label>:488                                     ; preds = %478
  %489 = load i32* %i, align 4
  %490 = sext i32 %489 to i64
  %491 = load %struct.GlobalMemory** @Global, align 8
  %492 = getelementptr inbounds %struct.GlobalMemory* %491, i32 0, i32 4
  %493 = load double** %492, align 8
  %494 = getelementptr inbounds double* %493, i64 %490
  %495 = load double* %494, align 8
  store double %495, double* %mint, align 8
  br label %496

; <label>:496                                     ; preds = %488, %478
  %497 = load i32* %i, align 4
  %498 = sext i32 %497 to i64
  %499 = load %struct.GlobalMemory** @Global, align 8
  %500 = getelementptr inbounds %struct.GlobalMemory* %499, i32 0, i32 4
  %501 = load double** %500, align 8
  %502 = getelementptr inbounds double* %501, i64 %498
  %503 = load double* %502, align 8
  %504 = load double* %avgt, align 8
  %505 = fadd double %504, %503
  store double %505, double* %avgt, align 8
  br label %506

; <label>:506                                     ; preds = %496
  %507 = load i32* %i, align 4
  %508 = add nsw i32 %507, 1
  store i32 %508, i32* %i, align 4
  br label %456

; <label>:509                                     ; preds = %456
  %510 = load double* %avgt, align 8
  %511 = load i32* @P, align 4
  %512 = sitofp i32 %511 to double
  %513 = fdiv double %510, %512
  store double %513, double* %avgt, align 8
  %514 = load %struct.GlobalMemory** @Global, align 8
  %515 = getelementptr inbounds %struct.GlobalMemory* %514, i32 0, i32 0
  %516 = load double** %515, align 8
  %517 = getelementptr inbounds double* %516, i64 0
  %518 = load double* %517, align 8
  store double %518, double* %avg_fac, align 8
  store double %518, double* %max_fac, align 8
  store double %518, double* %min_fac, align 8
  %519 = load %struct.GlobalMemory** @Global, align 8
  %520 = getelementptr inbounds %struct.GlobalMemory* %519, i32 0, i32 1
  %521 = load double** %520, align 8
  %522 = getelementptr inbounds double* %521, i64 0
  %523 = load double* %522, align 8
  store double %523, double* %avg_solve, align 8
  store double %523, double* %max_solve, align 8
  store double %523, double* %min_solve, align 8
  %524 = load %struct.GlobalMemory** @Global, align 8
  %525 = getelementptr inbounds %struct.GlobalMemory* %524, i32 0, i32 2
  %526 = load double** %525, align 8
  %527 = getelementptr inbounds double* %526, i64 0
  %528 = load double* %527, align 8
  store double %528, double* %avg_mod, align 8
  store double %528, double* %max_mod, align 8
  store double %528, double* %min_mod, align 8
  %529 = load %struct.GlobalMemory** @Global, align 8
  %530 = getelementptr inbounds %struct.GlobalMemory* %529, i32 0, i32 3
  %531 = load double** %530, align 8
  %532 = getelementptr inbounds double* %531, i64 0
  %533 = load double* %532, align 8
  store double %533, double* %avg_bar, align 8
  store double %533, double* %max_bar, align 8
  store double %533, double* %min_bar, align 8
  store i32 1, i32* %i, align 4
  br label %534

; <label>:534                                     ; preds = %719, %509
  %535 = load i32* %i, align 4
  %536 = load i32* @P, align 4
  %537 = icmp slt i32 %535, %536
  br i1 %537, label %538, label %722

; <label>:538                                     ; preds = %534
  %539 = load i32* %i, align 4
  %540 = sext i32 %539 to i64
  %541 = load %struct.GlobalMemory** @Global, align 8
  %542 = getelementptr inbounds %struct.GlobalMemory* %541, i32 0, i32 0
  %543 = load double** %542, align 8
  %544 = getelementptr inbounds double* %543, i64 %540
  %545 = load double* %544, align 8
  %546 = load double* %max_fac, align 8
  %547 = fcmp ogt double %545, %546
  br i1 %547, label %548, label %556

; <label>:548                                     ; preds = %538
  %549 = load i32* %i, align 4
  %550 = sext i32 %549 to i64
  %551 = load %struct.GlobalMemory** @Global, align 8
  %552 = getelementptr inbounds %struct.GlobalMemory* %551, i32 0, i32 0
  %553 = load double** %552, align 8
  %554 = getelementptr inbounds double* %553, i64 %550
  %555 = load double* %554, align 8
  store double %555, double* %max_fac, align 8
  br label %556

; <label>:556                                     ; preds = %548, %538
  %557 = load i32* %i, align 4
  %558 = sext i32 %557 to i64
  %559 = load %struct.GlobalMemory** @Global, align 8
  %560 = getelementptr inbounds %struct.GlobalMemory* %559, i32 0, i32 0
  %561 = load double** %560, align 8
  %562 = getelementptr inbounds double* %561, i64 %558
  %563 = load double* %562, align 8
  %564 = load double* %min_fac, align 8
  %565 = fcmp olt double %563, %564
  br i1 %565, label %566, label %574

; <label>:566                                     ; preds = %556
  %567 = load i32* %i, align 4
  %568 = sext i32 %567 to i64
  %569 = load %struct.GlobalMemory** @Global, align 8
  %570 = getelementptr inbounds %struct.GlobalMemory* %569, i32 0, i32 0
  %571 = load double** %570, align 8
  %572 = getelementptr inbounds double* %571, i64 %568
  %573 = load double* %572, align 8
  store double %573, double* %min_fac, align 8
  br label %574

; <label>:574                                     ; preds = %566, %556
  %575 = load i32* %i, align 4
  %576 = sext i32 %575 to i64
  %577 = load %struct.GlobalMemory** @Global, align 8
  %578 = getelementptr inbounds %struct.GlobalMemory* %577, i32 0, i32 1
  %579 = load double** %578, align 8
  %580 = getelementptr inbounds double* %579, i64 %576
  %581 = load double* %580, align 8
  %582 = load double* %max_solve, align 8
  %583 = fcmp ogt double %581, %582
  br i1 %583, label %584, label %592

; <label>:584                                     ; preds = %574
  %585 = load i32* %i, align 4
  %586 = sext i32 %585 to i64
  %587 = load %struct.GlobalMemory** @Global, align 8
  %588 = getelementptr inbounds %struct.GlobalMemory* %587, i32 0, i32 1
  %589 = load double** %588, align 8
  %590 = getelementptr inbounds double* %589, i64 %586
  %591 = load double* %590, align 8
  store double %591, double* %max_solve, align 8
  br label %592

; <label>:592                                     ; preds = %584, %574
  %593 = load i32* %i, align 4
  %594 = sext i32 %593 to i64
  %595 = load %struct.GlobalMemory** @Global, align 8
  %596 = getelementptr inbounds %struct.GlobalMemory* %595, i32 0, i32 1
  %597 = load double** %596, align 8
  %598 = getelementptr inbounds double* %597, i64 %594
  %599 = load double* %598, align 8
  %600 = load double* %min_solve, align 8
  %601 = fcmp olt double %599, %600
  br i1 %601, label %602, label %610

; <label>:602                                     ; preds = %592
  %603 = load i32* %i, align 4
  %604 = sext i32 %603 to i64
  %605 = load %struct.GlobalMemory** @Global, align 8
  %606 = getelementptr inbounds %struct.GlobalMemory* %605, i32 0, i32 1
  %607 = load double** %606, align 8
  %608 = getelementptr inbounds double* %607, i64 %604
  %609 = load double* %608, align 8
  store double %609, double* %min_solve, align 8
  br label %610

; <label>:610                                     ; preds = %602, %592
  %611 = load i32* %i, align 4
  %612 = sext i32 %611 to i64
  %613 = load %struct.GlobalMemory** @Global, align 8
  %614 = getelementptr inbounds %struct.GlobalMemory* %613, i32 0, i32 2
  %615 = load double** %614, align 8
  %616 = getelementptr inbounds double* %615, i64 %612
  %617 = load double* %616, align 8
  %618 = load double* %max_mod, align 8
  %619 = fcmp ogt double %617, %618
  br i1 %619, label %620, label %628

; <label>:620                                     ; preds = %610
  %621 = load i32* %i, align 4
  %622 = sext i32 %621 to i64
  %623 = load %struct.GlobalMemory** @Global, align 8
  %624 = getelementptr inbounds %struct.GlobalMemory* %623, i32 0, i32 2
  %625 = load double** %624, align 8
  %626 = getelementptr inbounds double* %625, i64 %622
  %627 = load double* %626, align 8
  store double %627, double* %max_mod, align 8
  br label %628

; <label>:628                                     ; preds = %620, %610
  %629 = load i32* %i, align 4
  %630 = sext i32 %629 to i64
  %631 = load %struct.GlobalMemory** @Global, align 8
  %632 = getelementptr inbounds %struct.GlobalMemory* %631, i32 0, i32 2
  %633 = load double** %632, align 8
  %634 = getelementptr inbounds double* %633, i64 %630
  %635 = load double* %634, align 8
  %636 = load double* %min_mod, align 8
  %637 = fcmp olt double %635, %636
  br i1 %637, label %638, label %646

; <label>:638                                     ; preds = %628
  %639 = load i32* %i, align 4
  %640 = sext i32 %639 to i64
  %641 = load %struct.GlobalMemory** @Global, align 8
  %642 = getelementptr inbounds %struct.GlobalMemory* %641, i32 0, i32 2
  %643 = load double** %642, align 8
  %644 = getelementptr inbounds double* %643, i64 %640
  %645 = load double* %644, align 8
  store double %645, double* %min_mod, align 8
  br label %646

; <label>:646                                     ; preds = %638, %628
  %647 = load i32* %i, align 4
  %648 = sext i32 %647 to i64
  %649 = load %struct.GlobalMemory** @Global, align 8
  %650 = getelementptr inbounds %struct.GlobalMemory* %649, i32 0, i32 3
  %651 = load double** %650, align 8
  %652 = getelementptr inbounds double* %651, i64 %648
  %653 = load double* %652, align 8
  %654 = load double* %max_bar, align 8
  %655 = fcmp ogt double %653, %654
  br i1 %655, label %656, label %664

; <label>:656                                     ; preds = %646
  %657 = load i32* %i, align 4
  %658 = sext i32 %657 to i64
  %659 = load %struct.GlobalMemory** @Global, align 8
  %660 = getelementptr inbounds %struct.GlobalMemory* %659, i32 0, i32 3
  %661 = load double** %660, align 8
  %662 = getelementptr inbounds double* %661, i64 %658
  %663 = load double* %662, align 8
  store double %663, double* %max_bar, align 8
  br label %664

; <label>:664                                     ; preds = %656, %646
  %665 = load i32* %i, align 4
  %666 = sext i32 %665 to i64
  %667 = load %struct.GlobalMemory** @Global, align 8
  %668 = getelementptr inbounds %struct.GlobalMemory* %667, i32 0, i32 3
  %669 = load double** %668, align 8
  %670 = getelementptr inbounds double* %669, i64 %666
  %671 = load double* %670, align 8
  %672 = load double* %min_bar, align 8
  %673 = fcmp olt double %671, %672
  br i1 %673, label %674, label %682

; <label>:674                                     ; preds = %664
  %675 = load i32* %i, align 4
  %676 = sext i32 %675 to i64
  %677 = load %struct.GlobalMemory** @Global, align 8
  %678 = getelementptr inbounds %struct.GlobalMemory* %677, i32 0, i32 3
  %679 = load double** %678, align 8
  %680 = getelementptr inbounds double* %679, i64 %676
  %681 = load double* %680, align 8
  store double %681, double* %min_bar, align 8
  br label %682

; <label>:682                                     ; preds = %674, %664
  %683 = load i32* %i, align 4
  %684 = sext i32 %683 to i64
  %685 = load %struct.GlobalMemory** @Global, align 8
  %686 = getelementptr inbounds %struct.GlobalMemory* %685, i32 0, i32 0
  %687 = load double** %686, align 8
  %688 = getelementptr inbounds double* %687, i64 %684
  %689 = load double* %688, align 8
  %690 = load double* %avg_fac, align 8
  %691 = fadd double %690, %689
  store double %691, double* %avg_fac, align 8
  %692 = load i32* %i, align 4
  %693 = sext i32 %692 to i64
  %694 = load %struct.GlobalMemory** @Global, align 8
  %695 = getelementptr inbounds %struct.GlobalMemory* %694, i32 0, i32 1
  %696 = load double** %695, align 8
  %697 = getelementptr inbounds double* %696, i64 %693
  %698 = load double* %697, align 8
  %699 = load double* %avg_solve, align 8
  %700 = fadd double %699, %698
  store double %700, double* %avg_solve, align 8
  %701 = load i32* %i, align 4
  %702 = sext i32 %701 to i64
  %703 = load %struct.GlobalMemory** @Global, align 8
  %704 = getelementptr inbounds %struct.GlobalMemory* %703, i32 0, i32 2
  %705 = load double** %704, align 8
  %706 = getelementptr inbounds double* %705, i64 %702
  %707 = load double* %706, align 8
  %708 = load double* %avg_mod, align 8
  %709 = fadd double %708, %707
  store double %709, double* %avg_mod, align 8
  %710 = load i32* %i, align 4
  %711 = sext i32 %710 to i64
  %712 = load %struct.GlobalMemory** @Global, align 8
  %713 = getelementptr inbounds %struct.GlobalMemory* %712, i32 0, i32 3
  %714 = load double** %713, align 8
  %715 = getelementptr inbounds double* %714, i64 %711
  %716 = load double* %715, align 8
  %717 = load double* %avg_bar, align 8
  %718 = fadd double %717, %716
  store double %718, double* %avg_bar, align 8
  br label %719

; <label>:719                                     ; preds = %682
  %720 = load i32* %i, align 4
  %721 = add nsw i32 %720, 1
  store i32 %721, i32* %i, align 4
  br label %534

; <label>:722                                     ; preds = %534
  %723 = load double* %avg_fac, align 8
  %724 = load i32* @P, align 4
  %725 = sitofp i32 %724 to double
  %726 = fdiv double %723, %725
  store double %726, double* %avg_fac, align 8
  %727 = load double* %avg_solve, align 8
  %728 = load i32* @P, align 4
  %729 = sitofp i32 %728 to double
  %730 = fdiv double %727, %729
  store double %730, double* %avg_solve, align 8
  %731 = load double* %avg_mod, align 8
  %732 = load i32* @P, align 4
  %733 = sitofp i32 %732 to double
  %734 = fdiv double %731, %733
  store double %734, double* %avg_mod, align 8
  %735 = load double* %avg_bar, align 8
  %736 = load i32* @P, align 4
  %737 = sitofp i32 %736 to double
  %738 = fdiv double %735, %737
  store double %738, double* %avg_bar, align 8
  br label %739

; <label>:739                                     ; preds = %722, %447
  %740 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([48 x i8]* @.str.29, i32 0, i32 0))
  %741 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([77 x i8]* @.str.30, i32 0, i32 0))
  %742 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([75 x i8]* @.str.31, i32 0, i32 0))
  %743 = load %struct.GlobalMemory** @Global, align 8
  %744 = getelementptr inbounds %struct.GlobalMemory* %743, i32 0, i32 4
  %745 = load double** %744, align 8
  %746 = getelementptr inbounds double* %745, i64 0
  %747 = load double* %746, align 8
  %748 = load %struct.GlobalMemory** @Global, align 8
  %749 = getelementptr inbounds %struct.GlobalMemory* %748, i32 0, i32 0
  %750 = load double** %749, align 8
  %751 = getelementptr inbounds double* %750, i64 0
  %752 = load double* %751, align 8
  %753 = load %struct.GlobalMemory** @Global, align 8
  %754 = getelementptr inbounds %struct.GlobalMemory* %753, i32 0, i32 1
  %755 = load double** %754, align 8
  %756 = getelementptr inbounds double* %755, i64 0
  %757 = load double* %756, align 8
  %758 = load %struct.GlobalMemory** @Global, align 8
  %759 = getelementptr inbounds %struct.GlobalMemory* %758, i32 0, i32 2
  %760 = load double** %759, align 8
  %761 = getelementptr inbounds double* %760, i64 0
  %762 = load double* %761, align 8
  %763 = load %struct.GlobalMemory** @Global, align 8
  %764 = getelementptr inbounds %struct.GlobalMemory* %763, i32 0, i32 3
  %765 = load double** %764, align 8
  %766 = getelementptr inbounds double* %765, i64 0
  %767 = load double* %766, align 8
  %768 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.32, i32 0, i32 0), double %747, double %752, double %757, double %762, double %767)
  %769 = load i32* @dostats, align 4
  %770 = icmp ne i32 %769, 0
  br i1 %770, label %771, label %836

; <label>:771                                     ; preds = %739
  store i32 1, i32* %i, align 4
  br label %772

; <label>:772                                     ; preds = %814, %771
  %773 = load i32* %i, align 4
  %774 = load i32* @P, align 4
  %775 = icmp slt i32 %773, %774
  br i1 %775, label %776, label %817

; <label>:776                                     ; preds = %772
  %777 = load i32* %i, align 4
  %778 = load i32* %i, align 4
  %779 = sext i32 %778 to i64
  %780 = load %struct.GlobalMemory** @Global, align 8
  %781 = getelementptr inbounds %struct.GlobalMemory* %780, i32 0, i32 4
  %782 = load double** %781, align 8
  %783 = getelementptr inbounds double* %782, i64 %779
  %784 = load double* %783, align 8
  %785 = load i32* %i, align 4
  %786 = sext i32 %785 to i64
  %787 = load %struct.GlobalMemory** @Global, align 8
  %788 = getelementptr inbounds %struct.GlobalMemory* %787, i32 0, i32 0
  %789 = load double** %788, align 8
  %790 = getelementptr inbounds double* %789, i64 %786
  %791 = load double* %790, align 8
  %792 = load i32* %i, align 4
  %793 = sext i32 %792 to i64
  %794 = load %struct.GlobalMemory** @Global, align 8
  %795 = getelementptr inbounds %struct.GlobalMemory* %794, i32 0, i32 1
  %796 = load double** %795, align 8
  %797 = getelementptr inbounds double* %796, i64 %793
  %798 = load double* %797, align 8
  %799 = load i32* %i, align 4
  %800 = sext i32 %799 to i64
  %801 = load %struct.GlobalMemory** @Global, align 8
  %802 = getelementptr inbounds %struct.GlobalMemory* %801, i32 0, i32 2
  %803 = load double** %802, align 8
  %804 = getelementptr inbounds double* %803, i64 %800
  %805 = load double* %804, align 8
  %806 = load i32* %i, align 4
  %807 = sext i32 %806 to i64
  %808 = load %struct.GlobalMemory** @Global, align 8
  %809 = getelementptr inbounds %struct.GlobalMemory* %808, i32 0, i32 3
  %810 = load double** %809, align 8
  %811 = getelementptr inbounds double* %810, i64 %807
  %812 = load double* %811, align 8
  %813 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.33, i32 0, i32 0), i32 %777, double %784, double %791, double %798, double %805, double %812)
  br label %814

; <label>:814                                     ; preds = %776
  %815 = load i32* %i, align 4
  %816 = add nsw i32 %815, 1
  store i32 %816, i32* %i, align 4
  br label %772

; <label>:817                                     ; preds = %772
  %818 = load double* %avgt, align 8
  %819 = load double* %avg_fac, align 8
  %820 = load double* %avg_solve, align 8
  %821 = load double* %avg_mod, align 8
  %822 = load double* %avg_bar, align 8
  %823 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.34, i32 0, i32 0), double %818, double %819, double %820, double %821, double %822)
  %824 = load double* %mint, align 8
  %825 = load double* %min_fac, align 8
  %826 = load double* %min_solve, align 8
  %827 = load double* %min_mod, align 8
  %828 = load double* %min_bar, align 8
  %829 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.35, i32 0, i32 0), double %824, double %825, double %826, double %827, double %828)
  %830 = load double* %maxt, align 8
  %831 = load double* %max_fac, align 8
  %832 = load double* %max_solve, align 8
  %833 = load double* %max_mod, align 8
  %834 = load double* %max_bar, align 8
  %835 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.36, i32 0, i32 0), double %830, double %831, double %832, double %833, double %834)
  br label %836

; <label>:836                                     ; preds = %817, %739
  %837 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  %838 = load i32* %start, align 4
  %839 = load %struct.GlobalMemory** @Global, align 8
  %840 = getelementptr inbounds %struct.GlobalMemory* %839, i32 0, i32 5
  store i32 %838, i32* %840, align 4
  %841 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([48 x i8]* @.str.37, i32 0, i32 0))
  %842 = load %struct.GlobalMemory** @Global, align 8
  %843 = getelementptr inbounds %struct.GlobalMemory* %842, i32 0, i32 5
  %844 = load i32* %843, align 4
  %845 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.38, i32 0, i32 0), i32 %844)
  %846 = load %struct.GlobalMemory** @Global, align 8
  %847 = getelementptr inbounds %struct.GlobalMemory* %846, i32 0, i32 7
  %848 = load i32* %847, align 4
  %849 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.39, i32 0, i32 0), i32 %848)
  %850 = load %struct.GlobalMemory** @Global, align 8
  %851 = getelementptr inbounds %struct.GlobalMemory* %850, i32 0, i32 6
  %852 = load i32* %851, align 4
  %853 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.40, i32 0, i32 0), i32 %852)
  %854 = load %struct.GlobalMemory** @Global, align 8
  %855 = getelementptr inbounds %struct.GlobalMemory* %854, i32 0, i32 6
  %856 = load i32* %855, align 4
  %857 = load %struct.GlobalMemory** @Global, align 8
  %858 = getelementptr inbounds %struct.GlobalMemory* %857, i32 0, i32 5
  %859 = load i32* %858, align 4
  %860 = sub i32 %856, %859
  %861 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.41, i32 0, i32 0), i32 %860)
  %862 = load %struct.GlobalMemory** @Global, align 8
  %863 = getelementptr inbounds %struct.GlobalMemory* %862, i32 0, i32 6
  %864 = load i32* %863, align 4
  %865 = load %struct.GlobalMemory** @Global, align 8
  %866 = getelementptr inbounds %struct.GlobalMemory* %865, i32 0, i32 7
  %867 = load i32* %866, align 4
  %868 = sub i32 %864, %867
  %869 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.42, i32 0, i32 0), i32 %868)
  %870 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  %871 = load i32* @test_result, align 4
  %872 = icmp ne i32 %871, 0
  br i1 %872, label %873, label %878

; <label>:873                                     ; preds = %836
  %874 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([46 x i8]* @.str.43, i32 0, i32 0))
  %875 = load i32* @n, align 4
  %876 = load double*** @a, align 8
  %877 = load double** @rhs, align 8
  call void @CheckResult(i32 %875, double** %876, double* %877)
  br label %878

; <label>:878                                     ; preds = %873, %836
  call void @exit(i32 0)
  br label %UnifiedUnreachableBlock
                                                  ; No predecessors!
  %880 = load i32* %1
  call void @waitForAll()
  ret i32 %880

UnifiedUnreachableBlock:                          ; preds = %878, %408, %402, %396, %390, %384, %378, %337, %253, %214, %33
  call void @waitForAll()
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
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 %I, i32* %1, align 4
  store i32 %J, i32* %2, align 4
  %3 = load i32* %2, align 4
  %4 = load i32* @num_cols, align 4
  %5 = srem i32 %3, %4
  %6 = load i32* %1, align 4
  %7 = load i32* @num_rows, align 4
  %8 = srem i32 %6, %7
  %9 = load i32* @num_cols, align 4
  %10 = mul nsw i32 %8, %9
  %11 = add nsw i32 %5, %10
  ret i32 %11
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

; Function Attrs: nounwind uwtable
define internal void @printerr(i8* %s) {
  %1 = alloca i8*, align 8
  store i8* %s, i8** %1, align 8
  %2 = load %struct._IO_FILE** @stderr, align 8
  %3 = load i8** %1, align 8
  %4 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([11 x i8]* @.str.49, i32 0, i32 0), i8* %3)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*)

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: nounwind uwtable
define internal void @InitA(double* %rhs) {
  %1 = alloca double*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %ii = alloca i32, align 4
  %jj = alloca i32, align 4
  %edge = alloca i32, align 4
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  %skip = alloca i32, align 4
  store double* %rhs, double** %1, align 8
  call void @srand48(i64 1)
  %2 = load i32* @n, align 4
  %3 = load i32* @block_size, align 4
  %4 = srem i32 %2, %3
  store i32 %4, i32* %edge, align 4
  store i32 0, i32* %j, align 4
  br label %5

; <label>:5                                       ; preds = %91, %0
  %6 = load i32* %j, align 4
  %7 = load i32* @n, align 4
  %8 = icmp slt i32 %6, %7
  br i1 %8, label %9, label %94

; <label>:9                                       ; preds = %5
  store i32 0, i32* %i, align 4
  br label %10

; <label>:10                                      ; preds = %87, %9
  %11 = load i32* %i, align 4
  %12 = load i32* @n, align 4
  %13 = icmp slt i32 %11, %12
  br i1 %13, label %14, label %90

; <label>:14                                      ; preds = %10
  %15 = load i32* @n, align 4
  %16 = load i32* %i, align 4
  %17 = sub nsw i32 %15, %16
  %18 = load i32* %edge, align 4
  %19 = icmp sle i32 %17, %18
  br i1 %19, label %20, label %26

; <label>:20                                      ; preds = %14
  %21 = load i32* %edge, align 4
  store i32 %21, i32* %ibs, align 4
  %22 = load i32* @n, align 4
  %23 = load i32* %edge, align 4
  %24 = sub nsw i32 %22, %23
  store i32 %24, i32* %ibs, align 4
  %25 = load i32* %edge, align 4
  store i32 %25, i32* %skip, align 4
  br label %29

; <label>:26                                      ; preds = %14
  %27 = load i32* @block_size, align 4
  store i32 %27, i32* %ibs, align 4
  %28 = load i32* @block_size, align 4
  store i32 %28, i32* %skip, align 4
  br label %29

; <label>:29                                      ; preds = %26, %20
  %30 = load i32* @n, align 4
  %31 = load i32* %j, align 4
  %32 = sub nsw i32 %30, %31
  %33 = load i32* %edge, align 4
  %34 = icmp sle i32 %32, %33
  br i1 %34, label %35, label %40

; <label>:35                                      ; preds = %29
  %36 = load i32* %edge, align 4
  store i32 %36, i32* %jbs, align 4
  %37 = load i32* @n, align 4
  %38 = load i32* %edge, align 4
  %39 = sub nsw i32 %37, %38
  store i32 %39, i32* %jbs, align 4
  br label %42

; <label>:40                                      ; preds = %29
  %41 = load i32* @block_size, align 4
  store i32 %41, i32* %jbs, align 4
  br label %42

; <label>:42                                      ; preds = %40, %35
  %43 = load i32* %i, align 4
  %44 = load i32* @block_size, align 4
  %45 = sdiv i32 %43, %44
  %46 = load i32* %j, align 4
  %47 = load i32* @block_size, align 4
  %48 = sdiv i32 %46, %47
  %49 = load i32* @nblocks, align 4
  %50 = mul nsw i32 %48, %49
  %51 = add nsw i32 %45, %50
  store i32 %51, i32* %ii, align 4
  %52 = load i32* %i, align 4
  %53 = load i32* %ibs, align 4
  %54 = srem i32 %52, %53
  %55 = load i32* %j, align 4
  %56 = load i32* %jbs, align 4
  %57 = srem i32 %55, %56
  %58 = load i32* %skip, align 4
  %59 = mul nsw i32 %57, %58
  %60 = add nsw i32 %54, %59
  store i32 %60, i32* %jj, align 4
  %61 = call i64 @lrand48()
  %62 = sitofp i64 %61 to double
  %63 = fdiv double %62, 3.276700e+04
  %64 = load i32* %jj, align 4
  %65 = sext i32 %64 to i64
  %66 = load i32* %ii, align 4
  %67 = sext i32 %66 to i64
  %68 = load double*** @a, align 8
  %69 = getelementptr inbounds double** %68, i64 %67
  %70 = load double** %69, align 8
  %71 = getelementptr inbounds double* %70, i64 %65
  store double %63, double* %71, align 8
  %72 = load i32* %i, align 4
  %73 = load i32* %j, align 4
  %74 = icmp eq i32 %72, %73
  br i1 %74, label %75, label %86

; <label>:75                                      ; preds = %42
  %76 = load i32* %jj, align 4
  %77 = sext i32 %76 to i64
  %78 = load i32* %ii, align 4
  %79 = sext i32 %78 to i64
  %80 = load double*** @a, align 8
  %81 = getelementptr inbounds double** %80, i64 %79
  %82 = load double** %81, align 8
  %83 = getelementptr inbounds double* %82, i64 %77
  %84 = load double* %83, align 8
  %85 = fmul double %84, 1.000000e+01
  store double %85, double* %83, align 8
  br label %86

; <label>:86                                      ; preds = %75, %42
  br label %87

; <label>:87                                      ; preds = %86
  %88 = load i32* %i, align 4
  %89 = add nsw i32 %88, 1
  store i32 %89, i32* %i, align 4
  br label %10

; <label>:90                                      ; preds = %10
  br label %91

; <label>:91                                      ; preds = %90
  %92 = load i32* %j, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, i32* %j, align 4
  br label %5

; <label>:94                                      ; preds = %5
  store i32 0, i32* %j, align 4
  br label %95

; <label>:95                                      ; preds = %104, %94
  %96 = load i32* %j, align 4
  %97 = load i32* @n, align 4
  %98 = icmp slt i32 %96, %97
  br i1 %98, label %99, label %107

; <label>:99                                      ; preds = %95
  %100 = load i32* %j, align 4
  %101 = sext i32 %100 to i64
  %102 = load double** %1, align 8
  %103 = getelementptr inbounds double* %102, i64 %101
  store double 0.000000e+00, double* %103, align 8
  br label %104

; <label>:104                                     ; preds = %99
  %105 = load i32* %j, align 4
  %106 = add nsw i32 %105, 1
  store i32 %106, i32* %j, align 4
  br label %95

; <label>:107                                     ; preds = %95
  store i32 0, i32* %j, align 4
  br label %108

; <label>:108                                     ; preds = %183, %107
  %109 = load i32* %j, align 4
  %110 = load i32* @n, align 4
  %111 = icmp slt i32 %109, %110
  br i1 %111, label %112, label %186

; <label>:112                                     ; preds = %108
  store i32 0, i32* %i, align 4
  br label %113

; <label>:113                                     ; preds = %179, %112
  %114 = load i32* %i, align 4
  %115 = load i32* @n, align 4
  %116 = icmp slt i32 %114, %115
  br i1 %116, label %117, label %182

; <label>:117                                     ; preds = %113
  %118 = load i32* @n, align 4
  %119 = load i32* %i, align 4
  %120 = sub nsw i32 %118, %119
  %121 = load i32* %edge, align 4
  %122 = icmp sle i32 %120, %121
  br i1 %122, label %123, label %129

; <label>:123                                     ; preds = %117
  %124 = load i32* %edge, align 4
  store i32 %124, i32* %ibs, align 4
  %125 = load i32* @n, align 4
  %126 = load i32* %edge, align 4
  %127 = sub nsw i32 %125, %126
  store i32 %127, i32* %ibs, align 4
  %128 = load i32* %edge, align 4
  store i32 %128, i32* %skip, align 4
  br label %132

; <label>:129                                     ; preds = %117
  %130 = load i32* @block_size, align 4
  store i32 %130, i32* %ibs, align 4
  %131 = load i32* @block_size, align 4
  store i32 %131, i32* %skip, align 4
  br label %132

; <label>:132                                     ; preds = %129, %123
  %133 = load i32* @n, align 4
  %134 = load i32* %j, align 4
  %135 = sub nsw i32 %133, %134
  %136 = load i32* %edge, align 4
  %137 = icmp sle i32 %135, %136
  br i1 %137, label %138, label %143

; <label>:138                                     ; preds = %132
  %139 = load i32* %edge, align 4
  store i32 %139, i32* %jbs, align 4
  %140 = load i32* @n, align 4
  %141 = load i32* %edge, align 4
  %142 = sub nsw i32 %140, %141
  store i32 %142, i32* %jbs, align 4
  br label %145

; <label>:143                                     ; preds = %132
  %144 = load i32* @block_size, align 4
  store i32 %144, i32* %jbs, align 4
  br label %145

; <label>:145                                     ; preds = %143, %138
  %146 = load i32* %i, align 4
  %147 = load i32* @block_size, align 4
  %148 = sdiv i32 %146, %147
  %149 = load i32* %j, align 4
  %150 = load i32* @block_size, align 4
  %151 = sdiv i32 %149, %150
  %152 = load i32* @nblocks, align 4
  %153 = mul nsw i32 %151, %152
  %154 = add nsw i32 %148, %153
  store i32 %154, i32* %ii, align 4
  %155 = load i32* %i, align 4
  %156 = load i32* %ibs, align 4
  %157 = srem i32 %155, %156
  %158 = load i32* %j, align 4
  %159 = load i32* %jbs, align 4
  %160 = srem i32 %158, %159
  %161 = load i32* %skip, align 4
  %162 = mul nsw i32 %160, %161
  %163 = add nsw i32 %157, %162
  store i32 %163, i32* %jj, align 4
  %164 = load i32* %jj, align 4
  %165 = sext i32 %164 to i64
  %166 = load i32* %ii, align 4
  %167 = sext i32 %166 to i64
  %168 = load double*** @a, align 8
  %169 = getelementptr inbounds double** %168, i64 %167
  %170 = load double** %169, align 8
  %171 = getelementptr inbounds double* %170, i64 %165
  %172 = load double* %171, align 8
  %173 = load i32* %i, align 4
  %174 = sext i32 %173 to i64
  %175 = load double** %1, align 8
  %176 = getelementptr inbounds double* %175, i64 %174
  %177 = load double* %176, align 8
  %178 = fadd double %177, %172
  store double %178, double* %176, align 8
  br label %179

; <label>:179                                     ; preds = %145
  %180 = load i32* %i, align 4
  %181 = add nsw i32 %180, 1
  store i32 %181, i32* %i, align 4
  br label %113

; <label>:182                                     ; preds = %113
  br label %183

; <label>:183                                     ; preds = %182
  %184 = load i32* %j, align 4
  %185 = add nsw i32 %184, 1
  store i32 %185, i32* %j, align 4
  br label %108

; <label>:186                                     ; preds = %108
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckResult(i32 %n, double** %a, double* %rhs) {
  %1 = alloca i32, align 4
  %2 = alloca double**, align 8
  %3 = alloca double*, align 8
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
  store i32 %n, i32* %1, align 4
  store double** %a, double*** %2, align 8
  store double* %rhs, double** %3, align 8
  store i32 0, i32* %bogus, align 4
  %4 = load i32* %1, align 4
  %5 = load i32* @block_size, align 4
  %6 = srem i32 %4, %5
  store i32 %6, i32* %edge, align 4
  %7 = load i32* %1, align 4
  %8 = sext i32 %7 to i64
  %9 = mul i64 %8, 8
  %10 = call noalias i8* @malloc(i64 %9)
  %11 = bitcast i8* %10 to double*
  store double* %11, double** %y, align 8
  %12 = load double** %y, align 8
  %13 = icmp eq double* %12, null
  br i1 %13, label %14, label %15

; <label>:14                                      ; preds = %0
  call void @printerr(i8* getelementptr inbounds ([31 x i8]* @.str.46, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

; <label>:15                                      ; preds = %0
  store i32 0, i32* %j, align 4
  br label %16

; <label>:16                                      ; preds = %30, %15
  %17 = load i32* %j, align 4
  %18 = load i32* %1, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %20, label %33

; <label>:20                                      ; preds = %16
  %21 = load i32* %j, align 4
  %22 = sext i32 %21 to i64
  %23 = load double** %3, align 8
  %24 = getelementptr inbounds double* %23, i64 %22
  %25 = load double* %24, align 8
  %26 = load i32* %j, align 4
  %27 = sext i32 %26 to i64
  %28 = load double** %y, align 8
  %29 = getelementptr inbounds double* %28, i64 %27
  store double %25, double* %29, align 8
  br label %30

; <label>:30                                      ; preds = %20
  %31 = load i32* %j, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %j, align 4
  br label %16

; <label>:33                                      ; preds = %16
  store i32 0, i32* %j, align 4
  br label %34

; <label>:34                                      ; preds = %156, %33
  %35 = load i32* %j, align 4
  %36 = load i32* %1, align 4
  %37 = icmp slt i32 %35, %36
  br i1 %37, label %38, label %159

; <label>:38                                      ; preds = %34
  %39 = load i32* %1, align 4
  %40 = load i32* %j, align 4
  %41 = sub nsw i32 %39, %40
  %42 = load i32* %edge, align 4
  %43 = icmp sle i32 %41, %42
  br i1 %43, label %44, label %50

; <label>:44                                      ; preds = %38
  %45 = load i32* %edge, align 4
  store i32 %45, i32* %jbs, align 4
  %46 = load i32* %1, align 4
  %47 = load i32* %edge, align 4
  %48 = sub nsw i32 %46, %47
  store i32 %48, i32* %jbs, align 4
  %49 = load i32* %edge, align 4
  store i32 %49, i32* %skip, align 4
  br label %53

; <label>:50                                      ; preds = %38
  %51 = load i32* @block_size, align 4
  store i32 %51, i32* %jbs, align 4
  %52 = load i32* @block_size, align 4
  store i32 %52, i32* %skip, align 4
  br label %53

; <label>:53                                      ; preds = %50, %44
  %54 = load i32* %j, align 4
  %55 = load i32* @block_size, align 4
  %56 = sdiv i32 %54, %55
  %57 = load i32* %j, align 4
  %58 = load i32* @block_size, align 4
  %59 = sdiv i32 %57, %58
  %60 = load i32* @nblocks, align 4
  %61 = mul nsw i32 %59, %60
  %62 = add nsw i32 %56, %61
  store i32 %62, i32* %ii, align 4
  %63 = load i32* %j, align 4
  %64 = load i32* %jbs, align 4
  %65 = srem i32 %63, %64
  %66 = load i32* %j, align 4
  %67 = load i32* %jbs, align 4
  %68 = srem i32 %66, %67
  %69 = load i32* %skip, align 4
  %70 = mul nsw i32 %68, %69
  %71 = add nsw i32 %65, %70
  store i32 %71, i32* %jj, align 4
  %72 = load i32* %j, align 4
  %73 = sext i32 %72 to i64
  %74 = load double** %y, align 8
  %75 = getelementptr inbounds double* %74, i64 %73
  %76 = load double* %75, align 8
  %77 = load i32* %jj, align 4
  %78 = sext i32 %77 to i64
  %79 = load i32* %ii, align 4
  %80 = sext i32 %79 to i64
  %81 = load double*** %2, align 8
  %82 = getelementptr inbounds double** %81, i64 %80
  %83 = load double** %82, align 8
  %84 = getelementptr inbounds double* %83, i64 %78
  %85 = load double* %84, align 8
  %86 = fdiv double %76, %85
  %87 = load i32* %j, align 4
  %88 = sext i32 %87 to i64
  %89 = load double** %y, align 8
  %90 = getelementptr inbounds double* %89, i64 %88
  store double %86, double* %90, align 8
  %91 = load i32* %j, align 4
  %92 = add nsw i32 %91, 1
  store i32 %92, i32* %i, align 4
  br label %93

; <label>:93                                      ; preds = %152, %53
  %94 = load i32* %i, align 4
  %95 = load i32* %1, align 4
  %96 = icmp slt i32 %94, %95
  br i1 %96, label %97, label %155

; <label>:97                                      ; preds = %93
  %98 = load i32* %1, align 4
  %99 = load i32* %i, align 4
  %100 = sub nsw i32 %98, %99
  %101 = load i32* %edge, align 4
  %102 = icmp sle i32 %100, %101
  br i1 %102, label %103, label %109

; <label>:103                                     ; preds = %97
  %104 = load i32* %edge, align 4
  store i32 %104, i32* %ibs, align 4
  %105 = load i32* %1, align 4
  %106 = load i32* %edge, align 4
  %107 = sub nsw i32 %105, %106
  store i32 %107, i32* %ibs, align 4
  %108 = load i32* %edge, align 4
  store i32 %108, i32* %skip, align 4
  br label %112

; <label>:109                                     ; preds = %97
  %110 = load i32* @block_size, align 4
  store i32 %110, i32* %ibs, align 4
  %111 = load i32* @block_size, align 4
  store i32 %111, i32* %skip, align 4
  br label %112

; <label>:112                                     ; preds = %109, %103
  %113 = load i32* %i, align 4
  %114 = load i32* @block_size, align 4
  %115 = sdiv i32 %113, %114
  %116 = load i32* %j, align 4
  %117 = load i32* @block_size, align 4
  %118 = sdiv i32 %116, %117
  %119 = load i32* @nblocks, align 4
  %120 = mul nsw i32 %118, %119
  %121 = add nsw i32 %115, %120
  store i32 %121, i32* %ii, align 4
  %122 = load i32* %i, align 4
  %123 = load i32* %ibs, align 4
  %124 = srem i32 %122, %123
  %125 = load i32* %j, align 4
  %126 = load i32* %jbs, align 4
  %127 = srem i32 %125, %126
  %128 = load i32* %skip, align 4
  %129 = mul nsw i32 %127, %128
  %130 = add nsw i32 %124, %129
  store i32 %130, i32* %jj, align 4
  %131 = load i32* %jj, align 4
  %132 = sext i32 %131 to i64
  %133 = load i32* %ii, align 4
  %134 = sext i32 %133 to i64
  %135 = load double*** %2, align 8
  %136 = getelementptr inbounds double** %135, i64 %134
  %137 = load double** %136, align 8
  %138 = getelementptr inbounds double* %137, i64 %132
  %139 = load double* %138, align 8
  %140 = load i32* %j, align 4
  %141 = sext i32 %140 to i64
  %142 = load double** %y, align 8
  %143 = getelementptr inbounds double* %142, i64 %141
  %144 = load double* %143, align 8
  %145 = fmul double %139, %144
  %146 = load i32* %i, align 4
  %147 = sext i32 %146 to i64
  %148 = load double** %y, align 8
  %149 = getelementptr inbounds double* %148, i64 %147
  %150 = load double* %149, align 8
  %151 = fsub double %150, %145
  store double %151, double* %149, align 8
  br label %152

; <label>:152                                     ; preds = %112
  %153 = load i32* %i, align 4
  %154 = add nsw i32 %153, 1
  store i32 %154, i32* %i, align 4
  br label %93

; <label>:155                                     ; preds = %93
  br label %156

; <label>:156                                     ; preds = %155
  %157 = load i32* %j, align 4
  %158 = add nsw i32 %157, 1
  store i32 %158, i32* %j, align 4
  br label %34

; <label>:159                                     ; preds = %34
  %160 = load i32* %1, align 4
  %161 = sub nsw i32 %160, 1
  store i32 %161, i32* %j, align 4
  br label %162

; <label>:162                                     ; preds = %242, %159
  %163 = load i32* %j, align 4
  %164 = icmp sge i32 %163, 0
  br i1 %164, label %165, label %245

; <label>:165                                     ; preds = %162
  store i32 0, i32* %i, align 4
  br label %166

; <label>:166                                     ; preds = %238, %165
  %167 = load i32* %i, align 4
  %168 = load i32* %j, align 4
  %169 = icmp slt i32 %167, %168
  br i1 %169, label %170, label %241

; <label>:170                                     ; preds = %166
  %171 = load i32* %1, align 4
  %172 = load i32* %i, align 4
  %173 = sub nsw i32 %171, %172
  %174 = load i32* %edge, align 4
  %175 = icmp sle i32 %173, %174
  br i1 %175, label %176, label %182

; <label>:176                                     ; preds = %170
  %177 = load i32* %edge, align 4
  store i32 %177, i32* %ibs, align 4
  %178 = load i32* %1, align 4
  %179 = load i32* %edge, align 4
  %180 = sub nsw i32 %178, %179
  store i32 %180, i32* %ibs, align 4
  %181 = load i32* %edge, align 4
  store i32 %181, i32* %skip, align 4
  br label %185

; <label>:182                                     ; preds = %170
  %183 = load i32* @block_size, align 4
  store i32 %183, i32* %ibs, align 4
  %184 = load i32* @block_size, align 4
  store i32 %184, i32* %skip, align 4
  br label %185

; <label>:185                                     ; preds = %182, %176
  %186 = load i32* %1, align 4
  %187 = load i32* %j, align 4
  %188 = sub nsw i32 %186, %187
  %189 = load i32* %edge, align 4
  %190 = icmp sle i32 %188, %189
  br i1 %190, label %191, label %196

; <label>:191                                     ; preds = %185
  %192 = load i32* %edge, align 4
  store i32 %192, i32* %jbs, align 4
  %193 = load i32* %1, align 4
  %194 = load i32* %edge, align 4
  %195 = sub nsw i32 %193, %194
  store i32 %195, i32* %jbs, align 4
  br label %198

; <label>:196                                     ; preds = %185
  %197 = load i32* @block_size, align 4
  store i32 %197, i32* %jbs, align 4
  br label %198

; <label>:198                                     ; preds = %196, %191
  %199 = load i32* %i, align 4
  %200 = load i32* @block_size, align 4
  %201 = sdiv i32 %199, %200
  %202 = load i32* %j, align 4
  %203 = load i32* @block_size, align 4
  %204 = sdiv i32 %202, %203
  %205 = load i32* @nblocks, align 4
  %206 = mul nsw i32 %204, %205
  %207 = add nsw i32 %201, %206
  store i32 %207, i32* %ii, align 4
  %208 = load i32* %i, align 4
  %209 = load i32* %ibs, align 4
  %210 = srem i32 %208, %209
  %211 = load i32* %j, align 4
  %212 = load i32* %jbs, align 4
  %213 = srem i32 %211, %212
  %214 = load i32* %skip, align 4
  %215 = mul nsw i32 %213, %214
  %216 = add nsw i32 %210, %215
  store i32 %216, i32* %jj, align 4
  %217 = load i32* %jj, align 4
  %218 = sext i32 %217 to i64
  %219 = load i32* %ii, align 4
  %220 = sext i32 %219 to i64
  %221 = load double*** %2, align 8
  %222 = getelementptr inbounds double** %221, i64 %220
  %223 = load double** %222, align 8
  %224 = getelementptr inbounds double* %223, i64 %218
  %225 = load double* %224, align 8
  %226 = load i32* %j, align 4
  %227 = sext i32 %226 to i64
  %228 = load double** %y, align 8
  %229 = getelementptr inbounds double* %228, i64 %227
  %230 = load double* %229, align 8
  %231 = fmul double %225, %230
  %232 = load i32* %i, align 4
  %233 = sext i32 %232 to i64
  %234 = load double** %y, align 8
  %235 = getelementptr inbounds double* %234, i64 %233
  %236 = load double* %235, align 8
  %237 = fsub double %236, %231
  store double %237, double* %235, align 8
  br label %238

; <label>:238                                     ; preds = %198
  %239 = load i32* %i, align 4
  %240 = add nsw i32 %239, 1
  store i32 %240, i32* %i, align 4
  br label %166

; <label>:241                                     ; preds = %166
  br label %242

; <label>:242                                     ; preds = %241
  %243 = load i32* %j, align 4
  %244 = add nsw i32 %243, -1
  store i32 %244, i32* %j, align 4
  br label %162

; <label>:245                                     ; preds = %162
  store double 0.000000e+00, double* %max_diff, align 8
  store i32 0, i32* %j, align 4
  br label %246

; <label>:246                                     ; preds = %263, %245
  %247 = load i32* %j, align 4
  %248 = load i32* %1, align 4
  %249 = icmp slt i32 %247, %248
  br i1 %249, label %250, label %266

; <label>:250                                     ; preds = %246
  %251 = load i32* %j, align 4
  %252 = sext i32 %251 to i64
  %253 = load double** %y, align 8
  %254 = getelementptr inbounds double* %253, i64 %252
  %255 = load double* %254, align 8
  %256 = fsub double %255, 1.000000e+00
  store double %256, double* %diff, align 8
  %257 = load double* %diff, align 8
  %258 = call double @fabs(double %257)
  %259 = fcmp ogt double %258, 1.000000e-05
  br i1 %259, label %260, label %262

; <label>:260                                     ; preds = %250
  store i32 1, i32* %bogus, align 4
  %261 = load double* %diff, align 8
  store double %261, double* %max_diff, align 8
  br label %262

; <label>:262                                     ; preds = %260, %250
  br label %263

; <label>:263                                     ; preds = %262
  %264 = load i32* %j, align 4
  %265 = add nsw i32 %264, 1
  store i32 %265, i32* %j, align 4
  br label %246

; <label>:266                                     ; preds = %246
  %267 = load i32* %bogus, align 4
  %268 = icmp ne i32 %267, 0
  br i1 %268, label %269, label %272

; <label>:269                                     ; preds = %266
  %270 = load double* %max_diff, align 8
  %271 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([26 x i8]* @.str.47, i32 0, i32 0), double %270)
  br label %274

; <label>:272                                     ; preds = %266
  %273 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([13 x i8]* @.str.48, i32 0, i32 0))
  br label %274

; <label>:274                                     ; preds = %272, %269
  %275 = load double** %y, align 8
  %276 = bitcast double* %275 to i8*
  call void @free(i8* %276)
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @atomic_cmpxchg(i32 %oldcount, i32 %newcount) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %temp = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  store i32 %oldcount, i32* %1, align 4
  store i32 %newcount, i32* %2, align 4
  %3 = load %struct.GlobalMemory** @Global, align 8
  %4 = getelementptr inbounds %struct.GlobalMemory* %3, i32 0, i32 10
  %5 = getelementptr inbounds %struct.barrier_t* %4, i32 0, i32 1
  %6 = load volatile i64* %5, align 8
  %7 = trunc i64 %6 to i32
  store i32 %7, i32* %temp, align 4
  %8 = load i32* %1, align 4
  %9 = load i32* %temp, align 4
  %10 = icmp eq i32 %8, %9
  br i1 %10, label %11, label %18

; <label>:11                                      ; preds = %0
  %12 = load i32* %2, align 4
  %13 = sext i32 %12 to i64
  %14 = load %struct.GlobalMemory** @Global, align 8
  %15 = getelementptr inbounds %struct.GlobalMemory* %14, i32 0, i32 10
  %16 = getelementptr inbounds %struct.barrier_t* %15, i32 0, i32 1
  call void @RecordSyncVariable()
  store volatile i64 %13, i64* %16, align 8
  call void @snapshot64(i64 %13, i32 0)
  %17 = load i32* %1, align 4
  store i32 %17, i32* %updatedcount, align 4
  br label %24

; <label>:18                                      ; preds = %0
  %19 = load %struct.GlobalMemory** @Global, align 8
  %20 = getelementptr inbounds %struct.GlobalMemory* %19, i32 0, i32 10
  %21 = getelementptr inbounds %struct.barrier_t* %20, i32 0, i32 1
  %22 = load volatile i64* %21, align 8
  %23 = trunc i64 %22 to i32
  store i32 %23, i32* %updatedcount, align 4
  br label %24

; <label>:24                                      ; preds = %18, %11
  %25 = load i32* %updatedcount, align 4
  ret i32 %25
}

; Function Attrs: nounwind uwtable
define internal void @SlaveStart() {
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cluster = alloca i32, align 4
  %max_block = alloca i32, align 4
  %MyNum = alloca i32, align 4
  %1 = load %struct.GlobalMemory** @Global, align 8
  %2 = getelementptr inbounds %struct.GlobalMemory* %1, i32 0, i32 11
  %3 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %2)
  %4 = load %struct.GlobalMemory** @Global, align 8
  %5 = getelementptr inbounds %struct.GlobalMemory* %4, i32 0, i32 9
  %6 = load i32* %5, align 4
  store i32 %6, i32* %MyNum, align 4
  %7 = load %struct.GlobalMemory** @Global, align 8
  %8 = getelementptr inbounds %struct.GlobalMemory* %7, i32 0, i32 9
  %9 = load i32* %8, align 4
  %10 = add nsw i32 %9, 1
  store i32 %10, i32* %8, align 4
  %11 = load %struct.GlobalMemory** @Global, align 8
  %12 = getelementptr inbounds %struct.GlobalMemory* %11, i32 0, i32 11
  %13 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %12)
  %14 = load i32* @n, align 4
  %15 = load i32* @block_size, align 4
  %16 = load double*** @a, align 8
  %17 = load i32* %MyNum, align 4
  %18 = load i32* @dostats, align 4
  call void @OneSolve(i32 %14, i32 %15, double** %16, i32 %17, i32 %18)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

; Function Attrs: nounwind uwtable
define internal void @OneSolve(i32 %n, i32 %block_size, double** %a, i32 %MyNum, i32 %dostats) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double**, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
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
  %lsense1 = alloca i32, align 4
  %oldcount2 = alloca i32, align 4
  %newcount3 = alloca i32, align 4
  %updatedcount4 = alloca i32, align 4
  %retVal5 = alloca i32, align 4
  %lsense6 = alloca i32, align 4
  %oldcount7 = alloca i32, align 4
  %newcount8 = alloca i32, align 4
  %updatedcount9 = alloca i32, align 4
  %retVal10 = alloca i32, align 4
  store i32 %n, i32* %1, align 4
  store i32 %block_size, i32* %2, align 4
  store double** %a, double*** %3, align 8
  store i32 %MyNum, i32* %4, align 4
  store i32 %dostats, i32* %5, align 4
  %6 = call noalias i8* @malloc(i64 32)
  %7 = bitcast i8* %6 to %struct.LocalCopies*
  store %struct.LocalCopies* %7, %struct.LocalCopies** %lc, align 8
  %8 = load %struct.LocalCopies** %lc, align 8
  %9 = icmp eq %struct.LocalCopies* %8, null
  br i1 %9, label %10, label %14

; <label>:10                                      ; preds = %0
  %11 = load %struct._IO_FILE** @stderr, align 8
  %12 = load i32* %4, align 4
  %13 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([40 x i8]* @.str.44, i32 0, i32 0), i32 %12)
  call void @exit(i32 -1)
  unreachable

; <label>:14                                      ; preds = %0
  %15 = load %struct.LocalCopies** %lc, align 8
  %16 = getelementptr inbounds %struct.LocalCopies* %15, i32 0, i32 0
  store double 0.000000e+00, double* %16, align 8
  %17 = load %struct.LocalCopies** %lc, align 8
  %18 = getelementptr inbounds %struct.LocalCopies* %17, i32 0, i32 1
  store double 0.000000e+00, double* %18, align 8
  %19 = load %struct.LocalCopies** %lc, align 8
  %20 = getelementptr inbounds %struct.LocalCopies* %19, i32 0, i32 2
  store double 0.000000e+00, double* %20, align 8
  %21 = load %struct.LocalCopies** %lc, align 8
  %22 = getelementptr inbounds %struct.LocalCopies* %21, i32 0, i32 3
  store double 0.000000e+00, double* %22, align 8
  %23 = load %struct.GlobalMemory** @Global, align 8
  %24 = getelementptr inbounds %struct.GlobalMemory* %23, i32 0, i32 10
  %25 = getelementptr inbounds %struct.barrier_t* %24, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 1)
  call void @IncrementCounter()
  call void @printChar(i8 signext 49)
  call void @printChar(i8 signext 90)
  %26 = load volatile i32* %25, align 4
  store i32 %26, i32* %lsense, align 4
  br label %27

; <label>:27                                      ; preds = %62, %14
  %28 = load %struct.GlobalMemory** @Global, align 8
  %29 = getelementptr inbounds %struct.GlobalMemory* %28, i32 0, i32 10
  %30 = getelementptr inbounds %struct.barrier_t* %29, i32 0, i32 1
  %31 = load volatile i64* %30, align 8
  %call = call i32 @sleep(i32 1)
  %32 = trunc i64 %31 to i32
  store i32 %32, i32* %oldcount, align 4
  %33 = load i32* %oldcount, align 4
  %34 = load i32* %lsense, align 4
  %35 = add nsw i32 %33, %34
  store i32 %35, i32* %newcount, align 4
  %36 = load i32* %oldcount, align 4
  %37 = load i32* %newcount, align 4
  %38 = call i32 @atomic_cmpxchg(i32 %36, i32 %37)
  %call5 = call i32 @sleep(i32 1)
  store i32 %38, i32* %updatedcount, align 4
  %39 = load i32* %updatedcount, align 4
  %40 = load i32* %oldcount, align 4
  %41 = icmp eq i32 %39, %40
  br i1 %41, label %42, label %62

; <label>:42                                      ; preds = %27
  %43 = load i32* %newcount, align 4
  %44 = load i32* @P, align 4
  %call1 = call i32 @sleep(i32 1)
  %45 = icmp eq i32 %43, %44
  br i1 %45, label %46, label %49

; <label>:46                                      ; preds = %42
  %47 = load i32* %lsense, align 4
  %48 = icmp eq i32 %47, 1
  br i1 %48, label %55, label %49

; <label>:49                                      ; preds = %46, %42
  %50 = load i32* %newcount, align 4
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %52, label %61

; <label>:52                                      ; preds = %49
  %53 = load i32* %lsense, align 4
  %54 = icmp eq i32 %53, -1
  br i1 %54, label %55, label %61

; <label>:55                                      ; preds = %52, %46
  %56 = load i32* %lsense, align 4
  %57 = sub nsw i32 0, %56
  %58 = load %struct.GlobalMemory** @Global, align 8
  %59 = getelementptr inbounds %struct.GlobalMemory* %58, i32 0, i32 10
  %60 = getelementptr inbounds %struct.barrier_t* %59, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %57, i32* %60, align 4
  call void @snapshot(i32 %57, i32 1)
  %call2 = call i32 @sleep(i32 3)
  br label %61

; <label>:61                                      ; preds = %55, %52, %49
  br label %63

; <label>:62                                      ; preds = %27
  br label %27

; <label>:63                                      ; preds = %61
  br label %64

; <label>:64                                      ; preds = %71, %63
  %65 = load %struct.GlobalMemory** @Global, align 8
  %66 = getelementptr inbounds %struct.GlobalMemory* %65, i32 0, i32 10
  %67 = getelementptr inbounds %struct.barrier_t* %66, i32 0, i32 0
  %68 = load volatile i32* %67, align 4
  %69 = load i32* %lsense, align 4
  %70 = icmp eq i32 %68, %69
  br i1 %70, label %71, label %72

; <label>:71                                      ; preds = %64
  %call3 = call i32 @sleep(i32 2)
  br label %64

; <label>:72                                      ; preds = %64
  call void @printY()
  %call4 = call i32 @sleep(i32 4)
  %73 = load i32* %2, align 4
  %74 = load i32* %4, align 4
  %75 = call double @TouchA(i32 %73, i32 %74)
  %76 = load %struct.GlobalMemory** @Global, align 8
  %77 = getelementptr inbounds %struct.GlobalMemory* %76, i32 0, i32 10
  %78 = getelementptr inbounds %struct.barrier_t* %77, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 2)
  call void @IncrementCounter()
  call void @printChar(i8 signext 50)
  call void @printChar(i8 signext 90)
  %79 = load volatile i32* %78, align 4
  store i32 %79, i32* %lsense1, align 4
  br label %80

; <label>:80                                      ; preds = %115, %72
  %81 = load %struct.GlobalMemory** @Global, align 8
  %82 = getelementptr inbounds %struct.GlobalMemory* %81, i32 0, i32 10
  %83 = getelementptr inbounds %struct.barrier_t* %82, i32 0, i32 1
  %84 = load volatile i64* %83, align 8
  %call6 = call i32 @sleep(i32 1)
  %85 = trunc i64 %84 to i32
  store i32 %85, i32* %oldcount2, align 4
  %86 = load i32* %oldcount2, align 4
  %87 = load i32* %lsense1, align 4
  %88 = add nsw i32 %86, %87
  store i32 %88, i32* %newcount3, align 4
  %89 = load i32* %oldcount2, align 4
  %90 = load i32* %newcount3, align 4
  %91 = call i32 @atomic_cmpxchg(i32 %89, i32 %90)
  %call11 = call i32 @sleep(i32 1)
  store i32 %91, i32* %updatedcount4, align 4
  %92 = load i32* %updatedcount4, align 4
  %93 = load i32* %oldcount2, align 4
  %94 = icmp eq i32 %92, %93
  br i1 %94, label %95, label %115

; <label>:95                                      ; preds = %80
  %96 = load i32* %newcount3, align 4
  %97 = load i32* @P, align 4
  %call7 = call i32 @sleep(i32 1)
  %98 = icmp eq i32 %96, %97
  br i1 %98, label %99, label %102

; <label>:99                                      ; preds = %95
  %100 = load i32* %lsense1, align 4
  %101 = icmp eq i32 %100, 1
  br i1 %101, label %108, label %102

; <label>:102                                     ; preds = %99, %95
  %103 = load i32* %newcount3, align 4
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %105, label %114

; <label>:105                                     ; preds = %102
  %106 = load i32* %lsense1, align 4
  %107 = icmp eq i32 %106, -1
  br i1 %107, label %108, label %114

; <label>:108                                     ; preds = %105, %99
  %109 = load i32* %lsense1, align 4
  %110 = sub nsw i32 0, %109
  %111 = load %struct.GlobalMemory** @Global, align 8
  %112 = getelementptr inbounds %struct.GlobalMemory* %111, i32 0, i32 10
  %113 = getelementptr inbounds %struct.barrier_t* %112, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %110, i32* %113, align 4
  call void @snapshot(i32 %110, i32 1)
  %call8 = call i32 @sleep(i32 3)
  br label %114

; <label>:114                                     ; preds = %108, %105, %102
  br label %116

; <label>:115                                     ; preds = %80
  br label %80

; <label>:116                                     ; preds = %114
  br label %117

; <label>:117                                     ; preds = %124, %116
  %118 = load %struct.GlobalMemory** @Global, align 8
  %119 = getelementptr inbounds %struct.GlobalMemory* %118, i32 0, i32 10
  %120 = getelementptr inbounds %struct.barrier_t* %119, i32 0, i32 0
  %121 = load volatile i32* %120, align 4
  %122 = load i32* %lsense1, align 4
  %123 = icmp eq i32 %121, %122
  br i1 %123, label %124, label %125

; <label>:124                                     ; preds = %117
  %call9 = call i32 @sleep(i32 2)
  br label %117

; <label>:125                                     ; preds = %117
  call void @printY()
  %call10 = call i32 @sleep(i32 4)
  %126 = load i32* %4, align 4
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %131, label %128

; <label>:128                                     ; preds = %125
  %129 = load i32* %5, align 4
  %130 = icmp ne i32 %129, 0
  br i1 %130, label %131, label %134

; <label>:131                                     ; preds = %128, %125
  %132 = call i64 @time(i64* null)
  %133 = trunc i64 %132 to i32
  store i32 %133, i32* %myrs, align 4
  br label %134

; <label>:134                                     ; preds = %131, %128
  %135 = load i32* %1, align 4
  %136 = load i32* %2, align 4
  %137 = load i32* %4, align 4
  %138 = load %struct.LocalCopies** %lc, align 8
  %139 = load i32* %5, align 4
  call void @lu(i32 %135, i32 %136, i32 %137, %struct.LocalCopies* %138, i32 %139)
  %140 = load i32* %4, align 4
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %145, label %142

; <label>:142                                     ; preds = %134
  %143 = load i32* %5, align 4
  %144 = icmp ne i32 %143, 0
  br i1 %144, label %145, label %148

; <label>:145                                     ; preds = %142, %134
  %146 = call i64 @time(i64* null)
  %147 = trunc i64 %146 to i32
  store i32 %147, i32* %mydone, align 4
  br label %148

; <label>:148                                     ; preds = %145, %142
  %149 = load %struct.GlobalMemory** @Global, align 8
  %150 = getelementptr inbounds %struct.GlobalMemory* %149, i32 0, i32 10
  %151 = getelementptr inbounds %struct.barrier_t* %150, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 3)
  call void @IncrementCounter()
  call void @printChar(i8 signext 51)
  call void @printChar(i8 signext 90)
  %152 = load volatile i32* %151, align 4
  store i32 %152, i32* %lsense6, align 4
  br label %153

; <label>:153                                     ; preds = %188, %148
  %154 = load %struct.GlobalMemory** @Global, align 8
  %155 = getelementptr inbounds %struct.GlobalMemory* %154, i32 0, i32 10
  %156 = getelementptr inbounds %struct.barrier_t* %155, i32 0, i32 1
  %157 = load volatile i64* %156, align 8
  %call12 = call i32 @sleep(i32 1)
  %158 = trunc i64 %157 to i32
  store i32 %158, i32* %oldcount7, align 4
  %159 = load i32* %oldcount7, align 4
  %160 = load i32* %lsense6, align 4
  %161 = add nsw i32 %159, %160
  store i32 %161, i32* %newcount8, align 4
  %162 = load i32* %oldcount7, align 4
  %163 = load i32* %newcount8, align 4
  %164 = call i32 @atomic_cmpxchg(i32 %162, i32 %163)
  %call17 = call i32 @sleep(i32 1)
  store i32 %164, i32* %updatedcount9, align 4
  %165 = load i32* %updatedcount9, align 4
  %166 = load i32* %oldcount7, align 4
  %167 = icmp eq i32 %165, %166
  br i1 %167, label %168, label %188

; <label>:168                                     ; preds = %153
  %169 = load i32* %newcount8, align 4
  %170 = load i32* @P, align 4
  %call13 = call i32 @sleep(i32 1)
  %171 = icmp eq i32 %169, %170
  br i1 %171, label %172, label %175

; <label>:172                                     ; preds = %168
  %173 = load i32* %lsense6, align 4
  %174 = icmp eq i32 %173, 1
  br i1 %174, label %181, label %175

; <label>:175                                     ; preds = %172, %168
  %176 = load i32* %newcount8, align 4
  %177 = icmp eq i32 %176, 0
  br i1 %177, label %178, label %187

; <label>:178                                     ; preds = %175
  %179 = load i32* %lsense6, align 4
  %180 = icmp eq i32 %179, -1
  br i1 %180, label %181, label %187

; <label>:181                                     ; preds = %178, %172
  %182 = load i32* %lsense6, align 4
  %183 = sub nsw i32 0, %182
  %184 = load %struct.GlobalMemory** @Global, align 8
  %185 = getelementptr inbounds %struct.GlobalMemory* %184, i32 0, i32 10
  %186 = getelementptr inbounds %struct.barrier_t* %185, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %183, i32* %186, align 4
  call void @snapshot(i32 %183, i32 1)
  %call14 = call i32 @sleep(i32 3)
  br label %187

; <label>:187                                     ; preds = %181, %178, %175
  br label %189

; <label>:188                                     ; preds = %153
  br label %153

; <label>:189                                     ; preds = %187
  br label %190

; <label>:190                                     ; preds = %197, %189
  %191 = load %struct.GlobalMemory** @Global, align 8
  %192 = getelementptr inbounds %struct.GlobalMemory* %191, i32 0, i32 10
  %193 = getelementptr inbounds %struct.barrier_t* %192, i32 0, i32 0
  %194 = load volatile i32* %193, align 4
  %195 = load i32* %lsense6, align 4
  %196 = icmp eq i32 %194, %195
  br i1 %196, label %197, label %198

; <label>:197                                     ; preds = %190
  %call15 = call i32 @sleep(i32 2)
  br label %190

; <label>:198                                     ; preds = %190
  call void @printY()
  %call16 = call i32 @sleep(i32 4)
  %199 = load i32* %4, align 4
  %200 = icmp eq i32 %199, 0
  br i1 %200, label %204, label %201

; <label>:201                                     ; preds = %198
  %202 = load i32* %5, align 4
  %203 = icmp ne i32 %202, 0
  br i1 %203, label %204, label %251

; <label>:204                                     ; preds = %201, %198
  %205 = load %struct.LocalCopies** %lc, align 8
  %206 = getelementptr inbounds %struct.LocalCopies* %205, i32 0, i32 0
  %207 = load double* %206, align 8
  %208 = load i32* %4, align 4
  %209 = sext i32 %208 to i64
  %210 = load %struct.GlobalMemory** @Global, align 8
  %211 = getelementptr inbounds %struct.GlobalMemory* %210, i32 0, i32 0
  %212 = load double** %211, align 8
  %213 = getelementptr inbounds double* %212, i64 %209
  store double %207, double* %213, align 8
  %214 = load %struct.LocalCopies** %lc, align 8
  %215 = getelementptr inbounds %struct.LocalCopies* %214, i32 0, i32 1
  %216 = load double* %215, align 8
  %217 = load i32* %4, align 4
  %218 = sext i32 %217 to i64
  %219 = load %struct.GlobalMemory** @Global, align 8
  %220 = getelementptr inbounds %struct.GlobalMemory* %219, i32 0, i32 1
  %221 = load double** %220, align 8
  %222 = getelementptr inbounds double* %221, i64 %218
  store double %216, double* %222, align 8
  %223 = load %struct.LocalCopies** %lc, align 8
  %224 = getelementptr inbounds %struct.LocalCopies* %223, i32 0, i32 2
  %225 = load double* %224, align 8
  %226 = load i32* %4, align 4
  %227 = sext i32 %226 to i64
  %228 = load %struct.GlobalMemory** @Global, align 8
  %229 = getelementptr inbounds %struct.GlobalMemory* %228, i32 0, i32 2
  %230 = load double** %229, align 8
  %231 = getelementptr inbounds double* %230, i64 %227
  store double %225, double* %231, align 8
  %232 = load %struct.LocalCopies** %lc, align 8
  %233 = getelementptr inbounds %struct.LocalCopies* %232, i32 0, i32 3
  %234 = load double* %233, align 8
  %235 = load i32* %4, align 4
  %236 = sext i32 %235 to i64
  %237 = load %struct.GlobalMemory** @Global, align 8
  %238 = getelementptr inbounds %struct.GlobalMemory* %237, i32 0, i32 3
  %239 = load double** %238, align 8
  %240 = getelementptr inbounds double* %239, i64 %236
  store double %234, double* %240, align 8
  %241 = load i32* %mydone, align 4
  %242 = load i32* %myrs, align 4
  %243 = sub i32 %241, %242
  %244 = uitofp i32 %243 to double
  %245 = load i32* %4, align 4
  %246 = sext i32 %245 to i64
  %247 = load %struct.GlobalMemory** @Global, align 8
  %248 = getelementptr inbounds %struct.GlobalMemory* %247, i32 0, i32 4
  %249 = load double** %248, align 8
  %250 = getelementptr inbounds double* %249, i64 %246
  store double %244, double* %250, align 8
  br label %251

; <label>:251                                     ; preds = %204, %201
  %252 = load i32* %4, align 4
  %253 = icmp eq i32 %252, 0
  br i1 %253, label %254, label %266

; <label>:254                                     ; preds = %251
  %255 = call i64 @time(i64* null)
  %256 = trunc i64 %255 to i32
  store i32 %256, i32* %myrf, align 4
  %257 = load i32* %myrs, align 4
  %258 = load %struct.GlobalMemory** @Global, align 8
  %259 = getelementptr inbounds %struct.GlobalMemory* %258, i32 0, i32 7
  store i32 %257, i32* %259, align 4
  %260 = load i32* %mydone, align 4
  %261 = load %struct.GlobalMemory** @Global, align 8
  %262 = getelementptr inbounds %struct.GlobalMemory* %261, i32 0, i32 8
  store i32 %260, i32* %262, align 4
  %263 = load i32* %myrf, align 4
  %264 = load %struct.GlobalMemory** @Global, align 8
  %265 = getelementptr inbounds %struct.GlobalMemory* %264, i32 0, i32 6
  store i32 %263, i32* %265, align 4
  br label %266

; <label>:266                                     ; preds = %254, %251
  ret void
}

declare void @Criteria(i32)

; Function Attrs: nounwind uwtable
define internal double @TouchA(i32 %bs, i32 %MyNum) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %I = alloca i32, align 4
  %J = alloca i32, align 4
  %tot = alloca double, align 8
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  store i32 %bs, i32* %1, align 4
  store i32 %MyNum, i32* %2, align 4
  store double 0.000000e+00, double* %tot, align 8
  store i32 0, i32* %J, align 4
  br label %3

; <label>:3                                       ; preds = %93, %0
  %4 = load i32* %J, align 4
  %5 = load i32* @nblocks, align 4
  %6 = icmp slt i32 %4, %5
  br i1 %6, label %7, label %96

; <label>:7                                       ; preds = %3
  store i32 0, i32* %I, align 4
  br label %8

; <label>:8                                       ; preds = %89, %7
  %9 = load i32* %I, align 4
  %10 = load i32* @nblocks, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %92

; <label>:12                                      ; preds = %8
  %13 = load i32* %I, align 4
  %14 = load i32* %J, align 4
  %15 = call i32 @BlockOwner(i32 %13, i32 %14)
  %16 = load i32* %2, align 4
  %17 = icmp eq i32 %15, %16
  br i1 %17, label %18, label %88

; <label>:18                                      ; preds = %12
  %19 = load i32* %J, align 4
  %20 = load i32* @nblocks, align 4
  %21 = sub nsw i32 %20, 1
  %22 = icmp eq i32 %19, %21
  br i1 %22, label %23, label %32

; <label>:23                                      ; preds = %18
  %24 = load i32* @n, align 4
  %25 = load i32* %1, align 4
  %26 = srem i32 %24, %25
  store i32 %26, i32* %jbs, align 4
  %27 = load i32* %jbs, align 4
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %31

; <label>:29                                      ; preds = %23
  %30 = load i32* %1, align 4
  store i32 %30, i32* %jbs, align 4
  br label %31

; <label>:31                                      ; preds = %29, %23
  br label %34

; <label>:32                                      ; preds = %18
  %33 = load i32* %1, align 4
  store i32 %33, i32* %jbs, align 4
  br label %34

; <label>:34                                      ; preds = %32, %31
  %35 = load i32* %I, align 4
  %36 = load i32* @nblocks, align 4
  %37 = sub nsw i32 %36, 1
  %38 = icmp eq i32 %35, %37
  br i1 %38, label %39, label %48

; <label>:39                                      ; preds = %34
  %40 = load i32* @n, align 4
  %41 = load i32* %1, align 4
  %42 = srem i32 %40, %41
  store i32 %42, i32* %ibs, align 4
  %43 = load i32* %ibs, align 4
  %44 = icmp eq i32 %43, 0
  br i1 %44, label %45, label %47

; <label>:45                                      ; preds = %39
  %46 = load i32* %1, align 4
  store i32 %46, i32* %ibs, align 4
  br label %47

; <label>:47                                      ; preds = %45, %39
  br label %50

; <label>:48                                      ; preds = %34
  %49 = load i32* %1, align 4
  store i32 %49, i32* %ibs, align 4
  br label %50

; <label>:50                                      ; preds = %48, %47
  store i32 0, i32* %j, align 4
  br label %51

; <label>:51                                      ; preds = %84, %50
  %52 = load i32* %j, align 4
  %53 = load i32* %jbs, align 4
  %54 = icmp slt i32 %52, %53
  br i1 %54, label %55, label %87

; <label>:55                                      ; preds = %51
  store i32 0, i32* %i, align 4
  br label %56

; <label>:56                                      ; preds = %80, %55
  %57 = load i32* %i, align 4
  %58 = load i32* %ibs, align 4
  %59 = icmp slt i32 %57, %58
  br i1 %59, label %60, label %83

; <label>:60                                      ; preds = %56
  %61 = load i32* %i, align 4
  %62 = load i32* %j, align 4
  %63 = load i32* %ibs, align 4
  %64 = mul nsw i32 %62, %63
  %65 = add nsw i32 %61, %64
  %66 = sext i32 %65 to i64
  %67 = load i32* %I, align 4
  %68 = load i32* %J, align 4
  %69 = load i32* @nblocks, align 4
  %70 = mul nsw i32 %68, %69
  %71 = add nsw i32 %67, %70
  %72 = sext i32 %71 to i64
  %73 = load double*** @a, align 8
  %74 = getelementptr inbounds double** %73, i64 %72
  %75 = load double** %74, align 8
  %76 = getelementptr inbounds double* %75, i64 %66
  %77 = load double* %76, align 8
  %78 = load double* %tot, align 8
  %79 = fadd double %78, %77
  store double %79, double* %tot, align 8
  br label %80

; <label>:80                                      ; preds = %60
  %81 = load i32* %i, align 4
  %82 = add nsw i32 %81, 1
  store i32 %82, i32* %i, align 4
  br label %56

; <label>:83                                      ; preds = %56
  br label %84

; <label>:84                                      ; preds = %83
  %85 = load i32* %j, align 4
  %86 = add nsw i32 %85, 1
  store i32 %86, i32* %j, align 4
  br label %51

; <label>:87                                      ; preds = %51
  br label %88

; <label>:88                                      ; preds = %87, %12
  br label %89

; <label>:89                                      ; preds = %88
  %90 = load i32* %I, align 4
  %91 = add nsw i32 %90, 1
  store i32 %91, i32* %I, align 4
  br label %8

; <label>:92                                      ; preds = %8
  br label %93

; <label>:93                                      ; preds = %92
  %94 = load i32* %J, align 4
  %95 = add nsw i32 %94, 1
  store i32 %95, i32* %J, align 4
  br label %3

; <label>:96                                      ; preds = %3
  %97 = load double* %tot, align 8
  ret double %97
}

; Function Attrs: nounwind uwtable
define internal void @lu(i32 %n, i32 %bs, i32 %MyNum, %struct.LocalCopies* %lc, i32 %dostats) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca %struct.LocalCopies*, align 8
  %5 = alloca i32, align 4
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
  %lsense1 = alloca i32, align 4
  %oldcount2 = alloca i32, align 4
  %newcount3 = alloca i32, align 4
  %updatedcount4 = alloca i32, align 4
  %retVal5 = alloca i32, align 4
  store i32 %n, i32* %1, align 4
  store i32 %bs, i32* %2, align 4
  store i32 %MyNum, i32* %3, align 4
  store %struct.LocalCopies* %lc, %struct.LocalCopies** %4, align 8
  store i32 %dostats, i32* %5, align 4
  store i32 0, i32* %k, align 4
  store i32 0, i32* %K, align 4
  br label %6

; <label>:6                                       ; preds = %450, %0
  %7 = load i32* %k, align 4
  %8 = load i32* %1, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %456

; <label>:10                                      ; preds = %6
  %11 = load i32* %k, align 4
  %12 = load i32* %2, align 4
  %13 = add nsw i32 %11, %12
  store i32 %13, i32* %kl, align 4
  %14 = load i32* %kl, align 4
  %15 = load i32* %1, align 4
  %16 = icmp sgt i32 %14, %15
  br i1 %16, label %17, label %22

; <label>:17                                      ; preds = %10
  %18 = load i32* %1, align 4
  store i32 %18, i32* %kl, align 4
  %19 = load i32* %kl, align 4
  %20 = load i32* %k, align 4
  %21 = sub nsw i32 %19, %20
  store i32 %21, i32* %strK, align 4
  br label %24

; <label>:22                                      ; preds = %10
  %23 = load i32* %2, align 4
  store i32 %23, i32* %strK, align 4
  br label %24

; <label>:24                                      ; preds = %22, %17
  %25 = load i32* %3, align 4
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %30, label %27

; <label>:27                                      ; preds = %24
  %28 = load i32* %5, align 4
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %30, label %33

; <label>:30                                      ; preds = %27, %24
  %31 = call i64 @time(i64* null)
  %32 = trunc i64 %31 to i32
  store i32 %32, i32* %t1, align 4
  br label %33

; <label>:33                                      ; preds = %30, %27
  %34 = load i32* %K, align 4
  %35 = load i32* %K, align 4
  %36 = call i32 @BlockOwner(i32 %34, i32 %35)
  store i32 %36, i32* %diagowner, align 4
  %37 = load i32* %diagowner, align 4
  %38 = load i32* %3, align 4
  %39 = icmp eq i32 %37, %38
  br i1 %39, label %40, label %53

; <label>:40                                      ; preds = %33
  %41 = load i32* %K, align 4
  %42 = load i32* %K, align 4
  %43 = load i32* @nblocks, align 4
  %44 = mul nsw i32 %42, %43
  %45 = add nsw i32 %41, %44
  %46 = sext i32 %45 to i64
  %47 = load double*** @a, align 8
  %48 = getelementptr inbounds double** %47, i64 %46
  %49 = load double** %48, align 8
  store double* %49, double** %A, align 8
  %50 = load double** %A, align 8
  %51 = load i32* %strK, align 4
  %52 = load i32* %strK, align 4
  call void @lu0(double* %50, i32 %51, i32 %52)
  br label %53

; <label>:53                                      ; preds = %40, %33
  %54 = load i32* %3, align 4
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %59, label %56

; <label>:56                                      ; preds = %53
  %57 = load i32* %5, align 4
  %58 = icmp ne i32 %57, 0
  br i1 %58, label %59, label %62

; <label>:59                                      ; preds = %56, %53
  %60 = call i64 @time(i64* null)
  %61 = trunc i64 %60 to i32
  store i32 %61, i32* %t11, align 4
  br label %62

; <label>:62                                      ; preds = %59, %56
  %63 = load %struct.GlobalMemory** @Global, align 8
  %64 = getelementptr inbounds %struct.GlobalMemory* %63, i32 0, i32 10
  %65 = getelementptr inbounds %struct.barrier_t* %64, i32 0, i32 0
  call void @loopCurrent(i32 0)
  call void @InitializeSwitchesAndCounter(i32 4)
  call void @IncrementCounter()
  call void @printChar(i8 signext 52)
  call void @printChar(i8 signext 90)
  %66 = load volatile i32* %65, align 4
  store i32 %66, i32* %lsense, align 4
  br label %67

; <label>:67                                      ; preds = %102, %62
  %68 = load %struct.GlobalMemory** @Global, align 8
  %69 = getelementptr inbounds %struct.GlobalMemory* %68, i32 0, i32 10
  %70 = getelementptr inbounds %struct.barrier_t* %69, i32 0, i32 1
  %71 = load volatile i64* %70, align 8
  %call = call i32 @sleep(i32 1)
  %72 = trunc i64 %71 to i32
  store i32 %72, i32* %oldcount, align 4
  %73 = load i32* %oldcount, align 4
  %74 = load i32* %lsense, align 4
  %75 = add nsw i32 %73, %74
  store i32 %75, i32* %newcount, align 4
  %76 = load i32* %oldcount, align 4
  %77 = load i32* %newcount, align 4
  %78 = call i32 @atomic_cmpxchg(i32 %76, i32 %77)
  %call5 = call i32 @sleep(i32 1)
  store i32 %78, i32* %updatedcount, align 4
  %79 = load i32* %updatedcount, align 4
  %80 = load i32* %oldcount, align 4
  %81 = icmp eq i32 %79, %80
  br i1 %81, label %82, label %102

; <label>:82                                      ; preds = %67
  %83 = load i32* %newcount, align 4
  %84 = load i32* @P, align 4
  %call1 = call i32 @sleep(i32 1)
  %85 = icmp eq i32 %83, %84
  br i1 %85, label %86, label %89

; <label>:86                                      ; preds = %82
  %87 = load i32* %lsense, align 4
  %88 = icmp eq i32 %87, 1
  br i1 %88, label %95, label %89

; <label>:89                                      ; preds = %86, %82
  %90 = load i32* %newcount, align 4
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %92, label %101

; <label>:92                                      ; preds = %89
  %93 = load i32* %lsense, align 4
  %94 = icmp eq i32 %93, -1
  br i1 %94, label %95, label %101

; <label>:95                                      ; preds = %92, %86
  %96 = load i32* %lsense, align 4
  %97 = sub nsw i32 0, %96
  %98 = load %struct.GlobalMemory** @Global, align 8
  %99 = getelementptr inbounds %struct.GlobalMemory* %98, i32 0, i32 10
  %100 = getelementptr inbounds %struct.barrier_t* %99, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %97, i32* %100, align 4
  call void @snapshot(i32 %97, i32 1)
  %call2 = call i32 @sleep(i32 3)
  br label %101

; <label>:101                                     ; preds = %95, %92, %89
  br label %103

; <label>:102                                     ; preds = %67
  br label %67

; <label>:103                                     ; preds = %101
  br label %104

; <label>:104                                     ; preds = %111, %103
  %105 = load %struct.GlobalMemory** @Global, align 8
  %106 = getelementptr inbounds %struct.GlobalMemory* %105, i32 0, i32 10
  %107 = getelementptr inbounds %struct.barrier_t* %106, i32 0, i32 0
  %108 = load volatile i32* %107, align 4
  %109 = load i32* %lsense, align 4
  %110 = icmp eq i32 %108, %109
  br i1 %110, label %111, label %112

; <label>:111                                     ; preds = %104
  %call3 = call i32 @sleep(i32 2)
  br label %104

; <label>:112                                     ; preds = %104
  call void @printY()
  %call4 = call i32 @sleep(i32 4)
  %113 = load i32* %3, align 4
  %114 = icmp eq i32 %113, 0
  br i1 %114, label %118, label %115

; <label>:115                                     ; preds = %112
  %116 = load i32* %5, align 4
  %117 = icmp ne i32 %116, 0
  br i1 %117, label %118, label %121

; <label>:118                                     ; preds = %115, %112
  %119 = call i64 @time(i64* null)
  %120 = trunc i64 %119 to i32
  store i32 %120, i32* %t2, align 4
  br label %121

; <label>:121                                     ; preds = %118, %115
  %122 = load i32* %K, align 4
  %123 = load i32* %K, align 4
  %124 = load i32* @nblocks, align 4
  %125 = mul nsw i32 %123, %124
  %126 = add nsw i32 %122, %125
  %127 = sext i32 %126 to i64
  %128 = load double*** @a, align 8
  %129 = getelementptr inbounds double** %128, i64 %127
  %130 = load double** %129, align 8
  store double* %130, double** %D, align 8
  %131 = load i32* %kl, align 4
  store i32 %131, i32* %i, align 4
  %132 = load i32* %K, align 4
  %133 = add nsw i32 %132, 1
  store i32 %133, i32* %I, align 4
  br label %134

; <label>:134                                     ; preds = %175, %121
  %135 = load i32* %i, align 4
  %136 = load i32* %1, align 4
  %137 = icmp slt i32 %135, %136
  br i1 %137, label %138, label %181

; <label>:138                                     ; preds = %134
  %139 = load i32* %I, align 4
  %140 = load i32* %K, align 4
  %141 = call i32 @BlockOwner(i32 %139, i32 %140)
  %142 = load i32* %3, align 4
  %143 = icmp eq i32 %141, %142
  br i1 %143, label %144, label %174

; <label>:144                                     ; preds = %138
  %145 = load i32* %i, align 4
  %146 = load i32* %2, align 4
  %147 = add nsw i32 %145, %146
  store i32 %147, i32* %il, align 4
  %148 = load i32* %il, align 4
  %149 = load i32* %1, align 4
  %150 = icmp sgt i32 %148, %149
  br i1 %150, label %151, label %156

; <label>:151                                     ; preds = %144
  %152 = load i32* %1, align 4
  store i32 %152, i32* %il, align 4
  %153 = load i32* %il, align 4
  %154 = load i32* %i, align 4
  %155 = sub nsw i32 %153, %154
  store i32 %155, i32* %strI, align 4
  br label %158

; <label>:156                                     ; preds = %144
  %157 = load i32* %2, align 4
  store i32 %157, i32* %strI, align 4
  br label %158

; <label>:158                                     ; preds = %156, %151
  %159 = load i32* %I, align 4
  %160 = load i32* %K, align 4
  %161 = load i32* @nblocks, align 4
  %162 = mul nsw i32 %160, %161
  %163 = add nsw i32 %159, %162
  %164 = sext i32 %163 to i64
  %165 = load double*** @a, align 8
  %166 = getelementptr inbounds double** %165, i64 %164
  %167 = load double** %166, align 8
  store double* %167, double** %A, align 8
  %168 = load double** %A, align 8
  %169 = load double** %D, align 8
  %170 = load i32* %strI, align 4
  %171 = load i32* %strK, align 4
  %172 = load i32* %strI, align 4
  %173 = load i32* %strK, align 4
  call void @bdiv(double* %168, double* %169, i32 %170, i32 %171, i32 %172, i32 %173)
  br label %174

; <label>:174                                     ; preds = %158, %138
  br label %175

; <label>:175                                     ; preds = %174
  %176 = load i32* %2, align 4
  %177 = load i32* %i, align 4
  %178 = add nsw i32 %177, %176
  store i32 %178, i32* %i, align 4
  %179 = load i32* %I, align 4
  %180 = add nsw i32 %179, 1
  store i32 %180, i32* %I, align 4
  br label %134

; <label>:181                                     ; preds = %134
  %182 = load i32* %kl, align 4
  store i32 %182, i32* %j, align 4
  %183 = load i32* %K, align 4
  %184 = add nsw i32 %183, 1
  store i32 %184, i32* %J, align 4
  br label %185

; <label>:185                                     ; preds = %226, %181
  %186 = load i32* %j, align 4
  %187 = load i32* %1, align 4
  %188 = icmp slt i32 %186, %187
  br i1 %188, label %189, label %232

; <label>:189                                     ; preds = %185
  %190 = load i32* %K, align 4
  %191 = load i32* %J, align 4
  %192 = call i32 @BlockOwner(i32 %190, i32 %191)
  %193 = load i32* %3, align 4
  %194 = icmp eq i32 %192, %193
  br i1 %194, label %195, label %225

; <label>:195                                     ; preds = %189
  %196 = load i32* %j, align 4
  %197 = load i32* %2, align 4
  %198 = add nsw i32 %196, %197
  store i32 %198, i32* %jl, align 4
  %199 = load i32* %jl, align 4
  %200 = load i32* %1, align 4
  %201 = icmp sgt i32 %199, %200
  br i1 %201, label %202, label %207

; <label>:202                                     ; preds = %195
  %203 = load i32* %1, align 4
  store i32 %203, i32* %jl, align 4
  %204 = load i32* %jl, align 4
  %205 = load i32* %j, align 4
  %206 = sub nsw i32 %204, %205
  store i32 %206, i32* %strJ, align 4
  br label %209

; <label>:207                                     ; preds = %195
  %208 = load i32* %2, align 4
  store i32 %208, i32* %strJ, align 4
  br label %209

; <label>:209                                     ; preds = %207, %202
  %210 = load i32* %K, align 4
  %211 = load i32* %J, align 4
  %212 = load i32* @nblocks, align 4
  %213 = mul nsw i32 %211, %212
  %214 = add nsw i32 %210, %213
  %215 = sext i32 %214 to i64
  %216 = load double*** @a, align 8
  %217 = getelementptr inbounds double** %216, i64 %215
  %218 = load double** %217, align 8
  store double* %218, double** %A, align 8
  %219 = load double** %D, align 8
  %220 = load double** %A, align 8
  %221 = load i32* %strK, align 4
  %222 = load i32* %strJ, align 4
  %223 = load i32* %strK, align 4
  %224 = load i32* %strK, align 4
  call void @bmodd(double* %219, double* %220, i32 %221, i32 %222, i32 %223, i32 %224)
  br label %225

; <label>:225                                     ; preds = %209, %189
  br label %226

; <label>:226                                     ; preds = %225
  %227 = load i32* %2, align 4
  %228 = load i32* %j, align 4
  %229 = add nsw i32 %228, %227
  store i32 %229, i32* %j, align 4
  %230 = load i32* %J, align 4
  %231 = add nsw i32 %230, 1
  store i32 %231, i32* %J, align 4
  br label %185

; <label>:232                                     ; preds = %185
  %233 = load i32* %3, align 4
  %234 = icmp eq i32 %233, 0
  br i1 %234, label %238, label %235

; <label>:235                                     ; preds = %232
  %236 = load i32* %5, align 4
  %237 = icmp ne i32 %236, 0
  br i1 %237, label %238, label %241

; <label>:238                                     ; preds = %235, %232
  %239 = call i64 @time(i64* null)
  %240 = trunc i64 %239 to i32
  store i32 %240, i32* %t22, align 4
  br label %241

; <label>:241                                     ; preds = %238, %235
  %242 = load %struct.GlobalMemory** @Global, align 8
  %243 = getelementptr inbounds %struct.GlobalMemory* %242, i32 0, i32 10
  %244 = getelementptr inbounds %struct.barrier_t* %243, i32 0, i32 0
  call void @loopCurrent(i32 0)
  call void @InitializeSwitchesAndCounter(i32 5)
  call void @IncrementCounter()
  call void @printChar(i8 signext 53)
  call void @printChar(i8 signext 90)
  %245 = load volatile i32* %244, align 4
  store i32 %245, i32* %lsense1, align 4
  br label %246

; <label>:246                                     ; preds = %281, %241
  %247 = load %struct.GlobalMemory** @Global, align 8
  %248 = getelementptr inbounds %struct.GlobalMemory* %247, i32 0, i32 10
  %249 = getelementptr inbounds %struct.barrier_t* %248, i32 0, i32 1
  %250 = load volatile i64* %249, align 8
  %call6 = call i32 @sleep(i32 1)
  %251 = trunc i64 %250 to i32
  store i32 %251, i32* %oldcount2, align 4
  %252 = load i32* %oldcount2, align 4
  %253 = load i32* %lsense1, align 4
  %254 = add nsw i32 %252, %253
  store i32 %254, i32* %newcount3, align 4
  %255 = load i32* %oldcount2, align 4
  %256 = load i32* %newcount3, align 4
  %257 = call i32 @atomic_cmpxchg(i32 %255, i32 %256)
  %call11 = call i32 @sleep(i32 1)
  store i32 %257, i32* %updatedcount4, align 4
  %258 = load i32* %updatedcount4, align 4
  %259 = load i32* %oldcount2, align 4
  %260 = icmp eq i32 %258, %259
  br i1 %260, label %261, label %281

; <label>:261                                     ; preds = %246
  %262 = load i32* %newcount3, align 4
  %263 = load i32* @P, align 4
  %call7 = call i32 @sleep(i32 1)
  %264 = icmp eq i32 %262, %263
  br i1 %264, label %265, label %268

; <label>:265                                     ; preds = %261
  %266 = load i32* %lsense1, align 4
  %267 = icmp eq i32 %266, 1
  br i1 %267, label %274, label %268

; <label>:268                                     ; preds = %265, %261
  %269 = load i32* %newcount3, align 4
  %270 = icmp eq i32 %269, 0
  br i1 %270, label %271, label %280

; <label>:271                                     ; preds = %268
  %272 = load i32* %lsense1, align 4
  %273 = icmp eq i32 %272, -1
  br i1 %273, label %274, label %280

; <label>:274                                     ; preds = %271, %265
  %275 = load i32* %lsense1, align 4
  %276 = sub nsw i32 0, %275
  %277 = load %struct.GlobalMemory** @Global, align 8
  %278 = getelementptr inbounds %struct.GlobalMemory* %277, i32 0, i32 10
  %279 = getelementptr inbounds %struct.barrier_t* %278, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %276, i32* %279, align 4
  call void @snapshot(i32 %276, i32 1)
  %call8 = call i32 @sleep(i32 3)
  br label %280

; <label>:280                                     ; preds = %274, %271, %268
  br label %282

; <label>:281                                     ; preds = %246
  br label %246

; <label>:282                                     ; preds = %280
  br label %283

; <label>:283                                     ; preds = %290, %282
  %284 = load %struct.GlobalMemory** @Global, align 8
  %285 = getelementptr inbounds %struct.GlobalMemory* %284, i32 0, i32 10
  %286 = getelementptr inbounds %struct.barrier_t* %285, i32 0, i32 0
  %287 = load volatile i32* %286, align 4
  %288 = load i32* %lsense1, align 4
  %289 = icmp eq i32 %287, %288
  br i1 %289, label %290, label %291

; <label>:290                                     ; preds = %283
  %call9 = call i32 @sleep(i32 2)
  br label %283

; <label>:291                                     ; preds = %283
  call void @printY()
  %call10 = call i32 @sleep(i32 4)
  %292 = load i32* %3, align 4
  %293 = icmp eq i32 %292, 0
  br i1 %293, label %297, label %294

; <label>:294                                     ; preds = %291
  %295 = load i32* %5, align 4
  %296 = icmp ne i32 %295, 0
  br i1 %296, label %297, label %300

; <label>:297                                     ; preds = %294, %291
  %298 = call i64 @time(i64* null)
  %299 = trunc i64 %298 to i32
  store i32 %299, i32* %t3, align 4
  br label %300

; <label>:300                                     ; preds = %297, %294
  %301 = load i32* %kl, align 4
  store i32 %301, i32* %i, align 4
  %302 = load i32* %K, align 4
  %303 = add nsw i32 %302, 1
  store i32 %303, i32* %I, align 4
  br label %304

; <label>:304                                     ; preds = %398, %300
  %305 = load i32* %i, align 4
  %306 = load i32* %1, align 4
  %307 = icmp slt i32 %305, %306
  br i1 %307, label %308, label %404

; <label>:308                                     ; preds = %304
  %309 = load i32* %i, align 4
  %310 = load i32* %2, align 4
  %311 = add nsw i32 %309, %310
  store i32 %311, i32* %il, align 4
  %312 = load i32* %il, align 4
  %313 = load i32* %1, align 4
  %314 = icmp sgt i32 %312, %313
  br i1 %314, label %315, label %320

; <label>:315                                     ; preds = %308
  %316 = load i32* %1, align 4
  store i32 %316, i32* %il, align 4
  %317 = load i32* %il, align 4
  %318 = load i32* %i, align 4
  %319 = sub nsw i32 %317, %318
  store i32 %319, i32* %strI, align 4
  br label %322

; <label>:320                                     ; preds = %308
  %321 = load i32* %2, align 4
  store i32 %321, i32* %strI, align 4
  br label %322

; <label>:322                                     ; preds = %320, %315
  %323 = load i32* %I, align 4
  %324 = load i32* %K, align 4
  %325 = call i32 @BlockOwner(i32 %323, i32 %324)
  store i32 %325, i32* %colowner, align 4
  %326 = load i32* %I, align 4
  %327 = load i32* %K, align 4
  %328 = load i32* @nblocks, align 4
  %329 = mul nsw i32 %327, %328
  %330 = add nsw i32 %326, %329
  %331 = sext i32 %330 to i64
  %332 = load double*** @a, align 8
  %333 = getelementptr inbounds double** %332, i64 %331
  %334 = load double** %333, align 8
  store double* %334, double** %A, align 8
  %335 = load i32* %kl, align 4
  store i32 %335, i32* %j, align 4
  %336 = load i32* %K, align 4
  %337 = add nsw i32 %336, 1
  store i32 %337, i32* %J, align 4
  br label %338

; <label>:338                                     ; preds = %391, %322
  %339 = load i32* %j, align 4
  %340 = load i32* %1, align 4
  %341 = icmp slt i32 %339, %340
  br i1 %341, label %342, label %397

; <label>:342                                     ; preds = %338
  %343 = load i32* %j, align 4
  %344 = load i32* %2, align 4
  %345 = add nsw i32 %343, %344
  store i32 %345, i32* %jl, align 4
  %346 = load i32* %jl, align 4
  %347 = load i32* %1, align 4
  %348 = icmp sgt i32 %346, %347
  br i1 %348, label %349, label %354

; <label>:349                                     ; preds = %342
  %350 = load i32* %1, align 4
  store i32 %350, i32* %jl, align 4
  %351 = load i32* %jl, align 4
  %352 = load i32* %j, align 4
  %353 = sub nsw i32 %351, %352
  store i32 %353, i32* %strJ, align 4
  br label %356

; <label>:354                                     ; preds = %342
  %355 = load i32* %2, align 4
  store i32 %355, i32* %strJ, align 4
  br label %356

; <label>:356                                     ; preds = %354, %349
  %357 = load i32* %I, align 4
  %358 = load i32* %J, align 4
  %359 = call i32 @BlockOwner(i32 %357, i32 %358)
  %360 = load i32* %3, align 4
  %361 = icmp eq i32 %359, %360
  br i1 %361, label %362, label %390

; <label>:362                                     ; preds = %356
  %363 = load i32* %K, align 4
  %364 = load i32* %J, align 4
  %365 = load i32* @nblocks, align 4
  %366 = mul nsw i32 %364, %365
  %367 = add nsw i32 %363, %366
  %368 = sext i32 %367 to i64
  %369 = load double*** @a, align 8
  %370 = getelementptr inbounds double** %369, i64 %368
  %371 = load double** %370, align 8
  store double* %371, double** %B, align 8
  %372 = load i32* %I, align 4
  %373 = load i32* %J, align 4
  %374 = load i32* @nblocks, align 4
  %375 = mul nsw i32 %373, %374
  %376 = add nsw i32 %372, %375
  %377 = sext i32 %376 to i64
  %378 = load double*** @a, align 8
  %379 = getelementptr inbounds double** %378, i64 %377
  %380 = load double** %379, align 8
  store double* %380, double** %C, align 8
  %381 = load double** %A, align 8
  %382 = load double** %B, align 8
  %383 = load double** %C, align 8
  %384 = load i32* %strI, align 4
  %385 = load i32* %strJ, align 4
  %386 = load i32* %strK, align 4
  %387 = load i32* %strI, align 4
  %388 = load i32* %strK, align 4
  %389 = load i32* %strI, align 4
  call void @bmod(double* %381, double* %382, double* %383, i32 %384, i32 %385, i32 %386, i32 %387, i32 %388, i32 %389)
  br label %390

; <label>:390                                     ; preds = %362, %356
  br label %391

; <label>:391                                     ; preds = %390
  %392 = load i32* %2, align 4
  %393 = load i32* %j, align 4
  %394 = add nsw i32 %393, %392
  store i32 %394, i32* %j, align 4
  %395 = load i32* %J, align 4
  %396 = add nsw i32 %395, 1
  store i32 %396, i32* %J, align 4
  br label %338

; <label>:397                                     ; preds = %338
  br label %398

; <label>:398                                     ; preds = %397
  %399 = load i32* %2, align 4
  %400 = load i32* %i, align 4
  %401 = add nsw i32 %400, %399
  store i32 %401, i32* %i, align 4
  %402 = load i32* %I, align 4
  %403 = add nsw i32 %402, 1
  store i32 %403, i32* %I, align 4
  br label %304

; <label>:404                                     ; preds = %304
  %405 = load i32* %3, align 4
  %406 = icmp eq i32 %405, 0
  br i1 %406, label %410, label %407

; <label>:407                                     ; preds = %404
  %408 = load i32* %5, align 4
  %409 = icmp ne i32 %408, 0
  br i1 %409, label %410, label %449

; <label>:410                                     ; preds = %407, %404
  %411 = call i64 @time(i64* null)
  %412 = trunc i64 %411 to i32
  store i32 %412, i32* %t4, align 4
  %413 = load i32* %t11, align 4
  %414 = load i32* %t1, align 4
  %415 = sub i32 %413, %414
  %416 = uitofp i32 %415 to double
  %417 = load %struct.LocalCopies** %4, align 8
  %418 = getelementptr inbounds %struct.LocalCopies* %417, i32 0, i32 0
  %419 = load double* %418, align 8
  %420 = fadd double %419, %416
  store double %420, double* %418, align 8
  %421 = load i32* %t22, align 4
  %422 = load i32* %t2, align 4
  %423 = sub i32 %421, %422
  %424 = uitofp i32 %423 to double
  %425 = load %struct.LocalCopies** %4, align 8
  %426 = getelementptr inbounds %struct.LocalCopies* %425, i32 0, i32 1
  %427 = load double* %426, align 8
  %428 = fadd double %427, %424
  store double %428, double* %426, align 8
  %429 = load i32* %t4, align 4
  %430 = load i32* %t3, align 4
  %431 = sub i32 %429, %430
  %432 = uitofp i32 %431 to double
  %433 = load %struct.LocalCopies** %4, align 8
  %434 = getelementptr inbounds %struct.LocalCopies* %433, i32 0, i32 2
  %435 = load double* %434, align 8
  %436 = fadd double %435, %432
  store double %436, double* %434, align 8
  %437 = load i32* %t2, align 4
  %438 = load i32* %t11, align 4
  %439 = sub i32 %437, %438
  %440 = load i32* %t3, align 4
  %441 = load i32* %t22, align 4
  %442 = sub i32 %440, %441
  %443 = add i32 %439, %442
  %444 = uitofp i32 %443 to double
  %445 = load %struct.LocalCopies** %4, align 8
  %446 = getelementptr inbounds %struct.LocalCopies* %445, i32 0, i32 3
  %447 = load double* %446, align 8
  %448 = fadd double %447, %444
  store double %448, double* %446, align 8
  br label %449

; <label>:449                                     ; preds = %410, %407
  br label %450

; <label>:450                                     ; preds = %449
  %451 = load i32* %2, align 4
  %452 = load i32* %k, align 4
  %453 = add nsw i32 %452, %451
  store i32 %453, i32* %k, align 4
  %454 = load i32* %K, align 4
  %455 = add nsw i32 %454, 1
  store i32 %455, i32* %K, align 4
  br label %6

; <label>:456                                     ; preds = %6
  call void @loopExit(i32 0)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @lu0(double* %a, i32 %n, i32 %stride) {
  %1 = alloca double*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %length = alloca i32, align 4
  %alpha = alloca double, align 8
  store double* %a, double** %1, align 8
  store i32 %n, i32* %2, align 4
  store i32 %stride, i32* %3, align 4
  store i32 0, i32* %k, align 4
  br label %4

; <label>:4                                       ; preds = %76, %0
  %5 = load i32* %k, align 4
  %6 = load i32* %2, align 4
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %8, label %79

; <label>:8                                       ; preds = %4
  %9 = load i32* %k, align 4
  %10 = add nsw i32 %9, 1
  store i32 %10, i32* %j, align 4
  br label %11

; <label>:11                                      ; preds = %72, %8
  %12 = load i32* %j, align 4
  %13 = load i32* %2, align 4
  %14 = icmp slt i32 %12, %13
  br i1 %14, label %15, label %75

; <label>:15                                      ; preds = %11
  %16 = load i32* %k, align 4
  %17 = load i32* %k, align 4
  %18 = load i32* %3, align 4
  %19 = mul nsw i32 %17, %18
  %20 = add nsw i32 %16, %19
  %21 = sext i32 %20 to i64
  %22 = load double** %1, align 8
  %23 = getelementptr inbounds double* %22, i64 %21
  %24 = load double* %23, align 8
  %25 = load i32* %k, align 4
  %26 = load i32* %j, align 4
  %27 = load i32* %3, align 4
  %28 = mul nsw i32 %26, %27
  %29 = add nsw i32 %25, %28
  %30 = sext i32 %29 to i64
  %31 = load double** %1, align 8
  %32 = getelementptr inbounds double* %31, i64 %30
  %33 = load double* %32, align 8
  %34 = fdiv double %33, %24
  store double %34, double* %32, align 8
  %35 = load i32* %k, align 4
  %36 = load i32* %j, align 4
  %37 = load i32* %3, align 4
  %38 = mul nsw i32 %36, %37
  %39 = add nsw i32 %35, %38
  %40 = sext i32 %39 to i64
  %41 = load double** %1, align 8
  %42 = getelementptr inbounds double* %41, i64 %40
  %43 = load double* %42, align 8
  %44 = fsub double -0.000000e+00, %43
  store double %44, double* %alpha, align 8
  %45 = load i32* %2, align 4
  %46 = load i32* %k, align 4
  %47 = sub nsw i32 %45, %46
  %48 = sub nsw i32 %47, 1
  store i32 %48, i32* %length, align 4
  %49 = load i32* %k, align 4
  %50 = add nsw i32 %49, 1
  %51 = load i32* %j, align 4
  %52 = load i32* %3, align 4
  %53 = mul nsw i32 %51, %52
  %54 = add nsw i32 %50, %53
  %55 = sext i32 %54 to i64
  %56 = load double** %1, align 8
  %57 = getelementptr inbounds double* %56, i64 %55
  %58 = load i32* %k, align 4
  %59 = add nsw i32 %58, 1
  %60 = load i32* %k, align 4
  %61 = load i32* %3, align 4
  %62 = mul nsw i32 %60, %61
  %63 = add nsw i32 %59, %62
  %64 = sext i32 %63 to i64
  %65 = load double** %1, align 8
  %66 = getelementptr inbounds double* %65, i64 %64
  %67 = load i32* %2, align 4
  %68 = load i32* %k, align 4
  %69 = sub nsw i32 %67, %68
  %70 = sub nsw i32 %69, 1
  %71 = load double* %alpha, align 8
  call void @daxpy(double* %57, double* %66, i32 %70, double %71)
  br label %72

; <label>:72                                      ; preds = %15
  %73 = load i32* %j, align 4
  %74 = add nsw i32 %73, 1
  store i32 %74, i32* %j, align 4
  br label %11

; <label>:75                                      ; preds = %11
  br label %76

; <label>:76                                      ; preds = %75
  %77 = load i32* %k, align 4
  %78 = add nsw i32 %77, 1
  store i32 %78, i32* %k, align 4
  br label %4

; <label>:79                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @daxpy(double* %a, double* %b, i32 %n, double %alpha) {
  %1 = alloca double*, align 8
  %2 = alloca double*, align 8
  %3 = alloca i32, align 4
  %4 = alloca double, align 8
  %i = alloca i32, align 4
  store double* %a, double** %1, align 8
  store double* %b, double** %2, align 8
  store i32 %n, i32* %3, align 4
  store double %alpha, double* %4, align 8
  store i32 0, i32* %i, align 4
  br label %5

; <label>:5                                       ; preds = %23, %0
  %6 = load i32* %i, align 4
  %7 = load i32* %3, align 4
  %8 = icmp slt i32 %6, %7
  br i1 %8, label %9, label %26

; <label>:9                                       ; preds = %5
  %10 = load double* %4, align 8
  %11 = load i32* %i, align 4
  %12 = sext i32 %11 to i64
  %13 = load double** %2, align 8
  %14 = getelementptr inbounds double* %13, i64 %12
  %15 = load double* %14, align 8
  %16 = fmul double %10, %15
  %17 = load i32* %i, align 4
  %18 = sext i32 %17 to i64
  %19 = load double** %1, align 8
  %20 = getelementptr inbounds double* %19, i64 %18
  %21 = load double* %20, align 8
  %22 = fadd double %21, %16
  store double %22, double* %20, align 8
  br label %23

; <label>:23                                      ; preds = %9
  %24 = load i32* %i, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %i, align 4
  br label %5

; <label>:26                                      ; preds = %5
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bdiv(double* %a, double* %diag, i32 %stride_a, i32 %stride_diag, i32 %dimi, i32 %dimk) {
  %1 = alloca double*, align 8
  %2 = alloca double*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %alpha = alloca double, align 8
  store double* %a, double** %1, align 8
  store double* %diag, double** %2, align 8
  store i32 %stride_a, i32* %3, align 4
  store i32 %stride_diag, i32* %4, align 4
  store i32 %dimi, i32* %5, align 4
  store i32 %dimk, i32* %6, align 4
  store i32 0, i32* %k, align 4
  br label %7

; <label>:7                                       ; preds = %47, %0
  %8 = load i32* %k, align 4
  %9 = load i32* %6, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %50

; <label>:11                                      ; preds = %7
  %12 = load i32* %k, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, i32* %j, align 4
  br label %14

; <label>:14                                      ; preds = %43, %11
  %15 = load i32* %j, align 4
  %16 = load i32* %6, align 4
  %17 = icmp slt i32 %15, %16
  br i1 %17, label %18, label %46

; <label>:18                                      ; preds = %14
  %19 = load i32* %k, align 4
  %20 = load i32* %j, align 4
  %21 = load i32* %4, align 4
  %22 = mul nsw i32 %20, %21
  %23 = add nsw i32 %19, %22
  %24 = sext i32 %23 to i64
  %25 = load double** %2, align 8
  %26 = getelementptr inbounds double* %25, i64 %24
  %27 = load double* %26, align 8
  %28 = fsub double -0.000000e+00, %27
  store double %28, double* %alpha, align 8
  %29 = load i32* %j, align 4
  %30 = load i32* %3, align 4
  %31 = mul nsw i32 %29, %30
  %32 = sext i32 %31 to i64
  %33 = load double** %1, align 8
  %34 = getelementptr inbounds double* %33, i64 %32
  %35 = load i32* %k, align 4
  %36 = load i32* %3, align 4
  %37 = mul nsw i32 %35, %36
  %38 = sext i32 %37 to i64
  %39 = load double** %1, align 8
  %40 = getelementptr inbounds double* %39, i64 %38
  %41 = load i32* %5, align 4
  %42 = load double* %alpha, align 8
  call void @daxpy(double* %34, double* %40, i32 %41, double %42)
  br label %43

; <label>:43                                      ; preds = %18
  %44 = load i32* %j, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %j, align 4
  br label %14

; <label>:46                                      ; preds = %14
  br label %47

; <label>:47                                      ; preds = %46
  %48 = load i32* %k, align 4
  %49 = add nsw i32 %48, 1
  store i32 %49, i32* %k, align 4
  br label %7

; <label>:50                                      ; preds = %7
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bmodd(double* %a, double* %c, i32 %dimi, i32 %dimj, i32 %stride_a, i32 %stride_c) {
  %1 = alloca double*, align 8
  %2 = alloca double*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %length = alloca i32, align 4
  %alpha = alloca double, align 8
  store double* %a, double** %1, align 8
  store double* %c, double** %2, align 8
  store i32 %dimi, i32* %3, align 4
  store i32 %dimj, i32* %4, align 4
  store i32 %stride_a, i32* %5, align 4
  store i32 %stride_c, i32* %6, align 4
  store i32 0, i32* %k, align 4
  br label %7

; <label>:7                                       ; preds = %77, %0
  %8 = load i32* %k, align 4
  %9 = load i32* %3, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %80

; <label>:11                                      ; preds = %7
  store i32 0, i32* %j, align 4
  br label %12

; <label>:12                                      ; preds = %73, %11
  %13 = load i32* %j, align 4
  %14 = load i32* %4, align 4
  %15 = icmp slt i32 %13, %14
  br i1 %15, label %16, label %76

; <label>:16                                      ; preds = %12
  %17 = load i32* %k, align 4
  %18 = load i32* %k, align 4
  %19 = load i32* %5, align 4
  %20 = mul nsw i32 %18, %19
  %21 = add nsw i32 %17, %20
  %22 = sext i32 %21 to i64
  %23 = load double** %1, align 8
  %24 = getelementptr inbounds double* %23, i64 %22
  %25 = load double* %24, align 8
  %26 = load i32* %k, align 4
  %27 = load i32* %j, align 4
  %28 = load i32* %6, align 4
  %29 = mul nsw i32 %27, %28
  %30 = add nsw i32 %26, %29
  %31 = sext i32 %30 to i64
  %32 = load double** %2, align 8
  %33 = getelementptr inbounds double* %32, i64 %31
  %34 = load double* %33, align 8
  %35 = fdiv double %34, %25
  store double %35, double* %33, align 8
  %36 = load i32* %k, align 4
  %37 = load i32* %j, align 4
  %38 = load i32* %6, align 4
  %39 = mul nsw i32 %37, %38
  %40 = add nsw i32 %36, %39
  %41 = sext i32 %40 to i64
  %42 = load double** %2, align 8
  %43 = getelementptr inbounds double* %42, i64 %41
  %44 = load double* %43, align 8
  %45 = fsub double -0.000000e+00, %44
  store double %45, double* %alpha, align 8
  %46 = load i32* %3, align 4
  %47 = load i32* %k, align 4
  %48 = sub nsw i32 %46, %47
  %49 = sub nsw i32 %48, 1
  store i32 %49, i32* %length, align 4
  %50 = load i32* %k, align 4
  %51 = add nsw i32 %50, 1
  %52 = load i32* %j, align 4
  %53 = load i32* %6, align 4
  %54 = mul nsw i32 %52, %53
  %55 = add nsw i32 %51, %54
  %56 = sext i32 %55 to i64
  %57 = load double** %2, align 8
  %58 = getelementptr inbounds double* %57, i64 %56
  %59 = load i32* %k, align 4
  %60 = add nsw i32 %59, 1
  %61 = load i32* %k, align 4
  %62 = load i32* %5, align 4
  %63 = mul nsw i32 %61, %62
  %64 = add nsw i32 %60, %63
  %65 = sext i32 %64 to i64
  %66 = load double** %1, align 8
  %67 = getelementptr inbounds double* %66, i64 %65
  %68 = load i32* %3, align 4
  %69 = load i32* %k, align 4
  %70 = sub nsw i32 %68, %69
  %71 = sub nsw i32 %70, 1
  %72 = load double* %alpha, align 8
  call void @daxpy(double* %58, double* %67, i32 %71, double %72)
  br label %73

; <label>:73                                      ; preds = %16
  %74 = load i32* %j, align 4
  %75 = add nsw i32 %74, 1
  store i32 %75, i32* %j, align 4
  br label %12

; <label>:76                                      ; preds = %12
  br label %77

; <label>:77                                      ; preds = %76
  %78 = load i32* %k, align 4
  %79 = add nsw i32 %78, 1
  store i32 %79, i32* %k, align 4
  br label %7

; <label>:80                                      ; preds = %7
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @bmod(double* %a, double* %b, double* %c, i32 %dimi, i32 %dimj, i32 %dimk, i32 %stridea, i32 %strideb, i32 %stridec) {
  %1 = alloca double*, align 8
  %2 = alloca double*, align 8
  %3 = alloca double*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %alpha = alloca double, align 8
  store double* %a, double** %1, align 8
  store double* %b, double** %2, align 8
  store double* %c, double** %3, align 8
  store i32 %dimi, i32* %4, align 4
  store i32 %dimj, i32* %5, align 4
  store i32 %dimk, i32* %6, align 4
  store i32 %stridea, i32* %7, align 4
  store i32 %strideb, i32* %8, align 4
  store i32 %stridec, i32* %9, align 4
  store i32 0, i32* %k, align 4
  br label %10

; <label>:10                                      ; preds = %48, %0
  %11 = load i32* %k, align 4
  %12 = load i32* %6, align 4
  %13 = icmp slt i32 %11, %12
  br i1 %13, label %14, label %51

; <label>:14                                      ; preds = %10
  store i32 0, i32* %j, align 4
  br label %15

; <label>:15                                      ; preds = %44, %14
  %16 = load i32* %j, align 4
  %17 = load i32* %5, align 4
  %18 = icmp slt i32 %16, %17
  br i1 %18, label %19, label %47

; <label>:19                                      ; preds = %15
  %20 = load i32* %k, align 4
  %21 = load i32* %j, align 4
  %22 = load i32* %8, align 4
  %23 = mul nsw i32 %21, %22
  %24 = add nsw i32 %20, %23
  %25 = sext i32 %24 to i64
  %26 = load double** %2, align 8
  %27 = getelementptr inbounds double* %26, i64 %25
  %28 = load double* %27, align 8
  %29 = fsub double -0.000000e+00, %28
  store double %29, double* %alpha, align 8
  %30 = load i32* %j, align 4
  %31 = load i32* %9, align 4
  %32 = mul nsw i32 %30, %31
  %33 = sext i32 %32 to i64
  %34 = load double** %3, align 8
  %35 = getelementptr inbounds double* %34, i64 %33
  %36 = load i32* %k, align 4
  %37 = load i32* %7, align 4
  %38 = mul nsw i32 %36, %37
  %39 = sext i32 %38 to i64
  %40 = load double** %1, align 8
  %41 = getelementptr inbounds double* %40, i64 %39
  %42 = load i32* %4, align 4
  %43 = load double* %alpha, align 8
  call void @daxpy(double* %35, double* %41, i32 %42, double %43)
  br label %44

; <label>:44                                      ; preds = %19
  %45 = load i32* %j, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, i32* %j, align 4
  br label %15

; <label>:47                                      ; preds = %15
  br label %48

; <label>:48                                      ; preds = %47
  %49 = load i32* %k, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %k, align 4
  br label %10

; <label>:51                                      ; preds = %10
  ret void
}

; Function Attrs: nounwind
declare void @srand48(i64)

; Function Attrs: nounwind
declare i64 @lrand48()

; Function Attrs: nounwind uwtable
define internal void @PrintA() {
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %ii = alloca i32, align 4
  %jj = alloca i32, align 4
  %edge = alloca i32, align 4
  %ibs = alloca i32, align 4
  %jbs = alloca i32, align 4
  %skip = alloca i32, align 4
  %1 = load i32* @n, align 4
  %2 = load i32* @block_size, align 4
  %3 = srem i32 %1, %2
  store i32 %3, i32* %edge, align 4
  store i32 0, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %75, %0
  %5 = load i32* %i, align 4
  %6 = load i32* @n, align 4
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %8, label %78

; <label>:8                                       ; preds = %4
  store i32 0, i32* %j, align 4
  br label %9

; <label>:9                                       ; preds = %70, %8
  %10 = load i32* %j, align 4
  %11 = load i32* @n, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %73

; <label>:13                                      ; preds = %9
  %14 = load i32* @n, align 4
  %15 = load i32* %i, align 4
  %16 = sub nsw i32 %14, %15
  %17 = load i32* %edge, align 4
  %18 = icmp sle i32 %16, %17
  br i1 %18, label %19, label %25

; <label>:19                                      ; preds = %13
  %20 = load i32* %edge, align 4
  store i32 %20, i32* %ibs, align 4
  %21 = load i32* @n, align 4
  %22 = load i32* %edge, align 4
  %23 = sub nsw i32 %21, %22
  store i32 %23, i32* %ibs, align 4
  %24 = load i32* %edge, align 4
  store i32 %24, i32* %skip, align 4
  br label %28

; <label>:25                                      ; preds = %13
  %26 = load i32* @block_size, align 4
  store i32 %26, i32* %ibs, align 4
  %27 = load i32* @block_size, align 4
  store i32 %27, i32* %skip, align 4
  br label %28

; <label>:28                                      ; preds = %25, %19
  %29 = load i32* @n, align 4
  %30 = load i32* %j, align 4
  %31 = sub nsw i32 %29, %30
  %32 = load i32* %edge, align 4
  %33 = icmp sle i32 %31, %32
  br i1 %33, label %34, label %39

; <label>:34                                      ; preds = %28
  %35 = load i32* %edge, align 4
  store i32 %35, i32* %jbs, align 4
  %36 = load i32* @n, align 4
  %37 = load i32* %edge, align 4
  %38 = sub nsw i32 %36, %37
  store i32 %38, i32* %jbs, align 4
  br label %41

; <label>:39                                      ; preds = %28
  %40 = load i32* @block_size, align 4
  store i32 %40, i32* %jbs, align 4
  br label %41

; <label>:41                                      ; preds = %39, %34
  %42 = load i32* %i, align 4
  %43 = load i32* @block_size, align 4
  %44 = sdiv i32 %42, %43
  %45 = load i32* %j, align 4
  %46 = load i32* @block_size, align 4
  %47 = sdiv i32 %45, %46
  %48 = load i32* @nblocks, align 4
  %49 = mul nsw i32 %47, %48
  %50 = add nsw i32 %44, %49
  store i32 %50, i32* %ii, align 4
  %51 = load i32* %i, align 4
  %52 = load i32* %ibs, align 4
  %53 = srem i32 %51, %52
  %54 = load i32* %j, align 4
  %55 = load i32* %jbs, align 4
  %56 = srem i32 %54, %55
  %57 = load i32* %skip, align 4
  %58 = mul nsw i32 %56, %57
  %59 = add nsw i32 %53, %58
  store i32 %59, i32* %jj, align 4
  %60 = load i32* %jj, align 4
  %61 = sext i32 %60 to i64
  %62 = load i32* %ii, align 4
  %63 = sext i32 %62 to i64
  %64 = load double*** @a, align 8
  %65 = getelementptr inbounds double** %64, i64 %63
  %66 = load double** %65, align 8
  %67 = getelementptr inbounds double* %66, i64 %61
  %68 = load double* %67, align 8
  %69 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([7 x i8]* @.str.45, i32 0, i32 0), double %68)
  br label %70

; <label>:70                                      ; preds = %41
  %71 = load i32* %j, align 4
  %72 = add nsw i32 %71, 1
  store i32 %72, i32* %j, align 4
  br label %9

; <label>:73                                      ; preds = %9
  %74 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.13, i32 0, i32 0))
  br label %75

; <label>:75                                      ; preds = %73
  %76 = load i32* %i, align 4
  %77 = add nsw i32 %76, 1
  store i32 %77, i32* %i, align 4
  br label %4

; <label>:78                                      ; preds = %4
  %79 = load %struct._IO_FILE** @stdout, align 8
  %80 = call i32 @fflush(%struct._IO_FILE* %79)
  ret void
}

declare i32 @fflush(%struct._IO_FILE*)

; Function Attrs: nounwind readnone
declare double @fabs(double)

; Function Attrs: nounwind
declare void @free(i8*)

define internal void @loopCurrent(i32 %loopID) {
  %1 = alloca i32, align 4
  store i32 %loopID, i32* %1, align 4
  ret void
}

define internal void @loopExit(i32 %loopID) {
  %1 = alloca i32, align 4
  store i32 %loopID, i32* %1, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DeriveInvariant() {
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckInvariant() {
  ret void
}

define internal void @RecordSyncVariable() {
  ret void
}

define internal void @printX() {
  %1 = load i32* @index_out, align 4
  %2 = sext i32 %1 to i64
  %3 = getelementptr inbounds [1024 x i8]* @mystring, i32 0, i64 %2
  store i8 88, i8* %3, align 1
  %4 = load i32* @index_out, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, i32* @index_out, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @appendY() {
  %1 = load i32* @index_out, align 4
  %2 = sext i32 %1 to i64
  %3 = getelementptr inbounds [1024 x i8]* @mystring, i32 0, i64 %2
  store i8 89, i8* %3, align 1
  %4 = load i32* @index_out, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, i32* @index_out, align 4
  ret void
}

define internal void @printY() {
  call void @appendY()
  call void @DecrementCounter()
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DecrementCounter() {
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %i1 = alloca i32, align 4
  %1 = call i32 (...) *@pthread_self()
  store i32 %1, i32* %idx, align 4
  %2 = load i32* %idx, align 4
  %3 = zext i32 %2 to i64
  %4 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %3
  store i8 0, i8* %4, align 1
  %5 = load i32* %idx, align 4
  %6 = zext i32 %5 to i64
  %7 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %6
  %8 = load i32* %7, align 4
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %31

; <label>:10                                      ; preds = %0
  %11 = load i32* @counter0, align 4
  %12 = add nsw i32 %11, -1
  store i32 %12, i32* @counter0, align 4
  %13 = load i32* @counter0, align 4
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %27

; <label>:15                                      ; preds = %10
  call void @DeriveInvariant()
  store i32 0, i32* %i, align 4
  br label %16

; <label>:16                                      ; preds = %23, %15
  %17 = load i32* %i, align 4
  %18 = icmp slt i32 %17, 3
  br i1 %18, label %19, label %26

; <label>:19                                      ; preds = %16
  %20 = load i32* %i, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %21
  store i8 1, i8* %22, align 1
  br label %23

; <label>:23                                      ; preds = %19
  %24 = load i32* %i, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %i, align 4
  br label %16

; <label>:26                                      ; preds = %16
  br label %27

; <label>:27                                      ; preds = %26, %10
  %28 = load i32* %idx, align 4
  %29 = zext i32 %28 to i64
  %30 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %29
  store i32 1, i32* %30, align 4
  br label %52

; <label>:31                                      ; preds = %0
  %32 = load i32* @counter1, align 4
  %33 = add nsw i32 %32, -1
  store i32 %33, i32* @counter1, align 4
  %34 = load i32* @counter1, align 4
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %48

; <label>:36                                      ; preds = %31
  call void @DeriveInvariant()
  store i32 0, i32* %i1, align 4
  br label %37

; <label>:37                                      ; preds = %44, %36
  %38 = load i32* %i1, align 4
  %39 = icmp slt i32 %38, 3
  br i1 %39, label %40, label %47

; <label>:40                                      ; preds = %37
  %41 = load i32* %i1, align 4
  %42 = sext i32 %41 to i64
  %43 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %42
  store i8 1, i8* %43, align 1
  br label %44

; <label>:44                                      ; preds = %40
  %45 = load i32* %i1, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, i32* %i1, align 4
  br label %37

; <label>:47                                      ; preds = %37
  br label %48

; <label>:48                                      ; preds = %47, %31
  %49 = load i32* %idx, align 4
  %50 = zext i32 %49 to i64
  %51 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %50
  store i32 0, i32* %51, align 4
  br label %52

; <label>:52                                      ; preds = %48, %27
  store i8 1, i8* @bFirstThread, align 1
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @flushAll() {
  %1 = load i32* @index_out, align 4
  %2 = sext i32 %1 to i64
  %3 = getelementptr inbounds [1024 x i8]* @mystring, i32 0, i64 %2
  store i8 0, i8* %3, align 1
  ret void
}

define internal void @printChar(i8 signext %ch) {
  %1 = alloca i8, align 1
  store i8 %ch, i8* %1, align 1
  %2 = load i8* %1, align 1
  %3 = load i32* @index_out, align 4
  %4 = sext i32 %3 to i64
  %5 = getelementptr inbounds [1024 x i8]* @mystring, i32 0, i64 %4
  store i8 %2, i8* %5, align 1
  %6 = load i32* @index_out, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, i32* @index_out, align 4
  ret void
}

define internal void @waitForAll() {
  %1 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @pthread_join to i32 (i32, i32, ...)*)(i32 0, i32 0)
  call void @flushAll()
  ret void
}

declare i32 @pthread_join(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot(i32 %gvar, i32 %index) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %idx = alloca i32, align 4
  store i32 %gvar, i32* %1, align 4
  store i32 %index, i32* %2, align 4
  %3 = call i32 (...) *@pthread_self()
  store i32 %3, i32* %idx, align 4
  %4 = load i32* %idx, align 4
  %5 = zext i32 %4 to i64
  %6 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %5
  %7 = load i8* %6, align 1
  %8 = trunc i8 %7 to i1
  br i1 %8, label %9, label %27

; <label>:9                                       ; preds = %0
  %10 = load i32* %2, align 4
  switch i32 %10, label %17 [
    i32 0, label %11
    i32 1, label %13
    i32 2, label %15
  ]

; <label>:11                                      ; preds = %9
  %12 = load i32* %1, align 4
  store i32 %12, i32* @gSyncVar_0, align 4
  br label %18

; <label>:13                                      ; preds = %9
  %14 = load i32* %1, align 4
  store i32 %14, i32* @gSyncVar_1, align 4
  br label %18

; <label>:15                                      ; preds = %9
  %16 = load i32* %1, align 4
  store i32 %16, i32* @gSyncVar_2, align 4
  br label %17

; <label>:17                                      ; preds = %15, %9
  br label %18

; <label>:18                                      ; preds = %17, %13, %11
  %19 = load i32* %2, align 4
  %20 = add nsw i32 %19, 1
  %21 = load i32* @gSyncVarsTotalNum, align 4
  %22 = icmp sgt i32 %20, %21
  br i1 %22, label %23, label %26

; <label>:23                                      ; preds = %18
  %24 = load i32* %2, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* @gSyncVarsTotalNum, align 4
  br label %26

; <label>:26                                      ; preds = %23, %18
  br label %27

; <label>:27                                      ; preds = %26, %0
  ret void
}

declare i32 @pthread_self(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot64(i64 %gvar, i32 %index) {
  %1 = alloca i64, align 8
  %2 = alloca i32, align 4
  store i64 %gvar, i64* %1, align 8
  store i32 %index, i32* %2, align 4
  %3 = load i64* %1, align 8
  %4 = trunc i64 %3 to i32
  %5 = load i32* %2, align 4
  call void @snapshot(i32 %4, i32 %5)
  ret void
}

define internal void @InitializeSwitchesAndCounter(i32 %id) {
  %1 = alloca i32, align 4
  store i32 %id, i32* %1, align 4
  ret void
}

define internal void @IncrementCounter() {
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %1 = call i32 (...) *@pthread_self()
  store i32 %1, i32* %idx, align 4
  %2 = load i32* %idx, align 4
  %3 = zext i32 %2 to i64
  %4 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %3
  %5 = load i32* %4, align 4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %29

; <label>:7                                       ; preds = %0
  %8 = load i32* @counter0, align 4
  %9 = add nsw i32 %8, 1
  store i32 %9, i32* @counter0, align 4
  %10 = load i32* @counter0, align 4
  %11 = icmp eq i32 %10, 1
  br i1 %11, label %12, label %13

; <label>:12                                      ; preds = %7
  call void @CheckInvariant()
  br label %13

; <label>:13                                      ; preds = %12, %7
  %14 = load i8* @firstSync, align 1
  %15 = trunc i8 %14 to i1
  br i1 %15, label %16, label %28

; <label>:16                                      ; preds = %13
  store i32 0, i32* %i, align 4
  br label %17

; <label>:17                                      ; preds = %24, %16
  %18 = load i32* %i, align 4
  %19 = icmp slt i32 %18, 3
  br i1 %19, label %20, label %27

; <label>:20                                      ; preds = %17
  %21 = load i32* %i, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %22
  store i8 1, i8* %23, align 1
  br label %24

; <label>:24                                      ; preds = %20
  %25 = load i32* %i, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %i, align 4
  br label %17

; <label>:27                                      ; preds = %17
  store i8 0, i8* @firstSync, align 1
  br label %28

; <label>:28                                      ; preds = %27, %13
  br label %36

; <label>:29                                      ; preds = %0
  %30 = load i32* @counter1, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, i32* @counter1, align 4
  %32 = load i32* @counter1, align 4
  %33 = icmp eq i32 %32, 1
  br i1 %33, label %34, label %35

; <label>:34                                      ; preds = %29
  call void @CheckInvariant()
  br label %35

; <label>:35                                      ; preds = %34, %29
  br label %36

; <label>:36                                      ; preds = %35, %28
  ret void
}

declare i32 @sleep(i32)


