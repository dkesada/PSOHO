#' R6 class that defines causal lists in the PSO
#' 
#' The causal lists will be the base of the positions and the velocities
#' in the pso part of the algorithm.
#' @export
Causlist <- R6::R6Class("Causlist",
  public = list(
    #' @description 
    #' Constructor of the 'Causlist' class
    #' @param ordering a vector with the names of the nodes in t_0
    #' @param size number of timeslices of the DBN
    #' @return A new 'causlist' object
    initialize = function(ordering, size){
      #initial_size_check(size) --ICO-Merge
      
      private$size <- size
      private$ordering <- ordering
      private$cl <- initialize_cl_cpp(ordering, size)
    },
    
    get_cl = function(){return(private$cl)},
    
    get_ordering = function(){return(private$ordering)},
    
    get_size = function(){return(private$size)}
    
  ),
  private = list(
    #' @field cl List of causal units
    cl = NULL,
    #' @field size Size of the DBN
    size = NULL,
    #' @field ordering String vector defining the order of the nodes in a timeslice
    ordering = NULL
  )
)