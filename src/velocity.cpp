#include "include/velocity.h"

//' Randomize a velocity with the given probabilities
//' 
//' @param vl a velocity list
//' @param probs the probabilities of each value in the set {-1,0,1}
//' @param seed the seed used for random number generation. Ignored if lesser than 0
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

//' Substracts two Positions to obtain the Velocity that transforms one into the other
//' 
//' @param cl the first position's causal list
//' @param ps the second position's causal list
//' @param vl the Velocity's causal list
//' @return a list with the Velocity's causal list and the number of operations
// [[Rcpp::export]]
Rcpp::List pos_minus_pos_cpp(Rcpp::List &cl, Rcpp::List &ps, Rcpp::List &vl){
  Rcpp::List slice_cl;
  Rcpp::List slice_ps;
  Rcpp::List slice_vl;
  Rcpp::List cu_cl;
  Rcpp::List cu_ps;
  Rcpp::List cu_vl;
  Rcpp::List pair_cl;
  Rcpp::List pair_ps;
  Rcpp::List pair_vl;
  Rcpp::NumericVector dirs_cl;
  Rcpp::NumericVector dirs_ps;
  Rcpp::NumericVector dirs_vl;
  int n_abs = 0;
  Rcpp::List res (2);
  
  for(unsigned int i = 0; i < cl.size(); i++){
    slice_cl = cl[i];
    slice_ps = ps[i];
    slice_vl = vl[i];
    
    for(unsigned int j = 0; j < slice_cl.size(); j++){
      pair_cl = slice_cl[j];
      pair_ps = slice_ps[j];
      pair_vl = slice_vl[j];
      dirs_cl = pair_cl[1];
      dirs_ps = pair_ps[1];
      dirs_vl = subtract_dirs_vec(dirs_cl, dirs_ps, n_abs);
      
      pair_vl[1] = dirs_vl;
      slice_vl[j] = pair_vl;
    }
    
    vl[i] = slice_vl;
  }
  
  res[0] = vl;
  res[1] = n_abs;
  
  return res;
}

//' Substracts two Positions to obtain the Velocity that transforms one into the other
//' 
//' @param cl the first position's causal list
//' @param ps the second position's causal list
//' @param vl the Velocity's causal list
//' @return a list with the Velocity's causal list and the number of operations
// [[Rcpp::export]]
Rcpp::List vel_plus_vel_cpp(Rcpp::List &vl1, Rcpp::List &vl2, int abs_op){
  Rcpp::List slice_vl1;
  Rcpp::List slice_vl2;
  Rcpp::List cu_vl1;
  Rcpp::List cu_vl2;
  Rcpp::List pair_vl1;
  Rcpp::List pair_vl2;
  Rcpp::NumericVector dirs_vl1;
  Rcpp::NumericVector dirs_vl2;
  Rcpp::List res (2);
  
  for(unsigned int i = 0; i < vl1.size(); i++){
    slice_vl1 = vl1[i];
    slice_vl2 = vl2[i];
    
    for(unsigned int j = 0; j < slice_vl1.size(); j++){
      pair_vl1 = slice_vl1[j];
      pair_vl2 = slice_vl2[j];
      dirs_vl1 = pair_vl1[1];
      dirs_vl2 = pair_vl2[1];
      dirs_vl1 = add_vel_dirs_vec(dirs_vl1, dirs_vl2, abs_op);
      
      pair_vl1[1] = dirs_vl1;
      slice_vl1[j] = pair_vl1;
    }
    
    vl1[i] = slice_vl1;
  }
  
  res[0] = vl1;
  res[1] = abs_op;
  
  return res;
}