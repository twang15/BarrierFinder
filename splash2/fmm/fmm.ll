; ModuleID = 'fmm.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._G_Mem = type { %union.pthread_mutex_t, %union.pthread_mutex_t, %union.pthread_mutex_t, %union.pthread_mutex_t, i32, [2048 x %union.pthread_mutex_t], %struct.barrier_t, i32*, double*, [64 x [4 x double]], double, double, double, double, i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.barrier_t = type { i32, i64 }
%struct._Local_Memory = type { [1024 x i32], %struct._Box*, i32, i32, %struct._Particle**, i32, i32, %struct._Box*, [100 x %struct._Box*], i32, %struct._Box*, double, double, double, double, i32, i32, i32, i32, double, i32, [10 x %struct._Time_Info], [1024 x i32] }
%struct._Particle = type { i32, double, double, %struct._Vector, %struct._Vector, %struct._Vector, %struct.Complex, i32, double }
%struct._Vector = type { double, double }
%struct.Complex = type { double, double }
%struct._Box = type { double, double, double, double, i32, i32, [41 x %struct._Particle*], i32, %struct._Box*, i32, [4 x %struct._Box*], [4 x %struct._Box*], i32, [3 x %struct._Box*], i32, [8 x %struct._Box*], i32, [20 x %struct._Box*], i32, [27 x %struct._Box*], i32, [30 x %struct._Box*], i32, [40 x %struct.Complex], [40 x %struct.Complex], [40 x %struct.Complex], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct._Box*, %struct._Box*, %struct._Box*, %struct._Box* }
%struct._Time_Info = type { i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@do_stats = global i32 0, align 4
@do_output = global i32 0, align 4
@G_Memory = external global %struct._G_Mem*, align 8
@starttime = common global i32 0, align 4
@.str = private unnamed_addr constant [4 x i8] c"osh\00", align 1
@Cluster = internal global i32 0, align 4
@Model = internal global i32 0, align 4
@Number_Of_Processors = external global i32, align 4
@.str.1 = private unnamed_addr constant [14 x i8] c"Finished FMM\0A\00", align 1
@Total_Particles = external global i32, align 4
@.str.2 = private unnamed_addr constant [34 x i8] c"Starting FMM with %d processor%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@Local = external global [64 x %struct._Local_Memory], align 16
@Time_Steps = internal global i32 0, align 4
@Timestep_Dur = external global double, align 8
@endtime = common global i32 0, align 4
@Partition_Flag = internal global i32 0, align 4
@stderr = external global %struct._IO_FILE*, align 8
@.str.5 = private unnamed_addr constant [7 x i8] c"ERROR\0A\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"one cluster\00", align 1
@.str.7 = private unnamed_addr constant [12 x i8] c"two cluster\00", align 1
@.str.8 = private unnamed_addr constant [45 x i8] c"ERROR: The only cluster types available are \00", align 1
@.str.9 = private unnamed_addr constant [33 x i8] c"\22one cluster\22 or \22two cluster\22.\0A\00", align 1
@.str.10 = private unnamed_addr constant [39 x i8] c"If you need help, type \22nbody -help\22.\0A\00", align 1
@.str.11 = private unnamed_addr constant [8 x i8] c"uniform\00", align 1
@.str.12 = private unnamed_addr constant [8 x i8] c"plummer\00", align 1
@.str.13 = private unnamed_addr constant [45 x i8] c"ERROR: The only distributions available are \00", align 1
@.str.14 = private unnamed_addr constant [25 x i8] c"\22uniform\22 or \22plummer\22.\0A\00", align 1
@.str.15 = private unnamed_addr constant [49 x i8] c"ERROR: The number of particles should be an int \00", align 1
@.str.16 = private unnamed_addr constant [17 x i8] c"greater than 0.\0A\00", align 1
@Precision = internal global double 0.000000e+00, align 8
@.str.17 = private unnamed_addr constant [44 x i8] c"ERROR: The precision has no default value.\0A\00", align 1
@Expansion_Terms = external global i32, align 4
@.str.18 = private unnamed_addr constant [48 x i8] c"ERROR: %g (%d terms) is too great a precision.\0A\00", align 1
@.str.19 = private unnamed_addr constant [49 x i8] c"ERROR: The Number_Of_Processors has no default.\0A\00", align 1
@.str.20 = private unnamed_addr constant [54 x i8] c"ERROR: Number of processors should be an int greater \00", align 1
@.str.21 = private unnamed_addr constant [9 x i8] c"than 0.\0A\00", align 1
@.str.22 = private unnamed_addr constant [49 x i8] c"ERROR: The number of time steps has no default.\0A\00", align 1
@.str.23 = private unnamed_addr constant [50 x i8] c"ERROR: The number of time steps should be an int \00", align 1
@.str.24 = private unnamed_addr constant [51 x i8] c"ERROR: The duration of a time step has no default \00", align 1
@.str.25 = private unnamed_addr constant [47 x i8] c"value.\0A If you need help, type \22nbody -help\22.\0A\00", align 1
@.str.26 = private unnamed_addr constant [48 x i8] c"ERROR: The duration of a time step should be a \00", align 1
@.str.27 = private unnamed_addr constant [24 x i8] c"double greater than 0.\0A\00", align 1
@Softening_Param = external global double, align 8
@.str.28 = private unnamed_addr constant [51 x i8] c"ERROR: The softening parameter should be a double \00", align 1
@.str.29 = private unnamed_addr constant [11 x i8] c"cost zones\00", align 1
@.str.30 = private unnamed_addr constant [4 x i8] c"orb\00", align 1
@.str.31 = private unnamed_addr constant [48 x i8] c"ERROR: The only partitioning schemes available \00", align 1
@.str.32 = private unnamed_addr constant [31 x i8] c"are \22cost zones\22 \0A\09 or \22orb\22.\0A\00", align 1
@.str.33 = private unnamed_addr constant [6 x i8] c"times\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.35 = private unnamed_addr constant [27 x i8] c"Error opening output file\0A\00", align 1
@.str.36 = private unnamed_addr constant [9 x i8] c"TIMING:\0A\00", align 1
@.str.37 = private unnamed_addr constant [15 x i8] c"%d\09%d\09%.2e\09%d\0A\00", align 1
@.str.38 = private unnamed_addr constant [14 x i8] c"Time Step %d\0A\00", align 1
@.str.39 = private unnamed_addr constant [14 x i8] c"Processor %d\0A\00", align 1
@.str.40 = private unnamed_addr constant [19 x i8] c"\09Total Time = %lu\0A\00", align 1
@.str.41 = private unnamed_addr constant [31 x i8] c"\09Tree Construction Time = %lu\0A\00", align 1
@.str.42 = private unnamed_addr constant [31 x i8] c"\09List Construction Time = %lu\0A\00", align 1
@.str.43 = private unnamed_addr constant [23 x i8] c"\09Partition Time = %lu\0A\00", align 1
@.str.44 = private unnamed_addr constant [23 x i8] c"\09Tree Pass Time = %lu\0A\00", align 1
@.str.45 = private unnamed_addr constant [28 x i8] c"\09Inter Particle Time = %lu\0A\00", align 1
@.str.46 = private unnamed_addr constant [21 x i8] c"\09Barrier Time = %lu\0A\00", align 1
@.str.47 = private unnamed_addr constant [28 x i8] c"\09Intra Particle Time = %lu\0A\00", align 1
@.str.48 = private unnamed_addr constant [19 x i8] c"\09Other Time = %lu\0A\00", align 1
@.str.49 = private unnamed_addr constant [5 x i8] c"END\0A\00", align 1
@.str.50 = private unnamed_addr constant [55 x i8] c"                                   PROCESS STATISTICS\0A\00", align 1
@.str.51 = private unnamed_addr constant [116 x i8] c"             Track        Tree        List        Part        Pass       Inter        Bar        Intra       Other\0A\00", align 1
@.str.52 = private unnamed_addr constant [115 x i8] c" Proc        Time         Time        Time        Time        Time       Time         Time       Time        Time\0A\00", align 1
@.str.53 = private unnamed_addr constant [61 x i8] c" %4d %12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f\0A\00", align 1
@.str.54 = private unnamed_addr constant [62 x i8] c"  Avg %12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f%12.0f\0A\00", align 1
@.str.55 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.56 = private unnamed_addr constant [55 x i8] c"                                   TIMING INFORMATION\0A\00", align 1
@.str.57 = private unnamed_addr constant [42 x i8] c"Start time                        : %16d\0A\00", align 1
@.str.58 = private unnamed_addr constant [42 x i8] c"Initialization finish time        : %16d\0A\00", align 1
@.str.59 = private unnamed_addr constant [42 x i8] c"Overall finish time               : %16d\0A\00", align 1
@.str.60 = private unnamed_addr constant [42 x i8] c"Total time with initialization    : %16d\0A\00", align 1
@.str.61 = private unnamed_addr constant [42 x i8] c"Total time without initialization : %16d\0A\00", align 1
@.str.62 = private unnamed_addr constant [40 x i8] c"Total time for steps %d to %d : %12.0f\0A\00", align 1
@.str.63 = private unnamed_addr constant [35 x i8] c"Usage: FMM <options> < inputfile\0A\0A\00", align 1
@.str.64 = private unnamed_addr constant [10 x i8] c"options:\0A\00", align 1
@.str.65 = private unnamed_addr constant [44 x i8] c"  -o : Print out final particle positions.\0A\00", align 1
@.str.66 = private unnamed_addr constant [58 x i8] c"  -s : Print out individual processor timing statistics.\0A\00", align 1
@.str.67 = private unnamed_addr constant [39 x i8] c"  -h : Print out command line options\0A\00", align 1
@.str.68 = private unnamed_addr constant [31 x i8] c"Input parameter descriptions:\0A\00", align 1
@.str.69 = private unnamed_addr constant [59 x i8] c"  There are nine parameters, and parameters three through\0A\00", align 1
@.str.70 = private unnamed_addr constant [27 x i8] c"  have no default values.\0A\00", align 1
@.str.71 = private unnamed_addr constant [55 x i8] c"1) Cluster Type : Distribute particles in one cluster\0A\00", align 1
@.str.72 = private unnamed_addr constant [64 x i8] c"   (\22one cluster\22) or two interacting clusters (\22two cluster\22)\0A\00", align 1
@.str.73 = private unnamed_addr constant [28 x i8] c"   Default is two cluster.\0A\00", align 1
@.str.74 = private unnamed_addr constant [57 x i8] c"2) Distribution Type : Distribute particles in either a\0A\00", align 1
@.str.75 = private unnamed_addr constant [56 x i8] c"   uniform spherical distribution (\22uniform\22), or in a\0A\00", align 1
@.str.76 = private unnamed_addr constant [52 x i8] c"   Plummer model (\22plummer\22).  Default is plummer.\0A\00", align 1
@.str.77 = private unnamed_addr constant [50 x i8] c"3) Number Of Particles : Integer greater than 0.\0A\00", align 1
@.str.78 = private unnamed_addr constant [59 x i8] c"4) Precision : Precision of results.  Should be a double.\0A\00", align 1
@.str.79 = private unnamed_addr constant [51 x i8] c"5) Number of Processors : Integer greater than 0.\0A\00", align 1
@.str.80 = private unnamed_addr constant [51 x i8] c"6) Number of Time Steps : Integer greater than 0.\0A\00", align 1
@.str.81 = private unnamed_addr constant [48 x i8] c"7) Time Step Duration : Double greater than 0.\0A\00", align 1
@.str.82 = private unnamed_addr constant [54 x i8] c"8) Softening Parameter : Real number greater than 0.\0A\00", align 1
@.str.83 = private unnamed_addr constant [36 x i8] c"   Defaults is DBL_MIN or FLT_MIN.\0A\00", align 1
@.str.84 = private unnamed_addr constant [49 x i8] c"9) Partitioning Scheme : \22cost zones\22 or \22orb\22.\0A\00", align 1
@.str.85 = private unnamed_addr constant [27 x i8] c"   Default is cost zones.\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @atomic_cmpxchg(i32 %oldcount, i32 %newcount) {
entry:
  %oldcount.addr = alloca i32, align 4
  %newcount.addr = alloca i32, align 4
  %temp = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  store i32 %oldcount, i32* %oldcount.addr, align 4
  store i32 %newcount, i32* %newcount.addr, align 4
  %0 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %0, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 1
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
  %5 = load %struct._G_Mem** @G_Memory, align 8
  %synch3 = getelementptr inbounds %struct._G_Mem* %5, i32 0, i32 6
  %count4 = getelementptr inbounds %struct.barrier_t* %synch3, i32 0, i32 1
  store volatile i64 %conv2, i64* %count4, align 8
  %6 = load i32* %oldcount.addr, align 4
  store i32 %6, i32* %updatedcount, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %7 = load %struct._G_Mem** @G_Memory, align 8
  %synch5 = getelementptr inbounds %struct._G_Mem* %7, i32 0, i32 6
  %count6 = getelementptr inbounds %struct.barrier_t* %synch5, i32 0, i32 1
  %8 = load volatile i64* %count6, align 8
  %conv7 = trunc i64 %8 to i32
  store i32 %conv7, i32* %updatedcount, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %9 = load i32* %updatedcount, align 4
  ret i32 %9
}

; Function Attrs: nounwind uwtable
define void @main(i32 %argc, i8** %argv) {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %c = alloca i32, align 4
  %t = alloca i64, align 8
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i64 @time(i64* null)
  %conv = trunc i64 %call to i32
  store i32 %conv, i32* @starttime, align 4
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %0 = load i32* %argc.addr, align 4
  %1 = load i8*** %argv.addr, align 8
  %call1 = call i32 (i32, i8**, i8*, ...) *bitcast (i32 (...)* @getopt to i32 (i32, i8**, i8*, ...)*)(i32 %0, i8** %1, i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0))
  store i32 %call1, i32* %c, align 4
  %cmp = icmp ne i32 %call1, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %c, align 4
  switch i32 %2, label %sw.epilog [
    i32 111, label %sw.bb
    i32 115, label %sw.bb.3
    i32 104, label %sw.bb.4
  ]

sw.bb:                                            ; preds = %while.body
  store i32 1, i32* @do_output, align 4
  br label %sw.epilog

sw.bb.3:                                          ; preds = %while.body
  store i32 1, i32* @do_stats, align 4
  br label %sw.epilog

sw.bb.4:                                          ; preds = %while.body
  call void @Help()
  br label %sw.epilog

sw.epilog:                                        ; preds = %while.body, %sw.bb.4, %sw.bb.3, %sw.bb
  br label %while.cond

