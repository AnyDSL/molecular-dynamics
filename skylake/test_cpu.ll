; ModuleID = 'test_cpu'
source_filename = "test_cpu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%0 = type { %1, i32, i32, double, %2, i32 }
%1 = type { [3 x double], [3 x double] }
%2 = type { i32, [0 x i8]* }
%3 = type { %2, %2, %2, %2, i32, i32, i32, i32, %2, i32 }
%4 = type { double, double, double }
%5 = type { %6, %1 }
%6 = type { i32, i32, %2, %2 }

@grid_ = local_unnamed_addr global %0 zeroinitializer
@0 = internal global [17 x i8] c"Memory address: \00"
@1 = internal global [9 x i8] c"\0AIndex: \00"
@2 = internal global [2 x i8] c" \00"
@3 = internal global [8 x i8] c"\0ASize: \00"
@4 = internal global [12 x i8] c"\0ACapacity: \00"
@5 = internal global [11 x i8] c"\0APadding: \00"
@6 = internal global [22 x i8] c"\0ANumber of clusters: \00"
@7 = internal global [16 x i8] c"\0ACluster size: \00"
@8 = internal global [2 x i8] c"\0A\00"
@9 = internal global [12 x i8] c"Positions:\0A\00"
@10 = internal global [9 x i8] c"Forces:\0A\00"
@11 = internal global [13 x i8] c"Velocities:\0A\00"
@12 = internal global [11 x i8] c"Clusters:\0A\00"
@13 = internal global [2 x i8] c"\0A\00"
@14 = internal global [7 x i8] c"AABB:\0A\00"
@15 = internal global [5 x i8] c"x: (\00"
@16 = internal global [3 x i8] c", \00"
@17 = internal global [3 x i8] c")\0A\00"
@18 = internal global [5 x i8] c"y: (\00"
@19 = internal global [3 x i8] c", \00"
@20 = internal global [3 x i8] c")\0A\00"
@21 = internal global [5 x i8] c"z: (\00"
@22 = internal global [3 x i8] c", \00"
@23 = internal global [3 x i8] c")\0A\00"
@24 = internal global [16 x i8] c"Neighbor list:\0A\00"
@25 = internal global [7 x i8] c"Size: \00"
@26 = internal global [12 x i8] c"\0ACapacity: \00"
@27 = internal global [2 x i8] c"\0A\00"
@28 = internal global [2 x i8] c"\0A\00"
@29 = internal global [15 x i8] c"Cell address: \00"
@30 = internal global [9 x i8] c" Index: \00"
@31 = internal global [2 x i8] c"\0A\00"
@32 = internal global [2 x i8] c" \00"
@33 = internal global [2 x i8] c" \00"
@34 = internal global [2 x i8] c"\0A\00"
@35 = internal global [2 x i8] c"\0A\00"
@36 = internal global [2 x i8] c"\0A\00"
@37 = internal global [38 x i8] c"The arrays are too small for storing \00"
@38 = internal global [13 x i8] c" particles!\0A\00"

define double @cpu_compute_total_kinetic_energy() local_unnamed_addr {
cpu_compute_total_kinetic_energy_start:
  %parallel_closure = alloca { %2, double* }, align 8
  %kinetic_energy_281238 = alloca double, align 8
  store double 0.000000e+00, double* %kinetic_energy_281238, align 8
  %0 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %.fca.0.extract = extractvalue %2 %0, 0
  %.fca.0.gep = getelementptr inbounds { %2, double* }, { %2, double* }* %parallel_closure, i64 0, i32 0, i32 0
  store i32 %.fca.0.extract, i32* %.fca.0.gep, align 8
  %.fca.1.extract = extractvalue %2 %0, 1
  %.fca.1.gep = getelementptr inbounds { %2, double* }, { %2, double* }* %parallel_closure, i64 0, i32 0, i32 1
  store [0 x i8]* %.fca.1.extract, [0 x i8]** %.fca.1.gep, align 8
  %parallel_closure.repack1 = getelementptr inbounds { %2, double* }, { %2, double* }* %parallel_closure, i64 0, i32 1
  store double* %kinetic_energy_281238, double** %parallel_closure.repack1, align 8
  %2 = bitcast { %2, double* }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %1, i8* nonnull %2, i8* bitcast (void (i8*, i32, i32)* @lambda_281245_parallel_for to i8*))
  %3 = load double, double* %kinetic_energy_281238, align 8
  ret double %3
}

; Function Attrs: nounwind
define void @lambda_281245_parallel_for(i8* nocapture readonly, i32, i32) #0 {
lambda_281245_parallel_for:
  %3 = getelementptr inbounds i8, i8* %0, i64 8
  %4 = bitcast i8* %3 to [0 x %3]**
  %5 = load [0 x %3]*, [0 x %3]** %4, align 8
  %.elt1 = getelementptr inbounds i8, i8* %0, i64 16
  %6 = bitcast i8* %.elt1 to i64**
  %.unpack23 = load i64*, i64** %6, align 8
  %7 = icmp slt i32 %1, %2
  br i1 %7, label %body.preheader, label %exit

body.preheader:                                   ; preds = %lambda_281245_parallel_for
  br label %body

body:                                             ; preds = %body.preheader, %lambda_281245.exit
  %parallel_loop_phi6 = phi i32 [ %46, %lambda_281245.exit ], [ %1, %body.preheader ]
  %8 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %9 = icmp sgt i32 %8, 0
  br i1 %9, label %if_then.i.preheader, label %lambda_281245.exit

if_then.i.preheader:                              ; preds = %body
  br label %if_then.i

if_then.i:                                        ; preds = %if_then.i.preheader, %if_else4.i.if_then.i_crit_edge
  %10 = phi i32 [ %.pre, %if_else4.i.if_then.i_crit_edge ], [ %8, %if_then.i.preheader ]
  %lower.i5 = phi i32 [ %23, %if_else4.i.if_then.i_crit_edge ], [ 0, %if_then.i.preheader ]
  %11 = mul nsw i32 %10, %parallel_loop_phi6
  %12 = add nsw i32 %11, %lower.i5
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %13, i32 4
  %15 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %13, i32 0, i32 1
  %16 = bitcast [0 x i8]** %15 to [0 x double]**
  %17 = load [0 x double]*, [0 x double]** %16, align 8
  %18 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %13, i32 2, i32 1
  %19 = bitcast [0 x i8]** %18 to [0 x %4]**
  %20 = load [0 x %4]*, [0 x %4]** %19, align 8
  %21 = load i32, i32* %14, align 4
  %22 = icmp sgt i32 %21, 0
  br i1 %22, label %if_then5.i.preheader, label %if_else4.i

if_then5.i.preheader:                             ; preds = %if_then.i
  %wide.trip.count = zext i32 %21 to i64
  br label %if_then5.i

if_else4.i.loopexit:                              ; preds = %next.i
  br label %if_else4.i

if_else4.i:                                       ; preds = %if_else4.i.loopexit, %if_then.i
  %23 = add nuw nsw i32 %lower.i5, 1
  %exitcond8 = icmp eq i32 %23, %8
  br i1 %exitcond8, label %lambda_281245.exit.loopexit, label %if_else4.i.if_then.i_crit_edge

if_else4.i.if_then.i_crit_edge:                   ; preds = %if_else4.i
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then.i

if_then5.i:                                       ; preds = %if_then5.i.preheader, %next.i
  %indvars.iv = phi i64 [ %indvars.iv.next, %next.i ], [ 0, %if_then5.i.preheader ]
  %24 = getelementptr inbounds [0 x %4], [0 x %4]* %20, i64 0, i64 %indvars.iv, i32 1
  %25 = getelementptr inbounds [0 x %4], [0 x %4]* %20, i64 0, i64 %indvars.iv, i32 2
  %26 = getelementptr inbounds [0 x %4], [0 x %4]* %20, i64 0, i64 %indvars.iv, i32 0
  %27 = load double, double* %26, align 8
  %28 = fmul double %27, %27
  %29 = load double, double* %24, align 8
  %30 = load double, double* %25, align 8
  %31 = fmul double %29, %29
  %32 = fadd double %28, %31
  %33 = fmul double %30, %30
  %34 = fadd double %32, %33
  %35 = tail call double @llvm.sqrt.f64(double %34)
  %36 = getelementptr inbounds [0 x double], [0 x double]* %17, i64 0, i64 %indvars.iv
  %37 = load double, double* %36, align 8
  %38 = fmul double %37, 5.000000e-01
  %39 = fmul double %38, %35
  br label %while_body.i

while_body.i:                                     ; preds = %if_then5.i, %while_body.i
  %40 = load i64, i64* %.unpack23, align 8
  %41 = bitcast i64 %40 to double
  %42 = fadd double %39, %41
  %43 = bitcast double %42 to i64
  %44 = cmpxchg i64* %.unpack23, i64 %40, i64 %43 seq_cst seq_cst
  %45 = extractvalue { i64, i1 } %44, 1
  br i1 %45, label %next.i, label %while_body.i

next.i:                                           ; preds = %while_body.i
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else4.i.loopexit, label %if_then5.i

lambda_281245.exit.loopexit:                      ; preds = %if_else4.i
  br label %lambda_281245.exit

lambda_281245.exit:                               ; preds = %lambda_281245.exit.loopexit, %body
  %46 = add nsw i32 %parallel_loop_phi6, 1
  %exitcond9 = icmp eq i32 %46, %2
  br i1 %exitcond9, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %lambda_281245.exit
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_281245_parallel_for
  ret void
}

declare void @anydsl_parallel_for(i32, i32, i32, i8*, i8*) local_unnamed_addr

define void @cpu_integrate_position(double %dt_278183) local_unnamed_addr {
cpu_integrate_position_start:
  %parallel_closure = alloca { double, %2 }, align 8
  %0 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %parallel_closure.repack = getelementptr inbounds { double, %2 }, { double, %2 }* %parallel_closure, i64 0, i32 0
  store double %dt_278183, double* %parallel_closure.repack, align 8
  %.fca.0.extract = extractvalue %2 %0, 0
  %.fca.0.gep = getelementptr inbounds { double, %2 }, { double, %2 }* %parallel_closure, i64 0, i32 1, i32 0
  store i32 %.fca.0.extract, i32* %.fca.0.gep, align 8
  %.fca.1.extract = extractvalue %2 %0, 1
  %.fca.1.gep = getelementptr inbounds { double, %2 }, { double, %2 }* %parallel_closure, i64 0, i32 1, i32 1
  store [0 x i8]* %.fca.1.extract, [0 x i8]** %.fca.1.gep, align 8
  %2 = bitcast { double, %2 }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %1, i8* nonnull %2, i8* bitcast (void (i8*, i32, i32)* @lambda_278208_parallel_for to i8*))
  ret void
}

; Function Attrs: nounwind
define void @lambda_278208_parallel_for(i8* nocapture readonly, i32, i32) #0 {
lambda_278208_parallel_for:
  %3 = getelementptr inbounds i8, i8* %0, i64 16
  %4 = bitcast i8* %3 to [0 x %3]**
  %5 = load [0 x %3]*, [0 x %3]** %4, align 8
  %6 = icmp slt i32 %1, %2
  br i1 %6, label %body.lr.ph, label %exit

body.lr.ph:                                       ; preds = %lambda_278208_parallel_for
  %.elt = bitcast i8* %0 to double*
  %.unpack = load double, double* %.elt, align 8
  %.splatinsert1.i.i = insertelement <1 x double> undef, double %.unpack, i32 0
  br label %body

body:                                             ; preds = %lambda_278208.exit, %body.lr.ph
  %parallel_loop_phi44 = phi i32 [ %1, %body.lr.ph ], [ %64, %lambda_278208.exit ]
  %7 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %if_then.i.preheader, label %lambda_278208.exit

if_then.i.preheader:                              ; preds = %body
  br label %if_then.i

if_then.i:                                        ; preds = %if_then.i.preheader, %if_else4.i.if_then.i_crit_edge
  %9 = phi i32 [ %.pre, %if_else4.i.if_then.i_crit_edge ], [ %7, %if_then.i.preheader ]
  %lower.i43 = phi i32 [ %22, %if_else4.i.if_then.i_crit_edge ], [ 0, %if_then.i.preheader ]
  %10 = mul nsw i32 %9, %parallel_loop_phi44
  %11 = add nsw i32 %10, %lower.i43
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %12, i32 4
  %14 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %12, i32 1, i32 1
  %15 = bitcast [0 x i8]** %14 to [0 x %4]**
  %16 = load [0 x %4]*, [0 x %4]** %15, align 8
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %12, i32 2, i32 1
  %18 = bitcast [0 x i8]** %17 to [0 x %4]**
  %19 = load [0 x %4]*, [0 x %4]** %18, align 8
  %20 = load i32, i32* %13, align 4
  %21 = icmp sgt i32 %20, 0
  br i1 %21, label %body.i.preheader, label %exit.i

body.i.preheader:                                 ; preds = %if_then.i
  br label %body.i

if_else4.i.loopexit:                              ; preds = %_cont.i
  br label %if_else4.i

if_else4.i:                                       ; preds = %if_else4.i.loopexit, %exit.i
  %22 = add nuw nsw i32 %lower.i43, 1
  %exitcond47 = icmp eq i32 %22, %7
  br i1 %exitcond47, label %lambda_278208.exit.loopexit, label %if_else4.i.if_then.i_crit_edge

if_else4.i.if_then.i_crit_edge:                   ; preds = %if_else4.i
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then.i

if_then5.i:                                       ; preds = %if_then5.i.preheader, %_cont.i
  %indvars.iv = phi i64 [ %indvars.iv.next, %_cont.i ], [ 0, %if_then5.i.preheader ]
  %23 = getelementptr inbounds [0 x %4], [0 x %4]* %56, i64 0, i64 %indvars.iv, i32 0
  %24 = load double, double* %23, align 8
  %25 = fcmp olt double %24, %.unpack3.unpack
  br i1 %25, label %next.i.sink.split, label %if_else6.i

if_else6.i:                                       ; preds = %if_then5.i
  %26 = fcmp olt double %.unpack4.unpack, %24
  br i1 %26, label %next.i.sink.split, label %next.i

next.i.sink.split:                                ; preds = %if_else6.i, %if_then5.i
  %.sink = phi double [ %57, %if_then5.i ], [ %60, %if_else6.i ]
  store double %.sink, double* %23, align 8
  br label %next.i

next.i:                                           ; preds = %next.i.sink.split, %if_else6.i
  %27 = getelementptr inbounds [0 x %4], [0 x %4]* %56, i64 0, i64 %indvars.iv, i32 1
  %28 = load double, double* %27, align 8
  %29 = fcmp olt double %28, %.unpack3.unpack8
  br i1 %29, label %next14.i.sink.split, label %if_else10.i

if_else10.i:                                      ; preds = %next.i
  %30 = fcmp olt double %.unpack4.unpack5, %28
  br i1 %30, label %next14.i.sink.split, label %next14.i

next14.i.sink.split:                              ; preds = %if_else10.i, %next.i
  %.sink39 = phi double [ %58, %next.i ], [ %61, %if_else10.i ]
  store double %.sink39, double* %27, align 8
  br label %next14.i

next14.i:                                         ; preds = %next14.i.sink.split, %if_else10.i
  %31 = getelementptr inbounds [0 x %4], [0 x %4]* %56, i64 0, i64 %indvars.iv, i32 2
  %32 = load double, double* %31, align 8
  %33 = fcmp olt double %32, %.unpack3.unpack92324
  br i1 %33, label %_cont.i.sink.split, label %if_else15.i

if_else15.i:                                      ; preds = %next14.i
  %34 = fcmp olt double %.unpack4.unpack63738, %32
  br i1 %34, label %_cont.i.sink.split, label %_cont.i

_cont.i.sink.split:                               ; preds = %if_else15.i, %next14.i
  %.sink40 = phi double [ %59, %next14.i ], [ %62, %if_else15.i ]
  store double %.sink40, double* %31, align 8
  br label %_cont.i

_cont.i:                                          ; preds = %_cont.i.sink.split, %if_else15.i
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond46 = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond46, label %if_else4.i.loopexit, label %if_then5.i

body.i:                                           ; preds = %body.i.preheader, %body.i
  %parallel_loop_phi.i41 = phi i32 [ %54, %body.i ], [ 0, %body.i.preheader ]
  %.splatinsert.i.i = insertelement <1 x i32> undef, i32 %parallel_loop_phi.i41, i32 0
  %35 = sext <1 x i32> %.splatinsert.i.i to <1 x i64>
  %36 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %35, i32 0
  %37 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %36, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %38 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %35, i32 0
  %39 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %38, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %40 = fmul <1 x double> %.splatinsert1.i.i, %37
  %41 = fadd <1 x double> %39, %40
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %41, <1 x double*> %38, i32 1, <1 x i1> <i1 true>)
  %42 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %35, i32 1
  %43 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %42, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %44 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %35, i32 1
  %45 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %44, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %46 = fmul <1 x double> %.splatinsert1.i.i, %43
  %47 = fadd <1 x double> %45, %46
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %47, <1 x double*> %44, i32 1, <1 x i1> <i1 true>)
  %48 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %35, i32 2
  %49 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %48, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %50 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %35, i32 2
  %51 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %50, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %52 = fmul <1 x double> %.splatinsert1.i.i, %49
  %53 = fadd <1 x double> %51, %52
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %53, <1 x double*> %50, i32 1, <1 x i1> <i1 true>)
  %54 = add nuw nsw i32 %parallel_loop_phi.i41, 1
  %exitcond = icmp eq i32 %54, %20
  br i1 %exitcond, label %exit.i.loopexit, label %body.i

exit.i.loopexit:                                  ; preds = %body.i
  %.pre49 = load [0 x %4]*, [0 x %4]** %15, align 8
  %.pre50 = load i32, i32* %13, align 4
  br label %exit.i

exit.i:                                           ; preds = %exit.i.loopexit, %if_then.i
  %55 = phi i32 [ %.pre50, %exit.i.loopexit ], [ %20, %if_then.i ]
  %56 = phi [0 x %4]* [ %.pre49, %exit.i.loopexit ], [ %16, %if_then.i ]
  %.unpack3.unpack = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 0), align 16
  %.unpack3.unpack8 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 1), align 8
  %.unpack3.unpack92324 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 2), align 16
  %.unpack4.unpack = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 0), align 8
  %.unpack4.unpack5 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 1), align 8
  %.unpack4.unpack63738 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 2), align 8
  %57 = fadd double %.unpack3.unpack, 1.000000e-09
  %58 = fadd double %.unpack3.unpack8, 1.000000e-09
  %59 = fadd double %.unpack3.unpack92324, 1.000000e-09
  %60 = fadd double %.unpack4.unpack, -1.000000e-09
  %61 = fadd double %.unpack4.unpack5, -1.000000e-09
  %62 = fadd double %.unpack4.unpack63738, -1.000000e-09
  %63 = icmp sgt i32 %55, 0
  br i1 %63, label %if_then5.i.preheader, label %if_else4.i

if_then5.i.preheader:                             ; preds = %exit.i
  %wide.trip.count = zext i32 %55 to i64
  br label %if_then5.i

lambda_278208.exit.loopexit:                      ; preds = %if_else4.i
  br label %lambda_278208.exit

lambda_278208.exit:                               ; preds = %lambda_278208.exit.loopexit, %body
  %64 = add nsw i32 %parallel_loop_phi44, 1
  %exitcond48 = icmp eq i32 %64, %2
  br i1 %exitcond48, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %lambda_278208.exit
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_278208_parallel_for
  ret void
}

define void @cpu_initialize_grid([0 x double]* nocapture readonly %masses_281539, [0 x %4]* nocapture readonly %positions_281540, [0 x %4]* nocapture readonly %velocities_281541, i32 %nparticles_281542, [0 x double]* nocapture readonly %min_281543, [0 x double]* nocapture readonly %max_281544, double %spacing_281545, i32 %cell_capacity_281546) local_unnamed_addr {
cpu_initialize_grid_start:
  %0 = getelementptr inbounds [0 x double], [0 x double]* %max_281544, i64 0, i64 0
  %1 = getelementptr inbounds [0 x double], [0 x double]* %max_281544, i64 0, i64 1
  %2 = getelementptr inbounds [0 x double], [0 x double]* %max_281544, i64 0, i64 2
  %3 = getelementptr inbounds [0 x double], [0 x double]* %min_281543, i64 0, i64 2
  %4 = getelementptr inbounds [0 x double], [0 x double]* %min_281543, i64 0, i64 0
  %5 = getelementptr inbounds [0 x double], [0 x double]* %min_281543, i64 0, i64 1
  %6 = load double, double* %4, align 8
  %7 = load double, double* %5, align 8
  %8 = load double, double* %3, align 8
  %9 = load double, double* %0, align 8
  %10 = fsub double %9, %6
  %11 = load double, double* %1, align 8
  %12 = fdiv double %10, %spacing_281545
  %13 = load double, double* %2, align 8
  %14 = tail call double @llvm.floor.f64(double %12)
  %15 = fsub double %11, %7
  %16 = fdiv double %15, %spacing_281545
  %17 = tail call double @llvm.floor.f64(double %16)
  %18 = fptosi double %17 to i32
  %ny = add nsw i32 %18, 1
  %19 = fptosi double %14 to i32
  %nx = add i32 %19, 1
  %20 = mul i32 %nx, 104
  %21 = mul i32 %20, %ny
  %22 = sext i32 %21 to i64
  %23 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %22)
  %24 = insertvalue [3 x double] undef, double %6, 0
  %25 = insertvalue [3 x double] %24, double %7, 1
  %26 = insertvalue [3 x double] %25, double %8, 2
  %27 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %23, 1
  %28 = insertvalue [3 x double] undef, double %9, 0
  %29 = insertvalue [3 x double] %28, double %11, 1
  %30 = insertvalue [3 x double] %29, double %13, 2
  %31 = insertvalue %1 undef, [3 x double] %26, 0
  %32 = insertvalue %1 %31, [3 x double] %30, 1
  %33 = insertvalue %0 undef, %1 %32, 0
  %34 = insertvalue %0 %33, i32 %nx, 1
  %35 = insertvalue %0 %34, i32 %ny, 2
  %36 = insertvalue %0 %35, double %spacing_281545, 3
  %37 = insertvalue %0 %36, %2 %27, 4
  %38 = insertvalue %0 %37, i32 0, 5
  %39 = bitcast [0 x i8]* %23 to [0 x %3]*
  %40 = icmp slt i32 %19, 0
  br i1 %40, label %if_else, label %may_unroll_step30.preheader.lr.ph

may_unroll_step30.preheader.lr.ph:                ; preds = %cpu_initialize_grid_start
  %41 = icmp slt i32 %18, 0
  %42 = icmp sgt i32 %cell_capacity_281546, 4
  %.cell_capacity_281546 = select i1 %42, i32 %cell_capacity_281546, i32 4
  %43 = shl nsw i32 %.cell_capacity_281546, 3
  %44 = zext i32 %43 to i64
  %45 = mul nsw i32 %.cell_capacity_281546, 24
  %46 = zext i32 %45 to i64
  br i1 %41, label %if_else, label %may_unroll_step30.preheader.preheader

may_unroll_step30.preheader.preheader:            ; preds = %may_unroll_step30.preheader.lr.ph
  %47 = sext i32 %ny to i64
  %wide.trip.count151 = zext i32 %ny to i64
  %wide.trip.count155 = zext i32 %nx to i64
  br label %may_unroll_step30.preheader

may_unroll_step30.preheader:                      ; preds = %if_else33, %may_unroll_step30.preheader.preheader
  %indvars.iv153 = phi i64 [ 0, %may_unroll_step30.preheader.preheader ], [ %indvars.iv.next154, %if_else33 ]
  %48 = mul nsw i64 %indvars.iv153, %47
  br label %if_then34

if_else.loopexit:                                 ; preds = %if_else33
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %may_unroll_step30.preheader.lr.ph, %cpu_initialize_grid_start
  store %0 %38, %0* @grid_, align 16
  %49 = icmp sgt i32 %nparticles_281542, 0
  br i1 %49, label %if_then.preheader, label %if_else6

if_then.preheader:                                ; preds = %if_else
  %wide.trip.count146 = zext i32 %nparticles_281542 to i64
  br label %if_then

if_else6.loopexit:                                ; preds = %next27
  br label %if_else6

if_else6:                                         ; preds = %if_else6.loopexit, %if_else
  store i32 %nparticles_281542, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 5), align 16
  ret void

if_then:                                          ; preds = %if_then.preheader, %next27
  %indvars.iv144 = phi i64 [ %indvars.iv.next145, %next27 ], [ 0, %if_then.preheader ]
  %50 = getelementptr inbounds [0 x double], [0 x double]* %masses_281539, i64 0, i64 %indvars.iv144
  %51 = bitcast double* %50 to i64*
  %52 = load i64, i64* %51, align 8
  %.elt57 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_281540, i64 0, i64 %indvars.iv144, i32 0
  %.unpack58 = load double, double* %.elt57, align 8
  %.elt59 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_281540, i64 0, i64 %indvars.iv144, i32 1
  %.unpack60 = load double, double* %.elt59, align 8
  %.elt61 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_281540, i64 0, i64 %indvars.iv144, i32 2
  %53 = bitcast double* %.elt61 to i64*
  %.unpack6274 = load i64, i64* %53, align 8
  %.elt63 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_281541, i64 0, i64 %indvars.iv144, i32 0
  %54 = bitcast double* %.elt63 to i64*
  %.unpack6483 = load i64, i64* %54, align 8
  %.elt65 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_281541, i64 0, i64 %indvars.iv144, i32 1
  %55 = bitcast double* %.elt65 to i64*
  %.unpack6682 = load i64, i64* %55, align 8
  %.elt67 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_281541, i64 0, i64 %indvars.iv144, i32 2
  %56 = bitcast double* %.elt67 to i64*
  %.unpack6881 = load i64, i64* %56, align 8
  %57 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 0), align 16
  %58 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 3), align 8
  %59 = fsub double %.unpack58, %57
  %60 = fdiv double %59, %58
  %61 = tail call double @llvm.floor.f64(double %60)
  %62 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 1), align 8
  %63 = fsub double %.unpack60, %62
  %64 = fdiv double %63, %58
  %65 = tail call double @llvm.floor.f64(double %64)
  %66 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %67 = fptosi double %61 to i32
  %68 = fptosi double %65 to i32
  %69 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %70 = mul nsw i32 %67, %69
  %71 = add nsw i32 %68, %70
  %72 = sext i32 %71 to i64
  %73 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72
  %74 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 4
  %75 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 6
  %76 = load i32, i32* %74, align 4
  %new_size = add nsw i32 %76, 1
  %77 = load i32, i32* %75, align 4
  %78 = icmp eq i32 %76, %77
  br i1 %78, label %if_then12, label %if_else11

if_else11:                                        ; preds = %if_then
  store i32 %new_size, i32* %74, align 4
  br label %next27

if_then12:                                        ; preds = %if_then
  %79 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 7
  %80 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 9
  %81 = add nsw i32 %76, 5
  %82 = load i32, i32* %79, align 4
  %83 = load i32, i32* %80, align 4
  %84 = sdiv i32 %82, 10
  %85 = add nsw i32 %84, 1
  %86 = mul nsw i32 %85, %83
  %new_capacity = add nsw i32 %86, %76
  %87 = icmp slt i32 %new_capacity, %81
  %.new_capacity = select i1 %87, i32 %81, i32 %new_capacity
  %88 = shl nsw i32 %.new_capacity, 3
  %89 = sext i32 %88 to i64
  %90 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %89)
  %91 = mul nsw i32 %.new_capacity, 24
  %92 = sext i32 %91 to i64
  %93 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %92)
  %94 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %92)
  %95 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %92)
  %96 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %95, 1
  %97 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %90, 1
  %98 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %94, 1
  %99 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %93, 1
  %100 = insertvalue %3 undef, %2 %97, 0
  %101 = insertvalue %3 %100, %2 %99, 1
  %102 = insertvalue %3 %101, %2 %98, 2
  %103 = insertvalue %3 %102, %2 %96, 3
  %104 = insertvalue %3 %103, %2 zeroinitializer, 8
  %105 = load i32, i32* %74, align 4
  %106 = icmp sgt i32 %105, 0
  br i1 %106, label %if_then28.lr.ph, label %if_else26

if_then28.lr.ph:                                  ; preds = %if_then12
  %107 = bitcast [0 x i8]* %90 to [0 x double]*
  %108 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 0, i32 1
  %109 = bitcast [0 x i8]** %108 to [0 x double]**
  %110 = bitcast [0 x i8]* %93 to [0 x %4]*
  %111 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 1, i32 1
  %112 = bitcast [0 x i8]** %111 to [0 x %4]**
  %113 = bitcast [0 x i8]* %94 to [0 x %4]*
  %114 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 2, i32 1
  %115 = bitcast [0 x i8]** %114 to [0 x %4]**
  %wide.trip.count = zext i32 %105 to i64
  br label %if_then28

if_else26.loopexit:                               ; preds = %if_then28
  br label %if_else26

