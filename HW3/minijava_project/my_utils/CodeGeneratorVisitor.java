package my_utils;

import syntaxtree.*;
import visitor.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;

/**
 * NOTE: visitor generates IR from MiniJava input program
 */

public class CodeGeneratorVisitor extends GJDepthFirst<String, String>{
    // String codeBuffer = "";  /** NOTE: codeBuffer keeps the generated code */
    FileWriter fw;
    int tempCounter = 0;

    void emit(String s) throws Exception {
        // codeBuffer += s;
        try {
            fw.write(s);
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        }
    }

    void clearCounter() {
        tempCounter = 0;
    }

    String newIfLabel() {
        return "if" + tempCounter++;
    }

    String newLoopLabel() {
        return "loop" + tempCounter++;
    }

    String newAndLabel() {
        return "andclause" + tempCounter++;
    }

    String newArrAllocLabel() {
        return "arr_alloc" + tempCounter++;
    }

    String newOOBLabel() {
        return "oob" + tempCounter++;
    }

    String newTemp() {
        return "%_" + tempCounter++;
    }

    public CodeGeneratorVisitor(FileWriter fw_) {
        super();
        fw = fw_;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> "public"
     * f4 -> "static"
     * f5 -> "void"
     * f6 -> "main"
     * f7 -> "("
     * f8 -> "String"
     * f9 -> "["
     * f10 -> "]"
     * f11 -> Identifier()
     * f12 -> ")"
     * f13 -> "{"
     * f14 -> ( VarDeclaration() )*
     * f15 -> ( Statement() )*
     * f16 -> "}"
     * f17 -> "}"
     */
    @Override
    public String visit(MainClass n, String argu) throws Exception {
        /* Symbol                        | Interesting content
         * --------------------------------------------------------------
         * f14 -> ( VarDeclaration() )*  | variable declarations of main
         * f15 -> ( Statement() )*       | statements
         */

        // generate code for vtable of each class, using info from symbol table
        emit(SymbolTable.generateVTables());
        // insert code from assignment
        emit("\n\ndeclare i8* @calloc(i32, i32)\ndeclare i32 @printf(i8*, ...)\ndeclare void @exit(i32)\n\n");
        emit("@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n");
        emit("define void @print_int(i32 %i) {\n\t%_str = bitcast [4 x i8]* @_cint to i8*\n\tcall i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n\tret void\n}\n\n");
        emit("define void @throw_oob() {\n\t%_str = bitcast [15 x i8]* @_cOOB to i8*\n\tcall i32 (i8*, ...) @printf(i8* %_str)\n\tcall void @exit(i32 1)\n\tret void\n}\n\n");

        String buffer = "define i32 @main() {\n";
        for (Node node : n.f14.nodes) { // generate code for each VarDeclaration()
            buffer += node.accept(this, null);
        }
        emit(buffer);

        if (n.f15.present()) {  // generate code for all statements of main method, if any
            n.f15.accept(this, SymbolTable.mainClassName + " main"); // scope inside symbol table
        }

        emit("\tret i32 0\n}\n\n");

        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> ( VarDeclaration() )*
     * f4 -> ( MethodDeclaration() )*
     * f5 -> "}"
     */
    @Override
    public String visit(ClassDeclaration n, String argu) throws Exception {
        /*
         * Symbol                         | Interesting content
         * --------------------------------------------------------
         * f1 -> Identifier()             | name of class
         * f4 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);

        if (n.f4.present()) {   // generate code for all methods
            n.f4.accept(this, className);
        }
        return null;
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "extends"
     * f3 -> Identifier()
     * f4 -> "{"
     * f5 -> ( VarDeclaration() )*
     * f6 -> ( MethodDeclaration() )*
     * f7 -> "}"
     */
    @Override
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        /*
         * Symbol                         | Interesting content
         * -------------------------------------------------------------
         * f1 -> Identifier()             | name of class
         * f6 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);

        if (n.f6.present()) {   // generate code for all methods
            n.f6.accept(this, className);
        }
        return null;
    }

    /**
     * f0 -> Type()
     * f1 -> Identifier()
     * f2 -> ";"
     */
    @Override
    public String visit(VarDeclaration n, String argu) throws Exception {
        // TODO: perhaps return llvm type inside Type, instead of returning string and calling symboltable function
        String type = SymbolTable.llvmType(n.f0.accept(this, null));
        return String.format("\t%%%s = alloca %s\n\n", n.f1.accept(this, null), type);
    }

    /**
     * f0 -> "public"
     * f1 -> Type()
     * f2 -> Identifier()
     * f3 -> "("
     * f4 -> ( FormalParameterList() )?
     * f5 -> ")"
     * f6 -> "{"
     * f7 -> ( VarDeclaration() )*
     * f8 -> ( Statement() )*
     * f9 -> "return"
     * f10 -> Expression()
     * f11 -> ";"
     * f12 -> "}"
     */
    @Override
    public String visit(MethodDeclaration n, String argu) throws Exception {
        /*
         * Symbol                           | Interesting content
         * -------------------------------------------------------------------
         * f1 -> Type()                     | return type
         * f2 -> Identifier()               | method name
         * f4 -> ( FormalParameterList() )? | 
         * f7 -> ( VarDeclaration() )*      |
         * f8 -> ( Statement() )*           | all statements
         * f10 -> Expression()              | expression
         */
        // NOTE: argu contains classname that this method declaration belongs to
        String retType = SymbolTable.llvmType(n.f1.accept(this, null));
        String methodName = n.f2.accept(this, null);
        String classAndMethodName = argu + " " + methodName;
        String params = n.f4.present() ? n.f4.accept(this, null) : "";
        String buffer = String.format("define %s @%s.%s(i8* %%this%s) {\n", retType, argu, methodName, params);

        if (! params.isEmpty()) {   // generate code for each parameter, if any
            String[] paramsList = params.split(", ");
            for (String param : paramsList) {
                if (param.isEmpty())    // NOTE: bypass first element of paramsList which is empty
                    continue;
                String[] typeName = param.split(" %\\.");
                buffer += String.format("\t%%%s = alloca %s\n\tstore %s %%.%s, %s* %%%s\n",
                            typeName[1], typeName[0], typeName[0], typeName[1], typeName[0], typeName[1], typeName[1]);
            }
        }

        for (Node node : n.f7.nodes) { // generate code for each VarDeclaration()
            buffer += node.accept(this, null);
        }
        emit(buffer);

        clearCounter();    // reset counters for temps and labels

        if (n.f8.present()) {    // generate code for all statements, if any
            n.f8.accept(this, classAndMethodName);
        }

        String exprCode = n.f10.accept(this, classAndMethodName);
        emit(String.format("\tret %s\n}\n\n", exprCode));
        return null;
    }

    /**
     * f0 -> FormalParameter()
     * f1 -> FormalParameterTail()
     */
    @Override
    public String visit(FormalParameterList n, String argu) throws Exception {
        String ret = n.f0.accept(this, null);

        if (n.f1 != null) {
            ret += n.f1.accept(this, null);
        }

        return ret;
    }
    
    /**
     * f0 -> Type()
     * f1 -> Identifier()
     */
    @Override
    public String visit(FormalParameter n, String argu) throws Exception {
        return ", " + SymbolTable.llvmType(n.f0.accept(this, null)) + " %." + n.f1.accept(this, null);
    }

    /**
     * f0 -> ( FormalParameterTerm() )*
     */
    @Override
    public String visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for (Node node : n.f0.nodes) {
            ret += node.accept(this, null);
        }

        return ret;
    }

    /**
     * f0 -> ","
     * f1 -> FormalParameter()
     */
    @Override
    public String visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    // /**
    //  * f0 -> BooleanArrayType()
    //  * | IntegerArrayType()
    //  */
    // public R visit(ArrayType n, A argu) throws Exception {
    //     return n.f0.accept(this, argu);
    // }

    @Override
    public String visit(BooleanArrayType n, String argu) throws Exception {
        return "boolean[]";  // TODO: could i return "i8*" ?
    }

    @Override
    public String visit(IntegerArrayType n, String argu) throws Exception {
        return "int[]";     // TODO: could i return "i32*" ?
    }

    @Override
    public String visit(BooleanType n, String argu) {
        return "boolean";    // TODO: could i return "i8" ?
    }

    @Override
    public String visit(IntegerType n, String argu) {
        return "int";   // TODO: could i return "i32" ?
    }

    /**
    * f0 -> Block()
    *       | AssignmentStatement()
    *       | ArrayAssignmentStatement()
    *       | IfStatement()
    *       | WhileStatement()
    *       | PrintStatement()
    */
    @Override
    public String visit(Statement n, String argu) throws Exception {
        n.f0.accept(this, argu);  // parse statement
        return null;
    }

    /**
     * f0 -> "{"
     * f1 -> ( Statement() )*
     * f2 -> "}"
     */
    @Override
    public String visit(Block n, String argu) throws Exception {
        if (n.f1.present()) {
            n.f1.accept(this, argu);
        }
        return null;
    }

    /**
     * f0 -> Identifier()
     * f1 -> "="
     * f2 -> Expression()
     * f3 -> ";"
     */
    @Override
    public String visit(AssignmentStatement n, String argu) throws Exception {
        String expr = n.f2.accept(this, argu);
        String id = n.f0.accept(this, argu + " L");

        // System.out.println("argu: " + argu + " expr: " + expr + " id: " + id);

        emit(String.format("\tstore %s, %s\n\n", expr, id));

        return null;
    }

    /**
     * f0 -> Identifier()
     * f1 -> "["
     * f2 -> Expression()
     * f3 -> "]"
     * f4 -> "="
     * f5 -> Expression()
     * f6 -> ";"
     */
    @Override
    public String visit(ArrayAssignmentStatement n, String argu) throws Exception {
        // TODO: differentiate between int[] and boolean[] ?
        String temp0 = newTemp(), temp1 = newTemp(), temp2 = newTemp(), temp3 = newTemp();
        String temp4 = newTemp(); // TODO: just to match expected output
        String label0 = newOOBLabel(), label1 = newOOBLabel(), label2 = newOOBLabel();

        String tempID = n.f0.accept(this, argu);
        String tempIdx = n.f2.accept(this, argu);

        String buffer = String.format("\t%s = load i32, %s\n\t%s = icmp ult %s, %s\n", temp0, tempID, temp1, tempIdx, temp0)
                      + String.format("\tbr i1 %s, label %%%s, label %%%s\n\n%s:\n", temp1, label0, label1, label0)
                      + String.format("\t%s = add %s, 1\n", temp2, tempIdx)
                      + String.format("\t%s = getelementptr i32, %s, i32 %s\n", temp3, tempID, temp2)
        ;
        emit(buffer);

        String tempStore = n.f5.accept(this, argu);
        buffer = String.format("\tstore %s, i32* %s\n\tbr label %%%s\n\n", tempStore, temp3, label2)
               + String.format("%s:\n\tcall void @throw_oob()\n\tbr label %%%s\n\n%s:\n\n", label1, label2, label2)
        ;
        emit(buffer);

        return null;
    }

    /**
     * f0 -> "if"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> Statement()
     * f5 -> "else"
     * f6 -> Statement()
     */
    @Override
    public String visit(IfStatement n, String argu) throws Exception {
        String thenLabel = newIfLabel(), elseLabel = newIfLabel(), exitLabel = newIfLabel();
        String exprTemp = n.f2.accept(this, argu);
        emit(String.format("\tbr %s, label %%%s, label %%%s\n\n%s:\n", exprTemp, thenLabel, elseLabel, thenLabel));

        n.f4.accept(this, argu);
        emit(String.format("\tbr label %%%s\n\n%s:\n\n", exitLabel, elseLabel));
        n.f6.accept(this, argu);
        emit(String.format("\tbr label %%%s\n\n%s:\n\n", exitLabel, exitLabel));

        return null;
    }

    /**
     * f0 -> "while"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> Statement()
     */
    @Override
    public String visit(WhileStatement n, String argu) throws Exception {
        String whileLabel = newLoopLabel(), thenLabel = newLoopLabel(), exitLabel = newLoopLabel();
        emit(String.format("\tbr label %%%s\n\n%s:\n", whileLabel, whileLabel));

        String exprTemp = n.f2.accept(this, argu);
        emit(String.format("\tbr %s, label %%%s, label %%%s\n\n%s:\n", exprTemp, thenLabel, exitLabel, thenLabel));

        n.f4.accept(this, argu);
        emit(String.format("\tbr label %%%s\n\n%s:\n\n", whileLabel, exitLabel));

        return null;
    }

    /**
     * f0 -> "System.out.println"
     * f1 -> "("
     * f2 -> Expression()
     * f3 -> ")"
     * f4 -> ";"
     */
    @Override
    public String visit(PrintStatement n, String argu) throws Exception {
        String expr = n.f2.accept(this, argu);

        emit(String.format("\tcall void (i32) @print_int(%s)\n\n", expr));

        return null;
    }

    /**
    * f0 -> AndExpression()
    *       | CompareExpression()
    *       | PlusExpression()
    *       | MinusExpression()
    *       | TimesExpression()
    *       | ArrayLookup()
    *       | ArrayLength()
    *       | MessageSend()
    *       | Clause()
    */
    @Override
    public String visit(Expression n, String argu) throws Exception {
        return n.f0.accept(this, argu); // return code of expression
    }

    /**
     * f0 -> Clause()
     * f1 -> "&&"
     * f2 -> Clause()
     */
    @Override
    public String visit(AndExpression n, String argu) throws Exception {
        String temp0 = n.f0.accept(this, argu);

        String tempResult = newTemp();
        String label0 = newAndLabel(), label1 = newAndLabel(), label2 = newAndLabel(), label3 = newAndLabel();

        emit(String.format("\tbr label %%%s\n\n%s:\n\tbr %s, label %%%s, label %%%s\n\n%s:\n", 
                label0, label0, temp0, label1, label3, label1));
        String temp1 = n.f2.accept(this, argu);

        emit(String.format("\tbr label %%%s\n\n%s:\n\tbr label %%%s\n\n%s:\n", label2, label2, label3, label3));
        emit(String.format("\t%s = phi i1 [ 0, %%%s ], [ %s, %%%s ]\n", tempResult, label0, temp1.split(" ")[1], label2));

        return "i1 " + tempResult;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "<"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(CompareExpression n, String argu) throws Exception {
        String temp0 = n.f0.accept(this, argu);
        String temp1 = n.f2.accept(this, argu);
        String temp2 = newTemp();

        // System.out.println("temp0: " + temp0 + " temp1: " + temp1);

        emit(String.format("\t%s = icmp slt %s, %s\n", temp2, temp0, temp1.split(" ")[1]));
        return "i1 " + temp2;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "+"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(PlusExpression n, String argu) throws Exception {
        String temp0 = n.f0.accept(this, argu); 
        String temp1 = n.f2.accept(this, argu); 
        String temp2 = newTemp();

        emit(String.format("\t%s = add %s, %s\n", temp2, temp0, temp1.split(" ")[1]));
        return "i32 " + temp2;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "-"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(MinusExpression n, String argu) throws Exception {
        String temp0 = n.f0.accept(this, argu);
        String temp1 = n.f2.accept(this, argu);
        String temp2 = newTemp();

        emit(String.format("\t%s = sub %s, %s\n", temp2, temp0, temp1.split(" ")[1]));
        return "i32 " + temp2;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "*"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(TimesExpression n, String argu) throws Exception {
        String temp0 = n.f0.accept(this, argu);
        String temp1 = n.f2.accept(this, argu);
        String temp2 = newTemp();

        emit(String.format("\t%s = mul %s, %s\n", temp2, temp0, temp1.split(" ")[1]));
        return "i32 " + temp2;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "["
     * f2 -> PrimaryExpression()
     * f3 -> "]"
     */
    @Override
    public String visit(ArrayLookup n, String argu) throws Exception {
        // TODO: differentiate between "int[]" and "boolean[]" ??
        String temp0 = newTemp(), temp1 = newTemp(), temp2 = newTemp(), temp3 = newTemp(), temp4 = newTemp();
        String temp5 = newTemp(); // TODO: just to match expected output
        String label0 = newOOBLabel(), label1 = newOOBLabel(), label2 = newOOBLabel();

        String tempBase = n.f0.accept(this, argu);
        String tempIdx = n.f2.accept(this, argu);

        // System.out.println("tempBase: " + tempBase + " tempIdx: " + tempIdx);
        
        String buffer = String.format("\t%s = load i32, %s\n\t%s = icmp ult %s, %s\n", temp0, tempBase, temp1, tempIdx, temp0)
                + String.format("\tbr i1 %s, label %%%s, label %%%s\n\n%s:\n", temp1, label0, label1, label0)
                + String.format("\t%s = add %s, 1\n", temp2, tempIdx)
                + String.format("\t%s = getelementptr i32, %s, i32 %s\n", temp3, tempBase, temp2)
                + String.format("\t%s = load i32, i32* %s\n\tbr label %%%s\n\n", temp4, temp3, label2)
                + String.format("%s:\n\tcall void @throw_oob()\n\tbr label %%%s\n\n%s:\n", label1, label2, label2);
        ;

        emit(buffer);

        return "i32 " + temp4;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "."
     * f2 -> "length"
     */
    @Override
    public String visit(ArrayLength n, String argu) throws Exception {
        // TODO: differentiate between "int[]" and "boolean[]" ??
        String temp0 = newTemp();
        String tempBase = n.f0.accept(this, argu);

        emit(String.format("\t%s = load i32, %s\n", temp0, tempBase));
        return "i32 " + temp0;
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "."
     * f2 -> Identifier()
     * f3 -> "("
     * f4 -> ( ExpressionList() )?
     * f5 -> ")"
     */
    @Override
    public String visit(MessageSend n, String argu) throws Exception {
        boolean arguHasComma = argu.contains(",");
        // add a comma to argu, if not already present, to tell visitor to return type as well
        String exprList = n.f0.accept(this, arguHasComma ? argu : "," + argu);

        // System.out.println("argu: " + argu + " exprList: " + exprList);

        String[] args = exprList.split(",");    // [0]: "llvmType temp", [1]: className type of primary expression
        String exprTemp = args[0], className = args[1];
        // System.out.println("exprTemp: " + exprTemp + " className: " + className);
        String methodName = n.f2.accept(this, null);
        String prototype = SymbolTable.llvmMethodPrototype(className, methodName);
        String type = prototype.split(" ")[0];
        String temp0 = newTemp(), temp1 = newTemp(), temp2 = newTemp(),
               temp3 = newTemp(), temp4 = newTemp(), temp5 = newTemp();
        int methodOffset = SymbolTable.getMethodOffset(className, methodName);

        String buffer = String.format("\t; %s.%s : %s\n", className, methodName, methodOffset)
                    + String.format("\t%s = bitcast %s to i8***\n", temp0, exprTemp)
                    + String.format("\t%s = load i8**, i8*** %s\n", temp1, temp0)
                    + String.format("\t%s = getelementptr i8*, i8** %s, i32 %s\n", temp2, temp1, methodOffset)
                    + String.format("\t%s = load i8*, i8** %s\n", temp3, temp2)
                    + String.format("\t%s = bitcast i8* %s to %s\n", temp4, temp3, prototype)
        ;
        emit(buffer);

        String exprTempList = "";
        if (n.f4.present()) // generate code for parameters, if any
            exprTempList += n.f4.accept(this, argu.replace(",", ""));

        emit(String.format("\t%s = call %s %s(%s%s)\n", temp5, type, temp4, exprTemp, exprTempList));

        if (arguHasComma)
            return type + " " + temp5 + "," + className;    
        return type + " " + temp5;
    }

    /**
     * f0 -> Expression()
     * f1 -> ExpressionTail()
     */
    @Override
    public String visit(ExpressionList n, String argu) throws Exception {
        return ", " + n.f0.accept(this, argu) + n.f1.accept(this, argu);
    }

    /**
     * f0 -> ( ExpressionTerm() )*
     */
    @Override
    public String visit(ExpressionTail n, String argu) throws Exception {
        String exprTemp = "";
        for (Node node : n.f0.nodes) {
            // join all types of expressions using a single comma as separator
            exprTemp += "," + node.accept(this, argu);
        }
        return exprTemp;
    }

    /**
     * f0 -> ","
     * f1 -> Expression()
     */
    @Override
    public String visit(ExpressionTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    /**
     * f0 -> NotExpression()
     *      | PrimaryExpression()
     */
    @Override
    public String visit(Clause n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    /**
    * f0 -> IntegerLiteral()
    *       | TrueLiteral()
    *       | FalseLiteral()
    *       | Identifier()
    *       | ThisExpression()
    *       | ArrayAllocationExpression()
    *       | AllocationExpression()
    *       | BracketExpression()
    */
    @Override
    public String visit(PrimaryExpression n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    @Override
    public String visit(IntegerLiteral n, String argu) throws Exception {
        return "i32 " + n.f0.toString();
    }

    @Override
    public String visit(TrueLiteral n, String argu) throws Exception {
        return "i1 1";
    }

    @Override
    public String visit(FalseLiteral n, String argu) throws Exception {
        return "i1 0";
    }

    @Override
    public String visit(Identifier n, String argu) throws Exception {
        // TODO: refactor this code
        String id = n.f0.toString();
        if (argu == null)
            return id;

        String className = "";
        String[] args; // [0]: className, [1]: methodName
        if (argu.contains(",")) {
            args = argu.replace(",", "").split(" ");  // remove comma from splitted argu
            className = "," + SymbolTable.getTypeOfId(id, args[0], args[1]);
        } else {
            args = argu.split(" ");
        }
            
        // System.out.println("argu: " + argu + "  id: " + id);

        String result = SymbolTable.getIdInfoLLVM(id, args[0], args[1]);
        // System.out.println("result: " +  result);
        String type, temp0, temp1, idTemp;
        // if res[1] exists and it is a number,
        if (result.contains(" ")) {   // this is an offset
            String[] res = result.split(" "); // [0]: type, [1]: offset for this
            temp0 = newTemp();
            temp1 = newTemp();
            type = res[0];
            idTemp = temp1;
            // System.out.println("offset case -- temp0: " + temp0 + " temp1: " + temp1);
            // System.out.println("type: " + type + " idTemp: " + idTemp);
            emit(String.format("\t%s = getelementptr i8, i8* %%this, i32 %s\n", temp0, res[1]));
            emit(String.format("\t%s = bitcast i8* %s to %s*\n", temp1, temp0, type));
        } else {
            type = result;
            idTemp = "%" + id;
            // System.out.println("non-offset case -- type: " + type + " idTemp: " + idTemp);
        }

        if ((args.length == 3) && (args[2].equals("L"))) {
            // System.out.println("L case");
            return type + "* " + idTemp + className;
        }
        temp0 = newTemp();
        // System.out.println("R case");
        emit(String.format("\t%s = load %s, %s* %s\n", temp0, type, type, idTemp));
        return type + " " + temp0 + className;
    }

    /**
     * f0 -> "this"
     */
    @Override
    public String visit(ThisExpression n, String argu) throws Exception {
        if (argu.contains(","))    // return type of this as well, which is
            return "i8* %this" + argu.split(" ")[0];   // ",className" inside argu
        return "i8* %this";
    }

    // /**
    //  * f0 -> BooleanArrayAllocationExpression()
    //  * | IntegerArrayAllocationExpression()
    //  */
    // public R visit(ArrayAllocationExpression n, A argu) throws Exception {
    //     return n.f0.accept(this, argu);
    // }

    // /**
    //  * f0 -> "new"
    //  * f1 -> "boolean"
    //  * f2 -> "["
    //  * f3 -> Expression()
    //  * f4 -> "]"
    //  */
    // @Override
    // public String visit(BooleanArrayAllocationExpression n, String argu) throws Exception {
    //     // f3 must be of type "int"
    //     String type = n.f3.accept(this, argu);
    //     if (type.equals("int"))
    //         return "boolean[]";
    //     String[] args = argu.split(" "); // [0]: className, [1]: methodName
    //     throw new VisitorException("Type \"" + type
    //             + "\" does not match \"int\" type expected in array allocation expression in method \""
    //             + args[1] + "\" in class \"" + args[0] + "\"");
    // }

    /**
     * f0 -> "new"
     * f1 -> "int"
     * f2 -> "["
     * f3 -> Expression()
     * f4 -> "]"
     */
    @Override
    public String visit(IntegerArrayAllocationExpression n, String argu) throws Exception {
        String temp0 = newTemp(), temp1 = newTemp(), temp2 = newTemp(), temp3 = newTemp();
        String label0 = newArrAllocLabel(), label1 = newArrAllocLabel();
        String tempExpr = n.f3.accept(this, argu);
        String buffer = String.format("\t%s = icmp slt %s, 0\n", temp3, tempExpr)
                      + String.format("\tbr i1 %s, label %%%s, label %%%s\n\n", temp3, label0, label1)
                      + String.format("%s:\n\tcall void @throw_oob()\n\tbr label %%%s\n\n%s:\n", label0, label1, label1)
                      + String.format("\t%s = add %s, 1\n\t%s = call i8* @calloc(i32 4, i32 %s)\n", temp0, tempExpr, temp1, temp0)
                      + String.format("\t%s = bitcast i8* %s to i32*\n", temp2, temp1)
                      + String.format("\tstore %s, i32* %s\n", tempExpr, temp2)
        ;
        emit(buffer);

        return "i32* " + temp2;
    }

    /**
     * f0 -> "new"
     * f1 -> Identifier()
     * f2 -> "("
     * f3 -> ")"
     */
    @Override
    public String visit(AllocationExpression n, String argu) throws Exception {
        String className = n.f1.accept(this, null);
        if (argu == null)
            return className;
        int size = SymbolTable.getSizeOfClass(className);
        int num = SymbolTable.getMethodsNumOfClass(className);
        String temp0 = newTemp(), temp1 = newTemp(), temp2 = newTemp();
        String buffer = String.format("\t%s = call i8* @calloc(i32 1, i32 %s)\n", temp0, size)
                      + String.format("\t%s = bitcast i8* %s to i8***\n", temp1, temp0)
                      + String.format("\t%s = getelementptr [%s x i8*], [%s x i8*]* @.%s_vtable, i32 0, i32 0\n", 
                                        temp2, num, num, className)
                      + String.format("\tstore i8** %s, i8*** %s\n", temp2, temp1)
        ;
        emit(buffer);

        if (argu.contains(","))  // return type of allocation expression, which is 
            return "i8* " + temp0 + "," + className;   // identifier inside f1
        return "i8* " + temp0;
    }

    /**
     * f0 -> "!"
     * f1 -> Clause()
     */
    @Override
    public String visit(NotExpression n, String argu) throws Exception {
        String temp0 = newTemp();
        String clauseTemp = n.f1.accept(this, argu).split(" ")[1];

        emit(String.format("\t%s = xor i1 1, %s\n", temp0, clauseTemp));
        return "i1 " + temp0;
    }

    /**
     * f0 -> "("
     * f1 -> Expression()
     * f2 -> ")"
     */
    @Override
    public String visit(BracketExpression n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

}
