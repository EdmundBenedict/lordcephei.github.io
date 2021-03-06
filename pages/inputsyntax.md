---
layout: page-fullwidth
title: "Syntax of the Input File"
permalink: "/docs/input/inputfilesyntax/"
header: no
---

### _Purpose_
{:.no_toc}

This manual describes the syntax of Questaal's input file.
See [this guide](/docs/input/inputfile/) for an introduction to the input system and a description of all the tags Questaal programs look for. 
See the [preprocessor manual](/docs/input/preprocessor/) for a description of the preprocessor, which acts before the input file is read.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

_____________________________________________________________

### _Introduction_

The input system for the Questaal program suite is unique in the following
respects:

1. Input files are nearly free-format and input does not need to be
   arranged in a particular order.  (There are one or two mild
   exceptions: e.g. the first column is reserved to demarcate
   [categories](/docs/input/inputfilesyntax/#input-structure-syntax-for-parsing-tokens))
   Data is located by identifying _tokens_ (labels) in the input file, and
   reading the information following the token.  In this string:

     
      NSPIN=2

   token **NSPIN** has the contents **2**.  Note that a token such as **NSPIN** only acts
   as a marker to locate data: they are not themselves part of the data.

2. The token is the [end part of the full identifier](/docs/input/inputfile/#input-file-structure), which has a tree structure.
   The full identifier we call a _tag_; it is sometimes expressed as a string of
   identifers separated by underscores. e.g. &nbsp;**ITER\_CONV**&nbsp; or &nbsp;**SPEC\_ATOM\_Z**.
   A tag is analogous to a path in a tree directory structure: **SPEC**,&nbsp; **SPEC\_ATOM**,&nbsp;
   and **SPEC\_ATOM\_Z**,&nbsp; are tags with successively more
   branches.  The first identifier of the tag is called a _category_;
   the last identifier is called a _token_.
   Tokens are markers for data, e.g. &nbsp;**NSPIN**&nbsp; is a marker for **2**.

   Tokens are grouped according to categories.  If an identifier appears in more than one category its meaning is
   distinct.  Thus contents of &nbsp;**MODE**&nbsp; in
   &nbsp;**DYN_SSTAT_MODE**&nbsp; is different from the contents of &nbsp;**MODE**&nbsp; in &nbsp;**OPTICS_MODE**.  The next section shows
   how the structure is implemented for input files, which enables these
   cases to be distinguished.

3. The input file is first passed through a [_preprocessor_](/docs/input/preprocessor), which modifies it before being parsed for
   tags.  The preprocessor provides some programming language capability: input files can contain directives such as

   <pre>
   % if <i>expression</i>
   </pre>

   that are not part of the input proper, but control what is read into
   the input stream, and what is left out.  Thus input files can serve
   multiple uses --- containing information for many kinds of
   calculations, or as a kind of data base.

4. The parser can evaluate algebraic expressions. Variables can be assigned
   and used in the expressions.  Expression syntax is similar to the C programming languages;  it is essentially the same
   as the syntax used for [algebraic expressions](/docs/input/preprocessor/#syntax-of-algebraic-expressions) in the preprocessor.

   _Note:_{: style="color: red"} the preprocessor parses
   expressions [inside curly brackets](/docs/input/preprocessor/#curly-brackets-contain-expressions) and returns the result as a string.  An
   ASCII representation of the expression (string) is substituted for the contents of the curly brackets; this string can itself can be part of an
   expression.  Thus

   NSPIN={2+1}-1

   becomes after preprocessing:


   NSPIN=3-1

   The contents of **NSPIN** is an algebraic expression &nbsp;**3-1**&nbsp;. It is parsed as an expression so that the value of **NSPIN** is 2.
   Documentation of the [**CONST**](/docs/input/inputfile/#const) category explains how preprocessor expressions and input file expressions
   can coexist, and how to declare variables though &nbsp;**CONST**.

   _Note:_{: style="color: red"} the preprocessor will handle sequences of assignments and expressions such as &nbsp;**{x=3,y=4,x\*=y,x\*2}**;
   the result is the ASCII representation of the final expression, &nbsp;**x\*2**.  This extra capability is only in the preprocessor; the transformed
   input must consist of a single expression without any variable assignments, as in the example above.

### _Input structure: syntax for parsing tokens_
{::comment}
/docs/input/inputfilesyntax/#input-structure-syntax-for-parsing-tokens
{:/comment}

A typical input fragment looks something like:


<pre>
ITER NIT=2  CONV=0.001
     MIX=A,b=3
DYN  NIT=3
... <b>(fragment 1)</b>
</pre>

Tags in this fragment are: &nbsp; **ITER,&nbsp; ITER\_NIT,&nbsp; ITER\_CONV,&nbsp; ITER\_MIX,&nbsp; DYN,&nbsp; DYN\_NIT**.
The first or top-level tags we designate as _categories_ (**ITER**&nbsp; and &nbsp;**DYN**&nbsp; in the fragment above). 
Generally tags such as ITER\_NIT,&nbsp; do not appear explicitly but are split into branches as **fragment 1** shows.
A token's contents consists of a string which may represent input data when it is the last link in
the path, e.g. &nbsp;**NIT**, or be a segment of a larger tag, in which case it points to branches farther out on the tree.
The tag's structure is analogous to a file directory structure, where names refer to
files, or to directories (aka folders) which contain files or other directories.

What designates the scope of a category?  Any string that begins in the
first column of a line is a category.  A category's contents begins right
after its name, and ends just before the start of the next category.
In the fragment shown, &nbsp;**ITER**&nbsp; contains this string:\\
`NIT=2 CONV=0.001 MIX=A,b=3`\\
while &nbsp;**DYN**&nbsp; contains\\
`NIT=3`\\
Thus categories are treated a little differently from other tokens.  The
input data structure usually does not rely on line or column information;
however use of the first column to mark categories and delimit their
scope is an exception.

Data associated with a token may consist of logical, integer or
real scalars, or vectors, or a string. The contents of **NIT**,
**CONV**, and **MIX** are respectively an integer, a real number, and
a string.  This fragment illustrate tokens **PLAT** and **NKABC** that
contain vectors:

    STRUC  PLAT= 1 1/2 -1/2    1/2 -1/2 0   1 1 2
    BZ     NKABC=3,3,4

Numbers (more properly, expressions) may be separated either by spaces or
commas.

How are the start and end points of a token delineated
in a general tree structure?  The style shown in the input **fragment 1** does
not have the ability to handle general tree-structured input, notably
tags with more than two branches such as **STR\_IINV\_NIT**.  You can
always unambiguously delimit the scope of a token with brackets **[...]**, e.g.

<pre>
ITER[ NIT[2]  CONV[0.001]  MIX=[A,b=3]]
DYN[NIT[3]]
STR[RMAX[3] IINV[NIT[5] NCUT[20] TOL[1E-4]]]
... <b>(fragment 2)</b>
</pre>


Note that **ITER\_NIT**, &nbsp;**DYN\_NIT**&nbsp; and &nbsp;**STR\_IINV\_NIT**&nbsp; are all readily distinguished (contents **2, 3**, and
**5**).

The Questaal parser reads input structured by the bracket delimiters, as in
**fragment 2**.  This format is logically unambiguous but aesthetically horrible.
If you are willing to tolerate small ambiguities, you can use format like
that of **fragment 1** most of the time.  The rules are:

1.    Categories must start in the first column.  Any character in the
      first column starts a new category and terminates a prior one.

2.    When brackets are not used, a token's contents are delimited by the
      end of the category.  Thus the content of &nbsp;**ITER\_CONV**&nbsp; from
      **fragment 1** is &nbsp;`0.001 MIX=A,b=3`, while in
      **fragment 2** it is &nbsp; `0.001`.

      In practice this difference matters only occasionally.  Usually contents refer to numerical data. The parser will read only as many
      numbers as it needs.  If &nbsp;**CONV**&nbsp; contains only one number, the difference is moot.  On the other hand suppose
      &nbsp;**CONV**&nbsp; may contain more than one number.  Then the two styles might generate a difference.  In this case the parser can
      only find one number to convert in **fragment 2**, and that is all it would generate.  For **fragment 1**, the parser would see a
      second string `MIX=...` and attempt to parse it; but it would not be able to convert it to a number. Thus, the net effect would be the
      same: only one number would be parsed.

      _Note:_{: style="color: red"} if fewer numbers are read than expected, An error is generated if the parser requires more numbers than
      it can read.  But it can happen that more numbers are sought than are available, in which case the number actually may be sufficient.
      For example, &nbsp;**BZ_NKABC**&nbsp; expects three numbers, but you can supply only one or two.  If _more_ numbers are supplied than
      are sought, only the number sought are parsed, regardless of how many are supplied.

3.    When a token's contents consist of a character string (as distinct from a string representation of a number) and brackets are _not_ used, there
      is an ambiguity in where the string ends.  In this case, the parser will delimit strings in one of two ways.  Usually a space delimits
      the end-of-string, as in &nbsp; &nbsp;**MIX=A,b=3**&nbsp;.  However, in a few cases the end-of-category delimits the end-of-string ---
      usually when the entire category contains just a string, as in

      ~~~
      SYMGRP R4Z M(1,1,0) R3D
      ~~~

      If you want to be sure, use brackets:  `SYMGRP[R4Z M(1,1,0) R3D]`.

4.    Tags containing three levels of nesting, e.g &nbsp;**STR\_IINV\_NIT**,
      _must_ be bracketed after the second level.  Any of the following
      are acceptable:

      ~~~
      STR[RMAX[3] IINV[NIT[5] NCUT[20] TOL[1E-4]]]
      STR[RMAX=3 IINV[NIT=5 NCUT=20 TOL=1E-4]]
      STR RMAX=3 IINV[NIT=5 NCUT=20 TOL=1E-4]
      ~~~

### _Multiple occurrences of categories and tokens_
{::comment}
/docs/input/inputfilesyntax/#multiple-occurrences-of-categories-and-tokens
{:/comment}

_Note:_{: style="color: red"} If multiple categories occur within an input file, only the first one is used.

Similarly, only the first occurrence of a token _within_ a category is read.  There is an important exception to this rule, namely when
multiple occurences of a token are required. The two main instances are data in **SITE** and **SPEC** categories,
for example:

~~~
SITE   ATOM[C1  POS= 0          0   0    RELAX=1]
       ATOM[A1  POS= 0          0   5/8  RELAX=0]
       ATOM[C1  POS= 1/sqrt(3)  0   1/2]
~~~

The contents of the first and second occurences of &nbsp;**ATOM** are: &nbsp; `C1 POS= 0 0 0 RELAX=1` and &nbsp; `A1 POS= 0 0 5/8 RELAX=0`.
The parser will try to read as many instances of &nbsp;**SITE\_ATOM** (including tokens within it) as it needs.

_Note:_{: style="color: red"} **ATOM** plays a dual
role here: it is simultaneously a marker (token) for 
**ATOM**'s label (e.g. **C1**), and a marker for tokens nested
one level deeper, (e.g. contents of &nbsp;**SITE\_ATOM\_POS**&nbsp; and
&nbsp;**SITE\_ATOM\_RELAX**).

The format shown is consistent with rule 4 above.
You can also use the following format for repeated inputs
in **SITE** and **SPEC** categories:

    SITE    ATOM=C1  POS= 0          0   0    RELAX=1
            ATOM=A1  POS= 0          0   5/8  RELAX=0
            ATOM=C1  POS= 1/sqrt(3)  0   1/2

In the latter format the contents of &nbsp;**SITE\_ATOM**&nbsp; are delimited
by either the _next_ occurence of this tag within the same category, or by the end-of-category,
whichever occurs first. 


