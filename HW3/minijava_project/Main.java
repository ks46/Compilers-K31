import syntaxtree.*;
import visitor.*;
import my_utils.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;

public class Main {
    public static void main(String[] args) throws Exception {
        if(args.length < 1){
            System.err.println("Usage: java Main [file1] [file2] ... [fileN]");
            System.exit(1);
        }

        boolean print_delimeter = args.length > 1;

        for (String arg: args) {    // for each argument provided, parse program
            if (print_delimeter)
                System.out.println("Parsing file: " + arg);
            FileInputStream fis = null;
            try {
                fis = new FileInputStream(arg);
                MiniJavaParser parser = new MiniJavaParser(fis);

                Goal root = parser.Goal();

                // System.err.println("Program parsed successfully.");

                TypeCollectorVisitor eval = new TypeCollectorVisitor();
                root.accept(eval, null);
                TypeCheckerVisitor eval2 = new TypeCheckerVisitor();
                root.accept(eval2, null);
                // SymbolTable.printOffsets();

                // create a new .ll file with the same name as the .java file
                arg = arg.replace(".java", ".ll");
                File file = new File(arg);
                file.createNewFile();
                FileWriter fw = new FileWriter(arg);

                CodeGeneratorVisitor eval3 = new CodeGeneratorVisitor(fw);
                root.accept(eval3, null);

                fw.close();
            } catch (ParseException ex) {
                System.out.println(ex.getMessage());
            } catch (FileNotFoundException ex) {
                System.err.println(ex.getMessage());
            } catch (VisitorException ex) {
                System.err.println(ex.getMessage() + '\n');
            } finally {
                SymbolTable.clear();
                try {
                    if (fis != null)
                        fis.close();
                } catch (IOException ex) {
                    System.err.println(ex.getMessage());
                }
            }
        }
    }
}
