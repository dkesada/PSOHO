#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "utils.h"
#include "causality_list.h"

#ifndef vl_op
#define vl_op
Rcpp::List randomize_vl_cpp(Rcpp::List &vl, NumericVector &probs, int seed);
Rcpp::List pos_minus_pos_cpp(Rcpp::List &cl, Rcpp::List &ps, Rcpp::List &vl);
#endif