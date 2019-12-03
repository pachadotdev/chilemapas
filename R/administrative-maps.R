#' Mapa de Chile a nivel provincial
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @return un objeto de clase sf y data.frame, este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete
#' @examples
#' # mapa_provincias()
#' @export
mapa_provincias <- function() {
  ms_dissolve(chilemapas::mapa_comunas, field = "codigo_provincia") %>%
    left_join(
      chilemapas::codigos_territoriales %>% select(!!sym("codigo_provincia"), !!sym("codigo_region"))
    )
}

#' Mapa de Chile a nivel regional
#' @importFrom rmapshaper ms_dissolve
#' @return un objeto de clase sf y data.frame, este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete
#' @examples
#' # mapa_regiones()
#' @export
mapa_regiones <- function() {
  ms_dissolve(chilemapas::mapa_comunas, field = "codigo_region")
}
