#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "utils.h"

#ifndef cl_op
#define cl_op
Rcpp::List initialize_cl_cpp(StringVector &ordering, unsigned int size);
void insert_node_cl(Rcpp::List &cl, std::string node, unsigned int i);
#endif