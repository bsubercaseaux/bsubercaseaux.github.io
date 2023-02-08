---
layout: post
title: A cute problem about asymptotics of a summation
date: 2023-01-23 11:12:00-0400
description: A solution to a nice little problem given to my Nicolás Sanhueza-Matamala.
tags: math, asymptotics, puzzle
categories: Math
comments: true
---

Chilean mathematician [Nicolás Sanhueza-Matamala](https://sanhueza.net/nicolas/) gave me the following problem:

**Problem 1.** Prove that for any $$ c \leq n/3$$ we have: 
\begin{equation}
           \sum_{r=1}^c \frac{c^r r^c}{r^{2r}} n^r  = O(n^c).
\end{equation}

Given that there are two variables involved, $$n$$ and $$c$$, to avoid confusion (some people were confused by this), let me restate the problem unrolling the big-Oh notation to avoid any potential ambiguities.

**Problem 1.** Define the function $$F(n, c) = \sum_{r = 1}^c \frac{c^r r^c}{r^{2r}} n^r $$. Now prove that there is an absolute constant $$K$$ and a natural $$n_0$$ such that, for any $$n \geq n_0$$ it holds that for every $$c \leq \frac{n}{3}$$ we have
	\begin{equation}
		F(n, c) \leq K \cdot n^c.
	\end{equation}


This problem came up in Nicolás' research in combinatorics, while trying to bound some combinatorial expression. At the end, this particular sub-problem didn't end up being useful for his project, and thus instead of simply throwing this solution to the trash can, I have decided to put it up here.

---

### My solution.

I now present my solution. If any reader of this blog has a nicer one, I'd be thrilled to check it out!
Funnily enough, it is crucial that $$ c \leq n/3$$, as $$c \leq n/2.5$$ would make this proof fail!

Start with the following algebra:

<div style="overflox-x: scroll;">
$$\begin{align}
		\sum_{r = 1}^c \frac{c^r r^c}{r^{2r}} n^r &= \sum_{k = 0}^{c-1} \frac{c^{(c-k)} (c-k)^c}{(c-k)^{2(c-k)}} n^{(c-k)}\\ 
		&= \sum_{k = 0}^{c-1} \left(\frac{c}{c-k}\right)^{c-k} \cdot (c-k)^{k} n^{(c-k)}\\
		&= \sum_{k = 0}^{c-1} \left(\frac{c}{c-k}\right)^{c-k} \cdot \left(\frac{c-k}{n}\right)^{k} n^{c}\\
		&\leq \sum_{k = 0}^{c-1} \left(\frac{c}{c-k}\right)^{c-k} \cdot \left(\frac{c}{n}\right)^{k} n^{c}\\
		&\leq \sum_{k = 0}^{c-1} \left(\frac{c}{c-k}\right)^{c-k} \cdot \left(\frac{1}{3}\right)^{k} n^{c}\\
		&= \sum_{k = 0}^{c-1} \left(1 + \frac{k}{c-k}\right)^{c-k} \cdot \left(\frac{1}{3}\right)^{k} n^{c}\\
		&= \sum_{r = 1}^{c} \left(1 + \frac{c-r}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} n^{c}\\
		&= \sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} n^{c}\\
		&=  n^{c} \cdot\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}.
	\end{align}$$
</div>

The idea of this part is that we have obtained an expression of the form $$n^c \cdot f(c)$$, where $$f(c) = \sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}$$. Our goal now is, naturally, to argue that $$f(c)$$ is bounded above by a constant. As a first step towards this goal, let us prove first that $$f(c)$$ is always increasing. In order to do this consider that

$$\begin{align}
        f(c+1)  - f(c) &= \left(\sum_{r = 1}^{c} \frac{1}{3} \left(\frac{c+1}{c}\right)^{r} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} - \sum_{r = 1}^{c} 		\left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}\right) + 1\\
			&= \sum_{r=1}^c \left[\frac{1}{3}
			\left(\frac{c+1}{c}\right)^{r} - 1\right]\left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} + 1.
	\end{align}$$

We now propose the following claim, which is equivalent to $$f$$ being increasing.
	
**Claim 1.** $$f(c+1) - f(c) > 0.$$

_Proof of Claim 1._ Because of the previous equation for $$f(c+1) - f(c)$$, what we want to prove is equivalent to.	

