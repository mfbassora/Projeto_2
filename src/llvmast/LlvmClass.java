package llvmast;

public class LlvmClass extends LlvmType{
    public LlvmStructure structureType;
    public String identificator;
    
    public LlvmClass(LlvmStructure content, String identificator){
	this.structureType = content;
	this.identificator=identificator;
    }

	public String toString(){
	return ""+identificator;
    }
}