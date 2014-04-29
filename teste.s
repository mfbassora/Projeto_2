@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.BC = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp2 = call i32 (i8 *, ...)* @printf(i8 * %tmp1, i32 0)
  %tmp3 = load i32 * %tmp0
  ret i32 %tmp3
}
define i32 @__soma_BC() {
entry1:
  %a = alloca i32 *
  %b = alloca i32
  %c = alloca i32
  store i32 10, i32 * %b
  store i32 20, i32 * %c
  %tmp5 = load i32 * %b
  %tmp6 = load i32 * %c
  %tmp7 = add i32 %tmp5, %tmp6
  %tmp8 = mul i32 4, %tmp7
  %tmp9 = call i8* @malloc ( i32 %tmp8)
  %tmp4 = bitcast i8* %tmp9 to i32*
  store i32 * %tmp4, i32 * * %a
  %tmp10 = add i32 4, 3
  %tmp11 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp12 = call i32 (i8 *, ...)* @printf(i8 * %tmp11, i32 %tmp10)
  %tmp13 = alloca i32
  %tmp14 = load i32 * %tmp13
  ret i32 %tmp14
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
