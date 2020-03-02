; ModuleID = 'construct_grid.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._Local_Memory = type { [1024 x i32], %struct._Box*, i32, i32, %struct._Particle**, i32, i32, %struct._Box*, [100 x %struct._Box*], i32, %struct._Box*, double, double, double, double, i32, i32, i32, i32, double, i32, [10 x %struct._Time_Info], [1024 x i32] }
%struct._Particle = type { i32, double, double, %struct._Vector, %struct._Vector, %struct._Vector, %struct.Complex, i32, double }
%struct._Vector = type { double, double }
%struct.Complex = type { double, double }
%struct._Box = type { double, double, double, double, i32, i32, [41 x %struct._Particle*], i32, %struct._Box*, i32, [4 x %struct._Box*], [4 x %struct._Box*], i32, [3 x %struct._Box*], i32, [8 x %struct._Box*], i32, [20 x %struct._Box*], i32, [27 x %struct._Box*], i32, [30 x %struct._Box*], i32, [40 x %struct.Complex], [40 x %struct.Complex], [40 x %struct.Complex], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct._Box*, %struct._Box*, %struct._Box*, %struct._Box* }
%struct._Time_Info = type { i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct._G_Mem = type { %union.pthread_mutex_t, %union.pthread_mutex_t, %union.pthread_mutex_t, %union.pthread_mutex_t, i32, [2048 x %union.pthread_mutex_t], %struct.barrier_t, i32*, double*, [64 x [4 x double]], double, double, double, double, i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.barrier_t = type { i32, i64 }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@Local = external global [64 x %struct._Local_Memory], align 16
@G_Memory = external global %struct._G_Mem*, align 8
@Number_Of_Processors = external global i32, align 4
@.str = private unnamed_addr constant [49 x i8] c"ERROR (P%d) : Too many particles in local array\0A\00", align 1
@Grid = external global %struct._Box*, align 8
@.str.1 = private unnamed_addr constant [26 x i8] c"Info for Adaptive Grid :\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"Boxes :\0A\0A\00", align 1
@stdout = external global %struct._IO_FILE*, align 8
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.4 = private unnamed_addr constant [45 x i8] c"Adaptive grid has not been initialized yet.\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @ConstructGrid(i32 %my_id, %struct._Time_Info* %local_time, i32 %time_all) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_time.addr = alloca %struct._Time_Info*, align 8
  %time_all.addr = alloca i32, align 4
  %init = alloca i64, align 8
  %start = alloca i64, align 8
  %finish = alloca i64, align 8
  %i = alloca i32, align 4
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
  store i64 %call, i64* %init, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %1 = load i32* %my_id.addr, align 4
  call void @DetermineGridSize(i32 %1)
  %2 = load i32* %my_id.addr, align 4
  call void @FreeBoxes(i32 %2)
  %3 = load i32* %my_id.addr, align 4
  call void @InitPartition(i32 %3)
  %4 = load i32* %time_all.addr, align 4
  %tobool1 = icmp ne i32 %4, 0
  br i1 %tobool1, label %if.then.2, label %if.end.4

if.then.2:                                        ; preds = %if.end
  %call3 = call i64 @time(i64* null)
  store i64 %call3, i64* %start, align 8
  br label %if.end.4

if.end.4:                                         ; preds = %if.then.2, %if.end
  %5 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %5 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Num_Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 5
  %6 = load i32* %Num_Particles, align 4
  %cmp = icmp sgt i32 %6, 0
  br i1 %cmp, label %if.then.5, label %if.end.6

if.then.5:                                        ; preds = %if.end.4
  %7 = load i32* %my_id.addr, align 4
  call void @ConstructLocalGrid(i32 %7)
  %8 = load i32* %my_id.addr, align 4
  call void @MergeLocalGrid(i32 %8)
  br label %if.end.6

if.end.6:                                         ; preds = %if.then.5, %if.end.4
  %9 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %9, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %10 = load volatile i32* %gsense, align 4
  store i32 %10, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.6, %if.end.25
  %11 = load %struct._G_Mem** @G_Memory, align 8
  %synch7 = getelementptr inbounds %struct._G_Mem* %11, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch7, i32 0, i32 1
  %12 = load volatile i64* %count, align 8
  %conv = trunc i64 %12 to i32
  store i32 %conv, i32* %oldcount, align 4
  %13 = load i32* %oldcount, align 4
  %14 = load i32* %lsense, align 4
  %add = add nsw i32 %13, %14
  store i32 %add, i32* %newcount, align 4
  %15 = load i32* %oldcount, align 4
  %16 = load i32* %newcount, align 4
  %call8 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %15, i32 %16)
  store i32 %call8, i32* %updatedcount, align 4
  %17 = load i32* %updatedcount, align 4
  %18 = load i32* %oldcount, align 4
  %cmp9 = icmp eq i32 %17, %18
  br i1 %cmp9, label %if.then.11, label %if.end.25

if.then.11:                                       ; preds = %while.body
  %19 = load i32* %newcount, align 4
  %20 = load i32* @Number_Of_Processors, align 4
  %cmp12 = icmp eq i32 %19, %20
  br i1 %cmp12, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then.11
  %21 = load i32* %lsense, align 4
  %cmp14 = icmp eq i32 %21, 1
  br i1 %cmp14, label %if.then.21, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then.11
  %22 = load i32* %newcount, align 4
  %cmp16 = icmp eq i32 %22, 0
  br i1 %cmp16, label %land.lhs.true.18, label %if.end.24

land.lhs.true.18:                                 ; preds = %lor.lhs.false
  %23 = load i32* %lsense, align 4
  %cmp19 = icmp eq i32 %23, -1
  br i1 %cmp19, label %if.then.21, label %if.end.24

if.then.21:                                       ; preds = %land.lhs.true.18, %land.lhs.true
  %24 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %24
  %25 = load %struct._G_Mem** @G_Memory, align 8
  %synch22 = getelementptr inbounds %struct._G_Mem* %25, i32 0, i32 6
  %gsense23 = getelementptr inbounds %struct.barrier_t* %synch22, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense23, align 4
  call void @Criteria(i32 6)
  br label %if.end.24

if.end.24:                                        ; preds = %if.then.21, %land.lhs.true.18, %lor.lhs.false
  br label %while.end

if.end.25:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.24
  br label %while.cond

while.cond:                                       ; preds = %while.body.30, %while.end
  %26 = load %struct._G_Mem** @G_Memory, align 8
  %synch26 = getelementptr inbounds %struct._G_Mem* %26, i32 0, i32 6
  %gsense27 = getelementptr inbounds %struct.barrier_t* %synch26, i32 0, i32 0
  %27 = load volatile i32* %gsense27, align 4
  %28 = load i32* %lsense, align 4
  %cmp28 = icmp eq i32 %27, %28
  br i1 %cmp28, label %while.body.30, label %while.end.31

while.body.30:                                    ; preds = %while.cond
  br label %while.cond

while.end.31:                                     ; preds = %while.cond
  call void @Criteria(i32 6)
  %29 = load i32* %my_id.addr, align 4
  call void @CleanupGrid(i32 %29)
  %30 = load i32* %time_all.addr, align 4
  %tobool32 = icmp ne i32 %30, 0
  br i1 %tobool32, label %if.then.33, label %if.end.35

if.then.33:                                       ; preds = %while.end.31
  %call34 = call i64 @time(i64* null)
  store i64 %call34, i64* %finish, align 8
  br label %if.end.35

if.end.35:                                        ; preds = %if.then.33, %while.end.31
  %31 = load i32* %time_all.addr, align 4
  %tobool36 = icmp ne i32 %31, 0
  br i1 %tobool36, label %if.then.37, label %if.end.49

if.then.37:                                       ; preds = %if.end.35
  %32 = load i64* %start, align 8
  %33 = load i64* %init, align 8
  %sub38 = sub i64 %32, %33
  %34 = load i32* %my_id.addr, align 4
  %idxprom39 = sext i32 %34 to i64
  %arrayidx40 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom39
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx40, i32 0, i32 18
  %35 = load i32* %Time_Step, align 4
  %idxprom41 = sext i32 %35 to i64
  %36 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx42 = getelementptr inbounds %struct._Time_Info* %36, i64 %idxprom41
  %other_time = getelementptr inbounds %struct._Time_Info* %arrayidx42, i32 0, i32 7
  store i64 %sub38, i64* %other_time, align 8
  %37 = load i64* %finish, align 8
  %38 = load i64* %start, align 8
  %sub43 = sub i64 %37, %38
  %39 = load i32* %my_id.addr, align 4
  %idxprom44 = sext i32 %39 to i64
  %arrayidx45 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom44
  %Time_Step46 = getelementptr inbounds %struct._Local_Memory* %arrayidx45, i32 0, i32 18
  %40 = load i32* %Time_Step46, align 4
  %idxprom47 = sext i32 %40 to i64
  %41 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx48 = getelementptr inbounds %struct._Time_Info* %41, i64 %idxprom47
  %construct_time = getelementptr inbounds %struct._Time_Info* %arrayidx48, i32 0, i32 0
  store i64 %sub43, i64* %construct_time, align 8
  br label %if.end.49

if.end.49:                                        ; preds = %if.then.37, %if.end.35
  ret void
}

; Function Attrs: nounwind
declare i64 @time(i64*)

; Function Attrs: nounwind uwtable
define void @DetermineGridSize(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  call void @DetermineLocalGridSize(i32 %0)
  %1 = load i32* %my_id.addr, align 4
  call void @MergeLocalGridSize(i32 %1)
  ret void
}

declare void @FreeBoxes(i32)

declare void @InitPartition(i32)

; Function Attrs: nounwind uwtable
define void @ConstructLocalGrid(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %call = call %struct._Box* @InitGrid(i32 %0)
  %1 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Local_Grid = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 10
  store %struct._Box* %call, %struct._Box** %Local_Grid, align 8
  %2 = load i32* %my_id.addr, align 4
  %3 = load i32* %my_id.addr, align 4
  %idxprom1 = sext i32 %3 to i64
  %arrayidx2 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom1
  %Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx2, i32 0, i32 4
  %4 = load %struct._Particle*** %Particles, align 8
  %5 = load i32* %my_id.addr, align 4
  %idxprom3 = sext i32 %5 to i64
  %arrayidx4 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom3
  %Num_Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx4, i32 0, i32 5
  %6 = load i32* %Num_Particles, align 4
  %7 = load i32* %my_id.addr, align 4
  %idxprom5 = sext i32 %7 to i64
  %arrayidx6 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom5
  %Local_Grid7 = getelementptr inbounds %struct._Local_Memory* %arrayidx6, i32 0, i32 10
  %8 = load %struct._Box** %Local_Grid7, align 8
  call void @InsertParticlesInTree(i32 %2, %struct._Particle** %4, i32 %6, %struct._Box* %8)
  ret void
}

; Function Attrs: nounwind uwtable
define void @MergeLocalGrid(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %1 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Local_Grid = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 10
  %2 = load %struct._Box** %Local_Grid, align 8
  %3 = load %struct._Box** @Grid, align 8
  call void @MLGHelper(i32 %0, %struct._Box* %2, %struct._Box* %3, %struct._Box* null)
  ret void
}

declare i32 @atomic_cmpxchg(...)

declare void @Criteria(i32)

; Function Attrs: nounwind uwtable
define void @CleanupGrid(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  %b_scan = alloca %struct._Box*, align 8
  %tb = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Childless_Partition = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 7
  %1 = load %struct._Box** %Childless_Partition, align 8
  store %struct._Box* %1, %struct._Box** %b_scan, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end.17, %entry
  %2 = load %struct._Box** %b_scan, align 8
  %cmp = icmp ne %struct._Box* %2, null
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load %struct._Box** %b_scan, align 8
  %parent = getelementptr inbounds %struct._Box* %3, i32 0, i32 8
  %4 = load %struct._Box** %parent, align 8
  %cmp1 = icmp ne %struct._Box* %4, null
  br i1 %cmp1, label %land.lhs.true, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.body
  %5 = load %struct._Box** %b_scan, align 8
  %6 = load %struct._Box** @Grid, align 8
  %cmp2 = icmp eq %struct._Box* %5, %6
  br i1 %cmp2, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %lor.lhs.false, %while.body
  %7 = load %struct._Box** %b_scan, align 8
  %type = getelementptr inbounds %struct._Box* %7, i32 0, i32 5
  %8 = load i32* %type, align 4
  %cmp3 = icmp eq i32 %8, 0
  br i1 %cmp3, label %if.then, label %if.else

if.then:                                          ; preds = %land.lhs.true
  %9 = load %struct._Box** %b_scan, align 8
  %next = getelementptr inbounds %struct._Box* %9, i32 0, i32 37
  %10 = load %struct._Box** %next, align 8
  store %struct._Box* %10, %struct._Box** %b_scan, align 8
  br label %if.end.17

if.else:                                          ; preds = %land.lhs.true, %lor.lhs.false
  %11 = load %struct._Box** %b_scan, align 8
  store %struct._Box* %11, %struct._Box** %tb, align 8
  %12 = load %struct._Box** %b_scan, align 8
  %next4 = getelementptr inbounds %struct._Box* %12, i32 0, i32 37
  %13 = load %struct._Box** %next4, align 8
  store %struct._Box* %13, %struct._Box** %b_scan, align 8
  %14 = load %struct._Box** %tb, align 8
  %type5 = getelementptr inbounds %struct._Box* %14, i32 0, i32 5
  %15 = load i32* %type5, align 4
  %cmp6 = icmp eq i32 %15, 1
  br i1 %cmp6, label %if.then.7, label %if.else.15

if.then.7:                                        ; preds = %if.else
  %16 = load %struct._Box** %tb, align 8
  %type8 = getelementptr inbounds %struct._Box* %16, i32 0, i32 5
  store i32 0, i32* %type8, align 4
  %17 = load i32* %my_id.addr, align 4
  %18 = load %struct._Box** %tb, align 8
  call void @RemoveBoxFromPartition(i32 %17, %struct._Box* %18)
  %19 = load %struct._Box** %tb, align 8
  %type9 = getelementptr inbounds %struct._Box* %19, i32 0, i32 5
  store i32 1, i32* %type9, align 4
  %20 = load %struct._Box** %tb, align 8
  %parent10 = getelementptr inbounds %struct._Box* %20, i32 0, i32 8
  %21 = load %struct._Box** %parent10, align 8
  %cmp11 = icmp ne %struct._Box* %21, null
  br i1 %cmp11, label %if.then.14, label %lor.lhs.false.12

lor.lhs.false.12:                                 ; preds = %if.then.7
  %22 = load %struct._Box** %tb, align 8
  %23 = load %struct._Box** @Grid, align 8
  %cmp13 = icmp eq %struct._Box* %22, %23
  br i1 %cmp13, label %if.then.14, label %if.end

if.then.14:                                       ; preds = %lor.lhs.false.12, %if.then.7
  %24 = load i32* %my_id.addr, align 4
  %25 = load %struct._Box** %tb, align 8
  call void @InsertBoxInPartition(i32 %24, %struct._Box* %25)
  br label %if.end

if.end:                                           ; preds = %if.then.14, %lor.lhs.false.12
  br label %if.end.16

if.else.15:                                       ; preds = %if.else
  %26 = load i32* %my_id.addr, align 4
  %27 = load %struct._Box** %tb, align 8
  call void @RemoveBoxFromPartition(i32 %26, %struct._Box* %27)
  br label %if.end.16

if.end.16:                                        ; preds = %if.else.15, %if.end
  br label %if.end.17

if.end.17:                                        ; preds = %if.end.16, %if.then
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @ConstructLists(i32 %my_id, %struct._Time_Info* %local_time, i32 %time_all) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_time.addr = alloca %struct._Time_Info*, align 8
  %time_all.addr = alloca i32, align 4
  %start = alloca i64, align 8
  %finish = alloca i64, align 8
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
  call void @PartitionIterate(i32 %1, void (i32, %struct._Box*)* @ConstructGridLists, i32 0)
  %2 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %2, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %3 = load volatile i32* %gsense, align 4
  store i32 %3, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end, %if.end.18
  %4 = load %struct._G_Mem** @G_Memory, align 8
  %synch1 = getelementptr inbounds %struct._G_Mem* %4, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch1, i32 0, i32 1
  %5 = load volatile i64* %count, align 8
  %conv = trunc i64 %5 to i32
  store i32 %conv, i32* %oldcount, align 4
  %6 = load i32* %oldcount, align 4
  %7 = load i32* %lsense, align 4
  %add = add nsw i32 %6, %7
  store i32 %add, i32* %newcount, align 4
  %8 = load i32* %oldcount, align 4
  %9 = load i32* %newcount, align 4
  %call2 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %8, i32 %9)
  store i32 %call2, i32* %updatedcount, align 4
  %10 = load i32* %updatedcount, align 4
  %11 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %10, %11
  br i1 %cmp, label %if.then.4, label %if.end.18

if.then.4:                                        ; preds = %while.body
  %12 = load i32* %newcount, align 4
  %13 = load i32* @Number_Of_Processors, align 4
  %cmp5 = icmp eq i32 %12, %13
  br i1 %cmp5, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then.4
  %14 = load i32* %lsense, align 4
  %cmp7 = icmp eq i32 %14, 1
  br i1 %cmp7, label %if.then.14, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then.4
  %15 = load i32* %newcount, align 4
  %cmp9 = icmp eq i32 %15, 0
  br i1 %cmp9, label %land.lhs.true.11, label %if.end.17

land.lhs.true.11:                                 ; preds = %lor.lhs.false
  %16 = load i32* %lsense, align 4
  %cmp12 = icmp eq i32 %16, -1
  br i1 %cmp12, label %if.then.14, label %if.end.17

if.then.14:                                       ; preds = %land.lhs.true.11, %land.lhs.true
  %17 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %17
  %18 = load %struct._G_Mem** @G_Memory, align 8
  %synch15 = getelementptr inbounds %struct._G_Mem* %18, i32 0, i32 6
  %gsense16 = getelementptr inbounds %struct.barrier_t* %synch15, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense16, align 4
  call void @Criteria(i32 7)
  br label %if.end.17

if.end.17:                                        ; preds = %if.then.14, %land.lhs.true.11, %lor.lhs.false
  br label %while.end

if.end.18:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.17
  br label %while.cond

while.cond:                                       ; preds = %while.body.23, %while.end
  %19 = load %struct._G_Mem** @G_Memory, align 8
  %synch19 = getelementptr inbounds %struct._G_Mem* %19, i32 0, i32 6
  %gsense20 = getelementptr inbounds %struct.barrier_t* %synch19, i32 0, i32 0
  %20 = load volatile i32* %gsense20, align 4
  %21 = load i32* %lsense, align 4
  %cmp21 = icmp eq i32 %20, %21
  br i1 %cmp21, label %while.body.23, label %while.end.24

while.body.23:                                    ; preds = %while.cond
  br label %while.cond

while.end.24:                                     ; preds = %while.cond
  call void @Criteria(i32 7)
  %22 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %22, void (i32, %struct._Box*)* @ConstructInteractionLists, i32 1)
  %23 = load i32* %time_all.addr, align 4
  %tobool25 = icmp ne i32 %23, 0
  br i1 %tobool25, label %if.then.26, label %if.end.28

if.then.26:                                       ; preds = %while.end.24
  %call27 = call i64 @time(i64* null)
  store i64 %call27, i64* %finish, align 8
  br label %if.end.28

if.end.28:                                        ; preds = %if.then.26, %while.end.24
  %24 = load i32* %time_all.addr, align 4
  %tobool29 = icmp ne i32 %24, 0
  br i1 %tobool29, label %if.then.30, label %if.end.34

if.then.30:                                       ; preds = %if.end.28
  %25 = load i64* %finish, align 8
  %26 = load i64* %start, align 8
  %sub31 = sub i64 %25, %26
  %27 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %27 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 18
  %28 = load i32* %Time_Step, align 4
  %idxprom32 = sext i32 %28 to i64
  %29 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx33 = getelementptr inbounds %struct._Time_Info* %29, i64 %idxprom32
  %list_time = getelementptr inbounds %struct._Time_Info* %arrayidx33, i32 0, i32 1
  store i64 %sub31, i64* %list_time, align 8
  br label %if.end.34

if.end.34:                                        ; preds = %if.then.30, %if.end.28
  ret void
}

declare void @PartitionIterate(i32, void (i32, %struct._Box*)*, i32)

; Function Attrs: nounwind uwtable
define void @ConstructGridLists(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load i32* %my_id.addr, align 4
  %1 = load %struct._Box** %b.addr, align 8
  call void @SetSiblings(i32 %0, %struct._Box* %1)
  %2 = load i32* %my_id.addr, align 4
  %3 = load %struct._Box** %b.addr, align 8
  call void @SetColleagues(i32 %2, %struct._Box* %3)
  ret void
}

; Function Attrs: nounwind uwtable
define void @ConstructInteractionLists(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load i32* %my_id.addr, align 4
  %1 = load %struct._Box** %b.addr, align 8
  call void @SetVList(i32 %0, %struct._Box* %1)
  %2 = load %struct._Box** %b.addr, align 8
  %type = getelementptr inbounds %struct._Box* %2, i32 0, i32 5
  %3 = load i32* %type, align 4
  %cmp = icmp eq i32 %3, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = load i32* %my_id.addr, align 4
  %5 = load %struct._Box** %b.addr, align 8
  call void @SetUList(i32 %4, %struct._Box* %5)
  %6 = load i32* %my_id.addr, align 4
  %7 = load %struct._Box** %b.addr, align 8
  call void @SetWList(i32 %6, %struct._Box* %7)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @DestroyGrid(i32 %my_id, %struct._Time_Info* %local_time, i32 %time_all) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_time.addr = alloca %struct._Time_Info*, align 8
  %time_all.addr = alloca i32, align 4
  %b_scan = alloca %struct._Box*, align 8
  %tb = alloca %struct._Box*, align 8
  %p = alloca %struct._Particle*, align 8
  %i = alloca i32, align 4
  %particle_cost = alloca i32, align 4
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
  %1 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Childless_Partition = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 7
  %2 = load %struct._Box** %Childless_Partition, align 8
  store %struct._Box* %2, %struct._Box** %b_scan, align 8
  %3 = load i32* %my_id.addr, align 4
  %idxprom1 = sext i32 %3 to i64
  %arrayidx2 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom1
  %Num_Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx2, i32 0, i32 5
  store i32 0, i32* %Num_Particles, align 4
  br label %while.cond

while.cond:                                       ; preds = %for.end, %if.end
  %4 = load %struct._Box** %b_scan, align 8
  %cmp = icmp ne %struct._Box* %4, null
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %5 = load %struct._Box** %b_scan, align 8
  store %struct._Box* %5, %struct._Box** %tb, align 8
  %6 = load %struct._Box** %b_scan, align 8
  %next = getelementptr inbounds %struct._Box* %6, i32 0, i32 37
  %7 = load %struct._Box** %next, align 8
  store %struct._Box* %7, %struct._Box** %b_scan, align 8
  %8 = load %struct._Box** %tb, align 8
  %cost = getelementptr inbounds %struct._Box* %8, i32 0, i32 31
  %9 = load i32* %cost, align 4
  %10 = load %struct._Box** %tb, align 8
  %num_particles = getelementptr inbounds %struct._Box* %10, i32 0, i32 7
  %11 = load i32* %num_particles, align 4
  %div = sdiv i32 %9, %11
  store i32 %div, i32* %particle_cost, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body
  %12 = load i32* %i, align 4
  %13 = load %struct._Box** %tb, align 8
  %num_particles3 = getelementptr inbounds %struct._Box* %13, i32 0, i32 7
  %14 = load i32* %num_particles3, align 4
  %cmp4 = icmp slt i32 %12, %14
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %15 = load i32* %my_id.addr, align 4
  %idxprom5 = sext i32 %15 to i64
  %arrayidx6 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom5
  %Max_Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx6, i32 0, i32 6
  %16 = load i32* %Max_Particles, align 4
  %17 = load i32* %my_id.addr, align 4
  %idxprom7 = sext i32 %17 to i64
  %arrayidx8 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom7
  %Num_Particles9 = getelementptr inbounds %struct._Local_Memory* %arrayidx8, i32 0, i32 5
  %18 = load i32* %Num_Particles9, align 4
  %cmp10 = icmp sle i32 %16, %18
  br i1 %cmp10, label %if.then.11, label %if.end.12

if.then.11:                                       ; preds = %for.body
  %19 = load i32* %my_id.addr, align 4
  call void (i8*, ...) @LockedPrint(i8* getelementptr inbounds ([49 x i8]* @.str, i32 0, i32 0), i32 %19)
  call void @exit(i32 -1)
  unreachable

if.end.12:                                        ; preds = %for.body
  %20 = load i32* %i, align 4
  %idxprom13 = sext i32 %20 to i64
  %21 = load %struct._Box** %tb, align 8
  %particles = getelementptr inbounds %struct._Box* %21, i32 0, i32 6
  %arrayidx14 = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i64 %idxprom13
  %22 = load %struct._Particle** %arrayidx14, align 8
  store %struct._Particle* %22, %struct._Particle** %p, align 8
  %23 = load i32* %particle_cost, align 4
  %24 = load %struct._Particle** %p, align 8
  %cost15 = getelementptr inbounds %struct._Particle* %24, i32 0, i32 7
  store i32 %23, i32* %cost15, align 4
  %25 = load %struct._Particle** %p, align 8
  %26 = load i32* %my_id.addr, align 4
  %idxprom16 = sext i32 %26 to i64
  %arrayidx17 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom16
  %Num_Particles18 = getelementptr inbounds %struct._Local_Memory* %arrayidx17, i32 0, i32 5
  %27 = load i32* %Num_Particles18, align 4
  %inc = add nsw i32 %27, 1
  store i32 %inc, i32* %Num_Particles18, align 4
  %idxprom19 = sext i32 %27 to i64
  %28 = load i32* %my_id.addr, align 4
  %idxprom20 = sext i32 %28 to i64
  %arrayidx21 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom20
  %Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx21, i32 0, i32 4
  %29 = load %struct._Particle*** %Particles, align 8
  %arrayidx22 = getelementptr inbounds %struct._Particle** %29, i64 %idxprom19
  store %struct._Particle* %25, %struct._Particle** %arrayidx22, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.12
  %30 = load i32* %i, align 4
  %inc23 = add nsw i32 %30, 1
  store i32 %inc23, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %31 = load i32* %my_id.addr, align 4
  %cmp24 = icmp eq i32 %31, 0
  br i1 %cmp24, label %if.then.25, label %if.end.26

if.then.25:                                       ; preds = %while.end
  store %struct._Box* null, %struct._Box** @Grid, align 8
  br label %if.end.26

if.end.26:                                        ; preds = %if.then.25, %while.end
  %32 = load i32* %time_all.addr, align 4
  %tobool27 = icmp ne i32 %32, 0
  br i1 %tobool27, label %if.then.28, label %if.end.34

if.then.28:                                       ; preds = %if.end.26
  %call29 = call i64 @time(i64* null)
  store i64 %call29, i64* %finish, align 8
  %33 = load i64* %finish, align 8
  %34 = load i64* %start, align 8
  %sub = sub i64 %33, %34
  %35 = load i32* %my_id.addr, align 4
  %idxprom30 = sext i32 %35 to i64
  %arrayidx31 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom30
  %Time_Step = getelementptr inbounds %struct._Local_Memory* %arrayidx31, i32 0, i32 18
  %36 = load i32* %Time_Step, align 4
  %idxprom32 = sext i32 %36 to i64
  %37 = load %struct._Time_Info** %local_time.addr, align 8
  %arrayidx33 = getelementptr inbounds %struct._Time_Info* %37, i64 %idxprom32
  %other_time = getelementptr inbounds %struct._Time_Info* %arrayidx33, i32 0, i32 7
  %38 = load i64* %other_time, align 8
  %add = add i64 %38, %sub
  store i64 %add, i64* %other_time, align 8
  br label %if.end.34

if.end.34:                                        ; preds = %if.then.28, %if.end.26
  ret void
}

