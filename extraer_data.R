library(tidyverse)
library(sf)
library(terra)

# uso objeto dom y extr de exploracion.R
# CRS 4326 es WGS84

# uso puntos de base domestic como objeto sf y aseguro tener ID de cada punto
dom_sf <- st_as_sf(dom,coords = c("X","Y"),crs = 4326)
# dom_sf$ID <-  1:nrow(dom_sf)

# para usar buffer en metros reproyecto a utm
dom_sf_utm <- st_transform(dom_sf,.......)

buffer_500 <- st_buffer(dom_sf_utm, dist = 500)

# si datos de otra capa como tif
capa <- rast(".........tif")
crs(capa)

# reproyecto raster a utm
capa <- project(capa,st_crs(buffer_500)$wkt)

# extraigo valores como promedio del buffer
valores_capa <- terra::extract(capa, vect(buffer_500),
                               fun = mean, na.rm = T)

dom_sf_utm$capa <- valores_capa[,2]

# para raster grueso, este pondera por proporción de celda cubierta
# library(exactextractr)
# 
# valores_buffer <- exact_extract(r, buffer_500, 'mean')



# si datos como shapefile de polígonos
sh <- st_read("....shp")
sh <- st_transform(sh, st_crs(dom_sf))

# intersecar buffer y polígono, calcular area y sumar proporcion
inter <- st_intersection(buffer_500, sh)
inter$area_int <- st_area(inter)

resumen <- inter %>%
  group_by(ID_buffer = ID) %>%  # mejor usar un ID real
  summarise(prop = sum(area_int))

# si shapefile de puntos
sh_puntos <- st_read("....shp")
sh_puntos <- st_transform(sh_puntos, st_crs(buffer_500))

inter_pts <- st_intersects(buffer_500, sh_puntos)
n_pts <- lengths(inter_pts)
buffer_500$n_registros <- n_pts

