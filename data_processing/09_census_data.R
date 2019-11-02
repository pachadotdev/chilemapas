# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")
source("data_processing/01_download_data.R")

# Extract raw census ------------------------------------------------------

raw_census_csv <- list.files(census_dir, pattern = "Censo2017_Manzanas\\.csv", recursive = T)

tidy_census_file <- sprintf("%s/census_2017_communes.rda", data_dir)

if (!file.exists(tidy_census_file)) {
  census_2017_communes <- fread("dev/Censo2017_Manzanas.csv", sep = ";") %>%
    clean_names() %>%
    select(comuna, hombres, mujeres) %>%
    rename(commune_id = comuna) %>%
    mutate(
      commune_id = as.character(commune_id),
      hombres = as.numeric(hombres),
      mujeres = as.numeric(mujeres)
    ) %>%
    group_by(commune_id) %>%
    summarise(
      pop_men = sum(hombres, na.rm = TRUE),
      pop_women = sum(mujeres, na.rm = TRUE)
    ) %>%
    rowwise() %>%
    mutate(pop_total = pop_men + pop_women) %>%
    ungroup() %>%
    mutate(commune_id = ifelse(nchar(commune_id) == 4, paste0("0", commune_id), commune_id))

  save(census_2017_communes, file = tidy_census_file, compress = "xz")
} else {
  load(tidy_census_file)
}

census_file_csv <- sprintf("%s/census_2017_communes.csv", csv_dir)

if (!file.exists(census_file_csv)) {
  fwrite(census_2017_communes, file = census_file_csv)
}
