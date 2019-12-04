\name{divisiones_electorales}
\alias{divisiones_electorales}
\docType{data}
\title{
Divisiones electorales oficiales
}
\description{
Contiene las agrupaciones de las distintas comunas en circunscripciones
(eleccion de senadores) y distritos (eleccion de diputados) junto con la
cantidad de senadores y diputados que le corresponden a cada division
segun la legislacion vigente.
}
\usage{divisiones_electorales}
\format{
Un data frame con 346 observaciones y cinco columnas.
  \describe{
    \item{\code{codigo_comuna}}{vector de texto}
    \item{\code{codigo_circunscripcion}}{vector de texto}
    \item{\code{senadores_circunscripcion}}{vector numerico}
    \item{\code{codigo_distrito}}{vector de texto}
    \item{\code{diputados_distrito}}{vector numerico}
  }
}
\source{
Elaboracion propia con base en datos de Biblioteca del Congreso Nacional de Chile (BCN).
}
\examples{
divisiones_electorales
}
\keyword{datasets}