while.end:                                        ; preds = %while.cond
  call void @GetArguments()
  call void (...) @InitGlobalMemory()
  call void (...) @InitExpTables()
  %3 = load i32* @Cluster, align 4
  %4 = load i32* @Model, align 4
  call void @CreateDistribution(i32 %3, i32 %4)
  store i32 1, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end
  %5 = load i32* %i, align 4
  %6 = load i32* @Number_Of_Processors, align 4
  %cmp5 = icmp slt i32 %5, %6
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call7 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @ParallelExecute to i8* (i8*)*), i8* null)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @ParallelExecute()
  %call8 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([14 x i8]* @.str.1, i32 0, i32 0))
  call void @PrintTimes()
  %8 = load i32* @do_output, align 4
  %tobool = icmp ne i32 %8, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  call void (...) @PrintAllParticles()
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  call void @exit(i32 0)
  unreachable

return:                                           ; No predecessors!
  ret void
}

; Function Attrs: nounwind
declare i64 @time(i64*)

declare i32 @getopt(...)

declare void @InitGlobalMemory(...)

declare void @InitExpTables(...)

declare void @CreateDistribution(i32, i32)

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

declare i32 @printf(i8*, ...)

declare void @PrintAllParticles(...)

; Function Attrs: noreturn nounwind
declare void @exit(i32)

; Function Attrs: nounwind uwtable
define void @ParallelExecute() {
entry:
  %my_id = alloca i32, align 4
  %num_boxes = alloca i32, align 4
  %b = alloca %struct._Box*, align 8
  %b_list = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %start_index = alloca i32, align 4
  %end_index = alloca i32, align 4
  %start = alloca i64, align 8
  %finish = alloca i64, align 8
  %local_time = alloca %struct._Time_Info*, align 8
  %time_all = alloca i32, align 4
  %timing = alloca %struct._Time_Info*, align 8
  %local_init_done = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense69 = alloca i32, align 4
  %oldcount74 = alloca i32, align 4
  %newcount78 = alloca i32, align 4
  %updatedcount80 = alloca i32, align 4
  %retVal81 = alloca i32, align 4
  %lsense172 = alloca i32, align 4
  %oldcount177 = alloca i32, align 4
  %newcount181 = alloca i32, align 4
  %updatedcount183 = alloca i32, align 4
  %retVal184 = alloca i32, align 4
  %lsense288 = alloca i32, align 4
  %oldcount293 = alloca i32, align 4
  %newcount297 = alloca i32, align 4
  %updatedcount299 = alloca i32, align 4
  %retVal300 = alloca i32, align 4
  store i32 0, i32* %time_all, align 4
  %call = call noalias i8* @malloc(i64 720)
  %0 = bitcast i8* %call to %struct._Time_Info*
  store %struct._Time_Info* %0, %struct._Time_Info** %local_time, align 8
  %1 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %1, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %2 = load volatile i32* %gsense, align 4
  store i32 %2, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %entry, %if.end.16
  %3 = load %struct._G_Mem** @G_Memory, align 8
  %synch1 = getelementptr inbounds %struct._G_Mem* %3, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch1, i32 0, i32 1
  %4 = load volatile i64* %count, align 8
  %conv = trunc i64 %4 to i32
  store i32 %conv, i32* %oldcount, align 4
  %5 = load i32* %oldcount, align 4
  %6 = load i32* %lsense, align 4
  %add = add nsw i32 %5, %6
  store i32 %add, i32* %newcount, align 4
  %7 = load i32* %oldcount, align 4
  %8 = load i32* %newcount, align 4
  %call2 = call i32 @atomic_cmpxchg(i32 %7, i32 %8)
  store i32 %call2, i32* %updatedcount, align 4
  %9 = load i32* %updatedcount, align 4
  %10 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %9, %10
  br i1 %cmp, label %if.then, label %if.end.16

if.then:                                          ; preds = %while.body
  %11 = load i32* %newcount, align 4
  %12 = load i32* @Number_Of_Processors, align 4
  %cmp4 = icmp eq i32 %11, %12
  br i1 %cmp4, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %13 = load i32* %lsense, align 4
  %cmp6 = icmp eq i32 %13, 1
  br i1 %cmp6, label %if.then.13, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %14 = load i32* %newcount, align 4
  %cmp8 = icmp eq i32 %14, 0
  br i1 %cmp8, label %land.lhs.true.10, label %if.end

land.lhs.true.10:                                 ; preds = %lor.lhs.false
  %15 = load i32* %lsense, align 4
  %cmp11 = icmp eq i32 %15, -1
  br i1 %cmp11, label %if.then.13, label %if.end

if.then.13:                                       ; preds = %land.lhs.true.10, %land.lhs.true
  %16 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %16
  %17 = load %struct._G_Mem** @G_Memory, align 8
  %synch14 = getelementptr inbounds %struct._G_Mem* %17, i32 0, i32 6
  %gsense15 = getelementptr inbounds %struct.barrier_t* %synch14, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense15, align 4
  call void @Criteria(i32 1)
  br label %if.end

if.end:                                           ; preds = %if.then.13, %land.lhs.true.10, %lor.lhs.false
  br label %while.end

if.end.16:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.21, %while.end
  %18 = load %struct._G_Mem** @G_Memory, align 8
  %synch17 = getelementptr inbounds %struct._G_Mem* %18, i32 0, i32 6
  %gsense18 = getelementptr inbounds %struct.barrier_t* %synch17, i32 0, i32 0
  %19 = load volatile i32* %gsense18, align 4
  %20 = load i32* %lsense, align 4
  %cmp19 = icmp eq i32 %19, %20
  br i1 %cmp19, label %while.body.21, label %while.end.22

while.body.21:                                    ; preds = %while.cond
  br label %while.cond

while.end.22:                                     ; preds = %while.cond
  call void @Criteria(i32 1)
  %21 = load %struct._G_Mem** @G_Memory, align 8
  %count_lock = getelementptr inbounds %struct._G_Mem* %21, i32 0, i32 3
  %call23 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %count_lock)
  %22 = load %struct._G_Mem** @G_Memory, align 8
  %id = getelementptr inbounds %struct._G_Mem* %22, i32 0, i32 14
  %23 = load i32* %id, align 4
  store i32 %23, i32* %my_id, align 4
  %24 = load %struct._G_Mem** @G_Memory, align 8
  %id24 = getelementptr inbounds %struct._G_Mem* %24, i32 0, i32 14
  %25 = load i32* %id24, align 4
  %inc = add nsw i32 %25, 1
  store i32 %inc, i32* %id24, align 4
  %26 = load %struct._G_Mem** @G_Memory, align 8
  %count_lock25 = getelementptr inbounds %struct._G_Mem* %26, i32 0, i32 3
  %call26 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %count_lock25)
  %27 = load i32* %my_id, align 4
  %cmp27 = icmp eq i32 %27, 0
  br i1 %cmp27, label %if.then.29, label %if.else

if.then.29:                                       ; preds = %while.end.22
  store i32 1, i32* %time_all, align 4
  br label %if.end.32

if.else:                                          ; preds = %while.end.22
  %28 = load i32* @do_stats, align 4
  %tobool = icmp ne i32 %28, 0
  br i1 %tobool, label %if.then.30, label %if.end.31

if.then.30:                                       ; preds = %if.else
  store i32 1, i32* %time_all, align 4
  br label %if.end.31

if.end.31:                                        ; preds = %if.then.30, %if.else
  br label %if.end.32

if.end.32:                                        ; preds = %if.end.31, %if.then.29
  %29 = load i32* %my_id, align 4
  %cmp33 = icmp eq i32 %29, 0
  br i1 %cmp33, label %if.then.35, label %if.else.36

if.then.35:                                       ; preds = %if.end.32
  %30 = load i32* %my_id, align 4
  %31 = load i32* @Total_Particles, align 4
  call void @CreateParticleList(i32 %30, i32 %31)
  %32 = load i32* %my_id, align 4
  %33 = load i32* @Total_Particles, align 4
  call void @InitParticleList(i32 %32, i32 %33, i32 0)
  br label %if.end.40

if.else.36:                                       ; preds = %if.end.32
  %34 = load i32* %my_id, align 4
  %35 = load i32* @Total_Particles, align 4
  %conv37 = sitofp i32 %35 to double
  %mul = fmul double %conv37, 4.000000e+00
  %36 = load i32* @Number_Of_Processors, align 4
  %conv38 = sitofp i32 %36 to double
  %div = fdiv double %mul, %conv38
  %conv39 = fptosi double %div to i32
  call void @CreateParticleList(i32 %34, i32 %conv39)
  %37 = load i32* %my_id, align 4
  call void @InitParticleList(i32 %37, i32 0, i32 0)
  br label %if.end.40

if.end.40:                                        ; preds = %if.else.36, %if.then.35
  %38 = load i32* @Total_Particles, align 4
  %conv41 = sitofp i32 %38 to double
  %div42 = fdiv double %conv41, 1.500000e+01
  %mul43 = fmul double 1.333000e+00, %div42
  %conv44 = fptosi double %mul43 to i32
  store i32 %conv44, i32* %num_boxes, align 4
  %39 = load i32* %my_id, align 4
  %cmp45 = icmp eq i32 %39, 0
  br i1 %cmp45, label %if.then.47, label %if.else.51

if.then.47:                                       ; preds = %if.end.40
  %40 = load i32* %my_id, align 4
  %41 = load i32* %num_boxes, align 4
  %conv48 = sitofp i32 %41 to double
  %mul49 = fmul double 1.500000e+00, %conv48
  %conv50 = fptosi double %mul49 to i32
  call void @CreateBoxes(i32 %40, i32 %conv50)
  br label %if.end.61

if.else.51:                                       ; preds = %if.end.40
  %42 = load i32* %my_id, align 4
  %43 = load i32* %num_boxes, align 4
  %conv52 = sitofp i32 %43 to double
  %mul53 = fmul double 1.500000e+00, %conv52
  %44 = load i32* @Total_Particles, align 4
  %45 = load i32* @Number_Of_Processors, align 4
  %div54 = sdiv i32 %44, %45
  %cmp55 = icmp sgt i32 %div54, 128
  %cond = select i1 %cmp55, double 4.000000e+00, double 8.000000e+00
  %mul57 = fmul double %mul53, %cond
  %46 = load i32* @Number_Of_Processors, align 4
  %conv58 = sitofp i32 %46 to double
  %div59 = fdiv double %mul57, %conv58
  %conv60 = fptosi double %div59 to i32
  call void @CreateBoxes(i32 %42, i32 %conv60)
  br label %if.end.61

if.end.61:                                        ; preds = %if.else.51, %if.then.47
  %47 = load i32* %my_id, align 4
  %cmp62 = icmp eq i32 %47, 0
  br i1 %cmp62, label %if.then.64, label %if.end.68

