# Tidy map ----------------------------------------------------------------

health_service_map_shp <- list.files(path = health_service_raw_dir, pattern = ".shp$", recursive = T, full.names = T)

health_service_codes_file <- sprintf("%s/divisiones_salud.rda", data_dir)

if (!file.exists(health_service_codes_file)) {
  health_service_codes_1 <- tibble(
      # 5th valparaiso san antonio
      codigo_comuna = c("05606","05601","05603","05605","05604","05602","05102","05101","05104","05201"),
      codigo_servicio_salud = "06",
      nombre_servicio_salud = "Valparaiso San Antonio"
    ) %>%

    bind_rows(tibble(
      # 5th vina del mar quillota
      codigo_comuna = c("05109","05801","05804","05103","05802","05803","05107","05501","05503","05502",
                        "05504","05105","05506","05405","05403","05401","05402","05404"),
      codigo_servicio_salud = "07",
      nombre_servicio_salud = "Vina del Mar Quillota"
    )) %>%

    bind_rows(tibble(
      # 5th aconcagua
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia %in% c("057","053")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "08",
      nombre_servicio_salud = "Aconcagua"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano occidente
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia %in% c("135","136") | codigo_comuna %in% c("13124","13128","13103","13126","13117")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "10",
      nombre_servicio_salud = "Metropolitano Occidente"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano norte
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "133" | codigo_comuna %in% c("13125","13107","13104","13127","13108")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "09",
      nombre_servicio_salud = "Metropolitano Norte"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano centro
      codigo_comuna = codigos_territoriales %>% filter(codigo_comuna %in% c("13119","13106","13102","13101")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "11",
      nombre_servicio_salud = "Metropolitano Central"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano sur
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "134" | codigo_comuna %in% c("13105","13109","13116","13121","13130","13129")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "13",
      nombre_servicio_salud = "Metropolitano Sur"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano oriente
      codigo_comuna = codigos_territoriales %>% filter(codigo_comuna %in% c("13123","13120","13118","13132","13113","13122","13114","13115")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "12",
      nombre_servicio_salud = "Metropolitano Oriente"
    )) %>%

    bind_rows(tibble(
      # 13th metropolitano sur oriente
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "132" | codigo_comuna %in% c("13111","13131","13112","13110")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "14",
      nombre_servicio_salud = "Metropolitano Suroriente"
    )) %>%

    bind_rows(tibble(
      # 8th bio bio arauco
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "082") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "28",
      nombre_servicio_salud = "Arauco"
    )) %>%

    bind_rows(tibble(
      # 8th bio bio bio bio
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "083") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "20",
      nombre_servicio_salud = "Biobio"
    )) %>%

    bind_rows(tibble(
      # 8th bio bio talcahuano
      codigo_comuna = codigos_territoriales %>% filter(codigo_comuna %in% c("08112","08110","08107","08111")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "19",
      nombre_servicio_salud = "Talcahuano"
    )) %>%

    bind_rows(tibble(
      # 8th bio bio concepcion
      codigo_comuna = codigos_territoriales %>% filter(codigo_comuna %in% c("08108","08103","08101","08104","08102","08105","08106","08109")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "18",
      nombre_servicio_salud = "Concepcion"
    )) %>%

    bind_rows(tibble(
      # 9th araucania norte
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia== "092") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "29",
      nombre_servicio_salud = "Araucania Norte"
    )) %>%

    bind_rows(tibble(
      # 9th araucania sur
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "091") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "21",
      nombre_servicio_salud = "Araucania Sur"
    )) %>%

    bind_rows(tibble(
      # 10th los lagos osorno
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "103") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "23",
      nombre_servicio_salud = "Osorno"
    )) %>%

    bind_rows(tibble(
      # 10th los lagos chiloe
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia == "102") %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "33",
      nombre_servicio_salud = "Chiloe"
    )) %>%

    bind_rows(tibble(
      # 10th los lagos del reloncavi
      codigo_comuna = codigos_territoriales %>% filter(codigo_provincia %in% c("101","104")) %>% select(codigo_comuna) %>% pull(),
      codigo_servicio_salud = "24",
      nombre_servicio_salud = "del Reloncavi"
    ))

  health_service_codes_2 <- codigos_territoriales %>%
    select(codigo_comuna, codigo_region) %>%
    filter(codigo_region %in% c(str_pad(1:7, 2, "left", 0), 11, 12, 14:16)) %>%
    mutate(
      codigo_servicio_salud = NA,
      codigo_servicio_salud = ifelse(codigo_region == "15", "01", codigo_servicio_salud), # 15th
      codigo_servicio_salud = ifelse(codigo_region == "01", "02", codigo_servicio_salud), # 1st
      codigo_servicio_salud = ifelse(codigo_region == "02", "03", codigo_servicio_salud), # 2st
      codigo_servicio_salud = ifelse(codigo_region == "03", "04", codigo_servicio_salud), # 3rd
      codigo_servicio_salud = ifelse(codigo_region == "04", "05", codigo_servicio_salud), # 4rd
      codigo_servicio_salud = ifelse(codigo_region == "06", "15", codigo_servicio_salud), # 6th
      codigo_servicio_salud = ifelse(codigo_region == "07", "16", codigo_servicio_salud), # 7th
      codigo_servicio_salud = ifelse(codigo_region == "16", "17", codigo_servicio_salud), # 16th
      codigo_servicio_salud = ifelse(codigo_region == "14", "22", codigo_servicio_salud), # 14th
      codigo_servicio_salud = ifelse(codigo_region == "11", "25", codigo_servicio_salud), # 11th
      codigo_servicio_salud = ifelse(codigo_region == "12", "26", codigo_servicio_salud), # 12th
    ) %>%
    mutate(
      nombre_servicio_salud = NA,
      nombre_servicio_salud = ifelse(codigo_region == "15", "Arica", nombre_servicio_salud), # 15th
      nombre_servicio_salud = ifelse(codigo_region == "01", "Iquique", nombre_servicio_salud), # 1st
      nombre_servicio_salud = ifelse(codigo_region == "02", "Antofagasta", nombre_servicio_salud), # 2st
      nombre_servicio_salud = ifelse(codigo_region == "03", "Atacama", nombre_servicio_salud), # 3rd
      nombre_servicio_salud = ifelse(codigo_region == "04", "Coquimbo", nombre_servicio_salud), # 4rd
      nombre_servicio_salud = ifelse(codigo_region == "06", "OHiggins", nombre_servicio_salud), # 6th
      nombre_servicio_salud = ifelse(codigo_region == "07", "del Maule", nombre_servicio_salud), # 7th
      nombre_servicio_salud = ifelse(codigo_region == "16", "Nuble", nombre_servicio_salud), # 16th
      nombre_servicio_salud = ifelse(codigo_region == "14", "Valdivia", nombre_servicio_salud), # 14th
      nombre_servicio_salud = ifelse(codigo_region == "11", "Aysen", nombre_servicio_salud), # 11th
      nombre_servicio_salud = ifelse(codigo_region == "12", "Magallanes", nombre_servicio_salud), # 12th
    ) %>%
    select(-codigo_region)

  save(health_service_codes, file = health_service_codes_file, compress = "xz")
} else{
  load(health_service_codes_file)
}
