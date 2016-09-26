---
layout: page-fullwidth
title: "Jigsaw Puzzle Orbitals"
permalink: "/docs/code/jpos/"
header: no
---

### _Purpose_
{:.no_toc}

To describe a some of the properties of Smooth Hankel functions and
Jigsaw Puzzle Orbitals.

### *Smoothed Hankel functions*
_____________________________________________

The FP basis functions are built around smooth Hankel functions.
These are convolutions of ordinary Hankel functions and Gaussian functions and are regular at the origin. 

Methfessel's class of functions $$H_{pL}$$, are a superset of 
generalized (smoothed) Hankel functions, and the family of 
(polynomial)$$\times$$(gaussians).  They are defined in [reference 1](/docs/code/jpos/#other-resources)
(which we refer to as I), and many of
their properties derived there.  The $$H_{pL}({\bf{}r})$$ are a
family of functions with $$p=0,1,2,...$$ and angular momentum
$$L$$. ($$L$$ is a shorthand for $$\ell{}m$$ quantum numbers.)
The $$H_{pL}({\bf{}r})$$ are members of the general class of functions
$$F_L({\bf{}r})$$ which are determined from a single radial
function by 
\begin{eqnarray}
F_L({\bf{}r}) = \Upsilon_L(-\nabla) f(r)
\end{eqnarray}
$$\Upsilon_L({\bf{}r}),\ {\bf{}r}=(x,y,z)$$ is a polynomial in $$(x,y,z)$$, 
so is meaningful to talk about $$\Upsilon_L(-\nabla)$$.
It is written in terms of
conventional spherical harmonics as

\begin{eqnarray}
\Upsilon_L({\mathbf{r}}) = r^\ell Y_L (\hat{\mathbf{r}})
\label{eq:defshpoly}
\end{eqnarray}
Just as the product of two spherical harmonics can be expanded in
Clebsh Gordan coefficients $$C_{KLM}$$ and spherical harmonics,
so can the product of two spherical harmonic polynomials:
\begin{eqnarray}
Y_K(\hat{\mathbf{r}})Y_L(\hat{\mathbf{r}}) = \sum_M C_{KLM} Y_M({\hat{\mathbf{r}}})
\end{eqnarray}
\begin{eqnarray}
\Upsilon_K({\mathbf{r}})\Upsilon_L({\mathbf{r}}) = \sum_M C_{KLM}\, r^{k+\ell-m} \, \Upsilon_M({{\mathbf{r}}})
\end{eqnarray}



$$C_{KLM}$$ is nonzero only when $${k+\ell-m}$$ is an even integer, so
the r.h.s. is also a polynomial in $$(x,y,z)$$, as it must be.




![Ordinary and Smooth Hankel functions](https://lordcephei.github.io/assets/img/smhankels.svg)


### _Other Resources_
{::comment}
/docs/code/jpos/#other-resources/
{:/comment}

1. The mathematics of smoothed Hankel functions that form the **lmf**{: style="color: blue"} basis set
are described in this paper:  
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
_Nonsingular Hankel functions as a new basis for electronic structure calculations_,
[J. Math. Phys. 39, 3393 (1998)](http://dx.doi.org/10.1063/1.532437)

