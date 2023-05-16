import java.io.InputStream;
import java.io.IOException;

/* Grammar Rules:
1. exp      -> term exptail
2. exptail  -> ^ term exptail
3.           | e
4. term     -> andop termtail
5. termtail -> & andop termtail
6.           | e
7. andop   -> (exp)
8.           | num
9. num    -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
**/

/* Single lookahead table
 *          |   ^   |   &   |  0-9  |   (   |   )   | $  \n |
 * ----------------------------------------------------------
 * exp      | error | error |  #1   |  #1   | error | error |
 * exptail  |  #2   | error | error | error |  #3   |  #3   |
 * term     | error | error |  #4   |  #4   | error | error |
 * termtail |  #6   |  #5   | error | error |  #6   |  #6   |
 * andop    | error | error |  #8   |  #7   | error | error |
 * num      | error | error |  #9   | error | error | error |
 */

/**
 * NOTE: instead of passing arguments into recursive calls of functions,
 * return the proper value so that the caller function perform the proper operation.
 * In case of xxxxtail -> e rule, return -1 so that the caller function does not perform any operations.
 */
class CalculatorEvaluator {
    private final InputStream in;
    private int lookahead;

    public CalculatorEvaluator(InputStream in) throws IOException {
        this.in = in;
        lookahead = in.read();
    }

    public int eval() throws IOException, ParseError {
        int result = Exp();
        if (lookahead != -1 && lookahead != '\n')
            throw new ParseError();
        return result;
    }

    private void consume(int symbol) throws IOException, ParseError {
        if (lookahead == symbol)
            lookahead = in.read();
        else
            throw new ParseError();
    }

    private boolean isDigit(int c) {
        return '0' <= c && c <= '9';
    }

    private boolean isLeftParenthesis(int c) {
        return (c == '(');
    }

    // methods for non-terminal symbols
    private int Exp() throws IOException, ParseError {
        // 1. exp -> term exptail
        int result1 = Term();
        int result2 = ExpTail();
        return (result2 == -1) ? result1 : (result1 ^ result2);
    }

    private int ExpTail() throws IOException, ParseError {
        switch (lookahead) {
            case '^':
                // 2. exptail -> ^ term exptail
                consume('^');
                int result1 = Term();
                int result2 = ExpTail();
                return (result2 == -1) ? result1 : (result1 ^ result2);
            case ')':   // consume ')' in AndOp(), to keep parentheses balanced
            case '\n':
            case -1:
                // 3. exptail -> e
                return -1;                 // don't consume anything, just return
        }
 
        throw new ParseError();
    }

    private int Term() throws IOException, ParseError {
        if (isDigit(lookahead) || isLeftParenthesis(lookahead)) {
            // 4. term -> andop termtail
            int result1 = AndOp();
            int result2 = TermTail();
            return (result2 == -1) ? result1 : (result1 & result2);
        }

        throw new ParseError();
    }

    private int TermTail() throws IOException, ParseError {
        switch (lookahead) {
            case '&':
                // 5. termtail -> & andop termtail
                consume('&');
                int result1 = AndOp();
                int result2 = TermTail();
                return (result2 == -1) ? result1 : (result1 & result2);
            case '^':
            case ')':
            case '\n':
            case -1:
                // 6. termtail -> e
                return -1;
        }

        throw new ParseError();
    }

    private int AndOp() throws IOException, ParseError {
        if (isLeftParenthesis(lookahead)) {
            // 7. andop -> (exp)
            consume('(');
            int result = Exp();
            consume(')');
            return result;
        }
        if (isDigit(lookahead)) {
            // rules 8. and 9. are turned into andop -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
            int num = lookahead - '0';          // store number of lookahead before consuming it
            consume(lookahead);
            return num;
        }
        throw new ParseError();
    }

}
