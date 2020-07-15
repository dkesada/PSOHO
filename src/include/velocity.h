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
Rcpp::List vel_plus_vel_cpp(Rcpp::List &vl1, Rcpp::List &vl2, int abs_op);
Rcpp::List cte_times_vel_cpp(const float k, Rcpp::List vl, unsigned int abs_op, unsigned int max_op);
#endif