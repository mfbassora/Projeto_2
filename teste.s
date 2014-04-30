@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.BC = type { }
%class.CD = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = call i8* @malloc ( i32 %tmp2)
  %tmp1 = bitcast i8* %tmp3 to %BC*
  %tmp4 = call i32 ()* @__soma_BC({ } * %tmp1, i32 1, i32 18)
  %tmp5 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp6 = call i32 (i8 *, ...)* @printf(i8 * %tmp5, i32 %tmp4)
  %tmp7 = load i32 * %tmp0
  ret i32 %tmp7
}
define i32 @__soma_BC(i32 %a, i32 %b) {
entry1:
  %tree = alloca label
  %tmp9 = mul i32 1, 1
  %tmp10 = call i8* @malloc ( i32 %tmp9)
  %tmp8 = bitcast i8* %tmp10 to %CD*
  store { } * %tmp8, { } * %class.tree
  %tmp11 = alloca i32
  %tmp12 = load i32 * %tmp11
  ret i32 %tmp12
}
define i32 @__soma_CD(i1 %d) {
entry2:
  %tmp13 = alloca i32
  %tmp14 = load i32 * %tmp13
  ret i32 %tmp14
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
declare i32 @__soma_BC (i32, i32)
declare i32 @__soma_CD (i1)
