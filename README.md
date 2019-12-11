# chilemapas <img src="https://pachamaltese.github.io/chilemapas/hexicon.svg" width=150 align="right" alt="sticker"/>

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Codecov test coverage](https://codecov.io/gh/pachamaltese/chilemapas/branch/master/graph/badge.svg)](https://codecov.io/gh/pachamaltese/chilemapas?branch=master)
[![R build status](https://github.com/pachamaltese/chilemapas/workflows/R-CMD-check/badge.svg)](https://github.com/pachamaltese/chilemapas/actions?workflow=R-CMD-check)
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

La documentacion esta disponible en https://pacha.hk/chilemapas. Se incluyen ejemplos
de uso de las funciones del paquete chilemapas y como se integra con otros paquetes de R.

# Instalacion

Ejecuta el siguiente codigo en RStudio.
```
source("https://install-github.me/pachamaltese/chilemapas")
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

# Pendientes

Aun esta pendiente el mapa de zonas hasta tener respuesta sobre los cambios a
las geozonas.
