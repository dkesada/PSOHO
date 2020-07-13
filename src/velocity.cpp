#include "include/velocity.h"

//' Randomize a velocity with the given probabilities
//' 
//' @param vl a velocity list
//' @param probs the probabilities of each value in the set {-1,0,1}
//' @return a velocity list with randomized values
// [[Rcpp::export]]
Rcpp::List randomize_vl_cpp(Rcpp::List &vl, NumericVector &probs, int seed) {
  Rcpp::List slice;
  Rcpp::List velocity;
  Rcpp::List directions;
  Rcpp::List cu;
  Rcpp::List pair;
  unsigned int abs_op = 0;
  Rcpp::List res (2);
  
  // Initialization of the velocity
  for(unsigned int i = 0; i < vl.size(); i++){
    slice = vl[i];
    for(unsigned int j = 0; j < slice.size(); j++){
      pair = slice[j];
      directions = random_directions(probs, slice.size(), seed);
      seed = -1; // Note the seed elimination. The generator is already seeded, if seeded again it will return the same results over and over
      pair[1] = directions[0];
      abs_op += directions[1];
    }
  }
  
  res[0] = vl;
  res[1] = abs_op;
  
  return res;
}