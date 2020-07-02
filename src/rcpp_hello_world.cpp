#include <Rcpp.h>
using namespace Rcpp;

//' Dummy rcpp function
//' 
//' @return a list with a CharacterVector and a NumericVector
// [[Rcpp::export]]
List rcpp_hello_world() {

    CharacterVector x = CharacterVector::create( "foo", "bar" )  ;
    NumericVector y   = NumericVector::create( 0.0, 1.0 ) ;
    List z            = List::create( x, y ) ;

    return z ;
}
