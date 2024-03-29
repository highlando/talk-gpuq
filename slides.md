---
author: 
 - Jan Heiland (MPI Magdeburg)
 - Peter Benner (MPI Magdeburg)
title: Multidimensional Galerkin POD for UQ of PDE Solutions with Random Parameters
subtitle: virtual USNCCM 2021 
title-slide-attributes:
    data-background-image: pics/mpi-bridge.gif
parallaxBackgroundImage: pics/csc-en.svg
parallaxBackgroundSize: 1000px 1200px
bibliography: gpuq-talk.bib
---

# Introduction

---

## Example Problem Setup

 * The *heat equation* with uncertainty in the coefficient $\kappa$:
$$
-\kappa(\alpha) \Delta y = f, \quad \text{in }\Omega,
$$
where $\alpha$ is a random variable.

 * Then, *the* solution $y$ is a random variable depending on $\alpha$.

 * Of interest:
 $$
 \mathbb E_\alpha y, \quad \text{in }\Omega
 $$
 -- the expected value of the solution $y$.

<!-- ## Sampling Approach (Monte Carlo)

1. Draw a sample of $\alpha$: 
$$(\alpha^{(1)}, \alpha^{(2)}, \alpha^{(3)}, \alpha^{(4)}).$$

2. Compute the sample of $y(\alpha)$:  
$$(y(\alpha^{(1)}), y(\alpha^{(2)}), y(\alpha^{(3)}), y(\alpha^{(4)})).$$

3. Compute the empirical expected value
$$
\hat {\mathbb E}_\alpha = \frac{1}{4}(y(\alpha^{(1)})+ y(\alpha^{(2)})+ y(\alpha^{(3)})+ y(\alpha^{(4)})).
$$

## Collocation/Galerkin Approaches

1. *Discretize* the uncertainty, e.g., by shape functions $\eta_i$
$$
\hat y(\alpha) = \sum_{i=1}^4 y_i \eta_i(\alpha).
$$

2. Compute the coefficient functions $y_i$, e.g., through solving
$$
-\kappa(\alpha^{(i)})\Delta \hat y = f
$$
at given collocation points.

3. Compute the expected value of $\hat y$
$$
\mathbb E_\alpha y \approx \mathbb E_\alpha \hat y = \sum_{i=1}^4 y_i \mathbb E_\alpha \eta_i.
$$
-->


## Overview of approaches

## Monte Carlo (MC)

 * slow, but highly parallelizable

 * many *improvements* like *Multi Level MC*

 * little overhead for additional dimensions

## Galerkin/Collocation methods

 * e.g., *Polynomial Chaos Expansion* (PCE)

 * good convergence, effort grows exponentially with the dimensions

 * model reduction needed: *PCA*, *sparse grids*, *PGD*, *low-rank tensor formats*

 * general Hilbert space theory as in [@SoiG04]

 * for applications in PDE approximations see [@BabTZ04]


## This talk:

 * tensor representation of *PCE*

 * reduction through multidimensional POD


# Multidimensional Galerkin POD

## Setup
$$
\DeclareMathOperator{\spann}{span}
\def\yijk{\mathbf y^{i\,j\,k}}
\def\Vec{\mathop{\mathrm {vec}}\nolimits}
\def\Ltt{L^2((0,T))}
\def\Lto{L^2(\Omega)}
\def\Ltg{L^2(\Gamma;d\mathbb P_\alpha)}
\def\by{\mathbf y}
$$
Consider a multivariable function $y(t,x;\alpha)$:
$$
y\colon (0,T) \times \Omega \times \Gamma \to \mathbb R
$$

and the separated spaces for time, space, and uncertainty:
$$
\Ltt,\quad \Lto, \quad\text{and}\quad\Ltg.
$$

## Time-Space-PCE Galerkin Discretization

Finite dimensional "subspaces":

* $S = \spann\{\psi_1, \dotsc, \psi_s\} \subset \Ltt$,
* $X = \spann\{\phi_1, \dotsc, \phi_r\} \subset \Lto$,
* $W = \spann\{\eta_1, \dotsc, \eta_p\}~{}^{"}\mspace{-8mu}\subset^{"} \Ltg$,

and the Galerkin ansatz in $\by \in S\otimes X \otimes W$:
$$
\by = \sum_{i=1}^s\sum_{j=1}^r\sum_{k=1}^p \yijk \psi_i \phi_j \eta_k.
$$

## A Modest Example

 * $s=100$  -- "time steps"

 * $r=1000$ -- "nodes in the mesh"

 * $p=10$ -- "features in the uncertainty"

 * gives $s\cdot r \cdot p = 10^6$ -- number of unknowns

## Time-Space-PCE Galerkin POD

Goal: Dimension Reduction

Idea: Find a subspace $\hat S \subset S$ and projection $\Pi_{\hat S}$ such that
$$
\|\Pi_{\hat S} \by - \by\|_{S\otimes X \otimes W} 
$$
is minimal...

. . .

