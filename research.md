@def title = "schu - Research"


## Computational methods

1. Finding Motifs using DNA Images Derived From Sparse Representations 

    [[Oxford Bioinformatics, 2023](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btad378/7192989?utm_source=advanceaccess&utm_campaign=bioinformatics&utm_medium=email)] [[Github](https://github.com/kchu25/MOTIFs.jl)]

We present a principled representation learning approach based on a hierarchical sparse representation for motif discovery. Our method effectively discovers gapped, long, or overlapping motifs that we show to commonly exist in next generation sequencing datasets, in addition to the short and enriched primary binding sites. Our model is fully interpretable, fast, and capable of capturing motifs in a large number of DNA strings. A key concept emerged from our approach – enumerating at the image level – effectively overcomes the k-mers paradigm, enabling modest computational resources for capturing the long and varied but conserved patterns, in addition to capturing the primary binding sites.

2. uCDL (Deep Unfolded Convolutional Dictionary Learning for motif discovery)

   [[Preprint](https://www.biorxiv.org/content/10.1101/2022.11.06.515322v3)] [[Github](https://github.com/kchu25/UnfoldCDL.jl)]
<!-- We present a principled representation learning approach based on convolutional dictionary learning (CDL) for motif discovery. We unroll an iterative algorithm that optimizes CDL as a forward pass in a neural network, resulting in a network that is fully interpretable, fast, and capable of finding motifs in large datasets. Simulated data show that our network is more sensitive and specific for discovering binding sites that exhibit complex binding patterns than popular motif discovery methods such as STREME and HOMER. Our network reveals statistically significant motifs and their diverse binding modes from the JASPAR database that are currently not reported. -->

