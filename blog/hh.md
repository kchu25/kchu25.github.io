@def title = "Tracking the frequently occurring elements with count-min sketch"
@def published = "18 August 2024"
@def tags = ["probabilistic-data-structures"]

# Tracking the frequently occurring elements with count-min sketch

### Motivations 
Imagine we need to process a data stream and track frequently occurring (or large) elements, often called *heavy hitters*. The items in the data stream are given as pairs $(i_t, s_t)$, where $t$ denotes the time point, $i_t$ is the item encoded in some form, and $s_t$ represents the size of $i_t$. In some cases, we may not have enough space to store all the items (such as in routers for networking; or k-mers in genomics, which require exponential space), so we need a smart way to store only the important or frequently occurring elements.


### Count-Min sketch
This is where a probabilistic data structure called the __*count-min sketch*__ comes into play. Briefly put, the count-min sketch consists of a count table $C$ whose entries allow us to approximate the counts of the most frequent items that pass through the data stream. Additionally, a count-min sketch consists of $K$ universal hash functions $h_1,\dots,h_K$, whose domain is the space of the items and whose range is the column indices of the table $C$. Note that universal hash functions can be constructed easily (e.g. see [Universal hash functions](../hash_fcn)).

To construct the count table $C$, we define it to have $K$ rows and $L$ columns, where each row in the table sometimes referred to as a *group*. Each entry $C[k,\ell]$ in the table $C$ is called a *counter*, where $1\leq k \leq K$ and $1\leq \ell \leq L$. Now, we will define 
$$\text{Count}(i,T)=\underset{\begin{aligned} &\,\,t :i_t=i, \\  &1\leq t \leq T \end{aligned}}{\sum} s_t$$
as the total count of item $i$ up to time $T$. Next, assume that 
* The data stream came in discrete time points $1,\dots,T$
* As each point $(i_t,s_t)$ came in, we compute the hash values $h_k(i_t)$ for $k=1,\dots,K$
* We increment the each entry $C[k,\,h_k(i_t)]$, for $k=1,\dots,K$ in the count table by $s_t$

We now have the following result:

@@graybox
Let an error tolerance parameter $\epsilon > 0$ be given and a $K\times L$ count table $C$ constructed as above. Fix $i$ as an item from the input space. Then, with probability $1-(\frac{1}{L\epsilon})^K$ over the choice of hash functions, for a sequence of items $(i_1,s_1),\dots,(i_T,s_T)$, we have that 
$$
\text{Count}(i,T) \leq  \underset{\begin{aligned} &\,\,\,\ell=h_k(i), \\\ &1\leq k\leq K \end{aligned}}{\text{min}} C[k, \ell] \,\,\,\leq \text{Count}(i,T) + \epsilon\sum_{t=1}^T s_t
$$
@@

This results states that, for a given item $i$, one of the K entries (i.e. $C[1,h_1(i)],\dots,C[K,h_K(i)]$) in the count table $C$  __*reasonably approximate its count in the data stream with high probability*__. Specifically, this entry is the one with the minimum count among different groups. This result is significant because the __*space complexity is now fixed*__ -- we only need the space to store the size of the count table, which is $\mathcal O(KL)$. Even though the count table entry (i.e. the minimum of the entries $C[k,h_k(i)]$ for $k=1,\dots,K$) may overestimate the real count $\text{Count}(i,T)$, this overestimation is bounded. In particular, each count estimate is bounded by $\epsilon\sum_{t=1}^T s_t$, which is a fraction of the total size of the items observed so far.

We also have the following result:
@@graybox
Suppose that we use a count-min sketch with $K=\lceil \ln\frac{1}{\delta}\rceil$ hash functions, $m=K \times\lceil \frac{e}{\epsilon}\rceil$ counters, and a threshold value $q$. Let $Q$ be the total size of the items in the input data stream. Then all the heavy hitters (whose count are more than $q$) are included on the list, and any item that corresponds to fewer than $q-\epsilon Q$ counts is put on the list with probability at most $\delta$.
@@

This results states that if we construct the count table $C$ in count-min sketch according to the specified $\delta$ and $\epsilon$, we are guaranteed that __*false positive (non-heavy hitter appear on the heavy hitter's list) occur only with a small probability*__.

 <!-- we require two parameters $\delta$ and $\epsilon$, which we will see how it relates to the gurantees of such approach shortly. Specifically, -->

#### References

{{show_refs randomalg }}