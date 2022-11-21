@def title = "Convolutions"
@def published = "5 November 2022"
@def tags = ["linear-algebra"]

### Convolutions

The textbook definition of (linear) convolution is as follows: a convolution of two vectors $\fbm\in\R^n$ and $\xbm\in\R^m$ is a vector $\fbm * \xbm\in\R^{n+m-1}$, where
$$(\fbm * \xbm)[k] = \sum_{i+j=k+1}f[i] x[j],$$
i.e., the $k$-th entry of the vector $\fbm * \xbm$ is the sum of all product $\fbm[i]\xbm[j]$ such that the indices $i,j$ satisfy the condition $i+j=k+1$. 

This definition doesn't show convolution is related to applcations (it's more useful for proof exercises). Ok, what is an intuitive way to think about convolution?

Note that convolution is a linear operation, for which we can write it down as a matrix-vector multiplication. To make things concrete, suppose $\fbm=(f_1,f_2,f_3)^\top$ and $\xbm=(x_1,x_2,x_3,x_4)^\top$, then we can write
$$\fbm * \xbm = \begin{pmatrix} f_1 & 0   & 0   & 0   \\ 
                                f_2 & f_1 & 0   & 0   \\
                                f_3 & f_2 & f_1 & 0   \\
                                0   & f_3 & f_2 & f_1 \\
                                0   & 0   & f_3 & f_2 \\
                                0   & 0   & 0   & f_3
\end{pmatrix}\begin{pmatrix}x_1 \\ x_2 \\ x_3 \\ x_4 \end{pmatrix},$$ which is the same as what's going on in equation (1).

What's interesting from this perspective is when the vector $\xbm$ is *sparse*, i.e. $\xbm$ has mostly zero entries. Let's say $\xbm=(0,1,0,0)^\top$. Substitute this to the above, we have that
$$\fbm * \xbm = \begin{pmatrix} f_1 & 0   & 0   & 0   \\ 
                                f_2 & f_1 & 0   & 0   \\
                                f_3 & f_2 & f_1 & 0   \\
                                0   & f_3 & f_2 & f_1 \\
                                0   & 0   & f_3 & f_2 \\
                                0   & 0   & 0   & f_3
\end{pmatrix}\begin{pmatrix}0 \\ 1 \\ 0 \\ 0 \end{pmatrix}=\begin{pmatrix} 0 \\ f_1 \\ f_2 \\ f_3 \\ 0 \\ 0 \end{pmatrix}$$
What does this say? If we think about that $\fbm * \xbm$ as some kind of signal, then this is saying that $\fbm$ as a "feature" is presented in the span from the 2nd to the 4th entries.

We can leverage this intuition to think about applications related to bioinformatics. If the signal is a DNA string, and the feature represents a motif, e.g., it could be a k-mer, or a position frequency matrix, etc., then we have something meaningful: the sparse vector $\xbm$ indicates where the motif $\fbm$ is presented in the DNA string. Moreover, the non-zero entry in $\xbm$ doesn't need to be $1$. It could be an arbitrary value signifying the "strength" of the presense of $\fbm$ in the DNA string. 

Of course, the description above is just a simple analogy. To develop this idea further, we look at a classic problem in signal processing: [convolutional dictionary learning](../cdl).

