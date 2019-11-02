\name{communes_map}
\alias{communes_map}
\docType{data}
\title{
Map of Chile at commune level (new regions)
}
\description{
Contains all the communes in the nation's territory indicating the
administrative division (province and region) where they belong. This dataset
considers 16 regions.
}
\usage{communes_map}
\format{
List of 16

> str(communes_map[[1]])
Classes ‘sf’ and 'data.frame':	7 obs. of  9 variables:
 $ region_id    : chr  "01" "01" "01" "01" ...
 $ province_id  : chr  "011" "014" "011" "014" ...
 $ commune_id   : chr  "01107" "01404" "01101" "01401" ...
 $ geometry     :sfc_POLYGON of length 7; first list element: List of 1
  ..$ : num [1:30, 1:2] -70.1 -70.1 -70.1 -70.1 -70.1 ...
  ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA NA NA NA
  ..- attr(*, "names")= chr  "region_id" "province_id" "commune_id" "region_name" ...
}
\source{
Sistema Nacional de Informacion Municipal (SINIM), Subsecretaria de Desarrollo
Regional (SUBDERE) and Ministerio del Interior
}
\keyword{datasets}
