#' R6 class that defines DBNs as causality lists
#' 
#' A causality list has a list with causal units, a size representing the
#' Markovian order of the network and a specific node ordering.
Causlist <- R6::R6Class("Causlist", 
  public = list(
    #' @description 
    #' Constructor of the 'causlist' class
    #' @param net dbn or dbn.fit object defining the network
    #' @param size Number of timeslices of the DBN
    #' @param nodes A list with the names of the nodes in an order 
    #' If its not null, a random causlist will be generated for those nodes
    #' @return A new 'causlist' object
    initialize = function(net, size, nodes = NULL){
      #initial_size_check(size) --ICO-Merge
      
      if(!is.null(nodes)){
        #initial_nodes_check(nodes)
        net <- private$generate_random_network(nodes, size)
      }
      else{
        #initial_dbn_check(net) --ICO-Merge
        initial_dbn_to_causlist_check(net)
      }
      
      private$size <- size
      private$ordering <- private$dbn_ordering(net)
      private$cl_translate(net)
    },
    
    #' @description
    #' Getter of causality_list
    #' @return the causality list
    get_causality_list = function(){return(private$causality_list)},
    
    #' @description
    #' Getter of counters
    #' @return the counters numeric matrix
    get_counters = function(){return(private$counters)},
    
    debug = function(nodes, size){
      
      print(rename_nodes_cpp(nodes, size))
      
      
      }
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
    cl_translate = function(net){
      res <- create_causlist_cpp(net$nodes, private$size, private$ordering)
      private$causality_list <- res[[1]]
      private$counters <- res[[2]]
      rm(res)
    },
    
    #' @description 
    #' Translate the causality list into a DBN network
    #' 
    #' Uses this object private causality list and transforms it into a DBN.
    #' @return a dbn object
    bn_translate = function(){
      n_arcs = sum(private$counters)
      
      # TODO
      
    },
    
    #' @description 
    #' Generates a random DBN valid for causality list translation
    #' 
    #' This function takes as input a list with the names of the nodes and the
    #' desired size of the network and returns a random DBN structure.
    #' @param nodes a character vector with the names of the nodes in the net
    #' @param size the desired size of the DBN
    #' @return a random dbn structure
    generate_random_network = function(nodes, size){
      nodes_t_0 <- unlist(lapply(nodes, function(x){paste0(x, "_t_0")}))
      new_nodes <- rename_nodes_cpp(nodes, size)
      
      net <- bnlearn::random.graph(new_nodes)
      net <- private$prune_invalid_arcs(net, nodes_t_0)
      
      return(net)
    },
    
    #' @description 
    #' Fixes a DBN structure to make it suitable for causality list translation
    #' 
    #' This function takes as input a DBN structure and removes the 
    #' intra-timeslice arcs and the arcs that end in a node not in t_0.
    #' @param net the DBN structure
    #' @param nodes_t_0 a vector with the names of the nodes in t_0
    #' @return the fixed network
    prune_invalid_arcs = function(net, nodes_t_0){
      keep_rows <- !(net$arcs[,1] %in% nodes_t_0)
      keep_rows <- keep_rows & (net$arcs[,2] %in% nodes_t_0)
      keep_rows <- net$arcs[keep_rows,]
      bnlearn::arcs(net) <- keep_rows
      
      return(net)
    }
    
  )
)


