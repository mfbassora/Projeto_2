package llvmast;
import java.util.*;
public  class LlvmAllocaUnic extends LlvmInstruction{
    public LlvmValue lhs;
    public LlvmType type;
    public LlvmValue value;

    public LlvmAllocaUnic(LlvmValue lhs, LlvmType type){
	this.lhs = lhs;
	this.type = type;
	this.value=null;
    }
    public LlvmAllocaUnic(LlvmValue lhs, LlvmValue value){
    	this.lhs = lhs;
    	this.value = value;
    	this.type=null;
        }
    public String toString(){
	
	if(this.value==null){
	return "  " + lhs + " = alloca " + type;
	}else{
	return "  " + lhs + " = alloca " + value;

	}
    }
}
