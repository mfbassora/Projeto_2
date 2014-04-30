%class.LS_addr = alloca %class.LS *
  store %class.LS * %this, %class.LS * * %class.LS_addr
  %sz_addr = alloca i32
  store i32 %sz, i32 * %sz_addr
  %teste = alloca i32
  store i32 10, i32 * %teste
  %tmp8 = getelementptr %class.LS * %this, i32 0, i32 0
  %tmp9 = load i32 * %teste
  store i32 %tmp9, i32 * %tmp8
  %tmp10 = getelementptr %class.LS * %this, i32 0, i32 0
  %tmp11 = load i32 * %tmp10
  ret i32 %tmp11