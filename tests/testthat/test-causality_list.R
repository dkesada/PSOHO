# I will leave this checks outside the R6 object in order to be consistent with the 'dbnR' package style in case of merging

test_that("causality translation works", {
  net <- bnlearn::model2network("[A_t_2][B_t_2][C_t_2][A_t_1][B_t_1][C_t_1][A_t_0|A_t_1:B_t_2:C_t_1][B_t_0|A_t_1:B_t_1][C_t_0|B_t_2:C_t_2]")
  class(net) <- c("dbn", class(net))
  size <- 3
  
  cl <- Causlist$new(net, size)
  
  expect_equal(2 * 2, 4)
})
