; ModuleID = 'main.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

define i32 @main() nounwind uwtable ssp {
  %1 = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %d = alloca i32*, align 8
  %2 = alloca i8*
  %3 = alloca i32
  store i32 0, i32* %1
  store i32 3, i32* %a, align 4
  store i32 6, i32* %b, align 4
  %4 = load i32* %a, align 4
  %5 = load i32* %b, align 4
  %6 = add nsw i32 %4, %5
  %7 = zext i32 %6 to i64
  %8 = call i8* @llvm.stacksave()
  store i8* %8, i8** %2
  %9 = alloca i32, i64 %7, align 16
  store i32* %9, i32** %d, align 8
  store i32 0, i32* %1
  store i32 1, i32* %3
  %10 = load i8** %2
  call void @llvm.stackrestore(i8* %10)
  %11 = load i32* %1
  ret i32 %11
}

declare i8* @llvm.stacksave() nounwind

declare void @llvm.stackrestore(i8*) nounwind
