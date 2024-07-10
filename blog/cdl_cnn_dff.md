@def title = "Convolutional Dictionary Learning vs. Convolutional Neural Network in one picture"
@def published = "5 January 2023"
@def tags = ["representation-learning", "machine-learning"]

### Understand convolutional dictionary learning vs convolutional neural network in one picture

In his [talk](https://www.youtube.com/watch?v=lQzzhePX7X0) (at 21:57), [Brendt Wholberg](https://brendt.wohlberg.net/) illustrates the distinction between Convolutional Dictionary Learning (CDL) and Convolutional Neural Networks (CNNs) with the following slide:

![](/blog/pics/wholberg_talk_cnn_vs_cdl2.png)
> Slide from Brendt Wholberg's [talk](https://www.youtube.com/watch?v=lQzzhePX7X0) on Convolutional Sparse Representations for Imaging Inverse Problems at NC state ECE 2018.

In [CDL](../cdl), the filters are convolved with code vectors to represent the input signal, akin to a  [deconvolutional network](https://ieeexplore.ieee.org/abstract/document/5539957) that provides a translation-invariant sparse representation.

On the other hand, in CNNs, filters are convolved with the input signal (such as an image) to generate a feature representation.

#### References

{{show_refs zeiler2010deconvolutional garcia2018convolutional }}