if_else26:                                        ; preds = %if_else26.loopexit, %if_then12
  %116 = getelementptr inbounds %3, %3* %73, i64 0, i32 0
  %117 = load %2, %2* %116, align 8
  %118 = extractvalue %2 %117, 0
  %119 = extractvalue %2 %117, 1
  tail call void @anydsl_release(i32 %118, [0 x i8]* %119)
  %120 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 1
  %121 = load %2, %2* %120, align 8
  %122 = extractvalue %2 %121, 0
  %123 = extractvalue %2 %121, 1
  tail call void @anydsl_release(i32 %122, [0 x i8]* %123)
  %124 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 2
  %125 = load %2, %2* %124, align 8
  %126 = extractvalue %2 %125, 0
  %127 = extractvalue %2 %125, 1
  tail call void @anydsl_release(i32 %126, [0 x i8]* %127)
  %128 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 3
  %129 = load %2, %2* %128, align 8
  %130 = extractvalue %2 %129, 0
  %131 = extractvalue %2 %129, 1
  tail call void @anydsl_release(i32 %130, [0 x i8]* %131)
  store i32 0, i32* %74, align 4
  store i32 0, i32* %75, align 4
  %132 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 8
  %133 = load i32, i32* %79, align 4
  %134 = icmp sgt i32 %133, 0
  br i1 %134, label %if_then.i, label %deallocate_cell_cont

if_then.i:                                        ; preds = %if_else26
  %135 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 8, i32 1
  %136 = bitcast [0 x i8]** %135 to [0 x %5]**
  %137 = load [0 x %5]*, [0 x %5]** %136, align 8
  %wide.trip.count142 = zext i32 %133 to i64
  br label %if_then2.i

if_else1.i:                                       ; preds = %if_then2.i
  %138 = load %2, %2* %132, align 8
  %139 = extractvalue %2 %138, 0
  %140 = extractvalue %2 %138, 1
  tail call void @anydsl_release(i32 %139, [0 x i8]* %140)
  store i32 0, i32* %79, align 4
  br label %deallocate_cell_cont

if_then2.i:                                       ; preds = %if_then2.i, %if_then.i
  %indvars.iv140 = phi i64 [ 0, %if_then.i ], [ %indvars.iv.next141, %if_then2.i ]
  %141 = getelementptr inbounds [0 x %5], [0 x %5]* %137, i64 0, i64 %indvars.iv140, i32 0, i32 2
  %142 = load %2, %2* %141, align 8
  %143 = extractvalue %2 %142, 0
  %144 = extractvalue %2 %142, 1
  tail call void @anydsl_release(i32 %143, [0 x i8]* %144)
  %145 = getelementptr inbounds [0 x %5], [0 x %5]* %137, i64 0, i64 %indvars.iv140, i32 0, i32 3
  %146 = load %2, %2* %145, align 8
  %147 = extractvalue %2 %146, 0
  %148 = extractvalue %2 %146, 1
  tail call void @anydsl_release(i32 %147, [0 x i8]* %148)
  %149 = getelementptr inbounds [0 x %5], [0 x %5]* %137, i64 0, i64 %indvars.iv140, i32 0, i32 0
  store i32 0, i32* %149, align 4
  %150 = getelementptr inbounds [0 x %5], [0 x %5]* %137, i64 0, i64 %indvars.iv140, i32 0, i32 1
  store i32 0, i32* %150, align 4
  %indvars.iv.next141 = add nuw nsw i64 %indvars.iv140, 1
  %exitcond143 = icmp eq i64 %indvars.iv.next141, %wide.trip.count142
  br i1 %exitcond143, label %if_else1.i, label %if_then2.i

deallocate_cell_cont:                             ; preds = %if_else1.i, %if_else26
  %.fca.4.insert = insertvalue %3 %104, i32 %new_size, 4
  %.fca.5.insert = insertvalue %3 %.fca.4.insert, i32 0, 5
  %.fca.6.insert = insertvalue %3 %.fca.5.insert, i32 %.new_capacity, 6
  %.fca.7.insert = insertvalue %3 %.fca.6.insert, i32 0, 7
  %.fca.8.0.insert = insertvalue %3 %.fca.7.insert, i32 0, 8, 0
  %.fca.8.1.insert = insertvalue %3 %.fca.8.0.insert, [0 x i8]* null, 8, 1
  %.fca.9.insert = insertvalue %3 %.fca.8.1.insert, i32 %83, 9
  store %3 %.fca.9.insert, %3* %73, align 8
  br label %next27

next27:                                           ; preds = %deallocate_cell_cont, %if_else11
  %indvars.iv.next145 = add nuw nsw i64 %indvars.iv144, 1
  %151 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 0, i32 1
  %152 = bitcast [0 x i8]** %151 to [0 x double]**
  %153 = load [0 x double]*, [0 x double]** %152, align 8
  %154 = sext i32 %76 to i64
  %155 = getelementptr inbounds [0 x double], [0 x double]* %153, i64 0, i64 %154
  %156 = bitcast double* %155 to i64*
  store i64 %52, i64* %156, align 8
  %157 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 1, i32 1
  %158 = bitcast [0 x i8]** %157 to [0 x %4]**
  %159 = load [0 x %4]*, [0 x %4]** %158, align 8
  %.repack = getelementptr inbounds [0 x %4], [0 x %4]* %159, i64 0, i64 %154, i32 0
  store double %.unpack58, double* %.repack, align 8
  %.repack70 = getelementptr inbounds [0 x %4], [0 x %4]* %159, i64 0, i64 %154, i32 1
  store double %.unpack60, double* %.repack70, align 8
  %.repack72 = getelementptr inbounds [0 x %4], [0 x %4]* %159, i64 0, i64 %154, i32 2
  %160 = bitcast double* %.repack72 to i64*
  store i64 %.unpack6274, i64* %160, align 8
  %161 = getelementptr inbounds [0 x %3], [0 x %3]* %66, i64 0, i64 %72, i32 2, i32 1
  %162 = bitcast [0 x i8]** %161 to [0 x %4]**
  %163 = load [0 x %4]*, [0 x %4]** %162, align 8
  %164 = getelementptr inbounds [0 x %4], [0 x %4]* %163, i64 0, i64 %154
  %165 = bitcast %4* %164 to i64*
  store i64 %.unpack6483, i64* %165, align 8
  %.repack77 = getelementptr inbounds [0 x %4], [0 x %4]* %163, i64 0, i64 %154, i32 1
  %166 = bitcast double* %.repack77 to i64*
  store i64 %.unpack6682, i64* %166, align 8
  %.repack79 = getelementptr inbounds [0 x %4], [0 x %4]* %163, i64 0, i64 %154, i32 2
  %167 = bitcast double* %.repack79 to i64*
  store i64 %.unpack6881, i64* %167, align 8
  %exitcond147 = icmp eq i64 %indvars.iv.next145, %wide.trip.count146
  br i1 %exitcond147, label %if_else6.loopexit, label %if_then

if_then28:                                        ; preds = %if_then28, %if_then28.lr.ph
  %indvars.iv = phi i64 [ 0, %if_then28.lr.ph ], [ %indvars.iv.next, %if_then28 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %168 = load [0 x double]*, [0 x double]** %109, align 8
  %169 = getelementptr inbounds [0 x double], [0 x double]* %107, i64 0, i64 %indvars.iv
  %170 = getelementptr inbounds [0 x double], [0 x double]* %168, i64 0, i64 %indvars.iv
  %171 = bitcast double* %170 to i64*
  %172 = load i64, i64* %171, align 8
  %173 = bitcast double* %169 to i64*
  store i64 %172, i64* %173, align 8
  %174 = load [0 x %4]*, [0 x %4]** %112, align 8
  %175 = getelementptr inbounds [0 x %4], [0 x %4]* %110, i64 0, i64 %indvars.iv
  %.elt84 = getelementptr inbounds [0 x %4], [0 x %4]* %174, i64 0, i64 %indvars.iv, i32 0
  %176 = bitcast double* %.elt84 to i64*
  %.unpack8598 = load i64, i64* %176, align 8
  %.elt86 = getelementptr inbounds [0 x %4], [0 x %4]* %174, i64 0, i64 %indvars.iv, i32 1
  %177 = bitcast double* %.elt86 to i64*
  %.unpack8797 = load i64, i64* %177, align 8
  %.elt88 = getelementptr inbounds [0 x %4], [0 x %4]* %174, i64 0, i64 %indvars.iv, i32 2
  %178 = bitcast double* %.elt88 to i64*
  %.unpack8996 = load i64, i64* %178, align 8
  %179 = bitcast %4* %175 to i64*
  store i64 %.unpack8598, i64* %179, align 8
  %.repack92 = getelementptr inbounds [0 x %4], [0 x %4]* %110, i64 0, i64 %indvars.iv, i32 1
  %180 = bitcast double* %.repack92 to i64*
  store i64 %.unpack8797, i64* %180, align 8
  %.repack94 = getelementptr inbounds [0 x %4], [0 x %4]* %110, i64 0, i64 %indvars.iv, i32 2
  %181 = bitcast double* %.repack94 to i64*
  store i64 %.unpack8996, i64* %181, align 8
  %182 = load [0 x %4]*, [0 x %4]** %115, align 8
  %183 = getelementptr inbounds [0 x %4], [0 x %4]* %113, i64 0, i64 %indvars.iv
  %.elt99 = getelementptr inbounds [0 x %4], [0 x %4]* %182, i64 0, i64 %indvars.iv, i32 0
  %184 = bitcast double* %.elt99 to i64*
  %.unpack100113 = load i64, i64* %184, align 8
  %.elt101 = getelementptr inbounds [0 x %4], [0 x %4]* %182, i64 0, i64 %indvars.iv, i32 1
  %185 = bitcast double* %.elt101 to i64*
  %.unpack102112 = load i64, i64* %185, align 8
  %.elt103 = getelementptr inbounds [0 x %4], [0 x %4]* %182, i64 0, i64 %indvars.iv, i32 2
  %186 = bitcast double* %.elt103 to i64*
  %.unpack104111 = load i64, i64* %186, align 8
  %187 = bitcast %4* %183 to i64*
  store i64 %.unpack100113, i64* %187, align 8
  %.repack107 = getelementptr inbounds [0 x %4], [0 x %4]* %113, i64 0, i64 %indvars.iv, i32 1
  %188 = bitcast double* %.repack107 to i64*
  store i64 %.unpack102112, i64* %188, align 8
  %.repack109 = getelementptr inbounds [0 x %4], [0 x %4]* %113, i64 0, i64 %indvars.iv, i32 2
  %189 = bitcast double* %.repack109 to i64*
  store i64 %.unpack104111, i64* %189, align 8
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else26.loopexit, label %if_then28

if_else33:                                        ; preds = %if_then34
  %indvars.iv.next154 = add nuw nsw i64 %indvars.iv153, 1
  %exitcond156 = icmp eq i64 %indvars.iv.next154, %wide.trip.count155
  br i1 %exitcond156, label %if_else.loopexit, label %may_unroll_step30.preheader

if_then34:                                        ; preds = %if_then34, %may_unroll_step30.preheader
  %indvars.iv149 = phi i64 [ %indvars.iv.next150, %if_then34 ], [ 0, %may_unroll_step30.preheader ]
  %190 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %44)
  %191 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %46)
  %192 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %46)
  %193 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %46)
  %194 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %192, 1
  %195 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %193, 1
  %196 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %191, 1
  %197 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %190, 1
  %198 = insertvalue %3 undef, %2 %197, 0
  %199 = insertvalue %3 %198, %2 %196, 1
  %200 = insertvalue %3 %199, %2 %194, 2
  %201 = insertvalue %3 %200, %2 %195, 3
  %202 = insertvalue %3 %201, i32 0, 4
  %203 = insertvalue %3 %202, i32 0, 5
  %204 = insertvalue %3 %203, i32 %.cell_capacity_281546, 6
  %205 = insertvalue %3 %204, i32 0, 7
  %206 = insertvalue %3 %205, %2 zeroinitializer, 8
  %207 = insertvalue %3 %206, i32 4, 9
  %indvars.iv.next150 = add nuw nsw i64 %indvars.iv149, 1
  %208 = add nsw i64 %indvars.iv149, %48
  %209 = getelementptr inbounds [0 x %3], [0 x %3]* %39, i64 0, i64 %208
  store %3 %207, %3* %209, align 8
  %exitcond152 = icmp eq i64 %indvars.iv.next150, %wide.trip.count151
  br i1 %exitcond152, label %if_else33, label %if_then34
}

; Function Attrs: nounwind readnone
declare double @llvm.floor.f64(double) #1

declare [0 x i8]* @anydsl_alloc(i32, i64) local_unnamed_addr

define void @cpu_print_grid() local_unnamed_addr {
cpu_print_grid_start:
  %0 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %if_then.preheader, label %if_else

if_then.preheader:                                ; preds = %cpu_print_grid_start
  br label %if_then

if_else.loopexit:                                 ; preds = %if_else4
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %cpu_print_grid_start
  ret void

if_then:                                          ; preds = %if_then.preheader, %if_else4
  %lower157 = phi i32 [ %5, %if_else4 ], [ 0, %if_then.preheader ]
  %3 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %if_then5.preheader, label %if_else4

if_then5.preheader:                               ; preds = %if_then
  br label %if_then5

if_else4.loopexit:                                ; preds = %_cont_cascading_cascading
  br label %if_else4

if_else4:                                         ; preds = %if_else4.loopexit, %if_then
  %5 = add nuw nsw i32 %lower157, 1
  %exitcond176 = icmp eq i32 %5, %1
  br i1 %exitcond176, label %if_else.loopexit, label %if_then

if_then5:                                         ; preds = %if_then5.preheader, %_cont_cascading_cascading.if_then5_crit_edge
  %6 = phi i32 [ %.pre, %_cont_cascading_cascading.if_then5_crit_edge ], [ %3, %if_then5.preheader ]
  %lower2156 = phi i32 [ %41, %_cont_cascading_cascading.if_then5_crit_edge ], [ 0, %if_then5.preheader ]
  %7 = mul nsw i32 %6, %lower157
  %8 = add nsw i32 %7, %lower2156
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 4
  %11 = load i32, i32* %10, align 4
  %12 = icmp sgt i32 %11, 0
  br i1 %12, label %if_then7, label %_cont_cascading_cascading

if_then7:                                         ; preds = %if_then5
  %13 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9
  tail call void @anydsl_print_string([0 x i8]* bitcast ([17 x i8]* @0 to [0 x i8]*))
  %14 = ptrtoint %3* %13 to i64
  tail call void @anydsl_print_i64(i64 %14)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([9 x i8]* @1 to [0 x i8]*))
  tail call void @anydsl_print_i32(i32 %lower157)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @2 to [0 x i8]*))
  tail call void @anydsl_print_i32(i32 %lower2156)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([8 x i8]* @3 to [0 x i8]*))
  %15 = load i32, i32* %10, align 4
  tail call void @anydsl_print_i32(i32 %15)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([12 x i8]* @4 to [0 x i8]*))
  %16 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 6
  %17 = load i32, i32* %16, align 4
  tail call void @anydsl_print_i32(i32 %17)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([11 x i8]* @5 to [0 x i8]*))
  %18 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 5
  %19 = load i32, i32* %18, align 4
  tail call void @anydsl_print_i32(i32 %19)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([22 x i8]* @6 to [0 x i8]*))
  %20 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 7
  %21 = load i32, i32* %20, align 4
  tail call void @anydsl_print_i32(i32 %21)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([16 x i8]* @7 to [0 x i8]*))
  %22 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 9
  %23 = load i32, i32* %22, align 4
  tail call void @anydsl_print_i32(i32 %23)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @8 to [0 x i8]*))
  tail call void @anydsl_print_string([0 x i8]* bitcast ([12 x i8]* @9 to [0 x i8]*))
  %24 = load i32, i32* %10, align 4
  %25 = icmp sgt i32 %24, 0
  br i1 %25, label %if_then88.lr.ph, label %if_else26

if_then88.lr.ph:                                  ; preds = %if_then7
  %26 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 1, i32 1
  %27 = bitcast [0 x i8]** %26 to [0 x %4]**
  %wide.trip.count = zext i32 %24 to i64
  br label %if_then88

if_else26.loopexit:                               ; preds = %if_then88
  br label %if_else26

if_else26:                                        ; preds = %if_else26.loopexit, %if_then7
  tail call void @anydsl_print_string([0 x i8]* bitcast ([9 x i8]* @10 to [0 x i8]*))
  %28 = load i32, i32* %10, align 4
  %29 = icmp sgt i32 %28, 0
  br i1 %29, label %if_then81.lr.ph, label %if_else31

if_then81.lr.ph:                                  ; preds = %if_else26
  %30 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 3, i32 1
  %31 = bitcast [0 x i8]** %30 to [0 x %4]**
  %wide.trip.count161 = zext i32 %28 to i64
  br label %if_then81

if_else31.loopexit:                               ; preds = %if_then81
  br label %if_else31

if_else31:                                        ; preds = %if_else31.loopexit, %if_else26
  tail call void @anydsl_print_string([0 x i8]* bitcast ([13 x i8]* @11 to [0 x i8]*))
  %32 = load i32, i32* %10, align 4
  %33 = icmp sgt i32 %32, 0
  br i1 %33, label %if_then75.lr.ph, label %if_else36

if_then75.lr.ph:                                  ; preds = %if_else31
  %34 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 2, i32 1
  %35 = bitcast [0 x i8]** %34 to [0 x %4]**
  %wide.trip.count165 = zext i32 %32 to i64
  br label %if_then75

if_else36.loopexit:                               ; preds = %if_then75
  br label %if_else36

if_else36:                                        ; preds = %if_else36.loopexit, %if_else31
  tail call void @anydsl_print_string([0 x i8]* bitcast ([11 x i8]* @12 to [0 x i8]*))
  %36 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 8, i32 1
  %37 = bitcast [0 x i8]** %36 to [0 x %5]**
  %38 = load [0 x %5]*, [0 x %5]** %37, align 8
  %39 = load i32, i32* %20, align 4
  %40 = icmp sgt i32 %39, 0
  br i1 %40, label %if_then42.preheader, label %if_else41

if_then42.preheader:                              ; preds = %if_else36
  %wide.trip.count173 = zext i32 %39 to i64
  br label %if_then42

if_else41.loopexit:                               ; preds = %if_else67
  br label %if_else41

if_else41:                                        ; preds = %if_else41.loopexit, %if_else36
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @13 to [0 x i8]*))
  br label %_cont_cascading_cascading

_cont_cascading_cascading:                        ; preds = %if_then5, %if_else41
  %41 = add nuw nsw i32 %lower2156, 1
  %exitcond175 = icmp eq i32 %41, %3
  br i1 %exitcond175, label %if_else4.loopexit, label %_cont_cascading_cascading.if_then5_crit_edge

_cont_cascading_cascading.if_then5_crit_edge:     ; preds = %_cont_cascading_cascading
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then5

if_then42:                                        ; preds = %if_then42.preheader, %if_else67
  %indvars.iv171 = phi i64 [ %indvars.iv.next172, %if_else67 ], [ 0, %if_then42.preheader ]
  tail call void @anydsl_print_string([0 x i8]* bitcast ([7 x i8]* @14 to [0 x i8]*))
  %.unpack.elt = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 0, i64 0
  %.unpack.unpack = load double, double* %.unpack.elt, align 8
  %.unpack.elt102 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 0, i64 1
  %.unpack.unpack103 = load double, double* %.unpack.elt102, align 8
  %.unpack.elt104 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 0, i64 2
  %.unpack.unpack105127128 = load double, double* %.unpack.elt104, align 8
  %.unpack96.elt = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 1, i64 0
  %.unpack96.unpack = load double, double* %.unpack96.elt, align 8
  %.unpack96.elt97 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 1, i64 1
  %.unpack96.unpack98 = load double, double* %.unpack96.elt97, align 8
  %.unpack96.elt99 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 1, i32 1, i64 2
  %.unpack96.unpack100133134 = load double, double* %.unpack96.elt99, align 8
  tail call void @anydsl_print_string([0 x i8]* bitcast ([5 x i8]* @15 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack.unpack)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @16 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack96.unpack)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @17 to [0 x i8]*))
  tail call void @anydsl_print_string([0 x i8]* bitcast ([5 x i8]* @18 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack.unpack103)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @19 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack96.unpack98)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @20 to [0 x i8]*))
  tail call void @anydsl_print_string([0 x i8]* bitcast ([5 x i8]* @21 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack.unpack105127128)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @22 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack96.unpack100133134)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([3 x i8]* @23 to [0 x i8]*))
  tail call void @anydsl_print_string([0 x i8]* bitcast ([16 x i8]* @24 to [0 x i8]*))
  tail call void @anydsl_print_string([0 x i8]* bitcast ([7 x i8]* @25 to [0 x i8]*))
  %42 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 0, i32 0
  %43 = load i32, i32* %42, align 4
  tail call void @anydsl_print_i32(i32 %43)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([12 x i8]* @26 to [0 x i8]*))
  %44 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 0, i32 1
  %45 = load i32, i32* %44, align 4
  tail call void @anydsl_print_i32(i32 %45)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @27 to [0 x i8]*))
  %46 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 0, i32 2, i32 1
  %47 = bitcast [0 x i8]** %46 to [0 x %3*]**
  %48 = load [0 x %3*]*, [0 x %3*]** %47, align 8
  %49 = getelementptr inbounds [0 x %5], [0 x %5]* %38, i64 0, i64 %indvars.iv171, i32 0, i32 3, i32 1
  %50 = bitcast [0 x i8]** %49 to [0 x i32]**
  %51 = load [0 x i32]*, [0 x i32]** %50, align 8
  %52 = load i32, i32* %42, align 4
  %53 = icmp sgt i32 %52, 0
  br i1 %53, label %if_then69.preheader, label %if_else67

if_then69.preheader:                              ; preds = %if_then42
  %wide.trip.count169 = zext i32 %52 to i64
  br label %if_then69

if_else67.loopexit:                               ; preds = %if_then69
  br label %if_else67

if_else67:                                        ; preds = %if_else67.loopexit, %if_then42
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @28 to [0 x i8]*))
  %indvars.iv.next172 = add nuw nsw i64 %indvars.iv171, 1
  %exitcond174 = icmp eq i64 %indvars.iv.next172, %wide.trip.count173
  br i1 %exitcond174, label %if_else41.loopexit, label %if_then42

if_then69:                                        ; preds = %if_then69.preheader, %if_then69
  %indvars.iv167 = phi i64 [ %indvars.iv.next168, %if_then69 ], [ 0, %if_then69.preheader ]
  tail call void @anydsl_print_string([0 x i8]* bitcast ([15 x i8]* @29 to [0 x i8]*))
  %54 = getelementptr inbounds [0 x %3*], [0 x %3*]* %48, i64 0, i64 %indvars.iv167
  %55 = bitcast %3** %54 to i64*
  %56 = load i64, i64* %55, align 8
  tail call void @anydsl_print_i64(i64 %56)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([9 x i8]* @30 to [0 x i8]*))
  %57 = getelementptr inbounds [0 x i32], [0 x i32]* %51, i64 0, i64 %indvars.iv167
  %58 = load i32, i32* %57, align 4
  tail call void @anydsl_print_i32(i32 %58)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @31 to [0 x i8]*))
  %indvars.iv.next168 = add nuw nsw i64 %indvars.iv167, 1
  %exitcond170 = icmp eq i64 %indvars.iv.next168, %wide.trip.count169
  br i1 %exitcond170, label %if_else67.loopexit, label %if_then69

if_then75:                                        ; preds = %if_then75, %if_then75.lr.ph
  %indvars.iv163 = phi i64 [ 0, %if_then75.lr.ph ], [ %indvars.iv.next164, %if_then75 ]
  %59 = load [0 x %4]*, [0 x %4]** %35, align 8
  %.elt = getelementptr inbounds [0 x %4], [0 x %4]* %59, i64 0, i64 %indvars.iv163, i32 0
  %.unpack = load double, double* %.elt, align 8
  %.elt135 = getelementptr inbounds [0 x %4], [0 x %4]* %59, i64 0, i64 %indvars.iv163, i32 1
  %.unpack136 = load double, double* %.elt135, align 8
  %.elt137 = getelementptr inbounds [0 x %4], [0 x %4]* %59, i64 0, i64 %indvars.iv163, i32 2
  %.unpack138 = load double, double* %.elt137, align 8
  tail call void @anydsl_print_f64(double %.unpack)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @32 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack136)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @33 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack138)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @34 to [0 x i8]*))
  %indvars.iv.next164 = add nuw nsw i64 %indvars.iv163, 1
  %exitcond166 = icmp eq i64 %indvars.iv.next164, %wide.trip.count165
  br i1 %exitcond166, label %if_else36.loopexit, label %if_then75

if_then81:                                        ; preds = %if_then81, %if_then81.lr.ph
  %indvars.iv159 = phi i64 [ 0, %if_then81.lr.ph ], [ %indvars.iv.next160, %if_then81 ]
  %60 = load [0 x %4]*, [0 x %4]** %31, align 8
  %.elt139 = getelementptr inbounds [0 x %4], [0 x %4]* %60, i64 0, i64 %indvars.iv159, i32 0
  %.unpack140 = load double, double* %.elt139, align 8
  %.elt141 = getelementptr inbounds [0 x %4], [0 x %4]* %60, i64 0, i64 %indvars.iv159, i32 1
  %.unpack142 = load double, double* %.elt141, align 8
  %.elt143 = getelementptr inbounds [0 x %4], [0 x %4]* %60, i64 0, i64 %indvars.iv159, i32 2
  %.unpack144 = load double, double* %.elt143, align 8
  tail call void @anydsl_print_f64(double %.unpack140)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @32 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack142)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @33 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack144)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @35 to [0 x i8]*))
  %indvars.iv.next160 = add nuw nsw i64 %indvars.iv159, 1
  %exitcond162 = icmp eq i64 %indvars.iv.next160, %wide.trip.count161
  br i1 %exitcond162, label %if_else31.loopexit, label %if_then81

if_then88:                                        ; preds = %if_then88, %if_then88.lr.ph
  %indvars.iv = phi i64 [ 0, %if_then88.lr.ph ], [ %indvars.iv.next, %if_then88 ]
  %61 = load [0 x %4]*, [0 x %4]** %27, align 8
  %.elt145 = getelementptr inbounds [0 x %4], [0 x %4]* %61, i64 0, i64 %indvars.iv, i32 0
  %.unpack146 = load double, double* %.elt145, align 8
  %.elt147 = getelementptr inbounds [0 x %4], [0 x %4]* %61, i64 0, i64 %indvars.iv, i32 1
  %.unpack148 = load double, double* %.elt147, align 8
  %.elt149 = getelementptr inbounds [0 x %4], [0 x %4]* %61, i64 0, i64 %indvars.iv, i32 2
  %.unpack150 = load double, double* %.elt149, align 8
  tail call void @anydsl_print_f64(double %.unpack146)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @32 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack148)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @33 to [0 x i8]*))
  tail call void @anydsl_print_f64(double %.unpack150)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([2 x i8]* @36 to [0 x i8]*))
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else26.loopexit, label %if_then88
}

declare void @anydsl_print_string([0 x i8]*) local_unnamed_addr

declare void @anydsl_print_i64(i64) local_unnamed_addr

declare void @anydsl_print_i32(i32) local_unnamed_addr

declare void @anydsl_print_f64(double) local_unnamed_addr

; Function Attrs: norecurse nounwind readnone
define i64 @get_number_of_flops() local_unnamed_addr #2 {
get_number_of_flops_start:
  ret i64 0
}