declare void @LockedPrint(i8*, ...)

; Function Attrs: noreturn nounwind
declare void @exit(i32)

; Function Attrs: nounwind uwtable
define void @PrintGrid(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %lsense30 = alloca i32, align 4
  %oldcount35 = alloca i32, align 4
  %newcount39 = alloca i32, align 4
  %updatedcount41 = alloca i32, align 4
  %retVal42 = alloca i32, align 4
  %lsense78 = alloca i32, align 4
  %oldcount83 = alloca i32, align 4
  %newcount87 = alloca i32, align 4
  %updatedcount89 = alloca i32, align 4
  %retVal90 = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load %struct._Box** @Grid, align 8
  %cmp = icmp ne %struct._Box* %0, null
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %1 = load i32* %my_id.addr, align 4
  %cmp1 = icmp eq i32 %1, 0
  br i1 %cmp1, label %if.then.2, label %if.end

if.then.2:                                        ; preds = %if.then
  %call = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([26 x i8]* @.str.1, i32 0, i32 0))
  %call3 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([10 x i8]* @.str.2, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %if.then.2, %if.then
  %2 = load %struct._IO_FILE** @stdout, align 8
  %call4 = call i32 @fflush(%struct._IO_FILE* %2)
  %3 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %3, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %4 = load volatile i32* %gsense, align 4
  store i32 %4, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end, %if.end.23
  %5 = load %struct._G_Mem** @G_Memory, align 8
  %synch5 = getelementptr inbounds %struct._G_Mem* %5, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch5, i32 0, i32 1
  %6 = load volatile i64* %count, align 8
  %conv = trunc i64 %6 to i32
  store i32 %conv, i32* %oldcount, align 4
  %7 = load i32* %oldcount, align 4
  %8 = load i32* %lsense, align 4
  %add = add nsw i32 %7, %8
  store i32 %add, i32* %newcount, align 4
  %9 = load i32* %oldcount, align 4
  %10 = load i32* %newcount, align 4
  %call6 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %9, i32 %10)
  store i32 %call6, i32* %updatedcount, align 4
  %11 = load i32* %updatedcount, align 4
  %12 = load i32* %oldcount, align 4
  %cmp7 = icmp eq i32 %11, %12
  br i1 %cmp7, label %if.then.9, label %if.end.23

if.then.9:                                        ; preds = %while.body
  %13 = load i32* %newcount, align 4
  %14 = load i32* @Number_Of_Processors, align 4
  %cmp10 = icmp eq i32 %13, %14
  br i1 %cmp10, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then.9
  %15 = load i32* %lsense, align 4
  %cmp12 = icmp eq i32 %15, 1
  br i1 %cmp12, label %if.then.19, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then.9
  %16 = load i32* %newcount, align 4
  %cmp14 = icmp eq i32 %16, 0
  br i1 %cmp14, label %land.lhs.true.16, label %if.end.22

land.lhs.true.16:                                 ; preds = %lor.lhs.false
  %17 = load i32* %lsense, align 4
  %cmp17 = icmp eq i32 %17, -1
  br i1 %cmp17, label %if.then.19, label %if.end.22

if.then.19:                                       ; preds = %land.lhs.true.16, %land.lhs.true
  %18 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %18
  %19 = load %struct._G_Mem** @G_Memory, align 8
  %synch20 = getelementptr inbounds %struct._G_Mem* %19, i32 0, i32 6
  %gsense21 = getelementptr inbounds %struct.barrier_t* %synch20, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense21, align 4
  call void @Criteria(i32 8)
  br label %if.end.22

if.end.22:                                        ; preds = %if.then.19, %land.lhs.true.16, %lor.lhs.false
  br label %while.end

if.end.23:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.22
  br label %while.cond

while.cond:                                       ; preds = %while.body.28, %while.end
  %20 = load %struct._G_Mem** @G_Memory, align 8
  %synch24 = getelementptr inbounds %struct._G_Mem* %20, i32 0, i32 6
  %gsense25 = getelementptr inbounds %struct.barrier_t* %synch24, i32 0, i32 0
  %21 = load volatile i32* %gsense25, align 4
  %22 = load i32* %lsense, align 4
  %cmp26 = icmp eq i32 %21, %22
  br i1 %cmp26, label %while.body.28, label %while.end.29

while.body.28:                                    ; preds = %while.cond
  br label %while.cond

while.end.29:                                     ; preds = %while.cond
  call void @Criteria(i32 8)
  %23 = load i32* %my_id.addr, align 4
  call void @PartitionIterate(i32 %23, void (i32, %struct._Box*)* bitcast (void (%struct._Box*)* @PrintBox to void (i32, %struct._Box*)*), i32 0)
  %24 = load %struct._G_Mem** @G_Memory, align 8
  %synch31 = getelementptr inbounds %struct._G_Mem* %24, i32 0, i32 6
  %gsense32 = getelementptr inbounds %struct.barrier_t* %synch31, i32 0, i32 0
  %25 = load volatile i32* %gsense32, align 4
  store i32 %25, i32* %lsense30, align 4
  br label %while.body.34

while.body.34:                                    ; preds = %while.end.29, %if.end.63
  %26 = load %struct._G_Mem** @G_Memory, align 8
  %synch36 = getelementptr inbounds %struct._G_Mem* %26, i32 0, i32 6
  %count37 = getelementptr inbounds %struct.barrier_t* %synch36, i32 0, i32 1
  %27 = load volatile i64* %count37, align 8
  %conv38 = trunc i64 %27 to i32
  store i32 %conv38, i32* %oldcount35, align 4
  %28 = load i32* %oldcount35, align 4
  %29 = load i32* %lsense30, align 4
  %add40 = add nsw i32 %28, %29
  store i32 %add40, i32* %newcount39, align 4
  %30 = load i32* %oldcount35, align 4
  %31 = load i32* %newcount39, align 4
  %call43 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %30, i32 %31)
  store i32 %call43, i32* %updatedcount41, align 4
  %32 = load i32* %updatedcount41, align 4
  %33 = load i32* %oldcount35, align 4
  %cmp44 = icmp eq i32 %32, %33
  br i1 %cmp44, label %if.then.46, label %if.end.63

if.then.46:                                       ; preds = %while.body.34
  %34 = load i32* %newcount39, align 4
  %35 = load i32* @Number_Of_Processors, align 4
  %cmp47 = icmp eq i32 %34, %35
  br i1 %cmp47, label %land.lhs.true.49, label %lor.lhs.false.52

land.lhs.true.49:                                 ; preds = %if.then.46
  %36 = load i32* %lsense30, align 4
  %cmp50 = icmp eq i32 %36, 1
  br i1 %cmp50, label %if.then.58, label %lor.lhs.false.52

lor.lhs.false.52:                                 ; preds = %land.lhs.true.49, %if.then.46
  %37 = load i32* %newcount39, align 4
  %cmp53 = icmp eq i32 %37, 0
  br i1 %cmp53, label %land.lhs.true.55, label %if.end.62

land.lhs.true.55:                                 ; preds = %lor.lhs.false.52
  %38 = load i32* %lsense30, align 4
  %cmp56 = icmp eq i32 %38, -1
  br i1 %cmp56, label %if.then.58, label %if.end.62

if.then.58:                                       ; preds = %land.lhs.true.55, %land.lhs.true.49
  %39 = load i32* %lsense30, align 4
  %sub59 = sub nsw i32 0, %39
  %40 = load %struct._G_Mem** @G_Memory, align 8
  %synch60 = getelementptr inbounds %struct._G_Mem* %40, i32 0, i32 6
  %gsense61 = getelementptr inbounds %struct.barrier_t* %synch60, i32 0, i32 0
  store volatile i32 %sub59, i32* %gsense61, align 4
  call void @Criteria(i32 9)
  br label %if.end.62

if.end.62:                                        ; preds = %if.then.58, %land.lhs.true.55, %lor.lhs.false.52
  br label %while.end.64

if.end.63:                                        ; preds = %while.body.34
  br label %while.body.34

while.end.64:                                     ; preds = %if.end.62
  br label %while.cond.65

while.cond.65:                                    ; preds = %while.body.70, %while.end.64
  %41 = load %struct._G_Mem** @G_Memory, align 8
  %synch66 = getelementptr inbounds %struct._G_Mem* %41, i32 0, i32 6
  %gsense67 = getelementptr inbounds %struct.barrier_t* %synch66, i32 0, i32 0
  %42 = load volatile i32* %gsense67, align 4
  %43 = load i32* %lsense30, align 4
  %cmp68 = icmp eq i32 %42, %43
  br i1 %cmp68, label %while.body.70, label %while.end.71

while.body.70:                                    ; preds = %while.cond.65
  br label %while.cond.65

while.end.71:                                     ; preds = %while.cond.65
  call void @Criteria(i32 9)
  %44 = load i32* %my_id.addr, align 4
  %cmp72 = icmp eq i32 %44, 0
  br i1 %cmp72, label %if.then.74, label %if.end.76

if.then.74:                                       ; preds = %while.end.71
  %call75 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([2 x i8]* @.str.3, i32 0, i32 0))
  br label %if.end.76

if.end.76:                                        ; preds = %if.then.74, %while.end.71
  %45 = load %struct._IO_FILE** @stdout, align 8
  %call77 = call i32 @fflush(%struct._IO_FILE* %45)
  %46 = load %struct._G_Mem** @G_Memory, align 8
  %synch79 = getelementptr inbounds %struct._G_Mem* %46, i32 0, i32 6
  %gsense80 = getelementptr inbounds %struct.barrier_t* %synch79, i32 0, i32 0
  %47 = load volatile i32* %gsense80, align 4
  store i32 %47, i32* %lsense78, align 4
  br label %while.body.82

while.body.82:                                    ; preds = %if.end.76, %if.end.111
  %48 = load %struct._G_Mem** @G_Memory, align 8
  %synch84 = getelementptr inbounds %struct._G_Mem* %48, i32 0, i32 6
  %count85 = getelementptr inbounds %struct.barrier_t* %synch84, i32 0, i32 1
  %49 = load volatile i64* %count85, align 8
  %conv86 = trunc i64 %49 to i32
  store i32 %conv86, i32* %oldcount83, align 4
  %50 = load i32* %oldcount83, align 4
  %51 = load i32* %lsense78, align 4
  %add88 = add nsw i32 %50, %51
  store i32 %add88, i32* %newcount87, align 4
  %52 = load i32* %oldcount83, align 4
  %53 = load i32* %newcount87, align 4
  %call91 = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %52, i32 %53)
  store i32 %call91, i32* %updatedcount89, align 4
  %54 = load i32* %updatedcount89, align 4
  %55 = load i32* %oldcount83, align 4
  %cmp92 = icmp eq i32 %54, %55
  br i1 %cmp92, label %if.then.94, label %if.end.111

if.then.94:                                       ; preds = %while.body.82
  %56 = load i32* %newcount87, align 4
  %57 = load i32* @Number_Of_Processors, align 4
  %cmp95 = icmp eq i32 %56, %57
  br i1 %cmp95, label %land.lhs.true.97, label %lor.lhs.false.100

land.lhs.true.97:                                 ; preds = %if.then.94
  %58 = load i32* %lsense78, align 4
  %cmp98 = icmp eq i32 %58, 1
  br i1 %cmp98, label %if.then.106, label %lor.lhs.false.100

lor.lhs.false.100:                                ; preds = %land.lhs.true.97, %if.then.94
  %59 = load i32* %newcount87, align 4
  %cmp101 = icmp eq i32 %59, 0
  br i1 %cmp101, label %land.lhs.true.103, label %if.end.110

land.lhs.true.103:                                ; preds = %lor.lhs.false.100
  %60 = load i32* %lsense78, align 4
  %cmp104 = icmp eq i32 %60, -1
  br i1 %cmp104, label %if.then.106, label %if.end.110

if.then.106:                                      ; preds = %land.lhs.true.103, %land.lhs.true.97
  %61 = load i32* %lsense78, align 4
  %sub107 = sub nsw i32 0, %61
  %62 = load %struct._G_Mem** @G_Memory, align 8
  %synch108 = getelementptr inbounds %struct._G_Mem* %62, i32 0, i32 6
  %gsense109 = getelementptr inbounds %struct.barrier_t* %synch108, i32 0, i32 0
  store volatile i32 %sub107, i32* %gsense109, align 4
  call void @Criteria(i32 10)
  br label %if.end.110

if.end.110:                                       ; preds = %if.then.106, %land.lhs.true.103, %lor.lhs.false.100
  br label %while.end.112

if.end.111:                                       ; preds = %while.body.82
  br label %while.body.82

while.end.112:                                    ; preds = %if.end.110
  br label %while.cond.113

while.cond.113:                                   ; preds = %while.body.118, %while.end.112
  %63 = load %struct._G_Mem** @G_Memory, align 8
  %synch114 = getelementptr inbounds %struct._G_Mem* %63, i32 0, i32 6
  %gsense115 = getelementptr inbounds %struct.barrier_t* %synch114, i32 0, i32 0
  %64 = load volatile i32* %gsense115, align 4
  %65 = load i32* %lsense78, align 4
  %cmp116 = icmp eq i32 %64, %65
  br i1 %cmp116, label %while.body.118, label %while.end.119

while.body.118:                                   ; preds = %while.cond.113
  br label %while.cond.113

while.end.119:                                    ; preds = %while.cond.113
  call void @Criteria(i32 10)
  br label %if.end.121

if.else:                                          ; preds = %entry
  %call120 = call i32 (i8*, ...) *@printf(i8* getelementptr inbounds ([45 x i8]* @.str.4, i32 0, i32 0))
  br label %if.end.121

if.end.121:                                       ; preds = %if.else, %while.end.119
  ret void
}

declare i32 @printf(i8*, ...)

declare i32 @fflush(%struct._IO_FILE*)

declare void @PrintBox(%struct._Box*)

