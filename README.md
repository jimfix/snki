<h1 align="center">Program 0: Snek Interpreter</h1>
<h2 align="center">Reed CSCI 394 Fall 2026</h2>

# Overview

Your assignment is to extend an interpreter for **MiniSnek**, a subdialect
of a Pythonic programming language that we are developing this semester.
In this starter code's current state, **Snek** programs are only "straight
line." There are no conditionals, loops, or function definitions.
This limited syntax of **MiniSnek** is given by the following grammar:
~~~ none
<prgm> ::= <blck>
<blck> ::= { <stmt> EOLN }+ 
<stmt> ::= <name> = <expn>
         | pass
         | print ( <expn> )
<expn> ::= <addn>
<addn> ::= <mult> { <pmop> <mult> }*
<pmop> ::= + | -
<mult> ::= <leaf> { <tdop> <leaf> }*
<tdop> ::= * | //
<leaf> ::= <name> | <ltrl> | <blti> ( <strg> ) | ( <expn> )
<name> ::= x | count | _special | y0 | camelWalk | snake_slither | ...
<ltrl> ::= <nmbr> | <strg>
<nmbr> ::= 0 | 1 | 2 | 3 | ...
<strg> ::= "hello" | "" | "say \"yo!\n\tyo.\"" | ...
<blti> ::= input | int | str | len
~~~
The above spec is using a variant of BNF (Backus-Naur form).
You see a series of *production rules*, one for each of
the `<braced-terms>`. These are grammar variables (also called
*non-terminals*). They correspond to the "parts of speech", the
constructs of a **Snek** program. The right hand sides of each production
give one or several cases for what the syntax of that construct. These
are a mix of non-terminals and also *terminals*, the *tokens* that
denote the literal text (excluding, e.g. whitespace) that make up the
body of a Snek program. 