if.then.64:                                       ; preds = %if.end.61
  %48 = load i32* @Number_Of_Processors, align 4
  %49 = load i32* @Number_Of_Processors, align 4
  %cmp65 = icmp eq i32 %49, 1
  %cond67 = select i1 %cmp65, i8* getelementptr inbounds ([1 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str.4, i32 0, i32 0)
  call void (i8*, ...) @LockedPrint(i8* getelementptr inbounds ([34 x i8]* @.str.2, i32 0, i32 0), i32 %48, i8* %cond67)
  br label %if.end.68

if.end.68:                                        ; preds = %if.then.64, %if.end.61
  %50 = load %struct._G_Mem** @G_Memory, align 8
  %synch70 = getelementptr inbounds %struct._G_Mem* %50, i32 0, i32 6
  %gsense71 = getelementptr inbounds %struct.barrier_t* %synch70, i32 0, i32 0
  %51 = load volatile i32* %gsense71, align 4
  store i32 %51, i32* %lsense69, align 4
  br label %while.body.73

while.body.73:                                    ; preds = %if.end.68, %if.end.102
  %52 = load %struct._G_Mem** @G_Memory, align 8
  %synch75 = getelementptr inbounds %struct._G_Mem* %52, i32 0, i32 6
  %count76 = getelementptr inbounds %struct.barrier_t* %synch75, i32 0, i32 1
  %53 = load volatile i64* %count76, align 8
  %conv77 = trunc i64 %53 to i32
  store i32 %conv77, i32* %oldcount74, align 4
  %54 = load i32* %oldcount74, align 4
  %55 = load i32* %lsense69, align 4
  %add79 = add nsw i32 %54, %55
  store i32 %add79, i32* %newcount78, align 4
  %56 = load i32* %oldcount74, align 4
  %57 = load i32* %newcount78, align 4
  %call82 = call i32 @atomic_cmpxchg(i32 %56, i32 %57)
  store i32 %call82, i32* %updatedcount80, align 4
  %58 = load i32* %updatedcount80, align 4
  %59 = load i32* %oldcount74, align 4
  %cmp83 = icmp eq i32 %58, %59
  br i1 %cmp83, label %if.then.85, label %if.end.102

if.then.85:                                       ; preds = %while.body.73
  %60 = load i32* %newcount78, align 4
  %61 = load i32* @Number_Of_Processors, align 4
  %cmp86 = icmp eq i32 %60, %61
  br i1 %cmp86, label %land.lhs.true.88, label %lor.lhs.false.91

land.lhs.true.88:                                 ; preds = %if.then.85
  %62 = load i32* %lsense69, align 4
  %cmp89 = icmp eq i32 %62, 1
  br i1 %cmp89, label %if.then.97, label %lor.lhs.false.91

lor.lhs.false.91:                                 ; preds = %land.lhs.true.88, %if.then.85
  %63 = load i32* %newcount78, align 4
  %cmp92 = icmp eq i32 %63, 0
  br i1 %cmp92, label %land.lhs.true.94, label %if.end.101

land.lhs.true.94:                                 ; preds = %lor.lhs.false.91
  %64 = load i32* %lsense69, align 4
  %cmp95 = icmp eq i32 %64, -1
  br i1 %cmp95, label %if.then.97, label %if.end.101

if.then.97:                                       ; preds = %land.lhs.true.94, %land.lhs.true.88
  %65 = load i32* %lsense69, align 4
  %sub98 = sub nsw i32 0, %65
  %66 = load %struct._G_Mem** @G_Memory, align 8
  %synch99 = getelementptr inbounds %struct._G_Mem* %66, i32 0, i32 6
  %gsense100 = getelementptr inbounds %struct.barrier_t* %synch99, i32 0, i32 0
  store volatile i32 %sub98, i32* %gsense100, align 4
  call void @Criteria(i32 2)
  br label %if.end.101

if.end.101:                                       ; preds = %if.then.97, %land.lhs.true.94, %lor.lhs.false.91
  br label %while.end.103

if.end.102:                                       ; preds = %while.body.73
  br label %while.body.73

while.end.103:                                    ; preds = %if.end.101
  br label %while.cond.104

while.cond.104:                                   ; preds = %while.body.109, %while.end.103
  %67 = load %struct._G_Mem** @G_Memory, align 8
  %synch105 = getelementptr inbounds %struct._G_Mem* %67, i32 0, i32 6
  %gsense106 = getelementptr inbounds %struct.barrier_t* %synch105, i32 0, i32 0
  %68 = load volatile i32* %gsense106, align 4
  %69 = load i32* %lsense69, align 4
  %cmp107 = icmp eq i32 %68, %69
  br i1 %cmp107, label %while.body.109, label %while.end.110

while.body.109:                                   ; preds = %while.cond.104
  br label %while.cond.104

while.end.110:                                    ; preds = %while.cond.104
  call void @Criteria(i32 2)
  %70 = load i32* %my_id, align 4
  %idxprom = sext i32 %70 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Time = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 19
  store double 0.000000e+00, double* %Time, align 8
  %71 = load i32* %my_id, align 4
  %idxprom111 = sext i32 %71 to i64
  %arrayidx112 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom111
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx112, i32 0, i32 18
  store i32 0, i32* %Time_Step, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end.110
  %72 = load i32* %my_id, align 4
  %idxprom113 = sext i32 %72 to i64
  %arrayidx114 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom113
  %Time_Step115 = getelementptr inbounds %struct._Local_Memory* %arrayidx114, i32 0, i32 18
  %73 = load i32* %Time_Step115, align 4
  %74 = load i32* @Time_Steps, align 4
  %cmp116 = icmp slt i32 %73, %74
  br i1 %cmp116, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %75 = load i32* %my_id, align 4
  %idxprom118 = sext i32 %75 to i64
  %arrayidx119 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom118
  %Time_Step120 = getelementptr inbounds %struct._Local_Memory* %arrayidx119, i32 0, i32 18
  %76 = load i32* %Time_Step120, align 4
  %cmp121 = icmp eq i32 %76, 2
  br i1 %cmp121, label %if.then.123, label %if.end.124

if.then.123:                                      ; preds = %for.body
  br label %if.end.124

if.end.124:                                       ; preds = %if.then.123, %for.body
  %77 = load i32* %my_id, align 4
  %idxprom125 = sext i32 %77 to i64
  %arrayidx126 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom125
  %Time_Step127 = getelementptr inbounds %struct._Local_Memory* %arrayidx126, i32 0, i32 18
  %78 = load i32* %Time_Step127, align 4
  %cmp128 = icmp eq i32 %78, 2
  br i1 %cmp128, label %if.then.130, label %if.end.139

if.then.130:                                      ; preds = %if.end.124
  %79 = load i32* @do_stats, align 4
  %tobool131 = icmp ne i32 %79, 0
  br i1 %tobool131, label %if.then.135, label %lor.lhs.false.132

lor.lhs.false.132:                                ; preds = %if.then.130
  %80 = load i32* %my_id, align 4
  %cmp133 = icmp eq i32 %80, 0
  br i1 %cmp133, label %if.then.135, label %if.end.138

if.then.135:                                      ; preds = %lor.lhs.false.132, %if.then.130
  %call136 = call i64 @time(i64* null)
  %conv137 = trunc i64 %call136 to i32
  store i32 %conv137, i32* %local_init_done, align 4
  br label %if.end.138

if.end.138:                                       ; preds = %if.then.135, %lor.lhs.false.132
  br label %if.end.139

if.end.139:                                       ; preds = %if.end.138, %if.end.124
  %81 = load i32* %my_id, align 4
  %idxprom140 = sext i32 %81 to i64
  %arrayidx141 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom140
  %Time_Step142 = getelementptr inbounds %struct._Local_Memory* %arrayidx141, i32 0, i32 18
  %82 = load i32* %Time_Step142, align 4
  %cmp143 = icmp eq i32 %82, 0
  br i1 %cmp143, label %if.then.145, label %if.else.147

if.then.145:                                      ; preds = %if.end.139
  %call146 = call i64 @time(i64* null)
  store i64 %call146, i64* %start, align 8
  br label %if.end.148

if.else.147:                                      ; preds = %if.end.139
  %83 = load i64* %finish, align 8
  store i64 %83, i64* %start, align 8
  br label %if.end.148

if.end.148:                                       ; preds = %if.else.147, %if.then.145
  %84 = load i32* %my_id, align 4
  %85 = load %struct._Time_Info** %local_time, align 8
  %86 = load i32* %time_all, align 4
  call void @ConstructGrid(i32 %84, %struct._Time_Info* %85, i32 %86)
  %87 = load i32* %my_id, align 4
  %88 = load %struct._Time_Info** %local_time, align 8
  %89 = load i32* %time_all, align 4
  call void @ConstructLists(i32 %87, %struct._Time_Info* %88, i32 %89)
  %90 = load i32* %my_id, align 4
  %91 = load %struct._Time_Info** %local_time, align 8
  %92 = load i32* %time_all, align 4
  call void @PartitionGrid(i32 %90, %struct._Time_Info* %91, i32 %92)
  %93 = load i32* %my_id, align 4
  %94 = load %struct._Time_Info** %local_time, align 8
  %95 = load i32* %time_all, align 4
  call void @StepSimulation(i32 %93, %struct._Time_Info* %94, i32 %95)
  %96 = load i32* %my_id, align 4
  %97 = load %struct._Time_Info** %local_time, align 8
  %98 = load i32* %time_all, align 4
  call void @DestroyGrid(i32 %96, %struct._Time_Info* %97, i32 %98)
  %call149 = call i64 @time(i64* null)
  store i64 %call149, i64* %finish, align 8
  %99 = load double* @Timestep_Dur, align 8
  %100 = load i32* %my_id, align 4
  %idxprom150 = sext i32 %100 to i64
  %arrayidx151 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom150
  %Time152 = getelementptr inbounds %struct._Local_Memory* %arrayidx151, i32 0, i32 19
  %101 = load double* %Time152, align 8
  %add153 = fadd double %101, %99
  store double %add153, double* %Time152, align 8
  %102 = load i64* %finish, align 8
  %103 = load i64* %start, align 8
  %sub154 = sub i64 %102, %103
  %104 = load i32* %my_id, align 4
  %idxprom155 = sext i32 %104 to i64
  %arrayidx156 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom155
  %Time_Step157 = getelementptr inbounds %struct._Local_Memory* %arrayidx156, i32 0, i32 18
  %105 = load i32* %Time_Step157, align 4
  %idxprom158 = sext i32 %105 to i64
  %106 = load i32* %my_id, align 4
  %idxprom159 = sext i32 %106 to i64
  %arrayidx160 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom159
  %Timing = getelementptr inbounds %struct._Local_Memory* %arrayidx160, i32 0, i32 21
  %arrayidx161 = getelementptr inbounds [10 x %struct._Time_Info]* %Timing, i32 0, i64 %idxprom158
  %total_time = getelementptr inbounds %struct._Time_Info* %arrayidx161, i32 0, i32 8
  store i64 %sub154, i64* %total_time, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.148
  %107 = load i32* %my_id, align 4
  %idxprom162 = sext i32 %107 to i64
  %arrayidx163 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom162
  %Time_Step164 = getelementptr inbounds %struct._Local_Memory* %arrayidx163, i32 0, i32 18
  %108 = load i32* %Time_Step164, align 4
  %inc165 = add nsw i32 %108, 1
  store i32 %inc165, i32* %Time_Step164, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %109 = load i32* %my_id, align 4
  %cmp166 = icmp eq i32 %109, 0
  br i1 %cmp166, label %if.then.168, label %if.end.171

if.then.168:                                      ; preds = %for.end
  %call169 = call i64 @time(i64* null)
  %conv170 = trunc i64 %call169 to i32
  store i32 %conv170, i32* @endtime, align 4
  br label %if.end.171

if.end.171:                                       ; preds = %if.then.168, %for.end
  %110 = load %struct._G_Mem** @G_Memory, align 8
  %synch173 = getelementptr inbounds %struct._G_Mem* %110, i32 0, i32 6
  %gsense174 = getelementptr inbounds %struct.barrier_t* %synch173, i32 0, i32 0
  %111 = load volatile i32* %gsense174, align 4
  store i32 %111, i32* %lsense172, align 4
  br label %while.body.176

while.body.176:                                   ; preds = %if.end.171, %if.end.205
  %112 = load %struct._G_Mem** @G_Memory, align 8
  %synch178 = getelementptr inbounds %struct._G_Mem* %112, i32 0, i32 6
  %count179 = getelementptr inbounds %struct.barrier_t* %synch178, i32 0, i32 1
  %113 = load volatile i64* %count179, align 8
  %conv180 = trunc i64 %113 to i32
  store i32 %conv180, i32* %oldcount177, align 4
  %114 = load i32* %oldcount177, align 4
  %115 = load i32* %lsense172, align 4
  %add182 = add nsw i32 %114, %115
  store i32 %add182, i32* %newcount181, align 4
  %116 = load i32* %oldcount177, align 4
  %117 = load i32* %newcount181, align 4
  %call185 = call i32 @atomic_cmpxchg(i32 %116, i32 %117)
  store i32 %call185, i32* %updatedcount183, align 4
  %118 = load i32* %updatedcount183, align 4
  %119 = load i32* %oldcount177, align 4
  %cmp186 = icmp eq i32 %118, %119
  br i1 %cmp186, label %if.then.188, label %if.end.205

if.then.188:                                      ; preds = %while.body.176
  %120 = load i32* %newcount181, align 4
  %121 = load i32* @Number_Of_Processors, align 4
  %cmp189 = icmp eq i32 %120, %121
  br i1 %cmp189, label %land.lhs.true.191, label %lor.lhs.false.194

land.lhs.true.191:                                ; preds = %if.then.188
  %122 = load i32* %lsense172, align 4
  %cmp192 = icmp eq i32 %122, 1
  br i1 %cmp192, label %if.then.200, label %lor.lhs.false.194

lor.lhs.false.194:                                ; preds = %land.lhs.true.191, %if.then.188
  %123 = load i32* %newcount181, align 4
  %cmp195 = icmp eq i32 %123, 0
  br i1 %cmp195, label %land.lhs.true.197, label %if.end.204

land.lhs.true.197:                                ; preds = %lor.lhs.false.194
  %124 = load i32* %lsense172, align 4
  %cmp198 = icmp eq i32 %124, -1
  br i1 %cmp198, label %if.then.200, label %if.end.204

if.then.200:                                      ; preds = %land.lhs.true.197, %land.lhs.true.191
  %125 = load i32* %lsense172, align 4
  %sub201 = sub nsw i32 0, %125
  %126 = load %struct._G_Mem** @G_Memory, align 8
  %synch202 = getelementptr inbounds %struct._G_Mem* %126, i32 0, i32 6
  %gsense203 = getelementptr inbounds %struct.barrier_t* %synch202, i32 0, i32 0
  store volatile i32 %sub201, i32* %gsense203, align 4
  call void @Criteria(i32 3)
  br label %if.end.204

if.end.204:                                       ; preds = %if.then.200, %land.lhs.true.197, %lor.lhs.false.194
  br label %while.end.206

if.end.205:                                       ; preds = %while.body.176
  br label %while.body.176

while.end.206:                                    ; preds = %if.end.204
  br label %while.cond.207

while.cond.207:                                   ; preds = %while.body.212, %while.end.206
  %127 = load %struct._G_Mem** @G_Memory, align 8
  %synch208 = getelementptr inbounds %struct._G_Mem* %127, i32 0, i32 6
  %gsense209 = getelementptr inbounds %struct.barrier_t* %synch208, i32 0, i32 0
  %128 = load volatile i32* %gsense209, align 4
  %129 = load i32* %lsense172, align 4
  %cmp210 = icmp eq i32 %128, %129
  br i1 %cmp210, label %while.body.212, label %while.end.213

while.body.212:                                   ; preds = %while.cond.207
  br label %while.cond.207

while.end.213:                                    ; preds = %while.cond.207
  call void @Criteria(i32 3)
  %130 = load i32* %my_id, align 4
  %idxprom214 = sext i32 %130 to i64
  %arrayidx215 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom214
  %Time_Step216 = getelementptr inbounds %struct._Local_Memory* %arrayidx215, i32 0, i32 18
  store i32 0, i32* %Time_Step216, align 4
  br label %for.cond.217

for.cond.217:                                     ; preds = %for.inc.280, %while.end.213
  %131 = load i32* %my_id, align 4
  %idxprom218 = sext i32 %131 to i64
  %arrayidx219 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom218
  %Time_Step220 = getelementptr inbounds %struct._Local_Memory* %arrayidx219, i32 0, i32 18
  %132 = load i32* %Time_Step220, align 4
  %133 = load i32* @Time_Steps, align 4
  %cmp221 = icmp slt i32 %132, %133
  br i1 %cmp221, label %for.body.223, label %for.end.285

for.body.223:                                     ; preds = %for.cond.217
  %134 = load i32* %my_id, align 4
  %idxprom224 = sext i32 %134 to i64
  %arrayidx225 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom224
  %Time_Step226 = getelementptr inbounds %struct._Local_Memory* %arrayidx225, i32 0, i32 18
  %135 = load i32* %Time_Step226, align 4
  %idxprom227 = sext i32 %135 to i64
  %136 = load i32* %my_id, align 4
  %idxprom228 = sext i32 %136 to i64
  %arrayidx229 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom228
  %Timing230 = getelementptr inbounds %struct._Local_Memory* %arrayidx229, i32 0, i32 21
  %arrayidx231 = getelementptr inbounds [10 x %struct._Time_Info]* %Timing230, i32 0, i64 %idxprom227
  store %struct._Time_Info* %arrayidx231, %struct._Time_Info** %timing, align 8
  %137 = load i32* %my_id, align 4
  %idxprom232 = sext i32 %137 to i64
  %arrayidx233 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom232
  %Time_Step234 = getelementptr inbounds %struct._Local_Memory* %arrayidx233, i32 0, i32 18
  %138 = load i32* %Time_Step234, align 4
  %idxprom235 = sext i32 %138 to i64
  %139 = load %struct._Time_Info** %local_time, align 8
  %arrayidx236 = getelementptr inbounds %struct._Time_Info* %139, i64 %idxprom235
  %other_time = getelementptr inbounds %struct._Time_Info* %arrayidx236, i32 0, i32 7
  %140 = load i64* %other_time, align 8
  %141 = load %struct._Time_Info** %timing, align 8
  %other_time237 = getelementptr inbounds %struct._Time_Info* %141, i32 0, i32 7
  store i64 %140, i64* %other_time237, align 8
  %142 = load i32* %my_id, align 4
  %idxprom238 = sext i32 %142 to i64
  %arrayidx239 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom238
  %Time_Step240 = getelementptr inbounds %struct._Local_Memory* %arrayidx239, i32 0, i32 18
  %143 = load i32* %Time_Step240, align 4
  %idxprom241 = sext i32 %143 to i64
  %144 = load %struct._Time_Info** %local_time, align 8
  %arrayidx242 = getelementptr inbounds %struct._Time_Info* %144, i64 %idxprom241
  %construct_time = getelementptr inbounds %struct._Time_Info* %arrayidx242, i32 0, i32 0
  %145 = load i64* %construct_time, align 8
  %146 = load %struct._Time_Info** %timing, align 8
  %construct_time243 = getelementptr inbounds %struct._Time_Info* %146, i32 0, i32 0
  store i64 %145, i64* %construct_time243, align 8
  %147 = load i32* %my_id, align 4
  %idxprom244 = sext i32 %147 to i64
  %arrayidx245 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom244
  %Time_Step246 = getelementptr inbounds %struct._Local_Memory* %arrayidx245, i32 0, i32 18
  %148 = load i32* %Time_Step246, align 4
  %idxprom247 = sext i32 %148 to i64
  %149 = load %struct._Time_Info** %local_time, align 8
  %arrayidx248 = getelementptr inbounds %struct._Time_Info* %149, i64 %idxprom247
  %list_time = getelementptr inbounds %struct._Time_Info* %arrayidx248, i32 0, i32 1
  %150 = load i64* %list_time, align 8
  %151 = load %struct._Time_Info** %timing, align 8
  %list_time249 = getelementptr inbounds %struct._Time_Info* %151, i32 0, i32 1
  store i64 %150, i64* %list_time249, align 8
  %152 = load i32* %my_id, align 4
  %idxprom250 = sext i32 %152 to i64
  %arrayidx251 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom250
  %Time_Step252 = getelementptr inbounds %struct._Local_Memory* %arrayidx251, i32 0, i32 18
  %153 = load i32* %Time_Step252, align 4
  %idxprom253 = sext i32 %153 to i64
  %154 = load %struct._Time_Info** %local_time, align 8
  %arrayidx254 = getelementptr inbounds %struct._Time_Info* %154, i64 %idxprom253
  %partition_time = getelementptr inbounds %struct._Time_Info* %arrayidx254, i32 0, i32 2
  %155 = load i64* %partition_time, align 8
  %156 = load %struct._Time_Info** %timing, align 8
  %partition_time255 = getelementptr inbounds %struct._Time_Info* %156, i32 0, i32 2
  store i64 %155, i64* %partition_time255, align 8
  %157 = load i32* %my_id, align 4
  %idxprom256 = sext i32 %157 to i64
  %arrayidx257 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom256
  %Time_Step258 = getelementptr inbounds %struct._Local_Memory* %arrayidx257, i32 0, i32 18
  %158 = load i32* %Time_Step258, align 4
  %idxprom259 = sext i32 %158 to i64
  %159 = load %struct._Time_Info** %local_time, align 8
  %arrayidx260 = getelementptr inbounds %struct._Time_Info* %159, i64 %idxprom259
  %pass_time = getelementptr inbounds %struct._Time_Info* %arrayidx260, i32 0, i32 4
  %160 = load i64* %pass_time, align 8
  %161 = load %struct._Time_Info** %timing, align 8
  %pass_time261 = getelementptr inbounds %struct._Time_Info* %161, i32 0, i32 4
  store i64 %160, i64* %pass_time261, align 8
  %162 = load i32* %my_id, align 4
  %idxprom262 = sext i32 %162 to i64
  %arrayidx263 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom262
  %Time_Step264 = getelementptr inbounds %struct._Local_Memory* %arrayidx263, i32 0, i32 18
  %163 = load i32* %Time_Step264, align 4
  %idxprom265 = sext i32 %163 to i64
  %164 = load %struct._Time_Info** %local_time, align 8
  %arrayidx266 = getelementptr inbounds %struct._Time_Info* %164, i64 %idxprom265
  %inter_time = getelementptr inbounds %struct._Time_Info* %arrayidx266, i32 0, i32 3
  %165 = load i64* %inter_time, align 8
  %166 = load %struct._Time_Info** %timing, align 8
  %inter_time267 = getelementptr inbounds %struct._Time_Info* %166, i32 0, i32 3
  store i64 %165, i64* %inter_time267, align 8
  %167 = load i32* %my_id, align 4
  %idxprom268 = sext i32 %167 to i64
  %arrayidx269 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom268
  %Time_Step270 = getelementptr inbounds %struct._Local_Memory* %arrayidx269, i32 0, i32 18
  %168 = load i32* %Time_Step270, align 4
  %idxprom271 = sext i32 %168 to i64
  %169 = load %struct._Time_Info** %local_time, align 8
  %arrayidx272 = getelementptr inbounds %struct._Time_Info* %169, i64 %idxprom271
  %barrier_time = getelementptr inbounds %struct._Time_Info* %arrayidx272, i32 0, i32 6
  %170 = load i64* %barrier_time, align 8
  %171 = load %struct._Time_Info** %timing, align 8
  %barrier_time273 = getelementptr inbounds %struct._Time_Info* %171, i32 0, i32 6
  store i64 %170, i64* %barrier_time273, align 8
  %172 = load i32* %my_id, align 4
  %idxprom274 = sext i32 %172 to i64
  %arrayidx275 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom274
  %Time_Step276 = getelementptr inbounds %struct._Local_Memory* %arrayidx275, i32 0, i32 18
  %173 = load i32* %Time_Step276, align 4
  %idxprom277 = sext i32 %173 to i64
  %174 = load %struct._Time_Info** %local_time, align 8
  %arrayidx278 = getelementptr inbounds %struct._Time_Info* %174, i64 %idxprom277
  %intra_time = getelementptr inbounds %struct._Time_Info* %arrayidx278, i32 0, i32 5
  %175 = load i64* %intra_time, align 8
  %176 = load %struct._Time_Info** %timing, align 8
  %intra_time279 = getelementptr inbounds %struct._Time_Info* %176, i32 0, i32 5
  store i64 %175, i64* %intra_time279, align 8
  br label %for.inc.280

for.inc.280:                                      ; preds = %for.body.223
  %177 = load i32* %my_id, align 4
  %idxprom281 = sext i32 %177 to i64
  %arrayidx282 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom281
  %Time_Step283 = getelementptr inbounds %struct._Local_Memory* %arrayidx282, i32 0, i32 18
  %178 = load i32* %Time_Step283, align 4
  %inc284 = add nsw i32 %178, 1
  store i32 %inc284, i32* %Time_Step283, align 4
  br label %for.cond.217

for.end.285:                                      ; preds = %for.cond.217
  %179 = load i32* %local_init_done, align 4
  %180 = load i32* %my_id, align 4
  %idxprom286 = sext i32 %180 to i64
  %arrayidx287 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom286
  %init_done_times = getelementptr inbounds %struct._Local_Memory* %arrayidx287, i32 0, i32 20
  store i32 %179, i32* %init_done_times, align 4
  %181 = load %struct._G_Mem** @G_Memory, align 8
  %synch289 = getelementptr inbounds %struct._G_Mem* %181, i32 0, i32 6
  %gsense290 = getelementptr inbounds %struct.barrier_t* %synch289, i32 0, i32 0
  %182 = load volatile i32* %gsense290, align 4
  store i32 %182, i32* %lsense288, align 4
  br label %while.body.292

while.body.292:                                   ; preds = %for.end.285, %if.end.321
  %183 = load %struct._G_Mem** @G_Memory, align 8
  %synch294 = getelementptr inbounds %struct._G_Mem* %183, i32 0, i32 6
  %count295 = getelementptr inbounds %struct.barrier_t* %synch294, i32 0, i32 1
  %184 = load volatile i64* %count295, align 8
  %conv296 = trunc i64 %184 to i32
  store i32 %conv296, i32* %oldcount293, align 4
  %185 = load i32* %oldcount293, align 4
  %186 = load i32* %lsense288, align 4
  %add298 = add nsw i32 %185, %186
  store i32 %add298, i32* %newcount297, align 4
  %187 = load i32* %oldcount293, align 4
  %188 = load i32* %newcount297, align 4
  %call301 = call i32 @atomic_cmpxchg(i32 %187, i32 %188)
  store i32 %call301, i32* %updatedcount299, align 4
  %189 = load i32* %updatedcount299, align 4
  %190 = load i32* %oldcount293, align 4
  %cmp302 = icmp eq i32 %189, %190
  br i1 %cmp302, label %if.then.304, label %if.end.321

if.then.304:                                      ; preds = %while.body.292
  %191 = load i32* %newcount297, align 4
  %192 = load i32* @Number_Of_Processors, align 4
  %cmp305 = icmp eq i32 %191, %192
  br i1 %cmp305, label %land.lhs.true.307, label %lor.lhs.false.310

land.lhs.true.307:                                ; preds = %if.then.304
  %193 = load i32* %lsense288, align 4
  %cmp308 = icmp eq i32 %193, 1
  br i1 %cmp308, label %if.then.316, label %lor.lhs.false.310

lor.lhs.false.310:                                ; preds = %land.lhs.true.307, %if.then.304
  %194 = load i32* %newcount297, align 4
  %cmp311 = icmp eq i32 %194, 0
  br i1 %cmp311, label %land.lhs.true.313, label %if.end.320

land.lhs.true.313:                                ; preds = %lor.lhs.false.310
  %195 = load i32* %lsense288, align 4
  %cmp314 = icmp eq i32 %195, -1
  br i1 %cmp314, label %if.then.316, label %if.end.320

if.then.316:                                      ; preds = %land.lhs.true.313, %land.lhs.true.307
  %196 = load i32* %lsense288, align 4
  %sub317 = sub nsw i32 0, %196
  %197 = load %struct._G_Mem** @G_Memory, align 8
  %synch318 = getelementptr inbounds %struct._G_Mem* %197, i32 0, i32 6
  %gsense319 = getelementptr inbounds %struct.barrier_t* %synch318, i32 0, i32 0
  store volatile i32 %sub317, i32* %gsense319, align 4
  call void @Criteria(i32 4)
  br label %if.end.320

if.end.320:                                       ; preds = %if.then.316, %land.lhs.true.313, %lor.lhs.false.310
  br label %while.end.322

if.end.321:                                       ; preds = %while.body.292
  br label %while.body.292

while.end.322:                                    ; preds = %if.end.320
  br label %while.cond.323

while.cond.323:                                   ; preds = %while.body.328, %while.end.322
  %198 = load %struct._G_Mem** @G_Memory, align 8
  %synch324 = getelementptr inbounds %struct._G_Mem* %198, i32 0, i32 6
  %gsense325 = getelementptr inbounds %struct.barrier_t* %synch324, i32 0, i32 0
  %199 = load volatile i32* %gsense325, align 4
  %200 = load i32* %lsense288, align 4
  %cmp326 = icmp eq i32 %199, %200
  br i1 %cmp326, label %while.body.328, label %while.end.329

while.body.328:                                   ; preds = %while.cond.323
  br label %while.cond.323

while.end.329:                                    ; preds = %while.cond.323
  call void @Criteria(i32 4)
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64)

