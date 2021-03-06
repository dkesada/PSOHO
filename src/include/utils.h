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
int find_index(std::string node);
Rcpp::StringVector rename_slices(const Rcpp::StringVector &nodes, unsigned int slice);
Rcpp::List random_directions(const Rcpp::NumericVector &probs, unsigned int size);
int add_dirs(int d1, int d2, int &n_arcs);
Rcpp::NumericVector add_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_arcs);
int subtract_dirs(int d1, int d2, int &n_abs);
Rcpp::NumericVector subtract_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &n_abs);
int add_vel_dirs(int d1, int d2, int &abs_op);
Rcpp::NumericVector add_vel_dirs_vec(const NumericVector &d1, const NumericVector &d2, int &abs_op);
void locate_directions(Rcpp::List &vl, Rcpp::List &pool, int cmp, bool invert);
void modify_directions(Rcpp::List &vl, Rcpp::List &n_pool, int cmp);
#endif