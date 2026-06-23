@def hidden = false
@def title = "Local representations vs Distributed representations in one picture"
@def published = "19 November 2022"
@def tags = ["representation-learning", "machine-learning"]

### Local representations vs. Distributed representations

*Local vs. distributed representation* is one of the most basic and useful dichotomies for thinking about problem formulations.

We can understand the difference between the two in the following picture from [Bhaskar Mitra](https://www.microsoft.com/en-us/research/uploads/prod/2018/04/NeuralIR-Nov2017.pdf):

@@img-small ![local vs. distributed](/blog/pics/local_distributed.png) @@

In (a), the local representation, each concept gets its own distinct set of parameters. The picture illustrates this with one-hot encodings, where each possible one-hot vector stands for a single concept (e.g., banana, mango, dog).

In (b), the distributed representation, each concept is represented by some combination of parameters.

The choice makes a big difference in practice. The number of concepts a local representation can encode is linear in the number of parameters; the number a distributed representation can encode is roughly exponential in the number of parameters (see [this talk](https://www.youtube.com/watch?v=-SY4-GkDM8g) by Ruslan Salakhutdinov at the 26:53 mark). So a distributed representation can describe far more complicated concepts with far fewer parameters.