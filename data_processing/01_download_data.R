# rda dirs ----------------------------------------------------------------

data_dir <- "data"
try(dir.create(data_dir))

# csv dirs ----------------------------------------------------------------

csv_dir <- "data_csv"
try(dir.create(csv_dir))

# raw dirs ----------------------------------------------------------------

raw_dir <- "data_raw"
try(dir.create(raw_dir))

maps_raw_dir <- sprintf("%s/cartografia_censo_2017_oficial", raw_dir)

health_service_raw_dir <- sprintf("%s/health_service", raw_dir)
try(dir.create(health_service_raw_dir))

# topojson dirs -----------------------------------------------------------

topojson_dir <- "data_topojson"
try(dir.create(topojson_dir))

communes_topojson_dir <- sprintf("%s/comunas", topojson_dir)
try(dir.create(communes_topojson_dir))

# geojson dirs -----------------------------------------------------------

geojson_dir <- "data_geojson"
try(dir.create(geojson_dir))

communes_geojson_dir <- sprintf("%s/comunas", geojson_dir)
try(dir.create(communes_geojson_dir))

# SUBDERE territorial codes -----------------------------------------------

territorial_codes_url <- "http://www.subdere.gov.cl/sites/default/files/documentos/cut_2018_v03.xls"
territorial_codes_xls <- sprintf("%s/unique_territorial_codes_subdere_sep_06_2018.xls", territorial_codes_dir)

download_file(territorial_codes_url, territorial_codes_xls)
