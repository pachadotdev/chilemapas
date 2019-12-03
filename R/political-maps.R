#' Mapa de Chile a nivel de circunscripciones
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select distinct mutate rename arrange
#' @importFrom magrittr %>%
#' @importFrom stringr str_sub
#' @importFrom rlang sym
#' @return un objeto de clase sf y data.frame, este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete
#' @examples
#' # mapa_circunscripciones()
#' @export
mapa_circunscripciones <- function() {
  chilemapas::mapa_comunas %>%
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
#' @importFrom rmapshaper ms_dissolve
#' @importFrom dplyr left_join select distinct mutate rename arrange
#' @importFrom magrittr %>%
#' @importFrom stringr str_sub
#' @importFrom rlang sym
#' @return un objeto de clase sf y data.frame, este mapa es calculado a partir
#' del mapa comunal para no recargar el volumen de datos del paquete
#' @examples
#' # mapa_distritos()
#' @export
mapa_distritos <- function() {
  chilemapas::mapa_comunas %>%
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
