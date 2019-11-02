# Packages and functions --------------------------------------------------

source("data_processing/00_functions.R")

# rda dirs ----------------------------------------------------------------

data_dir <- "data"
try(dir.create(data_dir))

# csv dirs ----------------------------------------------------------------

csv_dir <- "data_csv"
try(dir.create(csv_dir))

# raw dirs ----------------------------------------------------------------

raw_dir <- "data_raw"
try(dir.create(raw_dir))

maps_raw_dir <- sprintf("%s/maps", raw_dir)
try(dir.create(maps_raw_dir))

territorial_codes_dir <- sprintf("%s/codes", raw_dir)
try(dir.create(territorial_codes_dir))

census_dir <- sprintf("%s/census", raw_dir)
try(dir.create(census_dir))

health_service_raw_dir <- sprintf("%s/health_service", raw_dir)
try(dir.create(health_service_raw_dir))

# topojson dirs -----------------------------------------------------------

topojson_dir <- "data_topojson"
try(dir.create(topojson_dir))

blocks_topojson_dir <- sprintf("%s/blocks", topojson_dir)
try(dir.create(blocks_topojson_dir))

communes_topojson_dir <- sprintf("%s/communes", topojson_dir)
try(dir.create(communes_topojson_dir))

provinces_topojson_dir <- sprintf("%s/provinces", topojson_dir)
try(dir.create(provinces_topojson_dir))

regions_topojson_dir <- sprintf("%s/regions", topojson_dir)
try(dir.create(regions_topojson_dir))

urban_limits_topojson_dir <- sprintf("%s/urban_limits", topojson_dir)
try(dir.create(urban_limits_topojson_dir))

health_service_topojson_dir <- sprintf("%s/health_service", topojson_dir)
try(dir.create(health_service_topojson_dir))

circumscription_topojson_dir <- sprintf("%s/electoral_circumscription", topojson_dir)
try(dir.create(circumscription_topojson_dir))

district_topojson_dir <- sprintf("%s/electoral_district", topojson_dir)
try(dir.create(district_topojson_dir))

# geojson dirs -----------------------------------------------------------

geojson_dir <- "data_geojson"
try(dir.create(geojson_dir))

blocks_geojson_dir <- sprintf("%s/blocks", geojson_dir)
try(dir.create(blocks_geojson_dir))

communes_geojson_dir <- sprintf("%s/communes", geojson_dir)
try(dir.create(communes_geojson_dir))

provinces_geojson_dir <- sprintf("%s/provinces", geojson_dir)
try(dir.create(provinces_geojson_dir))

regions_geojson_dir <- sprintf("%s/regions", geojson_dir)
try(dir.create(regions_geojson_dir))

urban_limits_geojson_dir <- sprintf("%s/urban_limits", geojson_dir)
try(dir.create(urban_limits_geojson_dir))

health_service_geojson_dir <- sprintf("%s/health_service", geojson_dir)
try(dir.create(health_service_geojson_dir))

circumscription_geojson_dir <- sprintf("%s/electoral_circumscription", geojson_dir)
try(dir.create(circumscription_geojson_dir))

district_geojson_dir <- sprintf("%s/electoral_district", geojson_dir)
try(dir.create(district_geojson_dir))

# SUBDERE territorial codes -----------------------------------------------

territorial_codes_url <- "http://www.subdere.gov.cl/sites/default/files/documentos/cut_2018_v03.xls"
territorial_codes_xls <- sprintf("%s/unique_territorial_codes_subdere_sep_06_2018.xls", territorial_codes_dir)

download_file(territorial_codes_url, territorial_codes_xls)

# Original maps -----------------------------------------------------------

region_code_old <- 1:15
region_code_old <- ifelse(str_length(region_code_old) == 1, paste0("0", region_code_old), region_code_old)

# links taken from http://www.censo2017.cl/resultados-precenso-2016/#1483043043443-4db741fa-4733
maps_url <- sprintf("http://www.censo2017.cl/wp-content/uploads/2017/04/R%s.zip", region_code_old)

maps_zip <- str_replace_all(maps_url, ".*/R", sprintf("%s/r", maps_raw_dir))
maps_zip <- str_replace_all(maps_zip, "zip", "rar") # the files are not zip, are rar renamed to zip, 7z gives a warning!!

map2(maps_url, maps_zip, download_file)

# Health services ---------------------------------------------------------

health_service_url <- "http://www.ide.cl/descargas/capas/salud/TERRIT_SS_SALUD.zip"

health_service_zip <- str_replace_all(health_service_url, ".*/", sprintf("%s/", health_service_raw_dir))

map2(health_service_url, health_service_zip, download_file)
