# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")

# Extract raw maps --------------------------------------------------------

map2(maps_zip, sprintf("%s/", maps_raw_dir), extract)

# Tidy territorial codes --------------------------------------------------

territorial_codes_file <- sprintf("%s/territorial_codes.rda", data_dir)

if (!file.exists(territorial_codes_file)) {
  territorial_codes <- read_excel(territorial_codes_xls) %>%
    clean_names() %>%
    rename(
      region_id = codigo_region,
      region_name = nombre_region,
      province_id = codigo_provincia,
      province_name = nombre_provincia,
      commune_id = codigo_comuna_2017,
      commune_name = nombre_comuna
    ) %>%
    mutate(
      commune_name = iconv(commune_name, to = "ASCII//TRANSLIT", sub = ""),
      commune_name = str_replace_all(commune_name, "[^[:alnum:]|[:space:]]", ""),
      commune_name = str_to_title(commune_name),

      province_name = iconv(province_name, to = "ASCII//TRANSLIT", sub = ""),
      province_name = str_replace_all(province_name, "[^[:alnum:]|[:space:]]", ""),
      province_name = str_to_title(province_name),

      region_name = iconv(region_name, to = "ASCII//TRANSLIT", sub = ""),
      region_name = str_replace_all(region_name, "[^[:alnum:]|[:space:]]", ""),
      region_name = str_to_title(region_name)
    ) %>%
    mutate(
      commune_name = str_replace_all(commune_name, " De ", " de "),
      commune_name = str_replace_all(commune_name, " Del ", " del "),
      commune_name = str_replace_all(commune_name, " La ", " la "),
      commune_name = str_replace_all(commune_name, " Las ", " las "),
      commune_name = str_replace_all(commune_name, " Los ", " los "),
      commune_name = str_replace_all(commune_name, " Y ", " y "),
      commune_name = str_replace_all(commune_name, "Ohiggins", "OHiggins"),

      province_name = str_replace_all(province_name, " De ", " de "),
      province_name = str_replace_all(province_name, " Del ", " del "),
      province_name = str_replace_all(province_name, " La ", " la "),
      province_name = str_replace_all(province_name, " Las ", " las "),
      province_name = str_replace_all(province_name, " Los ", " los "),
      province_name = str_replace_all(province_name, " Y ", " y "),
      province_name = str_replace_all(province_name, "Ohiggins", "OHiggins"),

      region_name = str_replace_all(region_name, " De ", " de "),
      region_name = str_replace_all(region_name, " Del ", " del "),
      region_name = str_replace_all(region_name, " La ", " la "),
      region_name = str_replace_all(region_name, " Las ", " las "),
      region_name = str_replace_all(region_name, " Los ", " los "),
      region_name = str_replace_all(region_name, " Y ", " y "),
      region_name = str_replace_all(region_name, "Ohiggins", "OHiggins")
    )

  save(territorial_codes, file = territorial_codes_file, compress = "xz")
} else {
  load(territorial_codes_file)
}

territorial_codes_file_csv <- sprintf("%s/territorial_codes.csv", csv_dir)

if (!file.exists(territorial_codes_file_csv)) {
  fwrite(territorial_codes, file = territorial_codes_file_csv)
}

# old_territorial_codes_file <- sprintf("%s/old_territorial_codes.rda", data_dir)

# if (!file.exists(old_territorial_codes_file)) {
#   old_territorial_codes <- territorial_codes %>%
#     mutate(
#       region_id = ifelse(province_id  %in% 161:163, "08", region_id),
#       province_id = ifelse(province_id  %in% 161:163, "084", province_id),
#
#       region_name = ifelse(region_id == "08", "Biobio", region_name),
#       province_name = ifelse(province_id == "084", "Nuble", province_name)
#     )
#
#   old_commune_id <- tibble(
#     commune_name = old_communes_map[[8]]$commune_name,
#     commune_id = old_communes_map[[8]]$commune_id
#   )
#
#   old_territorial_codes <- old_territorial_codes %>%
#     left_join(old_commune_id, by = "commune_name") %>%
#     mutate(commune_id.x = ifelse(province_id == "084", commune_id.y, commune_id.x)) %>%
#     select(-commune_id.y) %>%
#     rename(commune_id = commune_id.x) %>%
#     arrange(region_id, province_id)
#
#   save(old_territorial_codes, file = old_territorial_codes_file, compress = "xz")
# } else {
#   load(old_territorial_codes_file)
# }
#
# old_territorial_codes_file_csv <- sprintf("%s/old_territorial_codes.csv", csv_dir)
#
# if (!file.exists(old_territorial_codes_file_csv)) {
#   fwrite(old_territorial_codes, file = old_territorial_codes_file_csv)
# }

