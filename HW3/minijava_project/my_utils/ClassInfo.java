package my_utils;

import java.lang.reflect.Method;
import java.util.*;

class ClassInfo {
    String superName;
    Map<String, String> fields; // String: fieldID, String: type
    Map<String, MethodInfo> methods; // String: methodID
    Map<String, Integer> fieldOffsets;
    Map<String, Integer> methodOffsets;
    int fieldOffsetEnd;
    int methodOffsetEnd;

    public ClassInfo() {
        superName = "";
        fields = new HashMap<String, String>();
        methods = new LinkedHashMap<String, MethodInfo>();
        fieldOffsets = new LinkedHashMap<String, Integer>();
        methodOffsets = new LinkedHashMap<String, Integer>();
        fieldOffsetEnd = 0;
        methodOffsetEnd = 0;
    }

    public ClassInfo(String e, int superFieldOffset, int superMethodOffset) {
        superName = e;
        fields = new HashMap<String, String>();
        methods = new LinkedHashMap<String, MethodInfo>();
        fieldOffsets = new LinkedHashMap<String, Integer>();
        methodOffsets = new LinkedHashMap<String, Integer>();
        fieldOffsetEnd = superFieldOffset;
        methodOffsetEnd = superMethodOffset;
    }

    public void printOffsets(String className) {
        System.out.println("--Variables---");
        for (Map.Entry<String, Integer> ite : fieldOffsets.entrySet()) {
            System.out.println(className + "." + ite.getKey() + " : " + ite.getValue());
        }
        System.out.println("---Methods---");
        for (Map.Entry<String, Integer> ite : methodOffsets.entrySet()) {
            System.out.println(className + "." + ite.getKey() + " : " + ite.getValue());
        }
    }

    String llvmType(String t) {
        if (t.equals("int"))
            return "i32";
        if (t.equals("boolean"))
            return "i1";
        if (t.equals("int[]"))
            return "i32*";
        return "i8*"; // TODO: is this correct ??
    }

    public String generateVTable(String className) {
        String methodName, buffer = "";
        MethodInfo m;
        // for each method (preserving their insertion order)
        for (Map.Entry<String, Integer> entry : methodOffsets.entrySet()) {
            methodName = entry.getKey();
            m = methods.get(methodName);
            buffer += String.format("%si8* bitcast (%s @%s.%s to i8*)",
                    buffer.isEmpty() ? "" : ", ", m.llvmPrototype(), className, methodName);
        }
        // System.out.println(buffer);
        return buffer;
    }
}