@def title = "Universal hash functions"
@def published = "15 August 2024"
@def tags = ["probabilistic-data-structures", "julia"]

### Universal hash functions
The definition of *universal hash function* is as follows:

@@graybox
A family of hash functions $\mathcal H=\{h:U\rightarrow V\}$ is called __*universal*__ if for for any two distinct element $x,y\in U$, the probability that a randomly chosen hash function $h\in\mathcal H$ that maps $x$ and $y$ to the same value is at most $\frac{1}{|V|}$. Formally, $\mathcal H$ is universal if:
 $$\underset{h\in \mathcal H}{\mathbb P}\left[h(x)=h(y)\right]\leq \frac{1}{|V|}$$
for all $x\neq y$. Here, the probability is taken over the uniform distribution of $h$ from $\mathcal H$.
@@


We focus on the set $V=\{0,1,\dots,M-1\}$ as a set of integers. Constructing a universal hash function from a family of such functions is straightforward. Here's a way to do it:
* Fix a prime number $M$ 
* Assume that the keys in the universe can be encoded as vectors of positive integers $(x_1,x_2,\dots,x_k)$
* Uniformly choose numbers $r_1,r_2,\dots,r_k$ from the set $\{0,1,\dots,M-1\}$
* Define the hash function as 
    $$h(x) = (r_1x_1+\cdots+r_kx_k)\,\,\text{mod}\,\,M$$
Done! We've now constructed a universal hash function $h$ with a collsion probability $1/M$. You can find a proof of this, e.g. in this lecture [here](https://www.cs.cmu.edu/~avrim/451f11/lectures/lect1004.pdf) by Arvim Blum).

In some cases, the prime number $M$ might be inconvenient to work with, especially if we want to restrict the range of the output to $\{0,\dots,N-1\}$, where $N < M$. To address this, we modify the hash function as follows:

$$h(x) = (r_1x_1+\cdots+r_kx_k)\,\,\text{mod}\,\,M \,\, \text{mod}\,\, N$$

Now the collision probability increases from $1/M$ to  $1/N$. This happens because the reduction from $\{0,\dots,M-1\}$ to $\{0,\dots,N-1\}$ causes each value in $\{0,\dots,N-1\}$ to correspond to $\lfloor \frac{M}{N} \rfloor + 1$ values from the original range $\{0,\dots,M-1\}$.

Here's a simple Julia code to construct universal hash function $h$:

@@graybox
```
using Primes
# K: dimension for the items in the universe
# M: A sufficiently large prime number
# N: the output dimension when N > 1
function create_universal_hash(K::Int, M::Int; N = 1)
    @assert isprime(M) "M must be a prime number"
    r = [rand(0:M-1) for _ = 1:K]
    h(x) = (sum(r .* x) % M) % N
    return h
end
```
@@