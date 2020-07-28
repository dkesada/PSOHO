#' R6 class that defines the PSO controller
#' 
#' The controller will encapsulate the particles and run the algorithm
#' @export
PsoCtrl <- R6::R6Class("PsoCtrl",
  public = list(
    #' @description 
    #' Constructor of the 'PsoCtrl' class
    #' @param ordering a vector with the names of the nodes in t_0
    #' @param size number of timeslices of the DBN
    #' @param n_inds number of particles that the algorithm will simultaneously process
    #' @param n_threads number of threads used during parallel sections. By default, half of the available cores
    #' @param n_it maximum number of iterations of the pso algorithm
    #' @param in_cte parameter that varies the effect of the inertia
    #' @param gb_cte parameter that varies the effect of the global best
    #' @param lb_cte parameter that varies the effect of the local best
    #' @return A new 'PsoCtrl' object
    initialize = function(ordering, size, n_inds, n_threads, n_it, in_cte, gb_cte, lb_cte){
      #initial_size_check(size) --ICO-Merge
      
      private$parts <- private$initia
      private$ordering <- ordering
      private$cl <- initialize_cl_cpp(ordering, size)
    },
    
    get_cl = function(){return(private$cl)},
    
    get_ordering = function(){return(private$ordering)},
    
    get_size = function(){return(private$size)}
    
  ),
  private = list(
    #' @field parts list with all the particles in the algorithm
    parts = NULL,
    #' @field cl cluster for the parallel computations
    cl = NULL,
    #' @field n_it maximum number of iterations of the pso algorithm
    n_it = NULL,
    #' @field in_cte parameter that varies the effect of the inertia
    in_cte = NULL,
    #' @field gb_cte parameter that varies the effect of the global best
    gb_cte = NULL,
    #' @field lb_cte parameter that varies the effect of the local best
    lb_cte = NULL,
    #' @field b_ps best position found
    b_ps = NULL,
    #' @field b_scr best score obtained
    b_scr = NULL
  )
)