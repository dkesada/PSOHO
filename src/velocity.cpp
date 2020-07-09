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

//' Randomize a velocity with the given probabilities
//' 
//' @param vl a velocity list
//' @param probs the probabilities of each value in the set {-1,0,1}
//' @return a velocity list with randomized values
// [[Rcpp::export]]
Rcpp::List randomize_vl_cpp(Rcpp::List &vl, NumericVector &probs) {
  Rcpp::List slice;
  Rcpp::List velocity;
  Rcpp::NumericVector directions;
  Rcpp::List cu;
  Rcpp::List pair;
  
  
  // Initialization of the velocity
  for(unsigned int i = 0; i < vl.size(); i++){
    slice = vl[i];
    for(unsigned int j = 0; j < slice.size(); j++){
      pair = slice[j];
      directions = random_directions(probs, slice.size());
      pair[1] = directions;
    }
  }
  
  return vl;
}