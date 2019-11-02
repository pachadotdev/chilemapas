# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")
source("data_processing/02_communes_map.R")

# Tidy raw blocks -------------------------------------------------------

blocks_map_shp <- list.files(path = maps_raw_dir, pattern = "Manzana_Precensal.shp$", recursive = T, full.names = T)

blocks_map_file <- sprintf("%s/blocks_map.rda", data_dir)

if (!file.exists(blocks_map_file)) {
  blocks_map <- map(blocks_map_shp, ~tidy_sf(.x, simplify = TRUE, unit = "block", keep = 0.2))
  blocks_map <- map(blocks_map, ~remove_col(.x, col = c("district_id","zone_id","entity_id")))
  blocks_map <- map(blocks_map, ~move_cols(.x, aggregation = "block"))

  blocks_map <- map(seq_along(blocks_map),
      function(x) {
        d <- blocks_map[[x]]

        d <- d %>%
          mutate(block_id = ifelse(nchar(block_id) == 13, paste0("0", block_id), block_id))

        return(d)
      }
  )

  blocks_map_r08 <- blocks_map[[8]]

  blocks_map_bio_bio <- subset(blocks_map_r08, province_id != "084")

  blocks_map_nuble <- subset(blocks_map_r08, province_id == "084")

  d_blocks_map_bio_bio <- tibble(commune_name = blocks_map_bio_bio$commune_name) %>%
    left_join(territorial_codes) %>%
    select(ends_with("_id")) %>%
    select(-commune_id, everything())

  d_blocks_map_nuble <- tibble(commune_name = blocks_map_nuble$commune_name) %>%
    left_join(territorial_codes) %>%
    select(ends_with("_id")) %>%
    select(-commune_id, everything())

  blocks_map_bio_bio <- blocks_map_bio_bio %>%
    mutate(
      region_id = d_blocks_map_bio_bio$region_id,
      province_id = d_blocks_map_bio_bio$province_id,
      commune_id = d_blocks_map_bio_bio$commune_id
    )

  blocks_map_nuble <- blocks_map_nuble %>%
    mutate(
      region_id = d_blocks_map_nuble$region_id,
      province_id = d_blocks_map_nuble$province_id,
      commune_id = d_blocks_map_nuble$commune_id
    )

  blocks_map <- blocks_map[-8]
  blocks_map[[length(blocks_map) + 1]] <- blocks_map_bio_bio
  blocks_map[[length(blocks_map) + 1]] <- blocks_map_nuble

  blocks_order <- map_chr(
    seq_along(blocks_map),
    function(x) { unique(blocks_map[[x]]$region_id) }
  )

  blocks_order <- as.integer(blocks_order)

  blocks_order <- match(seq_along(blocks_order), blocks_order)

  blocks_map <- blocks_map[blocks_order]
  blocks_map <- map(blocks_map, ~remove_col(.x, col = c("commune_name", "province_name", "region_name")))

  blocks_map[[16]] <- blocks_map[[16]] %>%
    mutate(block_id = str_replace(block_id, "084", province_id))

  save(blocks_map, file = blocks_map_file, compress = "xz")
} else{
  load(blocks_map_file)
}

map2(
  blocks_map,
  sprintf("%s/r%s.geojson", blocks_geojson_dir, sort(region_attributes_id_new)),
  save_as_geojson
)

map2(
  blocks_map,
  sprintf("%s/r%s.topojson", blocks_topojson_dir, sort(region_attributes_id_new)),
  save_as_topojson
)
