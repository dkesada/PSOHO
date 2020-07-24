#' Learn a DBN structure with a PSO approach
#' 
#' Given a dataset and the desired Markovian order, this function returns a DBN
#' structure ready to be fitted with the 'dbnR' package.
#' @param dt a data.table with the data of the network to be trained. Do not previously fold it with the 'dbnR' package.
#' @param size Number of timeslices of the DBN. Markovian order 1 equals size 2, and so on.
#' @param n_ind Number of particles used in the algorithm.
#' @param n_it Maximum number of iterations that the algorithm can perform.
#' @param score The score used to evaluate the structures
#' @return A 'dbn' object with the structure of the best network found
#' @export
learn_dbn_structure_pso <- function(dt, size, n_ind = 30, n_it = 20, score = "bge"){
  #initial_size_check(size) --ICO-Merge
  #initial_df_check(dt) --ICO-Merge
}

#' Dummy function for C++ code
#' 
#' Dummy function for C++ code
#' @param ordering Names of the nodes in the network
#' @param size Number of timeslices of the DBN. Markovian order 1 equals size 2, and so on.
#' @param n_ind Number of particles used in the algorithm.
#' @export
dummy <- function(ordering, size, n_inds){
  a <- Sys.time()
  res <- init_list_cpp(ordering, size, n_inds)
  print(Sys.time() - a)
  
  a <- Sys.time()
  res <- vector(mode = "list", length = n_inds)
  for(i in 1:n_inds){
    res[[i]] = Position$new(NULL, size, ordering)
  }
  print(Sys.time() - a)
  
  cl <- makeCluster(detectCores() - 1)
  registerDoParallel(cl)
  a <- Sys.time()
  res <- vector(mode = "list", length = n_inds)
  res <- foreach(1:n_inds, .export = "Position") %dopar% {Position$new(NULL, size, ordering)}
  print(Sys.time() - a)
  stopCluster(cl)
  
  cl <- makeCluster(detectCores() - 1)
  clusterExport(cl, c("Position", "size", "ordering"))
  a <- Sys.time()
  res <- vector(mode = "list", length = n_inds)
  res <- parLapply(cl,1:n_inds, function(i){Position$new(NULL, size, ordering)})
  print(Sys.time() - a)
  stopCluster(cl)
  
  
  # Both initializations take the same amount of time, so no need to go down to C++
  # I'll try to speed things up by using 'RcppThread', which looks nice
  # The 'foreach' initialization performs awfully slow, maybe due to it combining the results of each iteration with the 'c' operator
  # The parLapply works better than the classical approach for more than 50 particles
  
  return(res)
}