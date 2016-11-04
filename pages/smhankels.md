---
layout: page-fullwidth
title: "Smooth Hankel Functions"
permalink: "/docs/code/smhankels/"
header: no
---

### _Purpose_
{:.no_toc}
_____________________________________________________________
To describe a some of the properties of smooth Hankel functions.
They form the basis set of the **lmf**{: style="color: blue"} code,
and they are used for other properties, e.g. in the calculation of the electrostic potential.
They also form the backbone of the new [Jigsaw Puzzle Orbitals](/docs/code/jpos/) basis.

### _Table of Contents_
{:.no_toc}
_____________________________________________________________
*  Auto generated table of contents
{:toc}

### *Unique properties of Smoothed Hankel functions*
{::comment}
/docs/code/smhankels/#unique-properties-of-smoothed-hankel-functions
{:/comment}
_____________________________________________________________

Smooth Hankel functions are convolutions of ordinary Hankel functions and Gaussian functions and are regular at the origin. 
Ordinary Hankel functions $$\bar H_L$$ are solutions of the Helmholtz wave equation
\begin{eqnarray}
\left(\Delta+\varepsilon\right)\bar H_L(\varepsilon,{\mathbf{r}})
=-4\pi \delta({\mathbf{r}})  \quad\quad\quad\quad (1)
\end{eqnarray}
Solutions are products of radial functions and spherical harmonics $$Y_L(\hat{\mathbf{r}})$$,
Here $$L$$ is a compound index for the $$\ell{}m$$ quantum numbers.
Radial functions are spherical Hankel or Bessel functions.  We will focus on the Hankel functions:
\begin{eqnarray}
\bar H_L(\varepsilon;{\mathbf{r}})=-i^\ell{\bar\kappa}^{\ell+1}h_\ell^{(1)}(i{\bar\kappa}{}r)Y_L(\hat{\mathbf{r}})
\quad\hbox{ where }\quad {\bar\kappa}^2 = -\varepsilon 
\quad\quad\quad\quad (2)
\end{eqnarray}
where $$h_\ell^{(1)}(z)$$ is the spherical Hankel function of the first kind.
Hankel (Bessel) functions are regular (irregular) as <i>r</i>&rarr;&infin;;
thus Hankel functions are exact solutions of the Schr&ouml;dinger equation in a flat potential with appropriate boundary conditions for large _r_.
For small _r_, the situation is reversed with Bessel functions being regular. Hankel and Bessel functions vary as $$r^{-\ell-1}$$ and $$r^{\ell}$$ when
_r_&rarr;0. 

