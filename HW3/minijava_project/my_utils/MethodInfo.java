package my_utils;

import java.util.*;

class MethodInfo {
    String returnType;
    ArrayList<String> argumentTypes; // series of types of arguments that method declares
    Map<String, String> variables; // variables declared in method's scope -- String: ID, String: type

    public MethodInfo() {
        returnType = "";
        argumentTypes = new ArrayList<String>();
        variables = new HashMap<String, String>();
    }

    public MethodInfo(String r, String argType, String argName) {
        returnType = r;
        argumentTypes = new ArrayList<String>();
        argumentTypes.add(argType);
        variables = new HashMap<String, String>();
        variables.put(argName, argType);
    }

    public MethodInfo(String r) {
        returnType = r;
        argumentTypes = new ArrayList<String>();
        variables = new HashMap<String, String>();
    }

    public boolean insertVar(String type, String var) {
        if (variables.containsKey(var))
            return false;
        variables.put(var, type);
        return true;
    }

    String llvmType(String t) {
        if (t.equals("int"))
            return "i32";
        if (t.equals("boolean"))
            return "i1";
        if (t.equals("int[]"))
            return "i32*";
        return "i8*";
    }

    public String llvmPrototype() {
        String args = "i8*";
        for (String t : argumentTypes) {
            args += "," + llvmType(t);
        }
        return String.format("%s (%s)*", llvmType(returnType), args);
    }
}
