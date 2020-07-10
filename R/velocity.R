#' R6 class that defines velocities affecting causality lists in the PSO
#' 
#' The velocities will be defined as a causality list where each element in
#' a causal unit is a pair (v, node) with v being either 0, 1 or -1. 0 means 
#' that arc remained the same, 1 means that arc was added and -1 means that arc 
#' was deleted.
#' @export
Velocity <- R6::R6Class("Velocity",
  inherit = Causlist,
  public = list(
    get_abs_op = function(){return(private$abs_op)},
    
    randomize_velocity = function(probs){
      numeric_prob_vector_check(probs)
      directions = randomize_vl_cpp(private$cl, probs)
      private$cl = directions[[1]]
      private$abs_op = directions[[2]]
    }
    
  ),
  private = list(
    #' @field abs_op Total number of operations 1 or -1 in the velocity
    abs_op = NULL
  )
)