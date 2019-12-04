#' Mapa de Chile a nivel provincial
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @import sf
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' mapa_provincias()
#' @export
mapa_provincias <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(mapa, field = "codigo_provincia") %>%
    left_join(
      chilemapas::codigos_territoriales %>% select(!!sym("codigo_provincia"), !!sym("codigo_region"))
    )
}

#' Mapa de Chile a nivel regional
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' mapa_regiones()
#' @export
mapa_regiones <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(mapa, field = "codigo_region")
}

#' Mapa de Chile a nivel de servicios de salud
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom dplyr left_join
#' @importFrom rmapshaper ms_dissolve
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' mapa_salud()
#' @export
mapa_salud <- function(mapa = chilemapas::mapa_comunas) {
  mapa %>%
    left_join(chilemapas::divisiones_salud) %>%
    ms_dissolve(field = "codigo_servicio_salud")
}
