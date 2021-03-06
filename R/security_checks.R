# I will leave this checks outside the R6 object in order to be consistent with the 'dbnR' package style in case of merging

is_causlist <- function(obj){
  return(inherits(obj, "causlist"))
}

initial_causlist_check <- function(obj){
  if(!is_causlist(obj))
    stop(sprintf("%s must be of class 'causlist'.",
                 deparse(substitute(obj))))
}

no_intraslice_check <- function(net){
  idx <- which(grepl("t_0", names(net$nodes)))
  for(i in idx)
    if(length(net$nodes[[i]]$children) > 0)
      stop("DBNs with intraslice arcs are not permitted.")
}

no_parents_check <- function(net){
  idx <- which(!grepl("t_0", names(net$nodes)))
  for(i in idx)
    if(length(net$nodes[[i]]$parents) > 0)
      stop("Only DBNs with no parents in any timeslice other than t_0 are permitted.")
}

initial_dbn_to_causlist_check <- function(obj){
  #initial_dbn_check(obj) --ICO-Merge
  no_parents_check(obj)
  no_intraslice_check(obj)
}

numeric_prob_vector_check <- function(obj){
  if(!is.numeric(obj))
    stop(sprintf("%s has to be numeric.", deparse(substitute(obj))))
  if(length(obj) != 3)
    stop(sprintf("%s has to of length 3.", deparse(substitute(obj))))
  # Not checking for positive numbers. Negative ones are also valid, although kind of useless.
}

initial_vel_2_pos_check <- function(vl, size, ordering){
  if(vl$get_size() != size)
    stop("The position and the velocity have different sizes.")
  # The orderings must have unique nodes
  sapply(vl$get_ordering(), function(x){
    if(!(x %in% ordering))
      stop("The position and the velocity have different nodes.")
  })
}

initial_pos_2_pos_check <- function(ps, size, ordering){
  if(ps$get_size() != size)
    stop("The two positions have different sizes.")
  # The orderings must have unique nodes
  sapply(ps$get_ordering(), function(x){
    if(!(x %in% ordering))
      stop("The two positions have different nodes.")
  })
}

initial_vel_2_vel_check <- function(vl, size, ordering){
  if(vl$get_size() != size)
    stop("The two velocities have different sizes.")
  # The orderings must have unique nodes
  sapply(vl$get_ordering(), function(x){
    if(!(x %in% ordering))
      stop("The two velocities have different nodes.")
  })
}