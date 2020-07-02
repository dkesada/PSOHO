#' R6 class that defines DBNs as causality lists
#' 
#' A causality list has a list with causal units, a size representing the
#' Markovian order of the network and a specific node ordering.
Causlist <- R6::R6Class("causlist", 
  public = list(
    #' @description 
    #' Constructor of the 'causlist' class
    #' @param net dbn or dbn.fit object defining the network.
    #' @param size Number of timeslices of the DBN
    #' @return A new 'causlist' object
    initialize = function(net, size){
      private$size <- size
    }
    ),
  
  private = list(
    #' @field causal_units List of causal units defining the structure
    causal_units = NULL,
    #' @field size Size of the DBN
    size = NULL,
    #' @field ordering String vector defining the order of the nodes in a timeslice
    ordering = NULL,
    
    #' @description 
    #' Translate a DBN into a causality list
    #' 
    #' This function takes as input a network from a DBN and transforms the 
    #' structure into a causality list if it is a valid DBN. Valid DBNs have only
    #' inter-timeslice edges and only allow variables in t_0 to have parents.
    #' @param net a dbn object
    #' @return a causlist object
    #' @export
    cl_translate = function(net){
      no_interslice_check(net)
      
      # Check valid network
      # Translate
    },
    
    #' @description 
    #' Translate a causality list into a DBN network
    #' 
    #' This function takes as input a causality list and transforms it into a DBN.
    #' @param caus a causlist object
    #' @return a dbn object
    #' @export
    bn_translate = function(caus){
      initial_causlist_check(caus)
    }
    
  )
)


