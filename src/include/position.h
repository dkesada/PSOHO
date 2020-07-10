#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "utils.h"
#include "causality_list.h"

#ifndef ps_op
#define ps_op
Rcpp::List create_causlist_cpp(Rcpp::List &cl, Rcpp::List &net, unsigned int size, StringVector &ordering);
Rcpp::CharacterMatrix cl_to_arc_matrix_cpp(Rcpp::List &cl, Rcpp::CharacterVector &ordering, unsigned int rows);
#endif