minimal in the sense that if there exists $\hat{\hat S}$ such that 
$\|\Pi_{\hat{\hat S}} \by - \by\|_{S\otimes X \otimes W}$ is smaller, than the dimension of $\hat{\hat S}$ is larger than that of $\hat S$.

## Solution: HOSVD -- higher order SVD

Recall:
$$
\by = \sum_{i=1}^s\sum_{j=1}^r\sum_{k=1}^p \yijk \psi_i \phi_j \eta_k
$$
that is, with $\mathbf Y = [\yijk]$, the discrete function

$$
    y \in S\otimes X \otimes W \longleftrightarrow \mathbf Y \in \mathbb R^{s \times r \times p}
$$

can be interpreted and reduced as a tensor $\mathbf Y$.

---

> **Theorem**: The $\hat s$-dimensional subspace $\hat S\subset S$ that optimally parametrizes $y\in S\otimes X \otimes W$ in $$\hat S \otimes X \otimes W$$ is defined by the $\hat s$ leading mode-(1) singular vectors of $\mathbf Y \in \mathbb R^{s \times r \times p}$.

. . .

Note that:

 * The reduced spaces define a reduced Galerkin discretization.

 * This works for any dimension in a product space $V = \prod_{\ell=1}^NV_i$.

# Application Example

## {data-background-image="pics/N7-physregs.png"}

## {data-background-image="pics/N7.png"}

. . .

::: {style="position: absolute; width: 60%; right: 0; box-shadow: 0 1px 4px rgba(0,0,0,0.5), 0 5px 25px rgba(0,0,0,0.2); background-color: rgba(0, 0, 0, 0.9); color: #fff; padding: 20px; font-size: 40px; text-align: left;"}
A generic *convection-diffusion* problem
$$
    b\cdot \nabla y- \nabla\cdot ( \kappa_\alpha \nabla y) = f,
$$
where we assume that the diffusivity coefficient depends on a random vector $\alpha=(\alpha_1, \alpha_2, \alpha_3, \alpha_4)$.
:::

## Ansatz


\providecommand{\nspinva}[1]{\mathsf{d} \mathbb P _ {#1}}
\providecommand\Ltgi[1]{L^2(\Gamma _ {#1};\nspinva{#1})}


Locate the solution $y$ (depending on space $x$ and the random variable
$\alpha$) in
$$
    \Lto \cdot \Ltgi 1 \cdot \Ltgi 2 \cdot \Ltgi 3 \cdot \Ltgi 4
$$

and use 

 * a standard FEM space $X$ to discretize $\Lto$,
 * and *Polynomial Chaos Expansions* (PCE), e.g.,
   * Lagrange polynomials with
   * weights and nodes chosen according to the distribution of $\alpha_i$
   * to define $W_i$, $i=1,2,3,4$.


## Numerical Realization

### 1. Training

Compute the discrete solution
$$
\bar y\in X\otimes \bar W_1 \otimes \bar W_2 \otimes \bar W_3 \otimes \bar W_4
$$
for a **low-dimensional** PCE discretization.

---

### 2. Reduction

Use the resulting tensor data
$$
\bar y \longleftrightarrow \bar {\mathbf Y} \in \mathbb R^{d_x \times \bar d_1 \times \dotsm \times \bar d_4}
$$
to compute an optimized low-dimensional approximation $$\hat X$$ for the FEM space $X$.

---

### 3. Prediction

Compute the discrete solution
$$
\hat y\in \hat X\otimes W_1 \otimes W_2 \otimes W_3 \otimes W_4
$$
for **high-dimensional** PCE discretizations and compare to

$$y\in X\otimes W_1 \otimes W_2 \otimes W_3 \otimes W_4,$$

i.e. the full-order solution.


## Result {data-background-image="pics/pcepoddiff.png"}

. . .

::: {style="position: absolute; width: 60%; right: 0; box-shadow: 0 1px 4px rgba(0,0,0,0.5), 0 5px 25px rgba(0,0,0,0.2); background-color: rgba(0, 0, 0, 0.9); color: #fff; padding: 20px; font-size: 40px; text-align: left;"}

 * Error in *expected value* over space.

 * Full solve: $5^4 \times 90'000$ (`PCE x FEM`)

 * Training: $2^4 \times 90'000$

 * ROM solve: $5^4 \times 12$

 * Error level $\approx 10^{-6}$

 * Speed up factor $\approx 16$

 * Memory savings: $\approx 97$\% 

 * Monte Carlo: No convergence after $10^6 \times 90'000$.

:::

# Conclusion

## ... and Outlook

 * Multidimensional Galerkin POD applies naturally for FEM/PCE discretizations.

 * Significant savings of computation time and memory.

 * Outlook: Optimal control and time dependent problems.

. . .

Thank You!

## Resources

* Submitted to *Int. J. Numerical Methods in Engineering*

* Preprint: [arxiv:2009.01055](https://arxiv.org/abs/2009.01055)

* Code: [doi:10.5281/zenodo.4005724](https://doi.org/10.5281/zenodo.4005724)

---

---
nocite: |
  @SoiG04, @BabTZ04
...