declare void @Criteria(i32)

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

declare void @CreateParticleList(i32, i32)

declare void @InitParticleList(i32, i32, i32)

declare void @CreateBoxes(i32, i32)

declare void @LockedPrint(i8*, ...)

declare void @ConstructGrid(i32, %struct._Time_Info*, i32)

declare void @ConstructLists(i32, %struct._Time_Info*, i32)

; Function Attrs: nounwind uwtable
define void @PartitionGrid(i32 %my_id, %struct._Time_Info* %local_time, i32 %time_all) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_time.addr = alloca %struct._Time_Info*, align 8
  %time_all.addr = alloca i32, align 4
  %start = alloca i64, align 8
  %finish = alloca i64, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Time_Info* %local_time, %struct._Time_Info** %local_time.addr, align 8
  store i32 %time_all, i32* %time_all.addr, align 4
  %0 = load i32* %time_all.addr, align 4
  %tobool = icmp ne i32 %0, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = call i64 @time(i64* null)
  store i64 %call, i64* %start, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %1 = load i32* @Partition_Flag, align 4
  %cmp = icmp eq i32 %1, 1
  br i1 %cmp, label %if.then.1, label %if.else

if.then.1:                                        ; preds = %if.end
  %2 = load i32* %my_id.addr, align 4
  call void @CostZones(i32 %2)
  br label %if.end.2

if.else:                                          ; preds = %if.end
  br label %if.end.2

if.end.2:                                         ; preds = %if.else, %if.then.1
  %3 = load i32* %time_all.addr, align 4
  %tobool3 = icmp ne i32 %3, 0
  br i1 %tobool3, label %if.then.4, label %if.end.6

if.then.4:                                        ; preds = %if.end.2
  %call5 = call i64 @time(i64* null)
  store i64 %call5, i64* %finish, align 8
  br label %if.end.6

if.end.6:                                         ; preds = %if.then.4, %if.end.2
  %4 = load i32* %time_all.addr, align 4
  %tobool7 = icmp ne i32 %4, 0
  br i1 %tobool7, label %if.then.8, label %if.end.11

if.then.8:                                        ; preds = %if.end.6
  %5 = load i64* %finish, align 8
  %6 = load i64* %start, align 8
  %sub = sub i64 %5, %6
  %7 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %7 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 18
  %8 = load i32* %Time_Step, align 4
  %idxprom9 = sext i32 %8 to i64
  %9 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx10 = getelementptr inbounds %struct._Time_Info* %9, i64 %idxprom9
  %partition_time = getelementptr inbounds %struct._Time_Info* %arrayidx10, i32 0, i32 2
  store i64 %sub, i64* %partition_time, align 8
  br label %if.end.11

if.end.11:                                        ; preds = %if.then.8, %if.end.6
  ret void
}

; Function Attrs: nounwind uwtable
define void @StepSimulation(i32 %my_id, %struct._Time_Info* %local_time, i32 %time_all) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_time.addr = alloca %struct._Time_Info*, align 8
  %time_all.addr = alloca i32, align 4
  %start = alloca i64, align 8
  %finish = alloca i64, align 8
  %upward_end = alloca i64, align 8
  %interaction_end = alloca i64, align 8
  %downward_end = alloca i64, align 8
  %barrier_end = alloca i64, align 8
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Time_Info* %local_time, %struct._Time_Info** %local_time.addr, align 8
  store i32 %time_all, i32* %time_all.addr, align 4
  %0 = load i32* %time_all.addr, align 4
  %tobool = icmp ne i32 %0, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = call i64 @time(i64* null)
  store i64 %call, i64* %start, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %1 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %1, void (i32, %struct._Box*)* @UpwardPass, i32 1)
  %2 = load i32* %time_all.addr, align 4
  %tobool1 = icmp ne i32 %2, 0
  br i1 %tobool1, label %if.then.2, label %if.end.4

