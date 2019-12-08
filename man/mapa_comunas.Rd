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
Un data frame con 346 observaciones y cuatro columnas.
  \describe{
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
mapa_comunas
}
\keyword{datasets}
