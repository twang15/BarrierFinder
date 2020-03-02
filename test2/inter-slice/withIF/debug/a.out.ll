; ModuleID = 'a.out.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.GlobalMemory = type { i32, %union.pthread_mutex_t, %struct.barrier_t, i32*, i32*, i32, i32, i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.barrier_t = type { i32, i64 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@P = internal global i32 1, align 4
@Global = internal global %struct.GlobalMemory* null, align 8
@.str = private unnamed_addr constant [8 x i8] c"id > 2\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
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
  store i32 2, i32* @P
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
  %call = call i8* @malloc(i64 96)
  %0 = bitcast i8* %call to %struct.GlobalMemory*
  store %struct.GlobalMemory* %0, %struct.GlobalMemory** @Global, align 8
  %1 = load %struct.GlobalMemory** @Global, align 8
  %start1 = getelementptr inbounds %struct.GlobalMemory* %1, i32 0, i32 2
  %gsense = getelementptr inbounds %struct.barrier_t* %start1, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %2 = load %struct.GlobalMemory** @Global, align 8
  %start2 = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start2, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  store i32 1, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32* %i, align 4
  %4 = load i32* @P, align 4
  %cmp = icmp slt i32 %3, %4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call3 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @SlaveStart to i8* (i8*)*), i8* null)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %5 = load i32* %i, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @SlaveStart()
  unreachable

return:                                           ; No predecessors!
  ret i32 undef
}

declare i8* @malloc(i64)

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: noreturn
declare void @exit(i32)

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
define internal void @foo(i32 %id) {
entry:
  %id.addr = alloca i32, align 4
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret void
}

declare i32 @printf(i8*, ...)

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

while.body:                                       ; preds = %if.end.22, %entry
  %2 = load %struct.GlobalMemory** @Global, align 8
  %start7 = getelementptr inbounds %struct.GlobalMemory* %2, i32 0, i32 2
  %count = getelementptr inbounds %struct.barrier_t* %start7, i32 0, i32 1
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
  %call8 = call i32 @atomic_cmpxchg(i32 %6, i32 %7)
  %call6 = call i32 @sleep(i32 1)
  store i32 %call8, i32* %updatedcount, align 4
  %8 = load i32* %updatedcount, align 4
  %9 = load i32* %oldcount, align 4
  %cmp = icmp eq i32 %8, %9
  br i1 %cmp, label %if.then, label %if.end.22

if.then:                                          ; preds = %while.body
  %10 = load i32* %newcount, align 4
  %11 = load i32* @P, align 4
  %call2 = call i32 @sleep(i32 1)
  %cmp10 = icmp eq i32 %10, %11
  br i1 %cmp10, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %if.then
  %12 = load i32* %lsense, align 4
  %cmp12 = icmp eq i32 %12, 1
  br i1 %cmp12, label %if.then.19, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %if.then
  %13 = load i32* %newcount, align 4
  %cmp14 = icmp eq i32 %13, 0
  br i1 %cmp14, label %land.lhs.true.16, label %if.end

land.lhs.true.16:                                 ; preds = %lor.lhs.false
  %14 = load i32* %lsense, align 4
  %cmp17 = icmp eq i32 %14, -1
  br i1 %cmp17, label %if.then.19, label %if.end

if.then.19:                                       ; preds = %land.lhs.true.16, %land.lhs.true
  %15 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %15
  %16 = load %struct.GlobalMemory** @Global, align 8
  %start20 = getelementptr inbounds %struct.GlobalMemory* %16, i32 0, i32 2
  %gsense21 = getelementptr inbounds %struct.barrier_t* %start20, i32 0, i32 0
  call void @printX()
  store volatile i32 %sub, i32* %gsense21, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call3 = call i32 @sleep(i32 3)
  br label %if.end

if.end:                                           ; preds = %if.then.19, %land.lhs.true.16, %lor.lhs.false
  br label %while.end

if.end.22:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %while.body.27, %while.end
  %17 = load %struct.GlobalMemory** @Global, align 8
  %start23 = getelementptr inbounds %struct.GlobalMemory* %17, i32 0, i32 2
  %gsense24 = getelementptr inbounds %struct.barrier_t* %start23, i32 0, i32 0
  %18 = load volatile i32* %gsense24, align 4
  %19 = load i32* %lsense, align 4
  %cmp25 = icmp eq i32 %18, %19
  br i1 %cmp25, label %while.body.27, label %while.end.28

while.body.27:                                    ; preds = %while.cond
  %call4 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.28:                                     ; preds = %while.cond
  call void @printY()
  %call5 = call i32 @sleep(i32 1)
  ret void
}

; Function Attrs: nounwind readnone
declare i64 @pthread_self()

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

declare void @Criteria(i32)

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

; Function Attrs: nounwind uwtable
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


