# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")
source("data_processing/02_communes_map.R")

# Merge comuna shapes -----------------------------------------------------

regions_map_file <- sprintf("%s/regions_map.rda", data_dir)

if (!file.exists(regions_map_file)) {
  regions_map <- map(communes_map, ~aggregate_communes(.x, field = "region_id"))
  save(regions_map, file = regions_map_file, compress = "xz")
} else {
  load(regions_map_file)
}

# Save as geo/topo json ---------------------------------------------------

map2(
  regions_map,
  sprintf("%s/r%s.geojson", regions_geojson_dir, sort(region_attributes_id_new)),
  save_as_geojson
)

map2(
  regions_map,
  sprintf("%s/r%s.topojson", regions_topojson_dir, sort(region_attributes_id_new)),
  save_as_topojson
)
