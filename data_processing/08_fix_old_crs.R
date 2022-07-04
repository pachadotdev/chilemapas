# CRS: EPSG:4674 - SIRGAS 2000 - Geographic
# from official census maps opened in QGIS
# https://github.com/ropensci/censo2017-cartografias/releases/tag/v0.4

# see https://stackoverflow.com/a/72671067/3720258

load("~/github/chilemapas/data/mapa_comunas.rda")
str(attr(mapa_comunas$geometry,"crs"))
st_crs(mapa_comunas$geometry) <- 4674
str(attr(mapa_comunas$geometry,"crs"))

load("~/github/chilemapas/data/mapa_zonas.rda")
str(attr(mapa_zonas$geometry,"crs"))
st_crs(mapa_zonas$geometry) <- 4674
str(attr(mapa_zonas$geometry,"crs"))

use_data(mapa_comunas, compress = "xz", overwrite = T)
use_data(mapa_zonas, compress = "xz", overwrite = T)
