; ModuleID = 'exe.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ThreadNdb = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@tNoOfThreads = internal global i32 3, align 4
@pThreads = internal global [3 x %struct.ThreadNdb] zeroinitializer, align 4
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
define internal i8* @flexHammerThread(i8* %pArg) {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %pThreadData = alloca %struct.ThreadNdb*, align 8
  store i8* %pArg, i8** %2, align 8
  %3 = load i8** %2, align 8
  %4 = bitcast i8* %3 to %struct.ThreadNdb*
  store %struct.ThreadNdb* %4, %struct.ThreadNdb** %pThreadData, align 8
  %5 = load %struct.ThreadNdb** %pThreadData, align 8
  %6 = getelementptr inbounds %struct.ThreadNdb* %5, i32 0, i32 0
  call void @printX()
  store i32 1, i32* %6, align 4
  %call = call i32 @sleep(i32 3)
  %7 = load i8** %1
  ret i8* %7
}

declare void @Criteria(i32)

; Function Attrs: nounwind uwtable
define internal void @resetThreads(%struct.ThreadNdb* %threadArrayP) {
  %1 = alloca %struct.ThreadNdb*, align 8
  %i = alloca i32, align 4
  store %struct.ThreadNdb* %threadArrayP, %struct.ThreadNdb** %1, align 8
  store i32 0, i32* %i, align 4
  br label %2

; <label>:2                                       ; preds = %11, %0
  %3 = load i32* %i, align 4
  %4 = load i32* @tNoOfThreads, align 4
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %6, label %14

; <label>:6                                       ; preds = %2
  %7 = load i32* %i, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [3 x %struct.ThreadNdb]* @pThreads, i32 0, i64 %8
  %10 = getelementptr inbounds %struct.ThreadNdb* %9, i32 0, i32 0
  store i32 0, i32* %10, align 4
  br label %11

; <label>:11                                      ; preds = %6
  %12 = load i32* %i, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, i32* %i, align 4
  br label %2

; <label>:14                                      ; preds = %2
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @waitForThreads(%struct.ThreadNdb* %threadArrayP) {
  %1 = alloca %struct.ThreadNdb*, align 8
  %cont = alloca i32, align 4
  %i = alloca i32, align 4
  store %struct.ThreadNdb* %threadArrayP, %struct.ThreadNdb** %1, align 8
  store i32 1, i32* %cont, align 4
  br label %2

; <label>:2                                       ; preds = %22, %0
  %3 = load i32* %cont, align 4
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %5, label %23

; <label>:5                                       ; preds = %2
  store i32 0, i32* %cont, align 4
  store i32 0, i32* %i, align 4
  br label %6

; <label>:6                                       ; preds = %19, %5
  %7 = load i32* %i, align 4
  %8 = load i32* @tNoOfThreads, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %22

; <label>:10                                      ; preds = %6
  %11 = load i32* %i, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [3 x %struct.ThreadNdb]* @pThreads, i32 0, i64 %12
  %14 = getelementptr inbounds %struct.ThreadNdb* %13, i32 0, i32 0
  %15 = load i32* %14, align 4
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %18

; <label>:17                                      ; preds = %10
  store i32 1, i32* %cont, align 4
  br label %22

; <label>:18                                      ; preds = %10
  br label %19

; <label>:19                                      ; preds = %18
  %20 = load i32* %i, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, i32* %i, align 4
  br label %6

; <label>:22                                      ; preds = %17, %6
  %call = call i32 @sleep(i32 2)
  br label %2

; <label>:23                                      ; preds = %2
  call void @printY()
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %i = alloca i32, align 4
  %t = alloca i64, align 8
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  call void @resetThreads(%struct.ThreadNdb* getelementptr inbounds ([3 x %struct.ThreadNdb]* @pThreads, i32 0, i32 0))
  store i32 0, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %15, %0
  %5 = load i32* %i, align 4
  %6 = load i32* @tNoOfThreads, align 4
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %8, label %18

; <label>:8                                       ; preds = %4
  %9 = load i32* %i, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [3 x %struct.ThreadNdb]* @pThreads, i32 0, i64 %10
  %12 = bitcast %struct.ThreadNdb* %11 to i8**
  %13 = bitcast i8** %12 to i8*
  %14 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* @flexHammerThread, i8* %13)
  br label %15

; <label>:15                                      ; preds = %8
  %16 = load i32* %i, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* %i, align 4
  br label %4

; <label>:18                                      ; preds = %4
  call void @waitForThreads(%struct.ThreadNdb* getelementptr inbounds ([3 x %struct.ThreadNdb]* @pThreads, i32 0, i32 0))
  call void @waitForAll()
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: nounwind uwtable
define internal void @DeriveInvariant() {
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckInvariant() {
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @RecordSyncVariable() {
  ret void
}

define internal void @printX() {
  %1 = load i32* @index_out, align 4
  %2 = sext i32 %1 to i64
  %3 = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %2
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
  %3 = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %2
  store i8 89, i8* %3, align 1
  %4 = load i32* @index_out, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, i32* @index_out, align 4
  ret void
}

define internal void @printY() {
  call void @appendY()
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @flushAll() {
  %1 = load i32* @index_out, align 4
  %2 = sext i32 %1 to i64
  %3 = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %2
  store i8 0, i8* %3, align 1
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @printChar(i8 signext %ch) {
  %1 = alloca i8, align 1
  store i8 %ch, i8* %1, align 1
  %2 = load i8* %1, align 1
  %3 = load i32* @index_out, align 4
  %4 = sext i32 %3 to i64
  %5 = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %4
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

; Function Attrs: nounwind uwtable
define internal void @InitializeSwitchesAndCounter(i32 %id) {
  %1 = alloca i32, align 4
  store i32 %id, i32* %1, align 4
  ret void
}

; Function Attrs: nounwind uwtable
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
  ret void
}

declare i32 @sleep(i32)

