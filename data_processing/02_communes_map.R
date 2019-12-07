# Tidy territorial codes --------------------------------------------------

territorial_codes_file <- sprintf("%s/codigos_territoriales.rda", data_dir)

if (!file.exists(territorial_codes_file)) {
  codigos_territoriales <- read_excel(territorial_codes_xls) %>%
    clean_names() %>%
    rename(codigo_comuna = codigo_comuna_2017) %>%
    mutate(
      nombre_comuna = iconv(nombre_comuna, to = "ASCII//TRANSLIT", sub = ""),
      nombre_comuna = str_replace_all(nombre_comuna, "[^[:alnum:]|[:space:]]", ""),
      nombre_comuna = str_to_title(nombre_comuna),

      nombre_provincia = iconv(nombre_provincia, to = "ASCII//TRANSLIT", sub = ""),
      nombre_provincia = str_replace_all(nombre_provincia, "[^[:alnum:]|[:space:]]", ""),
      nombre_provincia = str_to_title(nombre_provincia),

      nombre_region = iconv(nombre_region, to = "ASCII//TRANSLIT", sub = ""),
      nombre_region = str_replace_all(nombre_region, "[^[:alnum:]|[:space:]]", ""),
      nombre_region = str_to_title(nombre_region)
    ) %>%
    mutate(
      nombre_comuna = str_replace_all(nombre_comuna, " De ", " de "),
      nombre_comuna = str_replace_all(nombre_comuna, " Del ", " del "),
      nombre_comuna = str_replace_all(nombre_comuna, " La ", " la "),
      nombre_comuna = str_replace_all(nombre_comuna, " Las ", " las "),
      nombre_comuna = str_replace_all(nombre_comuna, " Los ", " los "),
      nombre_comuna = str_replace_all(nombre_comuna, " Y ", " y "),
      nombre_comuna = str_replace_all(nombre_comuna, "Ohiggins", "OHiggins"),

      nombre_provincia = str_replace_all(nombre_provincia, " De ", " de "),
      nombre_provincia = str_replace_all(nombre_provincia, " Del ", " del "),
      nombre_provincia = str_replace_all(nombre_provincia, " La ", " la "),
      nombre_provincia = str_replace_all(nombre_provincia, " Las ", " las "),
      nombre_provincia = str_replace_all(nombre_provincia, " Los ", " los "),
      nombre_provincia = str_replace_all(nombre_provincia, " Y ", " y "),
      nombre_provincia = str_replace_all(nombre_provincia, "Ohiggins", "OHiggins"),

      nombre_region = str_replace_all(nombre_region, " De ", " de "),
      nombre_region = str_replace_all(nombre_region, " Del ", " del "),
      nombre_region = str_replace_all(nombre_region, " La ", " la "),
      nombre_region = str_replace_all(nombre_region, " Las ", " las "),
      nombre_region = str_replace_all(nombre_region, " Los ", " los "),
      nombre_region = str_replace_all(nombre_region, " Y ", " y "),
      nombre_region = str_replace_all(nombre_region, "Ohiggins", "OHiggins")
    )

  save(codigos_territoriales, file = territorial_codes_file, compress = "xz")
} else {
  load(territorial_codes_file)
}

territorial_codes_file_csv <- sprintf("%s/codigos_territoriales.csv", csv_dir)

if (!file.exists(territorial_codes_file_csv)) {
  fwrite(territorial_codes, file = territorial_codes_file_csv)
}

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

communes_map_file <- sprintf("%s/mapa_comunas.rda", data_dir)

if (!file.exists(communes_map_file)) {
  communes_map_shp <- list.files(path = maps_raw_dir, pattern = "COMUNA_C17.shp$", recursive = T, full.names = T)

  old_communes_map_file <- sprintf("%s/old_communes_map.rda", data_dir)

  old_communes_map <- map(communes_map_shp, ~tidy_sf(.x, simplify = TRUE))
  old_communes_map <- map(old_communes_map, ~move_cols(.x, aggregation = "commune"))

  old_communes_map_r08 <- old_communes_map[[8]]

  old_communes_map_bio_bio <- subset(old_communes_map_r08, codigo_provincia != "084")

  old_communes_map_nuble <- subset(old_communes_map_r08, codigo_provincia == "084")

  d_old_communes_map_bio_bio <- tibble(nombre_comuna = old_communes_map_bio_bio$nombre_comuna) %>%
    left_join(codigos_territoriales) %>%
    select(-nombre_comuna, everything())

  d_old_communes_map_nuble <- tibble(nombre_comuna = old_communes_map_nuble$nombre_comuna) %>%
    left_join(codigos_territoriales) %>%
    select(-nombre_comuna, everything())

  old_communes_map_bio_bio <- old_communes_map_bio_bio %>%
    mutate(
      codigo_region = d_old_communes_map_bio_bio$codigo_region,
      codigo_provincia = d_old_communes_map_bio_bio$codigo_provincia,
      codigo_comuna = d_old_communes_map_bio_bio$codigo_comuna,

      nombre_region = d_old_communes_map_bio_bio$nombre_region,
      nombre_provincia = d_old_communes_map_bio_bio$nombre_provincia,
      nombre_comuna = d_old_communes_map_bio_bio$nombre_comuna
    )

  old_communes_map_nuble <- old_communes_map_nuble %>%
    mutate(
      codigo_region = d_old_communes_map_nuble$codigo_region,
      codigo_provincia = d_old_communes_map_nuble$codigo_provincia,
      codigo_comuna = d_old_communes_map_nuble$codigo_comuna,

      nombre_region = d_old_communes_map_nuble$nombre_region,
      nombre_provincia = d_old_communes_map_nuble$nombre_provincia,
      nombre_comuna = d_old_communes_map_nuble$nombre_comuna
    )

  communes_map <- old_communes_map[-8]
  communes_map[[length(communes_map) + 1]] <- old_communes_map_bio_bio
  communes_map[[length(communes_map) + 1]] <- old_communes_map_nuble

  communes_order <- map_chr(
    seq_along(communes_map),
    function(x) { unique(communes_map[[x]]$codigo_region) }
  )

  communes_order <- as.integer(communes_order)

  communes_order <- match(seq_along(communes_order), communes_order)

  communes_map <- communes_map[communes_order]
  communes_map <- map(communes_map, ~remove_col(.x, col = c("nombre_comuna", "nombre_provincia", "nombre_region")))

  mapa_comunas <- map(communes_map, ~leading_zeroes(.x))

  map2(
    mapa_comunas,
    sprintf("%s/r%s.geojson", communes_geojson_dir, sort(region_attributes_id_new)),
    save_as_geojson
  )

  map2(
    mapa_comunas,
    sprintf("%s/r%s.topojson", communes_topojson_dir, sort(region_attributes_id_new)),
    save_as_topojson
  )

  mapa_comunas <- do.call(rbind, mapa_comunas)

  mapa_comunas <- mapa_comunas %>%
    select(codigo_comuna, codigo_provincia, codigo_region, geometry)

  mapa_comunas <- rmapshaper::ms_simplify(mapa_comunas, keep = 0.3)

  save(mapa_comunas, file = communes_map_file, compress = "xz")
} else{
  load(communes_map_file)
}
