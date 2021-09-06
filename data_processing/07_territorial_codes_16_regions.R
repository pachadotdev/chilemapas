library(censo2017)
library(chilemapas)
library(dplyr)

comunas_censo <- censo_tabla("comunas")

comunas_censo %>%
  mutate(redcoden = substr(redcoden, 1, 2)) %>%
  select(redcoden) %>%
  distinct()

comunas_chilemapas <- codigos_territoriales %>%
  select(redcoden = codigo_comuna) %>%
  distinct()

codigos_territoriales_16r <- comunas_censo %>%
  mutate(nom_comuna = iconv(nom_comuna, "", "ASCII//TRANSLIT")) %>%
  anti_join(comunas_chilemapas) %>%
  left_join(
    codigos_territoriales %>%
      select(nom_comuna = nombre_comuna, codigo_comuna_16r = codigo_comuna) %>%
      mutate(nom_comuna = toupper(nom_comuna))
  ) %>%
  select(codigo_comuna = redcoden, codigo_comuna_16r, nombre_comuna = nom_comuna)

save(codigos_territoriales_16r, file = "data/codigos_territoriales_16r.rda", compress = "xz")
