---
layout: page-fullwidth
title: "Command Line switches"
permalink: "/docs/misc/data_format/"
header: no
---

### _Purpose_
{:.no_toc}

To explain the structure of data files in the Questaal suite.

#### Standard data formats for 2D arrays

Many Questaal programs, for example as [**fplot**{: style="color: blue"}](/docs/misc/fplot/) utility, and electronic structure programs such
as **lm**{: style="color: blue"}, read at some files containing 2D arrays.  Most of the time they follow a standard format.

Most files of this type are read through the file [file preprocessor](/docs/input/preprocessor), which can [modify the input](/docs/input/preprocessor/#main-features)
before it is parsed for data.


The array reader must be given information about the number of rows and columns in the file.  (They are called **nr** and **nc** in this
documentation.)

The safest way to specify **nr** and **nc** is to indicate the number of rows and columns in the first line of the file, as illustrated in
the code snippet below used in an [**fplot**{: style="color: blue"}
exercise](/docs/misc/fplot/#example-23-nbsp-charge-density-contours-in-cr).

~~~~
% rows 101 cols 101
      0.0570627197      0.0576345670      0.0595726102      0.0628546738
...
~~~

The first line


**nr** and/or **nc** (the number of rows and columns) can be stipulated in the file as shown in the first line of _chgd.cr_{:
style="color: green"}, but the information can be supplied in other ways.

+ The parser checks to see whether the first nonblank, non-preprocessor directive, begins with `% ... rows nr` or `% ... cols nc`.\\
  It uses whatever information is supplied to set the number of rows to **nr** and/or columns to **nc**.
+ Command-line switches &nbsp; `-r:nr=#` or `-r:nc=#` can specify **nr** and/or **nc**.
+ If **nc** has not been stipulated, the parser will count the number of elements in the first line containing data elements, and assign **nc** to it.\\
  For the particular file _chgd.cr_{: style="color: green"}, **fplot**{: style="color: blue"} would incorrectly infer **nc**=4: so **nc** must be stipulated in this case.
+ If **nr** has not been stipulated in some manner, **fplot**{: style="color: blue"} works it out a sensible guess from the file contents.\\
  If it knows **nc**, the reader can count the total number of values (or expressions more generally) in the file and deduce **nr** from it.

