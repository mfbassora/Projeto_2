package llvmast;
public class LlvmLabelValue extends LlvmValue{
    public String value = "Label";
    static int numberReg = 0;
    public LlvmLabelValue(String value){
	type = LlvmPrimitiveType.LABEL;
	this.value = value+numberReg++;
    }


    public String toString(){
	return ""+ value;
    }
}