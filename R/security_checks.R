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
  no_interslice_check(obj)
}