\begin{equation}
\sum_{r=1}^c \left[\frac{1}{3}
                \left(\frac{c+1}{c}\right)^{r} - 1\right]\left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} > -1.
\end{equation}
In turn, this is equivalent to proving 
\begin{equation}
         \sum_{r=1}^c \left[1 - \frac{1}{3}
                \left(1+\frac{1}{c}\right)^{r} \right]\left(\frac{3c}{r}\right)^{r}  < 3^{c} 
\end{equation}
but as $$\left(1+\frac{1}{c}\right)^{r} > 1$$, we have that	
\begin{equation}
  \left[1 - \frac{1}{3}
                \left(1+\frac{1}{c}\right)^{r} \right]\left(\frac{c}{r}\right)^{r} <   \left[1 - \frac{1}{3}
                 \right]\left(\frac{c}{r}\right)^{r}, 
\end{equation}
        and thus our claim is implied by
\begin{equation}
         \sum_{r=1}^c \left(\frac{3c}{r}\right)^{r} < \frac{3^{c+1}}{2}.
\end{equation}
Let us prove that this is the case by induction on $$c$$. For $$c=1$$ it is equivalent to $$3 < \frac{9}{2}$$, which obviously holds. For the general case consider that
$$\begin{align}
         \sum_{r=1}^{c+1} \left(\frac{3(c+1)}{r}\right)^{r} &= \left(\sum_{r=1}^{c} \left(\frac{3(c+1)}{r}\right)^{r}\right) + 3^{c+1}\\
         &= \left(\sum_{r=1}^{c} \left(\frac{3c}{r}\right)^{r} \left(\frac{c+1}{c}\right)^r\right) + 3^{c+1}\\
         &\leq \left(\sum_{r=1}^{c} \left(\frac{3c}{r}\right)^{r}e \right) + 3^{c+1}\\ % \tag{Using that $(1+1/c)^r \leq (1+1/c)^c \leq e$}\\
         &\leq e \cdot \frac{3^{c+1}}{2} + 3^{c+1}\\ %\tag{Inductive hypothesis}\\
         &= 3^{c+1} \left(\frac{e}{2} + 1 \right)\\
         &\leq 3^{c+2}. 		
\end{align}$$

Now let us study the ratio $$f(c+1)/f(c)$$. We have that
$$\begin{align}
        \frac{f(c+1)}{f(c)} &= \frac{\sum_{r = 1}^{c+1} \left(\frac{c+1}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c+1-r}}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}\\
        &= \frac{1}{3} \cdot  \frac{\sum_{r = 1}^{c+1} \left(\frac{c+1}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}\\
        &= \frac{1}{3} \cdot  \frac{\left(\sum_{r = 1}^{c} \left(\frac{c+1}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}\right) + 3}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}\\
        &= \frac{1}{3} \cdot  \frac{\left(\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \left(\frac{c+1}{c}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}\right) + 3}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}.
\end{align}$$

Now, using that $$(1+\frac{1}{c})^r \leq (1+\frac{1}{c})^c  \leq e$$ for every positive integer $$c$$, we have that
$$\begin{align}
        \frac{f(c+1)}{f(c)} &\leq \frac{1}{3} \cdot  \frac{e\left(\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}\right) + 3}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}\\
        &\leq \frac{e}{3} + \frac{1}{\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r}}.
\end{align}$$


Now assume, expecting a contradiction, that there is some positive integer $$C$$ such that $$f(C) > 11$$. This would imply that
\begin{equation}
\frac{f(C+1)}{f(C)} \leq \frac{e}{3} + \frac{1}{11} < 0.907 + 0.091 = 0.998 < 1,
\end{equation}
meaning that $$f(C+1) < f(C)$$, which contradicts Claim 1. Therefore, $$f(c) \leq 11$$ for every integer $$c$$, and thus we have our desired inequality:
\begin{equation}
\sum_{r = 1}^c \frac{c^r r^c}{r^{2r}} n^r \leq n^{c} \cdot\sum_{r = 1}^{c} \left(\frac{c}{r}\right)^{r} \cdot \left(\frac{1}{3}\right)^{c-r} = n^c \cdot f(c) \leq 11 n^c.
\end{equation} 

