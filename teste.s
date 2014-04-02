@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = load i32 * %tmp0
  ret i32 %tmp1
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
