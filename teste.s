@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.Element = type { i32, i32, i1 }
%class.List = type { label, label, i1 }
%class.LL = type { }
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = call i8* @malloc ( i32 %tmp2)
  %tmp1 = bitcast i8* %tmp3 to %class.LL*
  %tmp4 = call i32  @__Start_LL(%class.LL * %tmp1)
  %tmp5 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp6 = call i32 (i8 *, ...)* @printf(i8 * %tmp5, i32 %tmp4)
  %tmp7 = load i32 * %tmp0
  ret i32 %tmp7
}
define i1 @__Init_Element(%class.Element * %this, i32 %v_Age, i32 %v_Salary, i1 %v_Married) {
entry1:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %v_Age_addr = alloca i32
  store i32 %v_Age, i32 * %v_Age_addr
  %v_Salary_addr = alloca i32
  store i32 %v_Salary, i32 * %v_Salary_addr
  %v_Married_addr = alloca i1
  store i1 %v_Married, i1 * %v_Married_addr
  %tmp8 = getelementptr %class.Element * %this, i32 0, i32 0
  %tmp9 = load i32 * %v_Age_addr
  store i32 %tmp9, i32 * %tmp8
  %tmp10 = getelementptr %class.Element * %this, i32 0, i32 1
  %tmp11 = load i32 * %v_Salary_addr
  store i32 %tmp11, i32 * %tmp10
  %tmp12 = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp13 = load i1 * %v_Married_addr
  store i1 %tmp13, i1 * %tmp12
  ret i1 true
}
define i32 @__GetAge_Element(%class.Element * %this) {
entry2:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %tmp14 = getelementptr %class.Element * %this, i32 0, i32 0
  %tmp15 = load i32 * %tmp14
  ret i32 %tmp15
}
define i32 @__GetSalary_Element(%class.Element * %this) {
entry3:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %tmp16 = getelementptr %class.Element * %this, i32 0, i32 1
  %tmp17 = load i32 * %tmp16
  ret i32 %tmp17
}
define i1 @__GetMarried_Element(%class.Element * %this) {
entry4:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %tmp18 = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp19 = load i1 * %tmp18
  ret i1 %tmp19
}
define i1 @__Equal_Element(%class.Element * %this, label %other) {
entry5:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %other_addr = alloca label
  store label %other, label * %other_addr
  %ret_val = alloca i1
  %aux01 = alloca i32
  %aux02 = alloca i32
  %nt = alloca i32
  store i1 true, i1 * %ret_val
  %tmp20 = load %class.Element * * %other_addr
  %tmp21 = call i32  @__GetAge_Element(%class.Element * %tmp20)
  store i32 %tmp21, i32 * %aux01
  %tmp22 = load %class.Element * * %class.Element_addr
  %tmp24 = load i32 * %aux01
  %tmp25 = getelementptr %class.Element * %this, i32 0, i32 0
  %tmp26 = load i32 * %tmp25
  %tmp23 = call i1  @__Compare_Element(%class.Element * %tmp22, i32 %tmp24, i32 %tmp26)
br i1 %tmp27, label %if.then6, label %if.else7
if.then6:
  store i1 false, i1 * %ret_val
br label %if.end8
if.else7:
br label %if.end8
if.end8:
  %tmp28 = load i1 * %ret_val
  ret i1 %tmp28
}
define i1 @__Compare_Element(%class.Element * %this, i32 %num1, i32 %num2) {
entry9:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %num1_addr = alloca i32
  store i32 %num1, i32 * %num1_addr
  %num2_addr = alloca i32
  store i32 %num2, i32 * %num2_addr
  %retval = alloca i1
  %aux02 = alloca i32
  store i1 false, i1 * %retval
  %tmp29 = load i32 * %num2_addr
  %tmp30 = add i32 %tmp29, 1
  store i32 %tmp30, i32 * %aux02
  %tmp31 = load i32 * %num1_addr
  %tmp32 = load i32 * %num2_addr
%tmp33 = icmp slt i32 %tmp31, %tmp32
br i1 %tmp33, label %if.then10, label %if.else11
if.then10:
  store i1 false, i1 * %retval
br label %if.end12
if.else11:
  %tmp34 = load i32 * %num1_addr
  %tmp35 = load i32 * %aux02
%tmp36 = icmp slt i32 %tmp34, %tmp35
br i1 %tmp37, label %if.then13, label %if.else14
if.then13:
  store i1 false, i1 * %retval
br label %if.end15
if.else14:
  store i1 true, i1 * %retval
br label %if.end15
if.end15:
br label %if.end12
if.end12:
  %tmp38 = load i1 * %retval
  ret i1 %tmp38
}
define i1 @__Init_List(%class.List * %this) {
entry16:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp39 = getelementptr %class.List * %this, i32 0, i32 2
  store i1 true, i1 * %tmp39
  ret i1 true
}
define i1 @__InitNew_List(%class.List * %this, label %v_elem, label %v_next, i1 %v_end) {
entry17:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %v_elem_addr = alloca label
  store label %v_elem, label * %v_elem_addr
  %v_next_addr = alloca label
  store label %v_next, label * %v_next_addr
  %v_end_addr = alloca i1
  store i1 %v_end, i1 * %v_end_addr
  %tmp40 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp41 = load i1 * %v_end_addr
  store i1 %tmp41, i1 * %tmp40
  %tmp42 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp43 = load %class.List * * %v_elem_addr
  store %class.List * %tmp43, label * %tmp42
  %tmp44 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp45 = load %class.List * * %v_next_addr
  store %class.List * %tmp45, label * %tmp44
  ret i1 true
}
define label @__Insert_List(%class.List * %this, label %new_elem) {
entry18:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %new_elem_addr = alloca label
  store label %new_elem, label * %new_elem_addr
  %ret_val = alloca i1
  %aux03 = alloca %class.List *
  %aux02 = alloca %class.List *
  %tmp46 = load %class.List * * %class.List_addr
  store %class.List * %tmp46, %class.List * * %aux03
  %tmp48 = mul i32 1, 1
  %tmp49 = call i8* @malloc ( i32 %tmp48)
  %tmp47 = bitcast i8* %tmp49 to %class.List*
  store %class.List * %tmp47, %class.List * * %aux02
  %tmp50 = load %class.List * * %aux02
  %tmp52 = load %class.List * * %new_elem_addr
  %tmp53 = load %class.List * * %aux03
  %tmp51 = call i1  @__InitNew_List(%class.List * %tmp50, %class.List * %tmp52, %class.List * %tmp53, i1 false)
  store i1 %tmp51, i1 * %ret_val
  %tmp54 = load %class.List * * %aux02
  ret %class.List * %tmp54
}
define i1 @__SetNext_List(%class.List * %this, label %v_next) {
entry19:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %v_next_addr = alloca label
  store label %v_next, label * %v_next_addr
  %tmp55 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp56 = load %class.List * * %v_next_addr
  store %class.List * %tmp56, label * %tmp55
  ret i1 true
}
define label @__Delete_List(%class.List * %this, label %e) {
entry20:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %e_addr = alloca label
  store label %e, label * %e_addr
  %my_head = alloca %class.List *
  %ret_val = alloca i1
  %aux05 = alloca i1
  %aux01 = alloca %class.List *
  %prev = alloca %class.List *
  %var_end = alloca i1
  %var_elem = alloca %class.Element *
  %aux04 = alloca i32
  %nt = alloca i32
  %tmp57 = load %class.List * * %class.List_addr
  store %class.List * %tmp57, %class.List * * %my_head
  store i1 false, i1 * %ret_val
  %tmp58 = sub nsw i32 0, 1
  store i32 %tmp58, i32 * %aux04
  %tmp59 = load %class.List * * %class.List_addr
  store %class.List * %tmp59, %class.List * * %aux01
  %tmp60 = load %class.List * * %class.List_addr
  store %class.List * %tmp60, %class.List * * %prev
  %tmp61 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp62 = load i1 * %tmp61
  store i1 %tmp62, i1 * %var_end
  %tmp63 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp64 = load label * %tmp63
  store label %tmp64, %class.Element * * %var_elem
br label %while21
while21:
  %tmp65 = load i1 * %var_end
  %tmp67 = load i1 * %ret_val
and i1 %tmp66,%tmp68
br i1 %tmp69, label %whileEnd22, label %while21
whileEnd22:
  %tmp70 = load %class.List * * %my_head
  ret %class.List * %tmp70
}
define i32 @__Search_List(%class.List * %this, label %e) {
entry23:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %e_addr = alloca label
  store label %e, label * %e_addr
  %int_ret_val = alloca i32
  %aux01 = alloca %class.List *
  %var_elem = alloca %class.Element *
  %var_end = alloca i1
  %nt = alloca i32
  store i32 0, i32 * %int_ret_val
  %tmp71 = load %class.List * * %class.List_addr
  store %class.List * %tmp71, %class.List * * %aux01
  %tmp72 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp73 = load i1 * %tmp72
  store i1 %tmp73, i1 * %var_end
  %tmp74 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp75 = load label * %tmp74
  store label %tmp75, %class.Element * * %var_elem
br label %while24
while24:
  %tmp76 = load i1 * %var_end
br i1 %tmp77, label %whileEnd25, label %while24
whileEnd25:
  %tmp78 = load i32 * %int_ret_val
  ret i32 %tmp78
}
define i1 @__GetEnd_List(%class.List * %this) {
entry26:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp79 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp80 = load i1 * %tmp79
  ret i1 %tmp80
}
define label @__GetElem_List(%class.List * %this) {
entry27:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp81 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp82 = load label * %tmp81
  ret label %tmp82
}
define label @__GetNext_List(%class.List * %this) {
entry28:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp83 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp84 = load label * %tmp83
  ret label %tmp84
}
define i1 @__Print_List(%class.List * %this) {
entry29:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %aux01 = alloca %class.List *
  %var_end = alloca i1
  %var_elem = alloca %class.Element *
  %tmp85 = load %class.List * * %class.List_addr
  store %class.List * %tmp85, %class.List * * %aux01
  %tmp86 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp87 = load i1 * %tmp86
  store i1 %tmp87, i1 * %var_end
  %tmp88 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp89 = load label * %tmp88
  store label %tmp89, %class.Element * * %var_elem
br label %while30
while30:
  %tmp90 = load i1 * %var_end
br i1 %tmp91, label %whileEnd31, label %while30
whileEnd31:
  ret i1 true
}
define i32 @__Start_LL(%class.LL * %this) {
entry32:
  %class.LL_addr = alloca %class.LL *
  store %class.LL * %this, %class.LL * * %class.LL_addr
  %head = alloca %class.List *
  %last_elem = alloca %class.List *
  %aux01 = alloca i1
  %el01 = alloca %class.Element *
  %el02 = alloca %class.Element *
  %el03 = alloca %class.Element *
  %tmp93 = mul i32 1, 1
  %tmp94 = call i8* @malloc ( i32 %tmp93)
  %tmp92 = bitcast i8* %tmp94 to %class.List*
  store %class.List * %tmp92, %class.List * * %last_elem
  %tmp95 = load %class.List * * %last_elem
  %tmp96 = call i1  @__Init_List(%class.List * %tmp95)
  store i1 %tmp96, i1 * %aux01
  %tmp97 = load %class.List * * %last_elem
  store %class.List * %tmp97, %class.List * * %head
  %tmp98 = load %class.List * * %head
  %tmp99 = call i1  @__Init_List(%class.List * %tmp98)
  store i1 %tmp99, i1 * %aux01
  %tmp100 = load %class.List * * %head
  %tmp101 = call i1  @__Print_List(%class.List * %tmp100)
  store i1 %tmp101, i1 * %aux01
  %tmp103 = mul i32 1, 1
  %tmp104 = call i8* @malloc ( i32 %tmp103)
  %tmp102 = bitcast i8* %tmp104 to %class.Element*
  store %class.Element * %tmp102, %class.Element * * %el01
  %tmp105 = load %class.Element * * %el01
  %tmp106 = call i1  @__Init_Element(%class.Element * %tmp105, i32 25, i32 37000, i1 false)
  store i1 %tmp106, i1 * %aux01
  %tmp107 = load %class.List * * %head
  %tmp109 = load %class.Element * * %el01
  %tmp108 = call label  @__Insert_Element(%class.List * %tmp107, %class.Element * %tmp109)
  store label %tmp108, %class.List * * %head
  %tmp110 = load %class.List * * %head
  %tmp111 = call i1  @__Print_Element(%class.List * %tmp110)
  store i1 %tmp111, i1 * %aux01
  %tmp112 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp113 = call i32 (i8 *, ...)* @printf(i8 * %tmp112, i32 10000000)
  %tmp115 = mul i32 1, 1
  %tmp116 = call i8* @malloc ( i32 %tmp115)
  %tmp114 = bitcast i8* %tmp116 to %class.Element*
  store %class.Element * %tmp114, %class.Element * * %el01
  %tmp117 = load %class.Element * * %el01
  %tmp118 = call i1  @__Init_Element(%class.Element * %tmp117, i32 39, i32 42000, i1 true)
  store i1 %tmp118, i1 * %aux01
  %tmp119 = load %class.Element * * %el01
  store %class.Element * %tmp119, %class.Element * * %el02
  %tmp120 = load %class.List * * %head
  %tmp122 = load %class.Element * * %el01
  %tmp121 = call label  @__Insert_Element(%class.List * %tmp120, %class.Element * %tmp122)
  store label %tmp121, %class.List * * %head
  %tmp123 = load %class.List * * %head
  %tmp124 = call i1  @__Print_Element(%class.List * %tmp123)
  store i1 %tmp124, i1 * %aux01
  %tmp125 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp126 = call i32 (i8 *, ...)* @printf(i8 * %tmp125, i32 10000000)
  %tmp128 = mul i32 1, 1
  %tmp129 = call i8* @malloc ( i32 %tmp128)
  %tmp127 = bitcast i8* %tmp129 to %class.Element*
  store %class.Element * %tmp127, %class.Element * * %el01
  %tmp130 = load %class.Element * * %el01
  %tmp131 = call i1  @__Init_Element(%class.Element * %tmp130, i32 22, i32 34000, i1 false)
  store i1 %tmp131, i1 * %aux01
  %tmp132 = load %class.List * * %head
  %tmp134 = load %class.Element * * %el01
  %tmp133 = call label  @__Insert_Element(%class.List * %tmp132, %class.Element * %tmp134)
  store label %tmp133, %class.List * * %head
  %tmp135 = load %class.List * * %head
  %tmp136 = call i1  @__Print_Element(%class.List * %tmp135)
  store i1 %tmp136, i1 * %aux01
  %tmp138 = mul i32 1, 1
  %tmp139 = call i8* @malloc ( i32 %tmp138)
  %tmp137 = bitcast i8* %tmp139 to %class.Element*
  store %class.Element * %tmp137, %class.Element * * %el03
  %tmp140 = load %class.Element * * %el03
  %tmp141 = call i1  @__Init_Element(%class.Element * %tmp140, i32 27, i32 34000, i1 false)
  store i1 %tmp141, i1 * %aux01
  %tmp142 = load %class.List * * %head
  %tmp144 = load %class.Element * * %el02
  %tmp143 = call i32  @__Search_Element(%class.List * %tmp142, %class.Element * %tmp144)
  %tmp145 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp146 = call i32 (i8 *, ...)* @printf(i8 * %tmp145, i32 %tmp143)
  %tmp147 = load %class.List * * %head
  %tmp149 = load %class.Element * * %el03
  %tmp148 = call i32  @__Search_Element(%class.List * %tmp147, %class.Element * %tmp149)
  %tmp150 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp151 = call i32 (i8 *, ...)* @printf(i8 * %tmp150, i32 %tmp148)
  %tmp152 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp153 = call i32 (i8 *, ...)* @printf(i8 * %tmp152, i32 10000000)
  %tmp155 = mul i32 1, 1
  %tmp156 = call i8* @malloc ( i32 %tmp155)
  %tmp154 = bitcast i8* %tmp156 to %class.Element*
  store %class.Element * %tmp154, %class.Element * * %el01
  %tmp157 = load %class.Element * * %el01
  %tmp158 = call i1  @__Init_Element(%class.Element * %tmp157, i32 28, i32 35000, i1 false)
  store i1 %tmp158, i1 * %aux01
  %tmp159 = load %class.List * * %head
  %tmp161 = load %class.Element * * %el01
  %tmp160 = call label  @__Insert_Element(%class.List * %tmp159, %class.Element * %tmp161)
  store label %tmp160, %class.List * * %head
  %tmp162 = load %class.List * * %head
  %tmp163 = call i1  @__Print_Element(%class.List * %tmp162)
  store i1 %tmp163, i1 * %aux01
  %tmp164 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp165 = call i32 (i8 *, ...)* @printf(i8 * %tmp164, i32 2220000)
  %tmp166 = load %class.List * * %head
  %tmp168 = load %class.Element * * %el02
  %tmp167 = call label  @__Delete_Element(%class.List * %tmp166, %class.Element * %tmp168)
  store label %tmp167, %class.List * * %head
  %tmp169 = load %class.List * * %head
  %tmp170 = call i1  @__Print_Element(%class.List * %tmp169)
  store i1 %tmp170, i1 * %aux01
  %tmp171 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp172 = call i32 (i8 *, ...)* @printf(i8 * %tmp171, i32 33300000)
  %tmp173 = load %class.List * * %head
  %tmp175 = load %class.Element * * %el01
  %tmp174 = call label  @__Delete_Element(%class.List * %tmp173, %class.Element * %tmp175)
  store label %tmp174, %class.List * * %head
  %tmp176 = load %class.List * * %head
  %tmp177 = call i1  @__Print_Element(%class.List * %tmp176)
  store i1 %tmp177, i1 * %aux01
  %tmp178 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp179 = call i32 (i8 *, ...)* @printf(i8 * %tmp178, i32 44440000)
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
