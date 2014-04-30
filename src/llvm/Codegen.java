/*****************************************************
Esta classe Codegen é a responsável por emitir LLVM-IR. 
Ela possui o mesmo método 'visit' sobrecarregado de
acordo com o tipo do parâmetro. Se o parâmentro for
do tipo 'While', o 'visit' emitirá código LLVM-IR que 
representa este comportamento. 
Alguns métodos 'visit' já estão prontos e, por isso,
a compilação do código abaixo já é possível.

class a{
    public static void main(String[] args){
    	System.out.println(1+2);
    }
}

O pacote 'llvmast' possui estruturas simples 
que auxiliam a geração de código em LLVM-IR. Quase todas 
as classes estão prontas; apenas as seguintes precisam ser 
implementadas: 

// llvmasm/LlvmBranch.java
// llvmasm/LlvmIcmp.java
// llvmasm/LlvmMinus.java
// llvmasm/LlvmTimes.java


Todas as assinaturas de métodos e construtores 
necessárias já estão lá. 


Observem todos os métodos e classes já implementados
e o manual do LLVM-IR (http://llvm.org/docs/LangRef.html) 
como guia no desenvolvimento deste projeto. 

****************************************************/
package llvm;

import semant.Env;
import syntaxtree.*;
import llvmast.*;

import java.util.*;


public class Codegen extends VisitorAdapter{
	private List<LlvmInstruction> assembler;
	private Codegen codeGenerator;
	private ClassNode classEnv; // Aponta para a classe atualmente em uso em symTab
	private SymTab mySymTab;
	private MethodNode methodEnv; // Aponta para a metodo atualmente em uso em symTab
	
	public Codegen(){
		assembler = new LinkedList<LlvmInstruction>();
		mySymTab = new SymTab();
	}

	// Método de entrada do Codegen
	public String translate(Program p, Env env){	
		codeGenerator = new Codegen();
		//Colocando as estruturas das classes e metodos no inicio usando TabSymbol
		codeGenerator.mySymTab.FillTabSymbol(p);
		
		// Formato da String para o System.out.printlnijava "%d\n"
		codeGenerator.assembler.add(new LlvmConstantDeclaration("@.formatting.string", "private constant [4 x i8] c\"%d\\0A\\00\""));	
		Helper helper= new Helper();
		//Antes de comecar a emitir codigo, vamos declarar as variaveis do sistema e imprimir elas
		Iterator it = codeGenerator.mySymTab.classes.entrySet().iterator();
		while (it.hasNext()) {	

			 Map.Entry mapEntry = (Map.Entry) it.next();
			 if(it.hasNext()){
			 ClassNode cn = (ClassNode)mapEntry.getValue();
			 codeGenerator.assembler.add(new LlvmConstantDeclaration("%class."+ mapEntry.getKey(), "type "+cn.classType));
			}
		}
		// NOTA: sempre que X.accept(Y), então Y.visit(X);
		// NOTA: Logo, o comando abaixo irá chamar codeGenerator.visit(Program), linha 75
		
		p.accept(codeGenerator);
		
		// Link do printf
		List<LlvmType> pts = new LinkedList<LlvmType>();
		
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@printf", LlvmPrimitiveType.I32, pts)); 
		List<LlvmType> mallocpts = new LinkedList<LlvmType>();
		mallocpts.add(LlvmPrimitiveType.I32);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@malloc", new LlvmPointer(LlvmPrimitiveType.I8),mallocpts)); 
		
		String r = new String();
		for(LlvmInstruction instr : codeGenerator.assembler)
			r += instr+"\n";
		return r;
	}

	public LlvmValue visit(Program n){
		n.mainClass.accept(this);

		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);

		return null;
	}

	
	
	
