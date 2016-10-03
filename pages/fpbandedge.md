---
layout: page-fullwidth
title: "Extremal points and calculating effective mass"
permalink: "/tutorial/lmf/lmf_bandedge/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This tutorial demonstrates how to find extremal points in k-space and calcualte effective masses using the band-edge program. This is done for silicon starting from a self-consistent LDA density. Silicon is a trivial example as its extremal points are found on lines that pass through high-symmetry points. The band-edge program is particularly useful when looking for multiple extremal points that do not fall on high-symmetry lines. A more complicated example can be found in the additional exercises.  

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
    $ lmf --rs=1,0 -vnit=1 --band~fn=syml si               #calculate and plot bands
    $ rdcmd makeplot_scott; evince fplot.ps &

    $ band-edge -floatmn -maxit=20 -r=.1 -band=5 -q0=0.5,0,0 si  
    $ band-edge -edge2=1 -maxit=20 -r=.04 -band=5 -gtol=.0001 -q0=0.82,0,0 si 
    $ band-edge -mass -alat=10.26 -r=.0005,.001,.002,.003 -band=5 -q0=0.847,0,0 si

Take a look at the band structure plot. The valence band maximum is at the $$\Gamma$$ point while the conduction band minimum is most of the way along the line between &Gamma and X. We will now use the band-edge script to accurately locate the position of the conduction band minimum and to calculate the effective mass. This is done in three steps, you first do a rough search by 'floating' to a point near the minimum. From here, you do a more refined search by carrying out a minimisation until the gradient is negligibly small. Lastly, you calculate the effective mass around this point. 

#### 1. _Float to low-energy point_
The band-edge script has a 'float' option that is useful for doing a quick search to find a low-energy (or high-energy) region of k-space. You specify a starting point, then the script creates a cluster of points around it and checks what is the lowest-energy point. It then uses the lowest-energy point as the next central point, creates a new set of points around it and again moves to the lowest-energy one. This process is repeated until the central point is the lowest-energy point. 

Let's start at the point half-way between &Gamma and X (0.5, 0.0, 0.0) and float down in energy. Run the following command:

    $ band-edge -floatmn -maxit=20 -r=.1 -band=5 -q0=0.5,0,0 si

The 'floatmn' switch specifies that you are looking for a minimum-energy point (see additional exercises for a maximum-energy point example). The 'maxit' switch sets the number of iterations (number of times a set of points is created), 'r' is a range that defines how far out the points are generated, 'band' is for the band considered (here conduction band since 4 electrons and spin degenerate) and lastly q0 is the starting k-point. 

             start iteration 1 of 20
             lmf si --band~lst=5~box=.1,n=12+o,q0=0.5,0,0 > out.lmf
    qnow     :     0.500000     0.000000     0.000000       0.2628584
    gradient :    -0.231511     0.000000     0.000046       0.231511
    q*       :     0.925046     0.000000     0.001935
    use      :     0.589443     0.000000     0.044721

You should get an output similar to the above. Take a look at the line beginning with lmf, this is the command that band-edge uses to run lmf to get the energy of the cluster of points. The qnow line gives the current central k-point (0.5,0,0) and its energy in Rydbergs. The 'use' line prints the lowest-energy k-point from the cluster of points, this will then be used as the central point in the next iteration. The cluster of 13 k-points and their energies are printed to the bnds.si file, take a look and you will see that the point (0.589443, 0.0, 0.044721) is indeed the lowest-energy point.  

Note that the qnow energies are getting smaller as we float to a low-energy region. After 5 iterations, the following is printed: 'cluster center is extremal point ... exiting loop'. The central k-point is the lowest-energy point and the float routine is finished.

#### 2. _Gradient minimization_
Starting from our low-energy float point, the next step is to do a more refined search using a gradient minimization approach. Band-edge creates a new cluster of points, does a quadratic fit and then traces the gradients to a minimum point. Run the following command:

    $ band-edge -edge2=1 -maxit=20 -r=.04 -band=5 -gtol=.0001 -q0=0.82,0,0 si 

The 'edge2' part specifies what gradient minimization algorithm to use (run 'band-edge --h' for more information), the r is the excursion range (step size in minimization), the 'gtol' is the tolerance in the gradient and the q0 is the starting point that we obtained from the float step. 

The output is similar to before but now we will pay attention to the gradient line which prints the x, y and z gradient components and the last column gives the magnitude. Note how the gradient magnitude is decreasing with each step until it falls below the specified tolerance (gtol). At this point, the gradients minimization is converged and the following is printed 'gradient converged to tolerance gtol = .0001'.   

#### 3. _Calculate effective mass_
Now that we have accurately determined the conduction band minimum, we can calculate the effective mass. This is done by fitting a quadratic form to a set of points around the conduction band minimum. Run the following command:

    $ band-edge -mass -alat=10.26 --bin -r=.0005,.001,.002,.003 -band=5 -q0=0.8458,0,0 si

The mass refers to effective mass calculation and alat is the lattice constant (this can be found in the lmf output or in the site file). The lattice constant is needed since the k points are given in units of 2$$\pi$$/a. Here, the r gives the radii of the four clusters of points around the central point. The extra points improve the accuracy of the quadratic fitting. 





