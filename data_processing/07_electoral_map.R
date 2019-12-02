# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")

# Circumscription ---------------------------------------------------------

regions <- 1:16
regions <- ifelse(nchar(regions) == 1, paste0("0",regions), regions)

circumscription_map_file <- sprintf("%s/electoral_circumscription_map.rda", data_dir)

if (!file.exists(circumscription_map_file)) {
  load(sprintf("%s/electoral_division.rda", data_dir))
  load(sprintf("%s/communes_map.rda", data_dir))
  load(sprintf("%s/regions_map.rda", data_dir))
  load(sprintf("%s/territorial_codes.rda", data_dir))

  electoral_circumscription_map <- map(
    seq_along(communes_map),
    function(x) {
      communes_map[[x]] %>%
        left_join(electoral_division, by = "commune_id")
    }
  )

  electoral_circumscription_map <- map(electoral_circumscription_map, ~aggregate_communes(.x, field = "circumscription_id"))

  electoral_circumscription_map <- map(
    seq_along(electoral_circumscription_map),
    function(x) {
      electoral_circumscription_map[[x]] %>%
        left_join(
          electoral_division %>%
            select(commune_id, circumscription_id) %>%
            left_join(
              territorial_codes %>%
                select(commune_id, region_id)
            ) %>%
            select(circumscription_id, region_id) %>%
            distinct(),
        by = "circumscription_id")
    }
  )

  electoral_circumscription_map <- map(
    seq_along(electoral_circumscription_map),
    function(x) {
      electoral_circumscription_map[[x]] %>%
        arrange(circumscription_id)
    }
  )

  electoral_circumscription_map[[8]] <- rbind(regions_map[[8]],regions_map[[16]]) %>%
    mutate(circumscription_id = "10") %>%
    rmapshaper::ms_dissolve(., "circumscription_id") %>%
    mutate(region_id = "08") %>%
    select(circumscription_id, region_id, geometry)

  electoral_circumscription_map[[16]] <- electoral_circumscription_map[[8]] %>%
    mutate(region_id = "16")

  save(electoral_circumscription_map, file = circumscription_map_file, compress = "xz")
} else {
  load(circumscription_map_file)
}

map2(
  electoral_circumscription_map,
  sprintf("%s/r%s.geojson", circumscription_geojson_dir, regions),
  save_as_geojson
)

map2(
  electoral_circumscription_map,
  sprintf("%s/r%s.topojson", circumscription_topojson_dir, regions),
  save_as_topojson
)

# District ---------------------------------------------------------

district_map_file <- sprintf("%s/electoral_district_map.rda", data_dir)

if (!file.exists(district_map_file)) {
  load(sprintf("%s/electoral_division.rda", data_dir))
  load(sprintf("%s/communes_map.rda", data_dir))
  load(sprintf("%s/territorial_codes.rda", data_dir))

  electoral_district_map <- map(
    seq_along(communes_map),
    function(x) {
      communes_map[[x]] %>%
        left_join(electoral_division, by = "commune_id")
    }
  )

  electoral_district_map <- map(electoral_district_map, ~aggregate_communes(.x, field = "district_id"))

  electoral_district_map <- map(
    seq_along(electoral_district_map),
    function(x) {
      electoral_district_map[[x]] %>%
        left_join(
          electoral_division %>%
            select(commune_id, district_id) %>%
            left_join(
              territorial_codes %>%
                select(commune_id, region_id)
            ) %>%
            select(district_id, region_id) %>%
            distinct(),
          by = "district_id")
    }
  )

  electoral_district_map <- map(
    seq_along(electoral_district_map),
    function(x) {
      electoral_district_map[[x]] %>%
        arrange(district_id)
    }
  )

  save(electoral_district_map, file = district_map_file, compress = "xz")
} else {
  load(district_map_file)
}

map2(
  electoral_district_map,
  sprintf("%s/r%s.geojson", district_geojson_dir, regions),
  save_as_geojson
)

map2(
  electoral_district_map,
  sprintf("%s/r%s.topojson", district_topojson_dir, regions),
  save_as_topojson
)
