\name{mapa_comunas}
\alias{mapa_comunas}
\docType{data}
\title{
Mapa de Chile a nivel comunal
}
\description{
Contiene todas las comunas del territorio nacional indicando las divisiones
administrativas (provincia y region) a las que pertenecen.
}
\usage{mapa_comunas}
\format{
Classes ‘sf’ and 'data.frame':	345 obs. of  4 variables:
 $ codigo_comuna   : chr  "01401" "01403" "01405" "01402" ...
 $ codigo_provincia: chr  "014" "014" "014" "014" ...
 $ codigo_region   : chr  "01" "01" "01" "01" ...
 $ geometry        :sfc_GEOMETRY of length 345; first list element: List of 1
  ..$ : num [1:593, 1:2] -68.9 -68.9 -69 -69.1 -69.2 ...
  ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
 - attr(*, "sf_column")= chr "geometry"
 - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA
  ..- attr(*, "names")= chr  "codigo_comuna" "codigo_provincia" "codigo_region"
}
\source{
Instituto Nacional de Estadisticas (INE)
Subsecretaria de Desarrollo Regional (SUBDERE)
}
\keyword{datasets}
