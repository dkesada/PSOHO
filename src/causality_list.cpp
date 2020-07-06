#include <Rcpp.h>
using namespace Rcpp;
#include "include/causality_list.h"

// Return the time slice of a node
int find_index(std::string node){
  std::smatch m;
  int res;
  
  std::regex_match(node, m, std::regex(".*?([0-9]+)$"));
  res = std::stoi(m.str(m.size() - 1));
  
  return res;
}

// Insert a node in the correspondent causal unit. Keeps record of inserted
// elements in each causal unit
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
List create_causlist_cpp(Rcpp::List &net, unsigned int size, StringVector &ordering) {
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




