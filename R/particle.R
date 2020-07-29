#' R6 class that defines a Particle in the PSO algorithm
#' 
#' A particle has a Position, a Velocity and a local best
#' @export
Particle <- R6::R6Class("Particle",
 public = list(
   #' @description 
   #' Constructor of the 'Particle' class
   #' @param ordering a vector with the names of the nodes in t_0
   #' @param size number of timeslices of the DBN
   #' @return A new 'Particle' object
   initialize = function(ordering, size){
     #initial_size_check(size) --ICO-Merge
     
     private$ps <- Position$new(NULL, size, ordering)
     private$vl <- Velocity$new(private$ps$get_ordering(), size)
     private$vl$randomize_velocity()
     private$lb <- Inf
   },
   
   #' @description 
   #' Evaluate the score of the particle's position
   #' 
   #' Evaluate the score of the particle's position.
   #' Updates the local best if the new one is better.
   #' @param dt dataset to evaluate the fitness of the particle
   #' @return The score of the current position
   eval_ps = function(dt){
     struct <- private$ps$bn_translate()
     score <- bnlearn::score(struct, dt, type = "bge") # For now, unoptimized bge
     if(score < private$lb){
        private$lb <- score 
        private$lb_ps <- private$ps
     }
     
     return(score)
   },
   
   update_state = function(in_cte, gb_cte, gb_ps, lb_cte){
      # 1.- Inertia of previous velocity
      private$vl$cte_times_velocity(in_cte)
      # 2.- Velocity from global best
      op1 <- gb_cte * runif(1, -0.5, 1.5)
      vl1 <- gb_ps$subtract_position(private$ps)
      vl1$cte_times_velocity(op1)
      # 3.- Velocity from local best
      op2 <- lb_cte * runif(1, -0.5, 1.5)
      vl2 <- private$lb_ps$subtract_position(private$ps)
      vl2$cte_times_velocity(op2)
      # 4.- New velocity
      private$vl$add_velocity(vl1)
      private$vl$add_velocity(vl2)
      # 5.- Reduce velocity if higher than maximum (TODO)
      # 6.- New position
      private$ps$add_velocity(private$vl)
      # 7.- If a node has more parents than the maximum, reduce them (TODO)
   },
   
   get_ps = function(){return(private$ps)},
   
   get_vl = function(){return(private$vl)},
   
   get_lb = function(){return(private$lb)},
   
   get_lb_ps = function(){return(private$lb)}
 ),
 
 private = list(
   #' @field ps position of the particle
   ps = NULL,
   #' @field cl velocity of the particle
   vl = NULL,
   #' @field lb local best score obtained
   lb = NULL,
   #' @field lb_ps local best position found
   lb_ps = NULL
 )
)