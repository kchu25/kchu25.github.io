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

Suppose we have a suitable problem formulation along with an algorithm to find this set of similar strings, i.e., the set of purple substrings in the dataset:

@@img-small3 ![Unaligned](/blog/pics/motif/unaligned.png) @@

We can then turn them into a multiple sequence alignment (MSA):

@@img-tiny ![Unaligned](/blog/pics/motif/aligned.png) @@

This MSA, in turn, can be made into a *position weight matrix* (PWM) $\Pbm$. 

We estimate the position weight matrix $\Pbm$ using the empirical frequency $\fbm_{\alpha i}$ of each nucleotide $\alpha$ at each position $i$ from the MSA. Each entry of the PWM $\Pbm$ is $\Pbm_{\alpha i} = \log_2 (\fbm_{\alpha i} / \bbm_\alpha)$, where $\bbm_\alpha$ is the assumed genomic background frequency for nucleotide $\alpha$. 

We can visualize the PWM $\Pbm$ in the following picture:


@@img-small2 ![Unaligned](/blog/pics/motif/pwm.png) @@

where the height of the nucleotide at each column shows how conserved each nucleotide is at each position. The higher the nucleotide, the more conserved; each $i$-th column's height is given by the so-called information content formula, i.e., $\sum_\alpha \fbm_{\alpha i} \log_2 (\fbm_{\alpha i} / \bbm_\alpha)$.


However, the motif discovery problem turns out to be more complicated -- if you care about *how* proteins bind to DNA. 

#### Complex binding modes

Here we list out qualitative characteriztions of several binding modes and their illustrations from [Siggers and Gordan](https://academic.oup.com/nar/article/42/4/2099/2435233). 

One of the first complex ways a protein can bind to DNA is *variable spacing*:

![vs](/blog/pics/motif/v-spacing.png)

In variable spacing, the binding sites come in *parts*. It's common in biology to say that a spacer may separate the parts when a protein binds to the DNA.

Another situation we can have is *multiple DNA binding domains* (DBDs):

![vs](/blog/pics/motif/mdbds.png)

As shown above, in multiple DBDs, a protein may have very different binding sites. 

We can also have a binding mode called *multimeric binding*:

![vs](/blog/pics/motif/multimeric-b.png)

In multimeric binding, again the protein has more than one binding site. However, one binding site is an "extended" version of another, i.e., the binding sites overlaps.

Last, we have *alternate structural conformations*:

![vs](/blog/pics/motif/asc.png)

The alternate structural conformations is similar to multimeric binding; however, we don't have the "extensions."

Altogether, the binding modes such as variable spacing, multiple DBDs, multimeric binding, and alternate structural conformations make motif discovery more complicated than the simplified version of the problem above.

Note that for a protein, these binding modes may not be mutually exclusive of each other. For example, we may have multimeric binding as well as variable spacing.


#### References

{{show_refs siggers2014protein }}