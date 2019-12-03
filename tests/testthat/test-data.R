context("testthat.R")

test_that("chilemapas datasets can be loaded", {
  expect_is(chilemapas::mapa_comunas, "data.frame")
})
