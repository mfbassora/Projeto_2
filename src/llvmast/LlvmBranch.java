package llvmast;
public  class LlvmBranch extends LlvmInstruction{
	public LlvmValue condi;
	public LlvmLabelValue t, f;

    public LlvmBranch(LlvmLabelValue label){

    }
    
    public LlvmBranch(LlvmValue cond,  LlvmLabelValue brTrue, LlvmLabelValue brFalse){
    	this.condi = cond;
    	this.t = brTrue;
    	this.f = brFalse;

    }

    public String toString(){
		return null;
    }
}