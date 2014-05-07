@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%class.Element = type { i32, i32, i1 }
%class.List = type { %class.Element *, %class.List *, i1 }
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
define i1 @__Equal_Element(%class.Element * %this, %class.Element * %other) {
entry5:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %other_addr = alloca %class.Element *
  store %class.Element * %other, %class.Element * * %other_addr
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
  %tmp27 = xor i1 %tmp23, true
br i1 %tmp27, label %if.then6, label %if.else7
if.then6:
  store i1 false, i1 * %ret_val
br label %if.end8
if.else7:
  %tmp28 = load %class.Element * * %other_addr
  %tmp29 = call i32  @__GetSalary_Element(%class.Element * %tmp28)
  store i32 %tmp29, i32 * %aux02
  %tmp30 = load %class.Element * * %class.Element_addr
  %tmp32 = load i32 * %aux02
  %tmp33 = getelementptr %class.Element * %this, i32 0, i32 1
  %tmp34 = load i32 * %tmp33
  %tmp31 = call i1  @__Compare_Element(%class.Element * %tmp30, i32 %tmp32, i32 %tmp34)
  %tmp35 = xor i1 %tmp31, true
br i1 %tmp35, label %if.then9, label %if.else10
if.then9:
  store i1 false, i1 * %ret_val
br label %if.end11
if.else10:
  %tmp36 = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp37 = load i1 * %tmp36
br i1 %tmp37, label %if.then12, label %if.else13
if.then12:
  %tmp38 = load %class.Element * * %other_addr
  %tmp39 = call i1  @__GetMarried_Element(%class.Element * %tmp38)
  %tmp40 = xor i1 %tmp39, true
br i1 %tmp40, label %if.then15, label %if.else16
if.then15:
  store i1 false, i1 * %ret_val
br label %if.end17
if.else16:
  store i32 0, i32 * %nt
br label %if.end17
if.end17:
br label %if.end14
if.else13:
  %tmp41 = load %class.Element * * %other_addr
  %tmp42 = call i1  @__GetMarried_Element(%class.Element * %tmp41)
br i1 %tmp42, label %if.then18, label %if.else19
if.then18:
  store i1 false, i1 * %ret_val
br label %if.end20
if.else19:
  store i32 0, i32 * %nt
br label %if.end20
if.end20:
br label %if.end14
if.end14:
br label %if.end11
if.end11:
br label %if.end8
if.end8:
  %tmp43 = load i1 * %ret_val
  ret i1 %tmp43
}
define i1 @__Compare_Element(%class.Element * %this, i32 %num1, i32 %num2) {
entry21:
  %class.Element_addr = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %class.Element_addr
  %num1_addr = alloca i32
  store i32 %num1, i32 * %num1_addr
  %num2_addr = alloca i32
  store i32 %num2, i32 * %num2_addr
  %retval = alloca i1
  %aux02 = alloca i32
  store i1 false, i1 * %retval
  %tmp44 = load i32 * %num2_addr
  %tmp45 = add i32 %tmp44, 1
  store i32 %tmp45, i32 * %aux02
  %tmp46 = load i32 * %num1_addr
  %tmp47 = load i32 * %num2_addr
%tmp48 = icmp slt i32 %tmp46, %tmp47
br i1 %tmp48, label %if.then22, label %if.else23
if.then22:
  store i1 false, i1 * %retval
br label %if.end24
if.else23:
  %tmp49 = load i32 * %num1_addr
  %tmp50 = load i32 * %aux02
%tmp51 = icmp slt i32 %tmp49, %tmp50
  %tmp52 = xor i1 %tmp51, true
br i1 %tmp52, label %if.then25, label %if.else26
if.then25:
  store i1 false, i1 * %retval
br label %if.end27
if.else26:
  store i1 true, i1 * %retval
br label %if.end27
if.end27:
br label %if.end24
if.end24:
  %tmp53 = load i1 * %retval
  ret i1 %tmp53
}
define i1 @__Init_List(%class.List * %this) {
entry28:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp54 = getelementptr %class.List * %this, i32 0, i32 2
  store i1 true, i1 * %tmp54
  ret i1 true
}
define i1 @__InitNew_List(%class.List * %this, %class.Element * %v_elem, %class.List * %v_next, i1 %v_end) {
entry29:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %v_elem_addr = alloca %class.Element *
  store %class.Element * %v_elem, %class.Element * * %v_elem_addr
  %v_next_addr = alloca %class.List *
  store %class.List * %v_next, %class.List * * %v_next_addr
  %v_end_addr = alloca i1
  store i1 %v_end, i1 * %v_end_addr
  %tmp55 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp56 = load i1 * %v_end_addr
  store i1 %tmp56, i1 * %tmp55
  %tmp57 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp58 = load %class.Element * * %v_elem_addr
  store %class.Element * %tmp58, %class.Element * * %tmp57
  %tmp59 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp60 = load %class.List * * %v_next_addr
  store %class.List * %tmp60, %class.List * * %tmp59
  ret i1 true
}
define %class.List * @__Insert_List(%class.List * %this, %class.Element * %new_elem) {
entry30:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %new_elem_addr = alloca %class.Element *
  store %class.Element * %new_elem, %class.Element * * %new_elem_addr
  %ret_val = alloca i1
  %aux03 = alloca %class.List *
  %aux02 = alloca %class.List *
  %tmp61 = load %class.List * * %class.List_addr
  store %class.List * %tmp61, %class.List * * %aux03
  %tmp63 = mul i32 1, 1
  %tmp64 = call i8* @malloc ( i32 %tmp63)
  %tmp62 = bitcast i8* %tmp64 to %class.List*
  store %class.List * %tmp62, %class.List * * %aux02
  %tmp65 = load %class.List * * %aux02
  %tmp67 = load %class.Element * * %new_elem_addr
  %tmp68 = load %class.List * * %aux03
  %tmp66 = call i1  @__InitNew_List(%class.List * %tmp65, %class.Element * %tmp67, %class.List * %tmp68, i1 false)
  store i1 %tmp66, i1 * %ret_val
  %tmp69 = load %class.List * * %aux02
  ret %class.List * %tmp69
}
define i1 @__SetNext_List(%class.List * %this, %class.List * %v_next) {
entry31:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %v_next_addr = alloca %class.List *
  store %class.List * %v_next, %class.List * * %v_next_addr
  %tmp70 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp71 = load %class.List * * %v_next_addr
  store %class.List * %tmp71, %class.List * * %tmp70
  ret i1 true
}
define %class.List * @__Delete_List(%class.List * %this, %class.Element * %e) {
entry32:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %e_addr = alloca %class.Element *
  store %class.Element * %e, %class.Element * * %e_addr
  %my_head = alloca %class.List *
  %ret_val = alloca i1
  %aux05 = alloca i1
  %aux01 = alloca %class.List *
  %prev = alloca %class.List *
  %var_end = alloca i1
  %var_elem = alloca %class.Element *
  %aux04 = alloca i32
  %nt = alloca i32
  %tmp72 = load %class.List * * %class.List_addr
  store %class.List * %tmp72, %class.List * * %my_head
  store i1 false, i1 * %ret_val
  %tmp73 = sub nsw i32 0, 1
  store i32 %tmp73, i32 * %aux04
  %tmp74 = load %class.List * * %class.List_addr
  store %class.List * %tmp74, %class.List * * %aux01
  %tmp75 = load %class.List * * %class.List_addr
  store %class.List * %tmp75, %class.List * * %prev
  %tmp76 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp77 = load i1 * %tmp76
  store i1 %tmp77, i1 * %var_end
  %tmp78 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp79 = load %class.Element * * %tmp78
  store %class.Element * %tmp79, %class.Element * * %var_elem
br label %whileTest33
whileTest33:
  %tmp80 = load i1 * %var_end
  %tmp81 = xor i1 %tmp80, true
  %tmp82 = load i1 * %ret_val
  %tmp83 = xor i1 %tmp82, true
 %tmp84 = and i1 %tmp81,%tmp83
br i1 %tmp84, label %whileBody34, label %whileEnd35
whileBody34:
  %tmp85 = load %class.Element * * %e_addr
  %tmp87 = load %class.Element * * %var_elem
  %tmp86 = call i1  @__Equal_Element(%class.Element * %tmp85, %class.Element * %tmp87)
br i1 %tmp86, label %if.then36, label %if.else37
if.then36:
  store i1 true, i1 * %ret_val
  %tmp88 = load i32 * %aux04
%tmp89 = icmp slt i32 %tmp88, 0
br i1 %tmp89, label %if.then39, label %if.else40
if.then39:
  %tmp90 = load %class.List * * %aux01
  %tmp91 = call %class.List *  @__GetNext_List(%class.List * %tmp90)
  store %class.List * %tmp91, %class.List * * %my_head
br label %if.end41
if.else40:
  %tmp92 = sub nsw i32 0, 555
  %tmp93 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp94 = call i32 (i8 *, ...)* @printf(i8 * %tmp93, i32 %tmp92)
  %tmp95 = load %class.List * * %prev
  %tmp97 = load %class.List * * %aux01
  %tmp98 = call %class.List *  @__GetNext_List(%class.List * %tmp97)
  %tmp96 = call i1  @__SetNext_List(%class.List * %tmp95, %class.List * %tmp98)
  store i1 %tmp96, i1 * %aux05
  %tmp99 = sub nsw i32 0, 555
  %tmp100 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp101 = call i32 (i8 *, ...)* @printf(i8 * %tmp100, i32 %tmp99)
br label %if.end41
if.end41:
br label %if.end38
if.else37:
  store i32 0, i32 * %nt
br label %if.end38
if.end38:
  %tmp102 = load i1 * %ret_val
  %tmp103 = xor i1 %tmp102, true
br i1 %tmp103, label %if.then42, label %if.else43
if.then42:
  %tmp104 = load %class.List * * %aux01
  store %class.List * %tmp104, %class.List * * %prev
  %tmp105 = load %class.List * * %aux01
  %tmp106 = call %class.List *  @__GetNext_List(%class.List * %tmp105)
  store %class.List * %tmp106, %class.List * * %aux01
  %tmp107 = load %class.List * * %aux01
  %tmp108 = call i1  @__GetEnd_List(%class.List * %tmp107)
  store i1 %tmp108, i1 * %var_end
  %tmp109 = load %class.List * * %aux01
  %tmp110 = call %class.Element *  @__GetElem_List(%class.List * %tmp109)
  store %class.Element * %tmp110, %class.Element * * %var_elem
  store i32 1, i32 * %aux04
br label %if.end44
if.else43:
  store i32 0, i32 * %nt
br label %if.end44
if.end44:
br label %whileTest33
whileEnd35:
  %tmp111 = load %class.List * * %my_head
  ret %class.List * %tmp111
}
define i32 @__Search_List(%class.List * %this, %class.Element * %e) {
entry45:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %e_addr = alloca %class.Element *
  store %class.Element * %e, %class.Element * * %e_addr
  %int_ret_val = alloca i32
  %aux01 = alloca %class.List *
  %var_elem = alloca %class.Element *
  %var_end = alloca i1
  %nt = alloca i32
  store i32 0, i32 * %int_ret_val
  %tmp112 = load %class.List * * %class.List_addr
  store %class.List * %tmp112, %class.List * * %aux01
  %tmp113 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp114 = load i1 * %tmp113
  store i1 %tmp114, i1 * %var_end
  %tmp115 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp116 = load %class.Element * * %tmp115
  store %class.Element * %tmp116, %class.Element * * %var_elem
br label %whileTest46
whileTest46:
  %tmp117 = load i1 * %var_end
  %tmp118 = xor i1 %tmp117, true
br i1 %tmp118, label %whileBody47, label %whileEnd48
whileBody47:
  %tmp119 = load %class.Element * * %e_addr
  %tmp121 = load %class.Element * * %var_elem
  %tmp120 = call i1  @__Equal_Element(%class.Element * %tmp119, %class.Element * %tmp121)
br i1 %tmp120, label %if.then49, label %if.else50
if.then49:
  store i32 1, i32 * %int_ret_val
br label %if.end51
if.else50:
  store i32 0, i32 * %nt
br label %if.end51
if.end51:
  %tmp122 = load %class.List * * %aux01
  %tmp123 = call %class.List *  @__GetNext_List(%class.List * %tmp122)
  store %class.List * %tmp123, %class.List * * %aux01
  %tmp124 = load %class.List * * %aux01
  %tmp125 = call i1  @__GetEnd_List(%class.List * %tmp124)
  store i1 %tmp125, i1 * %var_end
  %tmp126 = load %class.List * * %aux01
  %tmp127 = call %class.Element *  @__GetElem_List(%class.List * %tmp126)
  store %class.Element * %tmp127, %class.Element * * %var_elem
br label %whileTest46
whileEnd48:
  %tmp128 = load i32 * %int_ret_val
  ret i32 %tmp128
}
define i1 @__GetEnd_List(%class.List * %this) {
entry52:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp129 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp130 = load i1 * %tmp129
  ret i1 %tmp130
}
define %class.Element * @__GetElem_List(%class.List * %this) {
entry53:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp131 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp132 = load %class.Element * * %tmp131
  ret %class.Element * %tmp132
}
define %class.List * @__GetNext_List(%class.List * %this) {
entry54:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %tmp133 = getelementptr %class.List * %this, i32 0, i32 1
  %tmp134 = load %class.List * * %tmp133
  ret %class.List * %tmp134
}
define i1 @__Print_List(%class.List * %this) {
entry55:
  %class.List_addr = alloca %class.List *
  store %class.List * %this, %class.List * * %class.List_addr
  %aux01 = alloca %class.List *
  %var_end = alloca i1
  %var_elem = alloca %class.Element *
  %tmp135 = load %class.List * * %class.List_addr
  store %class.List * %tmp135, %class.List * * %aux01
  %tmp136 = getelementptr %class.List * %this, i32 0, i32 2
  %tmp137 = load i1 * %tmp136
  store i1 %tmp137, i1 * %var_end
  %tmp138 = getelementptr %class.List * %this, i32 0, i32 0
  %tmp139 = load %class.Element * * %tmp138
  store %class.Element * %tmp139, %class.Element * * %var_elem
br label %whileTest56
whileTest56:
  %tmp140 = load i1 * %var_end
  %tmp141 = xor i1 %tmp140, true
br i1 %tmp141, label %whileBody57, label %whileEnd58
whileBody57:
  %tmp142 = load %class.Element * * %var_elem
  %tmp143 = call i32  @__GetAge_Element(%class.Element * %tmp142)
  %tmp144 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp145 = call i32 (i8 *, ...)* @printf(i8 * %tmp144, i32 %tmp143)
  %tmp146 = load %class.List * * %aux01
  %tmp147 = call %class.List *  @__GetNext_List(%class.List * %tmp146)
  store %class.List * %tmp147, %class.List * * %aux01
  %tmp148 = load %class.List * * %aux01
  %tmp149 = call i1  @__GetEnd_List(%class.List * %tmp148)
  store i1 %tmp149, i1 * %var_end
  %tmp150 = load %class.List * * %aux01
  %tmp151 = call %class.Element *  @__GetElem_List(%class.List * %tmp150)
  store %class.Element * %tmp151, %class.Element * * %var_elem
br label %whileTest56
whileEnd58:
  ret i1 true
}
define i32 @__Start_LL(%class.LL * %this) {
entry59:
  %class.LL_addr = alloca %class.LL *
  store %class.LL * %this, %class.LL * * %class.LL_addr
  %head = alloca %class.List *
  %last_elem = alloca %class.List *
  %aux01 = alloca i1
  %el01 = alloca %class.Element *
  %el02 = alloca %class.Element *
  %el03 = alloca %class.Element *
  %tmp153 = mul i32 1, 1
  %tmp154 = call i8* @malloc ( i32 %tmp153)
  %tmp152 = bitcast i8* %tmp154 to %class.List*
  store %class.List * %tmp152, %class.List * * %last_elem
  %tmp155 = load %class.List * * %last_elem
  %tmp156 = call i1  @__Init_List(%class.List * %tmp155)
  store i1 %tmp156, i1 * %aux01
  %tmp157 = load %class.List * * %last_elem
  store %class.List * %tmp157, %class.List * * %head
  %tmp158 = load %class.List * * %head
  %tmp159 = call i1  @__Init_List(%class.List * %tmp158)
  store i1 %tmp159, i1 * %aux01
  %tmp160 = load %class.List * * %head
  %tmp161 = call i1  @__Print_List(%class.List * %tmp160)
  store i1 %tmp161, i1 * %aux01
  %tmp163 = mul i32 1, 1
  %tmp164 = call i8* @malloc ( i32 %tmp163)
  %tmp162 = bitcast i8* %tmp164 to %class.Element*
  store %class.Element * %tmp162, %class.Element * * %el01
  %tmp165 = load %class.Element * * %el01
  %tmp166 = call i1  @__Init_List(%class.Element * %tmp165, i32 25, i32 37000, i1 false)
  store i1 %tmp166, i1 * %aux01
  %tmp167 = load %class.List * * %head
  %tmp169 = load %class.Element * * %el01
  %tmp168 = call %class.List *  @__Insert_List(%class.List * %tmp167, %class.Element * %tmp169)
  store %class.List * %tmp168, %class.List * * %head
  %tmp170 = load %class.List * * %head
  %tmp171 = call i1  @__Print_List(%class.List * %tmp170)
  store i1 %tmp171, i1 * %aux01
  %tmp172 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp173 = call i32 (i8 *, ...)* @printf(i8 * %tmp172, i32 10000000)
  %tmp175 = mul i32 1, 1
  %tmp176 = call i8* @malloc ( i32 %tmp175)
  %tmp174 = bitcast i8* %tmp176 to %class.Element*
  store %class.Element * %tmp174, %class.Element * * %el01
  %tmp177 = load %class.Element * * %el01
  %tmp178 = call i1  @__Init_List(%class.Element * %tmp177, i32 39, i32 42000, i1 true)
  store i1 %tmp178, i1 * %aux01
  %tmp179 = load %class.Element * * %el01
  store %class.Element * %tmp179, %class.Element * * %el02
  %tmp180 = load %class.List * * %head
  %tmp182 = load %class.Element * * %el01
  %tmp181 = call %class.List *  @__Insert_List(%class.List * %tmp180, %class.Element * %tmp182)
  store %class.List * %tmp181, %class.List * * %head
  %tmp183 = load %class.List * * %head
  %tmp184 = call i1  @__Print_List(%class.List * %tmp183)
  store i1 %tmp184, i1 * %aux01
  %tmp185 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp186 = call i32 (i8 *, ...)* @printf(i8 * %tmp185, i32 10000000)
  %tmp188 = mul i32 1, 1
  %tmp189 = call i8* @malloc ( i32 %tmp188)
  %tmp187 = bitcast i8* %tmp189 to %class.Element*
  store %class.Element * %tmp187, %class.Element * * %el01
  %tmp190 = load %class.Element * * %el01
  %tmp191 = call i1  @__Init_List(%class.Element * %tmp190, i32 22, i32 34000, i1 false)
  store i1 %tmp191, i1 * %aux01
  %tmp192 = load %class.List * * %head
  %tmp194 = load %class.Element * * %el01
  %tmp193 = call %class.List *  @__Insert_List(%class.List * %tmp192, %class.Element * %tmp194)
  store %class.List * %tmp193, %class.List * * %head
  %tmp195 = load %class.List * * %head
  %tmp196 = call i1  @__Print_List(%class.List * %tmp195)
  store i1 %tmp196, i1 * %aux01
  %tmp198 = mul i32 1, 1
  %tmp199 = call i8* @malloc ( i32 %tmp198)
  %tmp197 = bitcast i8* %tmp199 to %class.Element*
  store %class.Element * %tmp197, %class.Element * * %el03
  %tmp200 = load %class.Element * * %el03
  %tmp201 = call i1  @__Init_List(%class.Element * %tmp200, i32 27, i32 34000, i1 false)
  store i1 %tmp201, i1 * %aux01
  %tmp202 = load %class.List * * %head
  %tmp204 = load %class.Element * * %el02
  %tmp203 = call i32  @__Search_List(%class.List * %tmp202, %class.Element * %tmp204)
  %tmp205 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp206 = call i32 (i8 *, ...)* @printf(i8 * %tmp205, i32 %tmp203)
  %tmp207 = load %class.List * * %head
  %tmp209 = load %class.Element * * %el03
  %tmp208 = call i32  @__Search_List(%class.List * %tmp207, %class.Element * %tmp209)
  %tmp210 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp211 = call i32 (i8 *, ...)* @printf(i8 * %tmp210, i32 %tmp208)
  %tmp212 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp213 = call i32 (i8 *, ...)* @printf(i8 * %tmp212, i32 10000000)
  %tmp215 = mul i32 1, 1
  %tmp216 = call i8* @malloc ( i32 %tmp215)
  %tmp214 = bitcast i8* %tmp216 to %class.Element*
  store %class.Element * %tmp214, %class.Element * * %el01
  %tmp217 = load %class.Element * * %el01
  %tmp218 = call i1  @__Init_List(%class.Element * %tmp217, i32 28, i32 35000, i1 false)
  store i1 %tmp218, i1 * %aux01
  %tmp219 = load %class.List * * %head
  %tmp221 = load %class.Element * * %el01
  %tmp220 = call %class.List *  @__Insert_List(%class.List * %tmp219, %class.Element * %tmp221)
  store %class.List * %tmp220, %class.List * * %head
  %tmp222 = load %class.List * * %head
  %tmp223 = call i1  @__Print_List(%class.List * %tmp222)
  store i1 %tmp223, i1 * %aux01
  %tmp224 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp225 = call i32 (i8 *, ...)* @printf(i8 * %tmp224, i32 2220000)
  %tmp226 = load %class.List * * %head
  %tmp228 = load %class.Element * * %el02
  %tmp227 = call %class.List *  @__Delete_List(%class.List * %tmp226, %class.Element * %tmp228)
  store %class.List * %tmp227, %class.List * * %head
  %tmp229 = load %class.List * * %head
  %tmp230 = call i1  @__Print_List(%class.List * %tmp229)
  store i1 %tmp230, i1 * %aux01
  %tmp231 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp232 = call i32 (i8 *, ...)* @printf(i8 * %tmp231, i32 33300000)
  %tmp233 = load %class.List * * %head
  %tmp235 = load %class.Element * * %el01
  %tmp234 = call %class.List *  @__Delete_List(%class.List * %tmp233, %class.Element * %tmp235)
  store %class.List * %tmp234, %class.List * * %head
  %tmp236 = load %class.List * * %head
  %tmp237 = call i1  @__Print_List(%class.List * %tmp236)
  store i1 %tmp237, i1 * %aux01
  %tmp238 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp239 = call i32 (i8 *, ...)* @printf(i8 * %tmp238, i32 44440000)
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
