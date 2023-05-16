package my_utils;

import java.lang.reflect.Method;
import java.util.*;

public class SymbolTable {
    public static String mainClassName = "";
    public static MethodInfo mainMethod = null;     // info for main method of main class
    public static Map<String, ClassInfo> classes = new LinkedHashMap<String, ClassInfo>();
    /* NOTE: implemented as LinkedHashMap, so as to allow for fast lookup, while preserving order of insertion of items */

    public static void clear() {
        mainClassName = "";
        mainMethod = null;
        classes.clear();
    }

    public static String generateVTables() {
        ClassInfo c, superClass;
        String buffer = "@." + mainClassName + "_vtable = global [0 x i8*] []\n";
        String className, bufferClass, bufferSuper, methodName, prototype;
        MethodInfo m;
        Map<String, String> overriddenPrototypes = new HashMap<String, String>();
        // for each class in classes (preserving their order)
        for (Map.Entry<String, ClassInfo> ite : classes.entrySet()) {
            className = ite.getKey();
            c = ite.getValue();
            buffer += String.format("@.%s_vtable = global [%s x i8*] ", className, c.methodOffsetEnd / 8);
            // for each method in c, generate code for vtable
            bufferClass = "";
            for (Map.Entry<String, MethodInfo> entry : c.methods.entrySet()) {
                methodName = entry.getKey();
                m = entry.getValue();
                prototype = String.format("i8* bitcast (%s @%s.%s to i8*)", m.llvmPrototype(), className, methodName);
                if (c.methodOffsets.get(methodName) != null)
                    bufferClass += (bufferClass.isEmpty() ? "" : ", ") + prototype;
                else
                    overriddenPrototypes.put(methodName, prototype);
            }
            // for each super class of c, generate code for vtable
            while ((superClass = classes.get(c.superName)) != null) {
                className = c.superName;
                bufferSuper = "";
                // for each method in super methodsOffset
                for (Map.Entry<String, MethodInfo> entry : superClass.methods.entrySet()) {
                    methodName = entry.getKey();
                    m = entry.getValue();
                    if (superClass.methodOffsets.get(methodName) != null) {
                        if (overriddenPrototypes.containsKey(methodName)) {
                            prototype = overriddenPrototypes.remove(methodName);
                        } else {
                            prototype = String.format("i8* bitcast (%s @%s.%s to i8*)", m.llvmPrototype(), className, methodName);
                        }
                        bufferSuper += (bufferSuper.isEmpty() ? "" : ", ") + prototype;
                    } else {
                        overriddenPrototypes.put(methodName, String.format("i8* bitcast (%s @%s.%s to i8*)",
                                    m.llvmPrototype(), className, methodName));
                    }
                }
                bufferClass = bufferSuper + (bufferClass.isEmpty() ? "" : ", ") + bufferClass;
                c = superClass;
            }
            buffer += String.format("[%s]\n", bufferClass);
        }
        return buffer;
    }

    public static String llvmType(String t) {
        if (t.equals("int"))
            return "i32";
        if (t.equals("boolean"))
            return "i1";
        if (t.equals("int[]"))
            return "i32*";
        // if (classes.containsKey(t) || t.equals("int[]") || t.equals("boolean[]"))
        return "i8*";   // TODO: is this correct ??
    }

    public static void printOffsets() {
        String className;
        for (Map.Entry<String, ClassInfo> ite : classes.entrySet()) {
            className = ite.getKey();
            System.out.println("-----------Class " + className + "-----------");
            ite.getValue().printOffsets(className);
            System.out.println();   // to match output of offset files provided
        }
    }

    public static void insertMainClass(String className, MethodInfo m) {
        mainClassName = className;
        mainMethod = m;
    }

    public static void insertClass(String className, String superName) throws VisitorException {
        if (classes.containsKey(className) || className.equals(mainClassName)) {
            throw new VisitorException("Duplicate declaration of class \"" + className + "\"");
        }
        if (superName.equals(mainClassName)) {  // if this class extends main class
            classes.put(className, new ClassInfo());    // pretend that it does not have a super class
            return;
        }

        ClassInfo c = classes.get(superName);
        if (c == null) {    // super class must exist in ST
            throw new VisitorException("Class \"" + className + "\" extends from inexistent class \"" + superName + "\"");
        }
        classes.put(className, new ClassInfo(superName, c.fieldOffsetEnd, c.methodOffsetEnd));
    }

    public static void insertClass(String className) throws VisitorException {
        if (classes.containsKey(className) || className.equals(mainClassName)) {
            throw new VisitorException("Duplicate declaration of class \"" + className + "\"");
        }
        classes.put(className, new ClassInfo());
    }

