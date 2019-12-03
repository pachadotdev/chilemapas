if (!require("pacman")) { install.packages("pacman") }
pacman::p_load(sf, rmapshaper, geojsonio, dplyr, tidyr, purrr, stringr, data.table, readxl, janitor, xml2, rvest)

download_file <- function(x,y) {
  if (!file.exists(y)) {
    try(download.file(url = x, destfile = y, method = "wget", quiet = TRUE))
  }
}

extract <- function(x,y) {
  system(sprintf("7z x -aos %s -oc:%s", x, y))
}

# geodata custom functions ------------------------------------------------

tidy_sf <- function(x, simplify = TRUE, unit = "commune", keep = 0.05) {
  d <- sf::read_sf(x)

  if (simplify == TRUE) {
    d <- rmapshaper::ms_simplify(d, keep = keep)
  }

  if (unit == "commune") {
    names(d) <- c("codigo_region", "nombre_region", "codigo_provincia",
                  "nombre_provincia", "codigo_comuna", "nombre_comuna",
                  "shape_length", "shape_area", "geometry")
  }

  # fix unofficial ids and asciify strings

  d2 <- tibble(
    codigo_comuna = as.character(d$codigo_comuna),
    codigo_provincia = as.character(d$codigo_provincia),
    codigo_region = as.character(d$codigo_region)
  ) %>%
    mutate(
      codigo_comuna = ifelse(str_length(codigo_comuna) == 1, paste0("0", codigo_comuna), codigo_comuna),
      codigo_provincia = ifelse(str_length(codigo_provincia) == 1, paste0("0", codigo_provincia), codigo_provincia),
      codigo_region = ifelse(str_length(codigo_region) == 1, paste0("0", codigo_region), codigo_region)
    )

  d$codigo_comuna <- d2$codigo_comuna
  d$codigo_provincia <- d2$codigo_provincia
  d$codigo_region <- d2$codigo_region

  d$nombre_region <- iconv(d$nombre_region, to = "ASCII//TRANSLIT", sub = "")
  d$nombre_region <- str_replace_all(d$nombre_region, "[^[:alnum:]|[:space:]]", "")
  d$nombre_region <- str_to_title(d$nombre_region)

  d$nombre_provincia <- iconv(d$nombre_provincia, to = "ASCII//TRANSLIT", sub = "")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, "[^[:alnum:]|[:space:]]", "")
  d$nombre_provincia <- str_to_title(d$nombre_provincia)

  d$nombre_comuna <- iconv(d$nombre_comuna, to = "ASCII//TRANSLIT", sub = "")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, "[^[:alnum:]|[:space:]]", "")
  d$nombre_comuna <- str_to_title(d$nombre_comuna)

  # fix titlecase

  d$nombre_region <- str_replace_all(d$nombre_region, " De ", " de ")
  d$nombre_region <- str_replace_all(d$nombre_region, " Del ", " del ")
  d$nombre_region <- str_replace_all(d$nombre_region, " La ", " la ")
  d$nombre_region <- str_replace_all(d$nombre_region, " Los ", " los ")
  d$nombre_region <- str_replace_all(d$nombre_region, " Y ", " y ")
  d$nombre_region <- str_replace_all(d$nombre_region, "Ohiggins", "OHiggins")

  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " De ", " de ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " Del ", " del ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " La ", " la ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " Las ", " las ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " Los ", " los ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, " Y ", " y ")
  d$nombre_provincia <- str_replace_all(d$nombre_provincia, "Ohiggins", "OHiggins")

  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " De ", " de ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " Del ", " del ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " La ", " la ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " Las ", " las ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " Los ", " los ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, " Y ", " y ")
  d$nombre_comuna <- str_replace_all(d$nombre_comuna, "Ohiggins", "OHiggins")

  return(d)
}

save_as_geojson <- function(x,y) {
  if (!file.exists(y)) {
    x <- x %>% select(ends_with("_id"), geometry)
    sf::write_sf(x, dsn = y, driver = "GeoJSON")
  }
}

save_as_topojson <- function(x,y) {
  if (!file.exists(y)) {
    geojsonio::topojson_write(
      input = x %>% select(ends_with("_id"), geometry),
      file = y,
      object_name = str_replace_all(y,".*[:alnum:]/|.geojson|.topojson", ""),
      overwrite = F
    )
  }
}

aggregate_communes <- function(x, field = NULL) {
  d <- rmapshaper::ms_dissolve(x, field)
  return(d)
}

subset_by_province <- function(x, y) {
  d <- subset(y, province_id == x)
  return(d)
}

match_province_codes <- function(x) {
  d <- x
  d2 <- tibble(province_attributes_id_new = d$province_id) %>% left_join(province_attributes_new)
  d$province_name <- d2$province_attributes_name_new
  return(d)
}

add_col <- function(x,y,col) {
  x[, col] <- y
  x <- x[,!names(x) %in% "rmapshaperid"]
  return(x)
}

remove_col <- function(x,col) {
  x <- dplyr::select(x,-col)
  return(x)
}

move_cols <- function(x, aggregation = "region") {
  if (aggregation %in% c("region", "province", "commune", "block")) {
    # if (aggregation == "region") {
    #   x <- x[,c("region_id", "geometry")]
    # }
    # if (aggregation == "province") {
    #   x <- x[,c("province_id", "region_id", "geometry")]
    # }
    if (aggregation == "commune") {
      x <- x[,c("codigo_comuna", "nombre_comuna", "codigo_provincia", "nombre_provincia", "codigo_region", "nombre_region", "geometry")]
    }
    # if (aggregation == "block") {
    #   x <- x[,c("block_id", "commune_id", "commune_name", "province_id", "province_name", "region_id", "region_name", "geometry")]
    # }
  } else {
    stop()
  }

  return(x)
}

leading_zeroes <- function(d) {
  d <- d
  d$codigo_region <- str_pad(d$codigo_region, 2, "left", "0")
  d$codigo_provincia <- str_pad(d$codigo_provincia, 3, "left", "0")
  d$codigo_comuna <- str_pad(d$codigo_comuna, 5, "left", "0")
  return(d)
}