; Function Attrs: nounwind uwtable
define void @DetermineLocalGridSize(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  %x_pos1 = alloca double, align 8
  %x_pos2 = alloca double, align 8
  %y_pos1 = alloca double, align 8
  %y_pos2 = alloca double, align 8
  %x_max_challenger = alloca double, align 8
  %x_min_challenger = alloca double, align 8
  %y_max_challenger = alloca double, align 8
  %y_min_challenger = alloca double, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Local_X_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 11
  store double 0xFFF0000000000000, double* %Local_X_Max, align 8
  %1 = load i32* %my_id.addr, align 4
  %idxprom1 = sext i32 %1 to i64
  %arrayidx2 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom1
  %Local_X_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx2, i32 0, i32 12
  store double 0x7FF0000000000000, double* %Local_X_Min, align 8
  %2 = load i32* %my_id.addr, align 4
  %idxprom3 = sext i32 %2 to i64
  %arrayidx4 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom3
  %Local_Y_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx4, i32 0, i32 13
  store double 0xFFF0000000000000, double* %Local_Y_Max, align 8
  %3 = load i32* %my_id.addr, align 4
  %idxprom5 = sext i32 %3 to i64
  %arrayidx6 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom5
  %Local_Y_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx6, i32 0, i32 14
  store double 0x7FF0000000000000, double* %Local_Y_Min, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i32* %i, align 4
  %5 = load i32* %my_id.addr, align 4
  %idxprom7 = sext i32 %5 to i64
  %arrayidx8 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom7
  %Num_Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx8, i32 0, i32 5
  %6 = load i32* %Num_Particles, align 4
  %sub = sub nsw i32 %6, 1
  %cmp = icmp slt i32 %4, %sub
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %7 = load i32* %i, align 4
  %idxprom9 = sext i32 %7 to i64
  %8 = load i32* %my_id.addr, align 4
  %idxprom10 = sext i32 %8 to i64
  %arrayidx11 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom10
  %Particles = getelementptr inbounds %struct._Local_Memory* %arrayidx11, i32 0, i32 4
  %9 = load %struct._Particle*** %Particles, align 8
  %arrayidx12 = getelementptr inbounds %struct._Particle** %9, i64 %idxprom9
  %10 = load %struct._Particle** %arrayidx12, align 8
  %pos = getelementptr inbounds %struct._Particle* %10, i32 0, i32 3
  %x = getelementptr inbounds %struct._Vector* %pos, i32 0, i32 0
  %11 = load double* %x, align 8
  store double %11, double* %x_pos1, align 8
  %12 = load i32* %i, align 4
  %idxprom13 = sext i32 %12 to i64
  %13 = load i32* %my_id.addr, align 4
  %idxprom14 = sext i32 %13 to i64
  %arrayidx15 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom14
  %Particles16 = getelementptr inbounds %struct._Local_Memory* %arrayidx15, i32 0, i32 4
  %14 = load %struct._Particle*** %Particles16, align 8
  %arrayidx17 = getelementptr inbounds %struct._Particle** %14, i64 %idxprom13
  %15 = load %struct._Particle** %arrayidx17, align 8
  %pos18 = getelementptr inbounds %struct._Particle* %15, i32 0, i32 3
  %y = getelementptr inbounds %struct._Vector* %pos18, i32 0, i32 1
  %16 = load double* %y, align 8
  store double %16, double* %y_pos1, align 8
  %17 = load i32* %i, align 4
  %add = add nsw i32 %17, 1
  %idxprom19 = sext i32 %add to i64
  %18 = load i32* %my_id.addr, align 4
  %idxprom20 = sext i32 %18 to i64
  %arrayidx21 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom20
  %Particles22 = getelementptr inbounds %struct._Local_Memory* %arrayidx21, i32 0, i32 4
  %19 = load %struct._Particle*** %Particles22, align 8
  %arrayidx23 = getelementptr inbounds %struct._Particle** %19, i64 %idxprom19
  %20 = load %struct._Particle** %arrayidx23, align 8
  %pos24 = getelementptr inbounds %struct._Particle* %20, i32 0, i32 3
  %x25 = getelementptr inbounds %struct._Vector* %pos24, i32 0, i32 0
  %21 = load double* %x25, align 8
  store double %21, double* %x_pos2, align 8
  %22 = load i32* %i, align 4
  %add26 = add nsw i32 %22, 1
  %idxprom27 = sext i32 %add26 to i64
  %23 = load i32* %my_id.addr, align 4
  %idxprom28 = sext i32 %23 to i64
  %arrayidx29 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom28
  %Particles30 = getelementptr inbounds %struct._Local_Memory* %arrayidx29, i32 0, i32 4
  %24 = load %struct._Particle*** %Particles30, align 8
  %arrayidx31 = getelementptr inbounds %struct._Particle** %24, i64 %idxprom27
  %25 = load %struct._Particle** %arrayidx31, align 8
  %pos32 = getelementptr inbounds %struct._Particle* %25, i32 0, i32 3
  %y33 = getelementptr inbounds %struct._Vector* %pos32, i32 0, i32 1
  %26 = load double* %y33, align 8
  store double %26, double* %y_pos2, align 8
  %27 = load double* %x_pos1, align 8
  %28 = load double* %x_pos2, align 8
  %cmp34 = fcmp ogt double %27, %28
  br i1 %cmp34, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %29 = load double* %x_pos1, align 8
  store double %29, double* %x_max_challenger, align 8
  %30 = load double* %x_pos2, align 8
  store double %30, double* %x_min_challenger, align 8
  br label %if.end

if.else:                                          ; preds = %for.body
  %31 = load double* %x_pos2, align 8
  store double %31, double* %x_max_challenger, align 8
  %32 = load double* %x_pos1, align 8
  store double %32, double* %x_min_challenger, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %33 = load double* %y_pos1, align 8
  %34 = load double* %y_pos2, align 8
  %cmp35 = fcmp ogt double %33, %34
  br i1 %cmp35, label %if.then.36, label %if.else.37

if.then.36:                                       ; preds = %if.end
  %35 = load double* %y_pos1, align 8
  store double %35, double* %y_max_challenger, align 8
  %36 = load double* %y_pos2, align 8
  store double %36, double* %y_min_challenger, align 8
  br label %if.end.38

if.else.37:                                       ; preds = %if.end
  %37 = load double* %y_pos2, align 8
  store double %37, double* %y_max_challenger, align 8
  %38 = load double* %y_pos1, align 8
  store double %38, double* %y_min_challenger, align 8
  br label %if.end.38

if.end.38:                                        ; preds = %if.else.37, %if.then.36
  %39 = load double* %x_max_challenger, align 8
  %40 = load i32* %my_id.addr, align 4
  %idxprom39 = sext i32 %40 to i64
  %arrayidx40 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom39
  %Local_X_Max41 = getelementptr inbounds %struct._Local_Memory* %arrayidx40, i32 0, i32 11
  %41 = load double* %Local_X_Max41, align 8
  %cmp42 = fcmp ogt double %39, %41
  br i1 %cmp42, label %if.then.43, label %if.end.47

if.then.43:                                       ; preds = %if.end.38
  %42 = load double* %x_max_challenger, align 8
  %43 = load i32* %my_id.addr, align 4
  %idxprom44 = sext i32 %43 to i64
  %arrayidx45 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom44
  %Local_X_Max46 = getelementptr inbounds %struct._Local_Memory* %arrayidx45, i32 0, i32 11
  store double %42, double* %Local_X_Max46, align 8
  br label %if.end.47

if.end.47:                                        ; preds = %if.then.43, %if.end.38
  %44 = load double* %x_min_challenger, align 8
  %45 = load i32* %my_id.addr, align 4
  %idxprom48 = sext i32 %45 to i64
  %arrayidx49 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom48
  %Local_X_Min50 = getelementptr inbounds %struct._Local_Memory* %arrayidx49, i32 0, i32 12
  %46 = load double* %Local_X_Min50, align 8
  %cmp51 = fcmp olt double %44, %46
  br i1 %cmp51, label %if.then.52, label %if.end.56

if.then.52:                                       ; preds = %if.end.47
  %47 = load double* %x_min_challenger, align 8
  %48 = load i32* %my_id.addr, align 4
  %idxprom53 = sext i32 %48 to i64
  %arrayidx54 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom53
  %Local_X_Min55 = getelementptr inbounds %struct._Local_Memory* %arrayidx54, i32 0, i32 12
  store double %47, double* %Local_X_Min55, align 8
  br label %if.end.56

if.end.56:                                        ; preds = %if.then.52, %if.end.47
  %49 = load double* %y_max_challenger, align 8
  %50 = load i32* %my_id.addr, align 4
  %idxprom57 = sext i32 %50 to i64
  %arrayidx58 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom57
  %Local_Y_Max59 = getelementptr inbounds %struct._Local_Memory* %arrayidx58, i32 0, i32 13
  %51 = load double* %Local_Y_Max59, align 8
  %cmp60 = fcmp ogt double %49, %51
  br i1 %cmp60, label %if.then.61, label %if.end.65

if.then.61:                                       ; preds = %if.end.56
  %52 = load double* %y_max_challenger, align 8
  %53 = load i32* %my_id.addr, align 4
  %idxprom62 = sext i32 %53 to i64
  %arrayidx63 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom62
  %Local_Y_Max64 = getelementptr inbounds %struct._Local_Memory* %arrayidx63, i32 0, i32 13
  store double %52, double* %Local_Y_Max64, align 8
  br label %if.end.65

if.end.65:                                        ; preds = %if.then.61, %if.end.56
  %54 = load double* %y_min_challenger, align 8
  %55 = load i32* %my_id.addr, align 4
  %idxprom66 = sext i32 %55 to i64
  %arrayidx67 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom66
  %Local_Y_Min68 = getelementptr inbounds %struct._Local_Memory* %arrayidx67, i32 0, i32 14
  %56 = load double* %Local_Y_Min68, align 8
  %cmp69 = fcmp olt double %54, %56
  br i1 %cmp69, label %if.then.70, label %if.end.74

if.then.70:                                       ; preds = %if.end.65
  %57 = load double* %y_min_challenger, align 8
  %58 = load i32* %my_id.addr, align 4
  %idxprom71 = sext i32 %58 to i64
  %arrayidx72 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom71
  %Local_Y_Min73 = getelementptr inbounds %struct._Local_Memory* %arrayidx72, i32 0, i32 14
  store double %57, double* %Local_Y_Min73, align 8
  br label %if.end.74

if.end.74:                                        ; preds = %if.then.70, %if.end.65
  br label %for.inc

for.inc:                                          ; preds = %if.end.74
  %59 = load i32* %i, align 4
  %add75 = add nsw i32 %59, 2
  store i32 %add75, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %60 = load i32* %i, align 4
  %61 = load i32* %my_id.addr, align 4
  %idxprom76 = sext i32 %61 to i64
  %arrayidx77 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom76
  %Num_Particles78 = getelementptr inbounds %struct._Local_Memory* %arrayidx77, i32 0, i32 5
  %62 = load i32* %Num_Particles78, align 4
  %sub79 = sub nsw i32 %62, 1
  %cmp80 = icmp eq i32 %60, %sub79
  br i1 %cmp80, label %if.then.81, label %if.end.146

if.then.81:                                       ; preds = %for.end
  %63 = load i32* %i, align 4
  %idxprom82 = sext i32 %63 to i64
  %64 = load i32* %my_id.addr, align 4
  %idxprom83 = sext i32 %64 to i64
  %arrayidx84 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom83
  %Particles85 = getelementptr inbounds %struct._Local_Memory* %arrayidx84, i32 0, i32 4
  %65 = load %struct._Particle*** %Particles85, align 8
  %arrayidx86 = getelementptr inbounds %struct._Particle** %65, i64 %idxprom82
  %66 = load %struct._Particle** %arrayidx86, align 8
  %pos87 = getelementptr inbounds %struct._Particle* %66, i32 0, i32 3
  %x88 = getelementptr inbounds %struct._Vector* %pos87, i32 0, i32 0
  %67 = load double* %x88, align 8
  store double %67, double* %x_max_challenger, align 8
  %68 = load i32* %i, align 4
  %idxprom89 = sext i32 %68 to i64
  %69 = load i32* %my_id.addr, align 4
  %idxprom90 = sext i32 %69 to i64
  %arrayidx91 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom90
  %Particles92 = getelementptr inbounds %struct._Local_Memory* %arrayidx91, i32 0, i32 4
  %70 = load %struct._Particle*** %Particles92, align 8
  %arrayidx93 = getelementptr inbounds %struct._Particle** %70, i64 %idxprom89
  %71 = load %struct._Particle** %arrayidx93, align 8
  %pos94 = getelementptr inbounds %struct._Particle* %71, i32 0, i32 3
  %x95 = getelementptr inbounds %struct._Vector* %pos94, i32 0, i32 0
  %72 = load double* %x95, align 8
  store double %72, double* %x_min_challenger, align 8
  %73 = load i32* %i, align 4
  %idxprom96 = sext i32 %73 to i64
  %74 = load i32* %my_id.addr, align 4
  %idxprom97 = sext i32 %74 to i64
  %arrayidx98 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom97
  %Particles99 = getelementptr inbounds %struct._Local_Memory* %arrayidx98, i32 0, i32 4
  %75 = load %struct._Particle*** %Particles99, align 8
  %arrayidx100 = getelementptr inbounds %struct._Particle** %75, i64 %idxprom96
  %76 = load %struct._Particle** %arrayidx100, align 8
  %pos101 = getelementptr inbounds %struct._Particle* %76, i32 0, i32 3
  %y102 = getelementptr inbounds %struct._Vector* %pos101, i32 0, i32 1
  %77 = load double* %y102, align 8
  store double %77, double* %y_max_challenger, align 8
  %78 = load i32* %i, align 4
  %idxprom103 = sext i32 %78 to i64
  %79 = load i32* %my_id.addr, align 4
  %idxprom104 = sext i32 %79 to i64
  %arrayidx105 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom104
  %Particles106 = getelementptr inbounds %struct._Local_Memory* %arrayidx105, i32 0, i32 4
  %80 = load %struct._Particle*** %Particles106, align 8
  %arrayidx107 = getelementptr inbounds %struct._Particle** %80, i64 %idxprom103
  %81 = load %struct._Particle** %arrayidx107, align 8
  %pos108 = getelementptr inbounds %struct._Particle* %81, i32 0, i32 3
  %y109 = getelementptr inbounds %struct._Vector* %pos108, i32 0, i32 1
  %82 = load double* %y109, align 8
  store double %82, double* %y_min_challenger, align 8
  %83 = load double* %x_max_challenger, align 8
  %84 = load i32* %my_id.addr, align 4
  %idxprom110 = sext i32 %84 to i64
  %arrayidx111 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom110
  %Local_X_Max112 = getelementptr inbounds %struct._Local_Memory* %arrayidx111, i32 0, i32 11
  %85 = load double* %Local_X_Max112, align 8
  %cmp113 = fcmp ogt double %83, %85
  br i1 %cmp113, label %if.then.114, label %if.end.118

if.then.114:                                      ; preds = %if.then.81
  %86 = load double* %x_max_challenger, align 8
  %87 = load i32* %my_id.addr, align 4
  %idxprom115 = sext i32 %87 to i64
  %arrayidx116 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom115
  %Local_X_Max117 = getelementptr inbounds %struct._Local_Memory* %arrayidx116, i32 0, i32 11
  store double %86, double* %Local_X_Max117, align 8
  br label %if.end.118

if.end.118:                                       ; preds = %if.then.114, %if.then.81
  %88 = load double* %x_min_challenger, align 8
  %89 = load i32* %my_id.addr, align 4
  %idxprom119 = sext i32 %89 to i64
  %arrayidx120 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom119
  %Local_X_Min121 = getelementptr inbounds %struct._Local_Memory* %arrayidx120, i32 0, i32 12
  %90 = load double* %Local_X_Min121, align 8
  %cmp122 = fcmp olt double %88, %90
  br i1 %cmp122, label %if.then.123, label %if.end.127

if.then.123:                                      ; preds = %if.end.118
  %91 = load double* %x_min_challenger, align 8
  %92 = load i32* %my_id.addr, align 4
  %idxprom124 = sext i32 %92 to i64
  %arrayidx125 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom124
  %Local_X_Min126 = getelementptr inbounds %struct._Local_Memory* %arrayidx125, i32 0, i32 12
  store double %91, double* %Local_X_Min126, align 8
  br label %if.end.127

if.end.127:                                       ; preds = %if.then.123, %if.end.118
  %93 = load double* %y_max_challenger, align 8
  %94 = load i32* %my_id.addr, align 4
  %idxprom128 = sext i32 %94 to i64
  %arrayidx129 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom128
  %Local_Y_Max130 = getelementptr inbounds %struct._Local_Memory* %arrayidx129, i32 0, i32 13
  %95 = load double* %Local_Y_Max130, align 8
  %cmp131 = fcmp ogt double %93, %95
  br i1 %cmp131, label %if.then.132, label %if.end.136

if.then.132:                                      ; preds = %if.end.127
  %96 = load double* %y_max_challenger, align 8
  %97 = load i32* %my_id.addr, align 4
  %idxprom133 = sext i32 %97 to i64
  %arrayidx134 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom133
  %Local_Y_Max135 = getelementptr inbounds %struct._Local_Memory* %arrayidx134, i32 0, i32 13
  store double %96, double* %Local_Y_Max135, align 8
  br label %if.end.136

if.end.136:                                       ; preds = %if.then.132, %if.end.127
  %98 = load double* %y_min_challenger, align 8
  %99 = load i32* %my_id.addr, align 4
  %idxprom137 = sext i32 %99 to i64
  %arrayidx138 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom137
  %Local_Y_Min139 = getelementptr inbounds %struct._Local_Memory* %arrayidx138, i32 0, i32 14
  %100 = load double* %Local_Y_Min139, align 8
  %cmp140 = fcmp olt double %98, %100
  br i1 %cmp140, label %if.then.141, label %if.end.145

if.then.141:                                      ; preds = %if.end.136
  %101 = load double* %y_min_challenger, align 8
  %102 = load i32* %my_id.addr, align 4
  %idxprom142 = sext i32 %102 to i64
  %arrayidx143 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom142
  %Local_Y_Min144 = getelementptr inbounds %struct._Local_Memory* %arrayidx143, i32 0, i32 14
  store double %101, double* %Local_Y_Min144, align 8
  br label %if.end.145

if.end.145:                                       ; preds = %if.then.141, %if.end.136
  br label %if.end.146

if.end.146:                                       ; preds = %if.end.145, %for.end
  ret void
}

