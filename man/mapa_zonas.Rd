\name{mapa_zonas}
\alias{mapa_zonas}
\docType{data}
\title{
Mapa de Chile a nivel zonal
}
\description{
Contiene todas las zonas urbanas del territorio nacional indicando las divisiones
administrativas (comuna, provincia y region) a las que pertenecen.
}
\usage{mapa_zonas}
\format{
Un data frame con 4852 observaciones y cinco columnas.
  \describe{
    \item{\code{geocodigo}}{vector de texto}
    \item{\code{codigo_comuna}}{vector de texto}
    \item{\code{codigo_provincia}}{vector de texto}
    \item{\code{codigo_region}}{vector de texto}
    \item{\code{geometry}}{vector de poligonos}
  }
}
\source{
Elaboracion propia con base en datos de Instituto Nacional de Estadisticas (INE) y Subsecretaria de Desarrollo Regional (SUBDERE).
}
\examples{
mapa_zonas
}
\keyword{datasets}
