#include "include/velocity.h"

//' Create a velocity list and initialize it
//' 
//' @param ordering a list with the order of the variables in t_0
//' @param size the size of the DBN
//' @return a velocity list
// [[Rcpp::export]]
Rcpp::List initialize_vl_cpp(StringVector &ordering, unsigned int size) {
  Rcpp::List res (size - 1);
  Rcpp::StringVector new_names;
  
  // Initialization of the velocity
  for(unsigned int i = 0; i < size - 1; i++){
    Rcpp::List vel_list(ordering.size());
    new_names = rename_slices(ordering, i + 1);
    for(unsigned int j = 0; j < ordering.size(); j++){
      Rcpp::List pair (2);
      Rcpp::NumericVector velocity (ordering.size());
      
      pair[0] = new_names;
      pair[1] = velocity;
      vel_list[j] = pair;
    }
    res[i] = vel_list;
  }
  
  return res;
}