define void @cpu_deallocate_grid() local_unnamed_addr {
cpu_deallocate_grid_start:
  %0 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %if_then.preheader, label %if_else

if_then.preheader:                                ; preds = %cpu_deallocate_grid_start
  br label %if_then

if_else.loopexit:                                 ; preds = %if_else4
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %cpu_deallocate_grid_start
  %3 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %4 = extractvalue %2 %3, 0
  %5 = extractvalue %2 %3, 1
  tail call void @anydsl_release(i32 %4, [0 x i8]* %5)
  ret void

if_then:                                          ; preds = %if_then.preheader, %if_else4
  %lower8 = phi i32 [ %8, %if_else4 ], [ 0, %if_then.preheader ]
  %6 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %7 = icmp sgt i32 %6, 0
  br i1 %7, label %if_then5.preheader, label %if_else4

if_then5.preheader:                               ; preds = %if_then
  br label %if_then5

if_else4.loopexit:                                ; preds = %_cont
  br label %if_else4

if_else4:                                         ; preds = %if_else4.loopexit, %if_then
  %8 = add nuw nsw i32 %lower8, 1
  %exitcond11 = icmp eq i32 %8, %1
  br i1 %exitcond11, label %if_else.loopexit, label %if_then

if_then5:                                         ; preds = %if_then5.preheader, %_cont.if_then5_crit_edge
  %9 = phi i32 [ %.pre, %_cont.if_then5_crit_edge ], [ %6, %if_then5.preheader ]
  %lower27 = phi i32 [ %51, %_cont.if_then5_crit_edge ], [ 0, %if_then5.preheader ]
  %10 = mul nsw i32 %9, %lower8
  %11 = add nsw i32 %10, %lower27
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 0
  %14 = load %2, %2* %13, align 8
  %15 = extractvalue %2 %14, 0
  %16 = extractvalue %2 %14, 1
  tail call void @anydsl_release(i32 %15, [0 x i8]* %16)
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 1
  %18 = load %2, %2* %17, align 8
  %19 = extractvalue %2 %18, 0
  %20 = extractvalue %2 %18, 1
  tail call void @anydsl_release(i32 %19, [0 x i8]* %20)
  %21 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 2
  %22 = load %2, %2* %21, align 8
  %23 = extractvalue %2 %22, 0
  %24 = extractvalue %2 %22, 1
  tail call void @anydsl_release(i32 %23, [0 x i8]* %24)
  %25 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 3
  %26 = load %2, %2* %25, align 8
  %27 = extractvalue %2 %26, 0
  %28 = extractvalue %2 %26, 1
  tail call void @anydsl_release(i32 %27, [0 x i8]* %28)
  %29 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 6
  %30 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 4
  store i32 0, i32* %30, align 4
  store i32 0, i32* %29, align 4
  %31 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 8
  %32 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 7
  %33 = load i32, i32* %32, align 4
  %34 = icmp sgt i32 %33, 0
  br i1 %34, label %if_then.i, label %_cont

if_then.i:                                        ; preds = %if_then5
  %35 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %12, i32 8, i32 1
  %36 = bitcast [0 x i8]** %35 to [0 x %5]**
  %37 = load [0 x %5]*, [0 x %5]** %36, align 8
  %wide.trip.count = zext i32 %33 to i64
  br label %if_then2.i

if_else1.i:                                       ; preds = %if_then2.i
  %38 = load %2, %2* %31, align 8
  %39 = extractvalue %2 %38, 0
  %40 = extractvalue %2 %38, 1
  tail call void @anydsl_release(i32 %39, [0 x i8]* %40)
  store i32 0, i32* %32, align 4
  br label %_cont

if_then2.i:                                       ; preds = %if_then2.i, %if_then.i
  %indvars.iv = phi i64 [ 0, %if_then.i ], [ %indvars.iv.next, %if_then2.i ]
  %41 = getelementptr inbounds [0 x %5], [0 x %5]* %37, i64 0, i64 %indvars.iv, i32 0, i32 2
  %42 = load %2, %2* %41, align 8
  %43 = extractvalue %2 %42, 0
  %44 = extractvalue %2 %42, 1
  tail call void @anydsl_release(i32 %43, [0 x i8]* %44)
  %45 = getelementptr inbounds [0 x %5], [0 x %5]* %37, i64 0, i64 %indvars.iv, i32 0, i32 3
  %46 = load %2, %2* %45, align 8
  %47 = extractvalue %2 %46, 0
  %48 = extractvalue %2 %46, 1
  tail call void @anydsl_release(i32 %47, [0 x i8]* %48)
  %49 = getelementptr inbounds [0 x %5], [0 x %5]* %37, i64 0, i64 %indvars.iv, i32 0, i32 0
  store i32 0, i32* %49, align 4
  %50 = getelementptr inbounds [0 x %5], [0 x %5]* %37, i64 0, i64 %indvars.iv, i32 0, i32 1
  store i32 0, i32* %50, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else1.i, label %if_then2.i

_cont:                                            ; preds = %if_else1.i, %if_then5
  %51 = add nuw nsw i32 %lower27, 1
  %exitcond10 = icmp eq i32 %51, %6
  br i1 %exitcond10, label %if_else4.loopexit, label %_cont.if_then5_crit_edge

_cont.if_then5_crit_edge:                         ; preds = %_cont
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then5
}

declare void @anydsl_release(i32, [0 x i8]*) local_unnamed_addr

define i32 @cpu_write_grid_data_to_arrays([0 x double]* nocapture %masses_278391, [0 x %4]* nocapture %positions_278392, [0 x %4]* nocapture %velocities_278393, i32 %size_278394) local_unnamed_addr {
cpu_write_grid_data_to_arrays_start:
  %0 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 5), align 16
  %1 = icmp sgt i32 %0, %size_278394
  br i1 %1, label %if_then14, label %if_else

if_else:                                          ; preds = %cpu_write_grid_data_to_arrays_start
  %2 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %3 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %if_then.preheader, label %if_else1

if_then.preheader:                                ; preds = %if_else
  br label %if_then

if_else1.loopexit:                                ; preds = %if_else6
  br label %if_else1

if_else1:                                         ; preds = %if_else1.loopexit, %if_else, %if_then14
  %merge = phi i32 [ 0, %if_then14 ], [ 0, %if_else ], [ %array_index5.lcssa, %if_else1.loopexit ]
  ret i32 %merge

if_then:                                          ; preds = %if_then.preheader, %if_else6
  %array_index48 = phi i32 [ %array_index5.lcssa, %if_else6 ], [ 0, %if_then.preheader ]
  %lower46 = phi i32 [ %7, %if_else6 ], [ 0, %if_then.preheader ]
  %5 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %6 = icmp sgt i32 %5, 0
  br i1 %6, label %if_then7.preheader, label %if_else6

if_then7.preheader:                               ; preds = %if_then
  br label %if_then7

if_else6.loopexit:                                ; preds = %if_else12
  br label %if_else6

if_else6:                                         ; preds = %if_else6.loopexit, %if_then
  %array_index5.lcssa = phi i32 [ %array_index48, %if_then ], [ %array_index11.lcssa, %if_else6.loopexit ]
  %7 = add nuw nsw i32 %lower46, 1
  %exitcond53 = icmp eq i32 %7, %3
  br i1 %exitcond53, label %if_else1.loopexit, label %if_then

if_then7:                                         ; preds = %if_then7.preheader, %if_else12.if_then7_crit_edge
  %8 = phi i32 [ %.pre, %if_else12.if_then7_crit_edge ], [ %5, %if_then7.preheader ]
  %array_index544 = phi i32 [ %array_index11.lcssa, %if_else12.if_then7_crit_edge ], [ %array_index48, %if_then7.preheader ]
  %lower343 = phi i32 [ %23, %if_else12.if_then7_crit_edge ], [ 0, %if_then7.preheader ]
  %9 = mul nsw i32 %8, %lower46
  %10 = add nsw i32 %9, %lower343
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %11, i32 4
  %13 = load i32, i32* %12, align 4
  %14 = icmp sgt i32 %13, 0
  br i1 %14, label %if_then13.lr.ph, label %if_else12

if_then13.lr.ph:                                  ; preds = %if_then7
  %15 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %11, i32 0, i32 1
  %16 = bitcast [0 x i8]** %15 to [0 x double]**
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %11, i32 1, i32 1
  %18 = bitcast [0 x i8]** %17 to [0 x %4]**
  %19 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %11, i32 2, i32 1
  %20 = bitcast [0 x i8]** %19 to [0 x %4]**
  %21 = sext i32 %array_index544 to i64
  %wide.trip.count = zext i32 %13 to i64
  br label %if_then13

if_else12.loopexit:                               ; preds = %if_then13
  %22 = add i32 %array_index544, %13
  br label %if_else12

if_else12:                                        ; preds = %if_else12.loopexit, %if_then7
  %array_index11.lcssa = phi i32 [ %array_index544, %if_then7 ], [ %22, %if_else12.loopexit ]
  %23 = add nuw nsw i32 %lower343, 1
  %exitcond52 = icmp eq i32 %23, %5
  br i1 %exitcond52, label %if_else6.loopexit, label %if_else12.if_then7_crit_edge

if_else12.if_then7_crit_edge:                     ; preds = %if_else12
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then7

if_then13:                                        ; preds = %if_then13, %if_then13.lr.ph
  %indvars.iv50 = phi i64 [ 0, %if_then13.lr.ph ], [ %indvars.iv.next51, %if_then13 ]
  %indvars.iv = phi i64 [ %21, %if_then13.lr.ph ], [ %indvars.iv.next, %if_then13 ]
  %24 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_278392, i64 0, i64 %indvars.iv
  %25 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_278393, i64 0, i64 %indvars.iv
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %26 = load [0 x double]*, [0 x double]** %16, align 8
  %indvars.iv.next51 = add nuw nsw i64 %indvars.iv50, 1
  %27 = getelementptr inbounds [0 x double], [0 x double]* %masses_278391, i64 0, i64 %indvars.iv
  %28 = getelementptr inbounds [0 x double], [0 x double]* %26, i64 0, i64 %indvars.iv50
  %29 = bitcast double* %28 to i64*
  %30 = load i64, i64* %29, align 8
  %31 = bitcast double* %27 to i64*
  store i64 %30, i64* %31, align 8
  %32 = load [0 x %4]*, [0 x %4]** %18, align 8
  %.elt = getelementptr inbounds [0 x %4], [0 x %4]* %32, i64 0, i64 %indvars.iv50, i32 0
  %33 = bitcast double* %.elt to i64*
  %.unpack27 = load i64, i64* %33, align 8
  %.elt16 = getelementptr inbounds [0 x %4], [0 x %4]* %32, i64 0, i64 %indvars.iv50, i32 1
  %34 = bitcast double* %.elt16 to i64*
  %.unpack1726 = load i64, i64* %34, align 8
  %.elt18 = getelementptr inbounds [0 x %4], [0 x %4]* %32, i64 0, i64 %indvars.iv50, i32 2
  %35 = bitcast double* %.elt18 to i64*
  %.unpack1925 = load i64, i64* %35, align 8
  %36 = bitcast %4* %24 to i64*
  store i64 %.unpack27, i64* %36, align 8
  %.repack21 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_278392, i64 0, i64 %indvars.iv, i32 1
  %37 = bitcast double* %.repack21 to i64*
  store i64 %.unpack1726, i64* %37, align 8
  %.repack23 = getelementptr inbounds [0 x %4], [0 x %4]* %positions_278392, i64 0, i64 %indvars.iv, i32 2
  %38 = bitcast double* %.repack23 to i64*
  store i64 %.unpack1925, i64* %38, align 8
  %39 = load [0 x %4]*, [0 x %4]** %20, align 8
  %.elt28 = getelementptr inbounds [0 x %4], [0 x %4]* %39, i64 0, i64 %indvars.iv50, i32 0
  %40 = bitcast double* %.elt28 to i64*
  %.unpack40 = load i64, i64* %40, align 8
  %.elt29 = getelementptr inbounds [0 x %4], [0 x %4]* %39, i64 0, i64 %indvars.iv50, i32 1
  %41 = bitcast double* %.elt29 to i64*
  %.unpack3039 = load i64, i64* %41, align 8
  %.elt31 = getelementptr inbounds [0 x %4], [0 x %4]* %39, i64 0, i64 %indvars.iv50, i32 2
  %42 = bitcast double* %.elt31 to i64*
  %.unpack3238 = load i64, i64* %42, align 8
  %43 = bitcast %4* %25 to i64*
  store i64 %.unpack40, i64* %43, align 8
  %.repack34 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_278393, i64 0, i64 %indvars.iv, i32 1
  %44 = bitcast double* %.repack34 to i64*
  store i64 %.unpack3039, i64* %44, align 8
  %.repack36 = getelementptr inbounds [0 x %4], [0 x %4]* %velocities_278393, i64 0, i64 %indvars.iv, i32 2
  %45 = bitcast double* %.repack36 to i64*
  store i64 %.unpack3238, i64* %45, align 8
  %exitcond = icmp eq i64 %indvars.iv.next51, %wide.trip.count
  br i1 %exitcond, label %if_else12.loopexit, label %if_then13

if_then14:                                        ; preds = %cpu_write_grid_data_to_arrays_start
  tail call void @anydsl_print_string([0 x i8]* bitcast ([38 x i8]* @37 to [0 x i8]*))
  %46 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 5), align 16
  tail call void @anydsl_print_i32(i32 %46)
  tail call void @anydsl_print_string([0 x i8]* bitcast ([13 x i8]* @38 to [0 x i8]*))
  br label %if_else1
}

define void @cpu_reset_forces() local_unnamed_addr {
cpu_reset_forces_start:
  %parallel_closure = alloca { %2 }, align 8
  %0 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %.fca.0.extract = extractvalue %2 %0, 0
  %.fca.0.gep = getelementptr inbounds { %2 }, { %2 }* %parallel_closure, i64 0, i32 0, i32 0
  store i32 %.fca.0.extract, i32* %.fca.0.gep, align 8
  %.fca.1.extract = extractvalue %2 %0, 1
  %.fca.1.gep = getelementptr inbounds { %2 }, { %2 }* %parallel_closure, i64 0, i32 0, i32 1
  store [0 x i8]* %.fca.1.extract, [0 x i8]** %.fca.1.gep, align 8
  %2 = bitcast { %2 }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %1, i8* nonnull %2, i8* bitcast (void (i8*, i32, i32)* @lambda_281365_parallel_for to i8*))
  ret void
}

; Function Attrs: norecurse nounwind
define void @lambda_281365_parallel_for(i8* nocapture readonly, i32, i32) #3 {
lambda_281365_parallel_for:
  %3 = getelementptr inbounds i8, i8* %0, i64 8
  %4 = bitcast i8* %3 to [0 x %3]**
  %5 = load [0 x %3]*, [0 x %3]** %4, align 8
  %6 = icmp slt i32 %1, %2
  br i1 %6, label %body.preheader, label %exit

body.preheader:                                   ; preds = %lambda_281365_parallel_for
  br label %body

body:                                             ; preds = %body.preheader, %lambda_281365.exit
  %parallel_loop_phi5 = phi i32 [ %21, %lambda_281365.exit ], [ %1, %body.preheader ]
  %7 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %if_then.i.preheader, label %lambda_281365.exit

if_then.i.preheader:                              ; preds = %body
  br label %if_then.i

if_then.i:                                        ; preds = %if_then.i.preheader, %if_else4.i.if_then.i_crit_edge
  %9 = phi i32 [ %.pre, %if_else4.i.if_then.i_crit_edge ], [ %7, %if_then.i.preheader ]
  %lower.i4 = phi i32 [ %18, %if_else4.i.if_then.i_crit_edge ], [ 0, %if_then.i.preheader ]
  %10 = mul nsw i32 %9, %parallel_loop_phi5
  %11 = add nsw i32 %10, %lower.i4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %12, i32 4
  %14 = load i32, i32* %13, align 4
  %15 = icmp sgt i32 %14, 0
  br i1 %15, label %if_then5.i.lr.ph, label %if_else4.i

if_then5.i.lr.ph:                                 ; preds = %if_then.i
  %16 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %12, i32 3, i32 1
  %17 = bitcast [0 x i8]** %16 to [0 x %4]**
  %wide.trip.count = zext i32 %14 to i64
  br label %if_then5.i

if_else4.i.loopexit:                              ; preds = %if_then5.i
  br label %if_else4.i

if_else4.i:                                       ; preds = %if_else4.i.loopexit, %if_then.i
  %18 = add nuw nsw i32 %lower.i4, 1
  %exitcond7 = icmp eq i32 %18, %7
  br i1 %exitcond7, label %lambda_281365.exit.loopexit, label %if_else4.i.if_then.i_crit_edge

if_else4.i.if_then.i_crit_edge:                   ; preds = %if_else4.i
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then.i

if_then5.i:                                       ; preds = %if_then5.i, %if_then5.i.lr.ph
  %indvars.iv = phi i64 [ 0, %if_then5.i.lr.ph ], [ %indvars.iv.next, %if_then5.i ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %19 = load [0 x %4]*, [0 x %4]** %17, align 8
  %.repack = getelementptr inbounds [0 x %4], [0 x %4]* %19, i64 0, i64 %indvars.iv, i32 0
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  %20 = bitcast double* %.repack to i8*
  call void @llvm.memset.p0i8.i64(i8* %20, i8 0, i64 24, i32 8, i1 false)
  br i1 %exitcond, label %if_else4.i.loopexit, label %if_then5.i

lambda_281365.exit.loopexit:                      ; preds = %if_else4.i
  br label %lambda_281365.exit

lambda_281365.exit:                               ; preds = %lambda_281365.exit.loopexit, %body
  %21 = add nsw i32 %parallel_loop_phi5, 1
  %exitcond8 = icmp eq i32 %21, %2
  br i1 %exitcond8, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %lambda_281365.exit
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_281365_parallel_for
  ret void
}

define void @cpu_assemble_neighbor_lists(double %cutoff_distance_278535) local_unnamed_addr {
cpu_assemble_neighbor_lists_start:
  %parallel_closure = alloca { %2, double }, align 8
  %0 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %.fca.0.extract = extractvalue %2 %0, 0
  %.fca.0.gep = getelementptr inbounds { %2, double }, { %2, double }* %parallel_closure, i64 0, i32 0, i32 0
  store i32 %.fca.0.extract, i32* %.fca.0.gep, align 8
  %.fca.1.extract = extractvalue %2 %0, 1
  %.fca.1.gep = getelementptr inbounds { %2, double }, { %2, double }* %parallel_closure, i64 0, i32 0, i32 1
  store [0 x i8]* %.fca.1.extract, [0 x i8]** %.fca.1.gep, align 8
  %parallel_closure.repack1 = getelementptr inbounds { %2, double }, { %2, double }* %parallel_closure, i64 0, i32 1
  store double %cutoff_distance_278535, double* %parallel_closure.repack1, align 8
  %2 = bitcast { %2, double }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %1, i8* nonnull %2, i8* bitcast (void (i8*, i32, i32)* @lambda_278551_parallel_for to i8*))
  ret void
}

define void @lambda_278551_parallel_for(i8* nocapture readonly, i32, i32) {
lambda_278551_parallel_for:
  %.elt = bitcast i8* %0 to %2*
  %.unpack = load %2, %2* %.elt, align 8
  %.elt1 = getelementptr inbounds i8, i8* %0, i64 16
  %3 = bitcast i8* %.elt1 to double*
  %.unpack2 = load double, double* %3, align 8
  %4 = icmp slt i32 %1, %2
  br i1 %4, label %body.preheader, label %exit

body.preheader:                                   ; preds = %lambda_278551_parallel_for
  br label %body

body:                                             ; preds = %body.preheader, %body
  %parallel_loop_phi3 = phi i32 [ %5, %body ], [ %1, %body.preheader ]
  tail call fastcc void @lambda_278551(i32 %parallel_loop_phi3, %2 %.unpack, double %.unpack2)
  %5 = add nsw i32 %parallel_loop_phi3, 1
  %exitcond = icmp eq i32 %5, %2
  br i1 %exitcond, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %body
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_278551_parallel_for
  ret void
}

define internal fastcc void @lambda_278551(i32 %i_278553, %2 %_278555, double %_278556) unnamed_addr {
lambda_278551_start:
  %0 = add nsw i32 %i_278553, 2
  %1 = extractvalue %2 %_278555, 1
  %squared_cutoff_distance = fmul double %_278556, %_278556
  %2 = bitcast [0 x i8]* %1 to [0 x %3]*
  %3 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %if_then.preheader, label %if_else

if_then.preheader:                                ; preds = %lambda_278551_start
  br label %if_then

if_else.loopexit:                                 ; preds = %_cont
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %lambda_278551_start
  ret void

if_then:                                          ; preds = %if_then.preheader, %_cont.if_then_crit_edge
  %5 = phi i32 [ %.pre, %_cont.if_then_crit_edge ], [ %3, %if_then.preheader ]
  %lower402 = phi i32 [ %19, %_cont.if_then_crit_edge ], [ 0, %if_then.preheader ]
  %6 = mul nsw i32 %5, %i_278553
  %7 = add nsw i32 %6, %lower402
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %8, i32 4
  %10 = load i32, i32* %9, align 4
  %11 = icmp sgt i32 %10, 0
  br i1 %11, label %if_then2, label %_cont

if_then2:                                         ; preds = %if_then
  %12 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %8, i32 8, i32 1
  %13 = bitcast [0 x i8]** %12 to [0 x %5]**
  %14 = load [0 x %5]*, [0 x %5]** %13, align 8
  %15 = getelementptr inbounds [0 x %3], [0 x %3]* %2, i64 0, i64 %8, i32 7
  %16 = add nuw nsw i32 %lower402, 2
  %17 = load i32, i32* %15, align 4
  %18 = icmp sgt i32 %17, 0
  br i1 %18, label %if_then7.preheader, label %_cont

if_then7.preheader:                               ; preds = %if_then2
  %wide.trip.count419 = zext i32 %17 to i64
  br label %if_then7

_cont.loopexit:                                   ; preds = %if_else17
  br label %_cont

_cont:                                            ; preds = %_cont.loopexit, %if_then2, %if_then
  %19 = add nuw nsw i32 %lower402, 1
  %exitcond421 = icmp eq i32 %19, %3
  br i1 %exitcond421, label %if_else.loopexit, label %_cont.if_then_crit_edge

_cont.if_then_crit_edge:                          ; preds = %_cont
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then

if_then7:                                         ; preds = %if_then7.preheader, %if_else17
  %indvars.iv417 = phi i64 [ %indvars.iv.next418, %if_else17 ], [ 0, %if_then7.preheader ]
  %indvars.iv = phi i32 [ %indvars.iv.next, %if_else17 ], [ 1, %if_then7.preheader ]
  %20 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 0
  store i32 0, i32* %20, align 4
  %21 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %22 = add nsw i32 %21, -1
  %23 = icmp sgt i32 %22, %i_278553
  %. = select i1 %23, i32 %0, i32 %21
  %24 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %25 = add nsw i32 %24, -1
  %26 = icmp slt i32 %lower402, %25
  %converge13 = select i1 %26, i32 %16, i32 %24
  %27 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 1
  %28 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %29 = icmp sgt i32 %., %i_278553
  br i1 %29, label %may_unroll_step19.preheader.lr.ph, label %if_else17

may_unroll_step19.preheader.lr.ph:                ; preds = %if_then7
  %30 = icmp slt i32 %lower402, %converge13
  %.unpack.elt100 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 0, i64 2
  %.unpack92.elt95 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 1, i64 2
  %.unpack.elt = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 0, i64 0
  %.unpack.elt198 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 0, i64 1
  %31 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 2
  %32 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 3
  %33 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 2, i32 1
  %34 = bitcast [0 x i8]** %33 to [0 x %3*]**
  %35 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 0, i32 3, i32 1
  %36 = bitcast [0 x i8]** %35 to [0 x i32]**
  %.unpack190.elt191 = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 1, i64 1
  %.unpack142.elt = getelementptr inbounds [0 x %5], [0 x %5]* %14, i64 0, i64 %indvars.iv417, i32 1, i32 1, i64 0
  br label %may_unroll_step19.preheader

may_unroll_step19.preheader:                      ; preds = %if_else22, %may_unroll_step19.preheader.lr.ph
  %37 = phi i32 [ 0, %may_unroll_step19.preheader.lr.ph ], [ %38, %if_else22 ]
  %lower15399 = phi i32 [ %i_278553, %may_unroll_step19.preheader.lr.ph ], [ %39, %if_else22 ]
  br i1 %30, label %if_then23.preheader, label %if_else22

if_then23.preheader:                              ; preds = %may_unroll_step19.preheader
  br label %if_then23

if_else17.loopexit:                               ; preds = %if_else22
  br label %if_else17

if_else17:                                        ; preds = %if_else17.loopexit, %if_then7
  %indvars.iv.next418 = add nuw nsw i64 %indvars.iv417, 1
  %indvars.iv.next = add nuw i32 %indvars.iv, 1
  %exitcond420 = icmp eq i64 %indvars.iv.next418, %wide.trip.count419
  br i1 %exitcond420, label %_cont.loopexit, label %if_then7

if_else22.loopexit:                               ; preds = %_cont44
  br label %if_else22

if_else22:                                        ; preds = %if_else22.loopexit, %may_unroll_step19.preheader
  %38 = phi i32 [ %37, %may_unroll_step19.preheader ], [ %74, %if_else22.loopexit ]
  %39 = add nsw i32 %lower15399, 1
  %exitcond416 = icmp eq i32 %39, %.
  br i1 %exitcond416, label %if_else17.loopexit, label %may_unroll_step19.preheader

if_then23:                                        ; preds = %if_then23.preheader, %_cont44
  %40 = phi i32 [ %74, %_cont44 ], [ %37, %if_then23.preheader ]
  %lower20398 = phi i32 [ %75, %_cont44 ], [ %lower402, %if_then23.preheader ]
  %41 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %42 = mul nsw i32 %41, %lower15399
  %43 = add nsw i32 %42, %lower20398
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds [0 x %3], [0 x %3]* %28, i64 0, i64 %44
  %46 = getelementptr inbounds [0 x %3], [0 x %3]* %28, i64 0, i64 %44, i32 7
  %47 = load i32, i32* %46, align 4
  %48 = icmp sgt i32 %47, 0
  br i1 %48, label %if_then25, label %_cont44

if_then25:                                        ; preds = %if_then23
  %49 = mul nsw i32 %41, %i_278553
  %50 = add nsw i32 %49, %lower402
  %51 = icmp eq i32 %43, %50
  %indvars.iv. = select i1 %51, i32 %indvars.iv, i32 0
  %52 = getelementptr inbounds [0 x %3], [0 x %3]* %28, i64 0, i64 %44, i32 8, i32 1
  %53 = bitcast [0 x i8]** %52 to [0 x %5]**
  %54 = load [0 x %5]*, [0 x %5]** %53, align 8
  %.unpack.unpack101 = load double, double* %.unpack.elt100, align 8
  %.unpack108.elt111 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 0, i32 1, i32 1, i64 2
  %.unpack108.unpack112 = load double, double* %.unpack108.elt111, align 8
  %55 = fcmp olt double %.unpack108.unpack112, %.unpack.unpack101
  br i1 %55, label %if_then33, label %if_else30

if_else30:                                        ; preds = %if_then25
  %.unpack.elt118 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 0, i32 1, i32 0, i64 2
  %.unpack.unpack119137140 = load double, double* %.unpack.elt118, align 8
  %.unpack92.unpack96129132 = load double, double* %.unpack92.elt95, align 8
  %56 = fcmp olt double %.unpack92.unpack96129132, %.unpack.unpack119137140
  br i1 %56, label %if_then32, label %while_head36.preheader

if_then32:                                        ; preds = %if_else30
  %57 = fsub double %.unpack.unpack119137140, %.unpack92.unpack96129132
  br label %while_head36.preheader

if_then33:                                        ; preds = %if_then25
  %58 = fsub double %.unpack.unpack101, %.unpack108.unpack112
  br label %while_head36.preheader

while_head36.preheader:                           ; preds = %if_else30, %if_then33, %if_then32
  %.ph391 = phi double [ %57, %if_then32 ], [ %58, %if_then33 ], [ 0.000000e+00, %if_else30 ]
  %59 = add nsw i32 %47, -1
  %60 = icmp slt i32 %indvars.iv., %59
  %61 = fcmp ogt double %.ph391, %_278556
  %or.cond395 = and i1 %61, %60
  br i1 %or.cond395, label %while_body83.lr.ph, label %while_head39.outer.preheader

while_head39.outer.preheader:                     ; preds = %while_head39.outer.preheader.loopexit, %while_head36.preheader
  %.ph.ph = phi i32 [ %indvars.iv., %while_head36.preheader ], [ %62, %while_head39.outer.preheader.loopexit ]
  %.ph390.ph = phi double [ %.ph391, %while_head36.preheader ], [ %.be, %while_head39.outer.preheader.loopexit ]
  br label %while_head39.outer

while_head39.outer.preheader.loopexit:            ; preds = %while_head36.backedge
  %62 = trunc i64 %indvars.iv.next410 to i32
  br label %while_head39.outer.preheader

while_body83.lr.ph:                               ; preds = %while_head36.preheader
  %63 = sext i32 %indvars.iv. to i64
  %64 = sext i32 %59 to i64
  br label %while_body83

while_head39.outer:                               ; preds = %while_head39.outer.backedge, %while_head39.outer.preheader
  %65 = phi i32 [ %40, %while_head39.outer.preheader ], [ %120, %while_head39.outer.backedge ]
  %66 = phi i32 [ %47, %while_head39.outer.preheader ], [ %119, %while_head39.outer.backedge ]
  %.ph = phi i32 [ %.ph.ph, %while_head39.outer.preheader ], [ %123, %while_head39.outer.backedge ]
  %.ph390 = phi double [ %.ph390.ph, %while_head39.outer.preheader ], [ %.ph390.be, %while_head39.outer.backedge ]
  %67 = fcmp olt double %.ph390, %_278556
  %68 = fmul double %.ph390, %.ph390
  %69 = sext i32 %.ph to i64
  br label %while_head39

while_head39:                                     ; preds = %while_head39.outer, %next72
  %70 = phi i32 [ %65, %while_head39.outer ], [ %120, %next72 ]
  %71 = phi i32 [ %66, %while_head39.outer ], [ %119, %next72 ]
  %indvars.iv413 = phi i64 [ %69, %while_head39.outer ], [ %indvars.iv.next414, %next72 ]
  %72 = sext i32 %71 to i64
  %73 = icmp slt i64 %indvars.iv413, %72
  %or.cond374 = and i1 %67, %73
  br i1 %or.cond374, label %while_body, label %_cont44.loopexit

_cont44.loopexit:                                 ; preds = %while_head39
  br label %_cont44

_cont44:                                          ; preds = %_cont44.loopexit, %if_then23
  %74 = phi i32 [ %40, %if_then23 ], [ %70, %_cont44.loopexit ]
  %75 = add nuw nsw i32 %lower20398, 1
  %exitcond415 = icmp eq i32 %75, %converge13
  br i1 %exitcond415, label %if_else22.loopexit, label %if_then23

while_body:                                       ; preds = %while_head39
  %.unpack.unpack = load double, double* %.unpack.elt, align 8
  %.unpack158.elt = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv413, i32 1, i32 1, i64 0
  %.unpack158.unpack = load double, double* %.unpack158.elt, align 8
  %76 = fcmp olt double %.unpack158.unpack, %.unpack.unpack
  br i1 %76, label %if_then48, label %if_else45

if_else45:                                        ; preds = %while_body
  %77 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv413, i32 1, i32 0, i64 0
  %.unpack.unpack165188388 = load double, double* %77, align 8
  %.unpack142.unpack181389 = load double, double* %.unpack142.elt, align 8
  %78 = fcmp olt double %.unpack142.unpack181389, %.unpack.unpack165188388
  br i1 %78, label %if_then47, label %next49

if_then47:                                        ; preds = %if_else45
  %79 = fsub double %.unpack.unpack165188388, %.unpack142.unpack181389
  br label %next49

if_then48:                                        ; preds = %while_body
  %80 = fsub double %.unpack.unpack, %.unpack158.unpack
  br label %next49

next49:                                           ; preds = %if_else45, %if_then48, %if_then47
  %converge50 = phi double [ %80, %if_then48 ], [ %79, %if_then47 ], [ 0.000000e+00, %if_else45 ]
  %.unpack.unpack199 = load double, double* %.unpack.elt198, align 8
  %.unpack204.elt205 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv413, i32 1, i32 1, i64 1
  %.unpack204.unpack206 = load double, double* %.unpack204.elt205, align 8
  %81 = fcmp olt double %.unpack204.unpack206, %.unpack.unpack199
  br i1 %81, label %if_then54, label %if_else51

if_else51:                                        ; preds = %next49
  %.unpack.elt212 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv413, i32 1, i32 0, i64 1
  %.unpack.unpack213238240 = load double, double* %.unpack.elt212, align 8
  %.unpack190.unpack192230232 = load double, double* %.unpack190.elt191, align 8
  %82 = fcmp olt double %.unpack190.unpack192230232, %.unpack.unpack213238240
  br i1 %82, label %if_then53, label %next55

if_then53:                                        ; preds = %if_else51
  %83 = fsub double %.unpack.unpack213238240, %.unpack190.unpack192230232
  br label %next55

if_then54:                                        ; preds = %next49
  %84 = fsub double %.unpack.unpack199, %.unpack204.unpack206
  br label %next55

next55:                                           ; preds = %if_else51, %if_then54, %if_then53
  %converge56 = phi double [ %84, %if_then54 ], [ %83, %if_then53 ], [ 0.000000e+00, %if_else51 ]
  %85 = fmul double %converge56, %converge56
  %86 = fmul double %converge50, %converge50
  %87 = fadd double %86, %85
  %squared_distance = fadd double %68, %87
  %difference = fsub double %squared_cutoff_distance, %squared_distance
  %88 = fcmp ogt double %difference, 0.000000e+00
  br i1 %88, label %if_then58, label %next72

if_then58:                                        ; preds = %next55
  %89 = load i32, i32* %27, align 4
  %90 = icmp eq i32 %70, %89
  br i1 %90, label %if_then60, label %next71

if_then60:                                        ; preds = %if_then58
  %91 = sdiv i32 %70, 10
  %extension = add nsw i32 %91, 1
  %92 = icmp sgt i32 %extension, 4
  %.extension = select i1 %92, i32 %extension, i32 4
  %new_capacity = add nsw i32 %.extension, %70
  %93 = shl nsw i32 %new_capacity, 3
  %94 = sext i32 %93 to i64
  %95 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %94)
  %96 = shl nsw i32 %new_capacity, 2
  %97 = sext i32 %96 to i64
  %98 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %97)
  %99 = load i32, i32* %20, align 4
  %100 = icmp sgt i32 %99, 0
  br i1 %100, label %if_then82.lr.ph, label %if_else70

