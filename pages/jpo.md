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

![Ordinary and Smooth Hankel functions](https://lordcephei.github.io/assets/img/smhankels.svg)

Methfessel's class of functions $$H_{pL}$$, are a superset of 
generalized (smoothed) Hankel functions, and the family of 
(polynomial)$$\times$$(gaussians).  They are defined in [reference 1](/docs/code/jpos/#other-resources)
(which we refer to as I), and many of
their properties derived there.  The $$H_{pL}({\mathbf{r}})$$ are a
family of functions with $$p=0,1,2,...$$ and angular momentum
$$L$$. ($$L$$ is a shorthand for $$\ell{}m$$ quantum numbers.)
The $$H_{pL}({\mathbf{r}})$$ are members of the general class of functions
$$F_L({\mathbf{r}})$$ which are determined from a single radial
function by 
\begin{eqnarray}
F_L({\mathbf{r}}) = \Upsilon_L(-\nabla) f(r)
\end{eqnarray}
$$\Upsilon_L({\mathbf{r}}),\ {\mathbf{r}}=(x,y,z)$$ is a polynomial in $$(x,y,z)$$, 
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
\Upsilon_K({\mathbf{r}})\Upsilon_L({\mathbf{r}}) = \sum_M C_{KLM} r^{k+\ell-m} \Upsilon_M({\mathbf{r}})
\end{eqnarray}
$$C_{KLM}$$ is nonzero only when $${k+\ell-m}$$ is an even integer, so
the r.h.s. is also a polynomial in $$(x,y,z)$$, as it must be.

Functions $$H_{L}({\mathbf{r}})$$ are defined through the radial function $$h(r)$$
(I,~Eq.~6.5):
\begin{eqnarray}
H_{L}(\varepsilon,r_s;{\mathbf{r}}) &=& \Upsilon_L(-\nabla) h(\varepsilon,r_s;r)
\end{eqnarray}
\begin{eqnarray}
h(\varepsilon,r_s;r) &=& \frac{1}{2r}\left(u_+(\varepsilon,r_s;r) - u_{-}(\varepsilon,r_s;r)\right)
\end{eqnarray}
\begin{eqnarray}
u_{\pm}(\varepsilon,r_s;r) &=& e^{\mp{\bar\kappa}{}r}\left[1-{\rm{erf}}\left(\frac{r_s{\bar\kappa}}{2}\mp{}\frac{r}{r_s}\right)\right]
\end{eqnarray}
\begin{eqnarray}
\varepsilon &=& -{\bar\kappa}^2
\end{eqnarray}
$$H_{L}$$ is parameterized by energy $$\varepsilon$$ and smoothing radius
$$r_s$$; their significance will will become clear shortly.
The extended family $$H_{pL}({\mathbf{r}})$$ is defined through powers of
the laplacian acting on $$H_{L}({\mathbf{r}})$$:
\begin{eqnarray}
H_{pL}({\mathbf{r}}) &=& \Delta^p H_{L}({\mathbf{r}})
\end{eqnarray}

In real space $$H_{pL}$$ must be generated recursively from $$h$$.
However, the Fourier transform of $$H_{pL}$$ has a closed form (I, Eq. 6.35):
\begin{eqnarray}
\widehat{H}_{L}(\varepsilon,r_s;{\bf{}q}) &=& 
-\frac{4\pi}{\varepsilon-q^2}\Upsilon_L(-i{\bf{}q})\,e^{r_s^2(\varepsilon-q^2)/4}
\end{eqnarray}
\begin{eqnarray}
\widehat{H}_{pL}(\varepsilon,r_s;{\bf{}q}) &=& 
-\frac{4\pi}{\varepsilon-q^2}\Upsilon_L(-i{\bf{}q})(-q^2)^p\,e^{r_s^2(\varepsilon-q^2)/4}
\end{eqnarray}
By taking limiting cases we can see the connection with familiar
functions, and also the significance of parameters $$\varepsilon$$ and $$r_s$$.

1. $$p=0$$ and $$r_s=0$$:
   $$\widehat{H}_{00}(\varepsilon,0;{\bf{}q})=-{4\pi/(\varepsilon-q^2)}$$\\
   This is the Fourier transform of
   $$H_{00}(\varepsilon,0;r)=\exp(-{\bar\kappa}{}r)/r$$, and is proportional to the
   $$l=0$$ spherical Hankel function of the first kind, $$h_\ell^{(1)}(z)$$.  For
   general $$L$$ the relation is
   \begin{eqnarray}
     H_{L}(\varepsilon,0;{\mathbf{r}})=H_{0L}(\varepsilon,0;{\mathbf{r}})=-i^\ell{\bar\kappa}^{\ell+1}h_\ell^{(1)}(i{\bar\kappa}{}r)Y_L(\hat{\mathbf{r}})
   \end{eqnarray}

2. $$p=1$$ and $$\varepsilon=0$$: $$\widehat{H}_{10}(0,r_s;{\bf{}q})=-{4\pi} e^{-r_s^2q^2/4} $$.\\
   This is the Fourier transform of a Gaussian function, whose width is
   defined by $$r_s$$. For general $$L$$ we can define the family of generalized Gaussian functions
   \begin{eqnarray}
    G_{0L}(\varepsilon,r_s;{\mathbf{r}}) = \Upsilon_L(-\nabla) g(\varepsilon,r_s;r)
                         =  \left(\frac{1}{\pi r_s^2}\right)^{3/2} e^{\varepsilon r_s^2/4}
                              \left(2r_s^{-2}\right)^l e^{-r^2/r_s^2} 
   \end{eqnarray}
   where _g_ is a simple gaussian with an extra normalization:
   \begin{eqnarray}
    g(\varepsilon,r_s;r) &=& \left(\frac{1}{\pi r_s^2}\right)^{3/2} e^{\varepsilon r_s^2/4}e^{-r^2/r_s^2}
   \end{eqnarray}

Comparing cases i and ii with Eq. (XXX), evidently
$$\widehat{H}_L({\mathbf{q}})$$ is proportional to the product of the Fourier
transforms of a conventional spherical Hankel function of the first kind,
and a gaussian.  By the convolution theorem, $${H_L}({\mathbf{r}})$$ is a
convolution of a Hankel function and a gaussian.  For $$r\gg r_s$$,
$${H_L}({\mathbf{r}})$$ behaves as a Hankel function and asymptotically tends to
$$H_L({\mathbf{r}})\to r^{-l-1}\exp(-\sqrt{-\varepsilon}r)Y_L(\hat{\mathbf{r}})$$.
For $$r\ll r_s$$ it has structure of a gaussian; it is therefore analytic and
regular at the origin, varying as $$r^lY_L(\hat{\mathbf{r}})$$.  Thus, the
$$r^{-l-1}$$ singularity of the Hankel function is smoothed out, with $$r_s$$
determining the radius for transition from Gaussian-like to Hankel-like
behavior.  Thus, the smoothing radius $$r_s$$ determines the smoothness of
$$H_L$$, and also the width of generalized gaussians $$G_L$$.

By analogy with Eq.~(XXXX) we can extend the $$G_{L}$$ family with the
laplacian operator:
\begin{eqnarray}
G_{pL}(\varepsilon,r_s;{\mathbf{r}}) = 
      \Delta^p\, G_{0L}(\varepsilon,r_s;{\mathbf{r}}) =
      \Upsilon_L(-\nabla) \Delta^p g(\varepsilon,r_s;r)
\end{eqnarray}
\begin{eqnarray}
G_{pL}(\varepsilon,r_s;{\mathbf{r}}) = 
      \Upsilon_L(-\nabla)\left(\frac{1}{r}\frac{\partial^2}{\partial r^2}r\cdot\right)^p g(\varepsilon,r_s;r)\\
\end{eqnarray}
\begin{eqnarray}
\widehat{G}_{pL}(\varepsilon,r_s;{\mathbf{q}}) = 
      \Upsilon_L(-i{\mathbf{q}})(-q^2)^p e^{r_s^2(\varepsilon-q^2)/4}
\end{eqnarray}

The second Equation shows that $$G_{pL}$$ has the structure (polynomial of order $$p$$ in $$r^2$$)$$\times G_L$$.
Comparing the last form Eq.~(\ref{eq:defgplq}) to Eq.~(\ref{eq:defhplq})
and the definition of $$H_{pL}$$ Eq.~(\ref{eq:defhpl}), we obtain the useful relations
\begin{eqnarray}
H_{p+1,L}(\varepsilon,r_s;{\mathbf{r}})+\varepsilon H_{pL}(\varepsilon,r_s;{\mathbf{r}})
=-4\pi G_{pL}(\varepsilon,r_s;{\mathbf{r}})\\
\end{eqnarray}
\begin{eqnarray}
\left(\Delta+\varepsilon\right)H_{pL}(\varepsilon,r_s;{\mathbf{r}})
=-4\pi G_{pL}(\varepsilon,r_s;{\mathbf{r}})
\end{eqnarray}
This shows that $$H_{pL}$$ is the solution to the Helmholz operator $$\Delta+\varepsilon$$
in response to a source term smeared out in the form of a gaussian.  A 
conventional Hankel function is the response a point multipole at the
origin (see I, Eq.~6.14).  $$H_{pL}$$ is also the solution to the
Schrodinger equation for a potential that has an approximately
gaussian dependence on $$r$$ (Ref I, Eq.~6.30).

### Two-center integrals of smoothed Hankels

One extremely useful property of the $$H_{pL}$$ is that the product
of two of them, centered at different sites $${\mathbf{r}}_1$$ and
$${\mathbf{r}}_2$$, can be integrated in closed form.  The result a sum
of other $$H_{pL}$$, evaluated at the connecting vector
$${\mathbf{r}}_1-{\mathbf{r}}_2$$.  This can be seen from the power theorem
of Fourier transforms
\begin{eqnarray}
\int H^*_1({\mathbf{r}}-{\mathbf{r}}_1) H_2({\mathbf{r}}-{\mathbf{r}}_2) d^3r = 
(2\pi)^{-3} \int {\widehat{H}}
\end{eqnarray}
and the fact that
$$\widehat{H}^*_{p_1L_1}({\mathbf{q}})\widehat{H}_{p_2L_2}({\mathbf{q}})$$ can
be expressed as a linear combination of other
$$\widehat{H}_{pL}({\mathbf{q}})$$, or their energy derivatives.  This is
readily done from the identity
\begin{eqnarray}
\frac{1}{(\varepsilon_1-q^2)(\varepsilon_2-q^2)}
&=&\frac{1}{\varepsilon_1-\varepsilon_2}
\left[
\frac{1}{\varepsilon_2-q^2} - \frac{1}{\varepsilon_1-q^2}
\right]
\mathop{\longrightarrow}\limits^{\varepsilon_2\to\varepsilon_1}&
\frac{1}{(\varepsilon_1-q^2)^2}
\end{eqnarray}

Comparing the first identity and the form Eq.~(\ref{eq:defhplq})
of $$\widehat{H}_{p0}({\mathbf{q}})$$, it can be immediately seen that
the product of two $$\widehat{H}_{p0}({\mathbf{q}})$$ with different
energies can be expressed as a linear combination of two
$$\widehat{H}_{p0}({\mathbf{q}})$$.  The second identity applies when the
$$\widehat{H}_{p0}({\mathbf{q}})$$ have the same energy; the product will
involve the energy derivative of some $$\widehat{H}_{p0}({\mathbf{q}})$$.
For higher $$L$$,
$$\Upsilon^*_{L_1}(-i{\mathbf{q}})\Upsilon_{L_2}(-i{\mathbf{q}})$$ 
is expanded as a linear combination of
$$\Upsilon^*_{M}(-i{\mathbf{q}})$$ using the expansion theorem for
spherical harmonics, Eq.~(\ref{eq:expandsharm}).  In detail,

{::comment}

(2\pi)^{-3}\int \widehat{H}^*_1({\mathbf{q}}) 
\widehat{H}_2({\mathbf{q}}) e^{i{\mathbf{q}}\cdot({\mathbf{r}}_1-{\mathbf{r}}_2)} d^3q

\begin{eqnarray}
\frac{1}{(\varepsilon_1-q^2)(\varepsilon_2-q^2)}
&=&\frac{1}{\varepsilon_1-\varepsilon_2}
\left[
\frac{1}{\varepsilon_2-q^2} - \frac{1}{\varepsilon_1-q^2}
\right]
\label{eq:expandemq}
\\
&\mathop{\longrightarrow}\limits^{\varepsilon_2\to\varepsilon_1}&
\frac{1}{(\varepsilon_1-q^2)^2}
\label{eq:expandemqb}
\end{eqnarray}


### _Other Resources_
{::comment}
/docs/code/jpos/#other-resources/
{:/comment}

1. Many mathematical properties of smoothed Hankel functions and the $$H_{pL}$$ family
are described in this paper:  
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
_Nonsingular Hankel functions as a new basis for electronic structure calculations_,
[J. Math. Phys. 39, 3393 (1998)](http://dx.doi.org/10.1063/1.532437)

