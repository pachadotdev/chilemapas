# chilemapas <img src="https://pachamaltese.github.io/chilemapas/hexicon.svg" width=150 align="right" alt="sticker"/>

<!-- badges: start -->
[![R build status](https://github.com/pachamaltese/chilemapas/workflows/R-CMD-check/badge.svg)](https://github.com/pachamaltese/chilemapas/actions?workflow=R-CMD-check)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

# Acerca de

Proporciona datos y funciones para facilitar la elaboracion de mapas de Chile usando R.

Estos mapas no  tienen precision geodesica, por lo que aplica DFL-83 de 1979 de la Republica
de Chile y se consideran referenciales sin validez legal.

No se incluyen los territorios antarticos y bajo ningun evento estos mapas
significan que exista una cesion u ocupacion de territorios soberanos en
contra del Derecho Internacional por parte de Chile.

# Documentacion

La documentacion esta disponible en https://pacha.hk/chilemapas. Se incluyen ejemplos
de uso de las funciones del paquete chilemapas y como se integra con otros paquetes de R.

# Instalacion

```
# desde CRAN
install.packages("chilemapas")

# desde github
if (!require("remotes")) { install.packages("remotes") }
remotes::install_github("pachamaltese/chilemapas")
```
