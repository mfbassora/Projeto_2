package llvmast;
public  class LlvmIcmp extends LlvmInstruction{
	public String cmp;
	public LlvmRegister lhs;
	public int conditionCode;
	public LlvmType type;
	public LlvmValue op1, op2;
    
    public LlvmIcmp(LlvmRegister lhs,  int conditionCode, LlvmType type, LlvmValue op1, LlvmValue op2){
    	this.lhs = lhs;
    	this.conditionCode = conditionCode;
    	this.type = type;
    	this.op1 = op1;
    	this.op2 = op2;
    	
    	if(conditionCode == 1){
    		cmp = "slt";
    	}else if(conditionCode == 2){
    		cmp = "and";
    	}else{
    		cmp = "eq";
    	}
    	System.out.println(cmp);

    }

    public String toString(){
    	if(this.conditionCode == 2){
    		return "and "+type+" "+op1+","+op2;
    	}else{
    		return lhs+" = icmp "+cmp+" "+type+" "+op1+","+" "+op2;
    		
    	}
    }
}