@def title = "What can you do with a Position Weight Matrix?"
@def published = "19 August 2025"
@def tags = ["computational-biology"]

A position weight matrix, or commonly called "the motifs" or "*the logo*" is the often the default characterization for protein binding sites in comp bio.

It is defined as 

i.e. its paramters can be completely characterized by product multinomial distributions.

But what do you use it for? This is a question I think about -- after all, why even bother characterize it if we do not intend to use it?

One nice thing about it is that we can visualize it. E.g. the database JASPAR gives you a catalog of logos of transcription factor binding sites.
The height of each letter in the logo reflects how conserved that nucleotide is at that position of the binding site.


Is that it? Ah, the traditional use of PWMs is to use them to scan a long DNA or an RNA sequence, to identify the putative motifs. 
This can be done efficiently via methods like MOODS. The sequence can be long, e.g. entire genome, and it's impressive that MOODS can work easily in such setting.


Ok, we now have visualization can do scannings. That... to be honest, doesn't sound super powerful. We identified the sites. So what?
At least in the age of AI, people have more expectations; they want magical things. 


I'd argue the view that viewing the PWMs as an end of themselves isn't appropriate. 
Its role is "meta", and has always been that since its inception.

If we think about the regulation happening in the cells, then binding sites (or PWMs) are words, and visualizing and searching for words in a sentence isn't that meaningful 
if we don't know what the sentence mean.