//**** Main Class ****//
	
	public LlvmValue visit(MainClass n){
		
		// definicao do main 
		assembler.add(new LlvmDefine("@main", LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmAlloca(R1, LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmStore(new LlvmIntegerLiteral(0), R1));

		// Statement é uma classe abstrata
		// Portanto, o accept chamado é da classe que implementa Statement, por exemplo,  a classe "Print". 
		n.stm.accept(this);  
		
		// Final do Main
		LlvmRegister R2 = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		assembler.add(new LlvmCloseDefinition());
		return null;
	}
	
	
	
//**** SOMA ****//
	public LlvmValue visit(Plus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmPlus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	//**** PRINT ****//

	public LlvmValue visit(Print n){

		LlvmValue v =  n.exp.accept(this);

		// getelementptr:
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I8));
		LlvmRegister src = new LlvmNamedValue("@.formatting.string",new LlvmPointer(new LlvmArray(4,LlvmPrimitiveType.I8)));
		List<LlvmValue> offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmIntegerLiteral(0));
		offsets.add(new LlvmIntegerLiteral(0));
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		args.add(lhs);
		args.add(v);
		assembler.add(new LlvmGetElementPointer(lhs,src,offsets));

		pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		
		// printf:
		assembler.add(new LlvmCall(new LlvmRegister(LlvmPrimitiveType.I32),
				LlvmPrimitiveType.I32,
				pts,				 
				"@printf",
				args
				));
		return null;
	}
	
	public LlvmValue visit(IntegerLiteral n){
		return new LlvmIntegerLiteral(n.value);
	};
	

	//**** CLASSE SIMPLES ****//

	public LlvmValue visit(ClassDeclSimple n){
		
		this.classEnv = this.mySymTab.classes.get(n.name.toString());
		//Vamos declarar os metodos
		for (util.List<MethodDecl> met = n.methodList; met != null; met = met.tail)
		{
			//Vamos declarar dinamicamente cada metodo
			met.head.accept(this);
		};
		
		return null;
		}
	public LlvmValue visit(ClassDeclExtends n){
		//TODO: Fazer
		return null;}
	public LlvmValue visit(VarDecl n){
		System.out.println("VarDecl");

		//Primeiro verificamos que tipo ele e
		if (n.type instanceof IntegerType )
		{
			//Vamos criar uma variavel com nome
			LlvmRegister reg = new LlvmNamedValue("%"+n.name.s, LlvmPrimitiveType.I32);
			assembler.add(new LlvmAllocaUnic(reg,LlvmPrimitiveType.I32)); 
		}else if (n.type instanceof BooleanType )
		{
			//Vamos criar uma variavel com nome
			LlvmRegister reg = new LlvmNamedValue("%"+n.name.s, LlvmPrimitiveType.I1);
			assembler.add(new LlvmAllocaUnic(reg,LlvmPrimitiveType.I1)); 
		}else if (n.type instanceof IdentifierType )
		{
			//Vamos criar uma variavel com nome
			LlvmRegister reg = new LlvmNamedValue("%"+n.name.s, LlvmPrimitiveType.LABEL);
			assembler.add(new LlvmAllocaUnic(reg,LlvmPrimitiveType.LABEL)); 
		}else if (n.type instanceof syntaxtree.IntArrayType )
		{
			//Vamos criar uma variavel com nome
			LlvmRegister reg = new LlvmNamedValue("%"+n.name.s,  new LlvmPointer(LlvmPrimitiveType.I32));
			assembler.add(new LlvmAllocaUnic(reg,new LlvmPointer(LlvmPrimitiveType.I32))); 
		}

		
		return null;
	}
	public LlvmValue visit(MethodDecl n){
		
		Helper helper = new Helper();
		LlvmNamedValue aux;
		List<LlvmValue> valueList = new LinkedList<LlvmValue>();
	

		//Vamos achar o current method pelo nome
		
			this.methodEnv=this.classEnv.methodList.get("@__"+n.name.toString()+"_"+this.classEnv.nameClass);
			
		
		

		//vamos adicionar a classe que este metodo pertence primeiro no valueList
		valueList.add(new LlvmNamedValue("%this",new LlvmPointer(new LlvmClass(this.classEnv.classType,"%class."+this.classEnv.nameClass))));
		for (util.List<Formal> formal = n.formals; formal != null; formal = formal.tail)
		{
			//vamos declarar os formals no comeco
			aux = new LlvmNamedValue("%"+formal.head.name.toString(),helper.findType(formal.head.type));
			valueList.add(aux);
		};
		
		//Vamos definir o metodo primeiro
		assembler.add(new LlvmDefine("@__"+n.name.toString()+"_"+this.classEnv.nameClass, helper.findType(n.returnType),valueList));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		// Declarar os Formal
		for (util.List<Formal> formal = n.formals; formal != null; formal = formal.tail)
		{
			//vamos declarar os formals no comeco
			formal.head.accept(this);
			
		};
		//Vamos declarar as variaveis
		for (util.List<VarDecl> varDec = n.locals; varDec != null; varDec = varDec.tail)
		{
			varDec.head.accept(this);
		};
		//Vamos percorrer os statements 
		for (util.List<Statement> statement = n.body; statement != null; statement = statement.tail)
		{
			statement.head.accept(this);
		
			
		};
		//Retorno
		
		assembler.add(new LlvmRet(n.returnExp.accept(this)));
		
		//Fim do metodo
		assembler.add(new LlvmCloseDefinition());
		return null;
		}
	
	
	public LlvmValue visit(Formal n){
		System.out.println("Formal");
		Helper help = new Helper();
		//Criaremos um reg_addr e colocaremos o valor nele
		LlvmValue retReg = new LlvmNamedValue("%"+n.name.toString()+"_addr",new LlvmPointer(help.findType(n.type)));
		assembler.add(new LlvmAllocaUnic(retReg,help.findType(n.type)));
		assembler.add(new LlvmStore(new LlvmNamedValue("%"+n.name.s,help.findType(n.type)), retReg));

		return null;}
	public LlvmValue visit(IntArrayType n){
		System.out.println("IntArrayType");

		//Teoricamente nao sera preciso implementar essa func, esta em Helper().

	
		return null;
		
	
	}
	public LlvmValue visit(BooleanType n){
		System.out.println("BooleanType");

		//Teoricamente nao sera preciso implementar essa func, esta em Helper().
		
		return null;
		
	}
	public LlvmValue visit(IntegerType n){
		System.out.println("IntegerType");

		//Teoricamente nao sera preciso implementar essa func, esta em Helper().

		return null;}

	public LlvmValue visit(IdentifierType n){
		System.out.println("IdentifierType");

		LlvmType t = this.mySymTab.classes.get(n.name);
		return new LlvmRegister(t.toString(), t);
		
	}
	public LlvmValue visit(Block n){
		System.out.println("Block");

		return null;}
	public LlvmValue visit(If n){
		System.out.println("If");

		LlvmValue v1 = n.condition.accept(this);

		LlvmLabelValue ifThen = new LlvmLabelValue("if.then");
		LlvmLabelValue ifElse = new LlvmLabelValue("if.else");
		assembler.add(new LlvmBranch(v1, ifThen, ifElse));
		assembler.add(new LlvmLabel(ifThen));
		n.thenClause.accept(this);
		assembler.add(new LlvmLabel(ifElse));
		n.elseClause.accept(this);
		return null;
	}
	public LlvmValue visit(While n){
		System.out.println("While");
		LlvmLabelValue whileLabel =new LlvmLabelValue("while"); 
		LlvmLabelValue whileEnd =new LlvmLabelValue("whileEnd"); 
		//Primeiro usaremos um br label %while para entrar no while
		assembler.add(new LlvmBranch(whileLabel));
		//Vamos primeiro criar o label do while

		assembler.add(new LlvmLabel(whileLabel));
		//Agora vamos declarar o statement do while
		n.body.accept(this);
		//Por fim usamos o branch para verificar se podemos sair da condicao ou nao
		assembler.add(new LlvmBranch(n.condition.accept(this), whileEnd, whileLabel));
		assembler.add(new LlvmLabel(whileEnd));
		
		
		return null;
	}
	
	public LlvmValue visit(Assign n)
	{
		System.out.println("Assign");

		//Declarando a variavel
		LlvmValue var= n.var.accept(this);
		//Declarando a expressao
		System.out.println("   asdas   "+n.exp.toString());

		LlvmValue exp =n.exp.accept(this);
		assembler.add(new LlvmStore(exp,var));
		return null;
	}
	
	public LlvmValue visit(ArrayAssign n){
		System.out.println("ArrayAssign");
		LlvmValue ar = n.var.accept(this);
		LlvmValue in = n.index.accept(this);
		LlvmValue vl = n.value.accept(this);
		LlvmRegister lhs = new LlvmRegister(vl.type);
		List<LlvmValue> args = new ArrayList<LlvmValue>();
		args.add(new LlvmIntegerLiteral(0));
		args.add(in);
		assembler.add(new LlvmGetElementPointer(lhs,ar,args));
		assembler.add(new LlvmStore(vl,lhs));
		

		
		//TODO: Fazer
		return null;
		
	}
	public LlvmValue visit(And n){
		System.out.println("And");
		Helper help = new Helper();
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmType ty = help.findType(n.type);
		LlvmRegister lhs = new LlvmRegister(ty);
		assembler.add(new LlvmIcmp(lhs, 2, ty, v1, v2));
		
		//TODO: Fazer

		return lhs;
		
	}
	public LlvmValue visit(LessThan n){
		System.out.println("LessThan");
		Helper help = new Helper();
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmType ty = help.findType(n.type);
		LlvmRegister lhs = new LlvmRegister(ty);
		assembler.add(new LlvmIcmp(lhs, 1, ty, v1, v2));
		
		return lhs;}
	//TODO: Fazer
	
	public LlvmValue visit(Equal n){
		Helper help = new Helper();
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmType ty = help.findType(n.type);
		LlvmRegister lhs = new LlvmRegister(ty);
		assembler.add(new LlvmIcmp(lhs, 0, ty, v1, v2));
		

		return lhs;}

	 
	//DONE
	public LlvmValue visit(Minus n)
	{
		
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMinus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	//DONE		
	public LlvmValue visit(Times n){
	//Multiplicacao de numeros
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmTimes(lhs,LlvmPrimitiveType.I32,v1,v2));
		
		return lhs;
		}
	
	public LlvmValue visit(ArrayLookup n){
		//TODO: Fazer
		System.out.println("ArrayLookup");

		return null;}
	public LlvmValue visit(ArrayLength n){
		System.out.println("ArrayLength");
return null;}

	public LlvmValue visit(Call n){
		System.out.println("Call");
		Helper help = new Helper();
		//Allocando o objeto
		LlvmValue classPtr = n.object.accept(this);
		LlvmType ty = help.findType(n.type);
		LlvmRegister returnReg = new LlvmRegister(help.findType(n.type));
		
		List<LlvmValue> args = new ArrayList<LlvmValue>();
		List<LlvmType> typelist = null;
		//Vamos apendar primeiro a classe
		args.add(classPtr);
		
		for (util.List<Exp> m = n.actuals; m != null; m = m.tail)
		{
			LlvmValue aux = m.head.accept(this);
			args.add(aux);
					
		};
		assembler.add(new LlvmCall(returnReg, ty, typelist ,"@__"+n.method.s+"_"+this.classEnv.nameClass , args));

		return returnReg;
	}

	public LlvmValue visit(True n){
		System.out.println("True");

		return new LlvmBool(1);
	}

	public LlvmValue visit(False n){
		System.out.println("False");

		return new LlvmBool(0);
		
	}
	
	//DONE
	public LlvmValue visit(IdentifierExp n){
		System.out.println("IdentifierExp");
		 LlvmValue address = n.name.accept (this);
	        LlvmRegister temporary = new LlvmRegister (address.type);
	        
	        if (address instanceof LlvmRegister)
	          assembler.add (new LlvmLoad (temporary,
	                                       new LlvmNamedValue (address.toString (),
	                                                          address.type)));
	          else
	        assembler.add (new LlvmLoad (temporary,
	                                     new LlvmNamedValue (address + ".addr",
	                                                         address.type)));
	        return temporary;
//		
//		Helper helper = new Helper();
//		LlvmType lType =helper.findType(n.type); 
//		//Vamos dar o load em uma variavel temporaria
//		LlvmRegister lhs = new LlvmRegister(lType);
//		LlvmNamedValue addressReg = new LlvmNamedValue("%"+n.name.s, new LlvmPointer(helper.findType(n.type)));
//		assembler.add(new LlvmLoad(lhs,addressReg));
//		//Depois de dar um load, enviamos o registrador para ser usado
//		return lhs;

		}
	public LlvmValue visit(This n){
		//TODO: Fazer
		System.out.println("This");
		//

		return null;
		
	}
	
	public LlvmValue visit(NewArray n){
		System.out.println("NewArray");

		//Vamos alocar o espaco da array
		Helper helper = new Helper();
		//Registrador que guardara o valor da array
		LlvmRegister R1 = new LlvmRegister(helper.findType(n.type));
		//Achando o valor da array
		LlvmValue arraySize = n.size.accept(this);
		assembler.add(new LlvmMalloc(R1,LlvmPrimitiveType.I32,arraySize));

//Vamos agora retornar o ponteiro para a array
		
		return R1;
		}
	public LlvmValue visit(NewObject n){


		System.out.println("New Object");

		Helper help = new Helper();
		//Vamos avisar que estamos na classe actual
		this.classEnv = this.mySymTab.classes.get(n.className.toString());
		//Criando o tipo classe
		
		LlvmType ObjectType = new LlvmClass(this.classEnv.classType,"%class."+this.classEnv.nameClass);
		
		LlvmValue r1 = new LlvmRegister(new LlvmPointer(ObjectType));
		assembler.add(new LlvmMalloc(r1,ObjectType,"%class."+n.className.toString()));
		//Retornando o registrador da classe alocada
		return r1;
		}
	public LlvmValue visit(Not n){
		System.out.println("Not");

		//TODO: Fazer

		LlvmValue e = n.exp.accept(this);
		
		return null;
		
	
	}
	public LlvmValue visit(Identifier n)
	{
		//Pode ser Classe, Method, VarClass ou MethodVar
		//Vamos achar a declaracao da variavel primeiro
		System.out.println("Identifier");
		//Temos tipo classe identifier, class variable, method identifier ou method var

		String name = null;
		LlvmType tp = null;
		
		Helper helper=new Helper();
		if(this.methodEnv==null){
			//declaracao de variavel de classe
		

				
					//Achamos a declaracao
					name = this.methodEnv.varList.get(n.s).name.toString();
					tp=helper.findType(this.methodEnv.varList.get(n.s).type);
			
			
		
		
		//Declarando o namedValue
		return new LlvmNamedValue("%"+name,new LlvmPointer(tp));
		

		}else{
			//Identificador de variavel de metodo ou classe, ou declaracao de method
			//Por ordem, o LlvmNamedValue comeca do method
			LlvmValue value = null;
			if(this.methodEnv.varList.containsKey(n.s))
			{
				//Vamos declara-la como uma variavel local pois ela esta declarada localmente
				return new LlvmNamedValue("%"+this.methodEnv.varList.get(n.s).name.s,new LlvmPointer(helper.findType(this.methodEnv.varList.get(n.s).type)));
			}else if(this.methodEnv.formalList.containsKey(n.s))
			{
				//Ela e parte do formal do metodo, temos entao que enviar como o address, que foi declarado inicialmente
				return new LlvmNamedValue("%"+this.methodEnv.formalList.get(n.s).name.s+"_addr",new LlvmPointer(helper.findType(this.methodEnv.formalList.get(n.s).type)));

			}else if(this.methodEnv.methodClass.varList.containsKey(n.s))
			{
				
				System.out.println("MAOE");

				//Ele faz parte das variaveis da classe, entao temos que usar o getElementPointer
				LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
				//GetelementPointer, achamos a posicao da variavel
				int index = 0;
				for(String varName :this.methodEnv.methodClass.varList.keySet())
				{
					if(varName.equals(n.s)){
						break;
					}else{
					index=index+1;
					}
					
				}
				LlvmValue index0 = new LlvmIntegerLiteral(0);
				LlvmValue index1 = new LlvmIntegerLiteral(index);
				List<LlvmValue> offsets=new LinkedList<LlvmValue>();
				offsets.add(index0);
				offsets.add(index1);
				//Agora chamamos o getelementpointer
				assembler.add(new LlvmGetElementPointer(lhs,new LlvmNamedValue("%this",new LlvmPointer(new LlvmClass(this.methodEnv.methodClass.classType,"%class."+this.methodEnv.methodClass.nameClass))),offsets));
				//Load para um registrador
				
				return lhs;
				
			}
			
		}
		return null;
	}
}
class Helper {
	//Metodo que verifica qual LlvmType o Type pertence
	public LlvmType findType(Type t)
	{
		if(t instanceof IntegerType){
			return LlvmPrimitiveType.I32;
		}else if(t instanceof BooleanType){

			return (LlvmPrimitiveType.I1);	
		}else if(t instanceof IntArrayType){
			return new LlvmPointer(LlvmPrimitiveType.I32);	

		}else if(t instanceof IdentifierType)
		{
			return LlvmPrimitiveType.LABEL;	

		}
		return null;
	}
}

