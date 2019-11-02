# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")
source("data_processing/02_communes_map.R")

# Merge comunne shapes -----------------------------------------------------

province_attributes <- territorial_codes %>%
  select(province_id, province_name) %>%
  distinct() %>%
  arrange(province_id) %>%
  filter(!province_id  %in% 161:163)

province_attributes_id <- c(province_attributes$province_id, "084")
province_attributes_name <- c(province_attributes$province_name, "Nuble")

province_attributes_id_new <-  c(grep("^08", province_attributes$province_id, value = T, invert = T), paste0("0", 81:83), 161:163)
province_attributes_name_new <- c(grep("Concepcion|Arauco|Biobio|Nuble", province_attributes$province_name, value = T, invert = T), "Concepcion", "Arauco", "Biobio", "Diguillin", "Punilla", "Itata")

province_attributes_new <- tibble(
  province_attributes_id_new,
  province_attributes_name_new
)

provinces_map_file <- sprintf("%s/provinces_map.rda", data_dir)

if (!file.exists(provinces_map_file)) {
  provinces_map <- map(communes_map, ~aggregate_communes(.x, field = "province_id"))
  provinces_map <- map(provinces_map, match_province_codes)

  names(region_attributes_name_new) <- region_attributes_id_new
  provinces_map <- map2(provinces_map, sort(region_attributes_id_new), ~add_col(.x, .y, col = "region_id"))
  provinces_map <- map(provinces_map, ~move_cols(.x, aggregation = "province"))

  save(provinces_map, file = provinces_map_file, compress = "xz")
} else {
  load(provinces_map_file)
}

# Save as geo/topo json ---------------------------------------------------

map2(
  provinces_map,
  sprintf("%s/r%s.geojson", provinces_geojson_dir, sort(region_attributes_id_new)),
  save_as_geojson
)

map2(
  provinces_map,
  sprintf("%s/r%s.topojson", provinces_topojson_dir, sort(region_attributes_id_new)),
  save_as_topojson
)
