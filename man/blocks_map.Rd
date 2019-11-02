\name{blocks_map}
\alias{blocks_map}
\docType{data}
\title{
Map of Chile at block level (new regions)
}
\description{
Contains all the urban blocks in the nation's territory indicating the
administrative division (commune, province and region) where they belong.
This dataset considers 16 regions.
}
\usage{communes_map}
\format{
List of 16

> str(blocks_map[[1]])
Classes ‘sf’ and 'data.frame':	3044 obs. of  5 variables:
 $ block_id   : chr  "01107011002002" "01107011002014" "01107011002019" "01107011002020" ...
 $ commune_id : chr  "01107" "01107" "01107" "01107" ...
 $ province_id: chr  "011" "011" "011" "011" ...
 $ region_id  : chr  "01" "01" "01" "01" ...
 $ geometry   :sfc_MULTIPOLYGON of length 3044; first list element: List of 1
  ..$ :List of 1
  .. ..$ : num [1:29, 1:2] -70.1 -70.1 -70.1 -70.1 -70.1 ...
  ..- attr(*, "class")= chr  "XY" "MULTIPOLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA
  ..- attr(*, "names")= chr  "block_id" "commune_id" "province_id" "region_id"
}
\source{
Sistema Nacional de Informacion Municipal (SINIM), Subsecretaria de Desarrollo
Regional (SUBDERE) and Ministerio del Interior
}
\keyword{datasets}
