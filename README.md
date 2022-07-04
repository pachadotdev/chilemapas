# chilemapas

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Codecov test coverage](https://codecov.io/gh/pachadotdev/chilemapas/branch/master/graph/badge.svg)](https://codecov.io/gh/pachadotdev/chilemapas?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/chilemapas)](https://cran.r-project.org/package=chilemapas)
[![R-CMD-check](https://github.com/pachadotdev/chilemapas/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pachadotdev/chilemapas/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Acerca de

Mapas terrestres con topologias simplificadas. Estos mapas no 
tienen precision geodesica, por lo que aplica DFL-83 de 1979 de la Republica
de Chile y se consideran referenciales sin validez legal.
No se incluyen los territorios antarticos y bajo ningun evento estos mapas
significan que exista una cesion u ocupacion de territorios soberanos en
contra del Derecho Internacional por parte de Chile. Esta paquete esta documentado intencionalmente
en castellano asciificado para que funcione sin problema en diferentes plataformas.

# Documentacion

La documentacion esta disponible en https://pacha.dev/chilemapas. Se incluyen ejemplos
de uso de las funciones del paquete chilemapas y como se integra con otros paquetes de R.

# Instalacion

Si usas Windows, los binarios ya estan listos y no hace instalar software previamente.

En Ubuntu necesitas ejectutar lo siguiente:
```
sudo apt install libv8-dev libudunits2-dev libprotobuf-dev protobuf-compiler libgeos-dev libgdal-dev
```

Si lo haz instalado en Fedora, OS X u otro y tienes instrucciones para una instalación directa, por favor dejame un issue o pull request.

## Version estable
```
install.packages("chilemapas")
```

## Version de desarrollo
```
# install.packages("remotes")
remotes::install_github("pachadotdev/chilemapas")
```

# Mapas en geojson y topojson

Para quienes no usan R, las carpetas data_geojson y data_topojson contienen
los mapas simplificados de todas las comunas de Chile.

# Valor agregado sobre los archivos shp del INE

Aparte de la simplificacion para reducir el peso de los archivos, los aportes se
pueden divir en dos pilares:

* Mapas administrativos: Construi el mapa de la Region de Niuble haciendo todas las
transformaciones correspondientes sobre la Region del Bio Bio. Otro aporte es el
mapa de servicios de salud recopilando datos de diversas fuentes.

* Mapa politico: Reuni datos para generar el mapa de distritos y circunscripciones
con los diputados y senadores que les asigna la ley.

# Contribuciones

Todos los aportes son bienvenidos. La única condición es respetar el [Codigo de Conducta](https://github.com/pachadotdev/chilemapas/blob/main/CODE_OF_CONDUCT.md).
