; ModuleID = 'main.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

define i32 @main() nounwind uwtable ssp {
  %1 = alloca i32, align 4
  %a = alloca i8, align 1
  %b = alloca i32*, align 8
  %c = alloca [20 x i32], align 16
  store i32 0, i32* %1
  store i8 1, i8* %a, align 1
  %2 = getelementptr inbounds [20 x i32]* %c, i32 0, i32 0
  store i32* %2, i32** %b, align 8
  ret i32 0
}
