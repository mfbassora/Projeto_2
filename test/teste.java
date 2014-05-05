class Factorial{
    public static void main(String[] a){
	System.out.println(new Fac().ComputeFac(10));
    }
}

class Fac {

    public int ComputeFac(int num){
	int num_aux;
	num_aux=10;
	if(num_aux==num)
		num_aux=300;
	
	return num_aux ;
    }

}
