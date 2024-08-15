@def title = "Universal hash functions (practical)"
@def published = "15 August 2024"
@def tags = ["probabilistic-data-structure", "julia"]

### Universal hash functions
The definition of universal hash function is as follows:

---
A family of hash functions $\mathcal H$ mapping to a set of keys $U$ to a range of integers $\{0,1,\dots,M-1\}$ is called *universal* if any two distinct keys $x,y\in U$ the probability that a randomly chosen hash function $h$ from $\mathcal H$ maps $x$ and $y$ to the same value is at most $\frac{1}{M}$: $$\underset{h\in \mathcal H}{\mathbb P}\left[h(x)=h(y)\right]\leq \frac{1}{M}$$
---

Ok, how to construct one from such a family? It's actually pretty straight-forward (see proof [here](https://www.cs.cmu.edu/~avrim/451f11/lectures/lect1004.pdf) by Arvim Blum). We just need to:
* Fix a prime number $M$ 
* Suppose that the keys in the universe can be encoded as a vector of integers as $(x_1,x_2,\dots,x_k)$
* Uniformly choose numbers $r_1,r_2,\dots,r_k$ from $\{0,1,\dots,M-1\}$
and define 
$$h(x) = (r_1x_1+\cdots+r_kx_k)\,\,\text{mod}\,\,M$$
Done. We now have a universal hash function $h$ that has a collsion probability $1/M$.

Sometimes, the prime number $M$ is inconvenient to work with as we want to restrict the range of the output to $\{0,\dots,N-1\}$, where $N < M$. What we can do is to simply modify the hash function to be

$$h(x) = (r_1x_1+\cdots+r_kx_k)\,\,\text{mod}\,\,M \,\, \text{mod}\,\, N$$

Now the collision probability goes up from $1/M$ to  $1/N$. Loosely speaking, this is because since $M>N$, the value $h(x)\,\,\text{mod}\,\,N$ reduces the ouput space in a way that $\{0,\dots,N-1\}$ correspond to $\lfloor \frac{M}{N} \rfloor + 1$ values from the original range $\{0,\dots,M-1\}$.

A simple julia code to construct universal hash function $h$:

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