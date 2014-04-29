@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.BC = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = add i32 1, 3
  %tmp2 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp3 = call i32 (i8 *, ...)* @printf(i8 * %tmp2, i32 %tmp1)
  %tmp4 = load i32 * %tmp0
  ret i32 %tmp4
}
define i32 @__soma_BC() {
entry1:
  %a = alloca i32 *
  %tmp6 = mul i32 1, 10
  %tmp7 = call i8* @malloc ( i32 %tmp6)
  %tmp5 = bitcast i8* %tmp7 to i32 **
  store i32 * %tmp5, i32 * * %a
  %tmp8 = alloca i32
  %tmp9 = load i32 * %tmp8
  ret i32 %tmp9
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