Each set of production rules has a variable on the left, followed by
a `::=`, followed by one or more cases, separated by vertical bars `|`.
There is regular expression-like notation used, and my convention is
to use curly braces to block them off. These are as follows:
* `{ some-syntax }*` for zero or more repeats
* `{ some-syntax }+` for one or more repeats
* `{ some-syntax }?` optional, i.e. one or none
Here is a sample program that conforms to this grammar:
~~~ python
c = int(input("Temperature in degrees celsius? "))
f = (c * 9 // 5) + 32
print(f)
~~~
You can see that a **MiniSnek** program just consists of a non-empty *block* of
statements, with each statement `<stmt>` ending with an end-of-line
character denoted `EOLN`.
There are only two supported value types currently: strings and integers.
And then there are only three kinds of statements: an assignment, an output, and a no-op statement `pass`.
You can `print` calculated values as a line of output.
You can store calculated values with an identifying name using `=`.
These names identify the program's variables (they are also often called *identifiers*) and the stored value associated with each name can be looked up and used in later calculations.
Calculations are expressed as *expressions* and their syntax is given by `<expn>`. 

There are built-in functions for getting an string of `input` with a string prompt, converting values using `str` and `int`, and computing the `len` of a string.

**The Interpreter**

I've written a basic interpreter for **Snek**.
It is provided as a compressed folder from `.zip` file link just below:

* [snki.zip](snki.zip) - starter code for this assignment.

You can also get this same folder from my `jimfix` github as the repo  `csci394-p0`.

The interpreter can be built and then run with the following two commands:

~~~ none
    make snki
    ./snki my-first.snk
~~~

The latter command runs the interpreter on a text file `my-first.snk`
that consists of **Snek** program source code. It is also possible to debug or
study the front end's work. If you instead enter

~~~ none
    ./snki --tokens my-first.snk
~~~

You'll also get text output showing the sequence of tokens built by the
lexical analyzer. And if you enter

~~~ none
    ./snki --pprint my-first.snk
~~~

You'll get a "pretty print" of the source code, having been processed
by the parser, including full parenthesization of expressions. This
printing happens instead of the execution of the code.

**The Interpreter Layout**

The interpreter is made up of several components, laid out below:

* `snek-lex.{cc,hh}`: the lexical analyzer. Defines `Tokenizer` which processes the source file and returns a `TokenStream` object with the method `lex`.

* `snek-parse.{cc,hh}`: this parses a `TokenStream` according to the grammar for **Snek** given above. It produces an *abstract syntax tree* (or *AST*) used as the internal representation of the **Snek** program.

* `snek-ast.{cc,hh}`: this defines the class hierarchy for the nodes of a **Snek** tree. Each node object has methods for pretty printing them (`output`) and and either has methods for executing them (when programs, blocks, and statements) or evaluating them (when calculation expressions).

* `snki.cc`: this is just the `main` for the interpreter.

In this assignment, you will modify this code to enhance the
**Snek** language. Part of the work will involve you writing tests-- in
the form of `.snk` files along with their expected output-- that we
can all use to test our extensions. Part of the work requires you to
read some of the existing code and to mimic it when you write your
extensions. We'll also talk about the design in lecture. I'm happy to
answer any questions about the existing code, or to give suggestions for
how the enhancement code should be written.

The exercises follow.

# Test Suite Exercises

## Exercise: Write tests

Below this item (after the `--tree` one) are a list of exercises that
direct you to enhance the interpreter in some way. Write a series of
tests that we all can use to test our work. Make at least 20, with
each being a `.snk` script source file, a series of `.inpt` files
that consist of lines needed to feed that script, and `.gold` text
files that each give the expected *golden* output of the interpreter,
one for each `.inpt` file.

At least twenty of the tests should be correct. And at least twenty of
the tests you provide should cause errors for the interpreter.  For
example, these could be a syntax error in the code like `(2 ** print)`
instead of `(2 ** 10)` or `(2 ** x) when `x` is defined,
or a semantic error in the code like `(2 **x)` with `x` never defined.

If some program should cause an error during processing by `snki`, the
`.gold` file should just be a single line that says `ERROR`.

Name the tests with their exercise and a short name suggesting what's
tested, like say `ex3-assoc-check.snk` or `ex3-power-error.snk`.
Name each sample's inputs accordingly, for example `ex3-assoc-check-1.inpt`.
or `ex3-assoc-check-2.inpt`. Also name each input file's golden
output accordingly, like `ex3-assoc-check-2.gold`.

You need only have one `.inpt` (and hence only one `.gold`) for each
`.snk` you produce. Even so, you might find it useful for your own testing
to have several input files for a script.

**Example**

Just as a concrete example, suppose I had an **Exercise 3.99** that asked you
to add a `%` operator to **Snek**. Then I might write the following test
as `ex99-check-simple.snk`.

~~~ python
# Test for Exercise 99.
n = int(input("Enter a number.\n")
d = int(input("Enter a divisor.\n")
print(n % d)
~~~

I could see also including this `ex99-check-simple-1.inpt`

~~~ none
37
10
~~~

and this as a `ex99-check-simple-2.inpt`

~~~ none
37
0
~~~

If I did that, I would also submit these respective `.gold` files:

~~~ none
Enter a number.
Enter a divisor.
7
~~~

and also (to test division by 0)

~~~ none
ERROR
~~~

The former would be `ex99-check-simple-1.inpt` and the latter would be
`ex99-check-simple-2.inpt`. Notice that the error golden output doesn't have
anything else in it, even though an interpreter might output *some* stuff
before the division by 0 error was raised.

**Using Python3**

Since the **MiniSnek** conforms to **Python**, both its syntax and (most of its semantics), you can perhaps use `python3` to generate your `.gold` outputs. 

**Summary**

Submit at least 20 `.snk` files along with the `.inpt` and `.gold` files that
come with each. At least 10 of these should be working **Snek** code. At least 10 of these `.snk` test files should include some `ERROR` among their `.gold` outputs.

# Interpreter Enhancement Exercises

## Exercise: `--dump` for `Stmt`

I've written code for the `dump` methods of several `AST` node types. 
These output to `cout` a textual representation of the parse tree for the SLPY program after it has been parsed. 
It is recursive and it outputs the AST node type, followed by indented dumps of all of its subtrees.
This method gets called, instead of running the code, when the interpreter is run with the `--dump` flag.

For example, the temperature program given above would have the following
dumped output:

~~~ none
% ./snki --dump temperature.snk
Prgm
    Blck
        Asgn
            c
            IntC
                Inpt
                    "Temperature in degrees celsius? "
        Asgn
            f
            BiOp
                +
                BiOp
                    //
                    BiOp
                        *
                        Lkup
                            c
                        Nmbr
                            9
                    Nmbr
                        5
                Nmbr
                    32
        Prnt
            Lkup
                f
~~~
Write now, however, the `dump` methods of the `Stmt` subclasses do not do anything and so the feature doesn't work.
Write these methods.

You do not need to write special tests for this exercise.
You can, however, easily use the tests you write to check your AST output.

# Interpreter Enhancement Exercises

## Exercise: right-associative `**`

Python has a integer power operator `**` that works like so:

~~~ python
>>> 4 ** 3 ** 2
262144
>>> (4 ** 3) ** 2
4096
>>> 4 ** (3 ** 2)
262144
~~~

Note that it is *right associative*. This means that the
unparenthesized expression `4 ** 3 ** 2` has the same AST
as `4 ** (3 ** 2)` as suggested by

~~~ none
BnOp "**"
    Nmbr
        4
    BnOp "**"
        Nmbr
            3
        Nmbr
            2
~~~

If instead it was *left associative*, it would have the same
AST as `(4 ** 3) ** 2` as suggested by

~~~ none
BnOp "**"
    BnOp "**"
        Nmbr
            4
        Nmbr
            3
    Nmbr
        2
~~~

Extend the `lex` method in `snek-lex.cc` so that it "tokenizes" `**`
as a token with string `"**"`. You'll want to mimic what I did for the
integer division operation `//`.

Extend `snek-ast.*` source so that it can represent parses of programs
that contain expressions that use `**`. You'll want to add a `Powr`
class that is a subclass of `Expn`.

Extend `snek-parse.*` so that it parses these expressions. You'll want to
mimic the modfied SLPY grammar:

~~~ none
...
<mult> ::= <expt> { <td> <expt> }*
<expt> ::= { <leaf> ** }* <leaf>
...
~~~

You'll want to modify `parseMult` and add a `parseExpt` that parse
according to these two productions. For the latter, you'll want to
mimic the loops that you see in both `parseAddn` and `parseMult`.

The tricky thing here is that `+`, `-`, `*`, and `//` are all
left associative operations. So something like `4 + 3 + 2` parses
to a differently shaped tree than `4 ** 3 ** 2`.

You should make sure that `parseExpt` respects right associativity.

## Exercise: `print` with multiple arguments

Modify the interpreter so that the `print` statement can take zero, one,
or more arguments. To do this you'll need to extend the lexical analyzer
so that it recognizes `,` tokens. (See how I handle the `(` and `)`
delimiters.) You'll need to modify the `Prnt` node so that it holds a
vector of expressions. And then finally you'll need to modify the parsing
of `print` in `parseStmt` so that it skips parsing between the parentheses
or loops one or more times to parse several expressions separated by commas.

Then of course, you'll need to modify the `Prnt` statements methods to
handle that vector of its arguments. For printing, their values
should all be output on one line, separated by spaces.

## Exercise: add the `+=` update statment

Add a new statement type of the form

~~~ none
<stmt> ::= <name> += <expn>
~~~

One way of handling this is by parsing variable updates as assignments
that use plus. Instead, I'd like you to add a new `Stmt` subclass of
type `Updt` that represents this construct. You'll want to
invent its attribute(s) and methods, and also change the parser so
that it handles programs that use `+=`.

**Optional**: One way to do this more generally is similar to how we handle binary operations.
You can have a `Stmt` subclass that handles updates for any binary operation, not just `+`.

## Optional: `<expn> if <expn> else <expn>` expression

Add a conditional expression to Snek that has the same syntax as the conditional expression in Python. 
Note that this is different than the more common conditional *statement* of Python.
The conditional *expression* is used by some programmers to write terse calculations whose result depends on some condition, for example here I'm using it as the right hand side of an assignment to a variable named `average`

~~~ none
average = 0 if count == 0 else sum // count
~~~

Change the parser to handle this kind of conditional expression.
You'll need to make a class for its nodes in the AST.
Name its object class `Cndl`. It should be a subclass of `Expn`.
That AST node will have three subtrees, one for each <expn>.

In doing so, you are adding boolean expressions to the language.
This should include the boolean literals `True` and `False`.
It should also have the boolean operators `and`, `or`, and `not`.
And you'll need comparison operations like `<` and `==`.

In adding these to the parser, you'll need need AST nodes for all these new expressions that will subclass `Expn`. 
And their `eval` method will return a `bool`. 
So you will need to change the `Valu` type so that it handles booleans, in addition to integers and strings.