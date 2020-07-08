#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "utils.h"

#ifndef cl_op
#define cl_op
int find_index(std::string node);
void insert_node_cl(Rcpp::List &cl, std::string node, Rcpp::NumericMatrix &counters, unsigned int i);
Rcpp::List create_causlist_cpp(Rcpp::List &net, unsigned int size, StringVector &ordering);
Rcpp::CharacterMatrix cl_to_arc_matrix_cpp(Rcpp::List &cl, Rcpp::CharacterVector &ordering, 
                                           Rcpp::NumericMatrix &counters, unsigned int rows);
#endif