/**********************************************************************************/
/* === Tabela de Simbolos ==== 

 * 
 * 
 */
/**********************************************************************************/

class SymTab extends VisitorAdapter{
    public Map<String, ClassNode> classes;
    private ClassNode classEnv;    //aponta para a classe em uso
    
    public SymTab()
    {
    	this.classes= new HashMap<String, ClassNode>();
    }
    public LlvmValue FillTabSymbol(Program n){
    
	n.accept(this);
	
	return null;
    }
public LlvmValue visit(Program n){
	n.mainClass.accept(this);

	for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
		c.head.accept(this);

	return null;
}

public LlvmValue visit(MainClass n){
	classes.put(n.className.s, new ClassNode(n.className.s, null, null));
	return null;
}

public LlvmValue visit(ClassDeclSimple n){
	
	List<LlvmType> typeList = new ArrayList<LlvmType>();
	// Constroi TypeList com os tipos das variaveis da Classe (vai formar a Struct da classe)
	for (util.List<VarDecl> c = n.varList; c != null; c = c.tail)
	{
		//Vamos adicionar os tipos que estao declarados na classe
		if(c.head.type instanceof IntegerType){
			typeList.add(LlvmPrimitiveType.I32);
		}else if(c.head.type instanceof BooleanType){
			typeList.add(LlvmPrimitiveType.I1);	
		}else if(c.head.type instanceof IntArrayType){

			typeList.add(new LlvmPointer(LlvmPrimitiveType.I32));	

		}else if(c.head.type instanceof IdentifierType)
		{
		typeList.add(LlvmPrimitiveType.LABEL);	

		}
	};
	int i=0;
	
	Map<String, LlvmValue> varList= new LinkedHashMap<String, LlvmValue>();
	// Constroi VarList com as Variaveis da Classe
	for (util.List<VarDecl> c = n.varList; c != null; c = c.tail)
	{
		varList.put(c.head.name.toString(),new LlvmNamedValue(c.head.name.s,typeList.get(i)));
		i++;
	};
	ClassNode CS = new ClassNode(n.name.s, new LlvmStructure(typeList),varList);
	classes.put(n.name.s, CS);
	
	

	classEnv = CS;
    	// Percorre n.methodList visitando cada metodo
	for (util.List<MethodDecl> m = n.methodList; m != null; m = m.tail)
	{
		//Vamos percorrer agora o methodDecl
		m.head.accept(this);
	};
		

	return null;
}

