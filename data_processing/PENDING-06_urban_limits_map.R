# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")
source("data_processing/02_communes_map.R")

# Tidy raw urban_limits -------------------------------------------------------

urban_limits_map_shp <- list.files(path = maps_raw_dir, pattern = "LUC.shp$", recursive = T, full.names = T)

old_simplified_urban_limits_map_file <- sprintf("%s/old_simplified_urban_limits_map.rda", data_dir)

if (!file.exists(old_simplified_urban_limits_map_file)) {
  old_simplified_urban_limits_map <- map(urban_limits_map_shp, ~tidy_sf(.x, simplify = TRUE, unit = "urban_limit"))
  old_simplified_urban_limits_map <- map2(old_simplified_urban_limits_map, region_attributes_id, ~add_col(.x, .y, col = "region_id"))
  old_simplified_urban_limits_map <- map2(old_simplified_urban_limits_map, region_attributes_name, ~add_col(.x, .y, col = "region_name"))
  save(old_simplified_urban_limits_map, file = old_simplified_urban_limits_map_file, compress = "xz")
} else {
  load(old_simplified_urban_limits_map_file)
}

# Save tidy urban_limits as geo/topo json -------------------------------------

map2(
  old_simplified_urban_limits_map,
  sprintf("%s/r%s.geojson", simplified_urban_limits_geojson_old_dir, region_code_old),
  save_as_geojson
)

map2(
  old_simplified_urban_limits_map,
  sprintf("%s/r%s.topojson", simplified_urban_limits_topojson_old_dir, region_code_old),
  save_as_topojson
)

# Create new Bio Bio and Nuble map ----------------------------------------

new_simplified_urban_limits_map_file <- sprintf("%s/new_simplified_urban_limits_map.rda", data_dir)

if (!file.exists(new_simplified_urban_limits_map_file)) {
  old_simplified_urban_limits_map_r08 <- old_simplified_urban_limits_map[[8]]

  old_simplified_urban_limits_map_bio_bio <- subset(old_simplified_urban_limits_map_r08, province_id != "084")

  old_simplified_urban_limits_map_nuble <- subset(old_simplified_urban_limits_map_r08, province_id == "084")

  d_old_simplified_urban_limits_map_bio_bio <- tibble(commune_name = old_simplified_urban_limits_map_bio_bio$commune_name) %>%
    select(commune_name) %>%
    left_join(new_territorial_codes) %>%
    select(-commune_name, everything())

  d_old_simplified_urban_limits_map_nuble <- tibble(commune_name = old_simplified_urban_limits_map_nuble$commune_name) %>%
    select(commune_name) %>%
    left_join(new_territorial_codes) %>%
    select(-commune_name, everything())

  old_simplified_urban_limits_map_bio_bio <- old_simplified_urban_limits_map_bio_bio %>%
    mutate(
      region_id = d_old_simplified_urban_limits_map_bio_bio$region_id,
      province_id = d_old_simplified_urban_limits_map_bio_bio$province_id,
      commune_id = d_old_simplified_urban_limits_map_bio_bio$commune_id,

      region_name = d_old_simplified_urban_limits_map_bio_bio$region_name,
      province_name = d_old_simplified_urban_limits_map_bio_bio$province_name,
      commune_name = d_old_simplified_urban_limits_map_bio_bio$commune_name
    )

  old_simplified_urban_limits_map_nuble <- old_simplified_urban_limits_map_nuble %>%
    mutate(
      region_id = d_old_simplified_urban_limits_map_nuble$region_id,
      province_id = d_old_simplified_urban_limits_map_nuble$province_id,
      commune_id = d_old_simplified_urban_limits_map_nuble$commune_id,

      region_name = d_old_simplified_urban_limits_map_nuble$region_name,
      province_name = d_old_simplified_urban_limits_map_nuble$province_name,
      commune_name = d_old_simplified_urban_limits_map_nuble$commune_name
    )

  new_simplified_urban_limits_map <- old_simplified_urban_limits_map[-8]
  new_simplified_urban_limits_map[[length(new_simplified_urban_limits_map) + 1]] <- old_simplified_urban_limits_map_bio_bio
  new_simplified_urban_limits_map[[length(new_simplified_urban_limits_map) + 1]] <- old_simplified_urban_limits_map_nuble

  save(new_simplified_urban_limits_map, file = new_simplified_urban_limits_map_file, compress = "xz")
} else{
  load(new_simplified_urban_limits_map_file)
}

map2(
  new_simplified_urban_limits_map,
  sprintf("%s/r%s.geojson", simplified_urban_limits_geojson_new_dir, region_attributes_id_new),
  save_as_geojson
)

map2(
  new_simplified_urban_limits_map,
  sprintf("%s/r%s.topojson", simplified_urban_limits_topojson_new_dir, region_attributes_id_new),
  save_as_topojson
)
