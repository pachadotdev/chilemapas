#' Mapa de Chile a nivel provincial
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @import sf
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr as_tibble left_join select
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_provincias()
#' @export
generar_provincias <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(mapa, field = "codigo_provincia") %>%
    as_tibble() %>%
    left_join(
      chilemapas::codigos_territoriales %>% select(!!sym("codigo_provincia"), !!sym("codigo_region")),
      by = "codigo_provincia"
    )
}

#' Mapa de Chile a nivel regional
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_regiones()
#' @export
generar_regiones <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(mapa, field = "codigo_region")
}

#' Mapa de Chile a nivel de servicios de salud
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom dplyr as_tibble left_join
#' @importFrom rmapshaper ms_dissolve
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_servicios_salud()
#' @export
generar_servicios_salud <- function(mapa = chilemapas::mapa_comunas) {
  mapa %>%
    merge(
      chilemapas::divisiones_salud,
      all.x = TRUE
    ) %>%
    ms_dissolve(field = "codigo_servicio_salud") %>%
    as_tibble()
}