if.then.2:                                        ; preds = %if.end
  %call3 = call i64 @time(i64* null)
  store i64 %call3, i64* %upward_end, align 8
  br label %if.end.4

if.end.4:                                         ; preds = %if.then.2, %if.end
  %3 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %3, void (i32, %struct._Box*)* @ComputeInteractions, i32 1)
  %4 = load i32* %time_all.addr, align 4
  %tobool5 = icmp ne i32 %4, 0
  br i1 %tobool5, label %if.then.6, label %if.end.8

if.then.6:                                        ; preds = %if.end.4
  %call7 = call i64 @time(i64* null)
  store i64 %call7, i64* %interaction_end, align 8
  br label %if.end.8

if.end.8:                                         ; preds = %if.then.6, %if.end.4
  %5 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %5, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %6 = load volatile i32* %gsense, align 4
  store i32 %6, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.8, %if.end.26
  %7 = load %struct._G_Mem** @G_Memory, align 8
  %synch9 = getelementptr inbounds %struct._G_Mem* %7, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch9, i32 0, i32 1
  %8 = load volatile i64* %count, align 8
  %conv = trunc i64 %8 to i32
  store i32 %conv, i32* %oldcount, align 4
  %9 = load i32* %oldcount, align 4
  %10 = load i32* %lsense, align 4
  %add = add nsw i32 %9, %10
  store i32 %add, i32* %newcount, align 4
  %11 = load i32* %oldcount, align 4
  %12 = load i32* %newcount, align 4
  %call10 = call i32 @atomic_cmpxchg(i32 %11, i32 %12)
  store i32 %call10, i32* %updatedcount, align 4
  %13 = load i32* %updatedcount, align 4
  %14 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %13, %14
  br i1 %cmp, label %if.then.12, label %if.end.26

if.then.12:                                       ; preds = %while.body
  %15 = load i32* %newcount, align 4
  %16 = load i32* @Number_Of_Processors, align 4
  %cmp13 = icmp eq i32 %15, %16
  br i1 %cmp13, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then.12
  %17 = load i32* %lsense, align 4
  %cmp15 = icmp eq i32 %17, 1
  br i1 %cmp15, label %if.then.22, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then.12
  %18 = load i32* %newcount, align 4
  %cmp17 = icmp eq i32 %18, 0
  br i1 %cmp17, label %land.lhs.true.19, label %if.end.25

land.lhs.true.19:                                 ; preds = %lor.lhs.false
  %19 = load i32* %lsense, align 4
  %cmp20 = icmp eq i32 %19, -1
  br i1 %cmp20, label %if.then.22, label %if.end.25

if.then.22:                                       ; preds = %land.lhs.true.19, %land.lhs.true
  %20 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %20
  %21 = load %struct._G_Mem** @G_Memory, align 8
  %synch23 = getelementptr inbounds %struct._G_Mem* %21, i32 0, i32 6
  %gsense24 = getelementptr inbounds %struct.barrier_t* %synch23, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense24, align 4
  call void @Criteria(i32 5)
  br label %if.end.25

if.end.25:                                        ; preds = %if.then.22, %land.lhs.true.19, %lor.lhs.false
  br label %while.end

if.end.26:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.25
  br label %while.cond

while.cond:                                       ; preds = %while.body.31, %while.end
  %22 = load %struct._G_Mem** @G_Memory, align 8
  %synch27 = getelementptr inbounds %struct._G_Mem* %22, i32 0, i32 6
  %gsense28 = getelementptr inbounds %struct.barrier_t* %synch27, i32 0, i32 0
  %23 = load volatile i32* %gsense28, align 4
  %24 = load i32* %lsense, align 4
  %cmp29 = icmp eq i32 %23, %24
  br i1 %cmp29, label %while.body.31, label %while.end.32

while.body.31:                                    ; preds = %while.cond
  br label %while.cond

while.end.32:                                     ; preds = %while.cond
  call void @Criteria(i32 5)
  %25 = load i32* %time_all.addr, align 4
  %tobool33 = icmp ne i32 %25, 0
  br i1 %tobool33, label %if.then.34, label %if.end.36

if.then.34:                                       ; preds = %while.end.32
  %call35 = call i64 @time(i64* null)
  store i64 %call35, i64* %barrier_end, align 8
  br label %if.end.36

if.end.36:                                        ; preds = %if.then.34, %while.end.32
  %26 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %26, void (i32, %struct._Box*)* @DownwardPass, i32 0)
  %27 = load i32* %time_all.addr, align 4
  %tobool37 = icmp ne i32 %27, 0
  br i1 %tobool37, label %if.then.38, label %if.end.40

if.then.38:                                       ; preds = %if.end.36
  %call39 = call i64 @time(i64* null)
  store i64 %call39, i64* %downward_end, align 8
  br label %if.end.40

if.end.40:                                        ; preds = %if.then.38, %if.end.36
  %28 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %28, void (i32, %struct._Box*)* @ComputeParticlePositions, i32 2)
  %29 = load i32* %time_all.addr, align 4
  %tobool41 = icmp ne i32 %29, 0
  br i1 %tobool41, label %if.then.42, label %if.end.44

if.then.42:                                       ; preds = %if.end.40
  %call43 = call i64 @time(i64* null)
  store i64 %call43, i64* %finish, align 8
  br label %if.end.44

if.end.44:                                        ; preds = %if.then.42, %if.end.40
  %30 = load i32* %time_all.addr, align 4
  %tobool45 = icmp ne i32 %30, 0
  br i1 %tobool45, label %if.then.46, label %if.end.76

if.then.46:                                       ; preds = %if.end.44
  %31 = load i64* %upward_end, align 8
  %32 = load i64* %start, align 8
  %sub47 = sub i64 %31, %32
  %33 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %33 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 18
  %34 = load i32* %Time_Step, align 4
  %idxprom48 = sext i32 %34 to i64
  %35 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx49 = getelementptr inbounds %struct._Time_Info* %35, i64 %idxprom48
  %pass_time = getelementptr inbounds %struct._Time_Info* %arrayidx49, i32 0, i32 4
  store i64 %sub47, i64* %pass_time, align 8
  %36 = load i64* %interaction_end, align 8
  %37 = load i64* %upward_end, align 8
  %sub50 = sub i64 %36, %37
  %38 = load i32* %my_id.addr, align 4
  %idxprom51 = sext i32 %38 to i64
  %arrayidx52 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom51
  %Time_Step53 = getelementptr inbounds %struct._Local_Memory* %arrayidx52, i32 0, i32 18
  %39 = load i32* %Time_Step53, align 4
  %idxprom54 = sext i32 %39 to i64
  %40 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx55 = getelementptr inbounds %struct._Time_Info* %40, i64 %idxprom54
  %inter_time = getelementptr inbounds %struct._Time_Info* %arrayidx55, i32 0, i32 3
  store i64 %sub50, i64* %inter_time, align 8
  %41 = load i64* %barrier_end, align 8
  %42 = load i64* %interaction_end, align 8
  %sub56 = sub i64 %41, %42
  %43 = load i32* %my_id.addr, align 4
  %idxprom57 = sext i32 %43 to i64
  %arrayidx58 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom57
  %Time_Step59 = getelementptr inbounds %struct._Local_Memory* %arrayidx58, i32 0, i32 18
  %44 = load i32* %Time_Step59, align 4
  %idxprom60 = sext i32 %44 to i64
  %45 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx61 = getelementptr inbounds %struct._Time_Info* %45, i64 %idxprom60
  %barrier_time = getelementptr inbounds %struct._Time_Info* %arrayidx61, i32 0, i32 6
  store i64 %sub56, i64* %barrier_time, align 8
  %46 = load i64* %downward_end, align 8
  %47 = load i64* %barrier_end, align 8
  %sub62 = sub i64 %46, %47
  %48 = load i32* %my_id.addr, align 4
  %idxprom63 = sext i32 %48 to i64
  %arrayidx64 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom63
  %Time_Step65 = getelementptr inbounds %struct._Local_Memory* %arrayidx64, i32 0, i32 18
  %49 = load i32* %Time_Step65, align 4
  %idxprom66 = sext i32 %49 to i64
  %50 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx67 = getelementptr inbounds %struct._Time_Info* %50, i64 %idxprom66
  %pass_time68 = getelementptr inbounds %struct._Time_Info* %arrayidx67, i32 0, i32 4
  %51 = load i64* %pass_time68, align 8
  %add69 = add i64 %51, %sub62
  store i64 %add69, i64* %pass_time68, align 8
  %52 = load i64* %finish, align 8
  %53 = load i64* %downward_end, align 8
  %sub70 = sub i64 %52, %53
  %54 = load i32* %my_id.addr, align 4
  %idxprom71 = sext i32 %54 to i64
  %arrayidx72 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom71
  %Time_Step73 = getelementptr inbounds %struct._Local_Memory* %arrayidx72, i32 0, i32 18
  %55 = load i32* %Time_Step73, align 4
  %idxprom74 = sext i32 %55 to i64
  %56 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx75 = getelementptr inbounds %struct._Time_Info* %56, i64 %idxprom74
  %intra_time = getelementptr inbounds %struct._Time_Info* %arrayidx75, i32 0, i32 5
  store i64 %sub70, i64* %intra_time, align 8
  br label %if.end.76

if.end.76:                                        ; preds = %if.then.46, %if.end.44
  ret void
}

declare void @DestroyGrid(i32, %struct._Time_Info*, i32)

declare void @CostZones(i32)

declare void @PartitionIterate(i32, void (i32, %struct._Box*)*, i32)

declare void @UpwardPass(i32, %struct._Box*)

declare void @ComputeInteractions(i32, %struct._Box*)

declare void @DownwardPass(i32, %struct._Box*)

declare void @ComputeParticlePositions(i32, %struct._Box*)

; Function Attrs: nounwind uwtable
define void @GetArguments() {
entry:
  %input = alloca i8*, align 8
  %call = call noalias i8* @malloc(i64 100)
  store i8* %call, i8** %input, align 8
  %0 = load i8** %input, align 8
  %cmp = icmp eq i8* %0, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load %struct._IO_FILE** @stderr, align 8
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([7 x i8]* @.str.5, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end:                                           ; preds = %entry
  %2 = load i8** %input, align 8
  %call2 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %2)
  %3 = load i8** %input, align 8
  %call3 = call i32 @strcmp(i8* %3, i8* getelementptr inbounds ([12 x i8]* @.str.6, i32 0, i32 0))
  %cmp4 = icmp eq i32 %call3, 0
  br i1 %cmp4, label %if.then.5, label %if.else

if.then.5:                                        ; preds = %if.end
  store i32 0, i32* @Cluster, align 4
  br label %if.end.17

if.else:                                          ; preds = %if.end
  %4 = load i8** %input, align 8
  %5 = load i8* %4, align 1
  %conv = sext i8 %5 to i32
  %cmp6 = icmp eq i32 %conv, 0
  br i1 %cmp6, label %if.then.11, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.else
  %6 = load i8** %input, align 8
  %call8 = call i32 @strcmp(i8* %6, i8* getelementptr inbounds ([12 x i8]* @.str.7, i32 0, i32 0))
  %cmp9 = icmp eq i32 %call8, 0
  br i1 %cmp9, label %if.then.11, label %if.else.12

if.then.11:                                       ; preds = %lor.lhs.false, %if.else
  store i32 1, i32* @Cluster, align 4
  br label %if.end.16

if.else.12:                                       ; preds = %lor.lhs.false
  %7 = load %struct._IO_FILE** @stderr, align 8
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([45 x i8]* @.str.8, i32 0, i32 0))
  %8 = load %struct._IO_FILE** @stderr, align 8
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([33 x i8]* @.str.9, i32 0, i32 0))
  %9 = load %struct._IO_FILE** @stderr, align 8
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.16:                                        ; preds = %if.then.11
  br label %if.end.17

if.end.17:                                        ; preds = %if.end.16, %if.then.5
  %10 = load i8** %input, align 8
  %call18 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %10)
  %11 = load i8** %input, align 8
  %call19 = call i32 @strcmp(i8* %11, i8* getelementptr inbounds ([8 x i8]* @.str.11, i32 0, i32 0))
  %cmp20 = icmp eq i32 %call19, 0
  br i1 %cmp20, label %if.then.22, label %if.else.23

if.then.22:                                       ; preds = %if.end.17
  store i32 0, i32* @Model, align 4
  br label %if.end.37

if.else.23:                                       ; preds = %if.end.17
  %12 = load i8** %input, align 8
  %13 = load i8* %12, align 1
  %conv24 = sext i8 %13 to i32
  %cmp25 = icmp eq i32 %conv24, 0
  br i1 %cmp25, label %if.then.31, label %lor.lhs.false.27

lor.lhs.false.27:                                 ; preds = %if.else.23
  %14 = load i8** %input, align 8
  %call28 = call i32 @strcmp(i8* %14, i8* getelementptr inbounds ([8 x i8]* @.str.12, i32 0, i32 0))
  %cmp29 = icmp eq i32 %call28, 0
  br i1 %cmp29, label %if.then.31, label %if.else.32

if.then.31:                                       ; preds = %lor.lhs.false.27, %if.else.23
  store i32 1, i32* @Model, align 4
  br label %if.end.36

if.else.32:                                       ; preds = %lor.lhs.false.27
  %15 = load %struct._IO_FILE** @stderr, align 8
  %call33 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([45 x i8]* @.str.13, i32 0, i32 0))
  %16 = load %struct._IO_FILE** @stderr, align 8
  %call34 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([25 x i8]* @.str.14, i32 0, i32 0))
  %17 = load %struct._IO_FILE** @stderr, align 8
  %call35 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.36:                                        ; preds = %if.then.31
  br label %if.end.37

if.end.37:                                        ; preds = %if.end.36, %if.then.22
  %18 = load i8** %input, align 8
  %call38 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %18)
  %conv39 = sext i32 %call38 to i64
  %19 = inttoptr i64 %conv39 to i8*
  %call40 = call i32 @atoi(i8* %19)
  store i32 %call40, i32* @Total_Particles, align 4
  %20 = load i32* @Total_Particles, align 4
  %cmp41 = icmp sle i32 %20, 0
  br i1 %cmp41, label %if.then.43, label %if.end.47

