#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#ifndef utils_op
#define utils_op

#include <regex>
#include <random>

int find_index(std::string node);
Rcpp::StringVector rename_nodes_cpp(Rcpp::StringVector &nodes, unsigned int size);
Rcpp::StringVector rename_slices(const Rcpp::StringVector &nodes, unsigned int slice);
Rcpp::List random_directions(const Rcpp::NumericVector &probs, unsigned int size, int seed);
int add_dirs(int d1, int d2, int &n_arcs);
Rcpp::NumericVector add_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_arcs);
#endif