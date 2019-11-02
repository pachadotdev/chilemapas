\name{provinces_map}
\alias{provinces_map}
\docType{data}
\title{
Map of Chile at province level (new regions)
}
\description{
Contains all the provices in the nation's territory indicating the
administrative division (region) where they belong. This dataset
considers 16 regions.
}
\usage{provinces_map}
\format{
List of 16

> str(provinces_map[[1]])
Classes ‘sf’ and 'data.frame':	2 obs. of  5 variables:
 $ province_id  : chr  "011" "014"
 $ region_id    : chr  "01" "01"
 $ geometry     :sfc_POLYGON of length 2; first list element: List of 1
  ..$ : num [1:528, 1:2] -70.1 -70 -70 -69.9 -69.9 ...
  ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA
  ..- attr(*, "names")= chr  "province_id" "province_name" NA NA
}
\source{
Sistema Nacional de Informacion Municipal (SINIM), Subsecretaria de Desarrollo
Regional (SUBDERE) and Ministerio del Interior
}
\keyword{datasets}
