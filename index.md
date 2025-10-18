@def title = "schu - About"
@def tags = ["syntax", "code"]

@@clear @@
@@img-me-small ![Proguard](./me.jpg) @@

I am a post-doctoral research scientist at Columbia University, collaborating with [Chaolin Zhang](https://systemsbiology.columbia.edu/faculty/chaolin-zhang) and other wonderful members in the [Zhang Lab](https://zhanglab.c2b2.columbia.edu/). Previously, I earned my Ph.D. in computer science at Washington University in St. Louis under the mentorship of [Gary Stormo](https://en.wikipedia.org/wiki/Gary_Stormo). My current research focuses on deep learning interpretations, demonstrated through applications involving high-throughput functional genomics/proteomics screenings.


My path to deep learning interpretation was motivated by the fact that most deep learning applications in genomics and proteomics involve *sequence-to-label* problems, such as:
@@spacing @@
~~~
<figure style="float: right; margin-right: 10px; width: 317px;">
  <img src="./seq2label.png" alt="Sequence to label" style="width: 100%;">
  <figcaption style="font-style: italic; color: gray; text-align: center; margin-top: 10px;">Which patterns matter?</figcaption>
</figure>
~~~

@@small-list
- Predicting mutation effects on biological functions
- Locating genetic switches and control regions
- Mapping protein-DNA/RNA binding sites
- Other genomic tasks (splicing, gene expression)
@@

@@spacing @@

The fundamental question underlying these problems is: which *patterns* drive the outcome? My [doctoral work](https://openscholarship.wustl.edu/cgi/viewcontent.cgi?article=2066&context=eng_etds) tackled exactly this challenge: developing methods to uncover patterns from deep learning models and quantify the rules that govern them. My subsequent work has revealed broader interpretability principles for scientific data, particularly when the learned features in deep learning models are neither edge detectors nor word embeddings.

---

My name in Mandarin is Kuei-Hsien Chu (朱桂賢). Hsien pronounced like Shane, and that's how I got Shane. I grew up in Taiwan and have lived in the US since 2008.

<!-- 
For example, in regulatory genomics, we want to infer the following:

- The DNA sequences' regulatory elements, e.g., the motifs.
- The key regulatory elements in the DNA sequences give rise to the observed phenomenon.
- The counterfactuals, e.g., a minimal change to a DNA sequence that turns off the observed effects. -->
<!-- 
We can obtain a sparse representation of DNA sequences using principled deep learning techniques, e.g., deep unfolding. We use [sparse representations to reveal many more hidden motifs not shown on the JASPAR database](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btad378/7192989?utm_source=advanceaccess&utm_campaign=bioinformatics&utm_medium=email). Our result shows that sparse representation is a scalable and interpretable approach to biological sequence problems. -->