	public LlvmValue visit(ClassDeclExtends n){return null;}
	public LlvmValue visit(VarDecl n){
		
		return null;
		
	}
	public LlvmValue visit(Formal n){return null;}
	
	
	
	
	public LlvmValue visit(MethodDecl n){
		Helper helper = new Helper();
		List<LlvmType> typeList = new LinkedList<LlvmType>();
		Map<String, Formal> formalList = new LinkedHashMap<String,Formal>();
		Map<String, VarDecl> varList = new LinkedHashMap<String,VarDecl>();
		//Vamos declarar a classe a qual ele pertence primeiro
		typeList.add(new LlvmPointer(new LlvmClass(this.classEnv.classType,"%class."+this.classEnv.nameClass)));
		for (util.List<Formal> c = n.formals; c != null; c = c.tail)
		{
			formalList.put(c.head.name.s, c.head);
			typeList.add(helper.findType(c.head.type));
		};
		for (util.List<VarDecl> vard = n.locals; vard != null; vard = vard.tail)
		{
			varList.put(vard.head.name.toString(), vard.head);
			typeList.add(helper.findType(vard.head.type));
		};
		
		//Vamos fazer a declaracao deste metodo e guardar na lista da classe
		MethodNode mn= new MethodNode("@__"+n.name.toString()+"_"+this.classEnv.nameClass, LlvmPrimitiveType.I32,formalList,varList,classEnv,typeList);
		//Guardando method dentro da classe que ele pertence
		classEnv.methodList.put(mn.identificator, mn);	

		return null;
		}
	
	
	
