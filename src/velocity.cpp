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
  
  // TODO
  
  // Rcpp::List aux;
  
  // Rcpp::List cl(size - 1);
  // std::string node;
  // Rcpp::StringVector parents;
  // Rcpp::NumericMatrix counters(size-1, ordering.size());
  // Rcpp::List res(2);
  // 
  // 
  // Initialization of the causal list
  // for(unsigned int i = 0; i < size - 1; i++){
  //   Rcpp::List caus_list(ordering.size());
  //   new_names = rename_slices(ordering, i + 1);
  //   for(unsigned int j = 0; j < ordering.size(); j++){
  //     Rcpp::StringVector caus_unit(ordering.size());
  //     caus_list[j] = caus_unit;
  //   }
  //   cl[i] = caus_list;
  // }
  
  return res;
}