if.then.43:                                       ; preds = %if.end.37
  %21 = load %struct._IO_FILE** @stderr, align 8
  %call44 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([49 x i8]* @.str.15, i32 0, i32 0))
  %22 = load %struct._IO_FILE** @stderr, align 8
  %call45 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([17 x i8]* @.str.16, i32 0, i32 0))
  %23 = load %struct._IO_FILE** @stderr, align 8
  %call46 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.47:                                        ; preds = %if.end.37
  %24 = load i8** %input, align 8
  %call48 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %24)
  %conv49 = sext i32 %call48 to i64
  %25 = inttoptr i64 %conv49 to i8*
  %call50 = call double @atof(i8* %25)
  store double %call50, double* @Precision, align 8
  %26 = load double* @Precision, align 8
  %cmp51 = fcmp oeq double %26, 0.000000e+00
  br i1 %cmp51, label %if.then.53, label %if.end.56

if.then.53:                                       ; preds = %if.end.47
  %27 = load %struct._IO_FILE** @stderr, align 8
  %call54 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([44 x i8]* @.str.17, i32 0, i32 0))
  %28 = load %struct._IO_FILE** @stderr, align 8
  %call55 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %28, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.56:                                        ; preds = %if.end.47
  %29 = load double* @Precision, align 8
  %call57 = call double @log(double %29)
  %call58 = call double @sqrt(double 2.000000e+00)
  %sub = fsub double 4.000000e+00, %call58
  %call59 = call double @sqrt(double 2.000000e+00)
  %div = fdiv double %sub, %call59
  %call60 = call double @log(double %div)
  %div61 = fdiv double %call57, %call60
  %sub62 = fsub double -0.000000e+00, %div61
  %call63 = call double @ceil(double %sub62)
  %conv64 = fptosi double %call63 to i32
  store i32 %conv64, i32* @Expansion_Terms, align 4
  %30 = load i32* @Expansion_Terms, align 4
  %cmp65 = icmp sgt i32 %30, 40
  br i1 %cmp65, label %if.then.67, label %if.end.70

if.then.67:                                       ; preds = %if.end.56
  %31 = load %struct._IO_FILE** @stderr, align 8
  %32 = load double* @Precision, align 8
  %33 = load i32* @Expansion_Terms, align 4
  %call68 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([48 x i8]* @.str.18, i32 0, i32 0), double %32, i32 %33)
  %34 = load %struct._IO_FILE** @stderr, align 8
  %call69 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %34, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.70:                                        ; preds = %if.end.56
  %35 = load i8** %input, align 8
  %call71 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %35)
  %conv72 = sext i32 %call71 to i64
  %36 = inttoptr i64 %conv72 to i8*
  %call73 = call i32 @atoi(i8* %36)
  store i32 %call73, i32* @Number_Of_Processors, align 4
  %37 = load i32* @Number_Of_Processors, align 4
  %cmp74 = icmp eq i32 %37, 0
  br i1 %cmp74, label %if.then.76, label %if.end.79

if.then.76:                                       ; preds = %if.end.70
  %38 = load %struct._IO_FILE** @stderr, align 8
  %call77 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %38, i8* getelementptr inbounds ([49 x i8]* @.str.19, i32 0, i32 0))
  %39 = load %struct._IO_FILE** @stderr, align 8
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.79:                                        ; preds = %if.end.70
  %40 = load i32* @Number_Of_Processors, align 4
  %cmp80 = icmp slt i32 %40, 0
  br i1 %cmp80, label %if.then.82, label %if.end.86

if.then.82:                                       ; preds = %if.end.79
  %41 = load %struct._IO_FILE** @stderr, align 8
  %call83 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([54 x i8]* @.str.20, i32 0, i32 0))
  %42 = load %struct._IO_FILE** @stderr, align 8
  %call84 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %42, i8* getelementptr inbounds ([9 x i8]* @.str.21, i32 0, i32 0))
  %43 = load %struct._IO_FILE** @stderr, align 8
  %call85 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.86:                                        ; preds = %if.end.79
  %44 = load i8** %input, align 8
  %call87 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %44)
  %conv88 = sext i32 %call87 to i64
  %45 = inttoptr i64 %conv88 to i8*
  %call89 = call i32 @atoi(i8* %45)
  store i32 %call89, i32* @Time_Steps, align 4
  %46 = load i32* @Time_Steps, align 4
  %cmp90 = icmp eq i32 %46, 0
  br i1 %cmp90, label %if.then.92, label %if.end.95

if.then.92:                                       ; preds = %if.end.86
  %47 = load %struct._IO_FILE** @stderr, align 8
  %call93 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([49 x i8]* @.str.22, i32 0, i32 0))
  %48 = load %struct._IO_FILE** @stderr, align 8
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %48, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.95:                                        ; preds = %if.end.86
  %49 = load i32* @Time_Steps, align 4
  %cmp96 = icmp slt i32 %49, 0
  br i1 %cmp96, label %if.then.98, label %if.end.102

if.then.98:                                       ; preds = %if.end.95
  %50 = load %struct._IO_FILE** @stderr, align 8
  %call99 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %50, i8* getelementptr inbounds ([50 x i8]* @.str.23, i32 0, i32 0))
  %51 = load %struct._IO_FILE** @stderr, align 8
  %call100 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([17 x i8]* @.str.16, i32 0, i32 0))
  %52 = load %struct._IO_FILE** @stderr, align 8
  %call101 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %52, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.102:                                       ; preds = %if.end.95
  %53 = load i8** %input, align 8
  %call103 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %53)
  %conv104 = sext i32 %call103 to i64
  %54 = inttoptr i64 %conv104 to i8*
  %call105 = call double @atof(i8* %54)
  store double %call105, double* @Timestep_Dur, align 8
  %55 = load double* @Timestep_Dur, align 8
  %cmp106 = fcmp oeq double %55, 0.000000e+00
  br i1 %cmp106, label %if.then.108, label %if.end.111

if.then.108:                                      ; preds = %if.end.102
  %56 = load %struct._IO_FILE** @stderr, align 8
  %call109 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %56, i8* getelementptr inbounds ([51 x i8]* @.str.24, i32 0, i32 0))
  %57 = load %struct._IO_FILE** @stderr, align 8
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %57, i8* getelementptr inbounds ([47 x i8]* @.str.25, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.111:                                       ; preds = %if.end.102
  %58 = load double* @Timestep_Dur, align 8
  %cmp112 = fcmp olt double %58, 0.000000e+00
  br i1 %cmp112, label %if.then.114, label %if.end.118

if.then.114:                                      ; preds = %if.end.111
  %59 = load %struct._IO_FILE** @stderr, align 8
  %call115 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([48 x i8]* @.str.26, i32 0, i32 0))
  %60 = load %struct._IO_FILE** @stderr, align 8
  %call116 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %60, i8* getelementptr inbounds ([24 x i8]* @.str.27, i32 0, i32 0))
  %61 = load %struct._IO_FILE** @stderr, align 8
  %call117 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.118:                                       ; preds = %if.end.111
  %62 = load i8** %input, align 8
  %call119 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %62)
  %conv120 = sext i32 %call119 to i64
  %63 = inttoptr i64 %conv120 to i8*
  %call121 = call double @atof(i8* %63)
  store double %call121, double* @Softening_Param, align 8
  %64 = load double* @Softening_Param, align 8
  %cmp122 = fcmp oeq double %64, 0.000000e+00
  br i1 %cmp122, label %if.then.124, label %if.end.125

if.then.124:                                      ; preds = %if.end.118
  store double 0xFFFFFFFFFFFFF, double* @Softening_Param, align 8
  br label %if.end.125

if.end.125:                                       ; preds = %if.then.124, %if.end.118
  %65 = load double* @Softening_Param, align 8
  %cmp126 = fcmp olt double %65, 0.000000e+00
  br i1 %cmp126, label %if.then.128, label %if.end.132

if.then.128:                                      ; preds = %if.end.125
  %66 = load %struct._IO_FILE** @stderr, align 8
  %call129 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %66, i8* getelementptr inbounds ([51 x i8]* @.str.28, i32 0, i32 0))
  %67 = load %struct._IO_FILE** @stderr, align 8
  %call130 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %67, i8* getelementptr inbounds ([17 x i8]* @.str.16, i32 0, i32 0))
  %68 = load %struct._IO_FILE** @stderr, align 8
  %call131 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %68, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.132:                                       ; preds = %if.end.125
  %69 = load i8** %input, align 8
  %call133 = call i32 (i8*, ...) *bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %69)
  %70 = load i8** %input, align 8
  %71 = load i8* %70, align 1
  %conv134 = sext i8 %71 to i32
  %cmp135 = icmp eq i32 %conv134, 0
  br i1 %cmp135, label %if.then.141, label %lor.lhs.false.137

lor.lhs.false.137:                                ; preds = %if.end.132
  %72 = load i8** %input, align 8
  %call138 = call i32 @strcmp(i8* %72, i8* getelementptr inbounds ([11 x i8]* @.str.29, i32 0, i32 0))
  %cmp139 = icmp eq i32 %call138, 0
  br i1 %cmp139, label %if.then.141, label %if.else.142

if.then.141:                                      ; preds = %lor.lhs.false.137, %if.end.132
  store i32 1, i32* @Partition_Flag, align 4
  br label %if.end.152

if.else.142:                                      ; preds = %lor.lhs.false.137
  %73 = load i8** %input, align 8
  %call143 = call i32 @strcmp(i8* %73, i8* getelementptr inbounds ([4 x i8]* @.str.30, i32 0, i32 0))
  %cmp144 = icmp eq i32 %call143, 0
  br i1 %cmp144, label %if.then.146, label %if.else.147

if.then.146:                                      ; preds = %if.else.142
  store i32 0, i32* @Partition_Flag, align 4
  br label %if.end.151

if.else.147:                                      ; preds = %if.else.142
  %74 = load %struct._IO_FILE** @stderr, align 8
  %call148 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %74, i8* getelementptr inbounds ([48 x i8]* @.str.31, i32 0, i32 0))
  %75 = load %struct._IO_FILE** @stderr, align 8
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([31 x i8]* @.str.32, i32 0, i32 0))
  %76 = load %struct._IO_FILE** @stderr, align 8
  %call150 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %76, i8* getelementptr inbounds ([39 x i8]* @.str.10, i32 0, i32 0))
  call void @exit(i32 -1)
  unreachable

if.end.151:                                       ; preds = %if.then.146
  br label %if.end.152

if.end.152:                                       ; preds = %if.end.151, %if.then.141
  ret void
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

declare i32 @gets(...)

declare i32 @strcmp(i8*, i8*)

; Function Attrs: nounwind readonly
declare i32 @atoi(i8*)

; Function Attrs: nounwind readonly
declare double @atof(i8*)

; Function Attrs: nounwind readnone
declare double @ceil(double)

; Function Attrs: nounwind
declare double @log(double)

; Function Attrs: nounwind
declare double @sqrt(double)

; Function Attrs: nounwind uwtable
define void @PrintTimes() {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %timing = alloca %struct._Time_Info*, align 8
  %fp = alloca %struct._IO_FILE*, align 8
  %t_total_time = alloca double, align 8
  %t_tree_time = alloca double, align 8
  %t_list_time = alloca double, align 8
  %t_part_time = alloca double, align 8
  %t_pass_time = alloca double, align 8
  %t_inter_time = alloca double, align 8
  %t_bar_time = alloca double, align 8
  %t_intra_time = alloca double, align 8
  %t_other_time = alloca double, align 8
  %total_time = alloca double, align 8
  %tree_time = alloca double, align 8
  %list_time = alloca double, align 8
  %part_time = alloca double, align 8
  %pass_time = alloca double, align 8
  %inter_time = alloca double, align 8
  %bar_time = alloca double, align 8
  %intra_time = alloca double, align 8
  %other_time = alloca double, align 8
  %overall_total = alloca double, align 8
  %P = alloca i32, align 4
  %init_done = alloca i32, align 4
  store double 0.000000e+00, double* %t_total_time, align 8
  store double 0.000000e+00, double* %t_tree_time, align 8
  store double 0.000000e+00, double* %t_list_time, align 8
  store double 0.000000e+00, double* %t_part_time, align 8
  store double 0.000000e+00, double* %t_pass_time, align 8
  store double 0.000000e+00, double* %t_inter_time, align 8
  store double 0.000000e+00, double* %t_bar_time, align 8
  store double 0.000000e+00, double* %t_intra_time, align 8
  store double 0.000000e+00, double* %t_other_time, align 8
  store double 0.000000e+00, double* %overall_total, align 8
  %call = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([6 x i8]* @.str.33, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str.34, i32 0, i32 0))
  store %struct._IO_FILE* %call, %struct._IO_FILE** %fp, align 8
  %cmp = icmp eq %struct._IO_FILE* %call, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %0 = load %struct._IO_FILE** @stderr, align 8
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([27 x i8]* @.str.35, i32 0, i32 0))
  %1 = load %struct._IO_FILE** @stderr, align 8
  %call2 = call i32 @fflush(%struct._IO_FILE* %1)
  call void @exit(i32 -1)
  unreachable

if.end:                                           ; preds = %entry
  %2 = load %struct._IO_FILE** %fp, align 8
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([9 x i8]* @.str.36, i32 0, i32 0))
  %3 = load %struct._IO_FILE** %fp, align 8
  %4 = load i32* @Number_Of_Processors, align 4
  %5 = load i32* @Total_Particles, align 4
  %6 = load double* @Precision, align 8
  %7 = load i32* @Time_Steps, align 4
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str.37, i32 0, i32 0), i32 %4, i32 %5, double %6, i32 %7)
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.31, %if.end
  %8 = load i32* %i, align 4
  %9 = load i32* @Time_Steps, align 4
  %cmp5 = icmp slt i32 %8, %9
  br i1 %cmp5, label %for.body, label %for.end.33

for.body:                                         ; preds = %for.cond
  %10 = load %struct._IO_FILE** %fp, align 8
  %11 = load i32* %i, align 4
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([14 x i8]* @.str.38, i32 0, i32 0), i32 %11)
  store i32 0, i32* %j, align 4
  br label %for.cond.7

for.cond.7:                                       ; preds = %for.inc, %for.body
  %12 = load i32* %j, align 4
  %13 = load i32* @Number_Of_Processors, align 4
  %cmp8 = icmp slt i32 %12, %13
  br i1 %cmp8, label %for.body.9, label %for.end

for.body.9:                                       ; preds = %for.cond.7
  %14 = load i32* %i, align 4
  %idxprom = sext i32 %14 to i64
  %15 = load i32* %j, align 4
  %idxprom10 = sext i32 %15 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom10
  %Timing = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 21
  %arrayidx11 = getelementptr inbounds [10 x %struct._Time_Info]* %Timing, i32 0, i64 %idxprom
  store %struct._Time_Info* %arrayidx11, %struct._Time_Info** %timing, align 8
  %16 = load %struct._IO_FILE** %fp, align 8
  %17 = load i32* %j, align 4
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([14 x i8]* @.str.39, i32 0, i32 0), i32 %17)
  %18 = load %struct._IO_FILE** %fp, align 8
  %19 = load %struct._Time_Info** %timing, align 8
  %total_time13 = getelementptr inbounds %struct._Time_Info* %19, i32 0, i32 8
  %20 = load i64* %total_time13, align 8
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([19 x i8]* @.str.40, i32 0, i32 0), i64 %20)
  %21 = load i32* @do_stats, align 4
  %tobool = icmp ne i32 %21, 0
  br i1 %tobool, label %if.then.15, label %if.end.29