if_then82.lr.ph:                                  ; preds = %if_then60
  %101 = bitcast [0 x i8]* %95 to [0 x %3*]*
  %102 = bitcast [0 x i8]* %98 to [0 x i32]*
  %wide.trip.count = zext i32 %99 to i64
  br label %if_then82

if_else70.loopexit:                               ; preds = %if_then82
  br label %if_else70

if_else70:                                        ; preds = %if_else70.loopexit, %if_then60
  %103 = load %2, %2* %31, align 8
  %104 = extractvalue %2 %103, 0
  %105 = extractvalue %2 %103, 1
  tail call void @anydsl_release(i32 %104, [0 x i8]* %105)
  %106 = load %2, %2* %32, align 8
  %107 = extractvalue %2 %106, 0
  %108 = extractvalue %2 %106, 1
  tail call void @anydsl_release(i32 %107, [0 x i8]* %108)
  %.unpack308.fca.1.insert = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %95, 1
  %.unpack310.fca.1.insert = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %98, 1
  store i32 %70, i32* %20, align 8
  store i32 %new_capacity, i32* %27, align 4
  store %2 %.unpack308.fca.1.insert, %2* %31, align 8
  store %2 %.unpack310.fca.1.insert, %2* %32, align 8
  br label %next71

next71:                                           ; preds = %if_then58, %if_else70
  %109 = load [0 x %3*]*, [0 x %3*]** %34, align 8
  %110 = sext i32 %70 to i64
  %111 = getelementptr inbounds [0 x %3*], [0 x %3*]* %109, i64 0, i64 %110
  store %3* %45, %3** %111, align 8
  %112 = load i32, i32* %20, align 4
  %113 = load [0 x i32]*, [0 x i32]** %36, align 8
  %114 = sext i32 %112 to i64
  %115 = getelementptr inbounds [0 x i32], [0 x i32]* %113, i64 0, i64 %114
  %116 = trunc i64 %indvars.iv413 to i32
  store i32 %116, i32* %115, align 4
  %117 = load i32, i32* %20, align 4
  %118 = add nsw i32 %117, 1
  store i32 %118, i32* %20, align 4
  %.pre422 = load i32, i32* %46, align 4
  br label %next72

next72:                                           ; preds = %next55, %next71
  %119 = phi i32 [ %71, %next55 ], [ %.pre422, %next71 ]
  %120 = phi i32 [ %70, %next55 ], [ %118, %next71 ]
  %indvars.iv.next414 = add i64 %indvars.iv413, 1
  %121 = sext i32 %119 to i64
  %122 = icmp slt i64 %indvars.iv.next414, %121
  br i1 %122, label %if_then74, label %while_head39

if_then74:                                        ; preds = %next72
  %123 = trunc i64 %indvars.iv.next414 to i32
  %sext = shl i64 %indvars.iv.next414, 32
  %124 = ashr exact i64 %sext, 32
  %.unpack.unpack253 = load double, double* %.unpack.elt100, align 8
  %.unpack256.elt259 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %124, i32 1, i32 1, i64 2
  %.unpack256.unpack260 = load double, double* %.unpack256.elt259, align 8
  %125 = fcmp olt double %.unpack256.unpack260, %.unpack.unpack253
  br i1 %125, label %if_then78, label %if_else75

if_else75:                                        ; preds = %if_then74
  %.unpack242.unpack246289292 = load double, double* %.unpack92.elt95, align 8
  %.unpack.elt266 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %124, i32 1, i32 0, i64 2
  %.unpack.unpack267281284 = load double, double* %.unpack.elt266, align 8
  %126 = fcmp olt double %.unpack242.unpack246289292, %.unpack.unpack267281284
  br i1 %126, label %if_then77, label %while_head39.outer.backedge

if_then77:                                        ; preds = %if_else75
  %127 = fsub double %.unpack.unpack267281284, %.unpack242.unpack246289292
  br label %while_head39.outer.backedge

while_head39.outer.backedge:                      ; preds = %if_then77, %if_then78, %if_else75
  %.ph390.be = phi double [ %127, %if_then77 ], [ %128, %if_then78 ], [ 0.000000e+00, %if_else75 ]
  br label %while_head39.outer

if_then78:                                        ; preds = %if_then74
  %128 = fsub double %.unpack.unpack253, %.unpack256.unpack260
  br label %while_head39.outer.backedge

if_then82:                                        ; preds = %if_then82, %if_then82.lr.ph
  %indvars.iv411 = phi i64 [ 0, %if_then82.lr.ph ], [ %indvars.iv.next412, %if_then82 ]
  %indvars.iv.next412 = add nuw nsw i64 %indvars.iv411, 1
  %129 = load [0 x %3*]*, [0 x %3*]** %34, align 8
  %130 = getelementptr inbounds [0 x %3*], [0 x %3*]* %101, i64 0, i64 %indvars.iv411
  %131 = getelementptr inbounds [0 x %3*], [0 x %3*]* %129, i64 0, i64 %indvars.iv411
  %132 = bitcast %3** %131 to i64*
  %133 = load i64, i64* %132, align 8
  %134 = bitcast %3** %130 to i64*
  store i64 %133, i64* %134, align 8
  %135 = load [0 x i32]*, [0 x i32]** %36, align 8
  %136 = getelementptr inbounds [0 x i32], [0 x i32]* %102, i64 0, i64 %indvars.iv411
  %137 = getelementptr inbounds [0 x i32], [0 x i32]* %135, i64 0, i64 %indvars.iv411
  %138 = load i32, i32* %137, align 4
  store i32 %138, i32* %136, align 4
  %exitcond = icmp eq i64 %indvars.iv.next412, %wide.trip.count
  br i1 %exitcond, label %if_else70.loopexit, label %if_then82

while_body83:                                     ; preds = %while_body83.lr.ph, %while_head36.backedge
  %indvars.iv409 = phi i64 [ %63, %while_body83.lr.ph ], [ %indvars.iv.next410, %while_head36.backedge ]
  %indvars.iv.next410 = add nsw i64 %indvars.iv409, 1
  %.unpack335.elt338 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv.next410, i32 1, i32 1, i64 2
  %.unpack335.unpack339 = load double, double* %.unpack335.elt338, align 8
  %139 = fcmp olt double %.unpack335.unpack339, %.unpack.unpack101
  br i1 %139, label %if_then87, label %if_else84

if_else84:                                        ; preds = %while_body83
  %.unpack333.elt343 = getelementptr inbounds [0 x %5], [0 x %5]* %54, i64 0, i64 %indvars.iv.next410, i32 1, i32 0, i64 2
  %.unpack333.unpack344370373 = load double, double* %.unpack333.elt343, align 8
  %.unpack321.unpack325361364 = load double, double* %.unpack92.elt95, align 8
  %140 = fcmp olt double %.unpack321.unpack325361364, %.unpack333.unpack344370373
  br i1 %140, label %if_then86, label %while_head36.backedge

while_head36.backedge:                            ; preds = %if_else84, %if_then87, %if_then86
  %.be = phi double [ 0.000000e+00, %if_else84 ], [ %144, %if_then87 ], [ %143, %if_then86 ]
  %141 = icmp slt i64 %indvars.iv.next410, %64
  %142 = fcmp ogt double %.be, %_278556
  %or.cond = and i1 %142, %141
  br i1 %or.cond, label %while_body83, label %while_head39.outer.preheader.loopexit

if_then86:                                        ; preds = %if_else84
  %143 = fsub double %.unpack333.unpack344370373, %.unpack321.unpack325361364
  br label %while_head36.backedge

if_then87:                                        ; preds = %while_body83
  %144 = fsub double %.unpack.unpack101, %.unpack335.unpack339
  br label %while_head36.backedge
}

define void @cpu_initialize_clusters(i32 %neighbor_list_capacity_279749) local_unnamed_addr {
cpu_initialize_clusters_start:
  %parallel_closure = alloca { %2, i32 }, align 8
  %0 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %.fca.0.0.extract = extractvalue %2 %0, 0
  %.fca.0.0.gep = getelementptr inbounds { %2, i32 }, { %2, i32 }* %parallel_closure, i64 0, i32 0, i32 0
  store i32 %.fca.0.0.extract, i32* %.fca.0.0.gep, align 8
  %.fca.0.1.extract = extractvalue %2 %0, 1
  %.fca.0.1.gep = getelementptr inbounds { %2, i32 }, { %2, i32 }* %parallel_closure, i64 0, i32 0, i32 1
  store [0 x i8]* %.fca.0.1.extract, [0 x i8]** %.fca.0.1.gep, align 8
  %.fca.1.gep = getelementptr inbounds { %2, i32 }, { %2, i32 }* %parallel_closure, i64 0, i32 1
  store i32 %neighbor_list_capacity_279749, i32* %.fca.1.gep, align 8
  %2 = bitcast { %2, i32 }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %1, i8* nonnull %2, i8* bitcast (void (i8*, i32, i32)* @lambda_279765_parallel_for to i8*))
  ret void
}

define void @lambda_279765_parallel_for(i8* nocapture readonly, i32, i32) {
lambda_279765_parallel_for:
  %3 = bitcast i8* %0 to { %2, i32 }*
  %4 = load { %2, i32 }, { %2, i32 }* %3, align 8
  %5 = extractvalue { %2, i32 } %4, 0
  %6 = extractvalue { %2, i32 } %4, 1
  %7 = icmp slt i32 %1, %2
  br i1 %7, label %body.preheader, label %exit

body.preheader:                                   ; preds = %lambda_279765_parallel_for
  br label %body

body:                                             ; preds = %body.preheader, %body
  %parallel_loop_phi1 = phi i32 [ %8, %body ], [ %1, %body.preheader ]
  tail call fastcc void @lambda_279765(i32 %parallel_loop_phi1, %2 %5, i32 %6)
  %8 = add nsw i32 %parallel_loop_phi1, 1
  %exitcond = icmp eq i32 %8, %2
  br i1 %exitcond, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %body
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_279765_parallel_for
  ret void
}

define internal fastcc void @lambda_279765(i32 %i_279767, %2 %_279769, i32 %_279770) unnamed_addr {
lambda_279765_start:
  %0 = shl nsw i32 %_279770, 2
  %1 = sext i32 %0 to i64
  %2 = shl nsw i32 %_279770, 3
  %3 = extractvalue %2 %_279769, 1
  %4 = bitcast [0 x i8]* %3 to [0 x %3]*
  %5 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %6 = sext i32 %2 to i64
  %aabb_280125.sroa.4 = alloca i64, align 8
  %aabb_280125.sroa.8 = alloca i64, align 8
  %aabb_280125.sroa.16 = alloca i64, align 8
  %aabb_280125.sroa.20 = alloca i64, align 8
  %aabb_279977.sroa.4 = alloca i64, align 8
  %aabb_279977.sroa.8 = alloca i64, align 8
  %aabb_279977.sroa.16 = alloca i64, align 8
  %aabb_279977.sroa.20 = alloca i64, align 8
  %7 = icmp sgt i32 %5, 0
  br i1 %7, label %if_then.lr.ph, label %if_else

if_then.lr.ph:                                    ; preds = %lambda_279765_start
  %8 = bitcast i64* %aabb_279977.sroa.4 to double*
  %9 = bitcast i64* %aabb_279977.sroa.8 to double*
  %10 = bitcast i64* %aabb_279977.sroa.20 to double*
  %11 = bitcast i64* %aabb_279977.sroa.16 to double*
  %12 = bitcast i64* %aabb_280125.sroa.4 to double*
  %13 = bitcast i64* %aabb_280125.sroa.8 to double*
  %14 = bitcast i64* %aabb_280125.sroa.20 to double*
  %15 = bitcast i64* %aabb_280125.sroa.16 to double*
  br label %if_then

if_else.loopexit:                                 ; preds = %_cont_cascading_cascading
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %lambda_279765_start
  ret void

if_then:                                          ; preds = %_cont_cascading_cascading.if_then_crit_edge, %if_then.lr.ph
  %16 = phi i32 [ %5, %if_then.lr.ph ], [ %.pre, %_cont_cascading_cascading.if_then_crit_edge ]
  %lower238 = phi i32 [ 0, %if_then.lr.ph ], [ %148, %_cont_cascading_cascading.if_then_crit_edge ]
  %17 = mul nsw i32 %16, %i_279767
  %18 = add nsw i32 %17, %lower238
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 4
  %21 = load i32, i32* %20, align 4
  %22 = icmp sgt i32 %21, 0
  br i1 %22, label %may_unroll_step3.preheader, label %if_else1

may_unroll_step3.preheader:                       ; preds = %if_then
  %23 = icmp eq i32 %21, 1
  br i1 %23, label %if_else6, label %while_head.preheader.lr.ph

while_head.preheader.lr.ph:                       ; preds = %may_unroll_step3.preheader
  %24 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 1, i32 1
  %25 = bitcast [0 x i8]** %24 to [0 x %4]**
  %26 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 0, i32 1
  %27 = bitcast [0 x i8]** %26 to [0 x double]**
  %28 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 2, i32 1
  %29 = bitcast [0 x i8]** %28 to [0 x %4]**
  br label %and_extra.preheader

if_else1:                                         ; preds = %if_then
  %30 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 8
  %31 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 7
  %32 = load i32, i32* %31, align 4
  %33 = icmp sgt i32 %32, 0
  br i1 %33, label %if_then.i, label %_cont_cascading_cascading

if_then.i:                                        ; preds = %if_else1
  %34 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 8, i32 1
  %35 = bitcast [0 x i8]** %34 to [0 x %5]**
  %36 = load [0 x %5]*, [0 x %5]** %35, align 8
  %wide.trip.count = zext i32 %32 to i64
  br label %if_then2.i

if_else1.i:                                       ; preds = %if_then2.i
  %37 = load %2, %2* %30, align 8
  %38 = extractvalue %2 %37, 0
  %39 = extractvalue %2 %37, 1
  tail call void @anydsl_release(i32 %38, [0 x i8]* %39)
  store i32 0, i32* %31, align 4
  br label %_cont_cascading_cascading

if_then2.i:                                       ; preds = %if_then2.i, %if_then.i
  %indvars.iv = phi i64 [ 0, %if_then.i ], [ %indvars.iv.next, %if_then2.i ]
  %40 = getelementptr inbounds [0 x %5], [0 x %5]* %36, i64 0, i64 %indvars.iv, i32 0, i32 2
  %41 = load %2, %2* %40, align 8
  %42 = extractvalue %2 %41, 0
  %43 = extractvalue %2 %41, 1
  tail call void @anydsl_release(i32 %42, [0 x i8]* %43)
  %44 = getelementptr inbounds [0 x %5], [0 x %5]* %36, i64 0, i64 %indvars.iv, i32 0, i32 3
  %45 = load %2, %2* %44, align 8
  %46 = extractvalue %2 %45, 0
  %47 = extractvalue %2 %45, 1
  tail call void @anydsl_release(i32 %46, [0 x i8]* %47)
  %48 = getelementptr inbounds [0 x %5], [0 x %5]* %36, i64 0, i64 %indvars.iv, i32 0, i32 0
  store i32 0, i32* %48, align 4
  %49 = getelementptr inbounds [0 x %5], [0 x %5]* %36, i64 0, i64 %indvars.iv, i32 0, i32 1
  store i32 0, i32* %49, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else1.i, label %if_then2.i

and_extra.preheader:                              ; preds = %_cont66, %while_head.preheader.lr.ph
  %indvars.iv243 = phi i64 [ 1, %while_head.preheader.lr.ph ], [ %indvars.iv.next244, %_cont66 ]
  %lower4225 = phi i32 [ 1, %while_head.preheader.lr.ph ], [ %191, %_cont66 ]
  br label %and_extra

if_else6.loopexit:                                ; preds = %_cont66
  %.pre274 = load i32, i32* %20, align 4
  br label %if_else6

if_else6:                                         ; preds = %if_else6.loopexit, %may_unroll_step3.preheader
  %50 = phi i32 [ %.pre274, %if_else6.loopexit ], [ 1, %may_unroll_step3.preheader ]
  %51 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 9
  %52 = load i32, i32* %51, align 4
  %nclusters = sdiv i32 %50, %52
  %rest = srem i32 %50, %52
  %53 = icmp sgt i32 %rest, 0
  %54 = zext i1 %53 to i32
  %55 = add nsw i32 %54, %nclusters
  %56 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 8
  %57 = mul nsw i32 %55, %52
  %58 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 5
  %59 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 7
  %padding = sub nsw i32 %57, %50
  store i32 %padding, i32* %58, align 4
  %60 = load i32, i32* %59, align 4
  %61 = icmp eq i32 %55, %60
  br i1 %61, label %cell_allocate_clusters_cont, label %if_then10

if_then10:                                        ; preds = %if_else6
  %62 = icmp sgt i32 %60, 0
  br i1 %62, label %if_then.i69, label %cell_deallocate_clusters_cont

if_then.i69:                                      ; preds = %if_then10
  %63 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 8, i32 1
  %64 = bitcast [0 x i8]** %63 to [0 x %5]**
  %65 = load [0 x %5]*, [0 x %5]** %64, align 8
  %wide.trip.count249 = zext i32 %60 to i64
  br label %if_then2.i73

if_else1.i72:                                     ; preds = %if_then2.i73
  %66 = load %2, %2* %56, align 8
  %67 = extractvalue %2 %66, 0
  %68 = extractvalue %2 %66, 1
  tail call void @anydsl_release(i32 %67, [0 x i8]* %68)
  store i32 0, i32* %59, align 4
  br label %cell_deallocate_clusters_cont

if_then2.i73:                                     ; preds = %if_then2.i73, %if_then.i69
  %indvars.iv247 = phi i64 [ 0, %if_then.i69 ], [ %indvars.iv.next248, %if_then2.i73 ]
  %69 = getelementptr inbounds [0 x %5], [0 x %5]* %65, i64 0, i64 %indvars.iv247, i32 0, i32 2
  %70 = load %2, %2* %69, align 8
  %71 = extractvalue %2 %70, 0
  %72 = extractvalue %2 %70, 1
  tail call void @anydsl_release(i32 %71, [0 x i8]* %72)
  %73 = getelementptr inbounds [0 x %5], [0 x %5]* %65, i64 0, i64 %indvars.iv247, i32 0, i32 3
  %74 = load %2, %2* %73, align 8
  %75 = extractvalue %2 %74, 0
  %76 = extractvalue %2 %74, 1
  tail call void @anydsl_release(i32 %75, [0 x i8]* %76)
  %77 = getelementptr inbounds [0 x %5], [0 x %5]* %65, i64 0, i64 %indvars.iv247, i32 0, i32 0
  store i32 0, i32* %77, align 4
  %78 = getelementptr inbounds [0 x %5], [0 x %5]* %65, i64 0, i64 %indvars.iv247, i32 0, i32 1
  store i32 0, i32* %78, align 4
  %indvars.iv.next248 = add nuw nsw i64 %indvars.iv247, 1
  %exitcond250 = icmp eq i64 %indvars.iv.next248, %wide.trip.count249
  br i1 %exitcond250, label %if_else1.i72, label %if_then2.i73

cell_deallocate_clusters_cont:                    ; preds = %if_else1.i72, %if_then10
  %79 = mul nsw i32 %55, 88
  store i32 %55, i32* %59, align 4
  %80 = sext i32 %79 to i64
  %81 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %80)
  %82 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %81, 1
  %83 = bitcast [0 x i8]* %81 to [0 x %5]*
  store %2 %82, %2* %56, align 8
  %84 = icmp sgt i32 %55, 0
  br i1 %84, label %if_then59.preheader, label %cell_allocate_clusters_contthread-pre-split

if_then59.preheader:                              ; preds = %cell_deallocate_clusters_cont
  %wide.trip.count253 = zext i32 %55 to i64
  br label %if_then59

cell_allocate_clusters_contthread-pre-split.loopexit: ; preds = %if_then59
  br label %cell_allocate_clusters_contthread-pre-split

cell_allocate_clusters_contthread-pre-split:      ; preds = %cell_allocate_clusters_contthread-pre-split.loopexit, %cell_deallocate_clusters_cont
  %.pr = load i32, i32* %59, align 4
  br label %cell_allocate_clusters_cont

cell_allocate_clusters_cont:                      ; preds = %cell_allocate_clusters_contthread-pre-split, %if_else6
  %85 = phi i32 [ %.pr, %cell_allocate_clusters_contthread-pre-split ], [ %60, %if_else6 ]
  %86 = load i32, i32* %51, align 4
  %i = add nsw i32 %85, -1
  %87 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 8, i32 1
  %88 = bitcast [0 x i8]** %87 to [0 x %5]**
  %89 = load [0 x %5]*, [0 x %5]** %88, align 8
  %90 = getelementptr inbounds [0 x %3], [0 x %3]* %4, i64 0, i64 %19, i32 1, i32 1
  %91 = bitcast [0 x i8]** %90 to [0 x %4]**
  %92 = load [0 x %4]*, [0 x %4]** %91, align 8
  %93 = icmp sgt i32 %85, 1
  br i1 %93, label %if_then38.lr.ph, label %if_else18

if_then38.lr.ph:                                  ; preds = %cell_allocate_clusters_cont
  %94 = icmp sgt i32 %86, 1
  %95 = sext i32 %86 to i64
  br i1 %94, label %if_then38.us.preheader, label %if_then38.preheader

if_then38.preheader:                              ; preds = %if_then38.lr.ph
  %wide.trip.count257 = zext i32 %i to i64
  br label %if_then38

if_then38.us.preheader:                           ; preds = %if_then38.lr.ph
  %wide.trip.count262 = zext i32 %86 to i64
  %wide.trip.count266 = zext i32 %i to i64
  br label %if_then38.us

if_then38.us:                                     ; preds = %may_unroll_step39.if_else42_crit_edge.us, %if_then38.us.preheader
  %indvars.iv264 = phi i64 [ 0, %if_then38.us.preheader ], [ %indvars.iv.next265, %may_unroll_step39.if_else42_crit_edge.us ]
  %96 = mul nsw i64 %indvars.iv264, %95
  %97 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %96, i32 2
  %98 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %96, i32 1
  %99 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %96, i32 0
  %100 = load double, double* %99, align 8
  %101 = bitcast double* %98 to i64*
  %102 = load i64, i64* %101, align 8
  store i64 %102, i64* %aabb_279977.sroa.4, align 8
  %103 = bitcast double* %97 to i64*
  %104 = load i64, i64* %103, align 8
  store i64 %104, i64* %aabb_279977.sroa.8, align 8
  store i64 %102, i64* %aabb_279977.sroa.16, align 8
  store i64 %104, i64* %aabb_279977.sroa.20, align 8
  br label %if_then43.us

if_then43.us:                                     ; preds = %_cont58.us, %if_then38.us
  %indvars.iv259 = phi i64 [ 1, %if_then38.us ], [ %indvars.iv.next260, %_cont58.us ]
  %105 = phi double [ %100, %if_then38.us ], [ %113, %_cont58.us ]
  %106 = phi double [ %100, %if_then38.us ], [ %112, %_cont58.us ]
  %107 = add nsw i64 %indvars.iv259, %96
  %108 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %107, i32 0
  %109 = load double, double* %108, align 8
  %110 = fcmp olt double %109, %105
  br i1 %110, label %next48.us, label %if_else44.us

if_else44.us:                                     ; preds = %if_then43.us
  %111 = fcmp olt double %106, %109
  br i1 %111, label %if_then46.us, label %next48.us

if_then46.us:                                     ; preds = %if_else44.us
  br label %next48.us

next48.us:                                        ; preds = %if_then43.us, %if_then46.us, %if_else44.us
  %112 = phi double [ %109, %if_then46.us ], [ %106, %if_else44.us ], [ %106, %if_then43.us ]
  %113 = phi double [ %105, %if_then46.us ], [ %105, %if_else44.us ], [ %109, %if_then43.us ]
  %114 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %107, i32 1
  %115 = load double, double* %114, align 8
  %aabb_279977.sroa.4.0.aabb_279977.sroa.4.8.217.us = load double, double* %8, align 8
  %116 = fcmp olt double %115, %aabb_279977.sroa.4.0.aabb_279977.sroa.4.8.217.us
  br i1 %116, label %next53.sink.split.us, label %if_else49.us

if_else49.us:                                     ; preds = %next48.us
  %aabb_279977.sroa.16.0.aabb_279977.sroa.16.32.218.us = load double, double* %11, align 8
  %117 = fcmp olt double %aabb_279977.sroa.16.0.aabb_279977.sroa.16.32.218.us, %115
  br i1 %117, label %next53.sink.split.us, label %next53.us