    public static void insertFieldOfClass(String type, String name, String className) throws VisitorException {
        ClassInfo c = classes.get(className);
        if (c.fields.containsKey(name)) {
            throw new VisitorException("Duplicate declaration of field \"" + name + "\" in class \"" + className + "\"");
        }
        c.fields.put(name, type);
        /** NOTE: update fields offset
         * if this is the first field inserted in class, and class extends another class,
         * start counting from where super class left off, otherwise start counting from zero
         * else, increment offsets
         */
        int offset = c.fieldOffsets.isEmpty()
                     ? c.superName.equals("") ? 0 : classes.get(c.superName).fieldOffsetEnd
                     : c.fieldOffsetEnd;
        c.fieldOffsets.put(name, offset);
        if (type.equals("boolean"))
            c.fieldOffsetEnd++;
        else if (type.equals("int"))
            c.fieldOffsetEnd += 4;
        else
            c.fieldOffsetEnd += 8;
    }

    public static void insertMethodOfClass(String methodName, MethodInfo m, String className) throws VisitorException {
        ClassInfo superClass, c = classes.get(className);
        MethodInfo superMethod;

        if (c.methods.containsKey(methodName)) {
            throw new VisitorException("Duplicate declaration of method \"" + methodName + "\" in class \"" + className + "\"");
        }
        c.methods.put(methodName, m);   // insert method in class

        // check if method has been declared in super class
        for ( ; (superClass = classes.get(c.superName)) != null; c = superClass) {
            if ((superMethod = superClass.methods.get(methodName)) != null) {
                // check whether return types match
                if (!typesMatch(superMethod.returnType, m.returnType)) {
                    throw new VisitorException("Incompatible return types in method \"" + methodName + "\". Type is \""
                            + superMethod.returnType + "\" in declaration inside class \""
                            + c.superName + "\" and \"" + m.returnType + "\" in declaration inside class \"" + className + "\"");
                }
                // check whether argument types match, in the order they appear
                if (m.argumentTypes.size() != superMethod.argumentTypes.size()) {
                    throw new VisitorException("Incompatible number of arguments in method \"" + methodName
                            + "\". " + superMethod.argumentTypes.size() + " in declaration inside class \""
                            + c.superName + "\" and " + m.argumentTypes.size() + " in declaration inside class \"" + className + "\"");
                }
                for (int i = 0; i < m.argumentTypes.size(); ++i) {
                    if (! typesMatch(superMethod.argumentTypes.get(i), m.argumentTypes.get(i))) {
                        throw new VisitorException("Incompatible argument types in method \"" + methodName
                                + "\". #" + i + " argument has type \"" + superMethod.argumentTypes.get(i) + "\" in declaration inside class \""
                                + c.superName + "\" and \"" + m.argumentTypes.get(i) + "\" in declaration inside class \"" + className + "\"");
                    }
                }
                return;  // do not update methods offset
            }
        }

        /** NOTE: update methods offset, since such method does not exist in super class
         * if this is the first methd inserted in class, and class extends another class,
         * start counting from where super class left off, otherwise start counting from zero
         * else, increment methods offset
         */
        c = classes.get(className);

        int offset = c.methodOffsets.isEmpty()
                    ? c.superName.equals("") ? 0 : classes.get(c.superName).methodOffsetEnd
                    : c.methodOffsetEnd;
        c.methodOffsets.put(methodName, offset);
        c.methodOffsetEnd += 8;
    }

    public static boolean isType(String t) {
        return (classes.containsKey(t) || t.equals("int") || t.equals("int[]") ||
                t.equals("boolean") || t.equals("boolean[]"));
    }

    public static boolean isClassName(String t) {
        return classes.containsKey(t);
    }

    public static boolean isSubtypeOf(String typeB, String typeA) {
        for (ClassInfo c = classes.get(typeB); c != null; c = classes.get(c.superName)) {
            if (c.superName.equals(typeA))
                return true; // typeB is subtype of typeA
        }
        return false;
    }
    
    public static boolean typesMatch(String typeA, String typeB) {
        if (typeA.equals(typeB))
            return true;    // types are equal

        for (ClassInfo c = classes.get(typeB); c != null; c = classes.get(c.superName)) {
            if (c.superName.equals(typeA))
                return true;    // typeB is subtype of typeA
        }
        return false;   // types do not match
    }

    public static void classesTypeCheck() throws VisitorException {
        ClassInfo c;
        // type-check all variables of main method of main class
        for (Map.Entry<String, String> varEntry : mainMethod.variables.entrySet()) {
            if ((!isType(varEntry.getValue())) && (!varEntry.getValue().equals("String[]"))) {
                throw new VisitorException("Inexistent type \"" + varEntry.getValue() + "\" of variable \"" +
                        varEntry.getKey() + "\" declared in method \"main\" of class \"" + mainClassName + "\"");
            }
        }
        // for each class
        for (Map.Entry<String, ClassInfo> classEntry : classes.entrySet()) {
            c = classEntry.getValue();
            // type-check all fields of class
            for (Map.Entry<String, String> fieldEntry : c.fields.entrySet()) {
                if (!isType(fieldEntry.getValue())) {
                    throw new VisitorException("Inexistent type \"" + fieldEntry.getValue() + "\" of field \"" +
                            fieldEntry.getKey() + "\" declared in class \"" + classEntry.getKey() + "\"");
                }
            }
            // for each method of class
            for (Map.Entry<String, MethodInfo> methodEntry : c.methods.entrySet()) {
                // type-check all variables of method
                for (Map.Entry<String, String> varEntry : methodEntry.getValue().variables.entrySet()) {
                    if (!isType(varEntry.getValue())) {
                        throw new VisitorException("Inexistent type \"" + varEntry.getValue() + "\" of variable \"" +
                                varEntry.getKey() + "\" declared in method \"" + methodEntry.getKey() +
                                "\" of class \"" + classEntry.getKey() + "\"");
                    }
                }
            }
        }
    }

