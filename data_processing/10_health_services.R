# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")
source("data_processing/02_communes_map.R")

# Extract raw maps --------------------------------------------------------

map2(health_service_zip, sprintf("%s/", health_service_raw_dir), extract)

# Tidy map ----------------------------------------------------------------

health_service_map_shp <- list.files(path = health_service_raw_dir, pattern = ".shp$", recursive = T, full.names = T)

health_service_map_file <- sprintf("%s/health_service_map.rda", data_dir)

health_service_codes_file <- sprintf("%s/health_service_codes.rda", data_dir)

if (!file.exists(health_service_map_file)  |
    !file.exists(health_service_codes_file)) {
  health_service_map <- sf::read_sf(health_service_map_shp) %>%
    clean_names()

  health_service_map <- health_service_map %>%
    mutate(cod_ss = ifelse(nchar(cod_ss) == 1, paste0("0", cod_ss), cod_ss)) %>%
    rename(health_service_id = cod_ss)

  health_service_codes <- tibble(
    region_id = c(15,1:4, rep(5,3), rep(13,6), 6, 7, 16,
                  rep(8,3), 9, 14, rep(10,2), 11, 12, rep(9,2), 10),
    health_service_id = as.character(health_service_map$health_service_id),
    health_service = as.character(health_service_map$nom_ss)
  ) %>%
    mutate(
      region_id = ifelse(nchar(region_id) == 1, paste0("0", region_id), region_id),
      health_service = iconv(health_service, to = "ASCII//TRANSLIT"),
      health_service = str_to_title(health_service),
      health_service = str_replace_all(health_service, "Del ", "del "),
      health_service = str_replace_all(health_service, "Libertador B. Ohiggins", "OHiggins")
    ) %>%
    arrange(region_id)

  health_service_codes <- territorial_codes %>%
    select(region_id, province_id, commune_id) %>%

    mutate(
      # 5th valparaiso san antonio
      health_service_id = NA,
      health_service_id = ifelse(commune_id %in% c("05606","05601","05603","05605","05604","05602","05102","05101","05104","05201"), "06", health_service_id)
    ) %>%

    mutate(
      # 5th vina del mar quillota
      health_service_id = ifelse(commune_id %in% c("05109","05801","05804","05103","05802","05803","05107","05501","05503","05502",
                                                   "05504","05105","05506","05405","05403","05401","05402","05404"), "07", health_service_id)
    ) %>%

    mutate(
      # 5th aconcagua
      health_service_id = ifelse(province_id %in% c("057","053"), "08", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano occidente
      health_service_id = ifelse(province_id %in% c("135","136") | commune_id %in% c("13124","13128","13103","13126","13117"), "10", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano norte
      health_service_id = ifelse(province_id == "133" | commune_id %in% c("13125","13107","13104","13127","13108"), "09", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano centro
      health_service_id = ifelse(commune_id %in% c("13119","13106","13102","13101"), "11", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano sur
      health_service_id = ifelse(province_id == "134" | commune_id %in% c("13105","13109","13116","13121","13130","13129"), "13", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano oriente
      health_service_id = ifelse(commune_id %in% c("13123","13120","13118","13132","13113","13122","13114","13115"), "12", health_service_id)
    ) %>%

    mutate(
      # 13th metropolitano sur oriente
      health_service_id = ifelse(province_id == "132" | commune_id %in% c("13111","13131","13112","13110"), "14", health_service_id)
    ) %>%

    mutate(
      # 8th bio bio arauco
      health_service_id = ifelse(province_id == "082", "28", health_service_id)
    ) %>%

    mutate(
      # 8th bio bio bio bio
      health_service_id = ifelse(province_id == "083", "20", health_service_id)
    ) %>%

    mutate(
      # 8th bio bio talcahuano
      health_service_id = ifelse(commune_id %in% c("08112","08110","08107","08111"), "19", health_service_id)
    ) %>%

    mutate(
      # 8th bio bio concepcion
      health_service_id = ifelse(commune_id %in% c("08108","08103","08101","08104","08102","08105","08106","08109"), "18", health_service_id)
    ) %>%

    mutate(
      # 9th araucania norte
      health_service_id = ifelse(province_id == "092", "29", health_service_id)
    ) %>%

    mutate(
      # 9th araucania sur
      health_service_id = ifelse(province_id == "091", "21", health_service_id)
    ) %>%

    mutate(
      # 10th los lagos osorno
      health_service_id = ifelse(province_id == "103", "23", health_service_id)
    ) %>%

    mutate(
      # 10th los lagos chiloe
      health_service_id = ifelse(province_id == "102", "33", health_service_id)
    ) %>%

    mutate(
      # 10th los lagos del reloncavi
      health_service_id = ifelse(province_id %in% c("101","104"), "24", health_service_id)
    ) %>%

    mutate(
      health_service_id = ifelse(region_id == "15", "01", health_service_id), # 15th
      health_service_id = ifelse(region_id == "01", "02", health_service_id), # 1st
      health_service_id = ifelse(region_id == "02", "03", health_service_id), # 2st
      health_service_id = ifelse(region_id == "03", "04", health_service_id), # 3rd
      health_service_id = ifelse(region_id == "04", "05", health_service_id), # 4rd
      health_service_id = ifelse(region_id == "06", "15", health_service_id), # 6th
      health_service_id = ifelse(region_id == "07", "16", health_service_id), # 7th
      health_service_id = ifelse(region_id == "16", "17", health_service_id), # 16th
      health_service_id = ifelse(region_id == "14", "22", health_service_id), # 14th
      health_service_id = ifelse(region_id == "11", "25", health_service_id), # 11th
      health_service_id = ifelse(region_id == "12", "26", health_service_id), # 12th
    ) %>%

    left_join(
      health_service_codes %>%
        select(health_service_id, health_service)
    )

  health_service_codes <- health_service_codes %>%
    select(commune_id, health_service_id, health_service)

  save(health_service_codes, file = health_service_codes_file, compress = "xz")

  health_service_map <- map(
    seq_along(communes_map),
    function(x) {
      communes_map[[x]] %>%
        left_join(health_service_codes)
    }
  )

  health_service_map <- map(health_service_map, ~aggregate_communes(.x, field = "health_service_id"))

  health_service_map <- map(
    seq_along(health_service_map),
    function(x) {
      health_service_map[[x]] %>%
        left_join(
          health_service_codes %>%
            left_join(
              territorial_codes %>%
                select(commune_id, region_id)
            ) %>%
            select(health_service_id, region_id) %>%
            distinct()
        )
    }
  )

  save(health_service_map, file = health_service_map_file, compress = "xz")
} else{
  load(health_service_map_file)
  load(health_service_codes_file)
}

map2(
  health_service_map,
  sprintf("%s/r%s.geojson", health_service_geojson_dir, sort(region_attributes_id_new)),
  save_as_geojson
)

map2(
  health_service_map,
  sprintf("%s/r%s.topojson", health_service_topojson_dir, sort(region_attributes_id_new)),
  save_as_topojson
)
