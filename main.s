; ModuleID = 'main.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define i32 @main() nounwind uwtable ssp {
  %1 = alloca i32, align 4
  %num3 = alloca i32, align 4
  store i32 0, i32* %1
  store i32 20, i32* %num3, align 4
  br label %2

; <label>:2                                       ; preds = %5, %0
  %3 = load i32* %num3, align 4
  %4 = icmp slt i32 %3, 23
  br i1 %4, label %5, label %9

; <label>:5                                       ; preds = %2
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 100)
  %7 = load i32* %num3, align 4
  %8 = add nsw i32 %7, 1
  store i32 %8, i32* %num3, align 4
  br label %2

; <label>:9                                       ; preds = %2
  %10 = load i32* %1
  ret i32 %10
}

declare i32 @printf(i8*, ...)
