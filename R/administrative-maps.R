#' Mapa de Chile a nivel provincial
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @import sf
#' @importFrom rmapshaper ms_dissolve
#' @importFrom sf st_as_sf
#' @importFrom dplyr as_tibble inner_join select distinct
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_provincias()
#' @export
generar_provincias <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(st_as_sf(mapa), field = "codigo_provincia") %>%
    as_tibble() %>%
    inner_join(
      chilemapas::codigos_territoriales %>%
        select(!!sym("codigo_provincia"), !!sym("codigo_region")) %>%
        distinct(),
      by = "codigo_provincia"
    ) %>%
    select(!!sym("codigo_provincia"), !!sym("codigo_region"), !!sym("geometry"))
}

#' Mapa de Chile a nivel regional
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @importFrom sf st_as_sf
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_regiones()
#' @export
generar_regiones <- function(mapa = chilemapas::mapa_comunas) {
  ms_dissolve(st_as_sf(mapa), field = "codigo_region")
}

#' Mapa de Chile a nivel de servicios de salud
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom dplyr as_tibble inner_join
#' @importFrom rmapshaper ms_dissolve
#' @importFrom sf st_as_sf
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' generar_servicios_salud()
#' @export
generar_servicios_salud <- function(mapa = chilemapas::mapa_comunas) {
  mapa %>%
    merge(
      chilemapas::divisiones_salud %>%
        select(!!sym("codigo_servicio_salud"), !!sym("codigo_comuna")),
      by = "codigo_comuna"
    ) %>%
    st_as_sf() %>%
    ms_dissolve(field = "codigo_servicio_salud") %>%
    as_tibble() %>%
    inner_join(
      chilemapas::divisiones_salud %>%
        select(!!sym("codigo_servicio_salud"), !!sym("codigo_comuna")) %>%
        distinct() %>%
        inner_join(
          chilemapas::codigos_territoriales %>%
            select(!!sym("codigo_comuna"), !!sym("codigo_region"))
        ) %>%
        select(!!sym("codigo_servicio_salud"), !!sym("codigo_region")) %>%
        distinct(),
      by = "codigo_servicio_salud"
    ) %>%
    select(!!sym("codigo_servicio_salud"), !!sym("codigo_region"), !!sym("geometry"))
}
