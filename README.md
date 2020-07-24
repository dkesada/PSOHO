
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

  - Roxygen’s interaction with R6 objects is kind of wonky. It kind of
    works, but at the same time it kind of doesn’t. You can document R6
    objects, but when you are bulding the documentation of the classes
    and their methods it showers you with warnings. Afterwards, you get
    the tooltips for the constructor of the class and the methods all
    mixed up, and when you are calling a method from an instantiated
    object you get no helping tooltip at all.

![alt
text](https://raw.githubusercontent.com/dkesada/psoho/master/media/r6_roxygen.png)

  - Incorporating Rcpp inside R6 objects is as straightforward as it
    looks. No problems in that regard.

  - You can call R code from within C++, and you can do some interesting
    stuff by calling and creating R6 objects from C++, although it’s
    kind of weird:

<!-- end list -->

``` cpp
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

  - Given that I have specific operators for Positions and Velocities
    and my search space is not continuous, I can’t use packages like
    ‘pso’ for the particle swarm main functionallity.

  - I’ve finished the Position and Velocity objects and operations, so
    I’ll implement the pso algorithm and some parallelism with
    ‘RcppThread’ and maybe ‘doParallel’. As an early note, combining
    ‘doParallel’ with the first particles initialization results in
    awful performance, maybe due to combining the results with the ‘c’
    operator.