; Function Attrs: nounwind uwtable
define void @MergeLocalGridSize(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  %my_f_array = alloca double*, align 8
  %their_f_array = alloca double*, align 8
  %x_max_challenger = alloca double, align 8
  %x_min_challenger = alloca double, align 8
  %y_max_challenger = alloca double, align 8
  %y_min_challenger = alloca double, align 8
  %i = alloca i32, align 4
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %0 to i64
  %1 = load %struct._G_Mem** @G_Memory, align 8
  %f_array = getelementptr inbounds %struct._G_Mem* %1, i32 0, i32 9
  %arrayidx = getelementptr inbounds [64 x [4 x double]]* %f_array, i32 0, i64 %idxprom
  %arraydecay = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i32 0
  store double* %arraydecay, double** %my_f_array, align 8
  %2 = load i32* %my_id.addr, align 4
  %idxprom1 = sext i32 %2 to i64
  %arrayidx2 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom1
  %Local_X_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx2, i32 0, i32 11
  %3 = load double* %Local_X_Max, align 8
  %4 = load double** %my_f_array, align 8
  %arrayidx3 = getelementptr inbounds double* %4, i64 0
  store double %3, double* %arrayidx3, align 8
  %5 = load i32* %my_id.addr, align 4
  %idxprom4 = sext i32 %5 to i64
  %arrayidx5 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom4
  %Local_X_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx5, i32 0, i32 12
  %6 = load double* %Local_X_Min, align 8
  %7 = load double** %my_f_array, align 8
  %arrayidx6 = getelementptr inbounds double* %7, i64 1
  store double %6, double* %arrayidx6, align 8
  %8 = load i32* %my_id.addr, align 4
  %idxprom7 = sext i32 %8 to i64
  %arrayidx8 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom7
  %Local_Y_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx8, i32 0, i32 13
  %9 = load double* %Local_Y_Max, align 8
  %10 = load double** %my_f_array, align 8
  %arrayidx9 = getelementptr inbounds double* %10, i64 2
  store double %9, double* %arrayidx9, align 8
  %11 = load i32* %my_id.addr, align 4
  %idxprom10 = sext i32 %11 to i64
  %arrayidx11 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom10
  %Local_Y_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx11, i32 0, i32 14
  %12 = load double* %Local_Y_Min, align 8
  %13 = load double** %my_f_array, align 8
  %arrayidx12 = getelementptr inbounds double* %13, i64 3
  store double %12, double* %arrayidx12, align 8
  %14 = load %struct._G_Mem** @G_Memory, align 8
  %synch = getelementptr inbounds %struct._G_Mem* %14, i32 0, i32 6
  %gsense = getelementptr inbounds %struct.barrier_t* %synch, i32 0, i32 0
  %15 = load volatile i32* %gsense, align 4
  store i32 %15, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %entry, %if.end.27
  %16 = load %struct._G_Mem** @G_Memory, align 8
  %synch13 = getelementptr inbounds %struct._G_Mem* %16, i32 0, i32 6
  %count = getelementptr inbounds %struct.barrier_t* %synch13, i32 0, i32 1
  %17 = load volatile i64* %count, align 8
  %conv = trunc i64 %17 to i32
  store i32 %conv, i32* %oldcount, align 4
  %18 = load i32* %oldcount, align 4
  %19 = load i32* %lsense, align 4
  %add = add nsw i32 %18, %19
  store i32 %add, i32* %newcount, align 4
  %20 = load i32* %oldcount, align 4
  %21 = load i32* %newcount, align 4
  %call = call i32 (i32, i32, ...) *bitcast (i32 (...)* @atomic_cmpxchg to i32 (i32, i32, ...)*)(i32 %20, i32 %21)
  store i32 %call, i32* %updatedcount, align 4
  %22 = load i32* %updatedcount, align 4
  %23 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %22, %23
  br i1 %cmp, label %if.then, label %if.end.27

if.then:                                          ; preds = %while.body
  %24 = load i32* %newcount, align 4
  %25 = load i32* @Number_Of_Processors, align 4
  %cmp15 = icmp eq i32 %24, %25
  br i1 %cmp15, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %26 = load i32* %lsense, align 4
  %cmp17 = icmp eq i32 %26, 1
  br i1 %cmp17, label %if.then.24, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %27 = load i32* %newcount, align 4
  %cmp19 = icmp eq i32 %27, 0
  br i1 %cmp19, label %land.lhs.true.21, label %if.end

land.lhs.true.21:                                 ; preds = %lor.lhs.false
  %28 = load i32* %lsense, align 4
  %cmp22 = icmp eq i32 %28, -1
  br i1 %cmp22, label %if.then.24, label %if.end

if.then.24:                                       ; preds = %land.lhs.true.21, %land.lhs.true
  %29 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %29
  %30 = load %struct._G_Mem** @G_Memory, align 8
  %synch25 = getelementptr inbounds %struct._G_Mem* %30, i32 0, i32 6
  %gsense26 = getelementptr inbounds %struct.barrier_t* %synch25, i32 0, i32 0
  store volatile i32 %sub, i32* %gsense26, align 4
  call void @Criteria(i32 11)
  br label %if.end

if.end:                                           ; preds = %if.then.24, %land.lhs.true.21, %lor.lhs.false
  br label %while.end

if.end.27:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.32, %while.end
  %31 = load %struct._G_Mem** @G_Memory, align 8
  %synch28 = getelementptr inbounds %struct._G_Mem* %31, i32 0, i32 6
  %gsense29 = getelementptr inbounds %struct.barrier_t* %synch28, i32 0, i32 0
  %32 = load volatile i32* %gsense29, align 4
  %33 = load i32* %lsense, align 4
  %cmp30 = icmp eq i32 %32, %33
  br i1 %cmp30, label %while.body.32, label %while.end.33

while.body.32:                                    ; preds = %while.cond
  br label %while.cond

while.end.33:                                     ; preds = %while.cond
  call void @Criteria(i32 11)
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end.33
  %34 = load i32* %i, align 4
  %35 = load i32* @Number_Of_Processors, align 4
  %cmp34 = icmp slt i32 %34, %35
  br i1 %cmp34, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %36 = load i32* %i, align 4
  %idxprom36 = sext i32 %36 to i64
  %37 = load %struct._G_Mem** @G_Memory, align 8
  %f_array37 = getelementptr inbounds %struct._G_Mem* %37, i32 0, i32 9
  %arrayidx38 = getelementptr inbounds [64 x [4 x double]]* %f_array37, i32 0, i64 %idxprom36
  %arraydecay39 = getelementptr inbounds [4 x double]* %arrayidx38, i32 0, i32 0
  store double* %arraydecay39, double** %their_f_array, align 8
  %38 = load double** %their_f_array, align 8
  %arrayidx40 = getelementptr inbounds double* %38, i64 0
  %39 = load double* %arrayidx40, align 8
  store double %39, double* %x_max_challenger, align 8
  %40 = load double** %their_f_array, align 8
  %arrayidx41 = getelementptr inbounds double* %40, i64 1
  %41 = load double* %arrayidx41, align 8
  store double %41, double* %x_min_challenger, align 8
  %42 = load double** %their_f_array, align 8
  %arrayidx42 = getelementptr inbounds double* %42, i64 2
  %43 = load double* %arrayidx42, align 8
  store double %43, double* %y_max_challenger, align 8
  %44 = load double** %their_f_array, align 8
  %arrayidx43 = getelementptr inbounds double* %44, i64 3
  %45 = load double* %arrayidx43, align 8
  store double %45, double* %y_min_challenger, align 8
  %46 = load double* %x_max_challenger, align 8
  %47 = load i32* %my_id.addr, align 4
  %idxprom44 = sext i32 %47 to i64
  %arrayidx45 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom44
  %Local_X_Max46 = getelementptr inbounds %struct._Local_Memory* %arrayidx45, i32 0, i32 11
  %48 = load double* %Local_X_Max46, align 8
  %cmp47 = fcmp ogt double %46, %48
  br i1 %cmp47, label %if.then.49, label %if.end.53

if.then.49:                                       ; preds = %for.body
  %49 = load double* %x_max_challenger, align 8
  %50 = load i32* %my_id.addr, align 4
  %idxprom50 = sext i32 %50 to i64
  %arrayidx51 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom50
  %Local_X_Max52 = getelementptr inbounds %struct._Local_Memory* %arrayidx51, i32 0, i32 11
  store double %49, double* %Local_X_Max52, align 8
  br label %if.end.53

if.end.53:                                        ; preds = %if.then.49, %for.body
  %51 = load double* %x_min_challenger, align 8
  %52 = load i32* %my_id.addr, align 4
  %idxprom54 = sext i32 %52 to i64
  %arrayidx55 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom54
  %Local_X_Min56 = getelementptr inbounds %struct._Local_Memory* %arrayidx55, i32 0, i32 12
  %53 = load double* %Local_X_Min56, align 8
  %cmp57 = fcmp olt double %51, %53
  br i1 %cmp57, label %if.then.59, label %if.end.63

if.then.59:                                       ; preds = %if.end.53
  %54 = load double* %x_min_challenger, align 8
  %55 = load i32* %my_id.addr, align 4
  %idxprom60 = sext i32 %55 to i64
  %arrayidx61 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom60
  %Local_X_Min62 = getelementptr inbounds %struct._Local_Memory* %arrayidx61, i32 0, i32 12
  store double %54, double* %Local_X_Min62, align 8
  br label %if.end.63

if.end.63:                                        ; preds = %if.then.59, %if.end.53
  %56 = load double* %y_max_challenger, align 8
  %57 = load i32* %my_id.addr, align 4
  %idxprom64 = sext i32 %57 to i64
  %arrayidx65 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom64
  %Local_Y_Max66 = getelementptr inbounds %struct._Local_Memory* %arrayidx65, i32 0, i32 13
  %58 = load double* %Local_Y_Max66, align 8
  %cmp67 = fcmp ogt double %56, %58
  br i1 %cmp67, label %if.then.69, label %if.end.73

if.then.69:                                       ; preds = %if.end.63
  %59 = load double* %y_max_challenger, align 8
  %60 = load i32* %my_id.addr, align 4
  %idxprom70 = sext i32 %60 to i64
  %arrayidx71 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom70
  %Local_Y_Max72 = getelementptr inbounds %struct._Local_Memory* %arrayidx71, i32 0, i32 13
  store double %59, double* %Local_Y_Max72, align 8
  br label %if.end.73

if.end.73:                                        ; preds = %if.then.69, %if.end.63
  %61 = load double* %y_min_challenger, align 8
  %62 = load i32* %my_id.addr, align 4
  %idxprom74 = sext i32 %62 to i64
  %arrayidx75 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom74
  %Local_Y_Min76 = getelementptr inbounds %struct._Local_Memory* %arrayidx75, i32 0, i32 14
  %63 = load double* %Local_Y_Min76, align 8
  %cmp77 = fcmp olt double %61, %63
  br i1 %cmp77, label %if.then.79, label %if.end.83

if.then.79:                                       ; preds = %if.end.73
  %64 = load double* %y_min_challenger, align 8
  %65 = load i32* %my_id.addr, align 4
  %idxprom80 = sext i32 %65 to i64
  %arrayidx81 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom80
  %Local_Y_Min82 = getelementptr inbounds %struct._Local_Memory* %arrayidx81, i32 0, i32 14
  store double %64, double* %Local_Y_Min82, align 8
  br label %if.end.83

if.end.83:                                        ; preds = %if.then.79, %if.end.73
  br label %for.inc

for.inc:                                          ; preds = %if.end.83
  %66 = load i32* %i, align 4
  %inc = add nsw i32 %66, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define %struct._Box* @InitGrid(i32 %my_id) {
entry:
  %my_id.addr = alloca i32, align 4
  %x_length = alloca double, align 8
  %y_length = alloca double, align 8
  %grid_length = alloca double, align 8
  %grid_x_center = alloca double, align 8
  %grid_y_center = alloca double, align 8
  %exp = alloca i32, align 4
  %ret_box = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  %0 = load i32* %my_id.addr, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom
  %Local_X_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx, i32 0, i32 11
  %1 = load double* %Local_X_Max, align 8
  %call = call double @frexp(double %1, i32* %exp)
  %2 = load i32* %my_id.addr, align 4
  %idxprom1 = sext i32 %2 to i64
  %arrayidx2 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom1
  %Local_X_Max3 = getelementptr inbounds %struct._Local_Memory* %arrayidx2, i32 0, i32 11
  %3 = load double* %Local_X_Max3, align 8
  %cmp = fcmp ogt double %3, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %4 = load i32* %exp, align 4
  %call4 = call double @ldexp(double 1.000000e+00, i32 %4)
  %5 = load i32* %my_id.addr, align 4
  %idxprom5 = sext i32 %5 to i64
  %arrayidx6 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom5
  %Local_X_Max7 = getelementptr inbounds %struct._Local_Memory* %arrayidx6, i32 0, i32 11
  store double %call4, double* %Local_X_Max7, align 8
  br label %if.end.18

if.else:                                          ; preds = %entry
  %6 = load i32* %my_id.addr, align 4
  %idxprom8 = sext i32 %6 to i64
  %arrayidx9 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom8
  %Local_X_Max10 = getelementptr inbounds %struct._Local_Memory* %arrayidx9, i32 0, i32 11
  %7 = load double* %Local_X_Max10, align 8
  %cmp11 = fcmp olt double %7, 0.000000e+00
  br i1 %cmp11, label %if.then.12, label %if.end

if.then.12:                                       ; preds = %if.else
  %8 = load i32* %exp, align 4
  %sub = sub nsw i32 %8, 1
  %call13 = call double @ldexp(double 1.000000e+00, i32 %sub)
  %sub14 = fsub double -0.000000e+00, %call13
  %9 = load i32* %my_id.addr, align 4
  %idxprom15 = sext i32 %9 to i64
  %arrayidx16 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom15
  %Local_X_Max17 = getelementptr inbounds %struct._Local_Memory* %arrayidx16, i32 0, i32 11
  store double %sub14, double* %Local_X_Max17, align 8
  br label %if.end

if.end:                                           ; preds = %if.then.12, %if.else
  br label %if.end.18

if.end.18:                                        ; preds = %if.end, %if.then
  %10 = load i32* %my_id.addr, align 4
  %idxprom19 = sext i32 %10 to i64
  %arrayidx20 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom19
  %Local_X_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx20, i32 0, i32 12
  %11 = load double* %Local_X_Min, align 8
  %call21 = call double @frexp(double %11, i32* %exp)
  %12 = load i32* %my_id.addr, align 4
  %idxprom22 = sext i32 %12 to i64
  %arrayidx23 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom22
  %Local_X_Min24 = getelementptr inbounds %struct._Local_Memory* %arrayidx23, i32 0, i32 12
  %13 = load double* %Local_X_Min24, align 8
  %cmp25 = fcmp olt double %13, 0.000000e+00
  br i1 %cmp25, label %if.then.26, label %if.else.32

if.then.26:                                       ; preds = %if.end.18
  %14 = load i32* %exp, align 4
  %call27 = call double @ldexp(double 1.000000e+00, i32 %14)
  %sub28 = fsub double -0.000000e+00, %call27
  %15 = load i32* %my_id.addr, align 4
  %idxprom29 = sext i32 %15 to i64
  %arrayidx30 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom29
  %Local_X_Min31 = getelementptr inbounds %struct._Local_Memory* %arrayidx30, i32 0, i32 12
  store double %sub28, double* %Local_X_Min31, align 8
  br label %if.end.44

if.else.32:                                       ; preds = %if.end.18
  %16 = load i32* %my_id.addr, align 4
  %idxprom33 = sext i32 %16 to i64
  %arrayidx34 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom33
  %Local_X_Min35 = getelementptr inbounds %struct._Local_Memory* %arrayidx34, i32 0, i32 12
  %17 = load double* %Local_X_Min35, align 8
  %cmp36 = fcmp ogt double %17, 0.000000e+00
  br i1 %cmp36, label %if.then.37, label %if.end.43

if.then.37:                                       ; preds = %if.else.32
  %18 = load i32* %exp, align 4
  %sub38 = sub nsw i32 %18, 1
  %call39 = call double @ldexp(double 1.000000e+00, i32 %sub38)
  %19 = load i32* %my_id.addr, align 4
  %idxprom40 = sext i32 %19 to i64
  %arrayidx41 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom40
  %Local_X_Min42 = getelementptr inbounds %struct._Local_Memory* %arrayidx41, i32 0, i32 12
  store double %call39, double* %Local_X_Min42, align 8
  br label %if.end.43

if.end.43:                                        ; preds = %if.then.37, %if.else.32
  br label %if.end.44

if.end.44:                                        ; preds = %if.end.43, %if.then.26
  %20 = load i32* %my_id.addr, align 4
  %idxprom45 = sext i32 %20 to i64
  %arrayidx46 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom45
  %Local_Y_Max = getelementptr inbounds %struct._Local_Memory* %arrayidx46, i32 0, i32 13
  %21 = load double* %Local_Y_Max, align 8
  %call47 = call double @frexp(double %21, i32* %exp)
  %22 = load i32* %my_id.addr, align 4
  %idxprom48 = sext i32 %22 to i64
  %arrayidx49 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom48
  %Local_Y_Max50 = getelementptr inbounds %struct._Local_Memory* %arrayidx49, i32 0, i32 13
  %23 = load double* %Local_Y_Max50, align 8
  %cmp51 = fcmp ogt double %23, 0.000000e+00
  br i1 %cmp51, label %if.then.52, label %if.else.57

if.then.52:                                       ; preds = %if.end.44
  %24 = load i32* %exp, align 4
  %call53 = call double @ldexp(double 1.000000e+00, i32 %24)
  %25 = load i32* %my_id.addr, align 4
  %idxprom54 = sext i32 %25 to i64
  %arrayidx55 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom54
  %Local_Y_Max56 = getelementptr inbounds %struct._Local_Memory* %arrayidx55, i32 0, i32 13
  store double %call53, double* %Local_Y_Max56, align 8
  br label %if.end.70

if.else.57:                                       ; preds = %if.end.44
  %26 = load i32* %my_id.addr, align 4
  %idxprom58 = sext i32 %26 to i64
  %arrayidx59 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom58
  %Local_Y_Max60 = getelementptr inbounds %struct._Local_Memory* %arrayidx59, i32 0, i32 13
  %27 = load double* %Local_Y_Max60, align 8
  %cmp61 = fcmp olt double %27, 0.000000e+00
  br i1 %cmp61, label %if.then.62, label %if.end.69

if.then.62:                                       ; preds = %if.else.57
  %28 = load i32* %exp, align 4
  %sub63 = sub nsw i32 %28, 1
  %call64 = call double @ldexp(double 1.000000e+00, i32 %sub63)
  %sub65 = fsub double -0.000000e+00, %call64
  %29 = load i32* %my_id.addr, align 4
  %idxprom66 = sext i32 %29 to i64
  %arrayidx67 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom66
  %Local_Y_Max68 = getelementptr inbounds %struct._Local_Memory* %arrayidx67, i32 0, i32 13
  store double %sub65, double* %Local_Y_Max68, align 8
  br label %if.end.69

if.end.69:                                        ; preds = %if.then.62, %if.else.57
  br label %if.end.70

if.end.70:                                        ; preds = %if.end.69, %if.then.52
  %30 = load i32* %my_id.addr, align 4
  %idxprom71 = sext i32 %30 to i64
  %arrayidx72 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom71
  %Local_Y_Min = getelementptr inbounds %struct._Local_Memory* %arrayidx72, i32 0, i32 14
  %31 = load double* %Local_Y_Min, align 8
  %call73 = call double @frexp(double %31, i32* %exp)
  %32 = load i32* %my_id.addr, align 4
  %idxprom74 = sext i32 %32 to i64
  %arrayidx75 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom74
  %Local_Y_Min76 = getelementptr inbounds %struct._Local_Memory* %arrayidx75, i32 0, i32 14
  %33 = load double* %Local_Y_Min76, align 8
  %cmp77 = fcmp olt double %33, 0.000000e+00
  br i1 %cmp77, label %if.then.78, label %if.else.84

if.then.78:                                       ; preds = %if.end.70
  %34 = load i32* %exp, align 4
  %call79 = call double @ldexp(double 1.000000e+00, i32 %34)
  %sub80 = fsub double -0.000000e+00, %call79
  %35 = load i32* %my_id.addr, align 4
  %idxprom81 = sext i32 %35 to i64
  %arrayidx82 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom81
  %Local_Y_Min83 = getelementptr inbounds %struct._Local_Memory* %arrayidx82, i32 0, i32 14
  store double %sub80, double* %Local_Y_Min83, align 8
  br label %if.end.96

if.else.84:                                       ; preds = %if.end.70
  %36 = load i32* %my_id.addr, align 4
  %idxprom85 = sext i32 %36 to i64
  %arrayidx86 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom85
  %Local_Y_Min87 = getelementptr inbounds %struct._Local_Memory* %arrayidx86, i32 0, i32 14
  %37 = load double* %Local_Y_Min87, align 8
  %cmp88 = fcmp ogt double %37, 0.000000e+00
  br i1 %cmp88, label %if.then.89, label %if.end.95

if.then.89:                                       ; preds = %if.else.84
  %38 = load i32* %exp, align 4
  %sub90 = sub nsw i32 %38, 1
  %call91 = call double @ldexp(double 1.000000e+00, i32 %sub90)
  %39 = load i32* %my_id.addr, align 4
  %idxprom92 = sext i32 %39 to i64
  %arrayidx93 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom92
  %Local_Y_Min94 = getelementptr inbounds %struct._Local_Memory* %arrayidx93, i32 0, i32 14
  store double %call91, double* %Local_Y_Min94, align 8
  br label %if.end.95

if.end.95:                                        ; preds = %if.then.89, %if.else.84
  br label %if.end.96

if.end.96:                                        ; preds = %if.end.95, %if.then.78
  %40 = load i32* %my_id.addr, align 4
  %idxprom97 = sext i32 %40 to i64
  %arrayidx98 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom97
  %Local_X_Max99 = getelementptr inbounds %struct._Local_Memory* %arrayidx98, i32 0, i32 11
  %41 = load double* %Local_X_Max99, align 8
  %42 = load i32* %my_id.addr, align 4
  %idxprom100 = sext i32 %42 to i64
  %arrayidx101 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom100
  %Local_X_Min102 = getelementptr inbounds %struct._Local_Memory* %arrayidx101, i32 0, i32 12
  %43 = load double* %Local_X_Min102, align 8
  %sub103 = fsub double %41, %43
  store double %sub103, double* %x_length, align 8
  %44 = load i32* %my_id.addr, align 4
  %idxprom104 = sext i32 %44 to i64
  %arrayidx105 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom104
  %Local_Y_Max106 = getelementptr inbounds %struct._Local_Memory* %arrayidx105, i32 0, i32 13
  %45 = load double* %Local_Y_Max106, align 8
  %46 = load i32* %my_id.addr, align 4
  %idxprom107 = sext i32 %46 to i64
  %arrayidx108 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom107
  %Local_Y_Min109 = getelementptr inbounds %struct._Local_Memory* %arrayidx108, i32 0, i32 14
  %47 = load double* %Local_Y_Min109, align 8
  %sub110 = fsub double %45, %47
  store double %sub110, double* %y_length, align 8
  %48 = load double* %x_length, align 8
  %49 = load double* %y_length, align 8
  %cmp111 = fcmp ogt double %48, %49
  br i1 %cmp111, label %if.then.112, label %if.else.113

if.then.112:                                      ; preds = %if.end.96
  %50 = load double* %x_length, align 8
  store double %50, double* %grid_length, align 8
  br label %if.end.114

if.else.113:                                      ; preds = %if.end.96
  %51 = load double* %y_length, align 8
  store double %51, double* %grid_length, align 8
  br label %if.end.114

if.end.114:                                       ; preds = %if.else.113, %if.then.112
  %52 = load double* %grid_length, align 8
  %div = fdiv double %52, 2.000000e+00
  %53 = load i32* %my_id.addr, align 4
  %idxprom115 = sext i32 %53 to i64
  %arrayidx116 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom115
  %Local_X_Min117 = getelementptr inbounds %struct._Local_Memory* %arrayidx116, i32 0, i32 12
  %54 = load double* %Local_X_Min117, align 8
  %add = fadd double %div, %54
  store double %add, double* %grid_x_center, align 8
  %55 = load double* %grid_length, align 8
  %div118 = fdiv double %55, 2.000000e+00
  %56 = load i32* %my_id.addr, align 4
  %idxprom119 = sext i32 %56 to i64
  %arrayidx120 = getelementptr inbounds [64 x %struct._Local_Memory]* @Local, i32 0, i64 %idxprom119
  %Local_Y_Min121 = getelementptr inbounds %struct._Local_Memory* %arrayidx120, i32 0, i32 14
  %57 = load double* %Local_Y_Min121, align 8
  %add122 = fadd double %div118, %57
  store double %add122, double* %grid_y_center, align 8
  %58 = load i32* %my_id.addr, align 4
  %59 = load double* %grid_x_center, align 8
  %60 = load double* %grid_y_center, align 8
  %61 = load double* %grid_length, align 8
  %call123 = call %struct._Box* @InitBox(i32 %58, double %59, double %60, double %61, %struct._Box* null)
  store %struct._Box* %call123, %struct._Box** %ret_box, align 8
  %62 = load %struct._Box** %ret_box, align 8
  ret %struct._Box* %62
}

; Function Attrs: nounwind uwtable
define void @InsertParticlesInTree(i32 %my_id, %struct._Particle** %p_list, i32 %num_of_particles, %struct._Box* %root) {
entry:
  %my_id.addr = alloca i32, align 4
  %p_list.addr = alloca %struct._Particle**, align 8
  %num_of_particles.addr = alloca i32, align 4
  %root.addr = alloca %struct._Box*, align 8
  %p = alloca %struct._Particle*, align 8
  %dest_box = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle** %p_list, %struct._Particle*** %p_list.addr, align 8
  store i32 %num_of_particles, i32* %num_of_particles.addr, align 4
  store %struct._Box* %root, %struct._Box** %root.addr, align 8
  %0 = load %struct._Box** %root.addr, align 8
  store %struct._Box* %0, %struct._Box** %dest_box, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.15, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %num_of_particles.addr, align 4
  %cmp = icmp slt i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end.17

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load %struct._Particle*** %p_list.addr, align 8
  %arrayidx = getelementptr inbounds %struct._Particle** %4, i64 %idxprom
  %5 = load %struct._Particle** %arrayidx, align 8
  store %struct._Particle* %5, %struct._Particle** %p, align 8
  %6 = load i32* %my_id.addr, align 4
  %7 = load %struct._Particle** %p, align 8
  %8 = load %struct._Box** %dest_box, align 8
  %call = call %struct._Box* @FindHome(i32 %6, %struct._Particle* %7, %struct._Box* %8)
  store %struct._Box* %call, %struct._Box** %dest_box, align 8
  %9 = load %struct._Particle** %p, align 8
  %10 = load %struct._Box** %dest_box, align 8
  %num_particles = getelementptr inbounds %struct._Box* %10, i32 0, i32 7
  %11 = load i32* %num_particles, align 4
  %inc = add nsw i32 %11, 1
  store i32 %inc, i32* %num_particles, align 4
  %idxprom1 = sext i32 %11 to i64
  %12 = load %struct._Box** %dest_box, align 8
  %particles = getelementptr inbounds %struct._Box* %12, i32 0, i32 6
  %arrayidx2 = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i64 %idxprom1
  store %struct._Particle* %9, %struct._Particle** %arrayidx2, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %for.body
  %13 = load %struct._Box** %dest_box, align 8
  %num_particles3 = getelementptr inbounds %struct._Box* %13, i32 0, i32 7
  %14 = load i32* %num_particles3, align 4
  %cmp4 = icmp sgt i32 %14, 40
  br i1 %cmp4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %15 = load i32* %my_id.addr, align 4
  %16 = load %struct._Box** %dest_box, align 8
  call void @SubdivideBox(i32 %15, %struct._Box* %16)
  %17 = load %struct._Box** %dest_box, align 8
  %num_children = getelementptr inbounds %struct._Box* %17, i32 0, i32 12
  %18 = load i32* %num_children, align 4
  %cmp5 = icmp eq i32 %18, 1
  br i1 %cmp5, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  store i32 0, i32* %j, align 4
  br label %for.cond.6

for.cond.6:                                       ; preds = %for.inc, %if.then
  %19 = load i32* %j, align 4
  %idxprom7 = sext i32 %19 to i64
  %20 = load %struct._Box** %dest_box, align 8
  %children = getelementptr inbounds %struct._Box* %20, i32 0, i32 11
  %arrayidx8 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom7
  %21 = load %struct._Box** %arrayidx8, align 8
  %cmp9 = icmp eq %struct._Box* %21, null
  br i1 %cmp9, label %for.body.10, label %for.end

for.body.10:                                      ; preds = %for.cond.6
  br label %for.inc

for.inc:                                          ; preds = %for.body.10
  %22 = load i32* %j, align 4
  %inc11 = add nsw i32 %22, 1
  store i32 %inc11, i32* %j, align 4
  br label %for.cond.6

for.end:                                          ; preds = %for.cond.6
  %23 = load i32* %j, align 4
  %idxprom12 = sext i32 %23 to i64
  %24 = load %struct._Box** %dest_box, align 8
  %children13 = getelementptr inbounds %struct._Box* %24, i32 0, i32 11
  %arrayidx14 = getelementptr inbounds [4 x %struct._Box*]* %children13, i32 0, i64 %idxprom12
  %25 = load %struct._Box** %arrayidx14, align 8
  store %struct._Box* %25, %struct._Box** %dest_box, align 8
  br label %if.end

if.end:                                           ; preds = %for.end, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %for.inc.15

for.inc.15:                                       ; preds = %while.end
  %26 = load i32* %i, align 4
  %inc16 = add nsw i32 %26, 1
  store i32 %inc16, i32* %i, align 4
  br label %for.cond

for.end.17:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind
declare double @frexp(double, i32*)

; Function Attrs: nounwind
declare double @ldexp(double, i32)

declare %struct._Box* @InitBox(i32, double, double, double, %struct._Box*)

; Function Attrs: nounwind uwtable
define %struct._Box* @FindHome(i32 %my_id, %struct._Particle* %p, %struct._Box* %current_home) {
entry:
  %my_id.addr = alloca i32, align 4
  %p.addr = alloca %struct._Particle*, align 8
  %current_home.addr = alloca %struct._Box*, align 8
  %pb = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle* %p, %struct._Particle** %p.addr, align 8
  store %struct._Box* %current_home, %struct._Box** %current_home.addr, align 8
  %0 = load i32* %my_id.addr, align 4
  %1 = load %struct._Particle** %p.addr, align 8
  %2 = load %struct._Box** %current_home.addr, align 8
  %call = call %struct._Box* @FindInitialRoot(i32 %0, %struct._Particle* %1, %struct._Box* %2)
  store %struct._Box* %call, %struct._Box** %pb, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end.43, %entry
  %3 = load %struct._Box** %pb, align 8
  %type = getelementptr inbounds %struct._Box* %3, i32 0, i32 5
  %4 = load i32* %type, align 4
  %cmp = icmp eq i32 %4, 1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %5 = load %struct._Particle** %p.addr, align 8
  %pos = getelementptr inbounds %struct._Particle* %5, i32 0, i32 3
  %y = getelementptr inbounds %struct._Vector* %pos, i32 0, i32 1
  %6 = load double* %y, align 8
  %7 = load %struct._Box** %pb, align 8
  %y_center = getelementptr inbounds %struct._Box* %7, i32 0, i32 2
  %8 = load double* %y_center, align 8
  %cmp1 = fcmp ogt double %6, %8
  br i1 %cmp1, label %if.then, label %if.else.19

if.then:                                          ; preds = %while.body
  %9 = load %struct._Particle** %p.addr, align 8
  %pos2 = getelementptr inbounds %struct._Particle* %9, i32 0, i32 3
  %x = getelementptr inbounds %struct._Vector* %pos2, i32 0, i32 0
  %10 = load double* %x, align 8
  %11 = load %struct._Box** %pb, align 8
  %x_center = getelementptr inbounds %struct._Box* %11, i32 0, i32 1
  %12 = load double* %x_center, align 8
  %cmp3 = fcmp ogt double %10, %12
  br i1 %cmp3, label %if.then.4, label %if.else

if.then.4:                                        ; preds = %if.then
  %13 = load %struct._Box** %pb, align 8
  %children = getelementptr inbounds %struct._Box* %13, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 0
  %14 = load %struct._Box** %arrayidx, align 8
  %cmp5 = icmp eq %struct._Box* %14, null
  br i1 %cmp5, label %if.then.6, label %if.end

if.then.6:                                        ; preds = %if.then.4
  %15 = load i32* %my_id.addr, align 4
  %16 = load %struct._Box** %pb, align 8
  %call7 = call %struct._Box* @CreateChild(i32 %15, %struct._Box* %16, i32 0)
  br label %if.end

if.end:                                           ; preds = %if.then.6, %if.then.4
  %17 = load %struct._Box** %pb, align 8
  %children8 = getelementptr inbounds %struct._Box* %17, i32 0, i32 11
  %arrayidx9 = getelementptr inbounds [4 x %struct._Box*]* %children8, i32 0, i64 0
  %18 = load %struct._Box** %arrayidx9, align 8
  store %struct._Box* %18, %struct._Box** %pb, align 8
  br label %if.end.18

if.else:                                          ; preds = %if.then
  %19 = load %struct._Box** %pb, align 8
  %children10 = getelementptr inbounds %struct._Box* %19, i32 0, i32 11
  %arrayidx11 = getelementptr inbounds [4 x %struct._Box*]* %children10, i32 0, i64 1
  %20 = load %struct._Box** %arrayidx11, align 8
  %cmp12 = icmp eq %struct._Box* %20, null
  br i1 %cmp12, label %if.then.13, label %if.end.15

if.then.13:                                       ; preds = %if.else
  %21 = load i32* %my_id.addr, align 4
  %22 = load %struct._Box** %pb, align 8
  %call14 = call %struct._Box* @CreateChild(i32 %21, %struct._Box* %22, i32 1)
  br label %if.end.15

if.end.15:                                        ; preds = %if.then.13, %if.else
  %23 = load %struct._Box** %pb, align 8
  %children16 = getelementptr inbounds %struct._Box* %23, i32 0, i32 11
  %arrayidx17 = getelementptr inbounds [4 x %struct._Box*]* %children16, i32 0, i64 1
  %24 = load %struct._Box** %arrayidx17, align 8
  store %struct._Box* %24, %struct._Box** %pb, align 8
  br label %if.end.18

if.end.18:                                        ; preds = %if.end.15, %if.end
  br label %if.end.43

if.else.19:                                       ; preds = %while.body
  %25 = load %struct._Particle** %p.addr, align 8
  %pos20 = getelementptr inbounds %struct._Particle* %25, i32 0, i32 3
  %x21 = getelementptr inbounds %struct._Vector* %pos20, i32 0, i32 0
  %26 = load double* %x21, align 8
  %27 = load %struct._Box** %pb, align 8
  %x_center22 = getelementptr inbounds %struct._Box* %27, i32 0, i32 1
  %28 = load double* %x_center22, align 8
  %cmp23 = fcmp ogt double %26, %28
  br i1 %cmp23, label %if.then.24, label %if.else.33

if.then.24:                                       ; preds = %if.else.19
  %29 = load %struct._Box** %pb, align 8
  %children25 = getelementptr inbounds %struct._Box* %29, i32 0, i32 11
  %arrayidx26 = getelementptr inbounds [4 x %struct._Box*]* %children25, i32 0, i64 3
  %30 = load %struct._Box** %arrayidx26, align 8
  %cmp27 = icmp eq %struct._Box* %30, null
  br i1 %cmp27, label %if.then.28, label %if.end.30

if.then.28:                                       ; preds = %if.then.24
  %31 = load i32* %my_id.addr, align 4
  %32 = load %struct._Box** %pb, align 8
  %call29 = call %struct._Box* @CreateChild(i32 %31, %struct._Box* %32, i32 3)
  br label %if.end.30

if.end.30:                                        ; preds = %if.then.28, %if.then.24
  %33 = load %struct._Box** %pb, align 8
  %children31 = getelementptr inbounds %struct._Box* %33, i32 0, i32 11
  %arrayidx32 = getelementptr inbounds [4 x %struct._Box*]* %children31, i32 0, i64 3
  %34 = load %struct._Box** %arrayidx32, align 8
  store %struct._Box* %34, %struct._Box** %pb, align 8
  br label %if.end.42

if.else.33:                                       ; preds = %if.else.19
  %35 = load %struct._Box** %pb, align 8
  %children34 = getelementptr inbounds %struct._Box* %35, i32 0, i32 11
  %arrayidx35 = getelementptr inbounds [4 x %struct._Box*]* %children34, i32 0, i64 2
  %36 = load %struct._Box** %arrayidx35, align 8
  %cmp36 = icmp eq %struct._Box* %36, null
  br i1 %cmp36, label %if.then.37, label %if.end.39

if.then.37:                                       ; preds = %if.else.33
  %37 = load i32* %my_id.addr, align 4
  %38 = load %struct._Box** %pb, align 8
  %call38 = call %struct._Box* @CreateChild(i32 %37, %struct._Box* %38, i32 2)
  br label %if.end.39

if.end.39:                                        ; preds = %if.then.37, %if.else.33
  %39 = load %struct._Box** %pb, align 8
  %children40 = getelementptr inbounds %struct._Box* %39, i32 0, i32 11
  %arrayidx41 = getelementptr inbounds [4 x %struct._Box*]* %children40, i32 0, i64 2
  %40 = load %struct._Box** %arrayidx41, align 8
  store %struct._Box* %40, %struct._Box** %pb, align 8
  br label %if.end.42

if.end.42:                                        ; preds = %if.end.39, %if.end.30
  br label %if.end.43

if.end.43:                                        ; preds = %if.end.42, %if.end.18
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %41 = load %struct._Box** %pb, align 8
  ret %struct._Box* %41
}

; Function Attrs: nounwind uwtable
define void @SubdivideBox(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %p = alloca %struct._Particle*, align 8
  %child = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load %struct._Box** %b.addr, align 8
  %num_particles = getelementptr inbounds %struct._Box* %1, i32 0, i32 7
  %2 = load i32* %num_particles, align 4
  %cmp = icmp slt i32 %0, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load %struct._Box** %b.addr, align 8
  %particles = getelementptr inbounds %struct._Box* %4, i32 0, i32 6
  %arrayidx = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i64 %idxprom
  %5 = load %struct._Particle** %arrayidx, align 8
  store %struct._Particle* %5, %struct._Particle** %p, align 8
  %6 = load %struct._Particle** %p, align 8
  %pos = getelementptr inbounds %struct._Particle* %6, i32 0, i32 3
  %y = getelementptr inbounds %struct._Vector* %pos, i32 0, i32 1
  %7 = load double* %y, align 8
  %8 = load %struct._Box** %b.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %8, i32 0, i32 2
  %9 = load double* %y_center, align 8
  %cmp1 = fcmp ogt double %7, %9
  br i1 %cmp1, label %if.then, label %if.else.15

if.then:                                          ; preds = %for.body
  %10 = load %struct._Particle** %p, align 8
  %pos2 = getelementptr inbounds %struct._Particle* %10, i32 0, i32 3
  %x = getelementptr inbounds %struct._Vector* %pos2, i32 0, i32 0
  %11 = load double* %x, align 8
  %12 = load %struct._Box** %b.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %12, i32 0, i32 1
  %13 = load double* %x_center, align 8
  %cmp3 = fcmp ogt double %11, %13
  br i1 %cmp3, label %if.then.4, label %if.else

if.then.4:                                        ; preds = %if.then
  %14 = load %struct._Box** %b.addr, align 8
  %children = getelementptr inbounds %struct._Box* %14, i32 0, i32 11
  %arrayidx5 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 0
  %15 = load %struct._Box** %arrayidx5, align 8
  store %struct._Box* %15, %struct._Box** %child, align 8
  %16 = load %struct._Box** %child, align 8
  %cmp6 = icmp eq %struct._Box* %16, null
  br i1 %cmp6, label %if.then.7, label %if.end

if.then.7:                                        ; preds = %if.then.4
  %17 = load i32* %my_id.addr, align 4
  %18 = load %struct._Box** %b.addr, align 8
  %call = call %struct._Box* @CreateChild(i32 %17, %struct._Box* %18, i32 0)
  store %struct._Box* %call, %struct._Box** %child, align 8
  br label %if.end

if.end:                                           ; preds = %if.then.7, %if.then.4
  br label %if.end.14

if.else:                                          ; preds = %if.then
  %19 = load %struct._Box** %b.addr, align 8
  %children8 = getelementptr inbounds %struct._Box* %19, i32 0, i32 11
  %arrayidx9 = getelementptr inbounds [4 x %struct._Box*]* %children8, i32 0, i64 1
  %20 = load %struct._Box** %arrayidx9, align 8
  store %struct._Box* %20, %struct._Box** %child, align 8
  %21 = load %struct._Box** %child, align 8
  %cmp10 = icmp eq %struct._Box* %21, null
  br i1 %cmp10, label %if.then.11, label %if.end.13

if.then.11:                                       ; preds = %if.else
  %22 = load i32* %my_id.addr, align 4
  %23 = load %struct._Box** %b.addr, align 8
  %call12 = call %struct._Box* @CreateChild(i32 %22, %struct._Box* %23, i32 1)
  store %struct._Box* %call12, %struct._Box** %child, align 8
  br label %if.end.13

if.end.13:                                        ; preds = %if.then.11, %if.else
  br label %if.end.14

if.end.14:                                        ; preds = %if.end.13, %if.end
  br label %if.end.35

if.else.15:                                       ; preds = %for.body
  %24 = load %struct._Particle** %p, align 8
  %pos16 = getelementptr inbounds %struct._Particle* %24, i32 0, i32 3
  %x17 = getelementptr inbounds %struct._Vector* %pos16, i32 0, i32 0
  %25 = load double* %x17, align 8
  %26 = load %struct._Box** %b.addr, align 8
  %x_center18 = getelementptr inbounds %struct._Box* %26, i32 0, i32 1
  %27 = load double* %x_center18, align 8
  %cmp19 = fcmp ogt double %25, %27
  br i1 %cmp19, label %if.then.20, label %if.else.27

if.then.20:                                       ; preds = %if.else.15
  %28 = load %struct._Box** %b.addr, align 8
  %children21 = getelementptr inbounds %struct._Box* %28, i32 0, i32 11
  %arrayidx22 = getelementptr inbounds [4 x %struct._Box*]* %children21, i32 0, i64 3
  %29 = load %struct._Box** %arrayidx22, align 8
  store %struct._Box* %29, %struct._Box** %child, align 8
  %30 = load %struct._Box** %child, align 8
  %cmp23 = icmp eq %struct._Box* %30, null
  br i1 %cmp23, label %if.then.24, label %if.end.26

if.then.24:                                       ; preds = %if.then.20
  %31 = load i32* %my_id.addr, align 4
  %32 = load %struct._Box** %b.addr, align 8
  %call25 = call %struct._Box* @CreateChild(i32 %31, %struct._Box* %32, i32 3)
  store %struct._Box* %call25, %struct._Box** %child, align 8
  br label %if.end.26

if.end.26:                                        ; preds = %if.then.24, %if.then.20
  br label %if.end.34

if.else.27:                                       ; preds = %if.else.15
  %33 = load %struct._Box** %b.addr, align 8
  %children28 = getelementptr inbounds %struct._Box* %33, i32 0, i32 11
  %arrayidx29 = getelementptr inbounds [4 x %struct._Box*]* %children28, i32 0, i64 2
  %34 = load %struct._Box** %arrayidx29, align 8
  store %struct._Box* %34, %struct._Box** %child, align 8
  %35 = load %struct._Box** %child, align 8
  %cmp30 = icmp eq %struct._Box* %35, null
  br i1 %cmp30, label %if.then.31, label %if.end.33

if.then.31:                                       ; preds = %if.else.27
  %36 = load i32* %my_id.addr, align 4
  %37 = load %struct._Box** %b.addr, align 8
  %call32 = call %struct._Box* @CreateChild(i32 %36, %struct._Box* %37, i32 2)
  store %struct._Box* %call32, %struct._Box** %child, align 8
  br label %if.end.33

if.end.33:                                        ; preds = %if.then.31, %if.else.27
  br label %if.end.34

if.end.34:                                        ; preds = %if.end.33, %if.end.26
  br label %if.end.35

if.end.35:                                        ; preds = %if.end.34, %if.end.14
  %38 = load %struct._Particle** %p, align 8
  %39 = load %struct._Box** %child, align 8
  %num_particles36 = getelementptr inbounds %struct._Box* %39, i32 0, i32 7
  %40 = load i32* %num_particles36, align 4
  %inc = add nsw i32 %40, 1
  store i32 %inc, i32* %num_particles36, align 4
  %idxprom37 = sext i32 %40 to i64
  %41 = load %struct._Box** %child, align 8
  %particles38 = getelementptr inbounds %struct._Box* %41, i32 0, i32 6
  %arrayidx39 = getelementptr inbounds [41 x %struct._Particle*]* %particles38, i32 0, i64 %idxprom37
  store %struct._Particle* %38, %struct._Particle** %arrayidx39, align 8
  %42 = load i32* %i, align 4
  %idxprom40 = sext i32 %42 to i64
  %43 = load %struct._Box** %b.addr, align 8
  %particles41 = getelementptr inbounds %struct._Box* %43, i32 0, i32 6
  %arrayidx42 = getelementptr inbounds [41 x %struct._Particle*]* %particles41, i32 0, i64 %idxprom40
  store %struct._Particle* null, %struct._Particle** %arrayidx42, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.35
  %44 = load i32* %i, align 4
  %inc43 = add nsw i32 %44, 1
  store i32 %inc43, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %45 = load %struct._Box** %b.addr, align 8
  %num_particles44 = getelementptr inbounds %struct._Box* %45, i32 0, i32 7
  store i32 0, i32* %num_particles44, align 4
  %46 = load %struct._Box** %b.addr, align 8
  %type = getelementptr inbounds %struct._Box* %46, i32 0, i32 5
  store i32 1, i32* %type, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define %struct._Box* @FindInitialRoot(i32 %my_id, %struct._Particle* %p, %struct._Box* %current_home) {
entry:
  %my_id.addr = alloca i32, align 4
  %p.addr = alloca %struct._Particle*, align 8
  %current_home.addr = alloca %struct._Box*, align 8
  %found = alloca i32, align 4
  %x_center_distance = alloca double, align 8
  %y_center_distance = alloca double, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle* %p, %struct._Particle** %p.addr, align 8
  store %struct._Box* %current_home, %struct._Box** %current_home.addr, align 8
  store i32 0, i32* %found, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end.14, %entry
  %0 = load i32* %found, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %1 = load %struct._Particle** %p.addr, align 8
  %pos = getelementptr inbounds %struct._Particle* %1, i32 0, i32 3
  %x = getelementptr inbounds %struct._Vector* %pos, i32 0, i32 0
  %2 = load double* %x, align 8
  %3 = load %struct._Box** %current_home.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %3, i32 0, i32 1
  %4 = load double* %x_center, align 8
  %sub = fsub double %2, %4
  store double %sub, double* %x_center_distance, align 8
  %5 = load %struct._Particle** %p.addr, align 8
  %pos1 = getelementptr inbounds %struct._Particle* %5, i32 0, i32 3
  %y = getelementptr inbounds %struct._Vector* %pos1, i32 0, i32 1
  %6 = load double* %y, align 8
  %7 = load %struct._Box** %current_home.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %7, i32 0, i32 2
  %8 = load double* %y_center, align 8
  %sub2 = fsub double %6, %8
  store double %sub2, double* %y_center_distance, align 8
  %9 = load double* %x_center_distance, align 8
  %cmp3 = fcmp olt double %9, 0.000000e+00
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %10 = load double* %x_center_distance, align 8
  %sub4 = fsub double -0.000000e+00, %10
  store double %sub4, double* %x_center_distance, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  %11 = load double* %y_center_distance, align 8
  %cmp5 = fcmp olt double %11, 0.000000e+00
  br i1 %cmp5, label %if.then.6, label %if.end.8

if.then.6:                                        ; preds = %if.end
  %12 = load double* %y_center_distance, align 8
  %sub7 = fsub double -0.000000e+00, %12
  store double %sub7, double* %y_center_distance, align 8
  br label %if.end.8

if.end.8:                                         ; preds = %if.then.6, %if.end
  %13 = load double* %x_center_distance, align 8
  %14 = load %struct._Box** %current_home.addr, align 8
  %length = getelementptr inbounds %struct._Box* %14, i32 0, i32 3
  %15 = load double* %length, align 8
  %div = fdiv double %15, 2.000000e+00
  %cmp9 = fcmp ogt double %13, %div
  br i1 %cmp9, label %if.then.13, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end.8
  %16 = load double* %y_center_distance, align 8
  %17 = load %struct._Box** %current_home.addr, align 8
  %length10 = getelementptr inbounds %struct._Box* %17, i32 0, i32 3
  %18 = load double* %length10, align 8
  %div11 = fdiv double %18, 2.000000e+00
  %cmp12 = fcmp ogt double %16, %div11
  br i1 %cmp12, label %if.then.13, label %if.else

if.then.13:                                       ; preds = %lor.lhs.false, %if.end.8
  %19 = load %struct._Box** %current_home.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %19, i32 0, i32 8
  %20 = load %struct._Box** %parent, align 8
  store %struct._Box* %20, %struct._Box** %current_home.addr, align 8
  br label %if.end.14

if.else:                                          ; preds = %lor.lhs.false
  store i32 1, i32* %found, align 4
  br label %if.end.14

if.end.14:                                        ; preds = %if.else, %if.then.13
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %21 = load %struct._Box** %current_home.addr, align 8
  ret %struct._Box* %21
}

; Function Attrs: nounwind uwtable
define %struct._Box* @CreateChild(i32 %my_id, %struct._Box* %pb, i32 %new_child_num) {
entry:
  %my_id.addr = alloca i32, align 4
  %pb.addr = alloca %struct._Box*, align 8
  %new_child_num.addr = alloca i32, align 4
  %child_length = alloca double, align 8
  %child_offset = alloca double, align 8
  %ret_box = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  store i32 %new_child_num, i32* %new_child_num.addr, align 4
  %0 = load %struct._Box** %pb.addr, align 8
  %length = getelementptr inbounds %struct._Box* %0, i32 0, i32 3
  %1 = load double* %length, align 8
  %div = fdiv double %1, 2.000000e+00
  store double %div, double* %child_length, align 8
  %2 = load %struct._Box** %pb.addr, align 8
  %length1 = getelementptr inbounds %struct._Box* %2, i32 0, i32 3
  %3 = load double* %length1, align 8
  %div2 = fdiv double %3, 4.000000e+00
  store double %div2, double* %child_offset, align 8
  %4 = load i32* %new_child_num.addr, align 4
  %cmp = icmp eq i32 %4, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %5 = load i32* %my_id.addr, align 4
  %6 = load %struct._Box** %pb.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %6, i32 0, i32 1
  %7 = load double* %x_center, align 8
  %8 = load double* %child_offset, align 8
  %add = fadd double %7, %8
  %9 = load %struct._Box** %pb.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %9, i32 0, i32 2
  %10 = load double* %y_center, align 8
  %11 = load double* %child_offset, align 8
  %add3 = fadd double %10, %11
  %12 = load double* %child_length, align 8
  %13 = load %struct._Box** %pb.addr, align 8
  %call = call %struct._Box* @InitBox(i32 %5, double %add, double %add3, double %12, %struct._Box* %13)
  %14 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %14, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 0
  store %struct._Box* %call, %struct._Box** %arrayidx, align 8
  %15 = load %struct._Box** %pb.addr, align 8
  %children4 = getelementptr inbounds %struct._Box* %15, i32 0, i32 11
  %arrayidx5 = getelementptr inbounds [4 x %struct._Box*]* %children4, i32 0, i64 0
  %16 = load %struct._Box** %arrayidx5, align 8
  %17 = load %struct._Box** %pb.addr, align 8
  %shadow = getelementptr inbounds %struct._Box* %17, i32 0, i32 10
  %arrayidx6 = getelementptr inbounds [4 x %struct._Box*]* %shadow, i32 0, i64 0
  store %struct._Box* %16, %struct._Box** %arrayidx6, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %18 = load i32* %new_child_num.addr, align 4
  %cmp7 = icmp eq i32 %18, 1
  br i1 %cmp7, label %if.then.8, label %if.end.19

if.then.8:                                        ; preds = %if.end
  %19 = load i32* %my_id.addr, align 4
  %20 = load %struct._Box** %pb.addr, align 8
  %x_center9 = getelementptr inbounds %struct._Box* %20, i32 0, i32 1
  %21 = load double* %x_center9, align 8
  %22 = load double* %child_offset, align 8
  %sub = fsub double %21, %22
  %23 = load %struct._Box** %pb.addr, align 8
  %y_center10 = getelementptr inbounds %struct._Box* %23, i32 0, i32 2
  %24 = load double* %y_center10, align 8
  %25 = load double* %child_offset, align 8
  %add11 = fadd double %24, %25
  %26 = load double* %child_length, align 8
  %27 = load %struct._Box** %pb.addr, align 8
  %call12 = call %struct._Box* @InitBox(i32 %19, double %sub, double %add11, double %26, %struct._Box* %27)
  %28 = load %struct._Box** %pb.addr, align 8
  %children13 = getelementptr inbounds %struct._Box* %28, i32 0, i32 11
  %arrayidx14 = getelementptr inbounds [4 x %struct._Box*]* %children13, i32 0, i64 1
  store %struct._Box* %call12, %struct._Box** %arrayidx14, align 8
  %29 = load %struct._Box** %pb.addr, align 8
  %children15 = getelementptr inbounds %struct._Box* %29, i32 0, i32 11
  %arrayidx16 = getelementptr inbounds [4 x %struct._Box*]* %children15, i32 0, i64 1
  %30 = load %struct._Box** %arrayidx16, align 8
  %31 = load %struct._Box** %pb.addr, align 8
  %shadow17 = getelementptr inbounds %struct._Box* %31, i32 0, i32 10
  %arrayidx18 = getelementptr inbounds [4 x %struct._Box*]* %shadow17, i32 0, i64 1
  store %struct._Box* %30, %struct._Box** %arrayidx18, align 8
  br label %if.end.19

if.end.19:                                        ; preds = %if.then.8, %if.end
  %32 = load i32* %new_child_num.addr, align 4
  %cmp20 = icmp eq i32 %32, 2
  br i1 %cmp20, label %if.then.21, label %if.end.33

if.then.21:                                       ; preds = %if.end.19
  %33 = load i32* %my_id.addr, align 4
  %34 = load %struct._Box** %pb.addr, align 8
  %x_center22 = getelementptr inbounds %struct._Box* %34, i32 0, i32 1
  %35 = load double* %x_center22, align 8
  %36 = load double* %child_offset, align 8
  %sub23 = fsub double %35, %36
  %37 = load %struct._Box** %pb.addr, align 8
  %y_center24 = getelementptr inbounds %struct._Box* %37, i32 0, i32 2
  %38 = load double* %y_center24, align 8
  %39 = load double* %child_offset, align 8
  %sub25 = fsub double %38, %39
  %40 = load double* %child_length, align 8
  %41 = load %struct._Box** %pb.addr, align 8
  %call26 = call %struct._Box* @InitBox(i32 %33, double %sub23, double %sub25, double %40, %struct._Box* %41)
  %42 = load %struct._Box** %pb.addr, align 8
  %children27 = getelementptr inbounds %struct._Box* %42, i32 0, i32 11
  %arrayidx28 = getelementptr inbounds [4 x %struct._Box*]* %children27, i32 0, i64 2
  store %struct._Box* %call26, %struct._Box** %arrayidx28, align 8
  %43 = load %struct._Box** %pb.addr, align 8
  %children29 = getelementptr inbounds %struct._Box* %43, i32 0, i32 11
  %arrayidx30 = getelementptr inbounds [4 x %struct._Box*]* %children29, i32 0, i64 2
  %44 = load %struct._Box** %arrayidx30, align 8
  %45 = load %struct._Box** %pb.addr, align 8
  %shadow31 = getelementptr inbounds %struct._Box* %45, i32 0, i32 10
  %arrayidx32 = getelementptr inbounds [4 x %struct._Box*]* %shadow31, i32 0, i64 2
  store %struct._Box* %44, %struct._Box** %arrayidx32, align 8
  br label %if.end.33

if.end.33:                                        ; preds = %if.then.21, %if.end.19
  %46 = load i32* %new_child_num.addr, align 4
  %cmp34 = icmp eq i32 %46, 3
  br i1 %cmp34, label %if.then.35, label %if.end.47

if.then.35:                                       ; preds = %if.end.33
  %47 = load i32* %my_id.addr, align 4
  %48 = load %struct._Box** %pb.addr, align 8
  %x_center36 = getelementptr inbounds %struct._Box* %48, i32 0, i32 1
  %49 = load double* %x_center36, align 8
  %50 = load double* %child_offset, align 8
  %add37 = fadd double %49, %50
  %51 = load %struct._Box** %pb.addr, align 8
  %y_center38 = getelementptr inbounds %struct._Box* %51, i32 0, i32 2
  %52 = load double* %y_center38, align 8
  %53 = load double* %child_offset, align 8
  %sub39 = fsub double %52, %53
  %54 = load double* %child_length, align 8
  %55 = load %struct._Box** %pb.addr, align 8
  %call40 = call %struct._Box* @InitBox(i32 %47, double %add37, double %sub39, double %54, %struct._Box* %55)
  %56 = load %struct._Box** %pb.addr, align 8
  %children41 = getelementptr inbounds %struct._Box* %56, i32 0, i32 11
  %arrayidx42 = getelementptr inbounds [4 x %struct._Box*]* %children41, i32 0, i64 3
  store %struct._Box* %call40, %struct._Box** %arrayidx42, align 8
  %57 = load %struct._Box** %pb.addr, align 8
  %children43 = getelementptr inbounds %struct._Box* %57, i32 0, i32 11
  %arrayidx44 = getelementptr inbounds [4 x %struct._Box*]* %children43, i32 0, i64 3
  %58 = load %struct._Box** %arrayidx44, align 8
  %59 = load %struct._Box** %pb.addr, align 8
  %shadow45 = getelementptr inbounds %struct._Box* %59, i32 0, i32 10
  %arrayidx46 = getelementptr inbounds [4 x %struct._Box*]* %shadow45, i32 0, i64 3
  store %struct._Box* %58, %struct._Box** %arrayidx46, align 8
  br label %if.end.47

if.end.47:                                        ; preds = %if.then.35, %if.end.33
  %60 = load i32* %new_child_num.addr, align 4
  %61 = load i32* %new_child_num.addr, align 4
  %idxprom = sext i32 %61 to i64
  %62 = load %struct._Box** %pb.addr, align 8
  %children48 = getelementptr inbounds %struct._Box* %62, i32 0, i32 11
  %arrayidx49 = getelementptr inbounds [4 x %struct._Box*]* %children48, i32 0, i64 %idxprom
  %63 = load %struct._Box** %arrayidx49, align 8
  %child_num = getelementptr inbounds %struct._Box* %63, i32 0, i32 9
  store i32 %60, i32* %child_num, align 4
  %64 = load i32* %new_child_num.addr, align 4
  %idxprom50 = sext i32 %64 to i64
  %65 = load %struct._Box** %pb.addr, align 8
  %children51 = getelementptr inbounds %struct._Box* %65, i32 0, i32 11
  %arrayidx52 = getelementptr inbounds [4 x %struct._Box*]* %children51, i32 0, i64 %idxprom50
  %66 = load %struct._Box** %arrayidx52, align 8
  store %struct._Box* %66, %struct._Box** %ret_box, align 8
  %67 = load %struct._Box** %pb.addr, align 8
  %num_children = getelementptr inbounds %struct._Box* %67, i32 0, i32 12
  %68 = load i32* %num_children, align 4
  %add53 = add nsw i32 %68, 1
  store i32 %add53, i32* %num_children, align 4
  %69 = load %struct._Box** %ret_box, align 8
  ret %struct._Box* %69
}

; Function Attrs: nounwind uwtable
define void @MLGHelper(i32 %my_id, %struct._Box* %local_box, %struct._Box* %global_box, %struct._Box* %global_parent) {
entry:
  %my_id.addr = alloca i32, align 4
  %local_box.addr = alloca %struct._Box*, align 8
  %global_box.addr = alloca %struct._Box*, align 8
  %global_parent.addr = alloca %struct._Box*, align 8
  %success = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %local_box, %struct._Box** %local_box.addr, align 8
  store %struct._Box* %global_box, %struct._Box** %global_box.addr, align 8
  store %struct._Box* %global_parent, %struct._Box** %global_parent.addr, align 8
  store i32 0, i32* %success, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end.56, %entry
  %0 = load i32* %success, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %1 = load %struct._Box** %local_box.addr, align 8
  %type = getelementptr inbounds %struct._Box* %1, i32 0, i32 5
  %2 = load i32* %type, align 4
  %cmp1 = icmp eq i32 %2, 1
  br i1 %cmp1, label %if.then, label %if.else.24

if.then:                                          ; preds = %while.body
  %3 = load %struct._Box** %global_box.addr, align 8
  %cmp2 = icmp eq %struct._Box* %3, null
  br i1 %cmp2, label %if.then.3, label %if.else

if.then.3:                                        ; preds = %if.then
  %4 = load i32* %my_id.addr, align 4
  %5 = load %struct._Box** %local_box.addr, align 8
  %6 = load %struct._Box** %global_parent.addr, align 8
  %call = call i32 @InsertBoxInGrid(i32 %4, %struct._Box* %5, %struct._Box* %6)
  store i32 %call, i32* %success, align 4
  br label %if.end.23

if.else:                                          ; preds = %if.then
  %7 = load %struct._Box** %global_box.addr, align 8
  %type4 = getelementptr inbounds %struct._Box* %7, i32 0, i32 5
  %8 = load i32* %type4, align 4
  %cmp5 = icmp eq i32 %8, 1
  br i1 %cmp5, label %if.then.6, label %if.else.16

if.then.6:                                        ; preds = %if.else
  store i32 1, i32* %success, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.6
  %9 = load i32* %i, align 4
  %cmp7 = icmp slt i32 %9, 4
  br i1 %cmp7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %10 = load i32* %i, align 4
  %idxprom = sext i32 %10 to i64
  %11 = load %struct._Box** %local_box.addr, align 8
  %children = getelementptr inbounds %struct._Box* %11, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom
  %12 = load %struct._Box** %arrayidx, align 8
  %cmp8 = icmp ne %struct._Box* %12, null
  br i1 %cmp8, label %if.then.9, label %if.end

if.then.9:                                        ; preds = %for.body
  %13 = load i32* %my_id.addr, align 4
  %14 = load i32* %i, align 4
  %idxprom10 = sext i32 %14 to i64
  %15 = load %struct._Box** %local_box.addr, align 8
  %children11 = getelementptr inbounds %struct._Box* %15, i32 0, i32 11
  %arrayidx12 = getelementptr inbounds [4 x %struct._Box*]* %children11, i32 0, i64 %idxprom10
  %16 = load %struct._Box** %arrayidx12, align 8
  %17 = load i32* %i, align 4
  %idxprom13 = sext i32 %17 to i64
  %18 = load %struct._Box** %global_box.addr, align 8
  %children14 = getelementptr inbounds %struct._Box* %18, i32 0, i32 11
  %arrayidx15 = getelementptr inbounds [4 x %struct._Box*]* %children14, i32 0, i64 %idxprom13
  %19 = load %struct._Box** %arrayidx15, align 8
  %20 = load %struct._Box** %global_box.addr, align 8
  call void @MLGHelper(i32 %13, %struct._Box* %16, %struct._Box* %19, %struct._Box* %20)
  br label %if.end

if.end:                                           ; preds = %if.then.9, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %21 = load i32* %i, align 4
  %inc = add nsw i32 %21, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.22

if.else.16:                                       ; preds = %if.else
  %22 = load i32* %my_id.addr, align 4
  %23 = load %struct._Box** %global_box.addr, align 8
  %24 = load %struct._Box** %global_parent.addr, align 8
  %call17 = call i32 @RemoveBoxFromGrid(i32 %22, %struct._Box* %23, %struct._Box* %24)
  store i32 %call17, i32* %success, align 4
  %25 = load i32* %success, align 4
  %cmp18 = icmp eq i32 %25, 1
  br i1 %cmp18, label %if.then.19, label %if.end.21

if.then.19:                                       ; preds = %if.else.16
  %26 = load i32* %my_id.addr, align 4
  %27 = load %struct._Box** %global_box.addr, align 8
  %particles = getelementptr inbounds %struct._Box* %27, i32 0, i32 6
  %arraydecay = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i32 0
  %28 = load %struct._Box** %global_box.addr, align 8
  %num_particles = getelementptr inbounds %struct._Box* %28, i32 0, i32 7
  %29 = load i32* %num_particles, align 4
  %30 = load %struct._Box** %local_box.addr, align 8
  call void @InsertParticlesInTree(i32 %26, %struct._Particle** %arraydecay, i32 %29, %struct._Box* %30)
  %31 = load i32* %my_id.addr, align 4
  %32 = load %struct._Box** %local_box.addr, align 8
  %33 = load %struct._Box** %global_parent.addr, align 8
  %call20 = call i32 @InsertBoxInGrid(i32 %31, %struct._Box* %32, %struct._Box* %33)
  store i32 %call20, i32* %success, align 4
  br label %if.end.21

if.end.21:                                        ; preds = %if.then.19, %if.else.16
  br label %if.end.22

if.end.22:                                        ; preds = %if.end.21, %for.end
  br label %if.end.23

if.end.23:                                        ; preds = %if.end.22, %if.then.3
  br label %if.end.46

if.else.24:                                       ; preds = %while.body
  %34 = load %struct._Box** %global_box.addr, align 8
  %cmp25 = icmp eq %struct._Box* %34, null
  br i1 %cmp25, label %if.then.26, label %if.else.28

if.then.26:                                       ; preds = %if.else.24
  %35 = load i32* %my_id.addr, align 4
  %36 = load %struct._Box** %local_box.addr, align 8
  %37 = load %struct._Box** %global_parent.addr, align 8
  %call27 = call i32 @InsertBoxInGrid(i32 %35, %struct._Box* %36, %struct._Box* %37)
  store i32 %call27, i32* %success, align 4
  br label %if.end.45

if.else.28:                                       ; preds = %if.else.24
  %38 = load %struct._Box** %global_box.addr, align 8
  %type29 = getelementptr inbounds %struct._Box* %38, i32 0, i32 5
  %39 = load i32* %type29, align 4
  %cmp30 = icmp eq i32 %39, 1
  br i1 %cmp30, label %if.then.31, label %if.else.35

if.then.31:                                       ; preds = %if.else.28
  %40 = load i32* %my_id.addr, align 4
  %41 = load %struct._Box** %local_box.addr, align 8
  %particles32 = getelementptr inbounds %struct._Box* %41, i32 0, i32 6
  %arraydecay33 = getelementptr inbounds [41 x %struct._Particle*]* %particles32, i32 0, i32 0
  %42 = load %struct._Box** %local_box.addr, align 8
  %num_particles34 = getelementptr inbounds %struct._Box* %42, i32 0, i32 7
  %43 = load i32* %num_particles34, align 4
  %44 = load %struct._Box** %global_box.addr, align 8
  call void @MergeLocalParticles(i32 %40, %struct._Particle** %arraydecay33, i32 %43, %struct._Box* %44)
  store i32 1, i32* %success, align 4
  br label %if.end.44

if.else.35:                                       ; preds = %if.else.28
  %45 = load i32* %my_id.addr, align 4
  %46 = load %struct._Box** %global_box.addr, align 8
  %47 = load %struct._Box** %global_parent.addr, align 8
  %call36 = call i32 @RemoveBoxFromGrid(i32 %45, %struct._Box* %46, %struct._Box* %47)
  store i32 %call36, i32* %success, align 4
  %48 = load i32* %success, align 4
  %cmp37 = icmp eq i32 %48, 1
  br i1 %cmp37, label %if.then.38, label %if.end.43

if.then.38:                                       ; preds = %if.else.35
  %49 = load i32* %my_id.addr, align 4
  %50 = load %struct._Box** %global_box.addr, align 8
  %particles39 = getelementptr inbounds %struct._Box* %50, i32 0, i32 6
  %arraydecay40 = getelementptr inbounds [41 x %struct._Particle*]* %particles39, i32 0, i32 0
  %51 = load %struct._Box** %global_box.addr, align 8
  %num_particles41 = getelementptr inbounds %struct._Box* %51, i32 0, i32 7
  %52 = load i32* %num_particles41, align 4
  %53 = load %struct._Box** %local_box.addr, align 8
  call void @InsertParticlesInLeaf(i32 %49, %struct._Particle** %arraydecay40, i32 %52, %struct._Box* %53)
  %54 = load i32* %my_id.addr, align 4
  %55 = load %struct._Box** %local_box.addr, align 8
  %56 = load %struct._Box** %global_parent.addr, align 8
  %call42 = call i32 @InsertBoxInGrid(i32 %54, %struct._Box* %55, %struct._Box* %56)
  store i32 %call42, i32* %success, align 4
  br label %if.end.43

if.end.43:                                        ; preds = %if.then.38, %if.else.35
  br label %if.end.44

if.end.44:                                        ; preds = %if.end.43, %if.then.31
  br label %if.end.45

if.end.45:                                        ; preds = %if.end.44, %if.then.26
  br label %if.end.46

if.end.46:                                        ; preds = %if.end.45, %if.end.23
  %57 = load i32* %success, align 4
  %cmp47 = icmp eq i32 %57, 0
  br i1 %cmp47, label %if.then.48, label %if.end.56

if.then.48:                                       ; preds = %if.end.46
  %58 = load %struct._Box** %global_parent.addr, align 8
  %cmp49 = icmp eq %struct._Box* %58, null
  br i1 %cmp49, label %if.then.50, label %if.else.51

if.then.50:                                       ; preds = %if.then.48
  %59 = load %struct._Box** @Grid, align 8
  store %struct._Box* %59, %struct._Box** %global_box.addr, align 8
  br label %if.end.55

if.else.51:                                       ; preds = %if.then.48
  %60 = load %struct._Box** %local_box.addr, align 8
  %child_num = getelementptr inbounds %struct._Box* %60, i32 0, i32 9
  %61 = load i32* %child_num, align 4
  %idxprom52 = sext i32 %61 to i64
  %62 = load %struct._Box** %global_parent.addr, align 8
  %children53 = getelementptr inbounds %struct._Box* %62, i32 0, i32 11
  %arrayidx54 = getelementptr inbounds [4 x %struct._Box*]* %children53, i32 0, i64 %idxprom52
  %63 = load %struct._Box** %arrayidx54, align 8
  store %struct._Box* %63, %struct._Box** %global_box.addr, align 8
  br label %if.end.55

if.end.55:                                        ; preds = %if.else.51, %if.then.50
  br label %if.end.56

if.end.56:                                        ; preds = %if.end.55, %if.end.46
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @InsertBoxInGrid(i32 %my_id, %struct._Box* %b, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb.addr = alloca %struct._Box*, align 8
  %success = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  %0 = load %struct._Box** %pb.addr, align 8
  %cmp = icmp eq %struct._Box* %0, null
  br i1 %cmp, label %if.then, label %if.else.5

if.then:                                          ; preds = %entry
  %1 = load %struct._G_Mem** @G_Memory, align 8
  %single_lock = getelementptr inbounds %struct._G_Mem* %1, i32 0, i32 2
  %call = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %single_lock)
  %2 = load %struct._Box** @Grid, align 8
  %cmp1 = icmp eq %struct._Box* %2, null
  br i1 %cmp1, label %if.then.2, label %if.else

if.then.2:                                        ; preds = %if.then
  %3 = load %struct._Box** %b.addr, align 8
  store %struct._Box* %3, %struct._Box** @Grid, align 8
  store i32 1, i32* %success, align 4
  br label %if.end

if.else:                                          ; preds = %if.then
  store i32 0, i32* %success, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then.2
  %4 = load %struct._G_Mem** @G_Memory, align 8
  %single_lock3 = getelementptr inbounds %struct._G_Mem* %4, i32 0, i32 2
  %call4 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %single_lock3)
  br label %if.end.22

if.else.5:                                        ; preds = %entry
  %5 = load %struct._Box** %pb.addr, align 8
  %particle_lock_index = getelementptr inbounds %struct._Box* %5, i32 0, i32 27
  %6 = load i32* %particle_lock_index, align 4
  %idxprom = sext i32 %6 to i64
  %7 = load %struct._G_Mem** @G_Memory, align 8
  %lock_array = getelementptr inbounds %struct._G_Mem* %7, i32 0, i32 5
  %arrayidx = getelementptr inbounds [2048 x %union.pthread_mutex_t]* %lock_array, i32 0, i64 %idxprom
  %call6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %arrayidx)
  %8 = load %struct._Box** %b.addr, align 8
  %child_num = getelementptr inbounds %struct._Box* %8, i32 0, i32 9
  %9 = load i32* %child_num, align 4
  %idxprom7 = sext i32 %9 to i64
  %10 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %10, i32 0, i32 11
  %arrayidx8 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom7
  %11 = load %struct._Box** %arrayidx8, align 8
  %cmp9 = icmp eq %struct._Box* %11, null
  br i1 %cmp9, label %if.then.10, label %if.else.15

if.then.10:                                       ; preds = %if.else.5
  %12 = load %struct._Box** %b.addr, align 8
  %13 = load %struct._Box** %b.addr, align 8
  %child_num11 = getelementptr inbounds %struct._Box* %13, i32 0, i32 9
  %14 = load i32* %child_num11, align 4
  %idxprom12 = sext i32 %14 to i64
  %15 = load %struct._Box** %pb.addr, align 8
  %children13 = getelementptr inbounds %struct._Box* %15, i32 0, i32 11
  %arrayidx14 = getelementptr inbounds [4 x %struct._Box*]* %children13, i32 0, i64 %idxprom12
  store %struct._Box* %12, %struct._Box** %arrayidx14, align 8
  %16 = load %struct._Box** %pb.addr, align 8
  %num_children = getelementptr inbounds %struct._Box* %16, i32 0, i32 12
  %17 = load i32* %num_children, align 4
  %add = add nsw i32 %17, 1
  store i32 %add, i32* %num_children, align 4
  %18 = load %struct._Box** %pb.addr, align 8
  %19 = load %struct._Box** %b.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %19, i32 0, i32 8
  store %struct._Box* %18, %struct._Box** %parent, align 8
  store i32 1, i32* %success, align 4
  br label %if.end.16

if.else.15:                                       ; preds = %if.else.5
  store i32 0, i32* %success, align 4
  br label %if.end.16

if.end.16:                                        ; preds = %if.else.15, %if.then.10
  %20 = load %struct._Box** %pb.addr, align 8
  %particle_lock_index17 = getelementptr inbounds %struct._Box* %20, i32 0, i32 27
  %21 = load i32* %particle_lock_index17, align 4
  %idxprom18 = sext i32 %21 to i64
  %22 = load %struct._G_Mem** @G_Memory, align 8
  %lock_array19 = getelementptr inbounds %struct._G_Mem* %22, i32 0, i32 5
  %arrayidx20 = getelementptr inbounds [2048 x %union.pthread_mutex_t]* %lock_array19, i32 0, i64 %idxprom18
  %call21 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %arrayidx20)
  br label %if.end.22

if.end.22:                                        ; preds = %if.end.16, %if.end
  %23 = load i32* %success, align 4
  %cmp23 = icmp eq i32 %23, 1
  br i1 %cmp23, label %if.then.24, label %if.end.25

if.then.24:                                       ; preds = %if.end.22
  %24 = load i32* %my_id.addr, align 4
  %25 = load %struct._Box** %b.addr, align 8
  call void @InsertSubtreeInPartition(i32 %24, %struct._Box* %25)
  br label %if.end.25

if.end.25:                                        ; preds = %if.then.24, %if.end.22
  %26 = load i32* %success, align 4
  ret i32 %26
}

