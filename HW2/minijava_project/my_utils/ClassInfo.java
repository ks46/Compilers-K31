package my_utils;

import java.util.*;

class ClassInfo {
    String superName;
    Map<String, String> fields; // String: fieldID, String: type
    Map<String, MethodInfo> methods; // String: methodID
    ArrayList<OffsetInfo> fieldOffsets;
    ArrayList<OffsetInfo> methodOffsets;

    public ClassInfo() {
        superName = "";
        fields = new HashMap<String, String>();
        methods = new HashMap<String, MethodInfo>();
        fieldOffsets = new ArrayList<OffsetInfo>();
        methodOffsets = new ArrayList<OffsetInfo>();
    }

    public ClassInfo(String e) {
        superName = e;
        fields = new HashMap<String, String>();
        methods = new HashMap<String, MethodInfo>();
        fieldOffsets = new ArrayList<OffsetInfo>();
        methodOffsets = new ArrayList<OffsetInfo>();
    }

    public void printOffsets(String className) {
        System.out.println("--Variables---");
        for (OffsetInfo entry : fieldOffsets) {
            System.out.println(className + "." + entry.name + " : " + entry.offset);
        }
        System.out.println("---Methods---");
        for (OffsetInfo entry : methodOffsets) {
            System.out.println(className + "." + entry.name + " : " + entry.offset);
        }
    }

    public int getFieldsOffsetEnd() {
        if (fieldOffsets.isEmpty()) {
            return 0;
        }
        OffsetInfo lastEntry = fieldOffsets.get(fieldOffsets.size() - 1);
        int offset = lastEntry.offset;
        String type = fields.get(lastEntry.name);
        if (type.equals("boolean"))
            return offset + 1;
        if (type.equals("int"))
            return offset + 4;
        return offset + 8;
    }

    public int getMethodsOffsetEnd() {
        if (methodOffsets.isEmpty())
            return 0;
        return 8 + methodOffsets.get(methodOffsets.size() - 1).offset;
    }

}


class OffsetInfo {
    int offset;
    String name;

    public OffsetInfo(String n, int o) {
        offset = o;
        name = n;
    }   
}