next53.sink.split.us:                             ; preds = %if_else49.us, %next48.us
  %.sink208.in.us = phi i64* [ %aabb_279977.sroa.4, %next48.us ], [ %aabb_279977.sroa.16, %if_else49.us ]
  %118 = bitcast i64* %.sink208.in.us to double*
  store double %115, double* %118, align 8
  br label %next53.us

next53.us:                                        ; preds = %next53.sink.split.us, %if_else49.us
  %119 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %107, i32 2
  %120 = load double, double* %119, align 8
  %aabb_279977.sroa.8.0.aabb_279977.sroa.8.16.219.us = load double, double* %9, align 8
  %121 = fcmp olt double %120, %aabb_279977.sroa.8.0.aabb_279977.sroa.8.16.219.us
  br i1 %121, label %_cont58.sink.split.us, label %if_else54.us

if_else54.us:                                     ; preds = %next53.us
  %aabb_279977.sroa.20.0.aabb_279977.sroa.20.40.220.us = load double, double* %10, align 8
  %122 = fcmp olt double %aabb_279977.sroa.20.0.aabb_279977.sroa.20.40.220.us, %120
  br i1 %122, label %_cont58.sink.split.us, label %_cont58.us

_cont58.sink.split.us:                            ; preds = %if_else54.us, %next53.us
  %.sink211.in.us = phi i64* [ %aabb_279977.sroa.8, %next53.us ], [ %aabb_279977.sroa.20, %if_else54.us ]
  %123 = bitcast i64* %.sink211.in.us to double*
  store double %120, double* %123, align 8
  br label %_cont58.us

_cont58.us:                                       ; preds = %_cont58.sink.split.us, %if_else54.us
  %indvars.iv.next260 = add nuw nsw i64 %indvars.iv259, 1
  %exitcond263 = icmp eq i64 %indvars.iv.next260, %wide.trip.count262
  br i1 %exitcond263, label %may_unroll_step39.if_else42_crit_edge.us, label %if_then43.us

may_unroll_step39.if_else42_crit_edge.us:         ; preds = %_cont58.us
  %indvars.iv.next265 = add nuw nsw i64 %indvars.iv264, 1
  %aabb_279977.sroa.4.0.aabb_279977.sroa.4.8..unpack.unpack111129.us = load i64, i64* %aabb_279977.sroa.4, align 8
  %aabb_279977.sroa.8.0.aabb_279977.sroa.8.16..unpack.unpack113128.us = load i64, i64* %aabb_279977.sroa.8, align 8
  %aabb_279977.sroa.16.0.aabb_279977.sroa.16.32..unpack104.unpack106126.us = load i64, i64* %aabb_279977.sroa.16, align 8
  %aabb_279977.sroa.20.0.aabb_279977.sroa.20.40..unpack104.unpack108125.us = load i64, i64* %aabb_279977.sroa.20, align 8
  %124 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 0, i64 0
  store double %113, double* %124, align 8
  %.repack.repack121.us = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 0, i64 1
  %125 = bitcast double* %.repack.repack121.us to i64*
  store i64 %aabb_279977.sroa.4.0.aabb_279977.sroa.4.8..unpack.unpack111129.us, i64* %125, align 8
  %.repack.repack123.us = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 0, i64 2
  %126 = bitcast double* %.repack.repack123.us to i64*
  store i64 %aabb_279977.sroa.8.0.aabb_279977.sroa.8.16..unpack.unpack113128.us, i64* %126, align 8
  %.repack115.repack.us = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 1, i64 0
  store double %112, double* %.repack115.repack.us, align 8
  %.repack115.repack117.us = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 1, i64 1
  %127 = bitcast double* %.repack115.repack117.us to i64*
  store i64 %aabb_279977.sroa.16.0.aabb_279977.sroa.16.32..unpack104.unpack106126.us, i64* %127, align 8
  %.repack115.repack119.us = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv264, i32 1, i32 1, i64 2
  %128 = bitcast double* %.repack115.repack119.us to i64*
  store i64 %aabb_279977.sroa.20.0.aabb_279977.sroa.20.40..unpack104.unpack108125.us, i64* %128, align 8
  %exitcond267 = icmp eq i64 %indvars.iv.next265, %wide.trip.count266
  br i1 %exitcond267, label %if_else18.loopexit, label %if_then38.us

if_else18.loopexit279:                            ; preds = %if_then38
  store i64 %175, i64* %aabb_279977.sroa.4, align 8
  store i64 %177, i64* %aabb_279977.sroa.8, align 8
  store i64 %175, i64* %aabb_279977.sroa.16, align 8
  store i64 %177, i64* %aabb_279977.sroa.20, align 8
  br label %if_else18

if_else18.loopexit:                               ; preds = %may_unroll_step39.if_else42_crit_edge.us
  br label %if_else18

if_else18:                                        ; preds = %if_else18.loopexit, %if_else18.loopexit279, %cell_allocate_clusters_cont
  %129 = load i32, i32* %58, align 4
  %130 = mul nsw i32 %i, %86
  %131 = sext i32 %130 to i64
  %132 = sub nsw i32 %86, %129
  %133 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %131, i32 2
  %134 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %131, i32 1
  %135 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %131, i32 0
  %136 = load double, double* %135, align 8
  %137 = bitcast double* %134 to i64*
  %138 = load i64, i64* %137, align 8
  store i64 %138, i64* %aabb_280125.sroa.4, align 8
  %139 = bitcast double* %133 to i64*
  %140 = load i64, i64* %139, align 8
  store i64 %140, i64* %aabb_280125.sroa.8, align 8
  store i64 %138, i64* %aabb_280125.sroa.16, align 8
  store i64 %140, i64* %aabb_280125.sroa.20, align 8
  %141 = icmp sgt i32 %132, 1
  br i1 %141, label %if_then23.preheader, label %if_else22

if_then23.preheader:                              ; preds = %if_else18
  %wide.trip.count271 = zext i32 %132 to i64
  br label %if_then23

if_else22.loopexit:                               ; preds = %_cont
  %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8..unpack.unpack83101.pre = load i64, i64* %aabb_280125.sroa.4, align 8
  %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16..unpack.unpack85100.pre = load i64, i64* %aabb_280125.sroa.8, align 8
  %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32..unpack76.unpack7898.pre = load i64, i64* %aabb_280125.sroa.16, align 8
  %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40..unpack76.unpack8097.pre = load i64, i64* %aabb_280125.sroa.20, align 8
  br label %if_else22

if_else22:                                        ; preds = %if_else22.loopexit, %if_else18
  %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40..unpack76.unpack8097 = phi i64 [ %140, %if_else18 ], [ %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40..unpack76.unpack8097.pre, %if_else22.loopexit ]
  %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32..unpack76.unpack7898 = phi i64 [ %138, %if_else18 ], [ %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32..unpack76.unpack7898.pre, %if_else22.loopexit ]
  %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16..unpack.unpack85100 = phi i64 [ %140, %if_else18 ], [ %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16..unpack.unpack85100.pre, %if_else22.loopexit ]
  %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8..unpack.unpack83101 = phi i64 [ %138, %if_else18 ], [ %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8..unpack.unpack83101.pre, %if_else22.loopexit ]
  %.lcssa223 = phi double [ %136, %if_else18 ], [ %156, %if_else22.loopexit ]
  %.lcssa222 = phi double [ %136, %if_else18 ], [ %157, %if_else22.loopexit ]
  %142 = sext i32 %i to i64
  %143 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 0, i64 0
  store double %.lcssa222, double* %143, align 8
  %.repack.repack93 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 0, i64 1
  %144 = bitcast double* %.repack.repack93 to i64*
  store i64 %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8..unpack.unpack83101, i64* %144, align 8
  %.repack.repack95 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 0, i64 2
  %145 = bitcast double* %.repack.repack95 to i64*
  store i64 %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16..unpack.unpack85100, i64* %145, align 8
  %.repack87.repack = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 1, i64 0
  store double %.lcssa223, double* %.repack87.repack, align 8
  %.repack87.repack89 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 1, i64 1
  %146 = bitcast double* %.repack87.repack89 to i64*
  store i64 %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32..unpack76.unpack7898, i64* %146, align 8
  %.repack87.repack91 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %142, i32 1, i32 1, i64 2
  %147 = bitcast double* %.repack87.repack91 to i64*
  store i64 %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40..unpack76.unpack8097, i64* %147, align 8
  br label %_cont_cascading_cascading

_cont_cascading_cascading:                        ; preds = %if_else1, %if_else1.i, %if_else22
  %148 = add nuw nsw i32 %lower238, 1
  %exitcond273 = icmp eq i32 %148, %5
  br i1 %exitcond273, label %if_else.loopexit, label %_cont_cascading_cascading.if_then_crit_edge

_cont_cascading_cascading.if_then_crit_edge:      ; preds = %_cont_cascading_cascading
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then

if_then23:                                        ; preds = %if_then23.preheader, %_cont
  %indvars.iv268 = phi i64 [ %indvars.iv.next269, %_cont ], [ 1, %if_then23.preheader ]
  %149 = phi double [ %157, %_cont ], [ %136, %if_then23.preheader ]
  %150 = phi double [ %156, %_cont ], [ %136, %if_then23.preheader ]
  %151 = add nsw i64 %indvars.iv268, %131
  %152 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %151, i32 0
  %153 = load double, double* %152, align 8
  %154 = fcmp olt double %153, %149
  br i1 %154, label %next28, label %if_else24

if_else24:                                        ; preds = %if_then23
  %155 = fcmp olt double %150, %153
  br i1 %155, label %if_then26, label %next28

if_then26:                                        ; preds = %if_else24
  br label %next28

next28:                                           ; preds = %if_then23, %if_else24, %if_then26
  %156 = phi double [ %153, %if_then26 ], [ %150, %if_else24 ], [ %150, %if_then23 ]
  %157 = phi double [ %149, %if_then26 ], [ %149, %if_else24 ], [ %153, %if_then23 ]
  %158 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %151, i32 1
  %159 = load double, double* %158, align 8
  %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8.213 = load double, double* %12, align 8
  %160 = fcmp olt double %159, %aabb_280125.sroa.4.0.aabb_280125.sroa.4.8.213
  br i1 %160, label %next33.sink.split, label %if_else29

if_else29:                                        ; preds = %next28
  %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32.214 = load double, double* %15, align 8
  %161 = fcmp olt double %aabb_280125.sroa.16.0.aabb_280125.sroa.16.32.214, %159
  br i1 %161, label %next33.sink.split, label %next33

next33.sink.split:                                ; preds = %if_else29, %next28
  %.sink202.in = phi i64* [ %aabb_280125.sroa.4, %next28 ], [ %aabb_280125.sroa.16, %if_else29 ]
  %162 = bitcast i64* %.sink202.in to double*
  store double %159, double* %162, align 8
  br label %next33

next33:                                           ; preds = %next33.sink.split, %if_else29
  %163 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %151, i32 2
  %164 = load double, double* %163, align 8
  %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16.215 = load double, double* %13, align 8
  %165 = fcmp olt double %164, %aabb_280125.sroa.8.0.aabb_280125.sroa.8.16.215
  br i1 %165, label %_cont.sink.split, label %if_else34

if_else34:                                        ; preds = %next33
  %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40.216 = load double, double* %14, align 8
  %166 = fcmp olt double %aabb_280125.sroa.20.0.aabb_280125.sroa.20.40.216, %164
  br i1 %166, label %_cont.sink.split, label %_cont

_cont.sink.split:                                 ; preds = %if_else34, %next33
  %.sink205.in = phi i64* [ %aabb_280125.sroa.8, %next33 ], [ %aabb_280125.sroa.20, %if_else34 ]
  %167 = bitcast i64* %.sink205.in to double*
  store double %164, double* %167, align 8
  br label %_cont

_cont:                                            ; preds = %_cont.sink.split, %if_else34
  %indvars.iv.next269 = add nuw nsw i64 %indvars.iv268, 1
  %exitcond272 = icmp eq i64 %indvars.iv.next269, %wide.trip.count271
  br i1 %exitcond272, label %if_else22.loopexit, label %if_then23

if_then38:                                        ; preds = %if_then38, %if_then38.preheader
  %indvars.iv255 = phi i64 [ 0, %if_then38.preheader ], [ %indvars.iv.next256, %if_then38 ]
  %168 = mul nsw i64 %indvars.iv255, %95
  %169 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %168, i32 2
  %170 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %168, i32 1
  %171 = getelementptr inbounds [0 x %4], [0 x %4]* %92, i64 0, i64 %168, i32 0
  %172 = bitcast double* %171 to i64*
  %173 = load i64, i64* %172, align 8
  %174 = bitcast double* %170 to i64*
  %175 = load i64, i64* %174, align 8
  %176 = bitcast double* %169 to i64*
  %177 = load i64, i64* %176, align 8
  %indvars.iv.next256 = add nuw nsw i64 %indvars.iv255, 1
  %178 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 0, i64 0
  %179 = bitcast double* %178 to i64*
  store i64 %173, i64* %179, align 8
  %.repack.repack121 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 0, i64 1
  %180 = bitcast double* %.repack.repack121 to i64*
  store i64 %175, i64* %180, align 8
  %.repack.repack123 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 0, i64 2
  %181 = bitcast double* %.repack.repack123 to i64*
  store i64 %177, i64* %181, align 8
  %.repack115.repack = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 1, i64 0
  %182 = bitcast double* %.repack115.repack to i64*
  store i64 %173, i64* %182, align 8
  %.repack115.repack117 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 1, i64 1
  %183 = bitcast double* %.repack115.repack117 to i64*
  store i64 %175, i64* %183, align 8
  %.repack115.repack119 = getelementptr inbounds [0 x %5], [0 x %5]* %89, i64 0, i64 %indvars.iv255, i32 1, i32 1, i64 2
  %184 = bitcast double* %.repack115.repack119 to i64*
  store i64 %177, i64* %184, align 8
  %exitcond258 = icmp eq i64 %indvars.iv.next256, %wide.trip.count257
  br i1 %exitcond258, label %if_else18.loopexit279, label %if_then38

if_then59:                                        ; preds = %if_then59.preheader, %if_then59
  %indvars.iv251 = phi i64 [ %indvars.iv.next252, %if_then59 ], [ 0, %if_then59.preheader ]
  %185 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %6)
  %186 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %1)
  %187 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %185, 1
  %indvars.iv.next252 = add nuw nsw i64 %indvars.iv251, 1
  %188 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %186, 1
  %.repack = getelementptr inbounds [0 x %5], [0 x %5]* %83, i64 0, i64 %indvars.iv251, i32 0, i32 0
  store i32 0, i32* %.repack, align 8
  %.repack131 = getelementptr inbounds [0 x %5], [0 x %5]* %83, i64 0, i64 %indvars.iv251, i32 0, i32 1
  store i32 %_279770, i32* %.repack131, align 4
  %.repack133 = getelementptr inbounds [0 x %5], [0 x %5]* %83, i64 0, i64 %indvars.iv251, i32 0, i32 2
  store %2 %187, %2* %.repack133, align 8
  %.repack135 = getelementptr inbounds [0 x %5], [0 x %5]* %83, i64 0, i64 %indvars.iv251, i32 0, i32 3
  store %2 %188, %2* %.repack135, align 8
  %exitcond254 = icmp eq i64 %indvars.iv.next252, %wide.trip.count253
  br i1 %exitcond254, label %cell_allocate_clusters_contthread-pre-split.loopexit, label %if_then59

and_extra:                                        ; preds = %and_extra.preheader, %while_body
  %indvars.iv245 = phi i64 [ %indvars.iv243, %and_extra.preheader ], [ %indvars.iv.next246, %while_body ]
  %189 = load [0 x %4]*, [0 x %4]** %25, align 8
  %indvars.iv.next246 = add nsw i64 %indvars.iv245, -1
  %.elt139 = getelementptr inbounds [0 x %4], [0 x %4]* %189, i64 0, i64 %indvars.iv.next246, i32 2
  %.unpack140 = load double, double* %.elt139, align 8
  %.elt143 = getelementptr inbounds [0 x %4], [0 x %4]* %189, i64 0, i64 %indvars.iv245, i32 2
  %.unpack144 = load double, double* %.elt143, align 8
  %190 = fcmp olt double %.unpack144, %.unpack140
  br i1 %190, label %while_body, label %_cont66

_cont66:                                          ; preds = %while_body, %and_extra
  %191 = add nuw nsw i32 %lower4225, 1
  %192 = icmp slt i32 %191, %21
  %indvars.iv.next244 = add nuw nsw i64 %indvars.iv243, 1
  br i1 %192, label %and_extra.preheader, label %if_else6.loopexit

while_body:                                       ; preds = %and_extra
  %193 = load [0 x double]*, [0 x double]** %27, align 8
  %194 = getelementptr inbounds [0 x double], [0 x double]* %193, i64 0, i64 %indvars.iv.next246
  %195 = getelementptr inbounds [0 x double], [0 x double]* %193, i64 0, i64 %indvars.iv245
  %196 = bitcast double* %195 to i64*
  %197 = load i64, i64* %196, align 8
  %198 = bitcast double* %194 to i64*
  %199 = load i64, i64* %198, align 8
  store i64 %199, i64* %196, align 8
  store i64 %197, i64* %198, align 8
  %200 = load [0 x %4]*, [0 x %4]** %25, align 8
  %201 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv.next246
  %202 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv245
  %203 = bitcast %4* %202 to i64*
  %.unpack172 = load i64, i64* %203, align 8
  %.elt145 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv245, i32 1
  %204 = bitcast double* %.elt145 to i64*
  %.unpack146171 = load i64, i64* %204, align 8
  %.elt147 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv245, i32 2
  %205 = bitcast double* %.elt147 to i64*
  %.unpack148170 = load i64, i64* %205, align 8
  %206 = bitcast %4* %201 to i64*
  %.unpack150163 = load i64, i64* %206, align 8
  %.elt151 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv.next246, i32 1
  %207 = bitcast double* %.elt151 to i64*
  %.unpack152162 = load i64, i64* %207, align 8
  %.elt153 = getelementptr inbounds [0 x %4], [0 x %4]* %200, i64 0, i64 %indvars.iv.next246, i32 2
  %208 = bitcast double* %.elt153 to i64*
  %.unpack154161 = load i64, i64* %208, align 8
  store i64 %.unpack150163, i64* %203, align 8
  store i64 %.unpack152162, i64* %204, align 8
  store i64 %.unpack154161, i64* %205, align 8
  store i64 %.unpack172, i64* %206, align 8
  store i64 %.unpack146171, i64* %207, align 8
  store i64 %.unpack148170, i64* %208, align 8
  %209 = load [0 x %4]*, [0 x %4]** %29, align 8
  %210 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv.next246
  %211 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv245
  %212 = bitcast %4* %211 to i64*
  %.unpack200 = load i64, i64* %212, align 8
  %.elt173 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv245, i32 1
  %213 = bitcast double* %.elt173 to i64*
  %.unpack174199 = load i64, i64* %213, align 8
  %.elt175 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv245, i32 2
  %214 = bitcast double* %.elt175 to i64*
  %.unpack176198 = load i64, i64* %214, align 8
  %215 = bitcast %4* %210 to i64*
  %.unpack178191 = load i64, i64* %215, align 8
  %.elt179 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv.next246, i32 1
  %216 = bitcast double* %.elt179 to i64*
  %.unpack180190 = load i64, i64* %216, align 8
  %.elt181 = getelementptr inbounds [0 x %4], [0 x %4]* %209, i64 0, i64 %indvars.iv.next246, i32 2
  %217 = bitcast double* %.elt181 to i64*
  %.unpack182189 = load i64, i64* %217, align 8
  store i64 %.unpack178191, i64* %212, align 8
  store i64 %.unpack180190, i64* %213, align 8
  store i64 %.unpack182189, i64* %214, align 8
  store i64 %.unpack200, i64* %215, align 8
  store i64 %.unpack174199, i64* %216, align 8
  store i64 %.unpack176198, i64* %217, align 8
  %218 = icmp sgt i64 %indvars.iv245, 1
  br i1 %218, label %and_extra, label %_cont66
}

define void @cpu_redistribute_particles() local_unnamed_addr {
cpu_redistribute_particles_start:
  %0 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %if_then.preheader, label %if_else

if_then.preheader:                                ; preds = %cpu_redistribute_particles_start
  br label %if_then

if_else.loopexit:                                 ; preds = %if_else4
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %cpu_redistribute_particles_start
  ret void

if_then:                                          ; preds = %if_then.preheader, %if_else4
  %lower249 = phi i32 [ %5, %if_else4 ], [ 0, %if_then.preheader ]
  %3 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %if_then5.preheader, label %if_else4

if_then5.preheader:                               ; preds = %if_then
  br label %if_then5

if_else4.loopexit:                                ; preds = %next
  br label %if_else4

if_else4:                                         ; preds = %if_else4.loopexit, %if_then
  %5 = add nuw nsw i32 %lower249, 1
  %exitcond260 = icmp eq i32 %5, %1
  br i1 %exitcond260, label %if_else.loopexit, label %if_then

if_then5:                                         ; preds = %if_then5.preheader, %next.if_then5_crit_edge
  %6 = phi i32 [ %.pre, %next.if_then5_crit_edge ], [ %3, %if_then5.preheader ]
  %lower2246 = phi i32 [ %20, %next.if_then5_crit_edge ], [ 0, %if_then5.preheader ]
  %7 = mul nsw i32 %6, %lower249
  %8 = add nsw i32 %7, %lower2246
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 4
  %11 = load i32, i32* %10, align 4
  %12 = icmp sgt i32 %11, 0
  br i1 %12, label %while_body.lr.ph.lr.ph, label %next

while_body.lr.ph.lr.ph:                           ; preds = %if_then5
  %13 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 1, i32 1
  %14 = bitcast [0 x i8]** %13 to [0 x %4]**
  %15 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 0, i32 1
  %16 = bitcast [0 x i8]** %15 to [0 x double]**
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 2, i32 1
  %18 = bitcast [0 x i8]** %17 to [0 x %4]**
  br label %while_body.lr.ph

while_body.lr.ph:                                 ; preds = %while_body.lr.ph.lr.ph, %if_else17
  %indvars.iv257 = phi i64 [ 0, %while_body.lr.ph.lr.ph ], [ %indvars.iv.next258, %if_else17 ]
  %19 = phi i32 [ %11, %while_body.lr.ph.lr.ph ], [ %21, %if_else17 ]
  br label %while_body

next.loopexit:                                    ; preds = %while_head.backedge
  br label %next

next.loopexit266:                                 ; preds = %if_else17
  br label %next

next:                                             ; preds = %next.loopexit266, %next.loopexit, %if_then5
  %20 = add nuw nsw i32 %lower2246, 1
  %exitcond259 = icmp eq i32 %20, %3
  br i1 %exitcond259, label %if_else4.loopexit, label %next.if_then5_crit_edge

next.if_then5_crit_edge:                          ; preds = %next
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then5

while_body:                                       ; preds = %while_body.lr.ph, %while_head.backedge
  %21 = phi i32 [ %19, %while_body.lr.ph ], [ %221, %while_head.backedge ]
  %22 = load [0 x %4]*, [0 x %4]** %14, align 8
  %.elt = getelementptr inbounds [0 x %4], [0 x %4]* %22, i64 0, i64 %indvars.iv257, i32 0
  %.unpack = load double, double* %.elt, align 8
  %.elt42 = getelementptr inbounds [0 x %4], [0 x %4]* %22, i64 0, i64 %indvars.iv257, i32 1
  %.unpack43 = load double, double* %.elt42, align 8
  %.elt44 = getelementptr inbounds [0 x %4], [0 x %4]* %22, i64 0, i64 %indvars.iv257, i32 2
  %.unpack45 = load double, double* %.elt44, align 8
  %23 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 0), align 16
  %24 = fcmp olt double %23, %.unpack
  %25 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 0), align 8
  %26 = fcmp olt double %.unpack, %25
  %or.cond219 = and i1 %24, %26
  %27 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 1), align 8
  %28 = fcmp olt double %27, %.unpack43
  %or.cond221 = and i1 %or.cond219, %28
  %29 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 1), align 8
  %30 = fcmp olt double %.unpack43, %29
  %or.cond223 = and i1 %or.cond221, %30
  %31 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 0, i64 2), align 16
  %32 = fcmp olt double %31, %.unpack45
  %or.cond225 = and i1 %or.cond223, %32
  %33 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 0, i32 1, i64 2), align 8
  %34 = fcmp olt double %.unpack45, %33
  %or.cond227 = and i1 %or.cond225, %34
  br i1 %or.cond227, label %if_then14, label %if_else13

if_else13:                                        ; preds = %while_body
  %35 = add nsw i32 %21, -1
  %36 = load [0 x double]*, [0 x double]** %16, align 8
  %37 = sext i32 %35 to i64
  %38 = getelementptr inbounds [0 x double], [0 x double]* %36, i64 0, i64 %37
  %39 = getelementptr inbounds [0 x double], [0 x double]* %36, i64 0, i64 %indvars.iv257
  %40 = bitcast double* %39 to i64*
  %41 = load i64, i64* %40, align 8
  %42 = bitcast double* %38 to i64*
  %43 = load i64, i64* %42, align 8
  store i64 %43, i64* %40, align 8
  store i64 %41, i64* %42, align 8
  %44 = load [0 x %4]*, [0 x %4]** %14, align 8
  %45 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %37
  %46 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %indvars.iv257
  %47 = bitcast %4* %46 to i64*
  %.unpack4773 = load i64, i64* %47, align 8
  %.elt48 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %indvars.iv257, i32 1
  %48 = bitcast double* %.elt48 to i64*
  %.unpack4972 = load i64, i64* %48, align 8
  %.elt50 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %indvars.iv257, i32 2
  %49 = bitcast double* %.elt50 to i64*
  %.unpack5171 = load i64, i64* %49, align 8
  %50 = bitcast %4* %45 to i64*
  %.unpack5365 = load i64, i64* %50, align 8
  %.elt54 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %37, i32 1
  %51 = bitcast double* %.elt54 to i64*
  %.unpack5564 = load i64, i64* %51, align 8
  %.elt56 = getelementptr inbounds [0 x %4], [0 x %4]* %44, i64 0, i64 %37, i32 2
  %52 = bitcast double* %.elt56 to i64*
  %.unpack5763 = load i64, i64* %52, align 8
  store i64 %.unpack5365, i64* %47, align 8
  store i64 %.unpack5564, i64* %48, align 8
  store i64 %.unpack5763, i64* %49, align 8
  store i64 %.unpack4773, i64* %50, align 8
  store i64 %.unpack4972, i64* %51, align 8
  store i64 %.unpack5171, i64* %52, align 8
  %53 = load [0 x %4]*, [0 x %4]** %18, align 8
  %54 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %37
  %55 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %indvars.iv257
  %56 = bitcast %4* %55 to i64*
  %.unpack75101 = load i64, i64* %56, align 8
  %.elt76 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %indvars.iv257, i32 1
  %57 = bitcast double* %.elt76 to i64*
  %.unpack77100 = load i64, i64* %57, align 8
  %.elt78 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %indvars.iv257, i32 2
  %58 = bitcast double* %.elt78 to i64*
  %.unpack7999 = load i64, i64* %58, align 8
  %59 = bitcast %4* %54 to i64*
  %.unpack8193 = load i64, i64* %59, align 8
  %.elt82 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %37, i32 1
  %60 = bitcast double* %.elt82 to i64*
  %.unpack8392 = load i64, i64* %60, align 8
  %.elt84 = getelementptr inbounds [0 x %4], [0 x %4]* %53, i64 0, i64 %37, i32 2
  %61 = bitcast double* %.elt84 to i64*
  %.unpack8591 = load i64, i64* %61, align 8
  store i64 %.unpack8193, i64* %56, align 8
  store i64 %.unpack8392, i64* %57, align 8
  store i64 %.unpack8591, i64* %58, align 8
  store i64 %.unpack75101, i64* %59, align 8
  store i64 %.unpack77100, i64* %60, align 8
  store i64 %.unpack7999, i64* %61, align 8
  br label %while_head.backedge

if_then14:                                        ; preds = %while_body
  %62 = load double, double* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 3), align 8
  %63 = fsub double %.unpack, %23
  %64 = fdiv double %63, %62
  %65 = tail call double @llvm.floor.f64(double %64)
  %66 = fsub double %.unpack43, %27
  %67 = fdiv double %66, %62
  %68 = tail call double @llvm.floor.f64(double %67)
  %69 = fptosi double %65 to i32
  %70 = fptosi double %68 to i32
  %71 = icmp eq i32 %69, %lower249
  %72 = icmp eq i32 %70, %lower2246
  %or.cond = and i1 %71, %72
  br i1 %or.cond, label %if_else17, label %if_then19

if_else17:                                        ; preds = %if_then14
  %indvars.iv.next258 = add nuw i64 %indvars.iv257, 1
  %73 = sext i32 %21 to i64
  %74 = icmp slt i64 %indvars.iv.next258, %73
  br i1 %74, label %while_body.lr.ph, label %next.loopexit266