region_attributes <- territorial_codes %>%
  select(region_id, region_name) %>%
  distinct() %>%
  arrange(region_id) %>%
  filter(region_id  != 16)

region_attributes_id <- region_attributes$region_id
region_attributes_name <- region_attributes$region_name

region_attributes_id_new <-  c(grep("08", region_attributes$region_id, value = T, invert = T), "08", "16")
region_attributes_name_new <- c(grep("Biobio", region_attributes$region_name, value = T, invert = T), "Biobio", "Nuble")

# Create new Bio Bio and Nuble map ----------------------------------------

communes_map_file <- sprintf("%s/communes_map.rda", data_dir)

if (!file.exists(communes_map_file)) {
  communes_map_shp <- list.files(path = maps_raw_dir, pattern = "Comuna.shp$", recursive = T, full.names = T)

  old_communes_map_file <- sprintf("%s/old_communes_map.rda", data_dir)

  old_communes_map <- map(communes_map_shp, ~tidy_sf(.x, simplify = TRUE))
  old_communes_map <- map(old_communes_map, ~remove_col(.x, col = "object_id"))
  old_communes_map <- map(old_communes_map, ~move_cols(.x, aggregation = "commune"))

  old_communes_map_r08 <- old_communes_map[[8]]

  old_communes_map_bio_bio <- subset(old_communes_map_r08, province_id != "084")

  old_communes_map_nuble <- subset(old_communes_map_r08, province_id == "084")

  d_old_communes_map_bio_bio <- tibble(commune_name = old_communes_map_bio_bio$commune_name) %>%
    select(commune_name) %>%
    left_join(territorial_codes) %>%
    select(-commune_name, everything())

  d_old_communes_map_nuble <- tibble(commune_name = old_communes_map_nuble$commune_name) %>%
    select(commune_name) %>%
    left_join(territorial_codes) %>%
    select(-commune_name, everything())

  old_communes_map_bio_bio <- old_communes_map_bio_bio %>%
    mutate(
      region_id = d_old_communes_map_bio_bio$region_id,
      province_id = d_old_communes_map_bio_bio$province_id,
      commune_id = d_old_communes_map_bio_bio$commune_id,

      region_name = d_old_communes_map_bio_bio$region_name,
      province_name = d_old_communes_map_bio_bio$province_name,
      commune_name = d_old_communes_map_bio_bio$commune_name
    )

  old_communes_map_nuble <- old_communes_map_nuble %>%
    mutate(
      region_id = d_old_communes_map_nuble$region_id,
      province_id = d_old_communes_map_nuble$province_id,
      commune_id = d_old_communes_map_nuble$commune_id,

      region_name = d_old_communes_map_nuble$region_name,
      province_name = d_old_communes_map_nuble$province_name,
      commune_name = d_old_communes_map_nuble$commune_name
    )

  communes_map <- old_communes_map[-8]
  communes_map[[length(communes_map) + 1]] <- old_communes_map_bio_bio
  communes_map[[length(communes_map) + 1]] <- old_communes_map_nuble

  communes_order <- map_chr(
    seq_along(communes_map),
    function(x) { unique(communes_map[[x]]$region_id) }
  )

  communes_order <- as.integer(communes_order)

  communes_order <- match(seq_along(communes_order), communes_order)

  communes_map <- communes_map[communes_order]
  communes_map <- map(communes_map, ~remove_col(.x, col = c("commune_name", "province_name", "region_name")))

  save(communes_map, file = communes_map_file, compress = "xz")
} else{
  load(communes_map_file)
}

map2(
  communes_map,
  sprintf("%s/r%s.geojson", communes_geojson_dir, sort(region_attributes_id_new)),
  save_as_geojson
)

map2(
  communes_map,
  sprintf("%s/r%s.topojson", communes_topojson_dir, sort(region_attributes_id_new)),
  save_as_topojson
)
