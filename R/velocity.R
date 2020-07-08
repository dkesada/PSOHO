#' R6 class that defines velocities affecting causality lists in the PSO
#' 
#' The velocities will be defined as a causality list where each element in
#' a causal unit is a pair (v, node) with v being either 0, 1 or -1. 0 means 
#' that arc remained the same, 1 means that arc was added and -1 means that arc 
#' was deleted.
#' @export
Velocity <- R6::R6Class("Velocity",
  public = list(
    #' @description 
    #' Constructor of the 'causlist' class
    #' @param net dbn or dbn.fit object defining the network
    #' @param size Number of timeslices of the DBN
    #' @param nodes A list with the names of the nodes in an order 
    #' If its not null, a random causlist will be generated for those nodes
    #' @return A new 'causlist' object
    initialize = function(ordering, size){
      #initial_size_check(size) --ICO-Merge
      
      private$size <- size
      private$ordering <- ordering
      private$vl <- initialize_vl_cpp(ordering, size)
    }
  ),
  private = list(
    #' @field vl List of causal units defining the velocity
    vl = NULL,
    #' @field size Size of the DBN
    size = NULL,
    #' @field ordering String vector defining the order of the nodes in a timeslice
    ordering = NULL
  )
)