if_then19:                                        ; preds = %if_then14
  %75 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %76 = mul nsw i32 %75, %69
  %77 = add nsw i32 %76, %70
  %78 = sext i32 %77 to i64
  %79 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78
  %80 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 6
  %81 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 4
  %82 = load i32, i32* %81, align 4
  %83 = load i32, i32* %80, align 4
  %84 = icmp sgt i32 %83, %82
  br i1 %84, label %if_else20, label %if_then21

if_else20:                                        ; preds = %if_then19
  %85 = add nsw i32 %82, 1
  store i32 %85, i32* %81, align 4
  br label %next35

if_then21:                                        ; preds = %if_then19
  %86 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 9
  %87 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 7
  %88 = add nsw i32 %82, 5
  %89 = load i32, i32* %87, align 4
  %90 = load i32, i32* %86, align 4
  %91 = sdiv i32 %89, 10
  %92 = add nsw i32 %91, 1
  %93 = mul nsw i32 %92, %90
  %new_capacity = add nsw i32 %93, %83
  %94 = icmp slt i32 %new_capacity, %88
  %.new_capacity = select i1 %94, i32 %88, i32 %new_capacity
  %95 = shl nsw i32 %.new_capacity, 3
  %96 = sext i32 %95 to i64
  %97 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %96)
  %98 = mul nsw i32 %.new_capacity, 24
  %99 = sext i32 %98 to i64
  %100 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %99)
  %101 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %99)
  %102 = tail call [0 x i8]* @anydsl_alloc(i32 0, i64 %99)
  %103 = add nsw i32 %82, 1
  %104 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %102, 1
  %105 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %100, 1
  %106 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %97, 1
  %107 = insertvalue %2 { i32 0, [0 x i8]* undef }, [0 x i8]* %101, 1
  %108 = insertvalue %3 undef, %2 %106, 0
  %109 = insertvalue %3 %108, %2 %105, 1
  %110 = insertvalue %3 %109, %2 %107, 2
  %111 = insertvalue %3 %110, %2 %104, 3
  %112 = insertvalue %3 %111, %2 zeroinitializer, 8
  %113 = load i32, i32* %81, align 4
  %114 = icmp sgt i32 %113, 0
  br i1 %114, label %if_then41.lr.ph, label %if_else34

if_then41.lr.ph:                                  ; preds = %if_then21
  %115 = bitcast [0 x i8]* %97 to [0 x double]*
  %116 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 0, i32 1
  %117 = bitcast [0 x i8]** %116 to [0 x double]**
  %118 = bitcast [0 x i8]* %100 to [0 x %4]*
  %119 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 1, i32 1
  %120 = bitcast [0 x i8]** %119 to [0 x %4]**
  %121 = bitcast [0 x i8]* %101 to [0 x %4]*
  %122 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 2, i32 1
  %123 = bitcast [0 x i8]** %122 to [0 x %4]**
  %wide.trip.count = zext i32 %113 to i64
  br label %if_then41

if_else34.loopexit:                               ; preds = %if_then41
  br label %if_else34

if_else34:                                        ; preds = %if_else34.loopexit, %if_then21
  %124 = getelementptr inbounds %3, %3* %79, i64 0, i32 0
  %125 = load %2, %2* %124, align 8
  %126 = extractvalue %2 %125, 0
  %127 = extractvalue %2 %125, 1
  tail call void @anydsl_release(i32 %126, [0 x i8]* %127)
  %128 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 1
  %129 = load %2, %2* %128, align 8
  %130 = extractvalue %2 %129, 0
  %131 = extractvalue %2 %129, 1
  tail call void @anydsl_release(i32 %130, [0 x i8]* %131)
  %132 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 2
  %133 = load %2, %2* %132, align 8
  %134 = extractvalue %2 %133, 0
  %135 = extractvalue %2 %133, 1
  tail call void @anydsl_release(i32 %134, [0 x i8]* %135)
  %136 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 3
  %137 = load %2, %2* %136, align 8
  %138 = extractvalue %2 %137, 0
  %139 = extractvalue %2 %137, 1
  tail call void @anydsl_release(i32 %138, [0 x i8]* %139)
  store i32 0, i32* %81, align 4
  store i32 0, i32* %80, align 4
  %140 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 8
  %141 = load i32, i32* %87, align 4
  %142 = icmp sgt i32 %141, 0
  br i1 %142, label %if_then.i, label %deallocate_cell_cont

if_then.i:                                        ; preds = %if_else34
  %143 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 8, i32 1
  %144 = bitcast [0 x i8]** %143 to [0 x %5]**
  %145 = load [0 x %5]*, [0 x %5]** %144, align 8
  %wide.trip.count255 = zext i32 %141 to i64
  br label %if_then2.i

if_else1.i:                                       ; preds = %if_then2.i
  %146 = load %2, %2* %140, align 8
  %147 = extractvalue %2 %146, 0
  %148 = extractvalue %2 %146, 1
  tail call void @anydsl_release(i32 %147, [0 x i8]* %148)
  store i32 0, i32* %87, align 4
  br label %deallocate_cell_cont

if_then2.i:                                       ; preds = %if_then2.i, %if_then.i
  %indvars.iv253 = phi i64 [ 0, %if_then.i ], [ %indvars.iv.next254, %if_then2.i ]
  %149 = getelementptr inbounds [0 x %5], [0 x %5]* %145, i64 0, i64 %indvars.iv253, i32 0, i32 2
  %150 = load %2, %2* %149, align 8
  %151 = extractvalue %2 %150, 0
  %152 = extractvalue %2 %150, 1
  tail call void @anydsl_release(i32 %151, [0 x i8]* %152)
  %153 = getelementptr inbounds [0 x %5], [0 x %5]* %145, i64 0, i64 %indvars.iv253, i32 0, i32 3
  %154 = load %2, %2* %153, align 8
  %155 = extractvalue %2 %154, 0
  %156 = extractvalue %2 %154, 1
  tail call void @anydsl_release(i32 %155, [0 x i8]* %156)
  %157 = getelementptr inbounds [0 x %5], [0 x %5]* %145, i64 0, i64 %indvars.iv253, i32 0, i32 0
  store i32 0, i32* %157, align 4
  %158 = getelementptr inbounds [0 x %5], [0 x %5]* %145, i64 0, i64 %indvars.iv253, i32 0, i32 1
  store i32 0, i32* %158, align 4
  %indvars.iv.next254 = add nuw nsw i64 %indvars.iv253, 1
  %exitcond256 = icmp eq i64 %indvars.iv.next254, %wide.trip.count255
  br i1 %exitcond256, label %if_else1.i, label %if_then2.i

deallocate_cell_cont:                             ; preds = %if_else1.i, %if_else34
  %.fca.4.insert = insertvalue %3 %112, i32 %103, 4
  %.fca.5.insert = insertvalue %3 %.fca.4.insert, i32 0, 5
  %.fca.6.insert = insertvalue %3 %.fca.5.insert, i32 %.new_capacity, 6
  %.fca.7.insert = insertvalue %3 %.fca.6.insert, i32 0, 7
  %.fca.8.0.insert = insertvalue %3 %.fca.7.insert, i32 0, 8, 0
  %.fca.8.1.insert = insertvalue %3 %.fca.8.0.insert, [0 x i8]* null, 8, 1
  %.fca.9.insert = insertvalue %3 %.fca.8.1.insert, i32 %90, 9
  store %3 %.fca.9.insert, %3* %79, align 8
  %.pre261 = load i32, i32* %81, align 4
  br label %next35

next35:                                           ; preds = %deallocate_cell_cont, %if_else20
  %159 = phi i32 [ %.pre261, %deallocate_cell_cont ], [ %85, %if_else20 ]
  %160 = load i32, i32* %10, align 4
  %src_last = add nsw i32 %160, -1
  %161 = sext i32 %src_last to i64
  %162 = icmp slt i64 %indvars.iv257, %161
  %dest_last = add nsw i32 %159, -1
  %163 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 0, i32 1
  %164 = bitcast [0 x i8]** %163 to [0 x double]**
  %165 = load [0 x double]*, [0 x double]** %164, align 8
  %166 = load [0 x double]*, [0 x double]** %16, align 8
  %167 = sext i32 %dest_last to i64
  %168 = getelementptr inbounds [0 x double], [0 x double]* %165, i64 0, i64 %167
  %169 = getelementptr inbounds [0 x double], [0 x double]* %166, i64 0, i64 %indvars.iv257
  %170 = bitcast double* %169 to i64*
  %171 = load i64, i64* %170, align 8
  %172 = bitcast double* %168 to i64*
  store i64 %171, i64* %172, align 8
  %173 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 1, i32 1
  %174 = bitcast [0 x i8]** %173 to [0 x %4]**
  %175 = load [0 x %4]*, [0 x %4]** %174, align 8
  %176 = load [0 x %4]*, [0 x %4]** %14, align 8
  %177 = getelementptr inbounds [0 x %4], [0 x %4]* %175, i64 0, i64 %167
  %.elt102 = getelementptr inbounds [0 x %4], [0 x %4]* %176, i64 0, i64 %indvars.iv257, i32 0
  %178 = bitcast double* %.elt102 to i64*
  %.unpack103115 = load i64, i64* %178, align 8
  %.elt104 = getelementptr inbounds [0 x %4], [0 x %4]* %176, i64 0, i64 %indvars.iv257, i32 1
  %179 = bitcast double* %.elt104 to i64*
  %.unpack105114 = load i64, i64* %179, align 8
  %.elt106 = getelementptr inbounds [0 x %4], [0 x %4]* %176, i64 0, i64 %indvars.iv257, i32 2
  %180 = bitcast double* %.elt106 to i64*
  %.unpack107113 = load i64, i64* %180, align 8
  %181 = bitcast %4* %177 to i64*
  store i64 %.unpack103115, i64* %181, align 8
  %.repack109 = getelementptr inbounds [0 x %4], [0 x %4]* %175, i64 0, i64 %167, i32 1
  %182 = bitcast double* %.repack109 to i64*
  store i64 %.unpack105114, i64* %182, align 8
  %.repack111 = getelementptr inbounds [0 x %4], [0 x %4]* %175, i64 0, i64 %167, i32 2
  %183 = bitcast double* %.repack111 to i64*
  store i64 %.unpack107113, i64* %183, align 8
  %184 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %78, i32 2, i32 1
  %185 = bitcast [0 x i8]** %184 to [0 x %4]**
  %186 = load [0 x %4]*, [0 x %4]** %185, align 8
  %187 = load [0 x %4]*, [0 x %4]** %18, align 8
  %188 = getelementptr inbounds [0 x %4], [0 x %4]* %186, i64 0, i64 %167
  %.elt116 = getelementptr inbounds [0 x %4], [0 x %4]* %187, i64 0, i64 %indvars.iv257, i32 0
  %189 = bitcast double* %.elt116 to i64*
  %.unpack117129 = load i64, i64* %189, align 8
  %.elt118 = getelementptr inbounds [0 x %4], [0 x %4]* %187, i64 0, i64 %indvars.iv257, i32 1
  %190 = bitcast double* %.elt118 to i64*
  %.unpack119128 = load i64, i64* %190, align 8
  %.elt120 = getelementptr inbounds [0 x %4], [0 x %4]* %187, i64 0, i64 %indvars.iv257, i32 2
  %191 = bitcast double* %.elt120 to i64*
  %.unpack121127 = load i64, i64* %191, align 8
  %192 = bitcast %4* %188 to i64*
  store i64 %.unpack117129, i64* %192, align 8
  %.repack123 = getelementptr inbounds [0 x %4], [0 x %4]* %186, i64 0, i64 %167, i32 1
  %193 = bitcast double* %.repack123 to i64*
  store i64 %.unpack119128, i64* %193, align 8
  %.repack125 = getelementptr inbounds [0 x %4], [0 x %4]* %186, i64 0, i64 %167, i32 2
  %194 = bitcast double* %.repack125 to i64*
  store i64 %.unpack121127, i64* %194, align 8
  br i1 %162, label %if_then37, label %while_head.backedge

if_then37:                                        ; preds = %next35
  %195 = load [0 x double]*, [0 x double]** %16, align 8
  %196 = getelementptr inbounds [0 x double], [0 x double]* %195, i64 0, i64 %161
  %197 = getelementptr inbounds [0 x double], [0 x double]* %195, i64 0, i64 %indvars.iv257
  %198 = bitcast double* %197 to i64*
  %199 = load i64, i64* %198, align 8
  %200 = bitcast double* %196 to i64*
  %201 = load i64, i64* %200, align 8
  store i64 %201, i64* %198, align 8
  store i64 %199, i64* %200, align 8
  %202 = load [0 x %4]*, [0 x %4]** %14, align 8
  %203 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %161
  %204 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv257
  %205 = bitcast %4* %204 to i64*
  %.unpack131157 = load i64, i64* %205, align 8
  %.elt132 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv257, i32 1
  %206 = bitcast double* %.elt132 to i64*
  %.unpack133156 = load i64, i64* %206, align 8
  %.elt134 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv257, i32 2
  %207 = bitcast double* %.elt134 to i64*
  %.unpack135155 = load i64, i64* %207, align 8
  %208 = bitcast %4* %203 to i64*
  %.unpack137149 = load i64, i64* %208, align 8
  %.elt138 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %161, i32 1
  %209 = bitcast double* %.elt138 to i64*
  %.unpack139148 = load i64, i64* %209, align 8
  %.elt140 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %161, i32 2
  %210 = bitcast double* %.elt140 to i64*
  %.unpack141147 = load i64, i64* %210, align 8
  store i64 %.unpack137149, i64* %205, align 8
  store i64 %.unpack139148, i64* %206, align 8
  store i64 %.unpack141147, i64* %207, align 8
  store i64 %.unpack131157, i64* %208, align 8
  store i64 %.unpack133156, i64* %209, align 8
  store i64 %.unpack135155, i64* %210, align 8
  %211 = load [0 x %4]*, [0 x %4]** %18, align 8
  %212 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %161
  %213 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %indvars.iv257
  %214 = bitcast %4* %213 to i64*
  %.unpack159185 = load i64, i64* %214, align 8
  %.elt160 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %indvars.iv257, i32 1
  %215 = bitcast double* %.elt160 to i64*
  %.unpack161184 = load i64, i64* %215, align 8
  %.elt162 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %indvars.iv257, i32 2
  %216 = bitcast double* %.elt162 to i64*
  %.unpack163183 = load i64, i64* %216, align 8
  %217 = bitcast %4* %212 to i64*
  %.unpack165177 = load i64, i64* %217, align 8
  %.elt166 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %161, i32 1
  %218 = bitcast double* %.elt166 to i64*
  %.unpack167176 = load i64, i64* %218, align 8
  %.elt168 = getelementptr inbounds [0 x %4], [0 x %4]* %211, i64 0, i64 %161, i32 2
  %219 = bitcast double* %.elt168 to i64*
  %.unpack169175 = load i64, i64* %219, align 8
  store i64 %.unpack165177, i64* %214, align 8
  store i64 %.unpack167176, i64* %215, align 8
  store i64 %.unpack169175, i64* %216, align 8
  store i64 %.unpack159185, i64* %217, align 8
  store i64 %.unpack161184, i64* %218, align 8
  store i64 %.unpack163183, i64* %219, align 8
  br label %while_head.backedge

while_head.backedge:                              ; preds = %if_then37, %next35, %if_else13
  %220 = load i32, i32* %10, align 4
  %221 = add nsw i32 %220, -1
  store i32 %221, i32* %10, align 4
  %222 = sext i32 %221 to i64
  %223 = icmp slt i64 %indvars.iv257, %222
  br i1 %223, label %while_body, label %next.loopexit

if_then41:                                        ; preds = %if_then41, %if_then41.lr.ph
  %indvars.iv = phi i64 [ 0, %if_then41.lr.ph ], [ %indvars.iv.next, %if_then41 ]
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %224 = load [0 x double]*, [0 x double]** %117, align 8
  %225 = getelementptr inbounds [0 x double], [0 x double]* %115, i64 0, i64 %indvars.iv
  %226 = getelementptr inbounds [0 x double], [0 x double]* %224, i64 0, i64 %indvars.iv
  %227 = bitcast double* %226 to i64*
  %228 = load i64, i64* %227, align 8
  %229 = bitcast double* %225 to i64*
  store i64 %228, i64* %229, align 8
  %230 = load [0 x %4]*, [0 x %4]** %120, align 8
  %231 = getelementptr inbounds [0 x %4], [0 x %4]* %118, i64 0, i64 %indvars.iv
  %.elt186 = getelementptr inbounds [0 x %4], [0 x %4]* %230, i64 0, i64 %indvars.iv, i32 0
  %232 = bitcast double* %.elt186 to i64*
  %.unpack187199 = load i64, i64* %232, align 8
  %.elt188 = getelementptr inbounds [0 x %4], [0 x %4]* %230, i64 0, i64 %indvars.iv, i32 1
  %233 = bitcast double* %.elt188 to i64*
  %.unpack189198 = load i64, i64* %233, align 8
  %.elt190 = getelementptr inbounds [0 x %4], [0 x %4]* %230, i64 0, i64 %indvars.iv, i32 2
  %234 = bitcast double* %.elt190 to i64*
  %.unpack191197 = load i64, i64* %234, align 8
  %235 = bitcast %4* %231 to i64*
  store i64 %.unpack187199, i64* %235, align 8
  %.repack193 = getelementptr inbounds [0 x %4], [0 x %4]* %118, i64 0, i64 %indvars.iv, i32 1
  %236 = bitcast double* %.repack193 to i64*
  store i64 %.unpack189198, i64* %236, align 8
  %.repack195 = getelementptr inbounds [0 x %4], [0 x %4]* %118, i64 0, i64 %indvars.iv, i32 2
  %237 = bitcast double* %.repack195 to i64*
  store i64 %.unpack191197, i64* %237, align 8
  %238 = load [0 x %4]*, [0 x %4]** %123, align 8
  %239 = getelementptr inbounds [0 x %4], [0 x %4]* %121, i64 0, i64 %indvars.iv
  %.elt200 = getelementptr inbounds [0 x %4], [0 x %4]* %238, i64 0, i64 %indvars.iv, i32 0
  %240 = bitcast double* %.elt200 to i64*
  %.unpack201213 = load i64, i64* %240, align 8
  %.elt202 = getelementptr inbounds [0 x %4], [0 x %4]* %238, i64 0, i64 %indvars.iv, i32 1
  %241 = bitcast double* %.elt202 to i64*
  %.unpack203212 = load i64, i64* %241, align 8
  %.elt204 = getelementptr inbounds [0 x %4], [0 x %4]* %238, i64 0, i64 %indvars.iv, i32 2
  %242 = bitcast double* %.elt204 to i64*
  %.unpack205211 = load i64, i64* %242, align 8
  %243 = bitcast %4* %239 to i64*
  store i64 %.unpack201213, i64* %243, align 8
  %.repack207 = getelementptr inbounds [0 x %4], [0 x %4]* %121, i64 0, i64 %indvars.iv, i32 1
  %244 = bitcast double* %.repack207 to i64*
  store i64 %.unpack203212, i64* %244, align 8
  %.repack209 = getelementptr inbounds [0 x %4], [0 x %4]* %121, i64 0, i64 %indvars.iv, i32 2
  %245 = bitcast double* %.repack209 to i64*
  store i64 %.unpack205211, i64* %245, align 8
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %if_else34.loopexit, label %if_then41
}

; Function Attrs: nounwind
define void @cpu_integrate_velocity(double %dt_281414) local_unnamed_addr #0 {
cpu_integrate_velocity_start:
  %0 = load [0 x %3]*, [0 x %3]** bitcast ([0 x i8]** getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4, i32 1) to [0 x %3]**), align 8
  %1 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %if_then.lr.ph, label %if_else

if_then.lr.ph:                                    ; preds = %cpu_integrate_velocity_start
  %.splatinsert1.i = insertelement <1 x double> undef, double %dt_281414, i32 0
  br label %if_then

if_else.loopexit:                                 ; preds = %if_else4
  br label %if_else

if_else:                                          ; preds = %if_else.loopexit, %cpu_integrate_velocity_start
  ret void

if_then:                                          ; preds = %if_else4, %if_then.lr.ph
  %lower8 = phi i32 [ 0, %if_then.lr.ph ], [ %5, %if_else4 ]
  %3 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %if_then5.preheader, label %if_else4

if_then5.preheader:                               ; preds = %if_then
  br label %if_then5

if_else4.loopexit:                                ; preds = %exit
  br label %if_else4

if_else4:                                         ; preds = %if_else4.loopexit, %if_then
  %5 = add nuw nsw i32 %lower8, 1
  %exitcond11 = icmp eq i32 %5, %1
  br i1 %exitcond11, label %if_else.loopexit, label %if_then

if_then5:                                         ; preds = %if_then5.preheader, %exit.if_then5_crit_edge
  %6 = phi i32 [ %.pre, %exit.if_then5_crit_edge ], [ %3, %if_then5.preheader ]
  %lower27 = phi i32 [ %46, %exit.if_then5_crit_edge ], [ 0, %if_then5.preheader ]
  %7 = mul nsw i32 %6, %lower8
  %8 = add nsw i32 %7, %lower27
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 4
  %11 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 0, i32 1
  %12 = bitcast [0 x i8]** %11 to [0 x double]**
  %13 = load [0 x double]*, [0 x double]** %12, align 8
  %14 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 2, i32 1
  %15 = bitcast [0 x i8]** %14 to [0 x %4]**
  %16 = load [0 x %4]*, [0 x %4]** %15, align 8
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %0, i64 0, i64 %9, i32 3, i32 1
  %18 = bitcast [0 x i8]** %17 to [0 x %4]**
  %19 = load [0 x %4]*, [0 x %4]** %18, align 8
  %20 = load i32, i32* %10, align 4
  %21 = icmp sgt i32 %20, 0
  br i1 %21, label %body.preheader, label %exit

body.preheader:                                   ; preds = %if_then5
  %wide.trip.count = zext i32 %20 to i64
  br label %body

body:                                             ; preds = %body.preheader, %body
  %indvars.iv = phi i64 [ %indvars.iv.next, %body ], [ 0, %body.preheader ]
  %22 = trunc i64 %indvars.iv to i32
  %.splatinsert.i = insertelement <1 x i32> undef, i32 %22, i32 0
  %23 = getelementptr inbounds [0 x double], [0 x double]* %13, i64 0, i64 %indvars.iv
  %vec_cast.i = bitcast double* %23 to <1 x double>*
  %cont_load.i = load <1 x double>, <1 x double>* %vec_cast.i, align 1
  %inverse_mass_SIMD.i = fdiv <1 x double> <double 1.000000e+00>, %cont_load.i
  %24 = sext <1 x i32> %.splatinsert.i to <1 x i64>
  %25 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %24, i32 0
  %26 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %25, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %27 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %24, i32 0
  %28 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %27, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %29 = fmul <1 x double> %.splatinsert1.i, %26
  %30 = fmul <1 x double> %inverse_mass_SIMD.i, %29
  %31 = fadd <1 x double> %28, %30
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %31, <1 x double*> %27, i32 1, <1 x i1> <i1 true>)
  %32 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %24, i32 1
  %33 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %32, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %34 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %24, i32 1
  %35 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %34, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %36 = fmul <1 x double> %.splatinsert1.i, %33
  %37 = fmul <1 x double> %inverse_mass_SIMD.i, %36
  %38 = fadd <1 x double> %35, %37
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %38, <1 x double*> %34, i32 1, <1 x i1> <i1 true>)
  %39 = getelementptr inbounds [0 x %4], [0 x %4]* %19, <1 x i64> zeroinitializer, <1 x i64> %24, i32 2
  %40 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %39, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %41 = getelementptr inbounds [0 x %4], [0 x %4]* %16, <1 x i64> zeroinitializer, <1 x i64> %24, i32 2
  %42 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %41, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %43 = fmul <1 x double> %.splatinsert1.i, %40
  %44 = fmul <1 x double> %inverse_mass_SIMD.i, %43
  %45 = fadd <1 x double> %42, %44
  tail call void @llvm.masked.scatter.v1f64(<1 x double> %45, <1 x double*> %41, i32 1, <1 x i1> <i1 true>)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %body
  br label %exit

exit:                                             ; preds = %exit.loopexit, %if_then5
  %46 = add nuw nsw i32 %lower27, 1
  %exitcond10 = icmp eq i32 %46, %3
  br i1 %exitcond10, label %if_else4.loopexit, label %exit.if_then5_crit_edge

exit.if_then5_crit_edge:                          ; preds = %exit
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then5
}

define void @cpu_compute_forces(double %cutoff_distance_279168, double %epsilon_279169, double %sigma_279170) local_unnamed_addr {
cpu_compute_forces_start:
  %parallel_closure = alloca { double, %2, double, double }, align 8
  %0 = fmul double %sigma_279170, %sigma_279170
  %1 = fmul double %0, %sigma_279170
  %2 = fmul double %1, %1
  %3 = load %2, %2* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 4), align 16
  %4 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 1), align 16
  %parallel_closure.repack = getelementptr inbounds { double, %2, double, double }, { double, %2, double, double }* %parallel_closure, i64 0, i32 0
  store double %epsilon_279169, double* %parallel_closure.repack, align 8
  %.fca.0.extract = extractvalue %2 %3, 0
  %.fca.0.gep = getelementptr inbounds { double, %2, double, double }, { double, %2, double, double }* %parallel_closure, i64 0, i32 1, i32 0
  store i32 %.fca.0.extract, i32* %.fca.0.gep, align 8
  %.fca.1.extract = extractvalue %2 %3, 1
  %.fca.1.gep = getelementptr inbounds { double, %2, double, double }, { double, %2, double, double }* %parallel_closure, i64 0, i32 1, i32 1
  store [0 x i8]* %.fca.1.extract, [0 x i8]** %.fca.1.gep, align 8
  %parallel_closure.repack3 = getelementptr inbounds { double, %2, double, double }, { double, %2, double, double }* %parallel_closure, i64 0, i32 2
  store double %cutoff_distance_279168, double* %parallel_closure.repack3, align 8
  %parallel_closure.repack5 = getelementptr inbounds { double, %2, double, double }, { double, %2, double, double }* %parallel_closure, i64 0, i32 3
  store double %2, double* %parallel_closure.repack5, align 8
  %5 = bitcast { double, %2, double, double }* %parallel_closure to i8*
  call void @anydsl_parallel_for(i32 4, i32 0, i32 %4, i8* nonnull %5, i8* bitcast (void (i8*, i32, i32)* @lambda_279188_parallel_for to i8*))
  ret void
}

; Function Attrs: nounwind
define void @lambda_279188_parallel_for(i8* nocapture readonly, i32, i32) #0 {
lambda_279188_parallel_for:
  %3 = getelementptr inbounds i8, i8* %0, i64 16
  %4 = bitcast i8* %3 to [0 x %3]**
  %5 = load [0 x %3]*, [0 x %3]** %4, align 8
  %.elt3 = getelementptr inbounds i8, i8* %0, i64 24
  %6 = bitcast i8* %.elt3 to double*
  %.unpack4 = load double, double* %6, align 8
  %.elt5 = getelementptr inbounds i8, i8* %0, i64 32
  %7 = bitcast i8* %.elt5 to double*
  %.unpack6 = load double, double* %7, align 8
  %8 = icmp slt i32 %1, %2
  br i1 %8, label %body.lr.ph, label %exit

body.lr.ph:                                       ; preds = %lambda_279188_parallel_for
  %.elt = bitcast i8* %0 to double*
  %.unpack = load double, double* %.elt, align 8
  %9 = fmul double %.unpack4, %.unpack4
  %tmp2.i22.i = fmul double %.unpack6, 2.000000e+00
  %10 = fmul double %.unpack, 2.400000e+01
  %tmp1.i23.i = fmul double %10, %.unpack6
  %.splatinsert7.i.i = insertelement <1 x double> undef, double %9, i32 0
  %.splatinsert9.i.i = insertelement <1 x double> undef, double %tmp1.i23.i, i32 0
  %.splatinsert11.i.i = insertelement <1 x double> undef, double %tmp2.i22.i, i32 0
  br label %body

body:                                             ; preds = %lambda_279188.exit, %body.lr.ph
  %parallel_loop_phi34 = phi i32 [ %1, %body.lr.ph ], [ %248, %lambda_279188.exit ]
  %11 = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  %12 = icmp sgt i32 %11, 0
  br i1 %12, label %if_then.i.preheader, label %lambda_279188.exit

if_then.i.preheader:                              ; preds = %body
  br label %if_then.i

if_then.i:                                        ; preds = %if_then.i.preheader, %if_else4.i.if_then.i_crit_edge
  %13 = phi i32 [ %.pre, %if_else4.i.if_then.i_crit_edge ], [ %11, %if_then.i.preheader ]
  %lower.i33 = phi i32 [ %29, %if_else4.i.if_then.i_crit_edge ], [ 0, %if_then.i.preheader ]
  %14 = mul nsw i32 %13, %parallel_loop_phi34
  %15 = add nsw i32 %14, %lower.i33
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 7
  %18 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 4
  %19 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 9
  %20 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 8, i32 1
  %21 = bitcast [0 x i8]** %20 to [0 x %5]**
  %22 = load [0 x %5]*, [0 x %5]** %21, align 8
  %23 = load i32, i32* %17, align 4
  %24 = icmp sgt i32 %23, 0
  br i1 %24, label %if_then5.i.lr.ph, label %if_else4.i

