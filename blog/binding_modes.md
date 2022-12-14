@def title = "Proteins with complex binding modes"
@def published = "2 December 2022"
@def tags = ["comp-bio", "motif-discovery"]


### Proteins with complex binding modes

#### Simplified single motif discovery problem

In the *motif discovery problem*, an example dataset will look exactly like this:

@@img-small3 ![Unaligned](/blog/pics/motif/unaligned_noans.png) @@

i.e., a dataset whose entries are all DNA strings. 

This dataset usually is obtained from a sequencing experiment, e.g., Chip-Seq. 

In addition, this dataset is associated with a protein. This protein tends to bind to a set of similar DNA substrings embedded in those DNA strings, and we need to find out where those substrings occurred.

Suppose we have a *good* problem formulation along with a *good* algorithm to find this set of similar strings, i.e., the set of purple substrings in the dataset:

@@img-small3 ![Unaligned](/blog/pics/motif/unaligned.png) @@

We can then turn them into a multiple sequence alignment (MSA):

@@img-tiny ![Unaligned](/blog/pics/motif/aligned.png) @@

This MSA, in turn, can be made into a *position weight matrix* (PWM) $\Pbm$. 

We estimate the position weight matrix $\Pbm$ by first using the empirical frequency $\fbm_{\alpha i}$ of each nucleotide $\alpha$ at each position $i$ from the MSA. This step is equivalent to doing a maximum likelihood estimate of the parameters of a product multinomial distribution. Then, we fill each $(\alpha, i)$-entry of the PWM $\Pbm$ by $\Pbm_{\alpha i} = \log_2 (\fbm_{\alpha i} / \bbm_\alpha)$, where $\bbm_\alpha$ is the assumed genomic background frequency for nucleotide $\alpha$.

We can visualize the PWM $\Pbm$ in the following picture:


@@img-small2 ![Unaligned](/blog/pics/motif/pwm.png) @@

where the height of the nucleotide at each column shows how conserved each nucleotide is at each position. The higher the nucleotide, the more conserved; each $i$-th column's height is given by the so-called information content formula, i.e., $\sum_\alpha \fbm_{\alpha i} \log_2 (\fbm_{\alpha i} / \bbm_\alpha)$.


However, the motif discovery problem turns out to be more complicated -- if you care about *how* proteins bind to DNA. 

#### Complex binding modes

Here we list out qualitative characteriztions of several binding modes and their illustrations from [Siggers and Gordan](https://academic.oup.com/nar/article/42/4/2099/2435233). 

One of the complex ways a protein can bind to DNA is *variable spacing*:

![vs](/blog/pics/motif/v-spacing.png)

In variable spacing, the binding sites come in *parts*. It's common in biology to say that a spacer separates the parts when a protein binds to the DNA.

Another situation we can have is *multiple DNA binding domains* (DBDs):

![vs](/blog/pics/motif/mdbds.png)

In multiple DBDs, a protein may have distinct binding sites. 

We can also have a situation called *multimeric binding*:

![vs](/blog/pics/motif/multimeric-b.png)

In multimeric binding, again the protein has more than one binding site. However, one binding site is an "extended" version of another, i.e., the binding sites overlaps.

Last, we have *alternate structural conformations*:

![vs](/blog/pics/motif/asc.png)

Altogether, these "situations", i.e., the binding modes such as variable spacing, multiple DBDs, multimeric binding, and alternate structural conformations make motif discovery much more complicated than the simplified version of the problem above. 

Further, for a protein, these binding modes may not be mutually exclusive of each other. For example, we may have a protein with binding modes that include multimeric binding as well as variable spacing.

Detecting motifs with the above binding modes is a challenging computational problem. We will show our approach to detect such binding patterns in the next few blog posts.

#### References

{{show_refs siggers2014protein }}