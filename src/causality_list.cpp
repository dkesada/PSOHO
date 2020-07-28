#include "include/causality_list.h"

//' Create a causality list and initialize it
//' 
//' @param ordering a list with the order of the variables in t_0
//' @param size the size of the DBN
//' @return a causality list
// [[Rcpp::export]]
Rcpp::List initialize_cl_cpp(StringVector &ordering, unsigned int size) {
  Rcpp::List res (size - 1);
  Rcpp::StringVector new_names;
  
  // Initialization of the causality list
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

// Insert a node in the correspondent causal unit. Keeps record of inserted
// elements in each causal unit
// 
// @param cl a causality list
// @param node the node to insert
// @param i the causal unit in which to insert.
void insert_node_cl(Rcpp::List &cl, std::string node, unsigned int i){
  int idx = find_index(node);
  Rcpp::List slice = cl[idx-1];
  Rcpp::List cu = slice[i];
  int pos = 0;
  Rcpp::StringVector names = cu[0];
  std::string str;
  Rcpp::NumericVector arcs = cu[1];
  
  str = names[0];
  while(node.compare(str) != 0 && pos < names.size()){
    pos++;
    str = names[pos];
  }
  
  arcs[pos] = 1;
}