; Function Attrs: nounwind uwtable
define i32 @RemoveBoxFromGrid(i32 %my_id, %struct._Box* %b, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb.addr = alloca %struct._Box*, align 8
  %success = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  %0 = load %struct._Box** %pb.addr, align 8
  %cmp = icmp eq %struct._Box* %0, null
  br i1 %cmp, label %if.then, label %if.else.5

if.then:                                          ; preds = %entry
  %1 = load %struct._G_Mem** @G_Memory, align 8
  %single_lock = getelementptr inbounds %struct._G_Mem* %1, i32 0, i32 2
  %call = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %single_lock)
  %2 = load %struct._Box** @Grid, align 8
  %3 = load %struct._Box** %b.addr, align 8
  %cmp1 = icmp eq %struct._Box* %2, %3
  br i1 %cmp1, label %if.then.2, label %if.else

if.then.2:                                        ; preds = %if.then
  store %struct._Box* null, %struct._Box** @Grid, align 8
  store i32 1, i32* %success, align 4
  br label %if.end

if.else:                                          ; preds = %if.then
  store i32 0, i32* %success, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then.2
  %4 = load %struct._G_Mem** @G_Memory, align 8
  %single_lock3 = getelementptr inbounds %struct._G_Mem* %4, i32 0, i32 2
  %call4 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %single_lock3)
  br label %if.end.22

