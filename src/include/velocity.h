#ifndef Rcpp_head
#define Rcpp_head
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "utils.h"

#ifndef vl_op
#define vl_op
Rcpp::List initialize_vl_cpp(StringVector &ordering, unsigned int size);
#endif