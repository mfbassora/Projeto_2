; ModuleID = 'main.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

define i32 @main() nounwind uwtable ssp {
  %1 = alloca i32, align 4
  %a = alloca i8, align 1
  store i32 0, i32* %1
  store i8 1, i8* %a, align 1
  br label %2

; <label>:2                                       ; preds = %5, %0
  %3 = load i8* %a, align 1
  %4 = trunc i8 %3 to i1
  br i1 %4, label %5, label %6

; <label>:5                                       ; preds = %2
  store i8 0, i8* %a, align 1
  br label %2

; <label>:6                                       ; preds = %2
  ret i32 0
}
