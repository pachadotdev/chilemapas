\name{health_service_map}
\alias{health_service_map}
\docType{data}
\title{
Map of Chile at health service level (new regions)
}
\description{
Contains all the health services in the nation's territory indicating the
administrative division (region) where they belong. This dataset
considers 16 regions.
}
\usage{health_service_map}
\format{
List of 16

> str(health_service_map[[1]])
Classes ‘sf’ and 'data.frame':	1 obs. of  3 variables:
 $ health_service_id: chr "02"
 $ region_id        : chr "01"
 $ geometry         :sfc_POLYGON of length 1; first list element: List of 1
  ..$ : num [1:1653, 1:2] -70.1 -70.1 -70.1 -70.1 -70.1 ...
  ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA
  ..- attr(*, "names")= chr  "health_service_id" "region_id"
}
\source{
Subsecretaria de Desarrollo Regional (SUBDERE) and
Infraestructura de Datos Geoespaciales Chile (IDE Chile)
}
\keyword{datasets}
