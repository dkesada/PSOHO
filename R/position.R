#' R6 class that defines DBNs as causality lists
#' 
#' A causality list has a list with causal units, a size representing the
#' Markovian order of the network and a specific node ordering.
Position <- R6::R6Class("Position", 
  inherit = Causlist,
  public = list(
    #' @description 
    #' Constructor of the 'causlist' class
    #' @param net dbn or dbn.fit object defining the network
    #' @param size Number of timeslices of the DBN
    #' @param nodes A list with the names of the nodes in the network
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
      
      super$initialize(private$dbn_ordering(net), size)
      private$nodes <- names(net$nodes)
      private$n_arcs <- dim(net$arcs)[1]
      private$cl_translate(net)
    },
    
    get_n_arcs = function(){return(private$n_arcs)},
    
    get_nodes = function(){return(private$nodes)},
    
    #' @description 
    #' Translate the causality list into a DBN network
    #' 
    #' Uses this object private causality list and transforms it into a DBN.
    #' @return a dbn object
    bn_translate = function(){
      arc_mat <- cl_to_arc_matrix_cpp(private$cl, private$ordering, private$n_arcs)
      
      net <- bnlearn::empty.graph(private$nodes)
      bnlearn::arcs(net) <- arc_mat
      
      return(net)
    },
    
    #' @description 
    #' Add a velocity to the position
    #' 
    #' Given a Velocity object, add it to the current position.
    #' @param vl a Velocity object
    add_velocity = function(vl){
      initial_vel_2_pos_check(vl, private$size, private$ordering)
      
      res = pos_plus_vel_cpp(private$cl, vl$get_cl(), private$n_arcs)
      private$cl = res[[1]]
      private$n_arcs = res[[2]]
    },
    
    #' @description 
    #' Given another position, returns the velocity that gets this position to the
    #' other.
    #' 
    #' @param ps a Position object
    #' return the Velocity that gets this position to the new one
    subtract_position = function(ps){
      initial_pos_2_pos_check(ps, private$size, private$ordering)
      
      res <- Velocity$new(private$ordering, private$size)
      res$subtract_positions(self, ps)
      
      return(res)
    }
  ),
  
  private = list(
    #' @field n_arcs Number of arcs in the network
    n_arcs = NULL,
    #' @field nodes Names of the nodes in the network
    nodes = NULL,
    
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
      private$cl <- create_causlist_cpp(private$cl, net$nodes, private$size, private$ordering)
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
      idx <- grep("t_0", nodes)
      
      if(length(idx) == 0){
        nodes_t_0 <- unlist(lapply(nodes, function(x){paste0(x, "_t_0")}))
        new_nodes <- rename_nodes_cpp(nodes, size)
      }
      else{
        nodes_t_0 <- names(dt)[idx]
        new_nodes <- c(names(dt)[-idx], nodes_t_0)
      }
      
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


