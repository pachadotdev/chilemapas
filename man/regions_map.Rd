\name{regions_map}
\alias{regions_map}
\docType{data}
\title{
Map of Chile at region level (new regions)
}
\description{
Contains all the regions in the nation's territory. This dataset
considers 16 regions.
}
\usage{regions_map}
\format{
List of 16

> str(regions_map[[1]])
Classes ‘sf’ and 'data.frame':	1 obs. of  3 variables:
 $ region_id  : chr "01"
 $ geometry   :sfc_POLYGON of length 1; first list element: List of 1
  ..$ : num [1:1653, 1:2] -70.1 -70.1 -70.1 -70.1 -70.1 ...
  ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA
  ..- attr(*, "names")= chr  "region_id" NA
}
\source{
Sistema Nacional de Informacion Municipal (SINIM), Subsecretaria de Desarrollo
Regional (SUBDERE) and Ministerio del Interior
}
\keyword{datasets}
