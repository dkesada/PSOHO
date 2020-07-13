#include "include/position.h"

//' Create a causal list from a DBN. This is the C++ backend of the function.
//' 
//' @param cl an initialized causality list
//' @param net a dbn object treated as a list of lists
//' @param size the size of the DBN
//' @param ordering a list with the order of the variables in t_0
//' @return a list with a CharacterVector and a NumericVector
// [[Rcpp::export]]
Rcpp::List create_causlist_cpp(Rcpp::List &cl, Rcpp::List &net, unsigned int size, StringVector &ordering) {
  Rcpp::List aux;
  Rcpp::StringVector caus_unit;
  std::string node;
  Rcpp::StringVector parents;
    
  // Translation into causal list
  for(unsigned int i = 0; i < ordering.size(); i++){
    node = ordering[i];
    aux = net[node];
    parents = aux["parents"];

    for(unsigned int j = 0; j < parents.size(); j++){
      node = parents[j];
      insert_node_cl(cl, node, i);
    }
  }
  
  return cl;
}

//' Create a matrix with the arcs defined in a causlist object
//' 
//' @param cl a causal list
//' @param ordering a list with the order of the variables in t_0
//' @param rows number of arcs in the network
//' @return a list with a CharacterVector and a NumericVector
// [[Rcpp::export]]
Rcpp::CharacterMatrix cl_to_arc_matrix_cpp(Rcpp::List &cl, Rcpp::CharacterVector &ordering,
                                           unsigned int rows){
  Rcpp::StringMatrix res (rows, 2);
  unsigned int res_row = 0;
  Rcpp::List slice;
  Rcpp::List cu;
  Rcpp::StringVector nodes;
  Rcpp::NumericVector arcs;
  
  for(unsigned int i = 0; i < cl.size(); i++){
    slice = cl[i];
    for(unsigned int j = 0; j < ordering.size(); j++){
      cu = slice[j];
      nodes = cu[0];
      arcs = cu[1];
      for(unsigned int k = 0; k < nodes.size(); k++){
        if(arcs[k] == 1){
          res(res_row, 0) = nodes[k];
          res(res_row, 1) = ordering[j];
          res_row += 1;
        }
      }
    }
  }
  
  return res;
}

//' Add a velocity to a position
//' 
//' @param cl the position's causal list
//' @param vl the velocity's causal list
//' @param n_arcs number of arcs present in the position
//' @return a list with the modified position and the new number of arcs
// [[Rcpp::export]]
Rcpp::List pos_plus_vel_cpp(Rcpp::List &cl, Rcpp::List &vl, int n_arcs){
  Rcpp::List slice_cl;
  Rcpp::List slice_vl;
  Rcpp::List cu_cl;
  Rcpp::List cu_vl;
  Rcpp::List pair_cl;
  Rcpp::List pair_vl;
  Rcpp::NumericVector dirs_cl;
  Rcpp::NumericVector dirs_vl;
  Rcpp::List res (2);
  
  for(unsigned int i = 0; i < cl.size(); i++){
    slice_cl = cl[i];
    slice_vl = vl[i];
    
    for(unsigned int j = 0; j < slice_cl.size(); j++){
      pair_cl = slice_cl[j];
      pair_vl = slice_vl[j];
      dirs_cl = pair_cl[1];
      dirs_vl = pair_vl[1];
      dirs_cl = add_dirs_vec(dirs_cl, dirs_vl, n_arcs);
      
      pair_cl[1] = dirs_cl;
      slice_cl[j] = pair_cl;
    }
    
    cl[i] = slice_cl;
  }
  
  res[0] = cl;
  res[1] = n_arcs;
  
  return res;
}
