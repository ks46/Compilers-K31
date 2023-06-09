# Implementation of a LL(1) parser for a simple calculator

## Makefile options

* make compile: compile the project
* make execute: execute the program
* make test: use a bash script to test the program against several testcases


## Assignment description

For the first part of this homework you should implement a simple calculator. The calculator should accept expressions with the bitwise AND(&) and XOR(^) operators, as well as parentheses. The grammar (for single-digit numbers) is summarized in:

exp -> num | exp op exp | (exp)

op -> ^ | &

num -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

You need to change this grammar to support priority between the two operators, to remove the left recursion for LL parsing, etc.

This part of the homework is divided in two parts:

For practice, you can write the FIRST+ & FOLLOW sets for the LL(1) version of the above grammar. In the end you will summarize them in a single lookahead table (include a row for every derivation in your final grammar). This part will not be graded.

You have to write a recursive descent parser in Java that reads expressions and computes the values or prints "parse error" if there is a syntax error. You don't need to identify blank space or multi-digit numbers. You can read the symbols one-by-one (as in the C getchar() function). The expression must end with a newline or EOF.


### Rules for The LL(1) version of the grammar
```
1. exp      -> term exptail
2. exptail  -> ^ term exptail
3.           | e
4. term     -> andop termtail
5. termtail -> & andop termtail
6.           | e
7. andop   -> (exp)
8.           | num
9. num    -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
```

### Single lookahead table
```
          |   ^   |   &   |  0-9  |   (   |   )   | $  \n 
-----------------------------------------------------------
 exp      | error | error |  #1   |  #1   | error | error 
 exptail  |  #2   | error | error | error |  #3   |  #3   
 term     | error | error |  #4   |  #4   | error | error 
 termtail |  #6   |  #5   | error | error |  #6   |  #6   
 andop    | error | error |  #8   |  #7   | error | error 
 num      | error | error |  #9   | error | error | error 
```

