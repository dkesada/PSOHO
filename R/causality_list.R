#' R6 class that defines DBNs as causality lists
#' 
#' A causality list has a list with causal units, a size representing the
#' Markovian order of the network and a specific node ordering.
Causlist <- R6::R6Class("Causlist", 
  public = list(
    #' @description 
    #' Constructor of the 'causlist' class
    #' @param net dbn or dbn.fit object defining the network.
    #' @param size Number of timeslices of the DBN
    #' @param nodes A list with the names of the nodes in an order. 
    #' If its not null, a random causlist will be generated for those nodes.
    #' @return A new 'causlist' object
    initialize = function(net, size, nodes = NULL){
      if(is.null(nodes)){
        #initial_dbn_check(obj) --ICO-Merge
        initial_dbn_to_causlist_check(net)
        #initial_size_check(size) --ICO-Merge
        
        private$size <- size
        private$ordering <- private$dbn_ordering(net)
        private$cl_translate(net)
      }
      else{
        #initial_nodes_check(nodes)
        
        # TODO
      }
    },
    
    #' @description
    #' Getter of causality_list
    #' @return the causality list
    get_causality_list = function(){return(private$causality_list)},
    
    #' @description
    #' Getter of counters
    #' @return the counters numeric matrix
    get_counters = function(){return(private$counters)}
    ),
  
  private = list(
    #' @field causal_units List of causal units defining the structure
    causality_list = NULL,
    #' @field size Size of the DBN
    size = NULL,
    #' @field ordering String vector defining the order of the nodes in a timeslice
    ordering = NULL,
    #' @field number of elements in each causal unit
    counters = NULL,
    
    #' @description 
    #' Return the static node ordering
    #' 
    #' This function takes as input a dbn and return the node ordering of the
    #' variables inside a timeslice. This ordering is needed to understand a
    #' causal list.
    #' @param net a dbn or dbn.fit object
    #' @return the ordering of the nodes in t_0
    #' @export
    dbn_ordering = function(net){
      return(grep("t_0", names(net$nodes), value = TRUE))
    },
    
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
      res <- create_causlist_cpp(net$nodes, private$size, private$ordering)
      private$causality_list <- res[[1]]
      private$counters <- res[[2]]
      rm(res)
    },
    
    #' @description 
    #' Translate a causality list into a DBN network
    #' 
    #' This function takes as input a causality list and transforms it into a DBN.
    #' @param caus a causlist object
    #' @return a dbn object
    #' @export
    bn_translate = function(caus){
      # TODO
    }
    
  )
)


