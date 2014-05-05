@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.Fac = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = call i8* @malloc ( i32 %tmp2)
  %tmp1 = bitcast i8* %tmp3 to %class.Fac*
  %tmp4 = call i32  @__ComputeFac_Fac(%class.Fac * %tmp1, i32 10)
  %tmp5 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp6 = call i32 (i8 *, ...)* @printf(i8 * %tmp5, i32 %tmp4)
  %tmp7 = load i32 * %tmp0
  ret i32 %tmp7
}
define i32 @__ComputeFac_Fac(%class.Fac * %this, i32 %num) {
entry1:
  %class.Fac_addr = alloca %class.Fac *
  store %class.Fac * %this, %class.Fac * * %class.Fac_addr
  %num_addr = alloca i32
  store i32 %num, i32 * %num_addr
  %num_aux = alloca i32
  store i32 10, i32 * %num_aux
  %tmp8 = load i32 * %num_aux
  %tmp9 = load i32 * %num_addr
%tmp10 = icmp eq i32 %tmp8, %tmp9
br i1 %tmp10, label %if.then2, label %if.else3
if.then2:
br label %if.end4
if.else3:
br label %if.end4
if.end4:
  %tmp11 = load i32 * %num_aux
  ret i32 %tmp11
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
