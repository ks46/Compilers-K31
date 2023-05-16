package my_utils;

import syntaxtree.*;
import visitor.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;

/**
 * NOTE: second visitor does most of the type-checking job
 */

public class TypeCheckerVisitor extends GJDepthFirst<String, String> {
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
         * f15 -> ( Statement() )*       | statements
         */
        SymbolTable.classesTypeCheck();   // type-check contents of symbol table
        if (n.f15.present()) {  // type-check all statements
            n.f15.accept(this, SymbolTable.mainClassName + " main");  // scope inside symbol table
        }
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
         * f4 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);

        if (n.f4.present()) {  // type-check all methods
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
         * f6 -> ( MethodDeclaration() )* | method declarations
         */
        String className = n.f1.accept(this, null);

        if (n.f6.present()) {  // type-check all methods
            n.f6.accept(this, className);
        }
        return null;
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
         * -------------------------------------------------------------------
         * f1 -> Type()                      | return type
         * f2 -> Identifier()                | method name
         * f8 -> ( Statement() )*            | all statements
         * f10 -> Expression()               | must be same as return type
         */
        // NOTE: argu contains classname that this method declaration belongs to
        String type1 = n.f1.accept(this, null);
        String methodName = n.f2.accept(this, null);
        String classAndMethodName = argu + " " + methodName;

        if (n.f8.present()) {  // type-check all statements
            n.f8.accept(this, classAndMethodName);
        }
        // type of f10 should match type of f1
        String type2 = n.f10.accept(this, classAndMethodName);
        if (SymbolTable.typesMatch(type1, type2))
            return type1;
        throw new VisitorException("Expression type \"" + type2 + "\" does not match return type \"" + type1
                + "\" expected in method \"" + methodName + "\" in class \"" + argu + "\"");
    }

    @Override
    public String visit(BooleanArrayType n, String argu) throws Exception {
        return "boolean[]";
    }

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

    /**
     * f0 -> Block()
     * | AssignmentStatement()
     * | ArrayAssignmentStatement()
     * | IfStatement()
     * | WhileStatement()
     * | PrintStatement()
     */
    @Override
    public String visit(Statement n, String argu) throws Exception {
        n.f0.accept(this, argu);    // parse statement
        return null;    // statements have nothing to return
    }

    /**
     * f0 -> "{"
     * f1 -> ( Statement() )*
     * f2 -> "}"
     */
    @Override
    public String visit(Block n, String argu) throws Exception {
        if (n.f1.present()) {    // type-check all statements
            n.f1.accept(this, argu);    // argu is scope to start
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
        // types of f0 and f2 must match
        String[] typeAndId = n.f0.accept(this, argu).split(" ");
        String type1 = typeAndId[0], id = typeAndId[1];
        String[] args = argu.split(" ");    // [0]: className, [1]: methodName
        String type2 = n.f2.accept(this, argu);
        if (SymbolTable.typesMatch(type1, type2))
            return type1;
        throw new VisitorException("Type \"" + type2 + "\" does not match \"" + type1
                + "\" type expected in assignment of \"" + id + "\" in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
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
        // f0 must be of type either "int[]" or "boolean[]"
        // f2 must be of type "int"
        // f5 must be of type "int", if f0 is of type "int[]", otherwise "boolean"

        String[] typeAndId = n.f0.accept(this, argu).split(" ");
        String type1 = typeAndId[0], id = typeAndId[1];
        String[] args = argu.split(" ");    // [0]: className, [1]: methodName
        if (type1.equals("int[]") || type1.equals("boolean[]")) {
            String type2 = n.f2.accept(this, argu);
            if (type2.equals("int")) {
                String type3 = n.f5.accept(this, argu);
                if (type1.split("\\[")[0].equals(type3))
                    return null;
                throw new VisitorException("Type \"" + type3 + "\" does not match \"" + type1.split("\\[")[0]
                        + "\" type expected in array assignment of \"" + id + "\" in method \""
                        + args[1] + "\" in class \"" + args[0] + "\"");
            }
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in array assignment of \"" + id
                    + "\" in method \"" + args[1] + "\" in class \"" + args[0] + "\"");
        }
        throw new VisitorException("Invalid array type \"" + type1 + "\" in array assignment of \"" 
                + id + "\" in method \"" + args[1] + "\" in class \"" + args[0] + "\"");
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
        // f2 must be of type "boolean"
        String type = n.f2.accept(this, argu);
        if (type.equals("boolean")) {
            n.f4.accept(this, argu);
            n.f6.accept(this, argu);
            return null;
        }
        String[] args = argu.split(" ");
        throw new VisitorException("Expression type \"" + type
                + "\" does not match \"boolean\" type expected in if statement in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
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
        // f2 must be of type "boolean"
        String type = n.f2.accept(this, argu);
        if (type.equals("boolean")) {
            n.f4.accept(this, argu);
            return null;
        }
        String[] args = argu.split(" ");
        throw new VisitorException("Expression type \"" + type
                + "\" does not match \"boolean\" type expected in while statement in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");

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
        // f2 must be of type "int"
        String type = n.f2.accept(this, argu);
        if (type.equals("int"))
            return null;
        String[] args = argu.split(" ");
        throw new VisitorException("Expression type \"" + type
                + "\" does not match \"int\" type expected in print statement in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
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
     *       | PrimaryExpression()
     */
    @Override
    public String visit(Expression n, String argu) throws Exception {
        return n.f0.accept(this, argu);  // return type of result
    }

    /**
     * f0 -> Clause()
     * f1 -> "&&"
     * f2 -> Clause()
     */
    @Override
    public String visit(AndExpression n, String argu) throws Exception {
        // both f0 and f2 must be of type "boolean"
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("boolean")) {
            if (type2.equals("boolean"))
                return "boolean";
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"boolean\" type expected in second clause of and expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type1
                + "\" does not match \"boolean\" type expected in first clause of and expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "<"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(CompareExpression n, String argu) throws Exception {
        // both f0 and f2 must be of type "int"
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("int")) {
            if (type2.equals("int"))
                return "boolean";
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in second expression of compare expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type1
                + "\" does not match \"int\" type expected in first expression of compare expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "+"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(PlusExpression n, String argu) throws Exception {
        // both f0 and f2 must be of type "int"
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("int")) {
            if (type2.equals("int"))
                return "int";
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in second expression of plus expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type1
                + "\" does not match \"int\" type expected in first expression of plus expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "-"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(MinusExpression n, String argu) throws Exception {
        // both f0 and f2 must be of type "int"
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("int")) {
            if (type2.equals("int"))
                return "int";
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in second expression of minus expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type1
                + "\" does not match \"int\" type expected in first expression of minus expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "*"
     * f2 -> PrimaryExpression()
     */
    @Override
    public String visit(TimesExpression n, String argu) throws Exception {
        // both f0 and f2 must be of type "int"
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("int")) {
            if (type2.equals("int"))
                return "int";
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in second expression of times expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type1
                + "\" does not match \"int\" type expected in first expression of times expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "["
     * f2 -> PrimaryExpression()
     * f3 -> "]"
     */
    @Override
    public String visit(ArrayLookup n, String argu) throws Exception {
        // f0 must be of type either "int[]" or "boolean[]"
        // f2 must be of type "int"
        // return "int" if f0 is "int[]", "boolean" otherwise
        String type1 = n.f0.accept(this, argu);
        String type2 = n.f2.accept(this, argu);

        if (type1.equals("int[]") || type1.equals("boolean[]")) {
            if (type2.equals("int")) 
                return type1.split("\\[")[0];
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            throw new VisitorException("Type \"" + type2
                    + "\" does not match \"int\" type expected in array lookup expression in method \""
                    + args[1] + "\" in class \"" + args[0] + "\"");
        }
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Invalid type \"" + type1 + "\" in array lookup expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> PrimaryExpression()
     * f1 -> "."
     * f2 -> "length"
     */
    @Override
    public String visit(ArrayLength n, String argu) throws Exception {
        // f0 must be of type either "int[]" or "boolean[]"
        // return "int"
        String type = n.f0.accept(this, argu);

        if (type.equals("int[]") || type.equals("boolean[]"))
            return "int";
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Invalid type \"" + type + "\" in array length expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
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
        // f0 must be of class type
        // f2 must be a method compatible with this class type  
        // f4 must match types of parameters in method declaration, respectively

        String types, type = n.f0.accept(this, argu);
        String methodName = n.f2.accept(this, null);
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        String errString = "in message send of \"" + methodName + "\" in method \"" + args[1] + "\" in class \"" + args[0] + "\"";
        if (!SymbolTable.isClassName(type)) {
            throw new VisitorException("Invalid class type \"" + type + "\" " + errString);
        }
        types = (n.f4.present()) ? n.f4.accept(this, argu) : "";
        return SymbolTable.methodTypesMatch(type, methodName, types, errString);
    }

    /**
     * f0 -> Expression()
     * f1 -> ExpressionTail()
     */
    @Override
    public String visit(ExpressionList n, String argu) throws Exception {
        return n.f0.accept(this, argu) + n.f1.accept(this, argu);
    }

    /**
     * f0 -> ( ExpressionTerm() )*
     */
    @Override
    public String visit(ExpressionTail n, String argu) throws Exception {
        String typeNames = "";
        for (Node node : n.f0.nodes) {
            // join all types of expressions using a single space as separator
            typeNames += " " + node.accept(this, argu);
        }
        return typeNames;
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
    *       | PrimaryExpression()
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
        return n.f0.accept(this, argu).split(" ")[0];
    }

    @Override
    public String visit(IntegerLiteral n, String argu) throws Exception {
        return "int";
    }

    @Override
    public String visit(TrueLiteral n, String argu) throws Exception {
        return "boolean";
    }

    @Override
    public String visit(FalseLiteral n, String argu) throws Exception {
        return "boolean";
    }

    @Override
    public String visit(Identifier n, String argu) throws Exception {
        String id = n.f0.toString();
        if (argu != null) {     // return identifier and its type
            String[] args = argu.split(" "); // [0]: className, [1]: methodName
            String type1 = SymbolTable.getTypeOfId(id, args[0], args[1]);
            return type1 + " " + id;
        }
        return id;
    }

    /**
     * f0 -> "this"
     */
    @Override
    public String visit(ThisExpression n, String argu) throws Exception {
        return argu.split(" ")[0]; // return its className as type
    }

    /**
     * f0 -> "new"
     * f1 -> "boolean"
     * f2 -> "["
     * f3 -> Expression()
     * f4 -> "]"
     */
    @Override
    public String visit(BooleanArrayAllocationExpression n, String argu) throws Exception {
        // f3 must be of type "int"
        String type = n.f3.accept(this, argu);
        if (type.equals("int"))
            return "boolean[]";
        String[] args = argu.split(" ");    // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type
                + "\" does not match \"int\" type expected in array allocation expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> "new"
     * f1 -> "int"
     * f2 -> "["
     * f3 -> Expression()
     * f4 -> "]"
     */
    @Override
    public String visit(IntegerArrayAllocationExpression n, String argu) throws Exception {
        // f3 must be of type "int"
        String type = n.f3.accept(this, argu);
        if (type.equals("int"))
            return "int[]";
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type
                + "\" does not match \"int\" type expected in array allocation expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> "new"
     * f1 -> Identifier()
     * f2 -> "("
     * f3 -> ")"
     */
    @Override
    public String visit(AllocationExpression n, String argu) throws Exception {
        String type = n.f1.accept(this, null);
        // must be a name of class
        if (SymbolTable.isClassName(type))
            return type;
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Invalid type \"" + type + "\" in allocation expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
    }

    /**
     * f0 -> "!"
     * f1 -> Clause()
     */
    @Override
    public String visit(NotExpression n, String argu) throws Exception {
        // f1 must be of type "boolean"
        String type = n.f1.accept(this, argu);
        if (type.equals("boolean"))
            return "boolean";
        String[] args = argu.split(" "); // [0]: className, [1]: methodName
        throw new VisitorException("Type \"" + type
                + "\" does not match \"boolean\" type expected in not expression in method \""
                + args[1] + "\" in class \"" + args[0] + "\"");
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
