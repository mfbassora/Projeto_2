package llvmast;
public  class LlvmBranch extends LlvmInstruction{
	public LlvmValue condi;
	public LlvmLabelValue t, f;

    public LlvmBranch(LlvmLabelValue label){
    	this.t=label;
    	this.condi=null;
    	this.f=null;
    }
    
    public LlvmBranch(LlvmValue cond,  LlvmLabelValue brTrue, LlvmLabelValue brFalse){
    	this.condi = cond;
    	this.t = brTrue;
    	this.f = brFalse;

    }

    public String toString(){
    	if(this.condi!= null){
    		// branch normal
		return "br i1 "+condi+", label %"+t+", label %"+f;
    	}else{
    		//Branch inicial
    	return "br label %"+t;
    	}
    }
}