if.then.15:                                       ; preds = %for.body.9
  %22 = load %struct._IO_FILE** %fp, align 8
  %23 = load %struct._Time_Info** %timing, align 8
  %construct_time = getelementptr inbounds %struct._Time_Info* %23, i32 0, i32 0
  %24 = load i64* %construct_time, align 8
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([31 x i8]* @.str.41, i32 0, i32 0), i64 %24)
  %25 = load %struct._IO_FILE** %fp, align 8
  %26 = load %struct._Time_Info** %timing, align 8
  %list_time17 = getelementptr inbounds %struct._Time_Info* %26, i32 0, i32 1
  %27 = load i64* %list_time17, align 8
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([31 x i8]* @.str.42, i32 0, i32 0), i64 %27)
  %28 = load %struct._IO_FILE** %fp, align 8
  %29 = load %struct._Time_Info** %timing, align 8
  %partition_time = getelementptr inbounds %struct._Time_Info* %29, i32 0, i32 2
  %30 = load i64* %partition_time, align 8
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %28, i8* getelementptr inbounds ([23 x i8]* @.str.43, i32 0, i32 0), i64 %30)
  %31 = load %struct._IO_FILE** %fp, align 8
  %32 = load %struct._Time_Info** %timing, align 8
  %pass_time20 = getelementptr inbounds %struct._Time_Info* %32, i32 0, i32 4
  %33 = load i64* %pass_time20, align 8
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([23 x i8]* @.str.44, i32 0, i32 0), i64 %33)
  %34 = load %struct._IO_FILE** %fp, align 8
  %35 = load %struct._Time_Info** %timing, align 8
  %inter_time22 = getelementptr inbounds %struct._Time_Info* %35, i32 0, i32 3
  %36 = load i64* %inter_time22, align 8
  %call23 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %34, i8* getelementptr inbounds ([28 x i8]* @.str.45, i32 0, i32 0), i64 %36)
  %37 = load %struct._IO_FILE** %fp, align 8
  %38 = load %struct._Time_Info** %timing, align 8
  %barrier_time = getelementptr inbounds %struct._Time_Info* %38, i32 0, i32 6
  %39 = load i64* %barrier_time, align 8
  %call24 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([21 x i8]* @.str.46, i32 0, i32 0), i64 %39)
  %40 = load %struct._IO_FILE** %fp, align 8
  %41 = load %struct._Time_Info** %timing, align 8
  %intra_time25 = getelementptr inbounds %struct._Time_Info* %41, i32 0, i32 5
  %42 = load i64* %intra_time25, align 8
  %call26 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %40, i8* getelementptr inbounds ([28 x i8]* @.str.47, i32 0, i32 0), i64 %42)
  %43 = load %struct._IO_FILE** %fp, align 8
  %44 = load %struct._Time_Info** %timing, align 8
  %other_time27 = getelementptr inbounds %struct._Time_Info* %44, i32 0, i32 7
  %45 = load i64* %other_time27, align 8
  %call28 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([19 x i8]* @.str.48, i32 0, i32 0), i64 %45)
  br label %if.end.29

if.end.29:                                        ; preds = %if.then.15, %for.body.9
  %46 = load %struct._IO_FILE** %fp, align 8
  %call30 = call i32 @fflush(%struct._IO_FILE* %46)
  br label %for.inc

for.inc:                                          ; preds = %if.end.29
  %47 = load i32* %j, align 4
  %inc = add nsw i32 %47, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond.7

for.end:                                          ; preds = %for.cond.7
  br label %for.inc.31

for.inc.31:                                       ; preds = %for.end
  %48 = load i32* %i, align 4
  %inc32 = add nsw i32 %48, 1
  store i32 %inc32, i32* %i, align 4
  br label %for.cond

for.end.33:                                       ; preds = %for.cond
  %49 = load %struct._IO_FILE** %fp, align 8
  %call34 = call i32 (%struct._IO_FILE*, i8*, ...) *@fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([5 x i8]* @.str.49, i32 0, i32 0))
  %50 = load %struct._IO_FILE** %fp, align 8
  %call35 = call i32 @fclose(%struct._IO_FILE* %50)
  %call36 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.50, i32 0, i32 0))
  %call37 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([116 x i8]* @.str.51, i32 0, i32 0))
  %call38 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([115 x i8]* @.str.52, i32 0, i32 0))
  store double 0.000000e+00, double* %other_time, align 8
  store double 0.000000e+00, double* %intra_time, align 8
  store double 0.000000e+00, double* %bar_time, align 8
  store double 0.000000e+00, double* %inter_time, align 8
  store double 0.000000e+00, double* %pass_time, align 8
  store double 0.000000e+00, double* %part_time, align 8
  store double 0.000000e+00, double* %list_time, align 8
  store double 0.000000e+00, double* %tree_time, align 8
  store double 0.000000e+00, double* %total_time, align 8
  store i32 2, i32* %i, align 4
  br label %for.cond.39

for.cond.39:                                      ; preds = %for.inc.69, %for.end.33
  %51 = load i32* %i, align 4
  %52 = load i32* @Time_Steps, align 4
  %cmp40 = icmp slt i32 %51, %52
  br i1 %cmp40, label %for.body.41, label %for.end.71

for.body.41:                                      ; preds = %for.cond.39
  %53 = load i32* %i, align 4
  %idxprom42 = sext i32 %53 to i64
  %arrayidx43 = getelementptr inbounds [10 x %struct._Time_Info]* getelementptr inbounds ([64 x %struct._Local_Memory]* @Local, i32 0, i64 0, i32 21), i32 0, i64 %idxprom42
  store %struct._Time_Info* %arrayidx43, %struct._Time_Info** %timing, align 8
  %54 = load %struct._Time_Info** %timing, align 8
  %total_time44 = getelementptr inbounds %struct._Time_Info* %54, i32 0, i32 8
  %55 = load i64* %total_time44, align 8
  %conv = uitofp i64 %55 to double
  %56 = load double* %total_time, align 8
  %add = fadd double %56, %conv
  store double %add, double* %total_time, align 8
  %57 = load %struct._Time_Info** %timing, align 8
  %construct_time45 = getelementptr inbounds %struct._Time_Info* %57, i32 0, i32 0
  %58 = load i64* %construct_time45, align 8
  %conv46 = uitofp i64 %58 to double
  %59 = load double* %tree_time, align 8
  %add47 = fadd double %59, %conv46
  store double %add47, double* %tree_time, align 8
  %60 = load %struct._Time_Info** %timing, align 8
  %list_time48 = getelementptr inbounds %struct._Time_Info* %60, i32 0, i32 1
  %61 = load i64* %list_time48, align 8
  %conv49 = uitofp i64 %61 to double
  %62 = load double* %list_time, align 8
  %add50 = fadd double %62, %conv49
  store double %add50, double* %list_time, align 8
  %63 = load %struct._Time_Info** %timing, align 8
  %partition_time51 = getelementptr inbounds %struct._Time_Info* %63, i32 0, i32 2
  %64 = load i64* %partition_time51, align 8
  %conv52 = uitofp i64 %64 to double
  %65 = load double* %part_time, align 8
  %add53 = fadd double %65, %conv52
  store double %add53, double* %part_time, align 8
  %66 = load %struct._Time_Info** %timing, align 8
  %pass_time54 = getelementptr inbounds %struct._Time_Info* %66, i32 0, i32 4
  %67 = load i64* %pass_time54, align 8
  %conv55 = uitofp i64 %67 to double
  %68 = load double* %pass_time, align 8
  %add56 = fadd double %68, %conv55
  store double %add56, double* %pass_time, align 8
  %69 = load %struct._Time_Info** %timing, align 8
  %inter_time57 = getelementptr inbounds %struct._Time_Info* %69, i32 0, i32 3
  %70 = load i64* %inter_time57, align 8
  %conv58 = uitofp i64 %70 to double
  %71 = load double* %inter_time, align 8
  %add59 = fadd double %71, %conv58
  store double %add59, double* %inter_time, align 8
  %72 = load %struct._Time_Info** %timing, align 8
  %barrier_time60 = getelementptr inbounds %struct._Time_Info* %72, i32 0, i32 6
  %73 = load i64* %barrier_time60, align 8
  %conv61 = uitofp i64 %73 to double
  %74 = load double* %bar_time, align 8
  %add62 = fadd double %74, %conv61
  store double %add62, double* %bar_time, align 8
  %75 = load %struct._Time_Info** %timing, align 8
  %intra_time63 = getelementptr inbounds %struct._Time_Info* %75, i32 0, i32 5
  %76 = load i64* %intra_time63, align 8
  %conv64 = uitofp i64 %76 to double
  %77 = load double* %intra_time, align 8
  %add65 = fadd double %77, %conv64
  store double %add65, double* %intra_time, align 8
  %78 = load %struct._Time_Info** %timing, align 8
  %other_time66 = getelementptr inbounds %struct._Time_Info* %78, i32 0, i32 7
  %79 = load i64* %other_time66, align 8
  %conv67 = uitofp i64 %79 to double
  %80 = load double* %other_time, align 8
  %add68 = fadd double %80, %conv67
  store double %add68, double* %other_time, align 8
  br label %for.inc.69

for.inc.69:                                       ; preds = %for.body.41
  %81 = load i32* %i, align 4
  %inc70 = add nsw i32 %81, 1
  store i32 %inc70, i32* %i, align 4
  br label %for.cond.39

for.end.71:                                       ; preds = %for.cond.39
  %82 = load double* %total_time, align 8
  %83 = load double* %tree_time, align 8
  %84 = load double* %list_time, align 8
  %85 = load double* %part_time, align 8
  %86 = load double* %pass_time, align 8
  %87 = load double* %inter_time, align 8
  %88 = load double* %bar_time, align 8
  %89 = load double* %intra_time, align 8
  %90 = load double* %other_time, align 8
  %call72 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([61 x i8]* @.str.53, i32 0, i32 0), i32 0, double %82, double %83, double %84, double %85, double %86, double %87, double %88, double %89, double %90)
  %91 = load double* %total_time, align 8
  %92 = load double* %t_total_time, align 8
  %add73 = fadd double %92, %91
  store double %add73, double* %t_total_time, align 8
  %93 = load double* %tree_time, align 8
  %94 = load double* %t_tree_time, align 8
  %add74 = fadd double %94, %93
  store double %add74, double* %t_tree_time, align 8
  %95 = load double* %list_time, align 8
  %96 = load double* %t_list_time, align 8
  %add75 = fadd double %96, %95
  store double %add75, double* %t_list_time, align 8
  %97 = load double* %part_time, align 8
  %98 = load double* %t_part_time, align 8
  %add76 = fadd double %98, %97
  store double %add76, double* %t_part_time, align 8
  %99 = load double* %pass_time, align 8
  %100 = load double* %t_pass_time, align 8
  %add77 = fadd double %100, %99
  store double %add77, double* %t_pass_time, align 8
  %101 = load double* %inter_time, align 8
  %102 = load double* %t_inter_time, align 8
  %add78 = fadd double %102, %101
  store double %add78, double* %t_inter_time, align 8
  %103 = load double* %bar_time, align 8
  %104 = load double* %t_bar_time, align 8
  %add79 = fadd double %104, %103
  store double %add79, double* %t_bar_time, align 8
  %105 = load double* %intra_time, align 8
  %106 = load double* %t_intra_time, align 8
  %add80 = fadd double %106, %105
  store double %add80, double* %t_intra_time, align 8
  %107 = load double* %other_time, align 8
  %108 = load double* %t_other_time, align 8
  %add81 = fadd double %108, %107
  store double %add81, double* %t_other_time, align 8
  %109 = load double* %total_time, align 8
  %110 = load double* %overall_total, align 8
  %cmp82 = fcmp ogt double %109, %110
  br i1 %cmp82, label %if.then.84, label %if.end.85

if.then.84:                                       ; preds = %for.end.71
  %111 = load double* %total_time, align 8
  store double %111, double* %overall_total, align 8
  br label %if.end.85

if.end.85:                                        ; preds = %if.then.84, %for.end.71
  store i32 1, i32* %j, align 4
  br label %for.cond.86

for.cond.86:                                      ; preds = %for.inc.146, %if.end.85
  %112 = load i32* %j, align 4
  %113 = load i32* @Number_Of_Processors, align 4
  %cmp87 = icmp slt i32 %112, %113
  br i1 %cmp87, label %for.body.89, label %for.end.148

for.body.89:                                      ; preds = %for.cond.86
  store double 0.000000e+00, double* %other_time, align 8
  store double 0.000000e+00, double* %intra_time, align 8
  store double 0.000000e+00, double* %bar_time, align 8
  store double 0.000000e+00, double* %inter_time, align 8
  store double 0.000000e+00, double* %pass_time, align 8
  store double 0.000000e+00, double* %part_time, align 8
  store double 0.000000e+00, double* %list_time, align 8
  store double 0.000000e+00, double* %tree_time, align 8
  store double 0.000000e+00, double* %total_time, align 8
  store i32 2, i32* %i, align 4
  br label %for.cond.90

for.cond.90:                                      ; preds = %for.inc.126, %for.body.89
  %114 = load i32* %i, align 4
  %115 = load i32* @Time_Steps, align 4
  %cmp91 = icmp slt i32 %114, %115
  br i1 %cmp91, label %for.body.93, label %for.end.128

