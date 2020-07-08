#include "include/causality_list.h"

// Insert a node in the correspondent causal unit. Keeps record of inserted
// elements in each causal unit
// 
// @param cl a causality list
// @param node the node to insert
// @param counters the number of elements in each causal unit of the causality list
// @param i the causal unit in which to insert. Corresponds with a column in the counters
void insert_node_cl(Rcpp::List &cl, std::string node, Rcpp::NumericMatrix &counters, unsigned int i){
  int idx = find_index(node);
  Rcpp::List slice = cl[idx-1];
  Rcpp::StringVector cu = slice[i];
  int pos = counters(idx-1,i);
  cu[pos] = node;
  counters(idx-1, i) = pos + 1;
}

//' Create a causal list from a DBN. This is the C++ backend of the function.
//' 
//' @param net a dbn object treated as a list of lists
//' @param size the size of the DBN
//' @param ordering a list with the order of the variables in t_0
//' @return a list with a CharacterVector and a NumericVector
// [[Rcpp::export]]
Rcpp::List create_causlist_cpp(Rcpp::List &net, unsigned int size, StringVector &ordering) {
  Rcpp::List aux;
  Rcpp::StringVector caus_unit;
  Rcpp::List cl(size - 1);
  std::string node;
  Rcpp::StringVector parents;
  Rcpp::NumericMatrix counters(size-1, ordering.size());
  Rcpp::List res(2);
  
  
  // Initialization of the causal list
  for(unsigned int i = 0; i < size - 1; i++){
    Rcpp::List caus_list(ordering.size());
    for(unsigned int j = 0; j < ordering.size(); j++){
      Rcpp::StringVector caus_unit(ordering.size());
      caus_list[j] = caus_unit;
    }
    cl[i] = caus_list;
  }
    
  // Translation into causal list
  for(unsigned int i = 0; i < ordering.size(); i++){
    node = ordering[i];
    aux = net[node];
    parents = aux["parents"];

    for(unsigned int j = 0; j < parents.size(); j++){
      node = parents[j];
      insert_node_cl(cl, node, counters, i);
    }
  }
  
  res[0] = cl;
  res[1] = counters;
  
  return res;
}

//' Create a matrix with the arcs defined in a causlist object
//' 
//' @param cl a causal list
//' @param ordering a list with the order of the variables in t_0
//' @param counters the number of elements in each causal unit of the causality list
//' @param rows number of arcs in the network
//' @return a list with a CharacterVector and a NumericVector
// [[Rcpp::export]]
Rcpp::CharacterMatrix cl_to_arc_matrix_cpp(Rcpp::List &cl, Rcpp::CharacterVector &ordering, 
                                       Rcpp::NumericMatrix &counters, unsigned int rows){
  Rcpp::StringMatrix res (rows, 2);
  unsigned int res_row = 0;
  Rcpp::List slice;
  Rcpp::StringVector cu;
  
  for(unsigned int i = 0; i < cl.size(); i++){
    slice = cl[i];
    for(unsigned int j = 0; j < ordering.size(); j++){
      cu = slice[j];
      for(unsigned int k = 0; k < counters(i, j); k++){
        res(res_row, 0) = cu[k];
        res(res_row, 1) = ordering[j];
        res_row += 1;
      }
    }
  }
  
  return res;
}

