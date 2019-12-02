context("testthat.R")

test_that("chilemaps datasets can be loaded", {
  expect_is(chilemaps::regions_map[[14]], "data.frame")
})
