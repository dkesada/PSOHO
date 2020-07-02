is_causlist <- function(obj){
  return(inherits(obj, "causlist"))
}

initial_causlist_check <- function(obj){
  if(!is_causlist(obj))
    stop(sprintf("%s must be of class 'causlist'.",
                 deparse(substitute(obj))))
}

has_interslice_arcs <- function(net){
  
}

no_interslice_check <- function(obj){
  #initial_dbn_check(obj)
  if(!is_causlist(obj))
    stop(sprintf("%s must be of class 'causlist'.",
                 deparse(substitute(obj))))
}