for.body.93:                                      ; preds = %for.cond.90
  %116 = load i32* %i, align 4
  %idxprom94 = sext i32 %116 to i64
  %117 = load i32* %j, align 4
  %idxprom95 = sext i32 %117 to i64
  %arrayidx96 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom95
  %Timing97 = getelementptr inbounds %struct._Local_Memory* %arrayidx96, i32 0, i32 21
  %arrayidx98 = getelementptr inbounds [10 x %struct._Time_Info]* %Timing97, i32 0, i64 %idxprom94
  store %struct._Time_Info* %arrayidx98, %struct._Time_Info** %timing, align 8
  %118 = load %struct._Time_Info** %timing, align 8
  %total_time99 = getelementptr inbounds %struct._Time_Info* %118, i32 0, i32 8
  %119 = load i64* %total_time99, align 8
  %conv100 = uitofp i64 %119 to double
  %120 = load double* %total_time, align 8
  %add101 = fadd double %120, %conv100
  store double %add101, double* %total_time, align 8
  %121 = load %struct._Time_Info** %timing, align 8
  %construct_time102 = getelementptr inbounds %struct._Time_Info* %121, i32 0, i32 0
  %122 = load i64* %construct_time102, align 8
  %conv103 = uitofp i64 %122 to double
  %123 = load double* %tree_time, align 8
  %add104 = fadd double %123, %conv103
  store double %add104, double* %tree_time, align 8
  %124 = load %struct._Time_Info** %timing, align 8
  %list_time105 = getelementptr inbounds %struct._Time_Info* %124, i32 0, i32 1
  %125 = load i64* %list_time105, align 8
  %conv106 = uitofp i64 %125 to double
  %126 = load double* %list_time, align 8
  %add107 = fadd double %126, %conv106
  store double %add107, double* %list_time, align 8
  %127 = load %struct._Time_Info** %timing, align 8
  %partition_time108 = getelementptr inbounds %struct._Time_Info* %127, i32 0, i32 2
  %128 = load i64* %partition_time108, align 8
  %conv109 = uitofp i64 %128 to double
  %129 = load double* %part_time, align 8
  %add110 = fadd double %129, %conv109
  store double %add110, double* %part_time, align 8
  %130 = load %struct._Time_Info** %timing, align 8
  %pass_time111 = getelementptr inbounds %struct._Time_Info* %130, i32 0, i32 4
  %131 = load i64* %pass_time111, align 8
  %conv112 = uitofp i64 %131 to double
  %132 = load double* %pass_time, align 8
  %add113 = fadd double %132, %conv112
  store double %add113, double* %pass_time, align 8
  %133 = load %struct._Time_Info** %timing, align 8
  %inter_time114 = getelementptr inbounds %struct._Time_Info* %133, i32 0, i32 3
  %134 = load i64* %inter_time114, align 8
  %conv115 = uitofp i64 %134 to double
  %135 = load double* %inter_time, align 8
  %add116 = fadd double %135, %conv115
  store double %add116, double* %inter_time, align 8
  %136 = load %struct._Time_Info** %timing, align 8
  %barrier_time117 = getelementptr inbounds %struct._Time_Info* %136, i32 0, i32 6
  %137 = load i64* %barrier_time117, align 8
  %conv118 = uitofp i64 %137 to double
  %138 = load double* %bar_time, align 8
  %add119 = fadd double %138, %conv118
  store double %add119, double* %bar_time, align 8
  %139 = load %struct._Time_Info** %timing, align 8
  %intra_time120 = getelementptr inbounds %struct._Time_Info* %139, i32 0, i32 5
  %140 = load i64* %intra_time120, align 8
  %conv121 = uitofp i64 %140 to double
  %141 = load double* %intra_time, align 8
  %add122 = fadd double %141, %conv121
  store double %add122, double* %intra_time, align 8
  %142 = load %struct._Time_Info** %timing, align 8
  %other_time123 = getelementptr inbounds %struct._Time_Info* %142, i32 0, i32 7
  %143 = load i64* %other_time123, align 8
  %conv124 = uitofp i64 %143 to double
  %144 = load double* %other_time, align 8
  %add125 = fadd double %144, %conv124
  store double %add125, double* %other_time, align 8
  br label %for.inc.126

for.inc.126:                                      ; preds = %for.body.93
  %145 = load i32* %i, align 4
  %inc127 = add nsw i32 %145, 1
  store i32 %inc127, i32* %i, align 4
  br label %for.cond.90

for.end.128:                                      ; preds = %for.cond.90
  %146 = load i32* @do_stats, align 4
  %tobool129 = icmp ne i32 %146, 0
  br i1 %tobool129, label %if.then.130, label %if.end.132

if.then.130:                                      ; preds = %for.end.128
  %147 = load i32* %j, align 4
  %148 = load double* %total_time, align 8
  %149 = load double* %tree_time, align 8
  %150 = load double* %list_time, align 8
  %151 = load double* %part_time, align 8
  %152 = load double* %pass_time, align 8
  %153 = load double* %inter_time, align 8
  %154 = load double* %bar_time, align 8
  %155 = load double* %intra_time, align 8
  %156 = load double* %other_time, align 8
  %call131 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([61 x i8]* @.str.53, i32 0, i32 0), i32 %147, double %148, double %149, double %150, double %151, double %152, double %153, double %154, double %155, double %156)
  br label %if.end.132

if.end.132:                                       ; preds = %if.then.130, %for.end.128
  %157 = load double* %total_time, align 8
  %158 = load double* %t_total_time, align 8
  %add133 = fadd double %158, %157
  store double %add133, double* %t_total_time, align 8
  %159 = load double* %tree_time, align 8
  %160 = load double* %t_tree_time, align 8
  %add134 = fadd double %160, %159
  store double %add134, double* %t_tree_time, align 8
  %161 = load double* %list_time, align 8
  %162 = load double* %t_list_time, align 8
  %add135 = fadd double %162, %161
  store double %add135, double* %t_list_time, align 8
  %163 = load double* %part_time, align 8
  %164 = load double* %t_part_time, align 8
  %add136 = fadd double %164, %163
  store double %add136, double* %t_part_time, align 8
  %165 = load double* %pass_time, align 8
  %166 = load double* %t_pass_time, align 8
  %add137 = fadd double %166, %165
  store double %add137, double* %t_pass_time, align 8
  %167 = load double* %inter_time, align 8
  %168 = load double* %t_inter_time, align 8
  %add138 = fadd double %168, %167
  store double %add138, double* %t_inter_time, align 8
  %169 = load double* %bar_time, align 8
  %170 = load double* %t_bar_time, align 8
  %add139 = fadd double %170, %169
  store double %add139, double* %t_bar_time, align 8
  %171 = load double* %intra_time, align 8
  %172 = load double* %t_intra_time, align 8
  %add140 = fadd double %172, %171
  store double %add140, double* %t_intra_time, align 8
  %173 = load double* %other_time, align 8
  %174 = load double* %t_other_time, align 8
  %add141 = fadd double %174, %173
  store double %add141, double* %t_other_time, align 8
  %175 = load double* %total_time, align 8
  %176 = load double* %overall_total, align 8
  %cmp142 = fcmp ogt double %175, %176
  br i1 %cmp142, label %if.then.144, label %if.end.145

if.then.144:                                      ; preds = %if.end.132
  %177 = load double* %total_time, align 8
  store double %177, double* %overall_total, align 8
  br label %if.end.145

if.end.145:                                       ; preds = %if.then.144, %if.end.132
  br label %for.inc.146

for.inc.146:                                      ; preds = %if.end.145
  %178 = load i32* %j, align 4
  %inc147 = add nsw i32 %178, 1
  store i32 %inc147, i32* %j, align 4
  br label %for.cond.86

for.end.148:                                      ; preds = %for.cond.86
  %179 = load i32* @do_stats, align 4
  %tobool149 = icmp ne i32 %179, 0
  br i1 %tobool149, label %if.then.150, label %if.end.169

if.then.150:                                      ; preds = %for.end.148
  %180 = load i32* @Number_Of_Processors, align 4
  store i32 %180, i32* %P, align 4
  %181 = load double* %t_total_time, align 8
  %182 = load i32* %P, align 4
  %conv151 = sitofp i32 %182 to double
  %div = fdiv double %181, %conv151
  %183 = load double* %t_tree_time, align 8
  %184 = load i32* %P, align 4
  %conv152 = sitofp i32 %184 to double
  %div153 = fdiv double %183, %conv152
  %185 = load double* %t_list_time, align 8
  %186 = load i32* %P, align 4
  %conv154 = sitofp i32 %186 to double
  %div155 = fdiv double %185, %conv154
  %187 = load double* %t_part_time, align 8
  %188 = load i32* %P, align 4
  %conv156 = sitofp i32 %188 to double
  %div157 = fdiv double %187, %conv156
  %189 = load double* %t_pass_time, align 8
  %190 = load i32* %P, align 4
  %conv158 = sitofp i32 %190 to double
  %div159 = fdiv double %189, %conv158
  %191 = load double* %t_inter_time, align 8
  %192 = load i32* %P, align 4
  %conv160 = sitofp i32 %192 to double
  %div161 = fdiv double %191, %conv160
  %193 = load double* %t_bar_time, align 8
  %194 = load i32* %P, align 4
  %conv162 = sitofp i32 %194 to double
  %div163 = fdiv double %193, %conv162
  %195 = load double* %t_intra_time, align 8
  %196 = load i32* %P, align 4
  %conv164 = sitofp i32 %196 to double
  %div165 = fdiv double %195, %conv164
  %197 = load double* %t_other_time, align 8
  %198 = load i32* %P, align 4
  %conv166 = sitofp i32 %198 to double
  %div167 = fdiv double %197, %conv166
  %call168 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([62 x i8]* @.str.54, i32 0, i32 0), double %div, double %div153, double %div155, double %div157, double %div159, double %div161, double %div163, double %div165, double %div167)
  br label %if.end.169

if.end.169:                                       ; preds = %if.then.150, %for.end.148
  %call170 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.55, i32 0, i32 0))
  %199 = load i32* @Time_Steps, align 4
  %cmp171 = icmp sgt i32 %199, 2
  br i1 %cmp171, label %if.then.173, label %if.end.203

if.then.173:                                      ; preds = %if.end.169
  %200 = load i32* getelementptr inbounds ([64 x %struct._Local_Memory]* @Local, i32 0, i64 0, i32 20), align 4
  store i32 %200, i32* %init_done, align 4
  %201 = load i32* @do_stats, align 4
  %tobool174 = icmp ne i32 %201, 0
  br i1 %tobool174, label %if.then.175, label %if.end.192

if.then.175:                                      ; preds = %if.then.173
  store i32 1, i32* %j, align 4
  br label %for.cond.176

for.cond.176:                                     ; preds = %for.inc.189, %if.then.175
  %202 = load i32* %j, align 4
  %203 = load i32* @Number_Of_Processors, align 4
  %cmp177 = icmp slt i32 %202, %203
  br i1 %cmp177, label %for.body.179, label %for.end.191

for.body.179:                                     ; preds = %for.cond.176
  %204 = load i32* %j, align 4
  %idxprom180 = sext i32 %204 to i64
  %arrayidx181 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom180
  %init_done_times = getelementptr inbounds %struct._Local_Memory* %arrayidx181, i32 0, i32 20
  %205 = load i32* %init_done_times, align 4
  %206 = load i32* %init_done, align 4
  %cmp182 = icmp ugt i32 %205, %206
  br i1 %cmp182, label %if.then.184, label %if.end.188

if.then.184:                                      ; preds = %for.body.179
  %207 = load i32* %j, align 4
  %idxprom185 = sext i32 %207 to i64
  %arrayidx186 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom185
  %init_done_times187 = getelementptr inbounds %struct._Local_Memory* %arrayidx186, i32 0, i32 20
  %208 = load i32* %init_done_times187, align 4
  store i32 %208, i32* %init_done, align 4
  br label %if.end.188

if.end.188:                                       ; preds = %if.then.184, %for.body.179
  br label %for.inc.189

for.inc.189:                                      ; preds = %if.end.188
  %209 = load i32* %j, align 4
  %inc190 = add nsw i32 %209, 1
  store i32 %inc190, i32* %j, align 4
  br label %for.cond.176

for.end.191:                                      ; preds = %for.cond.176
  br label %if.end.192

if.end.192:                                       ; preds = %for.end.191, %if.then.173
  %call193 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.56, i32 0, i32 0))
  %210 = load i32* @starttime, align 4
  %call194 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.57, i32 0, i32 0), i32 %210)
  %211 = load i32* %init_done, align 4
  %call195 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.58, i32 0, i32 0), i32 %211)
  %212 = load i32* @endtime, align 4
  %call196 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.59, i32 0, i32 0), i32 %212)
  %213 = load i32* @endtime, align 4
  %214 = load i32* @starttime, align 4
  %sub = sub i32 %213, %214
  %call197 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.60, i32 0, i32 0), i32 %sub)
  %215 = load double* %overall_total, align 8
  %conv198 = fptosi double %215 to i32
  %call199 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([42 x i8]* @.str.61, i32 0, i32 0), i32 %conv198)
  %call200 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.55, i32 0, i32 0))
  %216 = load i32* @Time_Steps, align 4
  %217 = load double* %overall_total, align 8
  %call201 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([40 x i8]* @.str.62, i32 0, i32 0), i32 3, i32 %216, double %217)
  %call202 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.55, i32 0, i32 0))
  br label %if.end.203

if.end.203:                                       ; preds = %if.end.192, %if.end.169
  ret void
}

declare %struct._IO_FILE* @fopen(i8*, i8*)

declare i32 @fflush(%struct._IO_FILE*)

declare i32 @fclose(%struct._IO_FILE*)

; Function Attrs: nounwind uwtable
define void @Help() {
entry:
  %call = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([35 x i8]* @.str.63, i32 0, i32 0))
  %call1 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([10 x i8]* @.str.64, i32 0, i32 0))
  %call2 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([44 x i8]* @.str.65, i32 0, i32 0))
  %call3 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([58 x i8]* @.str.66, i32 0, i32 0))
  %call4 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([39 x i8]* @.str.67, i32 0, i32 0))
  %call5 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.55, i32 0, i32 0))
  %call6 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([31 x i8]* @.str.68, i32 0, i32 0))
  %call7 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([59 x i8]* @.str.69, i32 0, i32 0))
  %call8 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([27 x i8]* @.str.70, i32 0, i32 0))
  %call9 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([55 x i8]* @.str.71, i32 0, i32 0))
  %call10 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([64 x i8]* @.str.72, i32 0, i32 0))
  %call11 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([28 x i8]* @.str.73, i32 0, i32 0))
  %call12 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([57 x i8]* @.str.74, i32 0, i32 0))
  %call13 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([56 x i8]* @.str.75, i32 0, i32 0))
  %call14 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([52 x i8]* @.str.76, i32 0, i32 0))
  %call15 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([50 x i8]* @.str.77, i32 0, i32 0))
  %call16 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([59 x i8]* @.str.78, i32 0, i32 0))
  %call17 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([51 x i8]* @.str.79, i32 0, i32 0))
  %call18 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([51 x i8]* @.str.80, i32 0, i32 0))
  %call19 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([48 x i8]* @.str.81, i32 0, i32 0))
  %call20 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([54 x i8]* @.str.82, i32 0, i32 0))
  %call21 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([36 x i8]* @.str.83, i32 0, i32 0))
  %call22 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([49 x i8]* @.str.84, i32 0, i32 0))
  %call23 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([27 x i8]* @.str.85, i32 0, i32 0))
  call void @exit(i32 0)
  unreachable

return:                                           ; No predecessors!
  ret void
}


