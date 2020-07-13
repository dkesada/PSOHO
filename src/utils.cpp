#include "include/utils.h"

//' Return a list of nodes with the time slice appended up to the desired size
//' of the network
//' 
//' @param nodes a list with the names of the nodes in the network
//' @param size the size of the DBN
//' @return a list with the renamed nodes in each timeslice
// [[Rcpp::export]]
Rcpp::StringVector rename_nodes_cpp(const Rcpp::StringVector &nodes, unsigned int size){
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
Rcpp::StringVector rename_slices(const Rcpp::StringVector &nodes, unsigned int slice){
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
  
  return res;
}

// Generate a random vector of n {-1,0,1} directions
// 
// @param probs the weights of each value in the random generation
// @param size the number of random directions to generate
// @return a NumericVector with the random directions
Rcpp::List random_directions(const Rcpp::NumericVector &probs, unsigned int size, int seed){
  Rcpp::NumericVector res_n (size);
  static std::random_device rd;
  static std::mt19937 gen(rd());
  std::discrete_distribution<int> distribution (probs.begin(), probs.end());
  int base[3] = {-1,0,1};
  unsigned int abs_op = 0;
  Rcpp::List res (2);
  
  if(seed > 0)
    gen.seed(seed);
  
  
  for(unsigned int i = 0; i < size; i++){
    int dir = distribution(gen);
    res_n[i] = base[dir];
    abs_op += std::abs(base[dir]);
  }
  
  res[0] = res_n;
  res[1] = abs_op;
  
  return res;
}

// Add two directions whose value has to be in the set {-1,0,1}
// 
// @param d1 first direction
// @param d2 second direction
// @return the result of adding them
int add_dirs(int d1, int d2, int &n_arcs){
  int res = d1 + d2;
  
  if(res < 0)
    res = 0;
  else if(res > 1)
    res = 1;
  
  if(res > d1)
    n_arcs++;
  else if(res < d1)
    n_arcs--;
  
  return res;
}

// Add two directions vectors whose value has to be in the set {-1,0,1}
// 
// @param v1 first NumericVector direction
// @param v2 second NumericVector direction
// @return the result of adding them
Rcpp::NumericVector add_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_arcs){
  Rcpp::NumericVector res (d1.size());
  
  for(unsigned int i = 0; i < d1.size(); i++){
    res[i] = add_dirs(d1[i], d2[i], n_arcs);
  }
  
  return res;
}
