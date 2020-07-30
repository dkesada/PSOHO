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
                                    in_cte = 1, gb_cte = 0.5, lb_cte = 0.5){
  #initial_size_check(size) --ICO-Merge
  #initial_df_check(dt) --ICO-Merge
  
  ordering <- names(dt)
  ctrl <- PsoCtrl$new(ordering, size, n_inds, n_it, in_cte, gb_cte, lb_cte)
  ctrl$run(dt)
  
  return(ctrl$get_best_network())
}