    public static String getIdInfoLLVM(String id, String className, String methodName) throws VisitorException {
        MethodInfo m;
        String type;
        int offset;
        for (ClassInfo c = classes.get(className); c != null; c = classes.get(c.superName)) {
            // search inside method of class
            m = c.methods.get(methodName);
            if ((m != null) && ((type = m.variables.get(id)) != null))
                return llvmType(type);  // TODO: is this ok ?
            // search inside fields of class
            if ((type = c.fields.get(id)) != null) {
                offset = 8 + c.fieldOffsets.get(id);
                return String.format("%s %s", llvmType(type), offset);//llvmType(type) + " " + offset; // TODO: is this ok ?
            }
            // search super class of class
        }
        if (className.equals(mainClassName))
            if ((type = mainMethod.variables.get(id)) != null) {
                return llvmType(type);  // TODO: is this ok ?
            }
        // id does not exist in this scope
        throw new VisitorException("Inexistent id \"" + id + "\" inside scope of class \"" + className + "\"");
    }

    public static String getTypeOfId(String id, String className, String methodName) throws VisitorException {
        MethodInfo m;
        String type;
        for (ClassInfo c = classes.get(className); c != null; c = classes.get(c.superName)) {
            // search inside method of class
            m = c.methods.get(methodName);
            if ((m != null) && ((type = m.variables.get(id)) != null))
                return type;
            // search inside fields of class
            if ((type = c.fields.get(id)) != null)
                return type;
            // search super class of class
        }
        if (className.equals(mainClassName))
            if ((type = mainMethod.variables.get(id)) != null)
                return type;
        // id does not exist in this scope
        throw new VisitorException("Inexistent id \"" + id + "\" inside scope of class \"" + className + "\"");
    }

    public static String methodTypesMatch(String className, String methodName, String types, String errString) throws VisitorException {
        MethodInfo m;
        String[] argTypes;
        for (ClassInfo c = classes.get(className); c != null; c = classes.get(c.superName)) {
            if ((m = c.methods.get(methodName)) != null) {
                if ((types.length() == 0) && m.argumentTypes.isEmpty())
                    return m.returnType;    // no arguments to type-check
                // check that all arguments have compatible types
                argTypes = types.split(" ");
                if (argTypes.length != m.argumentTypes.size()) {
                    throw new VisitorException("Incompatible number of arguments " + errString
                            + ". Declared with " + m.argumentTypes.size() + " arguments in class \""
                            + className + "\" and called with " + argTypes.length);
                }
                for (int i = 0; i < argTypes.length; ++i) {
                    if (! typesMatch(m.argumentTypes.get(i), argTypes[i])) {
                        throw new VisitorException("Incompatible argument types " + errString
                                + ". #" + i + " argument has type \"" + argTypes[i]
                                + "\" in method call and \"" + m.argumentTypes.get(i)
                                + "\" in declaration inside class \"" + className + "\"");
                    }
                }
                return m.returnType;  // all types match, return the return type of this method
            }
        }
        throw new VisitorException("Inexistent method \"" + methodName + "\" inside scope of class \"" + className + "\"");
    }

    public static int getSizeOfClass(String className) {
        return 8 + classes.get(className).fieldOffsetEnd;
    }

    public static int getMethodsNumOfClass(String className) {
        return classes.get(className).methodOffsetEnd / 8;
    }

    public static int getMethodOffset(String className, String methodName) throws VisitorException {
        for (ClassInfo c = classes.get(className); c != null; c = classes.get(c.superName)) {
            if (c.methodOffsets.containsKey(methodName)) {
                return c.methodOffsets.get(methodName) / 8;
            }
        }
        throw new VisitorException("Inexistent method \"" + methodName + "\" inside scope of class \"" + className + "\"");
    }

    public static String llvmMethodPrototype(String className, String methodName) throws VisitorException {
        MethodInfo m;
        for (ClassInfo c = classes.get(className); c != null; c = classes.get(c.superName)) {
            if ((m = c.methods.get(methodName)) != null) {
                return m.llvmPrototype();
            }
        }
        throw new VisitorException("Inexistent method \"" + methodName + "\" inside scope of class \"" + className + "\"");
    }

}