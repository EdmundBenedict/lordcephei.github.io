---
layout: page-fullwidth
title: "Finding extremal points in k-space"
permalink: "/tutorial/lmf/lmf_bandedge/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This tutorial demonstrates how to find extremal points in k-space using the band-edge program. This is done for silicon starting from a self-consistent LDA density. Silicon is a trivial example as its extremal points are found on lines that pass through high-symmetry points. The band-edge program is particularly useful when looking for multiple extremal points that do not fall on high-symmetry lines. A more complicated example can be found in the additional exercises.  

_____________________________________________________________

### _Command summary_

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ cp lm/doc/demos/qsgw-si/init.si .                    #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20       #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent
    
    $ band-edge part

{::nomarkdown}</div>{:/}
_____________________________________________________________

### _Tutorial_

The starting point is a self-consistent LDA calculation, you may want to review the [lmf tutorial for Si](/tutorial/lmf/lmf_tutorial/). Run the following commands to obtain a self-consistent density:

    $ cp lm/doc/demos/qsgw-si/{init.si,syml.si} .          #copy init and syml files to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20       #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent
    $ lmf band calculation                                 #calculate and plot bands

Take a look at the band structure plot. The valence band maximum is at the gamma point while the conduction band minimum is most of the way along the $$\Gamma-X$$ line. 

Now run fine k-mesh to get 

The VB is at the gamma point, run fine k mesh for 
