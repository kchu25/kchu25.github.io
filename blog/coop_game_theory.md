@def title = "A primer on cooperative game theory and power indices"
@def published = "14 June 2026"
@def tags = ["game-theory", "machine-learning"]

\newcommand{\Pcal}{\mathcal P}
\newcommand{\Scal}{\mathcal S}
\newcommand{\Tcal}{\mathcal T}
\newcommand{\Ncal}{\mathcal N}
\newcommand{\Mcal}{\mathcal M}

## A primer on cooperative game theory and power indices

Cooperative game theory studies what happens when players form coalitions and produce value together, and asks how that value should be attributed back to the individual players. This is a plain reference for the standard definitions: cooperative games, the Shapley value and its axioms, the Banzhaf index, and the weighted-marginal-contribution form that contains both as special cases. Nothing here is new; for a full treatment see Maschler et al. (2013).

### Cooperative games

@@graybox
A *cooperative game* is a pair $(\Ncal, v)$, where $\Ncal = \{1, \dots, n\}$ is a finite set of *players* and
$$v : 2^{\Ncal} \rightarrow \R, \qquad v(\emptyset) = 0$$
is a *characteristic function* (or *payoff function*) that assigns a real value to every *coalition* $\Scal \subseteq \Ncal$. The full set $\Ncal$ is the *grand coalition*.
@@

The value $v(\Scal)$ is the payoff the players in $\Scal$ can secure by cooperating among themselves. A few standard restrictions on $v$:

* *Monotone*: $v(\Scal) \leq v(\Tcal)$ whenever $\Scal \subseteq \Tcal$.
* *Superadditive*: $v(\Scal \cup \Tcal) \geq v(\Scal) + v(\Tcal)$ whenever $\Scal \cap \Tcal = \emptyset$.
* *Simple*: $v$ is monotone and takes values in $\{0, 1\}$ with $v(\Ncal) = 1$. These model voting; a coalition with $v(\Scal) = 1$ is *winning*.

### Marginal contributions

@@graybox
The *marginal contribution* of player $i$ to a coalition $\Scal \subseteq \Ncal \setminus \{i\}$ is
$$\Mcal_i(\Scal) = v(\Scal \cup \{i\}) - v(\Scal).$$
@@

Every index below is a weighted average of marginal contributions; the indices differ only in the weights.

### The Shapley value

@@graybox
The *Shapley value* of player $i$ in the game $(\Ncal, v)$ is
$$\phi_i(v) = \sum_{\Scal \subseteq \Ncal \setminus \{i\}} \frac{|\Scal|! \, (n - |\Scal| - 1)!}{n!} \, \Mcal_i(\Scal).$$
@@

Equivalently, averaging marginal contributions over all $n!$ orderings of the players,
$$\phi_i(v) = \frac{1}{n!} \sum_{\pi} \Mcal_i\big(P_i^{\pi}\big),$$
where the sum runs over all permutations $\pi$ of $\Ncal$ and $P_i^{\pi}$ is the set of players preceding $i$ in $\pi$. The intuition is the random-arrival picture: the players show up one at a time in a random order, each is credited with what it adds to those already present, and the Shapley value is a player's expected credit under a uniformly random order. The two forms are equal because exactly $|\Scal|! \, (n - |\Scal| - 1)!$ orderings place the set $\Scal$ before $i$ and the rest after.

The Shapley value is characterized by four axioms (Shapley, 1953). State $\phi$ as a map from games to payoff vectors in $\R^n$.

* **Efficiency.** $\sum_{i \in \Ncal} \phi_i(v) = v(\Ncal)$. The whole value of the grand coalition is divided among the players, with nothing left over.
* **Null player.** If $\Mcal_i(\Scal) = 0$ for all $\Scal \subseteq \Ncal \setminus \{i\}$, then $\phi_i(v) = 0$.
* **Symmetry.** If $\Mcal_i(\Scal) = \Mcal_j(\Scal)$ for all $\Scal \subseteq \Ncal \setminus \{i, j\}$, then $\phi_i(v) = \phi_j(v)$.
* **Additivity.** $\phi_i(v + w) = \phi_i(v) + \phi_i(w)$, where $(v + w)(\Scal) = v(\Scal) + w(\Scal)$.

