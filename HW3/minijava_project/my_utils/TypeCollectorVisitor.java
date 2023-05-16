package my_utils;

import syntaxtree.*;
import visitor.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;

/**
 * NOTE: first visitor reads all declarations, collecting
 * name and type of each symbol
 */

public class TypeCollectorVisitor extends GJDepthFirst<String, String>{
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
         * f1  -> Identifier()           | name of class
         * f11 -> Identifier()           | argument name of main class
         * f14 -> ( VarDeclaration() )*  | variable declarations of main
         */
        String className = n.f1.accept(this, null);
        String mainArgName = n.f11.accept(this, null);
        MethodInfo m = new MethodInfo("void", "String[]", mainArgName);  // collect info for main method

        String[] varDecl;
        for (Node node : n.f14.nodes) {    // for each VarDeclaration()
            varDecl = node.accept(this, null).split(" ");   // retrieve type and name of variable
            // insert variable name and type into scope of method
            if (! m.insertVar(varDecl[0], varDecl[1])) {
                throw new VisitorException("Duplicate declaration of variable \"" + varDecl[1]
                        + "\" in method \"main\" in class \"" + className + "\"");
            }
        }

        SymbolTable.insertMainClass(className, m);

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
        /* Symbol                         | Interesting content
         * --------------------------------------------------------
         * f1 -> Identifier()             | name of class
         * f3 -> ( VarDeclaration() )*    | field declarations
         * f4 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);
        SymbolTable.insertClass(className);

        // extract field declarations info
        String[] varDecl;
        for (Node node : n.f3.nodes) {    // for each VarDeclaration()
            varDecl = node.accept(this, null).split(" ");   // retrieve type and name of field
            SymbolTable.insertFieldOfClass(varDecl[0], varDecl[1], className);
        }

        if (n.f4.present()) { // extract info from all method declarations
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
        /* Symbol                         | Interesting content
         * -------------------------------------------------------------
         * f1 -> Identifier()             | name of class
         * f3 -> Identifier()             | name of super class
         * f5 -> ( VarDeclaration() )*    | field declarations
         * f6 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);
        String superName = n.f3.accept(this, null);
        SymbolTable.insertClass(className, superName);

        String[] varDecl;
        for (Node node : n.f5.nodes) {    // for each VarDeclaration()
            varDecl = node.accept(this, null).split(" ");    // retrieve type and name of field
            SymbolTable.insertFieldOfClass(varDecl[0], varDecl[1], className);
        }

        if (n.f6.present()) { // extract info from all method declarations
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
        return n.f0.accept(this, null) + " " + n.f1.accept(this, null);
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
        /* Symbol                            | Interesting content
         * ----------------------------------------------------------------------------------
         * f1 -> Type()                      | return type
         * f2 -> Identifier()                | method name
         * f4 -> ( FormalParameterList() )?  | parameter declarations
         * f7 -> ( VarDeclaration() )*       | variable declarations of method's scope
         */
        // NOTE: argu contains classname that this method declaration belongs to
        String returnType = n.f1.accept(this, null);
        MethodInfo m = new MethodInfo(returnType);  // collect info for this method
        String methodName = n.f2.accept(this, null);
        String[] varDecl;

        if (n.f4.present()) {   // collect types and names of arguments of this method
            String[] argList = n.f4.accept(this, null).split(",");
            
            for (String s : argList) {  // for each parameter declaration
                varDecl = s.split(" ");   // retrieve type and name of field
                m.argumentTypes.add(varDecl[0]);
                if (! m.insertVar(varDecl[0], varDecl[1])) {
                    throw new VisitorException("Duplicate declaration of parameter \"" + varDecl[1]
                            + "\" in method \"" + methodName + "\" in class \"" + argu + "\"");
                }
            }
        }

        for (Node node : n.f7.nodes) {    // for each VarDeclaration()
            varDecl = node.accept(this, null).split(" ");   // retrieve type and name of field
            // insert field name and type just retrieved into scope of method
            if (! m.insertVar(varDecl[0], varDecl[1])) {
                throw new VisitorException("Duplicate declaration of variable \"" + varDecl[1]
                        + "\" in method \"" + methodName + "\" in class \"" + argu + "\"");
            }
        }

        SymbolTable.insertMethodOfClass(methodName, m, argu);

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
     * f0 -> FormalParameter()
     * f1 -> FormalParameterTail()
     */
    @Override
    public String visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    /**
     * f0 -> ","
     * f1 -> FormalParameter()
     */
    @Override
    public String visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for ( Node node: n.f0.nodes) {
            ret += "," + node.accept(this, null);
        }

        return ret;
    }

    /**
     * f0 -> Type()
     * f1 -> Identifier()
     */
    @Override
    public String visit(FormalParameter n, String argu) throws Exception{
        return n.f0.accept(this, null) + " " + n.f1.accept(this, null);
    }

    /**
     * f0 -> "boolean"
     * f1 -> "["
     * f2 -> "]"
     */
    @Override
    public String visit(BooleanArrayType n, String argu) throws Exception {
        return "boolean[]";
    }

    /**
     * f0 -> "int"
     * f1 -> "["
     * f2 -> "]"
     */
    @Override
    public String visit(IntegerArrayType n, String argu) throws Exception {
        return "int[]";
    }

    @Override
    public String visit(BooleanType n, String argu) {
        return "boolean";
    }

    @Override
    public String visit(IntegerType n, String argu) {
        return "int";
    }

    @Override
    public String visit(Identifier n, String argu) {
        return n.f0.toString();
    }
}
