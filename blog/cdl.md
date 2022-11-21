@def title = "Convolutional dictionary learning"
@def published = "19 November 2022"
@def tags = ["comp-bio", "representation-learning"]

### Convolutional dictionary learning

So we saw [convolutions](../conv). Given a filter $\dbm$ and a sparse code $\xbm$, an important insight we saw from the convolution is that the sparse code plays the role of an "indicator", indicating where and how much the filter $\dbm$ should appear in the convolution $\dbm * \xbm$.

Let's leverage this intuition a bit further. What if we have a signal $\sbm$, and that we try to "approximate" $\sbm$ using a sum of convolutions, i.e.,
$$\dbm_1 * \xbm_1 + \dbm_2 * \xbm_2 + \cdots + \dbm_M * \xbm_M \approx \sbm$$

for which we can visualize as 

![Sum of convolutions](/blog/pics/conv.png)

where the orange vector on the right is the signal $\sbm$. Let's formalize this as an optimization problem (single signal case):
$$ \begin{align*}
    \argmin_{\{ \dbm_m:\,\|\dbm_m\|_2=1\},\, \,\{\xbm_m\}}\,\,\, \frac{1}{2} \left\| \sum_m \dbm_m * \xbm_m - \sbm \right\|^2_2 + \lambda\sum_{m}\|\xbm_m\|_1
    \end{align*}
$$
i.e., we want to find the best filters $\{\dbm_m\}$ and the sparse code $\{\xbm_m\}$ to represent the signal $\sbm$. The hyperparameter $\lambda$ balances the trade-off between data fitting loss and the sparsity of $\{\xbm_m\}$, and we enforce the constraint $\|\dbm_m\|_2=1$ to avoid the scaling ambiguity in between the filters and the sparse code. We can easily extend this to the case where we have multiple signals:
$$ \begin{align*}
    \argmin_{\{ \dbm_m:\,\|\dbm_m\|_2=1\},\, \,\{\xbm_{mn}\}}\,\,\, \frac{1}{2} \sum_n\left\| \sum_m \dbm_m * \xbm_{mn} - \sbm_n \right\|^2_2 + \lambda\sum_{n,m}\|\xbm_{mn}\|_1
    \end{align*}
$$

The problem formulation of (2) and (3) is called a *convolutional dictionary learning* (CDL) problem. So what's the advantage of formulating the problem as a CDL?
* CDL is highly interpretable:
    > In CDL, each signal is approximated by a sparse linear combination of the filters and the sparse code. The sparse code indicates where and how much the filters should appear.
* Minimizing the CDL objective $\Rightarrow$ we obtain specialized filters representing the frequently occurring patterns in the signals.

Equation (1) also shows that CDL is a [distributed representation](../dist_rep). There's a particular name for this representation: it is a *sparse representation* — the model uses a sparse linear combination of the filters and the sparse code to describe each signal in the dataset.
