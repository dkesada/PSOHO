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
    #' @param n_it maximum number of iterations of the pso algorithm
    #' @param in_cte parameter that varies the effect of the inertia
    #' @param gb_cte parameter that varies the effect of the global best
    #' @param lb_cte parameter that varies the effect of the local best
    #' @param n_threads number of threads used during parallel sections. By default, half of the available cores
    #' @return A new 'PsoCtrl' object
    initialize = function(ordering, size, n_inds, n_it, in_cte, gb_cte, lb_cte, n_threads = NULL){
      #initial_size_check(size) --ICO-Merge
      # Missing security checks --ICO-Merge
      
      #private$initialize_cluster(n_threads) # A lot slower than the sequential approach. Dropped for now, I'll check it out again with the full algorithm.
      private$initialize_particles(ordering, size, n_inds)
      private$gb_scr <- Inf
      private$n_it <- n_it
      private$in_cte <- in_cte
      private$gb_cte <- gb_cte
      private$lb_cte <- lb_cte
    },
    
    #' @description 
    #' Getter of the cluster attribute
    #' @return the cluster attribute
    get_cl = function(){return(private$cl)},
    
    #' @description 
    #' Transforms the best position found into a bn structure and returns it
    #' @return the size attribute
    get_best_network = function(){return(private$gb_ps$bn_translate())},
    
    #' @description 
    #' Stops the cluster used for parallel operations. Should be called when the object is not needed anymore.
    stop_cluster = function(){
      parallel::stopCluster(private$cl)
    },
    
    #' @description 
    #' Main function of the pso algorithm.
    #' @param dt the dataset from which the structure will be learned
    run = function(dt){
      # Missing security checks --ICO-Merge
      private$evaluate_particles(dt)
      
      # Main loop of the algorithm.
      for(i in private$n_it){
        # Inside loop. Update each particle
        for(p in private$parts)
          p$update_state(private$in_cte, private$gb_cte, private$gb_ps, private$lb_cte)
        private$evaluate_particles(dt)
      }
      
    }
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
    #' @field b_ps global best position found
    gb_ps = NULL,
    #' @field b_scr global best score obtained
    gb_scr = NULL,
    
    #' @description 
    #' Initialize the cluster for parallel operations. On halt for now, it's way too slow for some reason.
    #' @param n_threads number of threads used during parallel sections. By default, half of the available cores
    initialize_cluster = function(n_threads){
      if(is.null(n_threads))
        private$cl <- parallel::makeCluster(parallel::detectCores() / 2, "PSOCK")
      else
        private$cl <- parallel::makeCluster(n_threads, "PSOCK")
    },
    
    #' @description 
    #' Initialize the particles for the algorithm to random positions and velocities.
    #' @param ordering a vector with the names of the nodes in t_0
    #' @param size number of timeslices of the DBN
    #' @param n_inds number of particles that the algorithm will simultaneously process
    initialize_particles = function(ordering, size, n_inds){
      #private$parts <- parallel::parLapply(private$cl,1:n_inds, function(i){Particle$new(ordering, size)})
      private$parts <- vector(mode = "list", length = n_inds)
      for(i in 1:n_inds)
        private$parts[[i]] <- Particle$new(ordering, size)
    },
    
    #' @description 
    #' Evaluate the particles and update the global best
    #' @param dt the dataset used to evaluate the position
    evaluate_particles = function(dt){
      for(p in private$parts){
        scr <- p$eval_ps(dt)
        if(scr < private$gb_scr){
          private$gb_scr <- scr
          private$gb_ps <- p$get_ps()
        }
      }
    }
  )
)