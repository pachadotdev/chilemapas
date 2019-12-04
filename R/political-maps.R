#' Mapa de Chile a nivel de circunscripciones
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select distinct mutate rename arrange
#' @importFrom magrittr %>%
#' @importFrom stringr str_sub
#' @importFrom rlang sym
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' mapa_circunscripciones()
#' @export
mapa_circunscripciones <- function(mapa = chilemapas::mapa_comunas) {
  mapa %>%
    left_join(
      chilemapas::divisiones_electorales %>% select(!!sym("codigo_comuna"), !!sym("codigo_circunscripcion"))
    ) %>%
    ms_dissolve(field = "codigo_circunscripcion") %>%
    left_join(
      chilemapas::divisiones_electorales %>%
        select(!!sym("codigo_comuna"), !!sym("codigo_circunscripcion")) %>%
        distinct(!!sym("codigo_circunscripcion"), .keep_all = T) %>%
        mutate(codigo_comuna = str_sub(!!sym("codigo_comuna"), 1, 2)) %>%
        rename(codigo_region = !!sym("codigo_comuna"))
    ) %>%
    arrange(!!sym("codigo_region"))
}

#' Mapa de Chile a nivel de distritos
#' @description Este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select distinct mutate rename arrange
#' @importFrom magrittr %>%
#' @importFrom stringr str_sub
#' @importFrom rlang sym
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' mapa_distritos()
#' @export
mapa_distritos <- function(mapa = chilemapas::mapa_comunas) {
  mapa %>%
    left_join(
      chilemapas::divisiones_electorales %>% select(!!sym("codigo_comuna"), !!sym("codigo_distrito"))
    ) %>%
    ms_dissolve(field = "codigo_distrito") %>%
    left_join(
      chilemapas::divisiones_electorales %>%
        select(!!sym("codigo_comuna"), !!sym("codigo_distrito")) %>%
        distinct(!!sym("codigo_distrito"), .keep_all = T) %>%
        mutate(codigo_comuna = str_sub(!!sym("codigo_comuna"), 1, 2)) %>%
        rename(codigo_region = !!sym("codigo_comuna"))
    ) %>%
    arrange(!!sym("codigo_region"))
}
