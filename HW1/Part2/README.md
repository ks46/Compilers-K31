# Implementation of a parser for a language supporting string operations and translation into a subset of Java

## Makefile options

* make compile
* make execute
* make test: run bash script `test.sh` which tests the results of the program against several test cases

## Project structure

* `scanner.flex` contains the implementation of the scanner using JFlex
* `parser.cup` contains the implementation of the grammar rules
* `test.sh` is a simple bash file that test the results of the program against several test cases
* `test_files` directory contains several input files that can be used as test cases for the program
* `test_files/results` directory contains the expected output for each input file in `test_files`
* `output_files` directory contains the output of the program, that is, the Main.java file created and the result of the execution of the code inside Main.java

## Assignment description

In the second part of this homework you will implement a parser and translator for a language supporting string operations. The language supports concatenation (+) and "reverse" operators over strings, function definitions and calls, conditionals (if-else i.e, every "if" must be followed by an "else"), and the following logical expression:

is-prefix-of (string1 prefix string2): Whether string1 is a prefix of string2.
All values in the language are strings.

The precedence of the operator expressions is defined as: precedence(if) < precedence(concat) < precedence(reverse).

Your parser, based on a context-free grammar, will translate the input language into Java. You will use JavaCUP for the generation of the parser combined either with a hand-written lexer or a generated-one (e.g., using JFlex, which is encouraged).

You will infer the desired syntax of the input and output languages from the examples below. The output language is a subset of Java so it can be compiled using javac and executed using Java or online Java compilers like [this](http://repl.it/languages/java), if you want to test your output.

There is no need to perform type checking for the argument types or a check for the number of function arguments. You can assume that the program input will always be semantically correct.

As with the first part of this assignment, you should accept input programs from stdin and print output Java programs to stdout. For your own convenience you can name the public class "Main", expecting the files that will be created by redirecting stdout output to be named "Main.java".. In order to compile a file named Main.java you need to execute the command: javac Main.java. In order to execute the produced Main.class file you need to execute: java Main.

To execute the program successfully, the "Main" class of your Java program must have a method with the following signature: public static void main(String[] args), which will be the main method of your program, containing all the translated statements of the input program. Moreover, for each function declaration of the input program, the translated Java program must contain an equivalent static method of the same name. Finally, keep in mind that in the input language the function declarations must precede all statements.

### Example 1
#### Input:
```
name()  {
    "John"
}

surname() {
    "Doe"
}

fullname(first_name, sep, last_name) {
    first_name + sep + last_name
}

name()
surname()
fullname(name(), " ", surname())
```

#### Output (Java):
```
public class Main {
    public static void main(String[] args) {
        System.out.println(name());
        System.out.println(surname());
        System.out.println(fullname(name(), " ", surname()));
    }

    public static String name() {
        return "John";
    }

    public static String surname() {
        return "Doe";
    }

    public static String fullname(String first_name, String sep, String last_name) {
        return first_name + sep + last_name;
    }
}
```

### Example 2
#### Input:
```
name() {
    "John"
}

repeat(x) {
    x + x
}

cond_repeat(c, x) {
    if (c prefix "yes")
        if("yes" prefix c)
            repeat(x)
        else
            x
    else
        x
}

cond_repeat("yes", name())
cond_repeat("no", "Jane")
```

### Example 3
#### Input:
```
findLangType(langName) {
    if ("Java" prefix langName)
        if(langName prefix "Java")
            "Static"
        else
            if(reverse "script" prefix reverse langName)
                "Dynamic"
            else
                "Unknown"
    else
        if (reverse "script" prefix reverse langName)
            "Probably Dynamic"
        else
            "Unknown"
}

findLangType("Java")
findLangType("Javascript")
findLangType("Typescript")
```