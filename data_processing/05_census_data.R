# census by commune ----

tidy_census_file <- sprintf("%s/censo_2017_comunas.rda", data_dir)

if (!file.exists(tidy_census_file)) {
  census_2017_communes <- read_excel("data_raw/census_data_by_sex_and_age.xlsx",
                                     sheet = "COMUNAS", range = "B2:L7636", skip = 1) %>%
    clean_names() %>%
    select(codigo_comuna,  edad, hombres, mujeres) %>%
    filter(codigo_comuna != "PAÍS", edad != "Total Comunal") %>%
    mutate(codigo_comuna = str_pad(codigo_comuna, 5, "left", 0)) %>%
    group_by(codigo_comuna, edad) %>%
    summarise_if(is.numeric, sum) %>%
    ungroup() %>%
    mutate(edad = iconv(edad, from = "", to = "ASCII//TRANSLIT"))

  census_2017_communes <- census_2017_communes %>%
    mutate(codigo_comuna = case_when(
      codigo_comuna == "08401" ~ "16101",
      codigo_comuna == "08402" ~ "16102",
      codigo_comuna == "08403" ~ "16202",
      codigo_comuna == "08404" ~ "16203",
      codigo_comuna == "08405" ~ "16302",
      codigo_comuna == "08406" ~ "16103",
      codigo_comuna == "08407" ~ "16104",
      codigo_comuna == "08408" ~ "16204",
      codigo_comuna == "08409" ~ "16303",
      codigo_comuna == "08410" ~ "16105",
      codigo_comuna == "08411" ~ "16106",
      codigo_comuna == "08412" ~ "16205",
      codigo_comuna == "08413" ~ "16107",
      codigo_comuna == "08414" ~ "16201",
      codigo_comuna == "08415" ~ "16206",
      codigo_comuna == "08416" ~ "16301",
      codigo_comuna == "08417" ~ "16304",
      codigo_comuna == "08418" ~ "16108",
      codigo_comuna == "08419" ~ "16305",
      codigo_comuna == "08420" ~ "16207",
      codigo_comuna == "08421" ~ "16109",
      TRUE ~ codigo_comuna
    ))

  censo_2017_comunas <- census_2017_communes %>%
    gather(sexo, poblacion, -codigo_comuna, -edad) %>%
    ungroup()

  censo_2017_comunas <- censo_2017_comunas %>%
    mutate(
      sexo = str_replace_all(sexo, "s$", ""),
      sexo = str_replace_all(sexo, "ere$", "er")
    ) %>%
    mutate(
      edad = as_factor(edad),
      sexo = as_factor(sexo)
    ) %>%
    mutate(
      edad = fct_relevel(edad, "100 o mas", after = Inf)
    )

  save(censo_2017_comunas, file = tidy_census_file, compress = "xz")
} else {
  load(tidy_census_file)
}

census_file_csv <- sprintf("%s/censo_2017_comunas.csv", csv_dir)

if (!file.exists(census_file_csv)) {
  fwrite(censo_2017_comunas, file = census_file_csv)
}

# census by zone ----

census_zone_rda <- "data/censo_2017_zonas.rda"

if (!file.exists(census_zone_rda)) {
  censo_2017_zonas <- fread("data_raw/census_data_by_zone/Censo2017_16R_ManzanaEntidad_CSV/Censo2017_Manzanas.csv",
                            sep = ";") %>%
    clean_names() %>%
    select(id_manzent, matches("edad")) %>%
    as_tibble() %>%
    rename(geocodigo = id_manzent) %>%
    mutate(geocodigo = as.character(geocodigo)) %>%
    mutate(
      geocodigo = str_pad(geocodigo, 14, "left", "0")
      # geocodigo = str_sub(geocodigo, 1 ,11)
    ) %>%

    group_by(geocodigo) %>%
    mutate_if(is.character, as.numeric) %>%
    summarise_if(is.numeric, sum, na.rm = T) %>%
    ungroup() %>%

    mutate(geocodigo = str_sub(geocodigo, 1, 11)) %>%
    group_by(geocodigo) %>%
    summarise_if(is.numeric, sum, na.rm = T) %>%

    gather(edad, poblacion, -geocodigo)

  censo_2017_zonas <- censo_2017_zonas %>%
    mutate(
      edad = str_replace_all(edad, "edad_", ""),
      edad = str_replace_all(edad, "a", " a "),
      edad = str_replace_all(edad, "ym a s", " y mas"),
      edad = as_factor(edad)
    )

  save(censo_2017_zonas, file = "data/censo_2017_zonas.rda", compress = "xz")
} else {
  load(census_zone_rda)
}

census_zone_csv <- sprintf("%s/censo_2017_zonas.csv", csv_dir)

if (!file.exists(census_zone_csv)) {
  fwrite(censo_2017_zonas, file = census_zone_csv)
}
