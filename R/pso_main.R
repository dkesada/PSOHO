#' Learn a DBN structure with a PSO approach
#' 
#' Given a dataset and the desired Markovian order, this function returns a DBN
#' structure ready to be fitted with the 'dbnR' package.
#' @param dt a data.table with the data of the network to be trained. Do not previously fold it with the 'dbnR' package.
#' @param size Number of timeslices of the DBN. Markovian order 1 equals size 2, and so on.
#' @param n_inds Number of particles used in the algorithm.
#' @param n_it Maximum number of iterations that the algorithm can perform.
#' @param in_cte parameter that varies the effect of the inertia
#' @param gb_cte parameter that varies the effect of the global best
#' @param lb_cte parameter that varies the effect of the local best
#' @param n_threads number of threads used during parallel sections. By default, half of the available cores
#' @return A 'dbn' object with the structure of the best network found
#' @export
learn_dbn_structure_pso <- function(dt, size, n_inds = 50, n_it = 50,
                                    in_cte = 0.5, gb_cte = 0.5, lb_cte = 0.5, n_threads = NULL){
  #initial_size_check(size) --ICO-Merge
  #initial_df_check(dt) --ICO-Merge
  
  ordering <- names(dt)
  ctrl <- PsoCtrl$new(ordering, size, n_inds, n_it, in_cte, gb_cte, lb_cte, n_threads = NULL)
  ctrl$run(dt)
  
  return(ctrl$get_best_network())
}


#' Dummy function for testing parallelism and C++ code
#' 
#' Dummy function for testing parallelism and C++ code
#' @param ordering Names of the nodes in the network
#' @param size Number of timeslices of the DBN. Markovian order 1 equals size 2, and so on.
#' @param n_inds Number of particles used in the algorithm.
#' @export
dummy <- function(ordering, size, n_inds){
  # a <- Sys.time()
  # res <- init_list_cpp(ordering, size, n_inds)
  # print(Sys.time() - a)
  
  a <- Sys.time()
  res <- vector(mode = "list", length = n_inds)
  for(i in 1:n_inds)
    res[[i]] <- Particle$new(ordering, size)
  print(Sys.time() - a)
  
  # cl <- makeCluster(detectCores() - 1, type = "FORK")
  # registerDoParallel(cl)
  # a <- Sys.time()
  # res <- vector(mode = "list", length = n_inds)
  # res <- foreach(i = 1:n_inds, .combine = list, .export = "Position") %dopar% {Position$new(NULL, size, ordering)}
  # print(Sys.time() - a)
  # stopCluster(cl)
  
  a <- Sys.time()
  cl <- parallel::makeCluster(parallel::detectCores() / 2, type = "PSOCK") # Selecting the appropriate number of threads is vital to performance
  
  res <- vector(mode = "list", length = n_inds)
  res <- parallel::parLapply(cl,1:n_inds, function(i){Particle$new(ordering, size)})
  
  parallel::stopCluster(cl)
  print(Sys.time() - a)
  
  a <- Sys.time()
  res <- PsoCtrl$new(ordering, size, n_inds, 50, 0.5, 0.5, 0.5, n_threads = NULL)
  #ctrl$stop_cluster()
  print(Sys.time() - a)
  
  # cl <- makeCluster(detectCores() - 1)
  # clusterExport(cl, c("Position", "size", "ordering"))
  # a <- Sys.time()
  # res <- vector(mode = "list", length = n_inds)
  # res <- parLapply(cl,1:n_inds, function(i){Position$new(NULL, size, ordering)})
  # print(Sys.time() - a)
  # stopCluster(cl)
  
  # registerDoMC(cores = detectCores() - 1)
  # a <- Sys.time()
  # res <- vector(mode = "list", length = n_inds)
  # res <- foreach(1:n_inds, .export = "Position") %dopar% {Position$new(NULL, size, ordering)}
  # print(Sys.time() - a)
  
  # Sequential initialization in C++ is equivalent or worse than sequential in R for n_inds < 200
  # Parallel with parLapply is ok for n_inds > 600, but that amount of particles is unrealistic
  # Parallel with parLapply and FORK dominates the other options, but only works on linux
  # I'll try to speed things up by using 'RcppThread', which looks nice --> Massive R session crashes due to calling R code from different threads at the same time
  # The 'foreach' initialization performs awfully slow, maybe due to it combining the results of each iteration with the 'c' operator
  # The parLapply works better than the classical approach for more than 50 particles
  
  return(res)
}

eval_sol <- function(real, sol){
  real_arcs <- apply(real$arcs, 1, function(x){paste0(x[1], x[2])})
  sol_arcs <- apply(sol$arcs, 1, function(x){paste0(x[1], x[2])})
  
  return(sum(real_arcs %in% sol_arcs))
}