#' Learn a DBN structure with a PSO approach
#' 
#' Given a dataset and the desired Markovian order, this function returns a DBN
#' structure ready to be fitted with the 'dbnR' package. It requires a 'folded' dataset,
#' meaning that all variables have to be in the format 'xxxx_t_y', where 'xxxx' is 
#' the name of the variable and 'y' is the time-slice of the variable. This folding
#' can be done manually by shifting the columns and renaming them or automatically
#' via the 'dbnR' package.
#' @param dt a data.table with the data of the network to be trained. Previously folded with the 'dbnR' package or other means.
#' @param size Number of timeslices of the DBN. Markovian order 1 equals size 2, and so on.
#' @param n_inds Number of particles used in the algorithm.
#' @param n_it Maximum number of iterations that the algorithm can perform.
#' @param in_cte parameter that varies the effect of the inertia
#' @param gb_cte parameter that varies the effect of the global best
#' @param lb_cte parameter that varies the effect of the local best
#' @param v_probs vector that defines the random velocity initialization probabilities
#' @param r_probs vector that defines the range of random variation of gb_cte and lb_cte
#' @return A 'dbn' object with the structure of the best network found
#' @export
learn_dbn_structure_pso <- function(dt, size, n_inds = 50, n_it = 50,
                                    in_cte = 1, gb_cte = 0.5, lb_cte = 0.5,
                                    v_probs = c(10, 65, 25), 
                                    r_probs = c(-0.5, 1.5)){
  #initial_size_check(size) --ICO-Merge
  #initial_df_check(dt) --ICO-Merge
  
  ordering <- names(dt)
  ctrl <- PsoCtrl$new(ordering, size, n_inds, n_it, in_cte, gb_cte, lb_cte,
                      v_probs, r_probs)
  ctrl$run(dt)
  
  return(ctrl$get_best_network())
}