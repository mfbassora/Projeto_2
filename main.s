; ModuleID = 'main.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

define void @teste(i32* %test2) nounwind uwtable ssp {
  %1 = alloca i32*, align 8
  store i32* %test2, i32** %1, align 8
  ret void
}

define i32 @main() nounwind uwtable ssp {
  %1 = alloca i32, align 4
  store i32 0, i32* %1
  ret i32 0
}
