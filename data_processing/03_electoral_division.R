# Electoral division ------------------------------------------------------

electoral_division_file <- sprintf("%s/divisiones_electorales.rda", data_dir)

if (!file.exists(electoral_division_file)) {
  electoral_division_html <- read_html("https://www.bcn.cl/siit/divisionelectoral")

  electoral_division <- electoral_division_html %>%
    html_node("table.table.table-bordered.table-condensed") %>%
    html_table(fill = TRUE) %>%
    clean_names()

  electoral_division <- electoral_division %>%
    mutate(
      circunscripcion = str_trim(str_replace_all(circunscripcion, "ª|Senadores|Semadores", "")),
      distrito = str_trim(str_replace_all(distrito, "^N|°|Diputados", ""))
    ) %>%

    mutate(
      distrito = str_replace_all(distrito, "^Región.*", ""),
      distrito = ifelse(distrito == "", NA, distrito)
    ) %>%
    fill(distrito) %>%

    mutate(
      comunas = iconv(comunas, to = "ASCII//TRANSLIT", sub = ""),
      comunas = str_replace_all(comunas, "[^[:alnum:]|[:space:]]", ""),
      comunas = str_trim(str_to_title(comunas))
    ) %>%

    mutate(
      comunas = str_replace_all(comunas, " De ", " de "),
      comunas = str_replace_all(comunas, " Del ", " del "),
      comunas = str_replace_all(comunas, " La ", " la "),
      comunas = str_replace_all(comunas, " Las ", " las "),
      comunas = str_replace_all(comunas, " Los ", " los "),
      comunas = str_replace_all(comunas, " Y ", " y "),
      comunas = str_replace_all(comunas, "Ohiggins", "OHiggins"),

      comunas = str_replace_all(comunas, "La Calera", "Calera"),
      comunas = str_replace_all(comunas, "Paihuano", "Paiguano")
    ) %>%

    separate(circunscripcion, c("circumscription_id", "circumscription_senators")) %>%
    separate(distrito, c("district_id", "district_deputies")) %>%

    select(comunas, matches("circumscription"), matches("district")) %>%
    rename(commune_name = comunas)

  # mismatch_communes <- electoral_divisions %>% anti_join(old_territorial_codes, by = "commune_name")

  electoral_division <- electoral_division %>%
    mutate(
      district_id = as.integer(district_id),
      district_deputies = as.integer(district_deputies),
      circumscription_id = as.integer(circumscription_id),
      circumscription_senators = as.integer(circumscription_senators)
    )

  electoral_division <- dplyr::as_tibble(electoral_division)

  load("data/territorial_codes.rda")

  electoral_division <- electoral_division %>%
    left_join(
      territorial_codes %>%
        select(commune_id, commune_name),
      by = "commune_name"
    ) %>%
    select(commune_id, everything()) %>%
    select(-commune_name)

  electoral_division <- electoral_division %>%
    mutate(
      circumscription_id = ifelse(nchar(circumscription_id) == 1, paste0("0", circumscription_id), circumscription_id),
      district_id = ifelse(nchar(district_id) == 1, paste0("0", district_id), district_id),
    )

  save(electoral_division, file = electoral_division_file, compress = "xz")
} else {
  load(electoral_division_file)
}

electoral_division_file_csv <- sprintf("%s/divisiones_electorales.csv", csv_dir)

if (!file.exists(electoral_division_file_csv)) {
  fwrite(electoral_division, file = electoral_division_file_csv)
}