When envelope functions are augmented with [partial waves](/docs/package_overview/#linear-methods-in-band-theory) in spheres around atoms, the irregular part of $$\bar H_L$$ is eliminated.  Thus augmented Hankel functions can form exact solutions to the Schr&ouml;dinger equation in a muffin-tin potential. 

Smooth Hankel functions $$H_L$$ are regular for both large and small _r_.  The Figure below compares ordinary Hankel functions $$\bar H_L(\varepsilon,{\mathbf{r}})$$ (dashed lines) to smooth ones $$H_L$$ for $$\varepsilon{=}-0.5$$.
Red, green, and blue correspond to $$\ell=0,1,2$$.

![Ordinary and Smooth Hankel functions](/assets/img/smhankels.svg)

Smooth Hankels are superior to ordinary ones, first because real potentials are not flat so there is scope for improvement on the Hankel functions as the basis set.

Also the fact that the <i>H<sub>L</sub></i> are everywhere smooth can greatly facilitate their implementation.   In the present Questaal implementation the charge density is kept on a uniform mesh of points.  Sharply peaked functions require finer meshes, and some smoothing would necessary in any case.

Finally also have a sensible asymptotic form, decaying exponentially as real wave functions do when far from an atom.  Thus they have better shape than gaussian orbitals do.

Smooth Hankels have two big drawbacks as a basis set.  First, they are more complicated to work with.  One center expansions of
ordinary Hankels (needed for augmentation) are Bessel functions.  A counterpart does exist for smooth Hankels, but expansions are polynomials
related to Laguerre polynomials.  The expansion is cumbersom and introduces an extra cutoff in the polynomial order. 

Second, gaussian orbitals hold an enormous advantage over both ordinary and smooth Hankels, namely that the product of two of them in real space can be
expressed as another gaussian (plane waves have a similar property).
There exist no counterpart for Hankels, so an auxiliary basis must be constructed to make the charge density and
matrix elements of the potential.  The Questaal suite uses plane waves for the auxiliary basis.

### *Smooth Hankel functions and the H<sub>kL</sub> family*
____________________________________________________________________
{::comment}
/docs/code/smhankels/#smooth-hankel-functions-and-the-hsubkLsub-family
{:/comment}

Methfessel's class of functions $$H_{kL}$$, are a superset of 
smoothed Hankel functions $$H_L$$; they also incorporate the family of 
(polynomial)$$\times$$(gaussians).  The $$H_L$$ and the $$H_{kL}$$
 are defined in [reference 1](/docs/code/smhankels/#other-resources), and many of
their properties derived there.  The $$H_{kL}({\mathbf{r}})$$ are a
family of functions with $$k=0,1,2,...$$ and angular momentum
$$L$$.  They are members of the general class of functions
$$F_L({\mathbf{r}})$$ which are determined from a single radial
function by 
\begin{eqnarray}
F_L({\mathbf{r}}) = \Upsilon_L(-\nabla) \, f(r)  \quad\quad\quad\quad (3)
\end{eqnarray}
$$\Upsilon_L({\mathbf{r}})$$ with $${\mathbf{r}}=(x,y,z)$$ is a polynomial in $$(x,y,z)$$, 
so is meaningful to talk about $$\Upsilon_L(-\nabla)$$.
It is written in terms of
conventional spherical harmonics as
\begin{eqnarray}
\Upsilon_L({\mathbf{r}}) = r^\ell Y_L (\hat{\mathbf{r}}) \quad\quad\quad\quad (4)
\end{eqnarray}
Just as the product of two spherical harmonics can be expanded in
Clebsh Gordan coefficients $$C_{KLM}$$ and spherical harmonics,
so can the product of two spherical harmonic polynomials:
\begin{eqnarray}
Y_K(\hat{\mathbf{r}})Y_L(\hat{\mathbf{r}}) = \sum_M C_{KLM} Y_M({\hat{\mathbf{r}}})
\end{eqnarray}
\begin{eqnarray}
\Upsilon_K({\mathbf{r}})\Upsilon_L({\mathbf{r}}) = \sum_M C_{KLM} r^{k+\ell-m} \Upsilon_M({\mathbf{r}})
\quad\quad\quad\quad (5)
\end{eqnarray}
$$C_{KLM}$$ is nonzero only when $${k+\ell-m}$$ is an even integer, so
the r.h.s. is also a polynomial in $$(x,y,z)$$, as it must be.

Functions $$H_{L}({\mathbf{r}})$$ are defined through the radial function $$h(r)$$
(Ref 1, Eq. 6.5):
\begin{eqnarray}
H_{L}(\varepsilon,r_s;{\mathbf{r}}) &=& \Upsilon_L(-\nabla) h(\varepsilon,r_s;r)
\quad\quad\quad\quad\quad\quad\quad\quad (6)
\end{eqnarray}
\begin{eqnarray}
h(\varepsilon,r_s;r) &=& \frac{1}{2r}\left(u_+(\varepsilon,r_s;r) - u_{-}(\varepsilon,r_s;r)\right)
\quad\quad\quad\quad (7)
\end{eqnarray}
\begin{eqnarray}
u_{\pm}(\varepsilon,r_s;r) &=& e^{\mp{\bar\kappa}{}r}\left[1-{\rm{erf}}\left(\frac{r_s{\bar\kappa}}{2}\mp{}\frac{r}{r_s}\right)\right]
\quad\quad\quad\quad (8)
\end{eqnarray}
$$H_{L}$$ is parameterized by energy $$\varepsilon$$ and smoothing radius
$$r_s$$; their significance will will become clear shortly.
The extended family $$H_{kL}({\mathbf{r}})$$ is defined through powers of
the Laplacian acting on $$H_{L}({\mathbf{r}})$$:
\begin{eqnarray}
H_{kL}({\mathbf{r}}) &=& \Delta^k H_{L}({\mathbf{r}})
\quad\quad\quad\quad (9)
\end{eqnarray}

In real space $$H_{kL}$$ must be generated recursively from $$h$$.
However, the Fourier transform of $$H_{kL}$$ has a closed form (Ref 1, Eq. 6.35).
The differential operator becomes a multiplicative operator
in the reciprocal space so
\begin{eqnarray}
\widehat{H}_{kL}(\varepsilon,r_s;\mathbf{q}) &=& 
-\frac{4\pi}{\varepsilon-q^2}\Upsilon_L(-i\mathbf{q})\,(-q^2)^k\,e^{r_s^2(\varepsilon-q^2)/4}
\quad\quad\quad\quad (10)
\end{eqnarray}
By taking limiting cases we can see the connection with familiar
functions, and also the significance of parameters $$\varepsilon$$ and $$r_s$$.

1. $$k=0$$ and $$r_s=0$$:
   $$\widehat{H}_{00}(\varepsilon,0;\mathbf{q})=-{4\pi/(\varepsilon-q^2)}$$\\
   This is the Fourier transform of
   $$H_{00}(\varepsilon,0;r)=\exp(-{\bar\kappa}{}r)/r$$, and is proportional to the
   $$\ell=0$$ spherical Hankel function of the first kind, $$h_0^{(1)}(z)$$.  For
   general $$L$$ the relation is
   \begin{eqnarray}
     H_{0L}(\varepsilon,0;{\mathbf{r}})=H_{L}(\varepsilon,0;{\mathbf{r}})=\bar H_{L}(\varepsilon,{\mathbf{r}})=-i^\ell{\bar\kappa}^{\ell+1}h_\ell^{(1)}(i{\bar\kappa}{}r)Y_L(\hat{\mathbf{r}})
   \end{eqnarray}
   which is Eq. 2.

2. $$k=1$$ and $$\varepsilon=0$$: $$\widehat{H}_{10}(0,r_s;\mathbf{q})=-{4\pi} e^{-r_s^2q^2/4} $$.\\
   This is the Fourier transform of a Gaussian function, whose width is
   defined by $$r_s$$. For general $$L$$ we can define the family of generalized Gaussian functions
   \begin{eqnarray}
    G_{0L}(\varepsilon,r_s;{\mathbf{r}}) = \Upsilon_L(-\nabla) g(\varepsilon,r_s;r)
                         =  \left(\frac{1}{\pi r_s^2}\right)^{3/2} e^{\varepsilon r_s^2/4}
                              \left(2r_s^{-2}\right)^l e^{-r^2/r_s^2} Y_L(\hat{\mathbf{r}})
   \end{eqnarray}
    _g_ is a simple gaussian with an extra normalization:
   \begin{eqnarray}
    g(\varepsilon,r_s;r) &=& \left(\frac{1}{\pi r_s^2}\right)^{3/2} e^{\varepsilon r_s^2/4}e^{-r^2/r_s^2}
   \quad\quad\quad\quad (11)
   \end{eqnarray}

Comparing cases 1 and 2 with Eq. (10), evidently
$$\widehat{H}_L(\mathbf{q})$$ is proportional to the product of the Fourier
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

By analogy with Eq. (9) we can extend the $$G_{L}$$ family with the
Laplacian operator:
\begin{eqnarray}
G_{kL}(\varepsilon,r_s;{\mathbf{r}}) = 
      \Delta^k\, G_{0L}(\varepsilon,r_s;{\mathbf{r}}) =
      \Upsilon_L(-\nabla) \Delta^k g(\varepsilon,r_s;r)
\quad (12)
\end{eqnarray}
\begin{eqnarray}
G_{kL}(\varepsilon,r_s;{\mathbf{r}}) = 
      \Upsilon_L(-\nabla)\left(\frac{1}{r}\frac{\partial^2}{\partial r^2}r\cdot\right)^k g(\varepsilon,r_s;r)\\
\quad\quad\quad\quad (13)
\end{eqnarray}

$$
\widehat{G}_{kL}(\varepsilon,r_s;\mathbf{q}) = 
      \Upsilon_L(-i\mathbf{q})(-q^2)^k e^{r_s^2(\varepsilon-q^2)/4}
\quad\quad\quad\quad\quad\quad (14)
$$

The second equation shows that $$G_{kL}$$ has the structure (polynomial of order $$k$$ in $$r^2$$)$$\times G_L$$.
These polynomials are related to the generalized Laguerre polynomials of half-integer order in $$r^2$$.
They obey a recurrence relation (see Ref 1, Eq. 5.19), which is how they are evaluated in practice.
They are proportional to the polynomials <i>P<sub>kL</sub></i> used in one-center expansions of 
smoothed Hankels around remote sites (see Ref 1, Eq. 12.7).

##### Differential equation for smooth Hankel functions

Comparing the last form Eq. (14) to Eq. (10)
and the definition of $$H_{kL}$$ Eq. (9), we obtain the useful relations
\begin{eqnarray}
H_{k+1,L}(\varepsilon,r_s;{\mathbf{r}})+\varepsilon H_{kL}(\varepsilon,r_s;{\mathbf{r}})
=-4\pi G_{kL}(\varepsilon,r_s;{\mathbf{r}})\\
\quad\quad\quad\quad (15)
\end{eqnarray}
\begin{eqnarray}
\left(\Delta+\varepsilon\right)H_{kL}(\varepsilon,r_s;{\mathbf{r}})
=-4\pi G_{kL}(\varepsilon,r_s;{\mathbf{r}})
\quad\quad\quad\quad\quad\quad\quad\  (16)
\end{eqnarray}
This shows that $$H_{kL}$$ is the solution to the Helmholz operator $$\Delta+\varepsilon$$
in response to a source term smeared out in the form of a gaussian.  A 
conventional Hankel function is the response to a point multipole at the
origin (see Ref 1, Eq. 6.14).  $$H_{kL}$$ is also the solution to the
Schr&ouml;dinger equation for a potential that has an approximately
gaussian dependence on _r_ (Ref 1, Eq. 6.30).

### _Two-center integrals of smoothed Hankels_
_______________________________________________________________
One extremely useful property of the $$H_{kL}$$ is that the product
of two of them, centered at different sites $${\mathbf{r}}_1$$ and
$${\mathbf{r}}_2$$, can be integrated in closed form.  The result a sum
of other $$H_{kL}$$, evaluated at the connecting vector
$${\mathbf{r}}_1-{\mathbf{r}}_2$$.  This can be seen from the power theorem
of Fourier transforms

$$
\int H^*_1({\mathbf{r}}-{\mathbf{r}}_1) H_2({\mathbf{r}}-{\mathbf{r}}_2) d^3r =
(2\pi)^{-3}\int \widehat{H}^*_1(\mathbf{q}) 
\widehat{H}_2(\mathbf{q}) e^{i\mathbf{q}\cdot({\mathbf{r}}_1-{\mathbf{r}}_2)} d^3q
\quad\quad\quad\quad (17)
$$

and the fact that
$$\widehat{H}^*_{k_1L_1}(\mathbf{q})\widehat{H}_{k_2L_2}(\mathbf{q})$$ can
be expressed as a linear combination of other
$$\widehat{H}_{kL}(\mathbf{q})$$, or their energy derivatives.  This is
readily done from the identity
\begin{eqnarray}
\frac{1}{(\varepsilon_1-q^2)(\varepsilon_2-q^2)}
&=&\frac{1}{\varepsilon_1-\varepsilon_2}
\left[
\frac{1}{\varepsilon_2-q^2} - \frac{1}{\varepsilon_1-q^2}
\right]
\mathop{\longrightarrow}\limits^{\varepsilon_2\to\varepsilon_1}&
\frac{1}{(\varepsilon_1-q^2)^2}
\quad\quad\quad\quad (18)
\end{eqnarray}

Comparing the first identity and the form Eq.~(10)
of $$\widehat{H}_{p0}(\mathbf{q})$$, it can be immediately seen that
the product of two $$\widehat{H}_{p0}(\mathbf{q})$$ with different
energies can be expressed as a linear combination of two
$$\widehat{H}_{p0}(\mathbf{q})$$.  The second identity applies when the
$$\widehat{H}_{p0}(\mathbf{q})$$ have the same energy; the product will
involve the energy derivative of some $$\widehat{H}_{p0}(\mathbf{q})$$.
For higher $$L$$,
$$\Upsilon^*_{L_1}(-i\mathbf{q})\Upsilon_{L_2}(-i\mathbf{q})$$ 
is expanded as a linear combination of
$$\Upsilon^*_{M}(-i\mathbf{q})$$ using the expansion theorem for
spherical harmonics, Eq. (5).  In detail,

$$
{\widehat{H}^*_{k_1L_1}}(\varepsilon_1,r_{s_1};\mathbf{q})
{\widehat{H}_{k_2L_2}}(\varepsilon_2,r_{s_2};\mathbf{q}) =
\frac{(4\pi)^2}{(\varepsilon_1-q^2)(\varepsilon_2-q^2)}
\Upsilon^*_{L_1}(-i{\mathbf{q}})\Upsilon_{L_2}(-i{\mathbf{q}})
(-q^2)^{k_1+k_2}\,e^{r_{s_1}^2(\varepsilon_1-q^2)/4+r_{s_2}^2(\varepsilon_2-q^2)/4}
\quad\quad (19)
$$

which can be written as
\begin{equation}
\frac{(4\pi)^2}{\varepsilon_1-\varepsilon_2}
\left[
\frac{e^{r_{s_1}^2(\varepsilon_1-\varepsilon_2)/4}e^{(r_{s_2}^2+r_{s_1}^2)(\varepsilon_2-q^2)/4}}{\varepsilon_2-q^2}-
\frac{e^{r_{s_2}^2(\varepsilon_2-\varepsilon_1)/4}e^{(r_{s_1}^2+r_{s_2}^2)(\varepsilon_1-q^2)/4}}{\varepsilon_1-q^2}
\right]\times 
(-q^2)^{k_1+k_2} i^{2\ell_1}
\sum_M C_{L_1L_2M} \Upsilon_{M}(-i{\mathbf{q}}) (-q^2)^{(\ell_1+\ell_2-m)/2}
\end{equation}
where $$r_{s}^2=r_{s_1}^2+r_{s_2}^2$$.

This last equation is a linear combination of
$$H_{kL}$$ with smoothing radius $$r_s$$ given as shown.

Using the power theorem the two-center integrals can be directly evaluated:

$$
\int{H^*_{k_1L_1}}(\varepsilon_1,r_{s_1};{\mathbf{r}}-{\mathbf{r}_1})
{H_{k_2L_2}}(\varepsilon_2,r_{s_2};{\mathbf{r}}-{\mathbf{r}_2})\, d^3r
=
\frac{1}{(2\pi)^3}
\int
{\widehat{H}^*_{k_1L_1}}(\varepsilon_1,r_{s_1};{\mathbf{q}})
{\widehat{H}_{k_2L_2}}(\varepsilon_2,r_{s_2};{\mathbf{q}})\,
e^{i{\mathbf{q}}\cdot\left({\mathbf{r}}_1-{\mathbf{r}}_2\right)} d^3q
\quad\quad (20)
$$

This can be written as

$$
(-1)^{\ell_1}\frac{4\pi}{\varepsilon_1-\varepsilon_2}
\sum_M C_{L_1L_2M} \times
\big[
    {\ e^{r_{s_2}^2(\varepsilon_2-\varepsilon_1)/4}{H_{k_1+k_2+{(\ell_1+\ell_2-m)/2},M}}(\varepsilon_1,r_{s};{\mathbf{r}}_1-{\mathbf{r}}_2)}
{- e^{r_{s_1}^2(\varepsilon_1-\varepsilon_2)/4}{H_{k_1+k_2+{(\ell_1+\ell_2-m)/2},M}}(\varepsilon_2,r_{s};{\mathbf{r}}_1-{\mathbf{r}}_2)}
\ \big]
$$

The special case $$\varepsilon_1=\varepsilon_2=\varepsilon$$ must
be handled using the limiting form of Eq. (18).
Differentiation of Eq. (10) with respect to energy results in

$$
\widehat{\dot{H}}_{kL} \equiv
\frac{\partial\widehat{H}_{kL}}{\partial\varepsilon} = 
-\frac{1}{\varepsilon-q^2}\widehat{H}_{kL} + (r_s^2/4) \widehat{H}_{kL}.
\quad\quad\quad\quad (21)
$$

The two-center integral now becomes

$$
\int{H^*_{k_1L_1}}(\varepsilon,r_{s_1};\mathbf{r}-\mathbf{r}_1)
H_{k_2L_2}(\varepsilon,r_{s_2};\mathbf{r}-\mathbf{r}_2)\, d^3r
= 
$$

$$
(-1)^{\ell_1}{4\pi} \sum_M C_{L_1L_2M} \times
\big[
    {\dot{H}_{k_1+k_2+{(\ell_1+\ell_2-m)/2},M}}(\varepsilon,r_{s};\mathbf{r}_1-\mathbf{r}_2)
   - (r_s^2/4) {H_{k_1+k_2+{(\ell_1+\ell_2-m)/2},M}}(\varepsilon,r_{s};\mathbf{r}_1-\mathbf{r}_2)
\big]
\quad\quad\quad\quad (22)
$$

If we consider a further limiting case, namely $$\varepsilon_1=\varepsilon_2=0$$,
Eq. (22) simplifies to

$$
\widehat{\dot{H}}_{kL}
\mathop{\longrightarrow}\limits^{\varepsilon\to 0} - \frac{1}{-q^2}\widehat{H}_{kL} + (r_s^2/4) \widehat{H}_{kL}
= - \widehat{H}_{k-1,L} + (r_s^2/4)\widehat{H}_{kL}
\quad\quad\quad\quad (23)
$$


and the two-center integral simplifies to

$$
\int
{H}^*_{k_1L_1}(0,r_{s_1};{\mathbf{r}}-{\mathbf{r}_1})
{H}_{k_2L_2}(0,r_{s_2};{\mathbf{r}}-{\mathbf{r}_2})\, d^3r
=
(-1)^{\ell_1}(-{4\pi})
\sum_M C_{L_1L_2M} \times
H_{k_1+k_2-1+{(\ell_1+\ell_2-m)/2},M}(0,r_{s};{\mathbf{r}}_1-{\mathbf{r}}_2).
\quad\quad (24)
$$

When $$\varepsilon=0$$ and $$k\ge 1$$ the $$H_{kL}$$ are generalized Gaussian functions of the type Eq. (12), scaled by $$-4\pi$$; see
Eq. (16).  Eq. (24) is then suitable for two-center integrals of generalized Gaussian functions.

### _Smoothed Hankels for positive energy_
_______________________________________________________________
The smooth Hankel functions defined in Ref. 1 for negative energy
also apply for positive energy.  We demonstrate that here, and
show that the difference between the conventional and smooth
Hankel functions are real functions.

Ref. 1 defines $${\bar\kappa}$$ in contradistinction to usual convention for $$\kappa$$

\begin{equation}
{\bar\kappa}^2 = -\varepsilon \hbox{  with  }{\bar\kappa}>0
\end{equation}
and restricts $$\varepsilon {\lt} 0$$.
According to usual conventions $$\kappa$$ is defined as 
\begin{equation}
 \kappa = \sqrt\varepsilon \hbox{,     Im}(\kappa) \ge 0.
\end{equation}
We can define for any energy
\begin{equation}
\bar\kappa = -i \kappa .
\end{equation}
Then $$\bar\kappa$$ is real and positive if 
$$\varepsilon \lt 0$$,
while $$\kappa$$ is real and positive if $$\varepsilon \gt 0$$.

The smoothed Hankel _s_ orbitals for $$\ell=0$$ and $$\ell=-1$$ are real:
\begin{eqnarray}
h^s_0 (r) &=& (u_+ - u_-) / 2r \hbox{ and }
h^s_{-1}(r) &=& (u_+ + u_-) / 2{\bar\kappa} 
\end{eqnarray}

To extend the definition to any energy we define $$U_{\pm}$$ as:
\begin{equation}
U_{\pm} = e^{\pm i\kappa r}\, \mathrm{erfc}\left(r/r_s\pm{i\kappa r_s}/2\right)
\end{equation}
The following relations are useful:

$$
\mathrm{erfc}(-x)
$$



Then for $$\varepsilon \lt 0$$, $$i\kappa$$ is real and 
\begin{equation}
U_+ = 2e^{i\kappa r} - u_+ \hbox{ and } U_- = u_-
\end{equation}
are also real.


The difference in ordinary and smoothed Hankels is
\begin{equation}
h_0  - h^s_0  	  = [e^{i \kappa r} - u_+/2 + u_-/2] /r
              	  = [U_+/2 + U_-/2] /r
\end{equation}
\begin{equation}
h_{-1} - h^s_{-1} = [e^{i \kappa r} - u_+/2 - u_-/2] /{\bar\kappa}
              	  = [U_+/2 - U_-/2] /(-i \kappa)
\end{equation}

For $$\varepsilon>0$$, $$\kappa$$ is real and $$U_+$$ = $$U_-^*$$.
The difference in ordinary and smoothed Hankels is
\begin{equation}
h_0  - h^s_0      = [U_+/2 + U_-/2] /r = \mathrm{Re}(U_+) /r 
\end{equation}
\begin{equation}
h_{-1} - h^s_{-1} = [U_+/2 - U_-/2] / (-i \kappa) = -\mathrm{Im} (U_+) / \kappa
\end{equation}
Both are real, though $$h_0$$ and $$h_{-1}$$ are complex.

### _Other Resources_
____________________________________________________
{::comment}
/docs/code/smhankels/#other-resources/
{:/comment}

1. Many mathematical properties of smoothed Hankel functions and the $$H_{kL}$$ family
are described in this paper:  
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
_Nonsingular Hankel functions as a new basis for electronic structure calculations_,
[J. Math. Phys. 39, 3393 (1998)](http://dx.doi.org/10.1063/1.532437)
