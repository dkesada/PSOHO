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
     if(score < private$lb)
       private$lb <- score
     
     return(score)
   },
   
   get_ps = function(){return(private$ps)},
   
   get_vl = function(){return(private$vl)},
   
   get_lb = function(){return(private$lb)}
 ),
 
 private = list(
   #' @field ps position of the particle
   ps = NULL,
   #' @field cl velocity of the particle
   vl = NULL,
   #' @field lb_cte local best score obtained
   lb = NULL
 )
)