if.else.5:                                        ; preds = %entry
  %5 = load %struct._Box** %pb.addr, align 8
  %particle_lock_index = getelementptr inbounds %struct._Box* %5, i32 0, i32 27
  %6 = load i32* %particle_lock_index, align 4
  %idxprom = sext i32 %6 to i64
  %7 = load %struct._G_Mem** @G_Memory, align 8
  %lock_array = getelementptr inbounds %struct._G_Mem* %7, i32 0, i32 5
  %arrayidx = getelementptr inbounds [2048 x %union.pthread_mutex_t]* %lock_array, i32 0, i64 %idxprom
  %call6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* %arrayidx)
  %8 = load %struct._Box** %b.addr, align 8
  %child_num = getelementptr inbounds %struct._Box* %8, i32 0, i32 9
  %9 = load i32* %child_num, align 4
  %idxprom7 = sext i32 %9 to i64
  %10 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %10, i32 0, i32 11
  %arrayidx8 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom7
  %11 = load %struct._Box** %arrayidx8, align 8
  %12 = load %struct._Box** %b.addr, align 8
  %cmp9 = icmp eq %struct._Box* %11, %12
  br i1 %cmp9, label %if.then.10, label %if.else.15

if.then.10:                                       ; preds = %if.else.5
  %13 = load %struct._Box** %b.addr, align 8
  %child_num11 = getelementptr inbounds %struct._Box* %13, i32 0, i32 9
  %14 = load i32* %child_num11, align 4
  %idxprom12 = sext i32 %14 to i64
  %15 = load %struct._Box** %pb.addr, align 8
  %children13 = getelementptr inbounds %struct._Box* %15, i32 0, i32 11
  %arrayidx14 = getelementptr inbounds [4 x %struct._Box*]* %children13, i32 0, i64 %idxprom12
  store %struct._Box* null, %struct._Box** %arrayidx14, align 8
  %16 = load %struct._Box** %b.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %16, i32 0, i32 8
  store %struct._Box* null, %struct._Box** %parent, align 8
  %17 = load %struct._Box** %pb.addr, align 8
  %num_children = getelementptr inbounds %struct._Box* %17, i32 0, i32 12
  %18 = load i32* %num_children, align 4
  %sub = sub nsw i32 %18, 1
  store i32 %sub, i32* %num_children, align 4
  store i32 1, i32* %success, align 4
  br label %if.end.16

if.else.15:                                       ; preds = %if.else.5
  store i32 0, i32* %success, align 4
  br label %if.end.16

if.end.16:                                        ; preds = %if.else.15, %if.then.10
  %19 = load %struct._Box** %pb.addr, align 8
  %particle_lock_index17 = getelementptr inbounds %struct._Box* %19, i32 0, i32 27
  %20 = load i32* %particle_lock_index17, align 4
  %idxprom18 = sext i32 %20 to i64
  %21 = load %struct._G_Mem** @G_Memory, align 8
  %lock_array19 = getelementptr inbounds %struct._G_Mem* %21, i32 0, i32 5
  %arrayidx20 = getelementptr inbounds [2048 x %union.pthread_mutex_t]* %lock_array19, i32 0, i64 %idxprom18
  %call21 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* %arrayidx20)
  br label %if.end.22

if.end.22:                                        ; preds = %if.end.16, %if.end
  %22 = load i32* %success, align 4
  ret i32 %22
}

