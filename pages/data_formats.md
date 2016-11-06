---
layout: page-fullwidth
title: "Questaal Data Formats"
permalink: "/docs/input/data_format/"
header: no
---

#### _Purpose_
{:.no_toc}

To explain the structure of data files in the Questaal suite.

#### _Table of Contents_
_____________________________________________________________
{:.no_toc}
*  Auto generated table of contents
{:toc}  
{::comment}
(/docs/input/preprocessor/#table-of-contents)
{:/comment}

#### Introduction

Questaal codes require a wide variety of data formats to meet the diverse range of purposes they serve.  When files are not too large they
are usually written in ASCII format.  In many cases, such files are passed through the [file preprocessor](/docs/input/preprocessor) before
being scanned for data.  The preprocessor's facilities (e.g. to evaluate expressions and to make looping constructs) can be useful in many
contexts.

The preprocessor can [modify the input](/docs/input/preprocessor/#main-features) before it is parsed for data.  Note also:

* Lines which begin with '**#**' are comment lines and are ignored. (More generally, text following a `**#**' in any line is ignored).
* Lines beginning with '**%**' are directives to the [preprocessor](/docs/input/preprocessor/).

#### Standard data formats for 2D arrays
{::comment}
(/docs/input/data_format/#standard-data-formats-for-2d-arrays)
{:/comment}

Many Questaal programs, for example the [**fplot**{: style="color: blue"}](/docs/misc/fplot/) utility and electronic structure programs such
as **lm**{: style="color: blue"}, read files containing 2D arrays.  Most of the time they follow a standard format described in this section.

Where possible, the 2D array reader uses **rdm.f**{: style="color: green"}, so that the files are read in a uniform style.  Unless told
otherwise, the reader treats data as algebraic expressions.  Thus you can use expressions in these files, in addition to expressions
in [curly brackets](/docs/input/preprocessor/#curly-brackets-contain-expressions) **{&hellip;}** managed by the preprocessor.

The array reader must be given information about the number of rows and columns in the file.  (They are called **nr** and **nc** here.)

The safest way to specify **nr** and **nc** is to indicate the number of rows and columns in the first line of the file, as illustrated in
the code snippet below (this is the beginning of _chgd.cr_{: style="color: green"} used in an [**fplot**{: style="color: blue"}
exercise](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr)).
**nr** and/or **nc** (the number of rows and columns) can be stipulated in the file as shown in the first line of _chgd.cr_{: style="color: green"}:

~~~~
% rows 101 cols 101
      0.0570627197      0.0576345670      0.0595726102      0.0628546738
...
~~~

_Note:_{: style="color: red"} `% rows...` is not a preprocessor instruction because **rows** is not a
directive the [preprocessor recognizes](/docs/input/preprocessor/#preprocessor-directives).

The reader attempts to work out **nr** and **nc** in the following sequence:

+ The reader  checks to see whether the first nonblank, non-preprocessor directive, begins with `% ... rows nr` or `% ... cols nc`.\\
  If either or both are supplied to set **nr** and/or columns to **nc** are set accordingly.
  + In some cases **nr** or **nc** is known in advance, for example a file containing site positions has **nc=3**.
    In such case the reader is told of the dimension in advance; if redundant information is given the reader checks that the two are consistent.\\
    If they are not, usually the program aborts with an error message.
+ If **nc** has not been stipulated, the parser will count the number of elements in the first line containing data elements, and assign **nc** to it.\\
  For the particular file _chgd.cr_{: style="color: green"}, the reader would incorrectly infer **nc**=4: so **nc** must be stipulated in this case.
+ If **nr** has not been stipulated in some manner, the reader works out a sensible guess from the file contents.\\
  If it knows **nc**, the reader can count the total number of values (or expressions more generally) in the file and deduce **nr** from it.\\
  If the number of rows it deduces is not an integer, a warning is given.

##### _Complex arrays_

If the array contains complex numbers, the first line should contain **complex**, e.g.

~~~
% ... complex
~~~

The entire real part of the array must occur first, followed by the imginary part.

#### Site files
{::comment}
(/docs/input/data_format/#site-files)
{:/comment}

Site files can assume a variety of formats.
Their structure is documented [here](/docs/input/sitefile/).

