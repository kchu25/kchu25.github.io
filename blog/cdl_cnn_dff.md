@def title = "Convolutional Dictionary Learning vs. Convolutional Neural Network in one picture"
@def published = "5 January 2023"
@def tags = ["representation-learning", "machine-learning"]

### Understand convolutional dictionary learning vs convolutional neural network in one picture

In the [talk](https://www.youtube.com/watch?v=lQzzhePX7X0) (at 21:57) given by [Brendt Wholberg](https://brendt.wohlberg.net/), the following slide illustrate the difference between a convolutional dictionary learning model (CDL) and a convolutional neural network (CNN).

![](/blog/pics/wholberg_talk_cnn_vs_cdl2.png)
> Slide from Brendt Wholberg's [talk](https://www.youtube.com/watch?v=lQzzhePX7X0) on Convolutional Sparse Representations for Imaging Inverse Problems at NC state ECE 2018.

Of course, the symbol $*$ is the convolution operator. Here, the [deconvolutional network](https://ieeexplore.ieee.org/abstract/document/5539957) is equivalent to the tranlational invariant (sparse) representation. In another word, the deconvolutional network is a [CDL](../cdl).

In CNN, the filters are convolved with the input signal (image) to generate a feature representation.

In CDL, the filters are convolved with the code vectors to represent the input signal.

#### References

{{show_refs zeiler2010deconvolutional garcia2018convolutional }}