package llvmast;
import java.util.*;
public  class LlvmAllocaUnic extends LlvmInstruction{
    public LlvmValue lhs;
    public LlvmType type;
    

    public LlvmAllocaUnic(LlvmValue lhs, LlvmType type){
	this.lhs = lhs;
	this.type = type;
    }

    public String toString(){
	
	
	return "  " + lhs + " = alloca " + type;
    }
}
