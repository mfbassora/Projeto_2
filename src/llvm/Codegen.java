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

import javax.xml.soap.Node;

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
		//Vamos declarar os methods
		Iterator it2 = codeGenerator.mySymTab.classes.entrySet().iterator();
		List<LlvmType> valueList = new LinkedList<LlvmType>();
		LlvmType aux=null;
		while (it2.hasNext()) {	

			 Map.Entry mapEntry = (Map.Entry) it2.next();
			 if(it2.hasNext()){
			 ClassNode cn = (ClassNode)mapEntry.getValue();
			 for(int i=0;i<cn.methodList.size();i++){
			MethodNode mn = cn.methodList.get(i);
			
			 codeGenerator.assembler.add(new LlvmExternalDeclaration(mn.identificator,mn.retType,mn.typeList));
			}}
		}

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
		for(int i=0;i<this.classEnv.methodList.size();i++)
		{
			if(this.classEnv.methodList.get(i).identificator.equals(n.name.toString()))
			{
				//achamos o method
				this.methodEnv=this.classEnv.methodList.get(i);
			}
		}
		for (util.List<Formal> formal = n.formals; formal != null; formal = formal.tail)
		{
			aux = new LlvmNamedValue("%"+formal.head.name.toString(),helper.findType(formal.head.type));
			valueList.add(aux);
		};
		
		//Vamos definir o metodo primeiro
		assembler.add(new LlvmDefine("@__"+n.name.toString()+"_"+this.classEnv.nameClass, helper.findType(n.returnType),valueList));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
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
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmAlloca(R1, LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		LlvmRegister R2 = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		
		//Fim do metodo
		assembler.add(new LlvmCloseDefinition());
		return null;
		}
	
	
	public LlvmValue visit(Formal n){
		System.out.println("Formal");

		//Teoricamente nao sera preciso implementar essa func, esta em Helper().
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
		LlvmValue ar = n.array.accept(this);
		LlvmValue in = n.index.accept(this);
		LlvmRegister lhs = new LlvmRegister(ar.type);
		List<LlvmValue> off = new ArrayList<LlvmValue>();
		off.add(new LlvmIntegerLiteral(0));
		off.add(in);
		assembler.add(new LlvmGetElementPointer(lhs,ar,off));
		LlvmRegister lkup = new LlvmRegister (((LlvmPointer)(ar.type)).content);
		assembler.add (new LlvmLoad (lkup, lhs));
		return lkup;
		}
	public LlvmValue visit(ArrayLength n){
		LlvmValue ar = n.array.accept (this);
		LlvmRegister lhs = new LlvmRegister (ar.type);
	    List<LlvmValue> off = new LinkedList<LlvmValue> ();
	    off.add (new LlvmIntegerLiteral (0));
	    assembler.add (new LlvmGetElementPointer (lhs, ar, off));
	    LlvmRegister lngth = new LlvmRegister (((LlvmPointer)(ar.type)).content);
	    assembler.add (new LlvmLoad (lngth, lhs));
	    return lhs;
		}

	public LlvmValue visit(Call n){
		System.out.println("Call");
		Helper help = new Helper();
		//Allocando o objeto
		LlvmValue classPtr = n.object.accept(this);
		
		LlvmType ty = help.findType(n.type);
		LlvmRegister returnReg = new LlvmRegister(help.findType(n.type));
		
		LlvmNamedValue name = new LlvmNamedValue("@__"+n.method.toString()+"_"+this.classEnv.nameClass, LlvmPrimitiveType.LABEL);
		List<LlvmValue> args = new ArrayList<LlvmValue>();
		List<LlvmType> typelist = new ArrayList<LlvmType>();
		//Vamos apendar primeiro a classe
		args.add(classPtr);
		
		for (util.List<Exp> m = n.actuals; m != null; m = m.tail)
		{
			LlvmValue aux = m.head.accept(this);
			args.add(aux);
					
		};
		//TODO:Cntinuar daqui: Identifier esta dando erro!!!!!
		assembler.add(new LlvmCall(returnReg, ty, typelist, name.name, args));

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
		
		Helper helper = new Helper();
		LlvmType lType =helper.findType(n.type); 
		//Vamos dar o load em uma variavel temporaria
		LlvmRegister lhs = new LlvmRegister(lType);
		LlvmNamedValue addressReg = new LlvmNamedValue("%"+n.name.s, new LlvmPointer(helper.findType(n.type)));
		assembler.add(new LlvmLoad(lhs,addressReg));
		//Depois de dar um load, enviamos o registrador para ser usado
		return lhs;

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
		System.out.println(helper.findType(n.type));
		assembler.add(new LlvmMalloc(R1,LlvmPrimitiveType.I32,arraySize));

//Vamos agora retornar o ponteiro para a array
		
		return R1;
		}
	public LlvmValue visit(NewObject n){
		//TODO: 
		//TODO: PRECISO RESOLVER ISSO
		//TODO: 

		System.out.println("New Object");

		Helper help = new Helper();
		//Vamos avisar que estamos na classe actual
		this.classEnv = this.mySymTab.classes.get(n.className.toString());
		LlvmType ObjectType = n.className.accept(this).type;
		LlvmValue cD = new LlvmNamedValue("%class."+n.className.toString(),LlvmPrimitiveType.LABEL);

		LlvmValue r1 = new LlvmRegister(ObjectType);
		
		assembler.add(new LlvmMalloc(r1,ObjectType,"%"+n.className.toString()));
		return r1;
		//return null;
		}
	public LlvmValue visit(Not n){
		System.out.println("Not");
		//fazer Xor com o bool 1 sempre inverte o booleano existente
		LlvmValue neg = n.exp.accept(this);
        LlvmRegister N = new LlvmRegister(LlvmPrimitiveType.I1);
        assembler.add(new LlvmXor(N, LlvmPrimitiveType.I1, neg, new LlvmBool(1)));
        return N;
		
		
	
	}
	public LlvmValue visit(Identifier n){
		//Vamos achar a declaracao da variavel primeiro
		System.out.println("Identifier");
		//Temos tipo classe id, var id 
		
		String name = null;
		LlvmType tp = null;
		
		Helper helper=new Helper();
		if(this.methodEnv!=null){
			//Temos um identifier de method
		for (util.List<VarDecl> varDec = this.methodEnv.varList; varDec != null; varDec = varDec.tail)
		{
				
				if(varDec.head.name.toString().equals(n.s))
				{
					//Achamos a declaracao
					name = varDec.head.name.toString();
					tp=helper.findType(varDec.head.type);
				}
			
		};
		}else if(this.classEnv!=null)
		{
		//Temos um identifier de classe
			name = "class."+n.s;
			tp = this.classEnv.classType;
		}
		//Declarando o namedValue
		return new LlvmNamedValue("%"+name,new LlvmPointer(tp));
		

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
	
	List<LlvmValue> varList = new ArrayList<LlvmValue>();
	// Constroi VarList com as Variaveis da Classe
	for (util.List<VarDecl> c = n.varList; c != null; c = c.tail)
	{
		varList.add(new LlvmNamedValue(c.head.name.s,typeList.get(i)));
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
		for (util.List<Formal> c = n.formals; c != null; c = c.tail)
		{
			typeList.add(helper.findType(c.head.type));
		};
		
		//Vamos fazer a declaracao deste metodo e guardar na lista da classe
		MethodNode mn= new MethodNode("@__"+n.name.toString()+"_"+this.classEnv.nameClass, LlvmPrimitiveType.I32,n.formals,n.locals,classEnv,typeList);
		//Guardando method dentro da classe que ele pertence
		classEnv.methodList.add(mn);	

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
	List<LlvmValue> varList;
	List<MethodNode> methodList; 
	ClassNode (String nameClass, LlvmStructure classType, List<LlvmValue> varList){
		this.nameClass=nameClass;
		this.classType = classType;
		this.varList = varList;
		this.methodList = new ArrayList<MethodNode>();
	}
}

class MethodNode extends LlvmType{
	LlvmType retType;
	util.List<Formal> formalList;
	util.List<VarDecl> varList;
	List<LlvmType> typeList;
	ClassNode methodClass;
	String identificator;
	
	MethodNode (String nameMethod,LlvmType retType,util.List<Formal> formalList,util.List<VarDecl> varList, ClassNode methodClass, List<LlvmType> typeList){
	this.identificator=nameMethod;
	this.formalList=formalList;
	this.varList=varList;
	this.retType=retType;
	this.methodClass=methodClass;
	this.typeList=typeList;
	}
	
}