@@graybox
**Theorem (Shapley, 1953).** The Shapley value is the unique map $\phi$ satisfying efficiency, the null-player property, symmetry, and additivity.
@@

An alternative characterization replaces additivity with *marginality*: a player's payoff depends only on its own marginal contributions.

@@graybox
**Theorem (Young, 1985).** The Shapley value is the unique map satisfying efficiency, symmetry, and marginality.
@@

### Simple games and the Banzhaf index

In a simple game, $\Mcal_i(\Scal) \in \{0, 1\}$, and $\Mcal_i(\Scal) = 1$ exactly when $i$ is a *swing* (or *pivotal*) player for $\Scal$: the coalition $\Scal$ loses but $\Scal \cup \{i\}$ wins.

@@graybox
The (absolute) *Banzhaf index* of player $i$ is
$$\beta_i(v) = \frac{1}{2^{\,n-1}} \sum_{\Scal \subseteq \Ncal \setminus \{i\}} \Mcal_i(\Scal),$$
i.e. the fraction of coalitions for which $i$ is a swing player. The *normalized* Banzhaf index divides by $\sum_{j} \beta_j(v)$ so the values sum to one.
@@

Where the Shapley value averages over arrival orders, the Banzhaf index (Banzhaf, 1965) ignores order entirely and simply asks how often a player turns a losing coalition into a winning one. Applying the Shapley value to a simple game gives the *Shapley-Shubik index*. Both measure voting power, and they generally disagree because they weight coalitions differently.

The Banzhaf index satisfies the null-player, symmetry, and additivity axioms but **not** efficiency.

### Power indices as weighted marginal contributions

Both indices have the form
$$\rho_i(v) = \sum_{\Scal \subseteq \Ncal \setminus \{i\}} \omega(|\Scal|) \, \Mcal_i(\Scal),$$
differing only in the weight $\omega$:

* Shapley: $\;\omega(s) = \dfrac{s! \, (n - s - 1)!}{n!}$,
* Banzhaf: $\;\omega(s) = \dfrac{1}{2^{\,n-1}}$.

This common form is the class of *semivalues* (Weber, 1988).

@@graybox
A *semivalue* is any map $\rho_i(v) = \sum_{\Scal \subseteq \Ncal \setminus \{i\}} p_{|\Scal|} \, \Mcal_i(\Scal)$ whose weights $p_s \geq 0$ satisfy
$$\sum_{s=0}^{n-1} \binom{n-1}{s} \, p_s = 1.$$
@@

The Shapley value is the unique efficient semivalue; the Banzhaf index is the semivalue with constant weights.

### Values for groups of players

To score a coalition $\Tcal \subseteq \Ncal$ rather than a single player, treat $\Tcal$ as one composite player and apply the same machinery. The general weighted form becomes
$$\rho(\Tcal) = \sum_{\Scal \subseteq \Ncal \setminus \Tcal} \omega(\Scal) \, \big(v(\Scal \cup \Tcal) - v(\Scal)\big),$$
with the Shapley weight generalizing to $\omega(\Scal) = \frac{|\Scal|! \, |\Tcal|! \, (n - |\Scal| - |\Tcal|)!}{n!}$. Values tailored to group structure also exist, but the composite-player view covers the common case.

### Computation

The exact formulas sum over $2^{\,n-1}$ subsets, so direct evaluation is exponential in $n$. For weighted voting games, computing the Banzhaf and Shapley-Shubik indices is #P-hard / NP-hard (Deng and Papadimitriou, 1994), though dynamic programming over integer weights gives a pseudo-polynomial algorithm. In general, the permutation form is estimated by Monte Carlo sampling over orderings (Castro et al., 2009).

### References

{{show_refs shapley1953value young1985monotonic banzhaf1965weighted weber1988probabilistic deng1994complexity castro2009polynomial maschler2013game}}
