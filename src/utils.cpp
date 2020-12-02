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
      res[i*nodes.size()+j] = new_name + "_t_" + std::to_string(size-1-i); // Random network generation works better with t_0 at the end 
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
Rcpp::List random_directions(const Rcpp::NumericVector &probs, unsigned int size){
  Rcpp::NumericVector res_n (size);
  NumericVector base = {-1,0,1};
  unsigned int abs_op = 0;
  Rcpp::List res (2);
  
  for(unsigned int i = 0; i < size; i++){
    NumericVector dir = sample(base, 1, true, probs);
    int dir_val = dir[0];
    res_n[i] = dir_val;
    abs_op += std::abs(dir_val);
  }
  
  res[0] = res_n;
  res[1] = abs_op;
  
  return res;
}

// Add two directions whose value has to be in the set {-1,0,1}
// 
// @param d1 first direction
// @param d2 second direction
// @param n_arcs the number of arcs present in the resulting causal list
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
// @param d1 first NumericVector direction
// @param d2 second NumericVector direction
// @param n_arcs the number of arcs present in the resulting causal list
// @return the result of adding them
Rcpp::NumericVector add_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_arcs){
  Rcpp::NumericVector res (d1.size());
  
  for(unsigned int i = 0; i < d1.size(); i++){
    res[i] = add_dirs(d1[i], d2[i], n_arcs);
  }
  
  return res;
}

// Subtract two directions whose value has to be in the set {-1,0,1}
// 
// @param d1 first direction
// @param d2 second direction
// @param n_arcs the number of arcs operations present in the resulting Velocity
// @return the result of subtracting them
int subtract_dirs(int d1, int d2, int &n_abs){
  int res = d1 - d2;
  
  if(d1 != d2)
    n_abs++;
  
  return res;
}

// Subtract two directions vectors whose value has to be in the set {-1,0,1}
// 
// @param d1 first NumericVector direction
// @param d2 second NumericVector direction
// @param n_arcs the number of arcs operations present in the resulting Velocity
// @return the result of subtracting them
Rcpp::NumericVector subtract_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_abs){
  Rcpp::NumericVector res (d1.size());
  
  for(unsigned int i = 0; i < d1.size(); i++){
    res[i] = subtract_dirs(d1[i], d2[i], n_abs);
  }
  
  return res;
}

// Add two velocity directions whose value has to be in the set {-1,0,1}
// 
// @param d1 first direction
// @param d2 second direction
// @param abs_op the number of {1,-1} operations present in the resulting Velocity
// @return the result of adding them
int add_vel_dirs(int d1, int d2, int &abs_op){
  int res = d1 + d2;
  
  if(res < -1)
    res = -1;
  else if(res > 1)
    res = 1;
  
  if(res > d1 && res == 1)
    abs_op++;
  else if(res > d1 && res == 0)
    abs_op--;
  else if(res < d1 && res == 0)
    abs_op--;
  else if(res < d1 && res == -1)
    abs_op++;
  
  return res;
}

// Subtract two directions vectors whose value has to be in the set {-1,0,1}
// 
// @param d1 first NumericVector direction
// @param d2 second NumericVector direction
// @param abs_op the number of {1,-1} operations present in the resulting Velocity
// @return the result of adding them
Rcpp::NumericVector add_vel_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &abs_op){
  Rcpp::NumericVector res (d1.size());
  
  for(unsigned int i = 0; i < d1.size(); i++){
    res[i] = add_vel_dirs(d1[i], d2[i], abs_op);
  }
  
  return res;
}

// Find the position of 0's or 1's in a Velocity's causality list
// 
// @param vl the Velocity's causality list
// @param pool the list with the positions
// @param cmp the direction to be searched, either 0 or 1 
// @return a list with the Velocity's new causal list and number of operations
void locate_directions(Rcpp::List &vl, Rcpp::List &pool, int cmp, bool invert){
  Rcpp::List slice, cu, pair;
  Rcpp::NumericVector dirs;
  unsigned int pool_i = 0;
  
  for(unsigned int i = 0; i < vl.size(); i++){
    slice = vl[i];
    
    for(unsigned int j = 0; j < slice.size(); j++){
      pair = slice[j];
      dirs = pair[1];
      
      for(unsigned int k = 0; k < dirs.size(); k++){
        if(invert)
          dirs[k] = -dirs[k];
        if(std::abs(dirs[k]) == cmp){
          Rcpp::NumericVector pool_res (3);
          pool_res[0] = i;
          pool_res[1] = j;
          pool_res[2] = k;
          pool[pool_i++] = pool_res;
        }
      }
    }
  }
}

// Modify the 0's or 1's in the given positons of a Velocity's causality list
// 
// @param vl the Velocity's causality list
// @param n_pool the list with the positions
// @param cmp the direction to be searched, either 0 or 1 
// @return a list with the Velocity's new causal list and number of operations
void modify_directions(Rcpp::List &vl, Rcpp::List &n_pool, int cmp){
  Rcpp::List slice, pair;
  Rcpp::NumericVector tuple, dirs;
  unsigned int idx;
  NumericVector base = {-1,1};
  NumericVector rand (1);
  
  for(unsigned int i = 0; i < n_pool.size(); i++){
    tuple = n_pool[i];
    idx = tuple[0];
    slice = vl[idx];
    idx = tuple[1];
    pair = slice[idx];
    dirs = pair[1];
    idx = tuple[2];

    if(cmp == 0){
      rand = sample(base, 1, false);
      dirs(idx) = rand[0];
    }

    else
      dirs(idx) = 0.0;
  }
}