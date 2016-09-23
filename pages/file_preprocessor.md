---
layout: page-fullwidth
title: "The File Preprocessor"
permalink: "/docs/input/preprocessor/"
header: no
---

### _Purpose_

This page documents the functioning of the preprocessor.
Many files in the Questaal suite (e.g. the main input file
_ctrl.ext_{: style="color: green"}) are read through the prepocessor
before they are used.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

_____________________________________________________________

### _Main Features_

The preprocessor allows you to declare variables and evaluate expressions. It also possesses some
programming language capability, with branching control to skip or loop over a selected block of
lines.

the preprocesor is build into 
the source code, _rdfiln.f_{: style="color: green"}.
Comments at the beginning of _rdfiln.f_{: style="color: green"}
document directives it can process.  Here we use _rdfiln_{: style="color: green"}
as a name for the preprocessor.

#### String Substitution

_rdfiln_{: style="color: green"} curly brackets **{...}** specially and substitutes 
it for for **something-else**.
Typically **{...}** will contain an algebraic expression, which is evaluated as a binary number and rendered back as an ASCII 
representation of the number.

Thus the line

~~~
    talk {4/2} me
~~~
becomes

~~~
    talk 2 me
~~~
**{...}** can contain other kinds of syntax as well; see [below](/docs/input/preprocessor/#expression-substitution)

_Note:_{: style="color: red"}
The substitution <FONT size="+1"><tt>{...}</tt></FONT>&rarr;<FONT size="+1"><tt><i>string</i></tt></FONT>
may increase the length of the line.  If the modified line exceeds the maximum size it is truncated.
This maximum length is controlled by parameter **recln0** in the main program.
Source codes are distributed with **recln0=120**.

#### Variables

_rdfiln_{: style="color: green"} permits three kinds of variables: floating point scalar,
floating-point vector, and strings.  They can be declared with preprocessor directives
and also on the command-line using, e.g. `-vnam=expr`.  Symbol tables are maintained for each of the three kinds
of variables

Scalar variables and vector elements can be used in algebraic expressions.

_Note:_{: style="color: red"} As _rdfiln_{: style="color: green"} parses a file, it may create new variables, thus enlarging the symbols
table.  Variables allocated this way are temporary, however.  When _rdfiln_{: style="color: green"} has finished with whatever it is
reading, it destroys variables created by preprocessor directives. You can preserve variables for future use with the **% save** directive.

#### Variables Preprocessor Directives

The preprocessor treats the following specially.

+ Lines which begin with **#** are comment lines and are ignored. (More generally, text following a **#** in any line is ignored).
+ Lines beginning with **% directive** are directives to the preprocessor. Directives can perform various functions similar to a normal programming language, such as assigning variables, evaluating expressions, conditionally readings some lines, and repeated loops over sections of input.\\
  Such lines interpreted as a directive to do something. They will not appear in the preprocessor's output.

The following keywords are directives supported by _rdfiln_{: style="color: green"}:
<pre>
   const cconst cvar udef var vec char char0 cchar getenv vfind   &larr; allocate variables and assigns values
   if ifdef ifndef iffile else elseif elseifd endif               &larr; branching constructs for conditional reading of lines
   while repeat end                                               &larr; looping constructs for repeated looping of lines
   echo exit include includo macro save show stop trace udef      &larr; miscellaneous other constructs
</pre>
	
### _Expression Substitution_
{::comment}
/docs/input/preprocessor/#expression-substitution
{:/comment}

By enclosing a string in curly brackets, _viz_ **{strn}**, you instruct the preprocessor to
parse the contents of &nbsp;**{strn}**&nbsp; and substitute it with something else.

**strn** must have one of the following syntax:

1. it begins with the name of a character variable
2. it begins with a "**?**"
3. is the name of a declared vector or
4. is an algebraic expression.  Expressions use C-like syntax.

When it encounters &nbsp;**{strn}**&nbsp; _rdfiln_{: style="color: green"} makes one of the following transformations,
listed in order of precedence:

1. _string substitution_: If  &nbsp;**strn**&nbsp; is a
     **character variable**, the value of the variable is substituted.\\
    The variable _may_ be followed by a qualification (see 1a and 1b below).
2. _conditional string substitution_: If the first character of &nbsp;**strn**&nbsp; is &nbsp;"**?**"&nbsp;
     it treats &nbsp;**strn**&nbsp; as a C-like conditional expression.  See 1c below.
3. _vector variable substitution_ If &nbsp;**strn**&nbsp; is a
     **vector variable**, &nbsp;**strn**&nbsp; is replaced by a
     character representation of the vector. See 2 below.
4. _algebraic expression substitution_ &nbsp;**strn**&nbsp; is parsed as an algebraic expression, or a sequence
      of expressions, and is replaced by a character representation of
      the numerical value of the (last) expression. See 3a and 3b below.


The syntax for string, vector, and algebraic substitutions is explained by rules 1, 2, 3 below, listing them in order of precedence.
_rdfiln_{: style="color: green"} parses &nbsp;**strn**&nbsp; as follows:


1. **strn** consists of (or begins with) a character variable, say **myvar**.

   a. **strn** is a character variable.
       _rdfiln_{: style="color: green"} replaces **{myvar}** with contents of **myvar**.\\
       This rule takes precedence if a character variable **myvar** exists.

   b. Similar to (1a), but &nbsp;**strn**&nbsp; is followed by a qualifier (...),
       which must be one of the following:

      * **(integer1,integer2)** returns a substring of &nbsp;**strn**.
       {myvar(n1,n2)} is replaced by the (n1:n2) substring of **myvar**.\\
       _Example_: If myvar="foo bar", **{myvar(2,3)}** &rarr; **oo**.

      * **(chrlst,n)** returns a number indicating the location where **chrlst** is found.
       **chrlst** is a sequence of characters, equivalent to regular expression [**chrlst**]:
       the contents of **myvar** is parsed for any character in **chrlst**.\\
       _Example_:  let myvar="foo bar" and chrlst='abc'.
       Note that "foo bar" contains characters 'b' and 'a' so
       **{myvar('abc',2)} &rarr; **6** , which is the index in "foo bar" that contains 
       the second occurrence of a character in [abc].\\
       Note: **n** is optional: if omitted, the preprocessor uses **n=1**.

      *(:e) returns an integer marking last nonblank character.\\
         _Example_: If myvar='foo bar', {myvar(:e)} &rarr; 7.

      *(/'**strn1**'/'**strn2**'/,**n**1,**n**2) substitutes **strn2** for **strn1**.\\
       _Example_ If **myvar="foo boor"**, then {myvar(/'oo'/a/,2,2)} &rarr; "foo bar"
       Substitutions are made for the **n**1<sup>th</sup> to **n**2<sup>th</sup> occurrence of **strn1**.
       **n**1 and **n**2 are optional, as are the quotation marks.

2. **strn** takes the form **{?~**expr**~**strn1**~**strn2**}**  (the '~' can be any character).
       **expr** is an algebraic expression; **strn1** and **strn2** are strings.
       _rdfiln_{: style="color: green"} returns either **strn1** or **strn2**, depending on the result of **expr**:
         {?~**expr**~**strn1**~**strn2**}    &larr;  
       + If **expr** evaluates to nonzero, **{...}** is replaced by **strn1**.
       + If **expr** evaluates to zero, **{...}** is replaced by **strn2**.

3. **strn** is name of a vector variable, say **myvec**..
       _rdfiln_{: style="color: green"} replaces  {myvec}  with a sequence of numbers separated
       by one space, which are the contents of **myvec**..
       **Example** : suppose a **myvec**. <A href="#vectordef">has been declared</A> as a 5-element quantity:
         % vec myvec[5] 6-1 6-2 5-2 5-3 4-3
       Then
         {myvec}
       is turned into
         5 4 3 2 1
       You can also substitute a single element.  Thus
         {myvec(2)}
       is transformed into
         4

   3a. **strn** is an algebraic expression composed of, numbers, <A href="#variabledecl">scalar variables</A>,
       elements of <A href="#vectordef">vector variables</A>, and <A href="#macrodef">macros</A>, combined with unary and binary operators.
       The <A href="#exprsyntax">syntax is very similar to C</A>.
       rdfiln parses &nbsp;**strn**&nbsp; to obtain a binary number, renders the result in ASCII form, and
       substitutes the result in place of &nbsp;**strn**.

   3b. is an extension of 3a.  **strn**&nbsp; may consist of a sequence of assignments of variables to expressions.
       The assignment may be a simple one (`<FONT size="+1"><tt>=</tt></FONT>') or <A href="#assignmentops">involve an arithmetic operation</A>.
       Members of the sequence separated by commas.  For each member a variable is assigned to an expression.
       rdfiln returns the value of the last expression.
         **Examples**:
         {x=3}               &larr;  assigns x to 3 and returns '3'
         {x=3,y=4}           &larr;  assigns x to 3 and y to 4, and returns '4'
         {x=3,y=4,x*=y}      &larr;  assigns x to 3*4 and y to 4, and returns '4'

       The last expression need not have an <A href="#assignmentops">assignment operator</A>.  Thus

         {x=3,y=4,x*=y,x*2}  &larr;  assigns x to 3*4 and y to 4, and returns '24'

<h3><A name="nesting"></A>Further properties of curly brackets {...} </h3>

Brackets <FONT size="+1"><tt>{..}</tt></FONT> may be <FONT color="#0000bb"><I>nested</I></FONT>.
_rdfiln_{: style="color: green"} will work recursively
through deeper levels of bracketing, substituting <FONT size="+1"><tt>{..}</tt></FONT> at each level with
a result before returning to the higher level.  <br>
<i>Example</i>: Suppose &nbsp;<FONT size="+1"><tt>{foo}</tt></FONT>&nbsp; evaluates to 2. Then:
<pre>
  {my{foo}bar}</pre>
will be transformed into
<pre>
  {my2bar}</pre>
and finally the result of &nbsp;<FONT size="+1"><tt>{my2bar}</tt></FONT>&nbsp; evaluated.

If _rdfiln_{: style="color: green"} cannot evaluate <FONT size="+1"><tt>{my2bar}</tt></FONT> it will abort with a message similar to this one:
<pre>
 rdfile: bad expression in line
 {  ...  my2bar}
</pre>

<P> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> the syntactical difference between <FONT size="+1"><tt>{..}</tt></FONT> and
<FONT size="+1"><tt>(..)</tt></FONT>.  The latter applies to only algebraic expressions, while the former offers other possibilities
as we have noted.  But even when <FONT size="+1"><tt>{..}</tt></FONT> contains an algebraic expression its effect can be a little different from
<FONT size="+1"><tt>(..)</tt></FONT>. Curly brackets put _rdfiln_{: style="color: green"} in a special mode where it replaces <FONT size="+1"><tt>{..}</tt></FONT> with
another string.  Thus &nbsp;<FONT size="+1"><tt>{pi-3}</tt></FONT>&nbsp; is replaced by
<A href="#sourcecodes">&nbsp;<FONT size="+1"><tt>.14159265</tt></FONT></A>&nbsp;, whereas
&nbsp;<FONT size="+1"><tt>(pi-3)</tt></FONT>&nbsp; is kept in a binary representation of
&nbsp;<FONT size="+1"><tt>&pi;-3</tt></FONT>, with about 16 decimal digits precision.
Note moreover that you can use expressions <FONT size="+1"><tt>(..)</tt></FONT> either <i>inside</i> curly brackets, in which case they form
part of an expression that will be rendered in ASCII form as a modification of the input, or <i>outside</i> curly brackets.  The input system
(which reads whatever the preprocessor returns) can also parse algebraic expressions.

<h3><A name="exprsyntax"></A>Syntax of Algebraic Expressions</h3>

The general syntax for an expression is a sequence of one or more expressions of the form
<pre>
   {<i>var</i> <i>assignment-op</i> <i>expr</i> [, ... ]}.
</pre>
Commas separate expressions in the sequence.
The final may (and typically does) consist of <i>expr</i> only,
omitting the <FONT size="+1"><tt><i>var <A href="#assignmentops">assignment-op</A></i></tt></FONT> part.

<P> <FONT size="+1"><tt><i>expr</i></tt></FONT>&nbsp; is a algebraic expression, 
with a syntax very similar to C.  
<FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> <i>expr</i> may not contain any blanks or tabs.
<br>It is composed of numbers, <A href="#variabledecl">scalar variables</A>,
elements of <A href="#vectordef">vector variables</A>, and <A href="#macrodef">macros</A>, combined with unary and binary operators.
<pre>
       <i>Unary</i> operators take first precedence:
       1.   - arithmetic negative
            ~ logical negative (.not.)
              functions abs(), exp(), log(), sin(), asin(), sinh(), cos(), acos()
                        cosh(), tan(), atan(), tanh(), flor(), ceil(), erfc(), sqrt()
              (flor() rounds to the next lowest integer; ceil() rounds up)

       The remaining operators are <i>binary</i>, listed here in order of precedence with associativity
       2.   ^  (exponentiation)
       3.   *  (times), / (divide), % (modulus)
       4.   +  (add), - (subtract)
       5.   <  (.lt.); > (.gt.); = (.eq.); <> (.ne.); <= (.le.);  >= (.ge.)
       6.   &  (.and.)
       7.   |  (.or.)
       8&9  ?: conditional operators, used as: <i>test</i>?<i>expr1</i>:<i>expr2</i>
       10&11 () parentheses 
</pre>

<P> The &nbsp;`<FONT size="+1"><tt>?:</tt></FONT>'&nbsp; pair of operators follow a C-like syntax.
<FONT size="+1"><tt><i>test</i></tt></FONT>, <FONT size="+1"><tt><i>expr1</i></tt></FONT>, and <FONT size="+1"><tt><i>expr2</i></tt></FONT>,
are all algebraic expressions.  
<br> If &nbsp;<FONT size="+1"><tt><i>test</i></tt></FONT>&nbsp; is nonzero,
&nbsp;<FONT size="+1"><tt><i>expr1</i></tt></FONT>&nbsp; is evaluated and becomes the result.  
Otherwise &nbsp;<FONT size="+1"><tt><i>expr2</i></tt></FONT>&nbsp; is evaluated and becomes the result.

<h4><A name="assignmentops"></A>Assignment Operators</h4>

The following are the allowed assignment operators:
<pre>
       assignment-op         function
         '='            simple assignment
         '*='           replace 'var' by var*expr
         '/='           replace 'var' by var/expr
         '+='           replace 'var' by var+expr
         '-='           replace 'var' by var-expr
         '^-'           replace 'var' by var^expr
</pre>

<h3><A name="exprsamples"></A>Examples of expressions</h3>

Suppose that the variables table looks like:
<pre>
   Var       Name                 Val
    1        t                   1.0000
    2        f                  0.00000
    3        pi                  3.1416
    4        a                   2.0000
 ...
   Vec       Name            Size   Val[1..n]
    1        firstnums          5    1.0000        5.0000
    2        nextnums           5    6.0000        10.000
 ...
     char symbol                     value
    1 c                               half
    2 a                               whole
    3 blank
</pre>

<P>
 You can print out the tables of current variables with the &nbsp;`<FONT size="+1"><tt><A href="#showdef">show</A></tt></FONT>'&nbsp; directive.
 As described in more detail <A href="#variabledecl">below</A>, such a variables table can be created with the following directives:
<pre>
 % const a=2
 % char c half a whole blank " "
 % vec firstnums[5] 1 2 3 4 5
 % vec nextnums[5] 6 7 8 9 10
</pre>

Then the line
<pre>
  {c} of the {a} {pi} is {pi/2}</pre>
is turned into the following;
<pre>
  half of the whole 3.14159265 is 1.57079633</pre>
whereas the line
<pre>
  one quarter is {1/(nextnums(4)-5)}</pre>
 becomes
<pre>
  one quarter is .25</pre>

The following illustrates substitution of character substrings:
<pre>
 % char c half a whole
  To {c(1,3)}ve a cave is to make a {a(2,5)}!
</pre>
 becomes
<pre>
  To halve a cave is to make a hole!
</pre>

The following line illustrates substitution of vector name
<pre>
  {firstnums}, I caught a hare alive, {nextnums} I let him go again ...
</pre>
becomes
<pre>
  1 2 3 4 5, I caught a hare alive, 6 7 8 9 10  I let him go again ...
</pre>

The following illustrates nesting of <FONT size="+1"><tt>{...}</tt></FONT>.
The innermost block s substituted first, as the following illustrates.
<pre>
    % const xx{1{2+{3+4}1}} = 2
</pre>
undergoes substitution in three passes
<pre>
    % const xx{1{2+71}} = 2
    % const xx{173} = 2
    % const xx173 = 2
</pre>

The example below combines nesting and <FONT size="+1"><tt>'{?~expr~strn1~strn2}'</tt></FONT> syntax:
<pre>
    MODE={?~k~B~C}3</pre>
 evaluates to, if <FONT size="+1"><tt><i>k</i></tt></FONT> is nonzero:
<pre>
    MODE=B3
</pre>
or, if <FONT size="+1"><tt><i>k</i></tt></FONT> is zero:
<pre>
    MODE=C3
</pre>

<P> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> the scalar variables table is always initialized with predefined variables
&nbsp;<FONT size="+1"><tt>t=1</tt></FONT>, &nbsp;<FONT size="+1"><tt>f=0</tt></FONT> and &nbsp;<FONT size="+1"><tt>pi=</tt></FONT>&pi;.  It is STRONGLY ADVISED that you never alter any of these variables.


<h2><A name="directives"></A>Preprocessor directives</h2>

Lines beginning with `<FONT size="+1"><tt>% keyword</tt></FONT>' are be interpreted as preprocessor
directives.  Such lines are not part of the the post-processed input.
Recognized keywords are
<pre>
   <A href="#variabledecl">const cconst cvar udef var vec char char0 cchar getenv vfind</A>   &larr; allocate variables and assigns values
   <A href="#branching">if ifdef ifndef iffile else elseif elseifd endif</A>               &larr; branching constructs for conditional reading of lines
   <A href="#loops">while repeat end</A>                                               &larr; looping constructs for repeated looping of lines
   <A href="#misc">echo exit include includo macro save show stop trace udef</A>      &larr; miscellaneous other constructs
</pre>

<h3><A name="variabledecl"></A>Variable declarations and assignments </h3>

&nbsp;&nbsp;Keywords&nbsp;:&nbsp;&nbsp; <FONT size="+1"><tt>const cconst cvar udef var vec char char0 cchar getenv vfind</tt></FONT>

<OL>
<A name="constdef"></A>
<LI> `<FONT size="+1"><tt>const</tt></FONT>'&nbsp; and &nbsp;`<FONT size="+1"><tt>var</tt></FONT>'&nbsp; load or alter the variables table.
<pre>
 <i>Example</i>
 % const  myvar=<i>expr</i>
</pre>
does two things:
<pre>
  (1) add **myvar** to the scalar variables symbols table if it is not there already.
      `const' and `var' are equivalent in this respect.

  (2) assign the result of <i>expr</i> to it, if <i>either</i>
      * you use the `var' directive  <i>or</i>
      * you use the `const' directive <i>and</i> the variable had not yet been created.
</pre>
In other words, if &nbsp;<FONT size="+1"><tt>myvar</tt></FONT>&nbsp;
already exists prior to the directive,
&nbsp;<FONT size="+1"><tt>const</tt></FONT>&nbsp; will not alter its value but
&nbsp;<FONT size="+1"><tt>var</tt></FONT>&nbsp; will.  Thus the lines
<pre>
   % const a=2
   % const a=3</pre>
incorporate <i>a</i> into the symbols table with value 2, while
<pre>
   % const a=2
   % var a=3
</pre>
does the same but assigns 3 to <i>a</i>.

<P> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
<FONT size="+1"><tt><i>expr</i></tt></FONT> may be multiplied into, divided into, added into,
 subtracted from or exponentiated into an already-declared variable
 using one of the following C-like syntax:
<pre>
   myvar*=expr  myvar/=expr  myvar+=expr  myvar-=expr  myvar^=expr
</pre>
These operators modify &nbsp;<FONT size="+1"><tt>myvar</tt></FONT>&nbsp; for both &nbsp;`<FONT size="+1"><tt>const</tt></FONT>'&nbsp; and &nbsp;`<FONT size="+1"><tt>var</tt></FONT>'&nbsp; directives.

<LI> `<FONT size="+1"><tt>cconst</tt></FONT>' and `<FONT size="+1"><tt>cvar</tt></FONT>' <i>conditionally</i> load or alter the variables table.
<pre>
 <i>Example</i>:
 % cconst <i>test-expr</i> myvar=<i>expr</i>
</pre>
<FONT size="+1"><tt><i>test-expr</i></tt></FONT>&nbsp; is an algebraic expression (e.g., <FONT size="+1"><tt>i==3</tt></FONT>)
that evaluates to zero or nonzero. <br>
If <FONT size="+1"><tt><i>test-expr</i></tt></FONT> evaluates to nonzero, the remainder
of the directive proceeds as &nbsp;<FONT size="+1"><tt>const</tt></FONT>&nbsp; or &nbsp;<FONT size="+1"><tt>var</tt></FONT>&nbsp; do.<br>
If <FONT size="+1"><tt><i>test-expr</i></tt></FONT> evaluates to zero, no further action is taken.

<br>&nbsp;&nbsp;&nbsp;<i>Example</i>:  the input segment
<pre>
   % const a = 2 b=3 c=4 d=5
   A={a} B={b} C={c} D={d}
   % const a=3
   % var d=-1
   % const b*=2 c+=3
   A={a} B={b} C={c} D={d}
   % cconst b==6  b+=3 c-=3
   A={a} B={b} C={c} D={d}
   % cconst b==6  b+=3 c-=3
   A={a} B={b} C={c} D={d}
</pre>
 generates four lines:
<pre>
   A=2 B=3 C=4 D=5
   A=2 B=6 C=7 D=-1
   A=2 B=9 C=4 D=-1
   A=2 B=9 C=4 D=-1
</pre>
<i>a</i> is unchanged from its initial assignment while <i>d</i> changes.

<P> Compare the two &nbsp;<FONT size="+1"><tt>cconst</tt></FONT>&nbsp; directives. <i>b</i> and <i>c</i> are altered in the first
instance, since the condition &nbsp;<FONT size="+1"><tt>b==6</tt></FONT>&nbsp; evaluates to 1, while they do not change in
the second instance, since now &nbsp;<FONT size="+1"><tt>b==6</tt></FONT>&nbsp; evaluates to zero.

<LI> `<FONT size="+1"><tt>char</tt></FONT>' loads or alters the character table.
<br>&nbsp;&nbsp;<i>Example</i>:
<pre>
 % char  c half     a whole      blank
</pre>
loads the character table as follows:
<pre>
     char symbol                     value
    1 c                               half
    2 a                               whole
    3 blank
</pre>
The last declaration can omit an associated string, in which case its value is a blank, as &nbsp;<FONT size="+1"><tt>blank</tt></FONT>&nbsp; is in this case.
<br> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
Re-declaration of any previously defined variable will change the contents of the variable.

<LI> `<FONT size="+1"><tt>char0</tt></FONT>' is the same as `<FONT size="+1"><tt>char</tt></FONT>', except re-assignment of an existing
variable is ignored.  Thus `<FONT size="+1"><tt>char0</tt></FONT>' is to `<FONT size="+1"><tt>const</tt></FONT>' as `<FONT size="+1"><tt>char</tt></FONT>' is to `<FONT size="+1"><tt>var</tt></FONT>'.

<LI> `<FONT size="+1"><tt>cchar</tt></FONT>' is similar to &nbsp;`<FONT size="+1"><tt>char</tt></FONT>'&nbsp; but tests are made
to enable different strings to be loaded depending on the results of the tests.
The syntax is
<pre>
 % cchar nam  <i>expr1 str1 expr2 str2</i> ...
</pre>
`<FONT size="+1"><tt>nam</tt></FONT>'&nbsp; is the name of the character variable;
 <FONT size="+1"><tt><i>expr1 expr2</i></tt></FONT> etc are algebraic expressions.

<br> `<FONT size="+1"><tt>nam</tt></FONT>'&nbsp; takes the
value &nbsp;<FONT size="+1"><tt><i>str1</i></tt></FONT>&nbsp; if &nbsp;<FONT size="+1"><tt><i>expr1</i></tt></FONT>&nbsp; evaluates to nonzero, the value &nbsp;<FONT size="+1"><tt><i>str2</i></tt></FONT>&nbsp; if &nbsp;<FONT size="+1"><tt><i>expr2</i></tt></FONT>&nbsp; evaluates to nonzero, etc.

<LI> `<FONT size="+1"><tt>getenv</tt></FONT>' has a function similar to `<FONT size="+1"><tt>char</tt></FONT>'.
 Only the contents of the variable are read from the unix environment variables table.  Thus
<pre>
% getenv myhome HOME
</pre>
 puts the string of your home directory into variable `<FONT size="+1"><tt>myhome</tt></FONT>.'

<A name="vectordef"></A>
<LI>`<FONT size="+1"><tt>vec</tt></FONT>' loads or alters elements in the table of vector variables.
<pre>
 % vec v[n]                      &larr; creates a vector variable of length n
 % vec v[n] n1 n2 n3 ...         &larr; does the same, also setting the first elements
</pre>
 Once `<FONT size="+1"><tt>v</tt></FONT>' has been declared, individual elements of &nbsp;<FONT size="+1"><tt>v</tt></FONT>&nbsp; may be set with
 the following syntax
<pre>
 % vec v(<i>i</i>) <i>n</i>                    &larr; assigns <i>n</i> to v(<i>i</i>)
 % vec v(<i>i1</i>:<i>in</i>)  <i>n1</i> <i>n2</i> ... <i>nn</i>    &larr; assigns range of elements <i>i1</i>..<i>in</i> to <i>n1 n2 ... nn</i>
</pre>
 There must be exactly <FONT size="+1"><tt><i>in&minus;i1</i>+1</tt></FONT> elements <FONT size="+1"><tt><i>n1 ... nn</i></tt></FONT>.
<br> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
 if `<FONT size="+1"><tt>v</tt></FONT>' is already declared, it is an error to re-declare it.

<LI> `<FONT size="+1"><tt>vfind</tt></FONT>' finds which element in a vector that matches a specified value.
The syntax is
<pre>
 % vfind v(i1:i2)  svar  <i>match-value</i>
</pre>
`<FONT size="+1"><tt>svar</tt></FONT>' is a scalar variable and
`<FONT size="+1"><tt><i>match-value</i></tt></FONT>' a number or expression.
Elements &nbsp;<FONT size="+1"><tt>v(i1:i2)</tt></FONT>&nbsp; are parsed.
&nbsp;<FONT size="+1"><tt>svar</tt></FONT>&nbsp; is
assigned to the the first instance i for which
&nbsp;<FONT size="+1"><tt><tt>v(i)</tt>=<i>match-value</i></tt></FONT>.
If no match is found, `<FONT size="+1"><tt>svar</tt></FONT>' is set to zero.
<br>&nbsp;&nbsp;<i>Example</i>:
<pre>
 % vec  a[3] 101 2002 30003
 % vfind a(1:3) k 2002           &larr; sets k=2
 % vfind a(1:3) k 10             &larr; sets k=0
</pre>
</OL>


<h3><A name="branching"></A>Branching constructs</h3>
&nbsp;&nbsp;Keywords&nbsp;:&nbsp;&nbsp; <FONT size="+1"><tt>if ifdef ifndef iffile else elseif elseifd endif</tt></FONT>

<P> These branching constructs have a function similar to the C constructs
<br> &nbsp;&nbsp; <FONT size="+1"><tt>if {text ;} else if {text ;} else {text ;}</tt></FONT>
<br> or Fortran constructs
<br> &nbsp;&nbsp; <FONT size="+1"><tt>if (<i>expr</i>) then;  ... elseif (<i>expr</i>) then; ... else; ... endif</tt></FONT>

<OL>
<LI> `<FONT size="+1"><tt>if <i>expr</i></tt></FONT>',&nbsp;
`<FONT size="+1"><tt>elseif <i>expr</i></tt></FONT>',&nbsp;
`<FONT size="+1"><tt>else</tt></FONT>'&nbsp; and &nbsp;
`<FONT size="+1"><tt>endif</tt></FONT>'&nbsp; are conditional read blocks.  Lines between these directives are read or not,
depending on the value of &nbsp;<FONT size="+1"><tt><i>expr</i></tt></FONT>.

<br>&nbsp;&nbsp;<i>Example</i>:
<pre>
 % if Quartz
  is clear
 % elseif Ag
  is bright
 % else
  neither is right
 % endif
</pre>
generate the line
<br> &nbsp;<FONT size="+1"><tt>is clear</tt></FONT>
<br> if <FONT size="+1"><tt>Quartz</tt></FONT> evaluates to nonzero; otherwise
<br> &nbsp;<FONT size="+1"><tt>is bright</tt></FONT>
<br> if <FONT size="+1"><tt>Ag</tt></FONT> evaluates to zero; otherwise
<br> &nbsp;<FONT size="+1"><tt>neither is right</tt></FONT>

<LI>

`<FONT size="+1"><tt>ifdef</tt></FONT>' is similar to `<FONT size="+1"><tt>if</tt></FONT>', but has a more general idea of what
constitutes an expression.

<UL>

<LI> `<FONT size="+1"><tt>if <i>expr</i></tt></FONT>'&nbsp; requires that <FONT size="+1"><tt><i>expr</i></tt></FONT> be a valid
expression, while &nbsp;`<FONT size="+1"><tt>ifdef <i>expr</i></tt></FONT>' evaluates <FONT size="+1"><tt><i>expr</i></tt></FONT>
as false if it invalid (e.g. it contains an undefined variable).

<LI>
<FONT size="+1"><tt><i>expr</i></tt></FONT>&nbsp; can be an algebraic expression, or
a sequence of expressions separated by
&nbsp;`<FONT size="+1"><tt>&</tt></FONT>'&nbsp; or &nbsp;&nbsp;`<FONT size="+1"><tt>|</tt></FONT>'&nbsp;
(<i>AND</i> or <i>OR</i> binary operators), <i>viz</i>:
<pre>
  % ifdef <i>expr1</i> | <i>expr2</i> | <i>expr3</i> ...
</pre>
If any of &nbsp;<FONT size="+1"><tt><i>expr1</i></tt></FONT>&nbsp;, &nbsp;<FONT size="+1"><tt><i>expr2</i></tt></FONT>&nbsp;, ... evaluate to nonzero, the result
is nonzero, whether or not preceding expressions are valid.
<br> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> the syntactical significance of the spaces.
&nbsp;<FONT size="+1"><tt><i>expr1</i>|<i>expr2</i></tt></FONT>&nbsp; cannot be evaluated unless both &nbsp;<FONT size="+1"><tt><i>expr1</i></tt></FONT>&nbsp; and &nbsp;<FONT size="+1"><tt><i>expr2</i></tt></FONT>&nbsp; are valid expressions, while &nbsp;<FONT size="+1"><tt><i>expr1</i> | <i>expr2</i></tt></FONT>&nbsp; may be nonzero if either is valid.
<LI> `<FONT size="+1"><tt>ifdef</tt></FONT>'&nbsp; allows a limited use of character variables in expressions. Either of the following are permissible expressions:
<pre>
   char-variable            &larr; T if char-variable exists, otherwise F
   char-variable=='<i>string</i>'  &larr; T ifchar-variable has the value <i>string</i>
</pre>
<i>Example</i>:
<pre>
% ifdef  x1==2 & atom=='Mg' | x1===1
</pre>
is nonzero if scalar &nbsp;<FONT size="+1"><tt>x1</tt></FONT>&nbsp; is 2 <i>and</i> if character variable &nbsp;`<FONT size="+1"><tt>atom</tt></FONT>'&nbsp; is equal to "Mg",
<i>or</i> if scalar &nbsp;<FONT size="+1"><tt>x1</tt></FONT>&nbsp; is 1.

<br> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> binary operators
&nbsp;`<FONT size="+1"><tt>&</tt></FONT>'&nbsp; and &nbsp;&nbsp;`<FONT size="+1"><tt>|</tt></FONT>'&nbsp; 
are evaluated left to right: &nbsp;`<FONT size="+1"><tt>&</tt></FONT>'&nbsp; does not take precedence
over &nbsp;`<FONT size="+1"><tt>|</tt></FONT>'.

</UL>

<LI> `<FONT size="+1"><tt>elseifd</tt></FONT>'&nbsp; is to &nbsp;`<FONT size="+1"><tt>elseif</tt></FONT>'&nbsp; as &nbsp;`<FONT size="+1"><tt>ifdef</tt></FONT>'&nbsp; is to &nbsp;`<FONT size="+1"><tt>if</tt></FONT>'.

<LI> `<FONT size="+1"><tt>ifndef <i>expr</i></tt></FONT>' ... is the mirror image of &nbsp;`<FONT size="+1"><tt>ifdef <i>expr</i></tt></FONT>'.
Lines following this construct are read only if &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; evaluates to 0.

<LI> `<FONT size="+1"><tt>iffile filename</tt></FONT>'&nbsp; is a construct analogous to &nbsp;`<FONT size="+1"><tt>%if</tt></FONT>'&nbsp; or &nbsp;`<FONT size="+1"><tt>%ifdef</tt></FONT>'&nbsp; for conditional reading of input lines.  
<br> The test condition is set not by an expression, but whether file &nbsp;`<FONT size="+1"><tt>filename</tt></FONT>'&nbsp; exists or not.

</OL>

<FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
`<FONT size="+1"><tt>if</tt></FONT>'&nbsp;, &nbsp;`<FONT size="+1"><tt>ifdef</tt></FONT>'&nbsp;,
and &nbsp;`<FONT size="+1"><tt>ifndef</tt></FONT>'&nbsp;  constructs may be nested to a depth of <FONT size="+1"><tt>mxlev</tt></FONT>.
The codes are distributed with <FONT size="+1"><tt>mxlev=6</tt></FONT> (see subroutine <b>rdfile</b>).


<h3><A name="loops"></A>Looping constructs</h3>
&nbsp;&nbsp;Keywords&nbsp;:&nbsp;&nbsp; <FONT size="+1"><tt>while repeat end</tt></FONT>

<OL>
<LI>`<FONT size="+1"><tt>while</tt></FONT>'&nbsp; and &nbsp;`<FONT size="+1"><tt>end</tt></FONT>'&nbsp; mark the beginning and end of a looping construct.
Lines inside the loop are repeatedly read until a test expression evaluates to 0.

<br> The &nbsp;`<FONT size="+1"><tt>while ... end</tt></FONT>'&nbsp; construct has the syntax
<pre>
  % while [<i>expr1</i> <i>expr2</i> ...] <i>exprn</i>                             &larr; skip to `% end' if <i>exprn</i> is 0
    ...                                                       &larr; these lines become part of the input while <i>exprn</i> is nonzero
  % end                                                       &larr; return to the `% while' directive unless <i>exprn</i> is 0
</pre>
The (optional) expressions `<FONT size="+1"><tt>[<i>expr1</i> <i>expr2</i> ...]</tt></FONT>'
follow the rules of the &nbsp;`<FONT size="+1"><tt><A href="#constdef">const</A></tt></FONT>'&nbsp; directive.  That is,
<UL>
<LI> Each of <FONT size="+1"><tt><i>expr1</i></tt></FONT>, <FONT size="+1"><tt><i>expr2</i></tt></FONT>, ... take the form
&nbsp;`<FONT size="+1"><tt>nam = <i>expr</i></tt></FONT>'&nbsp; or &nbsp;`<FONT size="+1"><tt>nam op= <i>expr</i></tt></FONT>'.
<LI> A simple assignment &nbsp;`<FONT size="+1"><tt>nam=<i>expr</i></tt></FONT>'&nbsp;
has effect only when &nbsp;`<FONT size="+1"><tt>nam</tt></FONT>'&nbsp;
has not yet been loaded into the variables table.  Thus it has effect on the first pass through the &nbsp;<FONT size="+1"><tt>while</tt></FONT>&nbsp; loop
(provided &nbsp;`<FONT size="+1"><tt>nam</tt></FONT>'&nbsp; isn't declared yet) but not subsequent passes.
</UL>
These rules make it very convenient to construct loops, as the following shows.
<br><i>Example</i>
<pre>
 % udef -f db                       &larr; removes db from symbols table, if it already exists
 % while db=-1 db+=2 db<=3          &larr; db is initialized to -1 only once
 this is db={db}                    &larr; the body of the loop that becomes the input
 % end                              &larr; return file pointer to %while until test db<=3 is 0
</pre>
generates
<pre>
  this is db=1
  this is db=3
</pre>
On the <i>first</i> pass, &nbsp;`db'&nbsp; is created and assigned the value &minus;1; then
&nbsp;`<FONT size="+1"><tt>db+=2</tt></FONT>'&nbsp; increments &nbsp;<FONT size="+1"><tt>db</tt></FONT>&nbsp; to 1.
Condition &nbsp;<FONT size="+1"><tt>db<=3</tt></FONT>&nbsp; evaluates to 1 and the loop proceeds.
<br> On the <i>second</i> pass, &nbsp;`db'&nbsp; already exists so &nbsp;`db=-1'&nbsp; has no effect.
&nbsp;`<FONT size="+1"><tt>db+=2</tt></FONT>' increments &nbsp;<FONT size="+1"><tt>db</tt></FONT>&nbsp; to 3.
<br> On the <i>third</i> pass, &nbsp;`<FONT size="+1"><tt>db</tt></FONT>'&nbsp; increments to 5 causing the condition
&nbsp;<FONT size="+1"><tt>db<=3</tt></FONT>&nbsp; to become 0.  The loop terminates.

<LI>
`<FONT size="+1"><tt>% repeat</tt></FONT>'&nbsp; ... &nbsp;`<FONT size="+1"><tt>% end</tt></FONT>'&nbsp; is another looping construct with the syntax
<pre>
   % repeat varnam <i>list</i>
    ...                             &larr; lines parsed for each element in list
   % end
</pre>
As with the &nbsp;`<FONT size="+1"><tt>while</tt></FONT>'&nbsp;
construct, multiple passes are made through the input lines.
&nbsp;<FONT size="+1"><tt><i>list</i></tt></FONT>&nbsp; generates a sequence of integers
(see <A href="Integer-list-syntax.html">&nbsp;<FONT size="+1"><tt>this page</tt></FONT></A> for the syntax),
For each member of the sequence &nbsp;`<FONT size="+1"><tt>varnam</tt></FONT>'&nbsp; takes its value
and the body of the loop passed through.
&nbsp;<FONT size="+1"><tt><i>list</i></tt></FONT>&nbsp; can be just an integer (e.g. &nbsp;`<FONT size="+1"><tt>7</tt></FONT>') or define a
more complex sequence,
e.g. &nbsp;`<FONT size="+1"><tt>1:3,6,2</tt></FONT>'&nbsp;
<A href="Integer-list-syntax.html">generates the sequence</A> &nbsp;`<FONT size="+1"><tt>1 2 3 6 2</tt></FONT>'.

<br><i>Example</i> of nested &nbsp;`<FONT size="+1"><tt>while</tt></FONT>'&nbsp; and &nbsp;`<FONT size="+1"><tt>repeat</tt></FONT>' loops (the &nbsp;`<FONT size="+1"><tt>while</tt></FONT>'&nbsp; loop was used above):
<pre>
 % const nm=-3 nn=4
 % while db=-1 db+=2 db<=3
 % repeat k= 2,7
 this is k={k} and db={db}
 {db+k+nn+nm} is db + k + nn+nm, where nn+nm={nn+nm}
 % end (loop over k)
 % end (loop over db)
</pre>
The nested loops are expanded into:
<pre>
 this is k=2 and db=1
 4 is db + k + nn+nm, where nn+nm=1
 this is k=7 and db=1
 9 is db + k + nn+nm, where nn+nm=1
 this is k=2 and db=3
 6 is db + k + nn+nm, where nn+nm=1
 this is k=7 and db=3
 11 is db + k + nn+nm, where nn+nm=1
</pre>

</OL>

<h3><A name="misc"></A>Other directives</h3>

&nbsp;&nbsp;Keywords&nbsp;:&nbsp;&nbsp;
<FONT size="+1"><tt>echo exit include includo macro save show stop trace udef</tt></FONT>

<OL>

<LI> `<FONT size="+1"><tt>echo <i>contents</i></tt></FONT>'&nbsp; echoes &nbsp;`<FONT size="+1"><tt><i>contents</i></tt></FONT>'&nbsp; to standard output.
<br><i>Example</i> :
<pre>
  % echo hello world
</pre>
prints
<pre>
  #rf    <i>##</i>: hello world
</pre>
where &nbsp;<FONT size="+1"><tt><i>##</i></tt></FONT>&nbsp; is the current line number.

<LI> `<FONT size="+1"><tt>exit [<i>expr</i>]</tt></FONT>'&nbsp; causes the program to stop parsing the input file, as though it encountered an <FONT size="+1"><tt>end-of-file</tt></FONT>.
<br> If &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; evaluates to nonzero, or if it is omitted, parsing ends.
<br> If &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; evaluates to 0 the directive has no effect.
<br><FONT color="#0000bb"><I>*Compare to</I>&nbsp;</FONT> the &nbsp;`<FONT size="+1"><tt>stop</tt></FONT>'&nbsp; directive.

<LI> `<FONT size="+1"><tt>include filename</tt></FONT>'&nbsp; causes
_rdfiln_{: style="color: green"} to include the contents file
&nbsp;`<FONT size="+1"><tt>filename</tt></FONT>'&nbsp; into the input.

If &nbsp;`<FONT size="+1"><tt>filename</tt></FONT>' exists,
_rdfiln_{: style="color: green"} opens it and the file pointer is transferred to this file until no further lines are to be read.
At that point file pointer returns to the original file.
If &nbsp;`<FONT size="+1"><tt>filename</tt></FONT>' does not exist, the directive has no effect.

<br><FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
`<FONT size="+1"><tt>%include</tt></FONT>'&nbsp; may be nested to a depth of 10.

<br><FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
looping and branching constructs <i>must</i> reside in the
same file.

<LI> `<FONT size="+1"><tt>includo filename</tt></FONT>'&nbsp; is identical to &nbsp;`<FONT size="+1"><tt>include</tt></FONT>', except that
<i>rdfiln</i> aborts if &nbsp;`<FONT size="+1"><tt>filename</tt></FONT>'&nbsp; does not exist.

<A name="macrodef"></A>
<LI> `<FONT size="+1"><tt>macro(arg1,arg2,..) <i>expr</i></tt></FONT>'&nbsp; defines a macro which acts in a manner similar to a function.
<FONT size="+1"><tt>arg1,arg2,...</tt></FONT> are substituted into `<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; before it is evaluated.
<br><i>Example</i> :
<pre>
  % macro xp(x1,x2,x3,x4) x1+2*x2+3*x3+4*x4
  The result of xp(1,2,3,4) is {xp(1,2,3,4)}
</pre>
generates
<pre>
  The result of xp(1,2,3,4) is 30
</pre>
<P> <FONT color="#0000bb"><I>*Caution</I>&nbsp;</FONT> macros are not quite identical to function declarations.  The following lines illustrate this:
<pre>
  % macro xp(x1,x2,x3,x4) x1+2*x2+3*x3+4*x4
  The result of xp(1,2,3,4) is {xp(1,2,3,4)}
  The result of xp(1,2,3,3+1) is {xp(1,2,3,3+1)}
  The result of xp(1,2,3,(3+1)) is {xp(1,2,3,(3+1))}
</pre>
generates
<pre>
  The result of xp(1,2,3,4) is 30
  The result of xp(1,2,3,3+1) is 27
  The result of xp(1,2,3,(3+1)) is 30
</pre>
`<FONT size="+1"><tt>macro</tt></FONT>'&nbsp; merely substitutes 1,2,3,.. for &nbsp;<FONT size="+1"><tt>x1,x2,x3,x4</tt></FONT>&nbsp; in &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; as follows:
<pre>
  1+2*2+3*3+4*4              &larr xp(1,2,3,4)
  1+2*2+3*3+4*3+1            &larr xp(1,2,3,3+1)
  1+2*2+3*3+4*(3+1)          &larr xp(1,2,3,(3+1))
</pre>
Because operator order matters, &nbsp;`<FONT size="+1"><tt>4</tt></FONT>'&nbsp; and &nbsp;`<FONT size="+1"><tt>3+1</tt></FONT>'&nbsp; behave differently.
By using &nbsp;`<FONT size="+1"><tt>(3+1)</tt></FONT>'&nbsp; in the fourth argument, operator precedence is maintained.

<LI> `<FONT size="+1"><tt>save</tt></FONT>'&nbsp; preserves variables after the preprocessor exits.
The syntax is:
<pre>
 % save                       &larr; preserves all variables defined to this point
 % save <i>name</i> [<i>name2</i> ...]      &larr; saves only variables named
</pre>
Only variables in the scalar symbols table are saved.

<A name="showdef"></A>
<LI> `<FONT size="+1"><tt>show ...</tt></FONT>'&nbsp; prints various things to standard output:
<pre>
 % show vars        prints out the state of the variables table
 % show lines       echos each line generated to the screen until:
 % show stop        is encountered
</pre>
<FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT>
because the vector variables can have arbitrary length, &nbsp;`<FONT size="+1"><tt>show</tt></FONT>'&nbsp; prints only the size of the vector and the first and last entries.  

<LI> `<FONT size="+1"><tt>stop [<i>expr</i> msg</tt></FONT>]' : causes the program to stop execution.
<br> If &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; evaluates to nonzero, or if it is omitted, program stops (&nbsp;`<FONT size="+1"><tt>msg</tt></FONT>', if present, is printed to standard out before aborting).
<br> If &nbsp;`<FONT size="+1"><tt><i>expr</i></tt></FONT>'&nbsp; evaluates to 0 the directive has no effect.
<br><FONT color="#0000bb"><I>*Compare to</I>&nbsp;</FONT> the &nbsp;`<FONT size="+1"><tt>exit</tt></FONT>'&nbsp; directive.

<LI> `<FONT size="+1"><tt>trace</tt></FONT>'&nbsp;
turns on debugging printout.  _rdfiln_{: style="color: green"} prints to standard output information about what it is doing
<pre>
'trace 0' turns the tracing off
'trace 1' turns the tracing on at the lowest level.
          rdfiln traces directives having to do with execution flow
          (if-else-endif, repeat/while-end).
'trace 2' prints some information about most directives.
'trace 4' is the most verbose
'trace  ' (no argument) toggles whether it is on or off.
</pre>

<LI> `<FONT size="+1"><tt>udef [&minus;f]</tt></FONT> <i>name</i> [<i>name2</i> ...]'&nbsp; remove one or more variables from the symbols table.
If the &nbsp;`<FONT size="+1"><tt>&minus;f</tt></FONT>'&nbsp;
is omitted, _rdfiln_{: style="color: green"} aborts with error if you remove a nonexistent variable.
If &nbsp;`<FONT size="+1"><tt>&minus;f</tt></FONT>'&nbsp; is included, removing
nonexistent variable does not generate an error.
Only scalar and character variables may be deleted.

</OL>

<h2><A name="footnotes"></A>Notes</h2>

<FN ID=sourcecodes><P>

Source codes the preprocessor uses are found in
the &nbsp;<FONT size="+1"><tt>slatsm</tt></FONT>&nbsp; directory:

<pre>
   rdfiln.f  The source code for the preprocessor.
             Subroutine <b>rdfile</b> parses an entire file and returns
             a preprocessed one, can be found in rdfiln.f
             The key subroutine is _rdfiln_{: style="color: green"}, which parses one line of a file.
   symvar.f  maintains the table of variables for floating point scalars.
   symvec.f  maintains the table of vector variables.
   a2bin.f   evaluates ASCII representations of algebraic expressions using a
             C-like syntax, converting the result into a binary number.
             Expressions may include variables and vector elements.
   bin2a.f   converts a binary number into a character string
             (inverse function to a2bin.f).
   mkilst.f  generates a list of integers for looping constructs,
             as described below. <A href="Integer-list-syntax.html">This page</A> describes the syntax of integer lists.
</pre>
The reader also maintains a table of character variables.  It is kept in the character array
<b>ctbl</b>, and is passed as an argument to _rdfiln_{: style="color: green"}.

<P> <FONT color="#0000bb"><I>*Note</I>&nbsp;</FONT> The ASCII representation of an expression
is represented to 8 to 9 decimal places; thus ASCII representation of a floating point number has
less precision than the binary form.  Thus <FONT size="+1"><tt>'{1.2345678987654e-8}'</tt></FONT>
is turned into <FONT size="+1"><tt>1.2345679e-8</tt></FONT>.


<BR><BR><BR><BR><BR><BR><BR><BR>
<BR><BR><BR><BR><BR><BR><BR><BR>
<BR><BR><BR><BR><BR><BR><BR><BR>
</HTML>
