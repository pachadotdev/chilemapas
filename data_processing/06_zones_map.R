territorial_codes_file <- sprintf("data/codigos_territoriales.rda", data_dir)
load(territorial_codes_file)

region_attributes <- codigos_territoriales %>%
  select(codigo_region, nombre_region) %>%
  distinct() %>%
  arrange(codigo_region) %>%
  filter(codigo_region  != 16)

region_attributes_id <- region_attributes$codigo_region
region_attributes_name <- region_attributes$nombre_region

region_attributes_id_new <-  c(grep("08", region_attributes$codigo_region, value = T, invert = T), "08", "16")
region_attributes_name_new <- c(grep("Biobio", region_attributes$nombre_region, value = T, invert = T), "Biobio", "Nuble")

# Create new Bio Bio and Nuble map ----------------------------------------

zones_map_file <- sprintf("%s/mapa_zonas.rda", data_dir)

if (!file.exists(zones_map_file)) {
  zones_map_shp <- list.files(path = maps_raw_dir, pattern = "ZONA_C17.shp$", recursive = T, full.names = T)

  # old_zones_map_file <- sprintf("%s/old_zones_map.rda", data_dir)

  old_zones_map <- map(zones_map_shp, ~tidy_sf(.x, unit = "zone", simplify = TRUE))
  old_zones_map <- map(old_zones_map, ~move_cols(.x, aggregation = "zone"))

  old_zones_map_r08 <- old_zones_map[[8]]

  old_zones_map_bio_bio <- subset(old_zones_map_r08, codigo_provincia != "084")

  old_zones_map_nuble <- subset(old_zones_map_r08, codigo_provincia == "084")

  d_old_zones_map_bio_bio <- tibble(nombre_comuna = old_zones_map_bio_bio$nombre_comuna) %>%
    left_join(codigos_territoriales) %>%
    select(-nombre_comuna, everything())

  d_old_zones_map_nuble <- tibble(nombre_comuna = old_zones_map_nuble$nombre_comuna) %>%
    left_join(codigos_territoriales) %>%
    select(-nombre_comuna, everything())

  old_zones_map_bio_bio <- old_zones_map_bio_bio %>%
    mutate(
      codigo_region = d_old_zones_map_bio_bio$codigo_region,
      codigo_provincia = d_old_zones_map_bio_bio$codigo_provincia,
      codigo_comuna = d_old_zones_map_bio_bio$codigo_comuna,

      nombre_region = d_old_zones_map_bio_bio$nombre_region,
      nombre_provincia = d_old_zones_map_bio_bio$nombre_provincia,
      nombre_comuna = d_old_zones_map_bio_bio$nombre_comuna
    )

  old_zones_map_nuble <- old_zones_map_nuble %>%
    mutate(
      codigo_region = d_old_zones_map_nuble$codigo_region,
      codigo_provincia = d_old_zones_map_nuble$codigo_provincia,
      codigo_comuna = d_old_zones_map_nuble$codigo_comuna,

      nombre_region = d_old_zones_map_nuble$nombre_region,
      nombre_provincia = d_old_zones_map_nuble$nombre_provincia,
      nombre_comuna = d_old_zones_map_nuble$nombre_comuna
    )

  zones_map <- old_zones_map[-8]
  zones_map[[length(zones_map) + 1]] <- old_zones_map_bio_bio
  zones_map[[length(zones_map) + 1]] <- old_zones_map_nuble

  communes_order <- map_chr(
    seq_along(zones_map),
    function(x) { unique(zones_map[[x]]$codigo_region) }
  )

  communes_order <- as.integer(communes_order)

  communes_order <- match(seq_along(communes_order), communes_order)

  zones_map <- zones_map[communes_order]
  zones_map <- map(zones_map, ~remove_col(.x, col = c("nombre_comuna", "nombre_provincia", "nombre_region")))

  mapa_zonas <- map(zones_map, ~leading_zeroes(.x, aggregation = "zone"))

  mapa_zonas[[16]] <- mapa_zonas[[16]] %>%
    mutate(geocodigo = paste0(codigo_comuna, str_sub(geocodigo, 6, 11)))

  map2(
    mapa_zonas,
    sprintf("%s/r%s.geojson", zones_geojson_dir, sort(region_attributes_id_new)),
    save_as_geojson,
    aggregation = "zone"
  )

  map2(
    mapa_zonas,
    sprintf("%s/r%s.topojson", zones_topojson_dir, sort(region_attributes_id_new)),
    save_as_topojson,
    aggregation = "zone"
  )

  mapa_zonas <- do.call(rbind, mapa_zonas)

  mapa_zonas <- rmapshaper::ms_simplify(mapa_zonas, keep = 0.3)

  save(mapa_zonas, file = zones_map_file, compress = "xz")
} else{
  load(zones_map_file)
}
