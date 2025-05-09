---
layout: post
title: Subquadratic encodings for my favorite graph problems
date: 2025-05-09 11:12:00-0400
description: An observation allowing to encode several graph problems in $$o(|E|)$$ clauses.
tags: math
categories: Math
comments: true
---

When reducing graph problems (e.g., vertex-cover, clique, independent-set, $$k$$-coloring) to SAT, standard encodings use $$\Omega(n^2)$$ binary clauses in dense graphs. This brief note shows how a trivial combination of existing ideas yields encodings that use $$\mathcal{O}(n^2 / \lg n)$$ many clauses.

Let us first consider the independent set problem, since vertex-cover, clique, and many variants of graph coloring are essentially equivalent in terms of their logical structure. The input is a graph $$G = (V, E)$$, together with an integer $$k$$, and the goal is to find a set of _selected_ vertices $$S \subseteq V$$ such that $$\binom{S}{2} \cap E = \varnothing$$ and $$|S| = k$$. The standard encoding is thus to create, for each vertex $$v \in V$$, a variable $$s_v$$ representing whether $$v \in S$$. Then, the constraints are simply:
\begin{equation}
    (\overline{s_{u}} \lor \overline{s_{v}}),  \forall \{u, v\} \in E,
\end{equation}
stating the independence property, and then the cardinality constraint
$$
    \sum_{v \in V} s_v = k.
$$
While cardinality constraints are known to admit compact encodings with $$\mathcal{O}(n \lg ^2 n)$$ clauses [[1]](https://www.cs.upc.edu/~oliveras/constraints.pdf), I could not find any references to an encoding of Equation 1 with $$o(n^2)$$ many clauses. As I show next, all the required ideas are already present in the literature.

**Independent Set in a Biclique.** If $$G$$ happens to be a biclique $$K_{a, b}$$, then it is trivial to encode the independence property efficiently. Let $$A$$ and $$B$$ be the parts of $$K_{a, b}$$. Then, introduce auxiliary variables $$s_A$$ and $$s_B$$, which intuitively represent whether some vertex of $$A$$ (resp. $$B$$) belongs to $$S$$. This is enforced by clauses $$(\overline{s_v} \lor s_A)$$ for every $$v \in A$$, as well as a long clause $$(\overline{s_A} \lor \bigvee_{v \in A} s_v)$$, and analogous clauses for $$B$$ are added as well. Finally, the clause $$(\overline{s_A} \lor \overline{s_B})$$ enforces the independent set property. We have used
 $$\mathcal{O}(a + b) = \mathcal{O}(|V(K_{a, b})|)$$
  many clauses, instead of the $$a \cdot b$$ used by Equation 1. Moreover, equivalence can be seen directly by resolving over $$s_A$$ and $$s_B$$.

**Biclique Coverings.** Suppose now $$G$$ is an arbitrary graph again, but we have a set of bicliques $$B_1, \ldots, B_r$$, with $$V(B_i) \subseteq V(G)$$ for each $$1 \leq i \leq r$$, and such that $$\bigcup_{i=1}^r E(B_i) = E(G)$$. Such a set of bicliques is said to be a _``biclique covering''_ of $$G$$. Then, for any set $$S \subseteq V(G)$$, we trivially have that $$S$$ is an independent set of $$G$$ if and only if $$S \cap V(B_i)$$ is an independent set of $$B_i$$ for every $$1 \leq i \leq r$$. Now, applying the method of the previous paragraph for each $$B_i$$ yields an encoding using $$\mathcal{O}(\sum_{i=1}^r |V(B_i)|)$$ many clauses. Fortunately, [a classic result of Chung, Erdős, and Spencer](https://users.renyi.hu/~p_erdos/1983-20.pdf) says that for any $G$ there is a biclique covering such that
 $$
 \sum_{i=1}^r |V(B_i)| \in \mathcal{O}(|V(G)|^2 / \lg (|V(G)|)).
 $$
 Furthermore, Mubayi and Turán proved that such a covering can be computed in polynomial time [[3]](https://arxiv.org/pdf/0905.2527), which allows therefore to construct the succinct encoding from an input graph in polynomial time. Naturally, without this runtime restriction the result of this note would be trivial, since one could first solve the independent set instance and then build a constant-size formula according to the answer.
 