	public LlvmValue visit(IdentifierType n){return null;}
	public LlvmValue visit(IntArrayType n){return null;}
	public LlvmValue visit(BooleanType n){return null;}
	public LlvmValue visit(IntegerType n){return null;}
	
}

class ClassNode extends LlvmType {
	String nameClass;
	LlvmStructure classType;
	Map<String, LlvmValue> varList;
	public Map<String, MethodNode> methodList; 
	ClassNode (String nameClass, LlvmStructure classType,   Map<String, LlvmValue> varList){
		this.nameClass=nameClass;
		this.classType = classType;
		this.varList = varList;
		this.methodList = new LinkedHashMap<String, MethodNode>();
	}
}

class MethodNode extends LlvmType{
	LlvmType retType;
	Map<String, Formal> formalList;
	Map<String, VarDecl> varList;
	List<LlvmType> typeList;
	ClassNode methodClass;
	String identificator;
	
	MethodNode (String nameMethod,LlvmType retType,Map<String, Formal> formalList,Map<String, VarDecl> varList, ClassNode methodClass, List<LlvmType> typeList){
	this.identificator=nameMethod;
	this.formalList=formalList;
	this.varList=varList;
	this.retType=retType;
	this.methodClass=methodClass;
	this.typeList=typeList;
	}
	
}





