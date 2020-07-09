#include "include/utils.h"

//' Return a list of nodes with the time slice appended up to the desired size
//' of the network
//' 
//' @param nodes a list with the names of the nodes in the network
//' @param size the size of the DBN
//' @return a list with the renamed nodes in each timeslice
// [[Rcpp::export]]
Rcpp::StringVector rename_nodes_cpp(Rcpp::StringVector &nodes, unsigned int size){
  Rcpp::StringVector res (nodes.size() * size);
  std::string new_name;
  
  for(unsigned int i = 0; i < size; i++){
    for(unsigned int j = 0; j < nodes.size(); j++){
      new_name = nodes[j];
      res[i*3+j] = new_name + "_t_" + std::to_string(size-1-i); // Random network generation works better with t_0 at the end 
    }
  }
  
  return res;
}

// Return the time slice of a node
// 
// @param node a string with the name of the node
// @return an integer with the time slice that the node belongs to
int find_index(std::string node){
  std::smatch m;
  int res;
  
  std::regex_match(node, m, std::regex(".*?([0-9]+)$"));
  res = std::stoi(m.str(m.size() - 1));
  
  return res;
}

// Modify the names of the nodes to the desired timeslice
// 
// @param nodes a string vector with the names of the nodes
// @param slice the new slice of the nodes
// @return an integer with the time slice that the node belongs to
Rcpp::StringVector rename_slices(Rcpp::StringVector nodes, unsigned int slice){
  std::smatch m;
  std::string new_name;
  Rcpp::StringVector res (nodes.size());
  
  for(unsigned int i = 0; i < nodes.size(); i++){
    new_name = nodes[i];
    std::regex_match(new_name, m, std::regex("(.+_t_)([0-9]+)"));
    new_name = m[1];
    new_name = new_name + std::to_string(slice);
    res[i] = new_name;
  }
  
  return(res);
}


