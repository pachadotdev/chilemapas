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
    names(d) <- c("object_id",
                  "region_id", "province_id", "commune_id",
                  "region_name", "province_name", "commune_name",
                  "shape_length", "shape_area", "geometry")
  }

  if (unit == "block") {
    names(d) <- c("region_id", "province_id", "commune_id",
                  "district_id", "zone_id", "entity_id", "block_id",
                  "region_name", "province_name", "commune_name",
                  "geometry")
  }

  if (unit == "urban_limit") {
    names(d) <- c("region_id", "province_id", "commune_id",
                  "region_name", "province_name", "commune_name", "urban_name", "category_name",
                  "shape_length", "shape_area", "geometry")
  }

  # fix unofficial ids and asciify strings

  d2 <- tibble(
    commune_id = as.character(d$commune_id),
    province_id = as.character(d$province_id),
    region_id = as.character(d$region_id)
  ) %>%
    mutate(
      commune_id = ifelse(str_length(region_id) == 1, paste0("0", commune_id), commune_id),
      province_id = ifelse(str_length(region_id) == 1, paste0("0", province_id), province_id),
      region_id = ifelse(str_length(region_id) == 1, paste0("0", region_id), region_id)
    )

  d$commune_id <- d2$commune_id
  d$province_id <- d2$province_id
  d$region_id <- d2$region_id

  d$region_name <- iconv(d$region_name, to = "ASCII//TRANSLIT", sub = "")
  d$region_name <- str_replace_all(d$region_name, "[^[:alnum:]|[:space:]]", "")
  d$region_name <- str_to_title(d$region_name)

  d$province_name <- iconv(d$province_name, to = "ASCII//TRANSLIT", sub = "")
  d$province_name <- str_replace_all(d$province_name, "[^[:alnum:]|[:space:]]", "")
  d$province_name <- str_to_title(d$province_name)

  d$commune_name <- iconv(d$commune_name, to = "ASCII//TRANSLIT", sub = "")
  d$commune_name <- str_replace_all(d$commune_name, "[^[:alnum:]|[:space:]]", "")
  d$commune_name <- str_to_title(d$commune_name)

  if (unit == "urban_limit") {
    d$category_name <- str_to_title(d$category_name)
  }

  # fix titlecase

  d$region_name <- str_replace_all(d$region_name, " De ", " de ")
  d$region_name <- str_replace_all(d$region_name, " Del ", " del ")
  d$region_name <- str_replace_all(d$region_name, " La ", " la ")
  d$region_name <- str_replace_all(d$region_name, " Los ", " los ")
  d$region_name <- str_replace_all(d$region_name, " Y ", " y ")
  d$region_name <- str_replace_all(d$region_name, "Ohiggins", "OHiggins")

  d$province_name <- str_replace_all(d$province_name, " De ", " de ")
  d$province_name <- str_replace_all(d$province_name, " Del ", " del ")
  d$province_name <- str_replace_all(d$province_name, " La ", " la ")
  d$province_name <- str_replace_all(d$province_name, " Las ", " las ")
  d$province_name <- str_replace_all(d$province_name, " Los ", " los ")
  d$province_name <- str_replace_all(d$province_name, " Y ", " y ")
  d$province_name <- str_replace_all(d$province_name, "Ohiggins", "OHiggins")

  d$commune_name <- str_replace_all(d$commune_name, " De ", " de ")
  d$commune_name <- str_replace_all(d$commune_name, " Del ", " del ")
  d$commune_name <- str_replace_all(d$commune_name, " La ", " la ")
  d$commune_name <- str_replace_all(d$commune_name, " Las ", " las ")
  d$commune_name <- str_replace_all(d$commune_name, " Los ", " los ")
  d$commune_name <- str_replace_all(d$commune_name, " Y ", " y ")
  d$commune_name <- str_replace_all(d$commune_name, "Ohiggins", "OHiggins")

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
    if (aggregation == "region") {
      x <- x[,c("region_id", "geometry")]
    }
    if (aggregation == "province") {
      x <- x[,c("province_id", "region_id", "geometry")]
    }
    if (aggregation == "commune") {
      x <- x[,c("commune_id", "commune_name", "province_id", "province_name", "region_id", "region_name", "geometry")]
    }
    if (aggregation == "block") {
      x <- x[,c("block_id", "commune_id", "commune_name", "province_id", "province_name", "region_id", "region_name", "geometry")]
    }
  } else {
    stop()
  }

  return(x)
}
