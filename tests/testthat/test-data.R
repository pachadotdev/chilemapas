context("testthat.R")

test_that("chilemaps datasets can be loaded", {
  expect_is(chilemaps::mapa_coomunas[[15]], "data.frame")
})
