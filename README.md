
# PSOHO

This package implements the particle swarm optimization structure
learning algorithm for higher-order dynamic Bayesian networks from
Santos and Maciel (<https://doi.org/10.1109/BRC.2014.6880957>). It will
start off as an independent module and most likely will be incorporated
into the ‘dbnR’ package. My objective is to provide the ‘dbnR’ package
with some state-of-the-art methods of DBN structure learning, both for
comparison with new methods and to give the current DBN scene richer
alternatives than the usual “pick a static structure learning algorithm
and run it twice: one to build the static structure and one to build the
transition structure”.

On a personal note, this repository will also serve me as a first
serious approach to PSO and to R6 objects, both of which I’ve been
meaning to invest some time in for a while now.

## Some preliminary results

### Roxygen2 + R6

Roxygen’s interaction with R6 objects is kind of wonky. It kind of
works, but at the same time it kind of doesn’t. You can document R6
objects, but when you are bulding the documentation of the classes and
their methods it showers you with warnings. Afterwards, you get the
tooltips for the constructor of the class and the methods all mixed up,
and when you are calling a method from an instantiated object you get no
helping tooltip at all.

![alt
text](https://raw.githubusercontent.com/dkesada/psoho/master/media/r6_roxygen.png)

### Rcpp inside R6 objects

Incorporating Rcpp inside R6 objects is as straightforward as it looks.
No problems in that regard.

### Creating R6 objects from C++

You can call R code from within C++, and you can do some interesting
stuff by calling and creating R6 objects from C++, although it’s kind of
weird:

``` cpp
// [[Rcpp::export]]
Rcpp::List init_list_cpp(Rcpp::StringVector nodes, unsigned int size, unsigned int n_inds){
  Rcpp::List res (n_inds);
  Environment psoho("package:psoho");
  Environment env = psoho["Position"];
  Function new_ps = env["new"];
  
  for(unsigned int i = 0; i < n_inds; i++){
    Environment ps;
    ps = new_ps(NULL, size, nodes);
    res[i] = ps;
  }
  
  return res;
}
```

The previous function initializes a list of Positions, an R6 object,
from within C++. The main idea is that R6 objects are essentially
environments, and so you can import the function to create them from
your package and then call it. This was cool, not gonna lie.

### Discrete search space and the ‘pso’ package

Given that I have specific operators for Positions and Velocities and my
search space is not continuous, I can’t use packages like ‘pso’ for the
particle swarm main functionallity.

### R parallelization: ‘foreach’ and ‘parLapply’

Using ‘foreach’ for the first particles initialization results in awful
performance, maybe due to combining the results with the ‘c’ operator.

The ‘parLapply’ function works much more efficiently than the ‘foreach’
with %dopar%. This is even more so if you are in unix systems and can
use FORK as the type of cluster. The ‘doMC’ approach is equivalent to
this one.

Improvement in performance can be seen, on a general note, for networks
with 20+ variables in each time slice, populations with more than 200
particles, or networks with Markovian order greater than 5. In smaller
cases, the performance is either very similar or slightly worse, which
is alright.

### C++ parallelization: ‘RcppThread’ | ‘RcppParallel’ + R and Rcpp

The ‘RcppThread’ and ‘RcppParallel’ packages seem interesting, but
combining them with calls to R or Rcpp APIs (e.g. Rcpp::List) ends up in
unavoidable (and unpredictable) R session crashes. They should both be
used with thread-safe data structures, and Rcpp’s ones are not. I also
tried creating R6 objects in parallel before noticing this, which also
resulted in obvious session crashes. At best you get unstable
performance: sometimes it works, sometimes you get stack imbalances
because the garbage collector goes kind of crazy on your non-thread-safe
data structures, and in the end it crashes at some point.

If you plan on using parallel computing in C++, **you should plan ahead
to only use thread-safe data structures**. Unless I’m doing some pure
C++ computations, I’ll probably leave C++ parallelization out of this
project and stick to R code parallelization if needed. Even so, I was
meaning to try out both ‘RcppThread’ and ‘RcppParallel’ anyways, and I
got some useful tests and insights for future projects, so that’s
something.
