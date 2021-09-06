\name{codigos_territoriales_16r}
\alias{codigos_territoriales_16r}
\docType{data}
\title{
Codigos oficiales de comunas, provincias y regiones con 15 y 16 regiones
}
\description{
Contiene la conversion de los codigos oficiales de SUBDERE de 15 regiones a 16
regiones tras la creacion de la region de Niuble. Los nombres de las comunas
fueron convertidos a ASCII para evitar problemas de codificacion.
}
\usage{codigos_territoriales_16r}
\format{
Un data frame con 21 observaciones y tres columnas.
  \describe{
    \item{\code{codigo_comuna}}{vector de texto}
    \item{\code{codigo_comuna+16r}}{vector de texto}
    \item{\code{nombre_comuna}}{vector de texto}
  }
}
\source{
Elaboracion propia con base en datos de Subsecretaria de Desarrollo Regional
(SUBDERE) y CENSO 2017 (INE).
}
\examples{
codigos_territoriales_16r
}
\keyword{datasets}