if_then5.i.lr.ph:                                 ; preds = %if_then.i
  %25 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 1, i32 1
  %26 = bitcast [0 x i8]** %25 to [0 x %4]**
  %27 = getelementptr inbounds [0 x %3], [0 x %3]* %5, i64 0, i64 %16, i32 3, i32 1
  %28 = bitcast [0 x i8]** %27 to [0 x %4]**
  %wide.trip.count54 = zext i32 %23 to i64
  br label %if_then5.i

if_else4.i.loopexit:                              ; preds = %if_else11.i
  br label %if_else4.i

if_else4.i:                                       ; preds = %if_else4.i.loopexit, %if_then.i
  %29 = add nuw nsw i32 %lower.i33, 1
  %exitcond56 = icmp eq i32 %29, %11
  br i1 %exitcond56, label %lambda_279188.exit.loopexit, label %if_else4.i.if_then.i_crit_edge

if_else4.i.if_then.i_crit_edge:                   ; preds = %if_else4.i
  %.pre = load i32, i32* getelementptr inbounds (%0, %0* @grid_, i64 0, i32 2), align 4
  br label %if_then.i

if_then5.i:                                       ; preds = %if_else11.i, %if_then5.i.lr.ph
  %indvars.iv52 = phi i64 [ 0, %if_then5.i.lr.ph ], [ %indvars.iv.next53, %if_else11.i ]
  %indvars.iv46 = phi i32 [ 0, %if_then5.i.lr.ph ], [ %indvars.iv.next47, %if_else11.i ]
  %30 = load i32, i32* %19, align 4
  %31 = load i32, i32* %18, align 4
  %32 = trunc i64 %indvars.iv52 to i32
  %begin.i = mul nsw i32 %30, %32
  %33 = add nsw i32 %begin.i, %30
  %34 = icmp slt i32 %33, %31
  %. = select i1 %34, i32 %33, i32 %31
  %35 = icmp slt i32 %begin.i, %.
  br i1 %35, label %body.i.preheader, label %exit.i

body.i.preheader:                                 ; preds = %if_then5.i
  %36 = mul i32 %30, %indvars.iv46
  %37 = sext i32 %36 to i64
  %38 = sext i32 %. to i64
  br label %body.i

if_else11.i.loopexit:                             ; preds = %exit19.i
  br label %if_else11.i

if_else11.i:                                      ; preds = %if_else11.i.loopexit, %exit.i
  %indvars.iv.next53 = add nuw nsw i64 %indvars.iv52, 1
  %indvars.iv.next47 = add nuw nsw i32 %indvars.iv46, 1
  %exitcond55 = icmp eq i64 %indvars.iv.next53, %wide.trip.count54
  br i1 %exitcond55, label %if_else4.i.loopexit, label %if_then5.i

if_then12.i:                                      ; preds = %exit19.i, %if_then12.i.lr.ph
  %indvars.iv50 = phi i64 [ 0, %if_then12.i.lr.ph ], [ %indvars.iv.next51, %exit19.i ]
  %39 = load [0 x %3*]*, [0 x %3*]** %161, align 8
  %40 = getelementptr inbounds [0 x %3*], [0 x %3*]* %39, i64 0, i64 %indvars.iv50
  %41 = load %3*, %3** %40, align 8
  %42 = getelementptr inbounds %3, %3* %41, i64 0, i32 4
  %43 = getelementptr inbounds %3, %3* %41, i64 0, i32 9
  %44 = load [0 x i32]*, [0 x i32]** %163, align 8
  %45 = getelementptr inbounds [0 x i32], [0 x i32]* %44, i64 0, i64 %indvars.iv50
  %46 = load i32, i32* %45, align 4
  %47 = load i32, i32* %43, align 4
  %begin_neighbor.i = mul nsw i32 %47, %46
  %48 = load i32, i32* %42, align 4
  %49 = add nsw i32 %begin_neighbor.i, %47
  %50 = icmp slt i32 %49, %48
  %.7 = select i1 %50, i32 %49, i32 %48
  br i1 %35, label %body18.i.lr.ph, label %exit19.i

body18.i.lr.ph:                                   ; preds = %if_then12.i
  %51 = icmp slt i32 %begin_neighbor.i, %.7
  %52 = getelementptr inbounds %3, %3* %41, i64 0, i32 1, i32 1
  %53 = bitcast [0 x i8]** %52 to [0 x %4]**
  %54 = getelementptr inbounds %3, %3* %41, i64 0, i32 3, i32 1
  %55 = bitcast [0 x i8]** %54 to [0 x %4]**
  %56 = sext i32 %begin_neighbor.i to i64
  %57 = sext i32 %.7 to i64
  br label %body18.i

body.i:                                           ; preds = %body.i.preheader, %lambda_279246_vectorize.exit.i
  %indvars.iv42 = phi i64 [ %37, %body.i.preheader ], [ %indvars.iv.next43, %lambda_279246_vectorize.exit.i ]
  %indvars.iv36.in = phi i64 [ %37, %body.i.preheader ], [ %indvars.iv36, %lambda_279246_vectorize.exit.i ]
  %indvars.iv36 = add i64 %indvars.iv36.in, 1
  %indvars.iv.next43 = add nsw i64 %indvars.iv42, 1
  %58 = icmp slt i64 %indvars.iv.next43, %38
  br i1 %58, label %if_then.rv.i.i.lr.ph, label %exit.i.loopexit

if_then.rv.i.i.lr.ph:                             ; preds = %body.i
  %59 = trunc i64 %indvars.iv42 to i32
  %.splatinsert.i.i = insertelement <1 x i32> undef, i32 %59, i32 0
  %60 = sext <1 x i32> %.splatinsert.i.i to <1 x i64>
  br label %if_then.rv.i.i

may_unroll_step.rv.i.i.loopexit.loopexit:         ; preds = %cascade_end51.i.i.thread
  br label %may_unroll_step.rv.i.i.loopexit

may_unroll_step.rv.i.i.loopexit:                  ; preds = %may_unroll_step.rv.i.i.loopexit.loopexit, %while_head23.divexit.rv.i.i
  %indvars.iv.next39 = add i64 %indvars.iv38, 1
  %61 = icmp slt i64 %indvars.iv.next39, %38
  br i1 %61, label %if_then.rv.i.i, label %lambda_279246_vectorize.exit.i

if_then.rv.i.i:                                   ; preds = %if_then.rv.i.i.lr.ph, %may_unroll_step.rv.i.i.loopexit
  %indvars.iv38 = phi i64 [ %indvars.iv36, %if_then.rv.i.i.lr.ph ], [ %indvars.iv.next39, %may_unroll_step.rv.i.i.loopexit ]
  %62 = trunc i64 %indvars.iv38 to i32
  %.splatinsert1.i.i = insertelement <1 x i32> undef, i32 %62, i32 0
  %63 = load [0 x %4]*, [0 x %4]** %26, align 8
  %srov_gep.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %60, i32 0
  %64 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep66.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %60, i32 1
  %65 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep66.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep67.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %60, i32 2
  %66 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep67.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %67 = sext <1 x i32> %.splatinsert1.i.i to <1 x i64>
  %srov_gep68.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %67, i32 0
  %68 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep68.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep69.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %67, i32 1
  %69 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep69.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep70.i.i = getelementptr [0 x %4], [0 x %4]* %63, <1 x i64> zeroinitializer, <1 x i64> %67, i32 2
  %70 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep70.i.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %dz_SIMD.i.i = fsub <1 x double> %70, %66
  %dx_SIMD.i.i = fsub <1 x double> %68, %64
  %dy_SIMD.i.i = fsub <1 x double> %69, %65
  %71 = fmul <1 x double> %dz_SIMD.i.i, %dz_SIMD.i.i
  %72 = fmul <1 x double> %dx_SIMD.i.i, %dx_SIMD.i.i
  %73 = fmul <1 x double> %dy_SIMD.i.i, %dy_SIMD.i.i
  %74 = fadd <1 x double> %72, %73
  %squared_distance_SIMD.i.i = fadd <1 x double> %74, %71
  %75 = fcmp olt <1 x double> %squared_distance_SIMD.i.i, %.splatinsert7.i.i
  %76 = fmul <1 x double> %squared_distance_SIMD.i.i, %squared_distance_SIMD.i.i
  %77 = load [0 x %4]*, [0 x %4]** %28, align 8
  %78 = fmul <1 x double> %76, %76
  %.op.i.i = fdiv <1 x double> <double 1.000000e+00>, %78
  %distance_8_inv_SIMD.i.i = select <1 x i1> %75, <1 x double> %.op.i.i, <1 x double> <double 1.000000e+00>
  %79 = fmul <1 x double> %squared_distance_SIMD.i.i, %distance_8_inv_SIMD.i.i
  %80 = fmul <1 x double> %.splatinsert9.i.i, %distance_8_inv_SIMD.i.i
  %81 = fmul <1 x double> %.splatinsert11.i.i, %79
  %82 = fsub <1 x double> <double 1.000000e+00>, %81
  %83 = fmul <1 x double> %80, %82
  %dF_x_SIMD.i.i = fmul <1 x double> %dx_SIMD.i.i, %83
  %84 = getelementptr inbounds [0 x %4], [0 x %4]* %77, <1 x i64> zeroinitializer, <1 x i64> %60, i32 0
  %85 = bitcast <1 x double*> %84 to <1 x i64*>
  %86 = getelementptr inbounds [0 x %4], [0 x %4]* %77, i64 0, i64 %indvars.iv42
  %87 = bitcast %4* %86 to i64*
  br label %while_head.rv.i.i

while_head.rv.i.i:                                ; preds = %cascade_end.i.i, %if_then.rv.i.i
  %_SIMD.i.i = phi <1 x i1> [ %scalarized.i.i, %cascade_end.i.i ], [ zeroinitializer, %if_then.rv.i.i ]
  %while_head.live_SIMD.i.i = phi <1 x i1> [ %while_head.live.upd3554_SIMD.i.i, %cascade_end.i.i ], [ %75, %if_then.rv.i.i ]
  %next.xtrack_SIMD.i.i = phi <1 x i1> [ %next.xupd3655_SIMD.i.i, %cascade_end.i.i ], [ zeroinitializer, %if_then.rv.i.i ]
  %edge_while_head.0_SIMD.i.i = and <1 x i1> %while_head.live_SIMD.i.i, %_SIMD.i.i
  %neg.48_SIMD.i.i = xor <1 x i1> %_SIMD.i.i, <i1 true>
  %edge_while_head.1_SIMD.i.i = and <1 x i1> %while_head.live_SIMD.i.i, %neg.48_SIMD.i.i
  %extract.i.i = extractelement <1 x i1> %edge_while_head.1_SIMD.i.i, i32 0
  %88 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %85, i32 1, <1 x i1> %edge_while_head.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract.i.i, label %cascade_masked_0.i.i, label %cascade_end.i.i

while_head.divexit.rv.i.i:                        ; preds = %cascade_end.i.i
  %dF_y_SIMD.i.i = fmul <1 x double> %dy_SIMD.i.i, %83
  %89 = getelementptr inbounds [0 x %4], [0 x %4]* %77, <1 x i64> zeroinitializer, <1 x i64> %60, i32 1
  %90 = bitcast <1 x double*> %89 to <1 x i64*>
  %91 = getelementptr inbounds [0 x %4], [0 x %4]* %77, i64 0, i64 %indvars.iv42, i32 1
  %92 = bitcast double* %91 to i64*
  br label %while_head5.rv.i.i

while_head5.rv.i.i:                               ; preds = %cascade_end15.i.i, %while_head.divexit.rv.i.i
  %_SIMD12.i.i = phi <1 x i1> [ %scalarized19.i.i, %cascade_end15.i.i ], [ zeroinitializer, %while_head.divexit.rv.i.i ]
  %while_head5.live_SIMD.i.i = phi <1 x i1> [ %while_head5.live.upd3756_SIMD.i.i, %cascade_end15.i.i ], [ %next.xupd3655_SIMD.i.i, %while_head.divexit.rv.i.i ]
  %next10.xtrack_SIMD.i.i = phi <1 x i1> [ %next10.xupd3857_SIMD.i.i, %cascade_end15.i.i ], [ zeroinitializer, %while_head.divexit.rv.i.i ]
  %edge_while_head5.0_SIMD.i.i = and <1 x i1> %while_head5.live_SIMD.i.i, %_SIMD12.i.i
  %neg.49_SIMD.i.i = xor <1 x i1> %_SIMD12.i.i, <i1 true>
  %edge_while_head5.1_SIMD.i.i = and <1 x i1> %while_head5.live_SIMD.i.i, %neg.49_SIMD.i.i
  %extract16.i.i = extractelement <1 x i1> %edge_while_head5.1_SIMD.i.i, i32 0
  %93 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %90, i32 1, <1 x i1> %edge_while_head5.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract16.i.i, label %cascade_masked_014.i.i, label %cascade_end15.i.i

while_head5.divexit.rv.i.i:                       ; preds = %cascade_end15.i.i
  %dF_z_SIMD.i.i = fmul <1 x double> %dz_SIMD.i.i, %83
  %94 = getelementptr inbounds [0 x %4], [0 x %4]* %77, <1 x i64> zeroinitializer, <1 x i64> %60, i32 2
  %95 = bitcast <1 x double*> %94 to <1 x i64*>
  %96 = getelementptr inbounds [0 x %4], [0 x %4]* %77, i64 0, i64 %indvars.iv42, i32 2
  %97 = bitcast double* %96 to i64*
  br label %while_head11.rv.i.i

while_head11.rv.i.i:                              ; preds = %cascade_end24.i.i, %while_head5.divexit.rv.i.i
  %_SIMD21.i.i = phi <1 x i1> [ %scalarized28.i.i, %cascade_end24.i.i ], [ zeroinitializer, %while_head5.divexit.rv.i.i ]
  %while_head11.live_SIMD.i.i = phi <1 x i1> [ %while_head11.live.upd3958_SIMD.i.i, %cascade_end24.i.i ], [ %next10.xupd3857_SIMD.i.i, %while_head5.divexit.rv.i.i ]
  %next16.xtrack_SIMD.i.i = phi <1 x i1> [ %next16.xupd4059_SIMD.i.i, %cascade_end24.i.i ], [ zeroinitializer, %while_head5.divexit.rv.i.i ]
  %edge_while_head11.0_SIMD.i.i = and <1 x i1> %while_head11.live_SIMD.i.i, %_SIMD21.i.i
  %neg.50_SIMD.i.i = xor <1 x i1> %_SIMD21.i.i, <i1 true>
  %edge_while_head11.1_SIMD.i.i = and <1 x i1> %while_head11.live_SIMD.i.i, %neg.50_SIMD.i.i
  %extract25.i.i = extractelement <1 x i1> %edge_while_head11.1_SIMD.i.i, i32 0
  %98 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %95, i32 1, <1 x i1> %edge_while_head11.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract25.i.i, label %cascade_masked_023.i.i, label %cascade_end24.i.i

while_head11.divexit.rv.i.i:                      ; preds = %cascade_end24.i.i
  %99 = load [0 x %4]*, [0 x %4]** %28, align 8
  %100 = getelementptr inbounds [0 x %4], [0 x %4]* %99, <1 x i64> zeroinitializer, <1 x i64> %67, i32 0
  %101 = bitcast <1 x double*> %100 to <1 x i64*>
  %102 = getelementptr inbounds [0 x %4], [0 x %4]* %99, i64 0, i64 %indvars.iv38
  %103 = bitcast %4* %102 to i64*
  br label %while_head17.rv.i.i

while_head17.rv.i.i:                              ; preds = %cascade_end33.i.i, %while_head11.divexit.rv.i.i
  %_SIMD30.i.i = phi <1 x i1> [ %scalarized37.i.i, %cascade_end33.i.i ], [ zeroinitializer, %while_head11.divexit.rv.i.i ]
  %while_head17.live_SIMD.i.i = phi <1 x i1> [ %while_head17.live.upd4160_SIMD.i.i, %cascade_end33.i.i ], [ %next16.xupd4059_SIMD.i.i, %while_head11.divexit.rv.i.i ]
  %next22.xtrack_SIMD.i.i = phi <1 x i1> [ %next22.xupd4261_SIMD.i.i, %cascade_end33.i.i ], [ zeroinitializer, %while_head11.divexit.rv.i.i ]
  %edge_while_head17.0_SIMD.i.i = and <1 x i1> %while_head17.live_SIMD.i.i, %_SIMD30.i.i
  %neg.51_SIMD.i.i = xor <1 x i1> %_SIMD30.i.i, <i1 true>
  %edge_while_head17.1_SIMD.i.i = and <1 x i1> %while_head17.live_SIMD.i.i, %neg.51_SIMD.i.i
  %extract34.i.i = extractelement <1 x i1> %edge_while_head17.1_SIMD.i.i, i32 0
  %104 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %101, i32 1, <1 x i1> %edge_while_head17.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract34.i.i, label %cascade_masked_032.i.i, label %cascade_end33.i.i

while_head17.divexit.rv.i.i:                      ; preds = %cascade_end33.i.i
  %105 = getelementptr inbounds [0 x %4], [0 x %4]* %99, <1 x i64> zeroinitializer, <1 x i64> %67, i32 1
  %106 = bitcast <1 x double*> %105 to <1 x i64*>
  %107 = getelementptr inbounds [0 x %4], [0 x %4]* %99, i64 0, i64 %indvars.iv38, i32 1
  %108 = bitcast double* %107 to i64*
  br label %while_head23.rv.i.i

while_head23.rv.i.i:                              ; preds = %cascade_end42.i.i, %while_head17.divexit.rv.i.i
  %_SIMD39.i.i = phi <1 x i1> [ %scalarized46.i.i, %cascade_end42.i.i ], [ zeroinitializer, %while_head17.divexit.rv.i.i ]
  %while_head23.live_SIMD.i.i = phi <1 x i1> [ %while_head23.live.upd4362_SIMD.i.i, %cascade_end42.i.i ], [ %next22.xupd4261_SIMD.i.i, %while_head17.divexit.rv.i.i ]
  %next28.xtrack_SIMD.i.i = phi <1 x i1> [ %next28.xupd4463_SIMD.i.i, %cascade_end42.i.i ], [ zeroinitializer, %while_head17.divexit.rv.i.i ]
  %edge_while_head23.0_SIMD.i.i = and <1 x i1> %while_head23.live_SIMD.i.i, %_SIMD39.i.i
  %neg.52_SIMD.i.i = xor <1 x i1> %_SIMD39.i.i, <i1 true>
  %edge_while_head23.1_SIMD.i.i = and <1 x i1> %while_head23.live_SIMD.i.i, %neg.52_SIMD.i.i
  %extract43.i.i = extractelement <1 x i1> %edge_while_head23.1_SIMD.i.i, i32 0
  %109 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %106, i32 1, <1 x i1> %edge_while_head23.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract43.i.i, label %cascade_masked_041.i.i, label %cascade_end42.i.i

while_head23.divexit.rv.i.i:                      ; preds = %cascade_end42.i.i
  %110 = getelementptr inbounds [0 x %4], [0 x %4]* %99, <1 x i64> zeroinitializer, <1 x i64> %67, i32 2
  %111 = bitcast <1 x double*> %110 to <1 x i64*>
  %112 = getelementptr inbounds [0 x %4], [0 x %4]* %99, i64 0, i64 %indvars.iv38, i32 2
  %113 = bitcast double* %112 to i64*
  %extract52.i.i21 = extractelement <1 x i1> %next28.xupd4463_SIMD.i.i, i32 0
  br i1 %extract52.i.i21, label %cascade_end51.i.i.thread.preheader, label %may_unroll_step.rv.i.i.loopexit

cascade_end51.i.i.thread.preheader:               ; preds = %while_head23.divexit.rv.i.i
  %114 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %111, i32 1, <1 x i1> %next28.xupd4463_SIMD.i.i, <1 x i64> undef)
  br label %cascade_end51.i.i.thread

cascade_masked_0.i.i:                             ; preds = %while_head.rv.i.i
  %115 = bitcast <1 x i64> %88 to <1 x double>
  %116 = fadd <1 x double> %dF_x_SIMD.i.i, %115
  %bc.i.i = bitcast <1 x double> %116 to <1 x i64>
  %117 = extractelement <1 x i64> %bc.i.i, i32 0
  %extract10.i.i = extractelement <1 x i64> %88, i32 0
  %118 = cmpxchg i64* %87, i64 %extract10.i.i, i64 %117 seq_cst seq_cst
  br label %cascade_end.i.i

cascade_end.i.i:                                  ; preds = %cascade_masked_0.i.i, %while_head.rv.i.i
  %119 = phi { i64, i1 } [ undef, %while_head.rv.i.i ], [ %118, %cascade_masked_0.i.i ]
  %120 = extractvalue { i64, i1 } %119, 1
  %scalarized.i.i = insertelement <1 x i1> undef, i1 %120, i64 0
  %while_head.live.upd3554_SIMD.i.i = xor <1 x i1> %while_head.live_SIMD.i.i, %edge_while_head.0_SIMD.i.i
  %next.xupd3655_SIMD.i.i = or <1 x i1> %edge_while_head.0_SIMD.i.i, %next.xtrack_SIMD.i.i
  %121 = extractelement <1 x i1> %while_head.live.upd3554_SIMD.i.i, i32 0
  br i1 %121, label %while_head.rv.i.i, label %while_head.divexit.rv.i.i

cascade_masked_014.i.i:                           ; preds = %while_head5.rv.i.i
  %122 = bitcast <1 x i64> %93 to <1 x double>
  %123 = fadd <1 x double> %dF_y_SIMD.i.i, %122
  %bc57.i.i = bitcast <1 x double> %123 to <1 x i64>
  %124 = extractelement <1 x i64> %bc57.i.i, i32 0
  %extract17.i.i = extractelement <1 x i64> %93, i32 0
  %125 = cmpxchg i64* %92, i64 %extract17.i.i, i64 %124 seq_cst seq_cst
  br label %cascade_end15.i.i

cascade_end15.i.i:                                ; preds = %cascade_masked_014.i.i, %while_head5.rv.i.i
  %126 = phi { i64, i1 } [ undef, %while_head5.rv.i.i ], [ %125, %cascade_masked_014.i.i ]
  %127 = extractvalue { i64, i1 } %126, 1
  %scalarized19.i.i = insertelement <1 x i1> undef, i1 %127, i64 0
  %while_head5.live.upd3756_SIMD.i.i = xor <1 x i1> %while_head5.live_SIMD.i.i, %edge_while_head5.0_SIMD.i.i
  %next10.xupd3857_SIMD.i.i = or <1 x i1> %edge_while_head5.0_SIMD.i.i, %next10.xtrack_SIMD.i.i
  %128 = extractelement <1 x i1> %while_head5.live.upd3756_SIMD.i.i, i32 0
  br i1 %128, label %while_head5.rv.i.i, label %while_head5.divexit.rv.i.i

cascade_masked_023.i.i:                           ; preds = %while_head11.rv.i.i
  %129 = bitcast <1 x i64> %98 to <1 x double>
  %130 = fadd <1 x double> %dF_z_SIMD.i.i, %129
  %bc58.i.i = bitcast <1 x double> %130 to <1 x i64>
  %131 = extractelement <1 x i64> %bc58.i.i, i32 0
  %extract26.i.i = extractelement <1 x i64> %98, i32 0
  %132 = cmpxchg i64* %97, i64 %extract26.i.i, i64 %131 seq_cst seq_cst
  br label %cascade_end24.i.i

cascade_end24.i.i:                                ; preds = %cascade_masked_023.i.i, %while_head11.rv.i.i
  %133 = phi { i64, i1 } [ undef, %while_head11.rv.i.i ], [ %132, %cascade_masked_023.i.i ]
  %134 = extractvalue { i64, i1 } %133, 1
  %scalarized28.i.i = insertelement <1 x i1> undef, i1 %134, i64 0
  %while_head11.live.upd3958_SIMD.i.i = xor <1 x i1> %while_head11.live_SIMD.i.i, %edge_while_head11.0_SIMD.i.i
  %next16.xupd4059_SIMD.i.i = or <1 x i1> %edge_while_head11.0_SIMD.i.i, %next16.xtrack_SIMD.i.i
  %135 = extractelement <1 x i1> %while_head11.live.upd3958_SIMD.i.i, i32 0
  br i1 %135, label %while_head11.rv.i.i, label %while_head11.divexit.rv.i.i

cascade_masked_032.i.i:                           ; preds = %while_head17.rv.i.i
  %136 = bitcast <1 x i64> %104 to <1 x double>
  %137 = fsub <1 x double> %136, %dF_x_SIMD.i.i
  %bc59.i.i = bitcast <1 x double> %137 to <1 x i64>
  %138 = extractelement <1 x i64> %bc59.i.i, i32 0
  %extract35.i.i = extractelement <1 x i64> %104, i32 0
  %139 = cmpxchg i64* %103, i64 %extract35.i.i, i64 %138 seq_cst seq_cst
  br label %cascade_end33.i.i

cascade_end33.i.i:                                ; preds = %cascade_masked_032.i.i, %while_head17.rv.i.i
  %140 = phi { i64, i1 } [ undef, %while_head17.rv.i.i ], [ %139, %cascade_masked_032.i.i ]
  %141 = extractvalue { i64, i1 } %140, 1
  %scalarized37.i.i = insertelement <1 x i1> undef, i1 %141, i64 0
  %while_head17.live.upd4160_SIMD.i.i = xor <1 x i1> %while_head17.live_SIMD.i.i, %edge_while_head17.0_SIMD.i.i
  %next22.xupd4261_SIMD.i.i = or <1 x i1> %edge_while_head17.0_SIMD.i.i, %next22.xtrack_SIMD.i.i
  %142 = extractelement <1 x i1> %while_head17.live.upd4160_SIMD.i.i, i32 0
  br i1 %142, label %while_head17.rv.i.i, label %while_head17.divexit.rv.i.i

cascade_masked_041.i.i:                           ; preds = %while_head23.rv.i.i
  %143 = bitcast <1 x i64> %109 to <1 x double>
  %144 = fsub <1 x double> %143, %dF_y_SIMD.i.i
  %bc60.i.i = bitcast <1 x double> %144 to <1 x i64>
  %145 = extractelement <1 x i64> %bc60.i.i, i32 0
  %extract44.i.i = extractelement <1 x i64> %109, i32 0
  %146 = cmpxchg i64* %108, i64 %extract44.i.i, i64 %145 seq_cst seq_cst
  br label %cascade_end42.i.i

cascade_end42.i.i:                                ; preds = %cascade_masked_041.i.i, %while_head23.rv.i.i
  %147 = phi { i64, i1 } [ undef, %while_head23.rv.i.i ], [ %146, %cascade_masked_041.i.i ]
  %148 = extractvalue { i64, i1 } %147, 1
  %scalarized46.i.i = insertelement <1 x i1> undef, i1 %148, i64 0
  %while_head23.live.upd4362_SIMD.i.i = xor <1 x i1> %while_head23.live_SIMD.i.i, %edge_while_head23.0_SIMD.i.i
  %next28.xupd4463_SIMD.i.i = or <1 x i1> %edge_while_head23.0_SIMD.i.i, %next28.xtrack_SIMD.i.i
  %149 = extractelement <1 x i1> %while_head23.live.upd4362_SIMD.i.i, i32 0
  br i1 %149, label %while_head23.rv.i.i, label %while_head23.divexit.rv.i.i

cascade_end51.i.i.thread:                         ; preds = %cascade_end51.i.i.thread.preheader, %cascade_end51.i.i.thread
  %150 = phi <1 x i64> [ %156, %cascade_end51.i.i.thread ], [ %114, %cascade_end51.i.i.thread.preheader ]
  %edge_while_head29.1_SIMD.i.i22 = phi <1 x i1> [ %edge_while_head29.1_SIMD.i.i, %cascade_end51.i.i.thread ], [ %next28.xupd4463_SIMD.i.i, %cascade_end51.i.i.thread.preheader ]
  %151 = bitcast <1 x i64> %150 to <1 x double>
  %152 = fsub <1 x double> %151, %dF_z_SIMD.i.i
  %bc61.i.i = bitcast <1 x double> %152 to <1 x i64>
  %153 = extractelement <1 x i64> %bc61.i.i, i32 0
  %extract53.i.i = extractelement <1 x i64> %150, i32 0
  %154 = cmpxchg i64* %113, i64 %extract53.i.i, i64 %153 seq_cst seq_cst
  %155 = extractvalue { i64, i1 } %154, 1
  %scalarized55.i.i8 = insertelement <1 x i1> undef, i1 %155, i64 0
  %neg.53_SIMD.i.i = xor <1 x i1> %scalarized55.i.i8, <i1 true>
  %edge_while_head29.1_SIMD.i.i = and <1 x i1> %edge_while_head29.1_SIMD.i.i22, %neg.53_SIMD.i.i
  %extract52.i.i = extractelement <1 x i1> %edge_while_head29.1_SIMD.i.i, i32 0
  %156 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %111, i32 1, <1 x i1> %edge_while_head29.1_SIMD.i.i, <1 x i64> undef)
  br i1 %extract52.i.i, label %cascade_end51.i.i.thread, label %may_unroll_step.rv.i.i.loopexit.loopexit

