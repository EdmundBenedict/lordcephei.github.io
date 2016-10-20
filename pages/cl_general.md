---
layout: page-fullwidth
title: "Command Line switches"
permalink: "/docs/commandline/general/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This page serves to document the command line switches generally applicable to most of the packages in the suite, and to give an idea of the usage cases of certain switches and switch types.

### _Documentation_
_____________________________________________________________
All of the programs have special branches that may be (and sometimes must be) set from command-line switches.

Here is an example:

    lmf cafeas -vns=4 -vnm=5 --rpos=pos 

Following unix style, switches always begin with “-”. There are many command-line switches that are specific to a particular main program, while a number of others are common to several or all programs.

Some switches have a single dash ; some have two. Those with two tend to control program flow (e.g. `--show`), while those with a single dash tend to have an “assignment” function, such as a variables declaration (e.g. `-vx=3`). Sometimes there is not a clear distinction between the two, e.g. the printout verbosity `--pr` accepts either one or two dashes (see below).

In the example above, `-vns=4 -vnm=5` assigns variables **ns** and **nm** to 4 and 5, respectively, while `--rpos=pos` tells **lmf**{: style="color: blue"} to read site positions from file 
_pos.cafeas_{: style="color: green"}.


##### _Switches Common to Most or All Programs_

    --help
    --h             Lists command-line switches for that program and quits.
    
    --input         Lists tags (categories and tokens) a program will read. 
                    Same as turning on HELP=T in category IO; see HELP= in the description of the IO category.
	
    --showp         Prints out input file after parsing by preprocessor, and exits.
                    This can be useful because it shows the action of the preprocessor.

    --show          Prints the input file parsed by preprocessor, and the value of the tags
                    parsed or default values taken.
			
    --show=2        Same as --show, except program exits after printing out results
                    from parsing the input file.


    --pr#1[,#2]     Sets output verbosities, overriding any specification in the ctrl file.
     -pr#1[,#2]     Optional #2 sets verbosity for the potential generation part.

    --time=#1[,#2]  Prints out a summary of timings in various sections of the code.
                    Timings are kept to a nesting level of #1.  
                    If #2 is nonzero, timings are printed 'on the fly'.
					
    --iactive       Turns on 'interactive' mode, overriding any specification through IO_IACTIV in the ctrl file.
					
    --iactive=no    Turns off 'interactive' mode.
    --no-iactive    
					
    -c"name=strn"   Declares a character variable and assigns it to value 'strn'.
					
    -v"name=expr"   Declares a numeric variable and assigns its value to the result of expression 'expr'. 
                    Be advised that only the first declaration of a variable is used.
                    Later declarations have no effect.  

                    In addition to the declaration 'name=...' there are assignment
                    operators '*=','/=','+=','-=','^=' that modif existing variables, following C syntax.

##### _Switches Common To Programs Using Site Information_
Additionally, for any program utilizing site information, the following switches apply

    --rpos=fnam     Tells the program to read site positions from file "fnam" after the input file has been read.
                    Data is read following a standard format for 2D arrays.
					
    --fixpos[:tol=#]
    --fixpos[:#]    Tells the symmetry finder to adjust positions to sites that are "slightly displaced".
                    That is, if they were displaced a small amount, the basis would conform to a group
                    operation. Optional tolerance specifies the maximum amount of adjustment allowed.
                    Example: lmchk --fixpos:tol=.001
				   
    --fixlat        Adjust lattice vectors and point group operations, attempting to render them internally
                    consistent with each other.

    --fixpos[:tol=#] Adjust positions slightly, rendering them as consistent as possible with the symmetry group.

    --sfill=class   List tells the program to adjust the sphere sizes to space filling.
					
                    By default, "class-list" is a list of integers. These enumerate class indices for
                    which spheres you wish to resize, eg 1,5,9 or 2:11.
                    For "class-list" syntax see Syntax of Integer Lists.
					
                    A second alternative specification of a class-list uses
                    the following:  "-sfill~style=2~expression"
                    The expression can involve the class index ic and atomic number z. Any class satisfying
                    expression is included in the list.
                    Example: "-sfill~style=2~ic<6&z==14"
					
                    A third alternative specification of a class-list is specifically for unix systems.
                    The syntax is "-sfill~style=3~fnam". Here "fnam" is a filename with the usual
                    unix wildcards. For each class, the program makes a system call "ls fnam | grep class"
                    and any class which grep finds is included in the list.
                    Example: "-sfill~style=3~a[1-6]"
                    