; Function Attrs: nounwind uwtable
define void @MergeLocalParticles(i32 %my_id, %struct._Particle** %p_array, i32 %num_of_particles, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %p_array.addr = alloca %struct._Particle**, align 8
  %num_of_particles.addr = alloca i32, align 4
  %pb.addr = alloca %struct._Box*, align 8
  %p_dist = alloca [4 x [40 x %struct._Particle*]], align 16
  %num_p_dist = alloca [4 x i32], align 16
  %child = alloca %struct._Box*, align 8
  %new_box = alloca %struct._Box*, align 8
  %success = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle** %p_array, %struct._Particle*** %p_array.addr, align 8
  store i32 %num_of_particles, i32* %num_of_particles.addr, align 4
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  %0 = load i32* %my_id.addr, align 4
  %1 = load %struct._Particle*** %p_array.addr, align 8
  %2 = load i32* %num_of_particles.addr, align 4
  %arraydecay = getelementptr inbounds [4 x [40 x %struct._Particle*]]* %p_dist, i32 0, i32 0
  %3 = bitcast [40 x %struct._Particle*]* %arraydecay to %struct._Particle**
  %arraydecay1 = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i32 0
  %4 = load %struct._Box** %pb.addr, align 8
  call void @SplitParticles(i32 %0, %struct._Particle** %1, i32 %2, %struct._Particle** %3, i32* %arraydecay1, %struct._Box* %4)
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %5 = load i32* %i, align 4
  %cmp = icmp slt i32 %5, 4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4
  %idxprom = sext i32 %6 to i64
  %arrayidx = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i64 %idxprom
  %7 = load i32* %arrayidx, align 4
  %cmp2 = icmp sgt i32 %7, 0
  br i1 %cmp2, label %if.then, label %if.end.45

if.then:                                          ; preds = %for.body
  %8 = load i32* %i, align 4
  %idxprom3 = sext i32 %8 to i64
  %9 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %9, i32 0, i32 11
  %arrayidx4 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom3
  %10 = load %struct._Box** %arrayidx4, align 8
  store %struct._Box* %10, %struct._Box** %child, align 8
  %11 = load %struct._Box** %child, align 8
  %cmp5 = icmp eq %struct._Box* %11, null
  br i1 %cmp5, label %if.then.6, label %if.else

if.then.6:                                        ; preds = %if.then
  %12 = load i32* %my_id.addr, align 4
  %13 = load %struct._Box** %pb.addr, align 8
  %14 = load i32* %i, align 4
  %15 = load i32* %i, align 4
  %idxprom7 = sext i32 %15 to i64
  %arrayidx8 = getelementptr inbounds [4 x [40 x %struct._Particle*]]* %p_dist, i32 0, i64 %idxprom7
  %arraydecay9 = getelementptr inbounds [40 x %struct._Particle*]* %arrayidx8, i32 0, i32 0
  %16 = load i32* %i, align 4
  %idxprom10 = sext i32 %16 to i64
  %arrayidx11 = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i64 %idxprom10
  %17 = load i32* %arrayidx11, align 4
  %call = call %struct._Box* @CreateLeaf(i32 %12, %struct._Box* %13, i32 %14, %struct._Particle** %arraydecay9, i32 %17)
  store %struct._Box* %call, %struct._Box** %child, align 8
  %18 = load i32* %my_id.addr, align 4
  %19 = load %struct._Box** %child, align 8
  %20 = load %struct._Box** %pb.addr, align 8
  %call12 = call i32 @InsertBoxInGrid(i32 %18, %struct._Box* %19, %struct._Box* %20)
  store i32 %call12, i32* %success, align 4
  br label %if.end.38

if.else:                                          ; preds = %if.then
  %21 = load %struct._Box** %child, align 8
  %type = getelementptr inbounds %struct._Box* %21, i32 0, i32 5
  %22 = load i32* %type, align 4
  %cmp13 = icmp eq i32 %22, 1
  br i1 %cmp13, label %if.then.14, label %if.else.20

if.then.14:                                       ; preds = %if.else
  %23 = load i32* %my_id.addr, align 4
  %24 = load i32* %i, align 4
  %idxprom15 = sext i32 %24 to i64
  %arrayidx16 = getelementptr inbounds [4 x [40 x %struct._Particle*]]* %p_dist, i32 0, i64 %idxprom15
  %arraydecay17 = getelementptr inbounds [40 x %struct._Particle*]* %arrayidx16, i32 0, i32 0
  %25 = load i32* %i, align 4
  %idxprom18 = sext i32 %25 to i64
  %arrayidx19 = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i64 %idxprom18
  %26 = load i32* %arrayidx19, align 4
  %27 = load %struct._Box** %child, align 8
  call void @MergeLocalParticles(i32 %23, %struct._Particle** %arraydecay17, i32 %26, %struct._Box* %27)
  store i32 1, i32* %success, align 4
  br label %if.end.37

if.else.20:                                       ; preds = %if.else
  %28 = load i32* %my_id.addr, align 4
  %29 = load %struct._Box** %child, align 8
  %30 = load %struct._Box** %pb.addr, align 8
  %call21 = call i32 @RemoveBoxFromGrid(i32 %28, %struct._Box* %29, %struct._Box* %30)
  store i32 %call21, i32* %success, align 4
  %31 = load i32* %success, align 4
  %cmp22 = icmp eq i32 %31, 1
  br i1 %cmp22, label %if.then.23, label %if.else.30

if.then.23:                                       ; preds = %if.else.20
  %32 = load i32* %my_id.addr, align 4
  %33 = load i32* %i, align 4
  %idxprom24 = sext i32 %33 to i64
  %arrayidx25 = getelementptr inbounds [4 x [40 x %struct._Particle*]]* %p_dist, i32 0, i64 %idxprom24
  %arraydecay26 = getelementptr inbounds [40 x %struct._Particle*]* %arrayidx25, i32 0, i32 0
  %34 = load i32* %i, align 4
  %idxprom27 = sext i32 %34 to i64
  %arrayidx28 = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i64 %idxprom27
  %35 = load i32* %arrayidx28, align 4
  %36 = load %struct._Box** %child, align 8
  call void @InsertParticlesInLeaf(i32 %32, %struct._Particle** %arraydecay26, i32 %35, %struct._Box* %36)
  %37 = load i32* %my_id.addr, align 4
  %38 = load %struct._Box** %child, align 8
  %39 = load %struct._Box** %pb.addr, align 8
  %call29 = call i32 @InsertBoxInGrid(i32 %37, %struct._Box* %38, %struct._Box* %39)
  store i32 %call29, i32* %success, align 4
  br label %if.end

if.else.30:                                       ; preds = %if.else.20
  %40 = load i32* %my_id.addr, align 4
  %41 = load %struct._Box** %pb.addr, align 8
  %42 = load i32* %i, align 4
  %43 = load i32* %i, align 4
  %idxprom31 = sext i32 %43 to i64
  %arrayidx32 = getelementptr inbounds [4 x [40 x %struct._Particle*]]* %p_dist, i32 0, i64 %idxprom31
  %arraydecay33 = getelementptr inbounds [40 x %struct._Particle*]* %arrayidx32, i32 0, i32 0
  %44 = load i32* %i, align 4
  %idxprom34 = sext i32 %44 to i64
  %arrayidx35 = getelementptr inbounds [4 x i32]* %num_p_dist, i32 0, i64 %idxprom34
  %45 = load i32* %arrayidx35, align 4
  %call36 = call %struct._Box* @CreateLeaf(i32 %40, %struct._Box* %41, i32 %42, %struct._Particle** %arraydecay33, i32 %45)
  store %struct._Box* %call36, %struct._Box** %child, align 8
  br label %if.end

if.end:                                           ; preds = %if.else.30, %if.then.23
  br label %if.end.37

if.end.37:                                        ; preds = %if.end, %if.then.14
  br label %if.end.38

if.end.38:                                        ; preds = %if.end.37, %if.then.6
  %46 = load i32* %success, align 4
  %cmp39 = icmp eq i32 %46, 0
  br i1 %cmp39, label %if.then.40, label %if.end.44

if.then.40:                                       ; preds = %if.end.38
  %47 = load i32* %my_id.addr, align 4
  %48 = load %struct._Box** %child, align 8
  %49 = load %struct._Box** %child, align 8
  %child_num = getelementptr inbounds %struct._Box* %49, i32 0, i32 9
  %50 = load i32* %child_num, align 4
  %idxprom41 = sext i32 %50 to i64
  %51 = load %struct._Box** %pb.addr, align 8
  %children42 = getelementptr inbounds %struct._Box* %51, i32 0, i32 11
  %arrayidx43 = getelementptr inbounds [4 x %struct._Box*]* %children42, i32 0, i64 %idxprom41
  %52 = load %struct._Box** %arrayidx43, align 8
  %53 = load %struct._Box** %pb.addr, align 8
  call void @MLGHelper(i32 %47, %struct._Box* %48, %struct._Box* %52, %struct._Box* %53)
  br label %if.end.44

if.end.44:                                        ; preds = %if.then.40, %if.end.38
  br label %if.end.45

if.end.45:                                        ; preds = %if.end.44, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end.45
  %54 = load i32* %i, align 4
  %inc = add nsw i32 %54, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @InsertParticlesInLeaf(i32 %my_id, %struct._Particle** %p_array, i32 %length, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %p_array.addr = alloca %struct._Particle**, align 8
  %length.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %offset = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle** %p_array, %struct._Particle*** %p_array.addr, align 8
  store i32 %length, i32* %length.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load i32* %length.addr, align 4
  %1 = load %struct._Box** %b.addr, align 8
  %num_particles = getelementptr inbounds %struct._Box* %1, i32 0, i32 7
  %2 = load i32* %num_particles, align 4
  %add = add nsw i32 %0, %2
  %cmp = icmp sgt i32 %add, 40
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %3 = load %struct._Box** %b.addr, align 8
  %num_particles1 = getelementptr inbounds %struct._Box* %3, i32 0, i32 7
  %4 = load i32* %num_particles1, align 4
  store i32 %4, i32* %i, align 4
  %5 = load i32* %length.addr, align 4
  %sub = sub nsw i32 %5, 1
  store i32 %sub, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  %6 = load i32* %i, align 4
  %cmp2 = icmp slt i32 %6, 40
  br i1 %cmp2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %7 = load i32* %j, align 4
  %idxprom = sext i32 %7 to i64
  %8 = load %struct._Particle*** %p_array.addr, align 8
  %arrayidx = getelementptr inbounds %struct._Particle** %8, i64 %idxprom
  %9 = load %struct._Particle** %arrayidx, align 8
  %10 = load i32* %i, align 4
  %idxprom3 = sext i32 %10 to i64
  %11 = load %struct._Box** %b.addr, align 8
  %particles = getelementptr inbounds %struct._Box* %11, i32 0, i32 6
  %arrayidx4 = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i64 %idxprom3
  store %struct._Particle* %9, %struct._Particle** %arrayidx4, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %12 = load i32* %i, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %i, align 4
  %13 = load i32* %j, align 4
  %dec = add nsw i32 %13, -1
  store i32 %dec, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %14 = load %struct._Box** %b.addr, align 8
  %num_particles5 = getelementptr inbounds %struct._Box* %14, i32 0, i32 7
  store i32 40, i32* %num_particles5, align 4
  %15 = load i32* %j, align 4
  %add6 = add nsw i32 %15, 1
  store i32 %add6, i32* %length.addr, align 4
  %16 = load i32* %my_id.addr, align 4
  %17 = load %struct._Particle*** %p_array.addr, align 8
  %18 = load i32* %length.addr, align 4
  %19 = load %struct._Box** %b.addr, align 8
  call void @InsertParticlesInTree(i32 %16, %struct._Particle** %17, i32 %18, %struct._Box* %19)
  br label %if.end

if.else:                                          ; preds = %entry
  %20 = load %struct._Box** %b.addr, align 8
  %num_particles7 = getelementptr inbounds %struct._Box* %20, i32 0, i32 7
  %21 = load i32* %num_particles7, align 4
  store i32 %21, i32* %offset, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc.17, %if.else
  %22 = load i32* %i, align 4
  %23 = load i32* %length.addr, align 4
  %cmp9 = icmp slt i32 %22, %23
  br i1 %cmp9, label %for.body.10, label %for.end.19

for.body.10:                                      ; preds = %for.cond.8
  %24 = load i32* %i, align 4
  %idxprom11 = sext i32 %24 to i64
  %25 = load %struct._Particle*** %p_array.addr, align 8
  %arrayidx12 = getelementptr inbounds %struct._Particle** %25, i64 %idxprom11
  %26 = load %struct._Particle** %arrayidx12, align 8
  %27 = load i32* %i, align 4
  %28 = load i32* %offset, align 4
  %add13 = add nsw i32 %27, %28
  %idxprom14 = sext i32 %add13 to i64
  %29 = load %struct._Box** %b.addr, align 8
  %particles15 = getelementptr inbounds %struct._Box* %29, i32 0, i32 6
  %arrayidx16 = getelementptr inbounds [41 x %struct._Particle*]* %particles15, i32 0, i64 %idxprom14
  store %struct._Particle* %26, %struct._Particle** %arrayidx16, align 8
  br label %for.inc.17

for.inc.17:                                       ; preds = %for.body.10
  %30 = load i32* %i, align 4
  %inc18 = add nsw i32 %30, 1
  store i32 %inc18, i32* %i, align 4
  br label %for.cond.8

for.end.19:                                       ; preds = %for.cond.8
  %31 = load i32* %length.addr, align 4
  %32 = load %struct._Box** %b.addr, align 8
  %num_particles20 = getelementptr inbounds %struct._Box* %32, i32 0, i32 7
  %33 = load i32* %num_particles20, align 4
  %add21 = add nsw i32 %33, %31
  store i32 %add21, i32* %num_particles20, align 4
  br label %if.end

if.end:                                           ; preds = %for.end.19, %for.end
  ret void
}

; Function Attrs: nounwind uwtable
define void @SplitParticles(i32 %my_id, %struct._Particle** %p_array, i32 %length, %struct._Particle** %p_dist, i32* %num_p_dist, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %p_array.addr = alloca %struct._Particle**, align 8
  %length.addr = alloca i32, align 4
  %p_dist.addr = alloca %struct._Particle**, align 8
  %num_p_dist.addr = alloca i32*, align 8
  %pb.addr = alloca %struct._Box*, align 8
  %p = alloca %struct._Particle*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Particle** %p_array, %struct._Particle*** %p_array.addr, align 8
  store i32 %length, i32* %length.addr, align 4
  store %struct._Particle** %p_dist, %struct._Particle*** %p_dist.addr, align 8
  store i32* %num_p_dist, i32** %num_p_dist.addr, align 8
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %cmp = icmp slt i32 %0, 4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32* %i, align 4
  %idxprom = sext i32 %1 to i64
  %2 = load i32** %num_p_dist.addr, align 8
  %arrayidx = getelementptr inbounds i32* %2, i64 %idxprom
  store i32 0, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %3 = load i32* %i, align 4
  %inc = add nsw i32 %3, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.36, %for.end
  %4 = load i32* %i, align 4
  %5 = load i32* %length.addr, align 4
  %cmp2 = icmp slt i32 %4, %5
  br i1 %cmp2, label %for.body.3, label %for.end.38

for.body.3:                                       ; preds = %for.cond.1
  %6 = load i32* %i, align 4
  %idxprom4 = sext i32 %6 to i64
  %7 = load %struct._Particle*** %p_array.addr, align 8
  %arrayidx5 = getelementptr inbounds %struct._Particle** %7, i64 %idxprom4
  %8 = load %struct._Particle** %arrayidx5, align 8
  store %struct._Particle* %8, %struct._Particle** %p, align 8
  %9 = load %struct._Particle** %p, align 8
  %pos = getelementptr inbounds %struct._Particle* %9, i32 0, i32 3
  %y = getelementptr inbounds %struct._Vector* %pos, i32 0, i32 1
  %10 = load double* %y, align 8
  %11 = load %struct._Box** %pb.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %11, i32 0, i32 2
  %12 = load double* %y_center, align 8
  %cmp6 = fcmp ogt double %10, %12
  br i1 %cmp6, label %if.then, label %if.else.17

if.then:                                          ; preds = %for.body.3
  %13 = load %struct._Particle** %p, align 8
  %pos7 = getelementptr inbounds %struct._Particle* %13, i32 0, i32 3
  %x = getelementptr inbounds %struct._Vector* %pos7, i32 0, i32 0
  %14 = load double* %x, align 8
  %15 = load %struct._Box** %pb.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %15, i32 0, i32 1
  %16 = load double* %x_center, align 8
  %cmp8 = fcmp ogt double %14, %16
  br i1 %cmp8, label %if.then.9, label %if.else

if.then.9:                                        ; preds = %if.then
  %17 = load %struct._Particle** %p, align 8
  %18 = load %struct._Particle*** %p_dist.addr, align 8
  %19 = load i32** %num_p_dist.addr, align 8
  %arrayidx10 = getelementptr inbounds i32* %19, i64 0
  %20 = load i32* %arrayidx10, align 4
  %inc11 = add nsw i32 %20, 1
  store i32 %inc11, i32* %arrayidx10, align 4
  %idx.ext = sext i32 %20 to i64
  %add.ptr = getelementptr inbounds %struct._Particle** %18, i64 %idx.ext
  store %struct._Particle* %17, %struct._Particle** %add.ptr, align 8
  br label %if.end

if.else:                                          ; preds = %if.then
  %21 = load %struct._Particle** %p, align 8
  %22 = load %struct._Particle*** %p_dist.addr, align 8
  %add.ptr12 = getelementptr inbounds %struct._Particle** %22, i64 40
  %23 = load i32** %num_p_dist.addr, align 8
  %arrayidx13 = getelementptr inbounds i32* %23, i64 1
  %24 = load i32* %arrayidx13, align 4
  %inc14 = add nsw i32 %24, 1
  store i32 %inc14, i32* %arrayidx13, align 4
  %idx.ext15 = sext i32 %24 to i64
  %add.ptr16 = getelementptr inbounds %struct._Particle** %add.ptr12, i64 %idx.ext15
  store %struct._Particle* %21, %struct._Particle** %add.ptr16, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then.9
  br label %if.end.35

if.else.17:                                       ; preds = %for.body.3
  %25 = load %struct._Particle** %p, align 8
  %pos18 = getelementptr inbounds %struct._Particle* %25, i32 0, i32 3
  %x19 = getelementptr inbounds %struct._Vector* %pos18, i32 0, i32 0
  %26 = load double* %x19, align 8
  %27 = load %struct._Box** %pb.addr, align 8
  %x_center20 = getelementptr inbounds %struct._Box* %27, i32 0, i32 1
  %28 = load double* %x_center20, align 8
  %cmp21 = fcmp ogt double %26, %28
  br i1 %cmp21, label %if.then.22, label %if.else.28

if.then.22:                                       ; preds = %if.else.17
  %29 = load %struct._Particle** %p, align 8
  %30 = load %struct._Particle*** %p_dist.addr, align 8
  %add.ptr23 = getelementptr inbounds %struct._Particle** %30, i64 120
  %31 = load i32** %num_p_dist.addr, align 8
  %arrayidx24 = getelementptr inbounds i32* %31, i64 3
  %32 = load i32* %arrayidx24, align 4
  %inc25 = add nsw i32 %32, 1
  store i32 %inc25, i32* %arrayidx24, align 4
  %idx.ext26 = sext i32 %32 to i64
  %add.ptr27 = getelementptr inbounds %struct._Particle** %add.ptr23, i64 %idx.ext26
  store %struct._Particle* %29, %struct._Particle** %add.ptr27, align 8
  br label %if.end.34

if.else.28:                                       ; preds = %if.else.17
  %33 = load %struct._Particle** %p, align 8
  %34 = load %struct._Particle*** %p_dist.addr, align 8
  %add.ptr29 = getelementptr inbounds %struct._Particle** %34, i64 80
  %35 = load i32** %num_p_dist.addr, align 8
  %arrayidx30 = getelementptr inbounds i32* %35, i64 2
  %36 = load i32* %arrayidx30, align 4
  %inc31 = add nsw i32 %36, 1
  store i32 %inc31, i32* %arrayidx30, align 4
  %idx.ext32 = sext i32 %36 to i64
  %add.ptr33 = getelementptr inbounds %struct._Particle** %add.ptr29, i64 %idx.ext32
  store %struct._Particle* %33, %struct._Particle** %add.ptr33, align 8
  br label %if.end.34

if.end.34:                                        ; preds = %if.else.28, %if.then.22
  br label %if.end.35

if.end.35:                                        ; preds = %if.end.34, %if.end
  br label %for.inc.36

for.inc.36:                                       ; preds = %if.end.35
  %37 = load i32* %i, align 4
  %inc37 = add nsw i32 %37, 1
  store i32 %inc37, i32* %i, align 4
  br label %for.cond.1

for.end.38:                                       ; preds = %for.cond.1
  ret void
}

; Function Attrs: nounwind uwtable
define %struct._Box* @CreateLeaf(i32 %my_id, %struct._Box* %pb, i32 %new_child_num, %struct._Particle** %p_array, i32 %length) {
entry:
  %my_id.addr = alloca i32, align 4
  %pb.addr = alloca %struct._Box*, align 8
  %new_child_num.addr = alloca i32, align 4
  %p_array.addr = alloca %struct._Particle**, align 8
  %length.addr = alloca i32, align 4
  %child_length = alloca double, align 8
  %child_offset = alloca double, align 8
  %ret_box = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  store i32 %new_child_num, i32* %new_child_num.addr, align 4
  store %struct._Particle** %p_array, %struct._Particle*** %p_array.addr, align 8
  store i32 %length, i32* %length.addr, align 4
  %0 = load %struct._Box** %pb.addr, align 8
  %length1 = getelementptr inbounds %struct._Box* %0, i32 0, i32 3
  %1 = load double* %length1, align 8
  %div = fdiv double %1, 2.000000e+00
  store double %div, double* %child_length, align 8
  %2 = load %struct._Box** %pb.addr, align 8
  %length2 = getelementptr inbounds %struct._Box* %2, i32 0, i32 3
  %3 = load double* %length2, align 8
  %div3 = fdiv double %3, 4.000000e+00
  store double %div3, double* %child_offset, align 8
  %4 = load i32* %new_child_num.addr, align 4
  %cmp = icmp eq i32 %4, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %5 = load i32* %my_id.addr, align 4
  %6 = load %struct._Box** %pb.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %6, i32 0, i32 1
  %7 = load double* %x_center, align 8
  %8 = load double* %child_offset, align 8
  %add = fadd double %7, %8
  %9 = load %struct._Box** %pb.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %9, i32 0, i32 2
  %10 = load double* %y_center, align 8
  %11 = load double* %child_offset, align 8
  %add4 = fadd double %10, %11
  %12 = load double* %child_length, align 8
  %13 = load %struct._Box** %pb.addr, align 8
  %call = call %struct._Box* @InitBox(i32 %5, double %add, double %add4, double %12, %struct._Box* %13)
  store %struct._Box* %call, %struct._Box** %ret_box, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %14 = load i32* %new_child_num.addr, align 4
  %cmp5 = icmp eq i32 %14, 1
  br i1 %cmp5, label %if.then.6, label %if.end.11

if.then.6:                                        ; preds = %if.end
  %15 = load i32* %my_id.addr, align 4
  %16 = load %struct._Box** %pb.addr, align 8
  %x_center7 = getelementptr inbounds %struct._Box* %16, i32 0, i32 1
  %17 = load double* %x_center7, align 8
  %18 = load double* %child_offset, align 8
  %sub = fsub double %17, %18
  %19 = load %struct._Box** %pb.addr, align 8
  %y_center8 = getelementptr inbounds %struct._Box* %19, i32 0, i32 2
  %20 = load double* %y_center8, align 8
  %21 = load double* %child_offset, align 8
  %add9 = fadd double %20, %21
  %22 = load double* %child_length, align 8
  %23 = load %struct._Box** %pb.addr, align 8
  %call10 = call %struct._Box* @InitBox(i32 %15, double %sub, double %add9, double %22, %struct._Box* %23)
  store %struct._Box* %call10, %struct._Box** %ret_box, align 8
  br label %if.end.11

if.end.11:                                        ; preds = %if.then.6, %if.end
  %24 = load i32* %new_child_num.addr, align 4
  %cmp12 = icmp eq i32 %24, 2
  br i1 %cmp12, label %if.then.13, label %if.end.19

if.then.13:                                       ; preds = %if.end.11
  %25 = load i32* %my_id.addr, align 4
  %26 = load %struct._Box** %pb.addr, align 8
  %x_center14 = getelementptr inbounds %struct._Box* %26, i32 0, i32 1
  %27 = load double* %x_center14, align 8
  %28 = load double* %child_offset, align 8
  %sub15 = fsub double %27, %28
  %29 = load %struct._Box** %pb.addr, align 8
  %y_center16 = getelementptr inbounds %struct._Box* %29, i32 0, i32 2
  %30 = load double* %y_center16, align 8
  %31 = load double* %child_offset, align 8
  %sub17 = fsub double %30, %31
  %32 = load double* %child_length, align 8
  %33 = load %struct._Box** %pb.addr, align 8
  %call18 = call %struct._Box* @InitBox(i32 %25, double %sub15, double %sub17, double %32, %struct._Box* %33)
  store %struct._Box* %call18, %struct._Box** %ret_box, align 8
  br label %if.end.19

if.end.19:                                        ; preds = %if.then.13, %if.end.11
  %34 = load i32* %new_child_num.addr, align 4
  %cmp20 = icmp eq i32 %34, 3
  br i1 %cmp20, label %if.then.21, label %if.end.27

if.then.21:                                       ; preds = %if.end.19
  %35 = load i32* %my_id.addr, align 4
  %36 = load %struct._Box** %pb.addr, align 8
  %x_center22 = getelementptr inbounds %struct._Box* %36, i32 0, i32 1
  %37 = load double* %x_center22, align 8
  %38 = load double* %child_offset, align 8
  %add23 = fadd double %37, %38
  %39 = load %struct._Box** %pb.addr, align 8
  %y_center24 = getelementptr inbounds %struct._Box* %39, i32 0, i32 2
  %40 = load double* %y_center24, align 8
  %41 = load double* %child_offset, align 8
  %sub25 = fsub double %40, %41
  %42 = load double* %child_length, align 8
  %43 = load %struct._Box** %pb.addr, align 8
  %call26 = call %struct._Box* @InitBox(i32 %35, double %add23, double %sub25, double %42, %struct._Box* %43)
  store %struct._Box* %call26, %struct._Box** %ret_box, align 8
  br label %if.end.27

if.end.27:                                        ; preds = %if.then.21, %if.end.19
  %44 = load i32* %new_child_num.addr, align 4
  %45 = load %struct._Box** %ret_box, align 8
  %child_num = getelementptr inbounds %struct._Box* %45, i32 0, i32 9
  store i32 %44, i32* %child_num, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.27
  %46 = load i32* %i, align 4
  %47 = load i32* %length.addr, align 4
  %cmp28 = icmp slt i32 %46, %47
  br i1 %cmp28, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %48 = load i32* %i, align 4
  %idxprom = sext i32 %48 to i64
  %49 = load %struct._Particle*** %p_array.addr, align 8
  %arrayidx = getelementptr inbounds %struct._Particle** %49, i64 %idxprom
  %50 = load %struct._Particle** %arrayidx, align 8
  %51 = load i32* %i, align 4
  %idxprom29 = sext i32 %51 to i64
  %52 = load %struct._Box** %ret_box, align 8
  %particles = getelementptr inbounds %struct._Box* %52, i32 0, i32 6
  %arrayidx30 = getelementptr inbounds [41 x %struct._Particle*]* %particles, i32 0, i64 %idxprom29
  store %struct._Particle* %50, %struct._Particle** %arrayidx30, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %53 = load i32* %i, align 4
  %inc = add nsw i32 %53, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %54 = load i32* %length.addr, align 4
  %55 = load %struct._Box** %ret_box, align 8
  %num_particles = getelementptr inbounds %struct._Box* %55, i32 0, i32 7
  store i32 %54, i32* %num_particles, align 4
  %56 = load %struct._Box** %ret_box, align 8
  ret %struct._Box* %56
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

; Function Attrs: nounwind uwtable
define void @InsertSubtreeInPartition(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %child = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %proc = getelementptr inbounds %struct._Box* %0, i32 0, i32 30
  %1 = load i32* %proc, align 4
  %2 = load i32* %my_id.addr, align 4
  %cmp = icmp eq i32 %1, %2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = load i32* %my_id.addr, align 4
  %4 = load %struct._Box** %b.addr, align 8
  call void @InsertBoxInPartition(i32 %3, %struct._Box* %4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %5 = load %struct._Box** %b.addr, align 8
  %type = getelementptr inbounds %struct._Box* %5, i32 0, i32 5
  %6 = load i32* %type, align 4
  %cmp1 = icmp eq i32 %6, 1
  br i1 %cmp1, label %if.then.2, label %if.end.12

if.then.2:                                        ; preds = %if.end
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.2
  %7 = load i32* %i, align 4
  %cmp3 = icmp slt i32 %7, 4
  br i1 %cmp3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %8 = load i32* %i, align 4
  %idxprom = sext i32 %8 to i64
  %9 = load %struct._Box** %b.addr, align 8
  %children = getelementptr inbounds %struct._Box* %9, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom
  %10 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %10, %struct._Box** %child, align 8
  %11 = load %struct._Box** %child, align 8
  %cmp4 = icmp eq %struct._Box* %11, null
  br i1 %cmp4, label %if.then.5, label %if.end.8

if.then.5:                                        ; preds = %for.body
  %12 = load i32* %i, align 4
  %idxprom6 = sext i32 %12 to i64
  %13 = load %struct._Box** %b.addr, align 8
  %shadow = getelementptr inbounds %struct._Box* %13, i32 0, i32 10
  %arrayidx7 = getelementptr inbounds [4 x %struct._Box*]* %shadow, i32 0, i64 %idxprom6
  %14 = load %struct._Box** %arrayidx7, align 8
  store %struct._Box* %14, %struct._Box** %child, align 8
  br label %if.end.8

if.end.8:                                         ; preds = %if.then.5, %for.body
  %15 = load %struct._Box** %child, align 8
  %cmp9 = icmp ne %struct._Box* %15, null
  br i1 %cmp9, label %if.then.10, label %if.end.11

if.then.10:                                       ; preds = %if.end.8
  %16 = load i32* %my_id.addr, align 4
  %17 = load %struct._Box** %child, align 8
  call void @InsertSubtreeInPartition(i32 %16, %struct._Box* %17)
  br label %if.end.11

if.end.11:                                        ; preds = %if.then.10, %if.end.8
  br label %for.inc

for.inc:                                          ; preds = %if.end.11
  %18 = load i32* %i, align 4
  %inc = add nsw i32 %18, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.12

if.end.12:                                        ; preds = %for.end, %if.end
  ret void
}

declare void @InsertBoxInPartition(i32, %struct._Box*)

declare void @RemoveBoxFromPartition(i32, %struct._Box*)

; Function Attrs: nounwind uwtable
define void @SetSiblings(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb = alloca %struct._Box*, align 8
  %sb = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %num_siblings = getelementptr inbounds %struct._Box* %0, i32 0, i32 14
  store i32 0, i32* %num_siblings, align 4
  %1 = load %struct._Box** %b.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %1, i32 0, i32 8
  %2 = load %struct._Box** %parent, align 8
  store %struct._Box* %2, %struct._Box** %pb, align 8
  %3 = load %struct._Box** %pb, align 8
  %cmp = icmp ne %struct._Box* %3, null
  br i1 %cmp, label %if.then, label %if.end.9

if.then:                                          ; preds = %entry
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  %4 = load i32* %i, align 4
  %cmp1 = icmp slt i32 %4, 4
  br i1 %cmp1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load i32* %i, align 4
  %idxprom = sext i32 %5 to i64
  %6 = load %struct._Box** %pb, align 8
  %children = getelementptr inbounds %struct._Box* %6, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom
  %7 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %7, %struct._Box** %sb, align 8
  %8 = load %struct._Box** %sb, align 8
  %cmp2 = icmp ne %struct._Box* %8, null
  br i1 %cmp2, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %for.body
  %9 = load %struct._Box** %sb, align 8
  %10 = load %struct._Box** %b.addr, align 8
  %cmp3 = icmp ne %struct._Box* %9, %10
  br i1 %cmp3, label %if.then.4, label %if.end

if.then.4:                                        ; preds = %land.lhs.true
  %11 = load %struct._Box** %sb, align 8
  %12 = load %struct._Box** %b.addr, align 8
  %num_siblings5 = getelementptr inbounds %struct._Box* %12, i32 0, i32 14
  %13 = load i32* %num_siblings5, align 4
  %inc = add nsw i32 %13, 1
  store i32 %inc, i32* %num_siblings5, align 4
  %idxprom6 = sext i32 %13 to i64
  %14 = load %struct._Box** %b.addr, align 8
  %siblings = getelementptr inbounds %struct._Box* %14, i32 0, i32 13
  %arrayidx7 = getelementptr inbounds [3 x %struct._Box*]* %siblings, i32 0, i64 %idxprom6
  store %struct._Box* %11, %struct._Box** %arrayidx7, align 8
  br label %if.end

if.end:                                           ; preds = %if.then.4, %land.lhs.true, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %15 = load i32* %i, align 4
  %inc8 = add nsw i32 %15, 1
  store i32 %inc8, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.9

if.end.9:                                         ; preds = %for.end, %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @SetColleagues(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb = alloca %struct._Box*, align 8
  %cb = alloca %struct._Box*, align 8
  %cousin = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %num_colleagues = getelementptr inbounds %struct._Box* %0, i32 0, i32 16
  store i32 0, i32* %num_colleagues, align 4
  %1 = load %struct._Box** %b.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %1, i32 0, i32 8
  %2 = load %struct._Box** %parent, align 8
  store %struct._Box* %2, %struct._Box** %pb, align 8
  %3 = load %struct._Box** %pb, align 8
  %cmp = icmp ne %struct._Box* %3, null
  br i1 %cmp, label %if.then, label %if.end.36

if.then:                                          ; preds = %entry
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  %4 = load i32* %i, align 4
  %5 = load %struct._Box** %b.addr, align 8
  %num_siblings = getelementptr inbounds %struct._Box* %5, i32 0, i32 14
  %6 = load i32* %num_siblings, align 4
  %cmp1 = icmp slt i32 %4, %6
  br i1 %cmp1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %7 = load i32* %i, align 4
  %idxprom = sext i32 %7 to i64
  %8 = load %struct._Box** %b.addr, align 8
  %siblings = getelementptr inbounds %struct._Box* %8, i32 0, i32 13
  %arrayidx = getelementptr inbounds [3 x %struct._Box*]* %siblings, i32 0, i64 %idxprom
  %9 = load %struct._Box** %arrayidx, align 8
  %10 = load %struct._Box** %b.addr, align 8
  %num_colleagues2 = getelementptr inbounds %struct._Box* %10, i32 0, i32 16
  %11 = load i32* %num_colleagues2, align 4
  %inc = add nsw i32 %11, 1
  store i32 %inc, i32* %num_colleagues2, align 4
  %idxprom3 = sext i32 %11 to i64
  %12 = load %struct._Box** %b.addr, align 8
  %colleagues = getelementptr inbounds %struct._Box* %12, i32 0, i32 15
  %arrayidx4 = getelementptr inbounds [8 x %struct._Box*]* %colleagues, i32 0, i64 %idxprom3
  store %struct._Box* %9, %struct._Box** %arrayidx4, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %13 = load i32* %i, align 4
  %inc5 = add nsw i32 %13, 1
  store i32 %inc5, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.end
  %14 = load %struct._Box** %b.addr, align 8
  %construct_synch = getelementptr inbounds %struct._Box* %14, i32 0, i32 28
  %15 = load volatile i32* %construct_synch, align 4
  %cmp6 = icmp eq i32 %15, 0
  br i1 %cmp6, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %16 = load %struct._Box** %b.addr, align 8
  %construct_synch7 = getelementptr inbounds %struct._Box* %16, i32 0, i32 28
  store volatile i32 0, i32* %construct_synch7, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc.33, %while.end
  %17 = load i32* %i, align 4
  %18 = load %struct._Box** %pb, align 8
  %num_colleagues9 = getelementptr inbounds %struct._Box* %18, i32 0, i32 16
  %19 = load i32* %num_colleagues9, align 4
  %cmp10 = icmp slt i32 %17, %19
  br i1 %cmp10, label %for.body.11, label %for.end.35

for.body.11:                                      ; preds = %for.cond.8
  %20 = load i32* %i, align 4
  %idxprom12 = sext i32 %20 to i64
  %21 = load %struct._Box** %pb, align 8
  %colleagues13 = getelementptr inbounds %struct._Box* %21, i32 0, i32 15
  %arrayidx14 = getelementptr inbounds [8 x %struct._Box*]* %colleagues13, i32 0, i64 %idxprom12
  %22 = load %struct._Box** %arrayidx14, align 8
  store %struct._Box* %22, %struct._Box** %cb, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond.15

for.cond.15:                                      ; preds = %for.inc.30, %for.body.11
  %23 = load i32* %j, align 4
  %cmp16 = icmp slt i32 %23, 4
  br i1 %cmp16, label %for.body.17, label %for.end.32

for.body.17:                                      ; preds = %for.cond.15
  %24 = load i32* %j, align 4
  %idxprom18 = sext i32 %24 to i64
  %25 = load %struct._Box** %cb, align 8
  %children = getelementptr inbounds %struct._Box* %25, i32 0, i32 11
  %arrayidx19 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom18
  %26 = load %struct._Box** %arrayidx19, align 8
  store %struct._Box* %26, %struct._Box** %cousin, align 8
  %27 = load %struct._Box** %cousin, align 8
  %cmp20 = icmp ne %struct._Box* %27, null
  br i1 %cmp20, label %if.then.21, label %if.end.29

if.then.21:                                       ; preds = %for.body.17
  %28 = load i32* %my_id.addr, align 4
  %29 = load %struct._Box** %b.addr, align 8
  %30 = load %struct._Box** %cousin, align 8
  %call = call i32 @AdjacentBoxes(i32 %28, %struct._Box* %29, %struct._Box* %30)
  %cmp22 = icmp eq i32 %call, 1
  br i1 %cmp22, label %if.then.23, label %if.end

if.then.23:                                       ; preds = %if.then.21
  %31 = load %struct._Box** %cousin, align 8
  %32 = load %struct._Box** %b.addr, align 8
  %num_colleagues24 = getelementptr inbounds %struct._Box* %32, i32 0, i32 16
  %33 = load i32* %num_colleagues24, align 4
  %inc25 = add nsw i32 %33, 1
  store i32 %inc25, i32* %num_colleagues24, align 4
  %idxprom26 = sext i32 %33 to i64
  %34 = load %struct._Box** %b.addr, align 8
  %colleagues27 = getelementptr inbounds %struct._Box* %34, i32 0, i32 15
  %arrayidx28 = getelementptr inbounds [8 x %struct._Box*]* %colleagues27, i32 0, i64 %idxprom26
  store %struct._Box* %31, %struct._Box** %arrayidx28, align 8
  br label %if.end

if.end:                                           ; preds = %if.then.23, %if.then.21
  br label %if.end.29

if.end.29:                                        ; preds = %if.end, %for.body.17
  br label %for.inc.30

for.inc.30:                                       ; preds = %if.end.29
  %35 = load i32* %j, align 4
  %inc31 = add nsw i32 %35, 1
  store i32 %inc31, i32* %j, align 4
  br label %for.cond.15

for.end.32:                                       ; preds = %for.cond.15
  br label %for.inc.33

for.inc.33:                                       ; preds = %for.end.32
  %36 = load i32* %i, align 4
  %inc34 = add nsw i32 %36, 1
  store i32 %inc34, i32* %i, align 4
  br label %for.cond.8

for.end.35:                                       ; preds = %for.cond.8
  br label %if.end.36

if.end.36:                                        ; preds = %for.end.35, %entry
  %37 = load %struct._Box** %b.addr, align 8
  %type = getelementptr inbounds %struct._Box* %37, i32 0, i32 5
  %38 = load i32* %type, align 4
  %cmp37 = icmp eq i32 %38, 1
  br i1 %cmp37, label %if.then.38, label %if.end.55

if.then.38:                                       ; preds = %if.end.36
  store i32 0, i32* %i, align 4
  br label %for.cond.39

for.cond.39:                                      ; preds = %for.inc.52, %if.then.38
  %39 = load i32* %i, align 4
  %cmp40 = icmp slt i32 %39, 4
  br i1 %cmp40, label %for.body.41, label %for.end.54

for.body.41:                                      ; preds = %for.cond.39
  %40 = load i32* %i, align 4
  %idxprom42 = sext i32 %40 to i64
  %41 = load %struct._Box** %b.addr, align 8
  %children43 = getelementptr inbounds %struct._Box* %41, i32 0, i32 11
  %arrayidx44 = getelementptr inbounds [4 x %struct._Box*]* %children43, i32 0, i64 %idxprom42
  %42 = load %struct._Box** %arrayidx44, align 8
  %cmp45 = icmp ne %struct._Box* %42, null
  br i1 %cmp45, label %if.then.46, label %if.end.51

if.then.46:                                       ; preds = %for.body.41
  %43 = load i32* %i, align 4
  %idxprom47 = sext i32 %43 to i64
  %44 = load %struct._Box** %b.addr, align 8
  %children48 = getelementptr inbounds %struct._Box* %44, i32 0, i32 11
  %arrayidx49 = getelementptr inbounds [4 x %struct._Box*]* %children48, i32 0, i64 %idxprom47
  %45 = load %struct._Box** %arrayidx49, align 8
  %construct_synch50 = getelementptr inbounds %struct._Box* %45, i32 0, i32 28
  store volatile i32 1, i32* %construct_synch50, align 4
  br label %if.end.51

if.end.51:                                        ; preds = %if.then.46, %for.body.41
  br label %for.inc.52

for.inc.52:                                       ; preds = %if.end.51
  %46 = load i32* %i, align 4
  %inc53 = add nsw i32 %46, 1
  store i32 %inc53, i32* %i, align 4
  br label %for.cond.39

for.end.54:                                       ; preds = %for.cond.39
  br label %if.end.55

if.end.55:                                        ; preds = %for.end.54, %if.end.36
  ret void
}

declare i32 @AdjacentBoxes(i32, %struct._Box*, %struct._Box*)

; Function Attrs: nounwind uwtable
define void @SetVList(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb = alloca %struct._Box*, align 8
  %cb = alloca %struct._Box*, align 8
  %cousin = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %num_v_list = getelementptr inbounds %struct._Box* %0, i32 0, i32 20
  store i32 0, i32* %num_v_list, align 4
  %1 = load %struct._Box** %b.addr, align 8
  %parent = getelementptr inbounds %struct._Box* %1, i32 0, i32 8
  %2 = load %struct._Box** %parent, align 8
  store %struct._Box* %2, %struct._Box** %pb, align 8
  %3 = load %struct._Box** %pb, align 8
  %cmp = icmp ne %struct._Box* %3, null
  br i1 %cmp, label %if.then, label %if.end.19

if.then:                                          ; preds = %entry
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.16, %if.then
  %4 = load i32* %i, align 4
  %5 = load %struct._Box** %pb, align 8
  %num_colleagues = getelementptr inbounds %struct._Box* %5, i32 0, i32 16
  %6 = load i32* %num_colleagues, align 4
  %cmp1 = icmp slt i32 %4, %6
  br i1 %cmp1, label %for.body, label %for.end.18

for.body:                                         ; preds = %for.cond
  %7 = load i32* %i, align 4
  %idxprom = sext i32 %7 to i64
  %8 = load %struct._Box** %pb, align 8
  %colleagues = getelementptr inbounds %struct._Box* %8, i32 0, i32 15
  %arrayidx = getelementptr inbounds [8 x %struct._Box*]* %colleagues, i32 0, i64 %idxprom
  %9 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %9, %struct._Box** %cb, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc, %for.body
  %10 = load i32* %j, align 4
  %cmp3 = icmp slt i32 %10, 4
  br i1 %cmp3, label %for.body.4, label %for.end

for.body.4:                                       ; preds = %for.cond.2
  %11 = load i32* %j, align 4
  %idxprom5 = sext i32 %11 to i64
  %12 = load %struct._Box** %cb, align 8
  %children = getelementptr inbounds %struct._Box* %12, i32 0, i32 11
  %arrayidx6 = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom5
  %13 = load %struct._Box** %arrayidx6, align 8
  store %struct._Box* %13, %struct._Box** %cousin, align 8
  %14 = load %struct._Box** %cousin, align 8
  %cmp7 = icmp ne %struct._Box* %14, null
  br i1 %cmp7, label %if.then.8, label %if.end.14

if.then.8:                                        ; preds = %for.body.4
  %15 = load i32* %my_id.addr, align 4
  %16 = load %struct._Box** %b.addr, align 8
  %17 = load %struct._Box** %cousin, align 8
  %call = call i32 @WellSeparatedBoxes(i32 %15, %struct._Box* %16, %struct._Box* %17)
  %cmp9 = icmp eq i32 %call, 1
  br i1 %cmp9, label %if.then.10, label %if.end

if.then.10:                                       ; preds = %if.then.8
  %18 = load %struct._Box** %cousin, align 8
  %19 = load %struct._Box** %b.addr, align 8
  %num_v_list11 = getelementptr inbounds %struct._Box* %19, i32 0, i32 20
  %20 = load i32* %num_v_list11, align 4
  %inc = add nsw i32 %20, 1
  store i32 %inc, i32* %num_v_list11, align 4
  %idxprom12 = sext i32 %20 to i64
  %21 = load %struct._Box** %b.addr, align 8
  %v_list = getelementptr inbounds %struct._Box* %21, i32 0, i32 19
  %arrayidx13 = getelementptr inbounds [27 x %struct._Box*]* %v_list, i32 0, i64 %idxprom12
  store %struct._Box* %18, %struct._Box** %arrayidx13, align 8
  br label %if.end

if.end:                                           ; preds = %if.then.10, %if.then.8
  br label %if.end.14

if.end.14:                                        ; preds = %if.end, %for.body.4
  br label %for.inc

for.inc:                                          ; preds = %if.end.14
  %22 = load i32* %j, align 4
  %inc15 = add nsw i32 %22, 1
  store i32 %inc15, i32* %j, align 4
  br label %for.cond.2

for.end:                                          ; preds = %for.cond.2
  br label %for.inc.16

for.inc.16:                                       ; preds = %for.end
  %23 = load i32* %i, align 4
  %inc17 = add nsw i32 %23, 1
  store i32 %inc17, i32* %i, align 4
  br label %for.cond

for.end.18:                                       ; preds = %for.cond
  br label %if.end.19

if.end.19:                                        ; preds = %for.end.18, %entry
  ret void
}

; Function Attrs: nounwind uwtable
define void @SetUList(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %num_u_list = getelementptr inbounds %struct._Box* %0, i32 0, i32 18
  store i32 0, i32* %num_u_list, align 4
  %1 = load i32* %my_id.addr, align 4
  %2 = load %struct._Box** %b.addr, align 8
  %3 = load %struct._Box** @Grid, align 8
  call void @SetUListHelper(i32 %1, %struct._Box* %2, %struct._Box* %3)
  ret void
}

; Function Attrs: nounwind uwtable
define void @SetWList(i32 %my_id, %struct._Box* %b) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %co_search = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  %0 = load %struct._Box** %b.addr, align 8
  %num_w_list = getelementptr inbounds %struct._Box* %0, i32 0, i32 22
  store i32 0, i32* %num_w_list, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4
  %2 = load %struct._Box** %b.addr, align 8
  %num_colleagues = getelementptr inbounds %struct._Box* %2, i32 0, i32 16
  %3 = load i32* %num_colleagues, align 4
  %cmp = icmp slt i32 %1, %3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %4 = load i32* %i, align 4
  %idxprom = sext i32 %4 to i64
  %5 = load %struct._Box** %b.addr, align 8
  %colleagues = getelementptr inbounds %struct._Box* %5, i32 0, i32 15
  %arrayidx = getelementptr inbounds [8 x %struct._Box*]* %colleagues, i32 0, i64 %idxprom
  %6 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %6, %struct._Box** %co_search, align 8
  %7 = load %struct._Box** %co_search, align 8
  %type = getelementptr inbounds %struct._Box* %7, i32 0, i32 5
  %8 = load i32* %type, align 4
  %cmp1 = icmp eq i32 %8, 1
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %9 = load i32* %my_id.addr, align 4
  %10 = load %struct._Box** %b.addr, align 8
  %11 = load %struct._Box** %co_search, align 8
  call void @InsertNonAdjChildren(i32 %9, %struct._Box* %10, %struct._Box* %11)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %12 = load i32* %i, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

declare i32 @WellSeparatedBoxes(i32, %struct._Box*, %struct._Box*)

; Function Attrs: nounwind uwtable
define void @SetUListHelper(i32 %my_id, %struct._Box* %b, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb.addr = alloca %struct._Box*, align 8
  %child = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %cmp = icmp slt i32 %0, 4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32* %i, align 4
  %idxprom = sext i32 %1 to i64
  %2 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %2, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom
  %3 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %3, %struct._Box** %child, align 8
  %4 = load %struct._Box** %child, align 8
  %cmp1 = icmp ne %struct._Box* %4, null
  br i1 %cmp1, label %if.then, label %if.end.14

if.then:                                          ; preds = %for.body
  %5 = load i32* %my_id.addr, align 4
  %6 = load %struct._Box** %b.addr, align 8
  %7 = load %struct._Box** %child, align 8
  %call = call i32 @AdjacentBoxes(i32 %5, %struct._Box* %6, %struct._Box* %7)
  %cmp2 = icmp eq i32 %call, 1
  br i1 %cmp2, label %if.then.3, label %if.else.8

if.then.3:                                        ; preds = %if.then
  %8 = load %struct._Box** %child, align 8
  %type = getelementptr inbounds %struct._Box* %8, i32 0, i32 5
  %9 = load i32* %type, align 4
  %cmp4 = icmp eq i32 %9, 0
  br i1 %cmp4, label %if.then.5, label %if.else

if.then.5:                                        ; preds = %if.then.3
  %10 = load %struct._Box** %child, align 8
  %11 = load %struct._Box** %b.addr, align 8
  %num_u_list = getelementptr inbounds %struct._Box* %11, i32 0, i32 18
  %12 = load i32* %num_u_list, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %num_u_list, align 4
  %idxprom6 = sext i32 %12 to i64
  %13 = load %struct._Box** %b.addr, align 8
  %u_list = getelementptr inbounds %struct._Box* %13, i32 0, i32 17
  %arrayidx7 = getelementptr inbounds [20 x %struct._Box*]* %u_list, i32 0, i64 %idxprom6
  store %struct._Box* %10, %struct._Box** %arrayidx7, align 8
  br label %if.end

if.else:                                          ; preds = %if.then.3
  %14 = load i32* %my_id.addr, align 4
  %15 = load %struct._Box** %b.addr, align 8
  %16 = load %struct._Box** %child, align 8
  call void @SetUListHelper(i32 %14, %struct._Box* %15, %struct._Box* %16)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then.5
  br label %if.end.13

if.else.8:                                        ; preds = %if.then
  %17 = load i32* %my_id.addr, align 4
  %18 = load %struct._Box** %b.addr, align 8
  %19 = load %struct._Box** %child, align 8
  %call9 = call i32 @AncestorBox(i32 %17, %struct._Box* %18, %struct._Box* %19)
  %cmp10 = icmp eq i32 %call9, 1
  br i1 %cmp10, label %if.then.11, label %if.end.12

if.then.11:                                       ; preds = %if.else.8
  %20 = load i32* %my_id.addr, align 4
  %21 = load %struct._Box** %b.addr, align 8
  %22 = load %struct._Box** %child, align 8
  call void @SetUListHelper(i32 %20, %struct._Box* %21, %struct._Box* %22)
  br label %if.end.12

if.end.12:                                        ; preds = %if.then.11, %if.else.8
  br label %if.end.13

if.end.13:                                        ; preds = %if.end.12, %if.end
  br label %if.end.14

if.end.14:                                        ; preds = %if.end.13, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end.14
  %23 = load i32* %i, align 4
  %inc15 = add nsw i32 %23, 1
  store i32 %inc15, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @AncestorBox(i32 %my_id, %struct._Box* %b, %struct._Box* %ancestor_box) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %ancestor_box.addr = alloca %struct._Box*, align 8
  %x_center_distance = alloca double, align 8
  %y_center_distance = alloca double, align 8
  %ret_val = alloca i32, align 4
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store %struct._Box* %ancestor_box, %struct._Box** %ancestor_box.addr, align 8
  store i32 1, i32* %ret_val, align 4
  %0 = load %struct._Box** %b.addr, align 8
  %length = getelementptr inbounds %struct._Box* %0, i32 0, i32 3
  %1 = load double* %length, align 8
  %2 = load %struct._Box** %ancestor_box.addr, align 8
  %length1 = getelementptr inbounds %struct._Box* %2, i32 0, i32 3
  %3 = load double* %length1, align 8
  %cmp = fcmp une double %1, %3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %4 = load %struct._Box** %b.addr, align 8
  %x_center = getelementptr inbounds %struct._Box* %4, i32 0, i32 1
  %5 = load double* %x_center, align 8
  %6 = load %struct._Box** %ancestor_box.addr, align 8
  %x_center2 = getelementptr inbounds %struct._Box* %6, i32 0, i32 1
  %7 = load double* %x_center2, align 8
  %sub = fsub double %5, %7
  %call = call double @fabs(double %sub)
  store double %call, double* %x_center_distance, align 8
  %8 = load %struct._Box** %b.addr, align 8
  %y_center = getelementptr inbounds %struct._Box* %8, i32 0, i32 2
  %9 = load double* %y_center, align 8
  %10 = load %struct._Box** %ancestor_box.addr, align 8
  %y_center3 = getelementptr inbounds %struct._Box* %10, i32 0, i32 2
  %11 = load double* %y_center3, align 8
  %sub4 = fsub double %9, %11
  %call5 = call double @fabs(double %sub4)
  store double %call5, double* %y_center_distance, align 8
  %12 = load double* %x_center_distance, align 8
  %13 = load %struct._Box** %ancestor_box.addr, align 8
  %length6 = getelementptr inbounds %struct._Box* %13, i32 0, i32 3
  %14 = load double* %length6, align 8
  %div = fdiv double %14, 2.000000e+00
  %cmp7 = fcmp ogt double %12, %div
  br i1 %cmp7, label %if.then.11, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.then
  %15 = load double* %y_center_distance, align 8
  %16 = load %struct._Box** %ancestor_box.addr, align 8
  %length8 = getelementptr inbounds %struct._Box* %16, i32 0, i32 3
  %17 = load double* %length8, align 8
  %div9 = fdiv double %17, 2.000000e+00
  %cmp10 = fcmp ogt double %15, %div9
  br i1 %cmp10, label %if.then.11, label %if.end

if.then.11:                                       ; preds = %lor.lhs.false, %if.then
  store i32 0, i32* %ret_val, align 4
  br label %if.end

if.end:                                           ; preds = %if.then.11, %lor.lhs.false
  br label %if.end.12

if.else:                                          ; preds = %entry
  store i32 0, i32* %ret_val, align 4
  br label %if.end.12

if.end.12:                                        ; preds = %if.else, %if.end
  %18 = load i32* %ret_val, align 4
  ret i32 %18
}

; Function Attrs: nounwind readnone
declare double @fabs(double)

; Function Attrs: nounwind uwtable
define void @InsertNonAdjChildren(i32 %my_id, %struct._Box* %b, %struct._Box* %pb) {
entry:
  %my_id.addr = alloca i32, align 4
  %b.addr = alloca %struct._Box*, align 8
  %pb.addr = alloca %struct._Box*, align 8
  %i = alloca i32, align 4
  %child = alloca %struct._Box*, align 8
  store i32 %my_id, i32* %my_id.addr, align 4
  store %struct._Box* %b, %struct._Box** %b.addr, align 8
  store %struct._Box* %pb, %struct._Box** %pb.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load %struct._Box** %pb.addr, align 8
  %num_children = getelementptr inbounds %struct._Box* %1, i32 0, i32 12
  %2 = load i32* %num_children, align 4
  %cmp = icmp slt i32 %0, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load %struct._Box** %pb.addr, align 8
  %children = getelementptr inbounds %struct._Box* %4, i32 0, i32 11
  %arrayidx = getelementptr inbounds [4 x %struct._Box*]* %children, i32 0, i64 %idxprom
  %5 = load %struct._Box** %arrayidx, align 8
  store %struct._Box* %5, %struct._Box** %child, align 8
  %6 = load %struct._Box** %child, align 8
  %cmp1 = icmp ne %struct._Box* %6, null
  br i1 %cmp1, label %if.then, label %if.end.9

if.then:                                          ; preds = %for.body
  %7 = load i32* %my_id.addr, align 4
  %8 = load %struct._Box** %b.addr, align 8
  %9 = load %struct._Box** %child, align 8
  %call = call i32 @AdjacentBoxes(i32 %7, %struct._Box* %8, %struct._Box* %9)
  %cmp2 = icmp eq i32 %call, 1
  br i1 %cmp2, label %if.then.3, label %if.else

if.then.3:                                        ; preds = %if.then
  %10 = load %struct._Box** %child, align 8
  %type = getelementptr inbounds %struct._Box* %10, i32 0, i32 5
  %11 = load i32* %type, align 4
  %cmp4 = icmp eq i32 %11, 1
  br i1 %cmp4, label %if.then.5, label %if.end

if.then.5:                                        ; preds = %if.then.3
  %12 = load i32* %my_id.addr, align 4
  %13 = load %struct._Box** %b.addr, align 8
  %14 = load %struct._Box** %child, align 8
  call void @InsertNonAdjChildren(i32 %12, %struct._Box* %13, %struct._Box* %14)
  br label %if.end

if.end:                                           ; preds = %if.then.5, %if.then.3
  br label %if.end.8

if.else:                                          ; preds = %if.then
  %15 = load %struct._Box** %child, align 8
  %16 = load %struct._Box** %b.addr, align 8
  %num_w_list = getelementptr inbounds %struct._Box* %16, i32 0, i32 22
  %17 = load i32* %num_w_list, align 4
  %inc = add nsw i32 %17, 1
  store i32 %inc, i32* %num_w_list, align 4
  %idxprom6 = sext i32 %17 to i64
  %18 = load %struct._Box** %b.addr, align 8
  %w_list = getelementptr inbounds %struct._Box* %18, i32 0, i32 21
  %arrayidx7 = getelementptr inbounds [30 x %struct._Box*]* %w_list, i32 0, i64 %idxprom6
  store %struct._Box* %15, %struct._Box** %arrayidx7, align 8
  br label %if.end.8

if.end.8:                                         ; preds = %if.else, %if.end
  br label %if.end.9

if.end.9:                                         ; preds = %if.end.8, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end.9
  %19 = load i32* %i, align 4
  %inc10 = add nsw i32 %19, 1
  store i32 %inc10, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}