lambda_279246_vectorize.exit.i:                   ; preds = %may_unroll_step.rv.i.i.loopexit
  br i1 %58, label %body.i, label %exit.i.loopexit

exit.i.loopexit:                                  ; preds = %lambda_279246_vectorize.exit.i, %body.i
  br label %exit.i

exit.i:                                           ; preds = %exit.i.loopexit, %if_then5.i
  %157 = getelementptr inbounds [0 x %5], [0 x %5]* %22, i64 0, i64 %indvars.iv52, i32 0, i32 0
  %158 = load i32, i32* %157, align 4
  %159 = icmp sgt i32 %158, 0
  br i1 %159, label %if_then12.i.lr.ph, label %if_else11.i

if_then12.i.lr.ph:                                ; preds = %exit.i
  %160 = getelementptr inbounds [0 x %5], [0 x %5]* %22, i64 0, i64 %indvars.iv52, i32 0, i32 2, i32 1
  %161 = bitcast [0 x i8]** %160 to [0 x %3*]**
  %162 = getelementptr inbounds [0 x %5], [0 x %5]* %22, i64 0, i64 %indvars.iv52, i32 0, i32 3, i32 1
  %163 = bitcast [0 x i8]** %162 to [0 x i32]**
  %164 = mul i32 %30, %indvars.iv46
  %165 = sext i32 %164 to i64
  %166 = sext i32 %. to i64
  %wide.trip.count = zext i32 %158 to i64
  br label %if_then12.i

body18.i:                                         ; preds = %body18.i.lr.ph, %lambda_279520_vectorize.exit.i
  %indvars.iv48 = phi i64 [ %165, %body18.i.lr.ph ], [ %indvars.iv.next49, %lambda_279520_vectorize.exit.i ]
  br i1 %51, label %if_then.rv.i34.i.lr.ph, label %lambda_279520_vectorize.exit.i

if_then.rv.i34.i.lr.ph:                           ; preds = %body18.i
  %167 = trunc i64 %indvars.iv48 to i32
  %.splatinsert.i21.i = insertelement <1 x i32> undef, i32 %167, i32 0
  %168 = sext <1 x i32> %.splatinsert.i21.i to <1 x i64>
  br label %if_then.rv.i34.i

if_then.rv.i34.i:                                 ; preds = %if_then.rv.i34.i.lr.ph, %while_head29.divexit.rv.i92.i
  %indvars.iv44 = phi i64 [ %56, %if_then.rv.i34.i.lr.ph ], [ %indvars.iv.next45, %while_head29.divexit.rv.i92.i ]
  %169 = load [0 x %4]*, [0 x %4]** %26, align 8
  %srov_gep.i26.i = getelementptr [0 x %4], [0 x %4]* %169, <1 x i64> zeroinitializer, <1 x i64> %168, i32 0
  %170 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep.i26.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep66.i27.i = getelementptr [0 x %4], [0 x %4]* %169, <1 x i64> zeroinitializer, <1 x i64> %168, i32 1
  %171 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep66.i27.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %srov_gep67.i28.i = getelementptr [0 x %4], [0 x %4]* %169, <1 x i64> zeroinitializer, <1 x i64> %168, i32 2
  %172 = tail call <1 x double> @llvm.masked.gather.v1f64(<1 x double*> %srov_gep67.i28.i, i32 1, <1 x i1> <i1 true>, <1 x double> undef)
  %173 = load [0 x %4]*, [0 x %4]** %53, align 8
  %.elt.i.i = getelementptr inbounds [0 x %4], [0 x %4]* %173, i64 0, i64 %indvars.iv44, i32 0
  %.unpack.i.i = load double, double* %.elt.i.i, align 8
  %.elt74.i.i = getelementptr inbounds [0 x %4], [0 x %4]* %173, i64 0, i64 %indvars.iv44, i32 1
  %.unpack75.i.i = load double, double* %.elt74.i.i, align 8
  %.elt76.i.i = getelementptr inbounds [0 x %4], [0 x %4]* %173, i64 0, i64 %indvars.iv44, i32 2
  %.unpack77.i.i = load double, double* %.elt76.i.i, align 8
  %.splatinsert1.i29.i = insertelement <1 x double> undef, double %.unpack77.i.i, i32 0
  %dz_SIMD.i30.i = fsub <1 x double> %.splatinsert1.i29.i, %172
  %.splatinsert3.i.i = insertelement <1 x double> undef, double %.unpack.i.i, i32 0
  %dx_SIMD.i31.i = fsub <1 x double> %.splatinsert3.i.i, %170
  %.splatinsert5.i.i = insertelement <1 x double> undef, double %.unpack75.i.i, i32 0
  %dy_SIMD.i32.i = fsub <1 x double> %.splatinsert5.i.i, %171
  %174 = fmul <1 x double> %dz_SIMD.i30.i, %dz_SIMD.i30.i
  %175 = fmul <1 x double> %dx_SIMD.i31.i, %dx_SIMD.i31.i
  %176 = fmul <1 x double> %dy_SIMD.i32.i, %dy_SIMD.i32.i
  %177 = fadd <1 x double> %175, %176
  %squared_distance_SIMD.i33.i = fadd <1 x double> %177, %174
  %178 = fcmp olt <1 x double> %squared_distance_SIMD.i33.i, %.splatinsert7.i.i
  %179 = load [0 x %4]*, [0 x %4]** %28, align 8
  %180 = fmul <1 x double> %squared_distance_SIMD.i33.i, %squared_distance_SIMD.i33.i
  %181 = fmul <1 x double> %180, %180
  %.op.i35.i = fdiv <1 x double> <double 1.000000e+00>, %181
  %distance_8_inv_SIMD.i36.i = select <1 x i1> %178, <1 x double> %.op.i35.i, <1 x double> <double 1.000000e+00>
  %182 = fmul <1 x double> %.splatinsert9.i.i, %distance_8_inv_SIMD.i36.i
  %183 = fmul <1 x double> %squared_distance_SIMD.i33.i, %distance_8_inv_SIMD.i36.i
  %184 = fmul <1 x double> %.splatinsert11.i.i, %183
  %185 = fsub <1 x double> <double 1.000000e+00>, %184
  %186 = fmul <1 x double> %182, %185
  %dF_x_SIMD.i37.i = fmul <1 x double> %dx_SIMD.i31.i, %186
  %187 = getelementptr inbounds [0 x %4], [0 x %4]* %179, <1 x i64> zeroinitializer, <1 x i64> %168, i32 0
  %188 = bitcast <1 x double*> %187 to <1 x i64*>
  %189 = getelementptr inbounds [0 x %4], [0 x %4]* %179, i64 0, i64 %indvars.iv48
  %190 = bitcast %4* %189 to i64*
  br label %while_head.rv.i45.i

while_head.rv.i45.i:                              ; preds = %cascade_end.i96.i, %if_then.rv.i34.i
  %_SIMD.i38.i = phi <1 x i1> [ %scalarized.i95.i, %cascade_end.i96.i ], [ zeroinitializer, %if_then.rv.i34.i ]
  %while_head.live_SIMD.i39.i = phi <1 x i1> [ %while_head.live.upd3554_SIMD.i48.i, %cascade_end.i96.i ], [ %178, %if_then.rv.i34.i ]
  %next.xtrack_SIMD.i40.i = phi <1 x i1> [ %next.xupd3655_SIMD.i49.i, %cascade_end.i96.i ], [ zeroinitializer, %if_then.rv.i34.i ]
  %edge_while_head.0_SIMD.i41.i = and <1 x i1> %while_head.live_SIMD.i39.i, %_SIMD.i38.i
  %neg.48_SIMD.i42.i = xor <1 x i1> %_SIMD.i38.i, <i1 true>
  %edge_while_head.1_SIMD.i43.i = and <1 x i1> %while_head.live_SIMD.i39.i, %neg.48_SIMD.i42.i
  %extract.i44.i = extractelement <1 x i1> %edge_while_head.1_SIMD.i43.i, i32 0
  %191 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %188, i32 1, <1 x i1> %edge_while_head.1_SIMD.i43.i, <1 x i64> undef)
  br i1 %extract.i44.i, label %cascade_masked_0.i94.i, label %cascade_end.i96.i

while_head.divexit.rv.i47.i:                      ; preds = %cascade_end.i96.i
  %dF_y_SIMD.i50.i = fmul <1 x double> %dy_SIMD.i32.i, %186
  %192 = getelementptr inbounds [0 x %4], [0 x %4]* %179, <1 x i64> zeroinitializer, <1 x i64> %168, i32 1
  %193 = bitcast <1 x double*> %192 to <1 x i64*>
  %194 = getelementptr inbounds [0 x %4], [0 x %4]* %179, i64 0, i64 %indvars.iv48, i32 1
  %195 = bitcast double* %194 to i64*
  br label %while_head5.rv.i56.i

while_head5.rv.i56.i:                             ; preds = %cascade_end18.i.i, %while_head.divexit.rv.i47.i
  %_SIMD15.i.i = phi <1 x i1> [ %scalarized22.i.i, %cascade_end18.i.i ], [ zeroinitializer, %while_head.divexit.rv.i47.i ]
  %while_head5.live_SIMD.i51.i = phi <1 x i1> [ %while_head5.live.upd3756_SIMD.i58.i, %cascade_end18.i.i ], [ %next.xupd3655_SIMD.i49.i, %while_head.divexit.rv.i47.i ]
  %next10.xtrack_SIMD.i52.i = phi <1 x i1> [ %next10.xupd3857_SIMD.i59.i, %cascade_end18.i.i ], [ zeroinitializer, %while_head.divexit.rv.i47.i ]
  %edge_while_head5.0_SIMD.i53.i = and <1 x i1> %while_head5.live_SIMD.i51.i, %_SIMD15.i.i
  %neg.49_SIMD.i54.i = xor <1 x i1> %_SIMD15.i.i, <i1 true>
  %edge_while_head5.1_SIMD.i55.i = and <1 x i1> %while_head5.live_SIMD.i51.i, %neg.49_SIMD.i54.i
  %extract19.i.i = extractelement <1 x i1> %edge_while_head5.1_SIMD.i55.i, i32 0
  %196 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %193, i32 1, <1 x i1> %edge_while_head5.1_SIMD.i55.i, <1 x i64> undef)
  br i1 %extract19.i.i, label %cascade_masked_017.i.i, label %cascade_end18.i.i

while_head5.divexit.rv.i57.i:                     ; preds = %cascade_end18.i.i
  %dF_z_SIMD.i60.i = fmul <1 x double> %dz_SIMD.i30.i, %186
  %197 = getelementptr inbounds [0 x %4], [0 x %4]* %179, <1 x i64> zeroinitializer, <1 x i64> %168, i32 2
  %198 = bitcast <1 x double*> %197 to <1 x i64*>
  %199 = getelementptr inbounds [0 x %4], [0 x %4]* %179, i64 0, i64 %indvars.iv48, i32 2
  %200 = bitcast double* %199 to i64*
  br label %while_head11.rv.i66.i

while_head11.rv.i66.i:                            ; preds = %cascade_end27.i.i, %while_head5.divexit.rv.i57.i
  %_SIMD24.i.i = phi <1 x i1> [ %scalarized31.i.i, %cascade_end27.i.i ], [ zeroinitializer, %while_head5.divexit.rv.i57.i ]
  %while_head11.live_SIMD.i61.i = phi <1 x i1> [ %while_head11.live.upd3958_SIMD.i68.i, %cascade_end27.i.i ], [ %next10.xupd3857_SIMD.i59.i, %while_head5.divexit.rv.i57.i ]
  %next16.xtrack_SIMD.i62.i = phi <1 x i1> [ %next16.xupd4059_SIMD.i69.i, %cascade_end27.i.i ], [ zeroinitializer, %while_head5.divexit.rv.i57.i ]
  %edge_while_head11.0_SIMD.i63.i = and <1 x i1> %while_head11.live_SIMD.i61.i, %_SIMD24.i.i
  %neg.50_SIMD.i64.i = xor <1 x i1> %_SIMD24.i.i, <i1 true>
  %edge_while_head11.1_SIMD.i65.i = and <1 x i1> %while_head11.live_SIMD.i61.i, %neg.50_SIMD.i64.i
  %extract28.i.i = extractelement <1 x i1> %edge_while_head11.1_SIMD.i65.i, i32 0
  %201 = tail call <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*> %198, i32 1, <1 x i1> %edge_while_head11.1_SIMD.i65.i, <1 x i64> undef)
  br i1 %extract28.i.i, label %cascade_masked_026.i.i, label %cascade_end27.i.i

while_head11.divexit.rv.i67.i:                    ; preds = %cascade_end27.i.i
  %202 = load [0 x %4]*, [0 x %4]** %55, align 8
  %203 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv44
  %204 = bitcast %4* %203 to i64*
  %extract41.rhs.i.i = extractelement <1 x double> %dF_x_SIMD.i37.i, i32 0
  br label %while_head17.rv.i75.i

while_head17.rv.i75.i:                            ; preds = %cascade_end39.i.i, %while_head11.divexit.rv.i67.i
  %_SIMD33.i.i = phi <1 x i1> [ %scalarized42.i.i, %cascade_end39.i.i ], [ zeroinitializer, %while_head11.divexit.rv.i67.i ]
  %while_head17.live_SIMD.i70.i = phi <1 x i1> [ %while_head17.live.upd4160_SIMD.i77.i, %cascade_end39.i.i ], [ %next16.xupd4059_SIMD.i69.i, %while_head11.divexit.rv.i67.i ]
  %next22.xtrack_SIMD.i71.i = phi <1 x i1> [ %next22.xupd4261_SIMD.i78.i, %cascade_end39.i.i ], [ zeroinitializer, %while_head11.divexit.rv.i67.i ]
  %edge_while_head17.0_SIMD.i72.i = and <1 x i1> %while_head17.live_SIMD.i70.i, %_SIMD33.i.i
  %extract40.i.i.lhs = extractelement <1 x i1> %while_head17.live_SIMD.i70.i, i32 0
  %extract40.i.i.rhs.lhs = extractelement <1 x i1> %_SIMD33.i.i, i32 0
  %extract40.i.i.rhs = xor i1 %extract40.i.i.rhs.lhs, true
  %extract40.i.i = and i1 %extract40.i.i.lhs, %extract40.i.i.rhs
  br i1 %extract40.i.i, label %cascade_masked_038.i.i, label %cascade_end39.i.i

while_head17.divexit.rv.i76.i:                    ; preds = %cascade_end39.i.i
  %205 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv44, i32 1
  %206 = bitcast double* %205 to i64*
  %extract56.rhs.i.i = extractelement <1 x double> %dF_y_SIMD.i50.i, i32 0
  br label %while_head23.rv.i84.i

while_head23.rv.i84.i:                            ; preds = %cascade_end54.i.i, %while_head17.divexit.rv.i76.i
  %_SIMD44.i.i = phi <1 x i1> [ %scalarized57.i.i, %cascade_end54.i.i ], [ zeroinitializer, %while_head17.divexit.rv.i76.i ]
  %while_head23.live_SIMD.i79.i = phi <1 x i1> [ %while_head23.live.upd4362_SIMD.i86.i, %cascade_end54.i.i ], [ %next22.xupd4261_SIMD.i78.i, %while_head17.divexit.rv.i76.i ]
  %next28.xtrack_SIMD.i80.i = phi <1 x i1> [ %next28.xupd4463_SIMD.i87.i, %cascade_end54.i.i ], [ zeroinitializer, %while_head17.divexit.rv.i76.i ]
  %edge_while_head23.0_SIMD.i81.i = and <1 x i1> %while_head23.live_SIMD.i79.i, %_SIMD44.i.i
  %extract55.i.i.lhs = extractelement <1 x i1> %while_head23.live_SIMD.i79.i, i32 0
  %extract55.i.i.rhs.lhs = extractelement <1 x i1> %_SIMD44.i.i, i32 0
  %extract55.i.i.rhs = xor i1 %extract55.i.i.rhs.lhs, true
  %extract55.i.i = and i1 %extract55.i.i.lhs, %extract55.i.i.rhs
  br i1 %extract55.i.i, label %cascade_masked_053.i.i, label %cascade_end54.i.i

while_head23.divexit.rv.i85.i:                    ; preds = %cascade_end54.i.i
  %207 = getelementptr inbounds [0 x %4], [0 x %4]* %202, i64 0, i64 %indvars.iv44, i32 2
  %208 = bitcast double* %207 to i64*
  %extract70.i.i27 = extractelement <1 x i1> %next28.xupd4463_SIMD.i87.i, i32 0
  br i1 %extract70.i.i27, label %cascade_end69.i.i.thread.lr.ph, label %while_head29.divexit.rv.i92.i

cascade_end69.i.i.thread.lr.ph:                   ; preds = %while_head23.divexit.rv.i85.i
  %extract71.rhs.i.i = extractelement <1 x double> %dF_z_SIMD.i60.i, i32 0
  br label %cascade_end69.i.i.thread

while_head29.divexit.rv.i92.i.loopexit:           ; preds = %cascade_end69.i.i.thread
  br label %while_head29.divexit.rv.i92.i

while_head29.divexit.rv.i92.i:                    ; preds = %while_head29.divexit.rv.i92.i.loopexit, %while_head23.divexit.rv.i85.i
  %indvars.iv.next45 = add nsw i64 %indvars.iv44, 1
  %209 = icmp slt i64 %indvars.iv.next45, %57
  br i1 %209, label %if_then.rv.i34.i, label %lambda_279520_vectorize.exit.i.loopexit

cascade_masked_0.i94.i:                           ; preds = %while_head.rv.i45.i
  %210 = bitcast <1 x i64> %191 to <1 x double>
  %211 = fadd <1 x double> %dF_x_SIMD.i37.i, %210
  %bc.i46.i = bitcast <1 x double> %211 to <1 x i64>
  %212 = extractelement <1 x i64> %bc.i46.i, i32 0
  %extract13.i.i = extractelement <1 x i64> %191, i32 0
  %213 = cmpxchg i64* %190, i64 %extract13.i.i, i64 %212 seq_cst seq_cst
  br label %cascade_end.i96.i

cascade_end.i96.i:                                ; preds = %cascade_masked_0.i94.i, %while_head.rv.i45.i
  %214 = phi { i64, i1 } [ undef, %while_head.rv.i45.i ], [ %213, %cascade_masked_0.i94.i ]
  %215 = extractvalue { i64, i1 } %214, 1
  %scalarized.i95.i = insertelement <1 x i1> undef, i1 %215, i64 0
  %while_head.live.upd3554_SIMD.i48.i = xor <1 x i1> %while_head.live_SIMD.i39.i, %edge_while_head.0_SIMD.i41.i
  %next.xupd3655_SIMD.i49.i = or <1 x i1> %edge_while_head.0_SIMD.i41.i, %next.xtrack_SIMD.i40.i
  %216 = extractelement <1 x i1> %while_head.live.upd3554_SIMD.i48.i, i32 0
  br i1 %216, label %while_head.rv.i45.i, label %while_head.divexit.rv.i47.i

cascade_masked_017.i.i:                           ; preds = %while_head5.rv.i56.i
  %217 = bitcast <1 x i64> %196 to <1 x double>
  %218 = fadd <1 x double> %dF_y_SIMD.i50.i, %217
  %bc78.i.i = bitcast <1 x double> %218 to <1 x i64>
  %219 = extractelement <1 x i64> %bc78.i.i, i32 0
  %extract20.i.i = extractelement <1 x i64> %196, i32 0
  %220 = cmpxchg i64* %195, i64 %extract20.i.i, i64 %219 seq_cst seq_cst
  br label %cascade_end18.i.i

cascade_end18.i.i:                                ; preds = %cascade_masked_017.i.i, %while_head5.rv.i56.i
  %221 = phi { i64, i1 } [ undef, %while_head5.rv.i56.i ], [ %220, %cascade_masked_017.i.i ]
  %222 = extractvalue { i64, i1 } %221, 1
  %scalarized22.i.i = insertelement <1 x i1> undef, i1 %222, i64 0
  %while_head5.live.upd3756_SIMD.i58.i = xor <1 x i1> %while_head5.live_SIMD.i51.i, %edge_while_head5.0_SIMD.i53.i
  %next10.xupd3857_SIMD.i59.i = or <1 x i1> %edge_while_head5.0_SIMD.i53.i, %next10.xtrack_SIMD.i52.i
  %223 = extractelement <1 x i1> %while_head5.live.upd3756_SIMD.i58.i, i32 0
  br i1 %223, label %while_head5.rv.i56.i, label %while_head5.divexit.rv.i57.i

cascade_masked_026.i.i:                           ; preds = %while_head11.rv.i66.i
  %224 = bitcast <1 x i64> %201 to <1 x double>
  %225 = fadd <1 x double> %dF_z_SIMD.i60.i, %224
  %bc79.i.i = bitcast <1 x double> %225 to <1 x i64>
  %226 = extractelement <1 x i64> %bc79.i.i, i32 0
  %extract29.i.i = extractelement <1 x i64> %201, i32 0
  %227 = cmpxchg i64* %200, i64 %extract29.i.i, i64 %226 seq_cst seq_cst
  br label %cascade_end27.i.i

cascade_end27.i.i:                                ; preds = %cascade_masked_026.i.i, %while_head11.rv.i66.i
  %228 = phi { i64, i1 } [ undef, %while_head11.rv.i66.i ], [ %227, %cascade_masked_026.i.i ]
  %229 = extractvalue { i64, i1 } %228, 1
  %scalarized31.i.i = insertelement <1 x i1> undef, i1 %229, i64 0
  %while_head11.live.upd3958_SIMD.i68.i = xor <1 x i1> %while_head11.live_SIMD.i61.i, %edge_while_head11.0_SIMD.i63.i
  %next16.xupd4059_SIMD.i69.i = or <1 x i1> %edge_while_head11.0_SIMD.i63.i, %next16.xtrack_SIMD.i62.i
  %230 = extractelement <1 x i1> %while_head11.live.upd3958_SIMD.i68.i, i32 0
  br i1 %230, label %while_head11.rv.i66.i, label %while_head11.divexit.rv.i67.i

cascade_masked_038.i.i:                           ; preds = %while_head17.rv.i75.i
  %scal_mask_mem.i.i = load i64, i64* %204, align 1
  %231 = bitcast i64 %scal_mask_mem.i.i to double
  %extract41.i.i = fsub double %231, %extract41.rhs.i.i
  %232 = bitcast double %extract41.i.i to i64
  %233 = cmpxchg i64* %204, i64 %scal_mask_mem.i.i, i64 %232 seq_cst seq_cst
  br label %cascade_end39.i.i

cascade_end39.i.i:                                ; preds = %while_head17.rv.i75.i, %cascade_masked_038.i.i
  %234 = phi { i64, i1 } [ %233, %cascade_masked_038.i.i ], [ undef, %while_head17.rv.i75.i ]
  %235 = extractvalue { i64, i1 } %234, 1
  %scalarized42.i.i = insertelement <1 x i1> undef, i1 %235, i64 0
  %while_head17.live.upd4160_SIMD.i77.i = xor <1 x i1> %while_head17.live_SIMD.i70.i, %edge_while_head17.0_SIMD.i72.i
  %next22.xupd4261_SIMD.i78.i = or <1 x i1> %edge_while_head17.0_SIMD.i72.i, %next22.xtrack_SIMD.i71.i
  %236 = extractelement <1 x i1> %while_head17.live.upd4160_SIMD.i77.i, i32 0
  br i1 %236, label %while_head17.rv.i75.i, label %while_head17.divexit.rv.i76.i

cascade_masked_053.i.i:                           ; preds = %while_head23.rv.i84.i
  %scal_mask_mem48.i.i = load i64, i64* %206, align 1
  %237 = bitcast i64 %scal_mask_mem48.i.i to double
  %extract56.i.i = fsub double %237, %extract56.rhs.i.i
  %238 = bitcast double %extract56.i.i to i64
  %239 = cmpxchg i64* %206, i64 %scal_mask_mem48.i.i, i64 %238 seq_cst seq_cst
  br label %cascade_end54.i.i

cascade_end54.i.i:                                ; preds = %while_head23.rv.i84.i, %cascade_masked_053.i.i
  %240 = phi { i64, i1 } [ %239, %cascade_masked_053.i.i ], [ undef, %while_head23.rv.i84.i ]
  %241 = extractvalue { i64, i1 } %240, 1
  %scalarized57.i.i = insertelement <1 x i1> undef, i1 %241, i64 0
  %while_head23.live.upd4362_SIMD.i86.i = xor <1 x i1> %while_head23.live_SIMD.i79.i, %edge_while_head23.0_SIMD.i81.i
  %next28.xupd4463_SIMD.i87.i = or <1 x i1> %edge_while_head23.0_SIMD.i81.i, %next28.xtrack_SIMD.i80.i
  %242 = extractelement <1 x i1> %while_head23.live.upd4362_SIMD.i86.i, i32 0
  br i1 %242, label %while_head23.rv.i84.i, label %while_head23.divexit.rv.i85.i

cascade_end69.i.i.thread:                         ; preds = %cascade_end69.i.i.thread.lr.ph, %cascade_end69.i.i.thread
  %edge_while_head29.1_SIMD.i90.i28 = phi <1 x i1> [ %next28.xupd4463_SIMD.i87.i, %cascade_end69.i.i.thread.lr.ph ], [ %edge_while_head29.1_SIMD.i90.i, %cascade_end69.i.i.thread ]
  %scal_mask_mem63.i.i = load i64, i64* %208, align 1
  %243 = bitcast i64 %scal_mask_mem63.i.i to double
  %extract71.i.i = fsub double %243, %extract71.rhs.i.i
  %244 = bitcast double %extract71.i.i to i64
  %245 = cmpxchg i64* %208, i64 %scal_mask_mem63.i.i, i64 %244 seq_cst seq_cst
  %246 = extractvalue { i64, i1 } %245, 1
  %scalarized72.i.i17 = insertelement <1 x i1> undef, i1 %246, i64 0
  %neg.53_SIMD.i89.i = xor <1 x i1> %scalarized72.i.i17, <i1 true>
  %edge_while_head29.1_SIMD.i90.i = and <1 x i1> %edge_while_head29.1_SIMD.i90.i28, %neg.53_SIMD.i89.i
  %extract70.i.i = extractelement <1 x i1> %edge_while_head29.1_SIMD.i90.i, i32 0
  br i1 %extract70.i.i, label %cascade_end69.i.i.thread, label %while_head29.divexit.rv.i92.i.loopexit

lambda_279520_vectorize.exit.i.loopexit:          ; preds = %while_head29.divexit.rv.i92.i
  br label %lambda_279520_vectorize.exit.i

lambda_279520_vectorize.exit.i:                   ; preds = %lambda_279520_vectorize.exit.i.loopexit, %body18.i
  %indvars.iv.next49 = add nsw i64 %indvars.iv48, 1
  %247 = icmp slt i64 %indvars.iv.next49, %166
  br i1 %247, label %body18.i, label %exit19.i.loopexit

exit19.i.loopexit:                                ; preds = %lambda_279520_vectorize.exit.i
  br label %exit19.i

exit19.i:                                         ; preds = %exit19.i.loopexit, %if_then12.i
  %indvars.iv.next51 = add nuw nsw i64 %indvars.iv50, 1
  %exitcond = icmp eq i64 %indvars.iv.next51, %wide.trip.count
  br i1 %exitcond, label %if_else11.i.loopexit, label %if_then12.i

lambda_279188.exit.loopexit:                      ; preds = %if_else4.i
  br label %lambda_279188.exit

lambda_279188.exit:                               ; preds = %lambda_279188.exit.loopexit, %body
  %248 = add nsw i32 %parallel_loop_phi34, 1
  %exitcond57 = icmp eq i32 %248, %2
  br i1 %exitcond57, label %exit.loopexit, label %body

exit.loopexit:                                    ; preds = %lambda_279188.exit
  br label %exit

exit:                                             ; preds = %exit.loopexit, %lambda_279188_parallel_for
  ret void
}

; Function Attrs: nounwind readnone
declare double @llvm.sqrt.f64(double) #1

; Function Attrs: nounwind readonly
declare <1 x double> @llvm.masked.gather.v1f64(<1 x double*>, i32, <1 x i1>, <1 x double>) #4

; Function Attrs: nounwind
declare void @llvm.masked.scatter.v1f64(<1 x double>, <1 x double*>, i32, <1 x i1>) #0

; Function Attrs: nounwind readonly
declare <1 x i64> @llvm.masked.gather.v1i64(<1 x i64*>, i32, <1 x i1>, <1 x i64>) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #5

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
attributes #2 = { norecurse nounwind readnone }
attributes #3 = { norecurse nounwind }
attributes #4 = { nounwind readonly }
attributes #5 = { argmemonly nounwind }
