@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.BC = type { i32 }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = call i8* @malloc ( i32 %tmp2)
  %tmp1 = bitcast i8* %tmp3 to %class.BC*
  %tmp5 = add i32 2, 1
  %tmp6 = add i32 1, 1
  %tmp4 = call i32  @__soma_BC(%class.BC * %tmp1, i32 %tmp5, i32 %tmp6)
  %tmp7 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp8 = call i32 (i8 *, ...)* @printf(i8 * %tmp7, i32 %tmp4)
  %tmp9 = load i32 * %tmp0
  ret i32 %tmp9
}
define i32 @__soma_BC(%class.BC * %this, i32 %a, i32 %b) {
entry1:
  %a_addr = alloca i32
  store i32 %a, i32 * %a_addr
  %b_addr = alloca i32
  store i32 %b, i32 * %b_addr
  %tmp10 = getelementptr %class.BC * %this, i32 0, i32 0
  store i32 3, i32 %tmp10
  %tmp11 = getelementptr %class.BC * %this, i32 0, i32 0
  %tmp12 = load i32 %tmp11
  ret i32 %tmp12
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
