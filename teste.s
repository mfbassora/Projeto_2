@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.BC = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = add i32 1, 1
  %tmp2 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp3 = call i32 (i8 *, ...)* @printf(i8 * %tmp2, i32 %tmp1)
  %tmp4 = load i32 * %tmp0
  ret i32 %tmp4
}
define i32 @__soma_BC() {
entry1:
  %c = alloca i32
  %a = alloca i32
  %b = alloca i1
  store i32 3, i32 * %a
  store i1 true, i1 * %b
br label %while2
while2:
  %tmp5 = load i1 * %b
br i1 %tmp5, label %whileEnd3, label %while2
whileEnd3:
  %tmp6 = alloca i32
  %tmp7 = load i32 * %tmp6
  ret i32 %tmp7
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
