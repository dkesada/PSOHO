test_that("causality translation works", {
  net <- bnlearn::model2network("[A_t_2][B_t_2][C_t_2][A_t_1][B_t_1][C_t_1][A_t_0|A_t_1:B_t_2:C_t_1][B_t_0|A_t_1:B_t_1][C_t_0|B_t_2:C_t_2]")
  class(net) <- c("dbn", class(net))
  size <- 3
  
  cl <- Causlist$new(net, size)
  res <- list(
    list(c("A_t_1", "C_t_1", ""),
         c("A_t_1", "B_t_1", ""),
         c("", "", "")),
    list(c("B_t_2", "", ""),
         c("", "", ""),
         c("B_t_2", "C_t_2", ""))
  )
  expect_equal(cl$get_causality_list(), res)
  expect_equal(cl$get_counters(), matrix(c(2,1,2,0,0,2), nrow = 2, ncol = 3))
})

test_that("random network generation works", {
  ordering <- c("A", "B", "C")
  size <- 3
  
  # TODO a seeded test.
  
  cl <- Causlist$new(NULL, size, ordering)
  
  
  res <- list(
    list(c("A_t_1", "C_t_1", ""),
         c("A_t_1", "B_t_1", ""),
         c("", "", "")),
    list(c("B_t_2", "", ""),
         c("", "", ""),
         c("B_t_2", "C_t_2", ""))
  )
  expect_equal(cl$get_causality_list(), res)
  expect_equal(cl$get_counters(), matrix(c(2,1,2,0,0,2), nrow = 2, ncol = 3))
})
