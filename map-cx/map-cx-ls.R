library(tidyverse)

## get data
## ----------
library(googlesheets)
(my_sheets <- gs_ls())
tmp <- gs_title("CX tracks in Lausanne")
coord <- tmp %>%
  gs_read(ws = "Sheet1")

## split into two clusters
coord.chaletagobet <- coord %>% filter(cluster == "Connection Chalet a Gobet")
coord.rest <- coord %>% filter(cluster != "Connection Chalet a Gobet")


## load icons
## ---------
## from here: https://github.com/bhaskarvk/leaflet/blob/master/inst/examples/awesomeMarkers.R
icon.bike.blue <- makeAwesomeIcon(icon = 'bicycle', markerColor = 'blue', library='fa',
                           iconColor = 'white')
icon.bike.green <- makeAwesomeIcon(icon = 'bicycle', markerColor = 'green', library='fa',
                                  iconColor = 'white')

## make map
## ---------
library(leaflet)
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addAwesomeMarkers(lat=coord.rest$latitude, lng=coord.rest$longitude, popup=coord.rest$name, icon = icon.bike.blue) %>%
  addAwesomeMarkers(lat=coord.chaletagobet$latitude, lng=coord.chaletagobet$longitude, popup=coord.chaletagobet$name, icon = icon.bike.green) %>%
  # Base groups
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(providers$MtbMap, group = "MTBmap") %>%
  addProviderTiles(providers$Thunderforest.OpenCycleMap, group = "CyclingMap") %>%
  addProviderTiles(providers$OpenTopoMap, group = "Topo") %>%
  addProviderTiles(providers$HikeBike.HikeBike, group = "HikeBike") %>%
  addProviderTiles(providers$Stamen.Watercolor, group = "Watercolor") %>%
  # Layers control
  addLayersControl(
    baseGroups = c("OSM (default)", "MTBmap", "CyclingMap", "Topo", "HikeBike", "Watercolor"),
    options = layersControlOptions(collapsed = FALSE)
  )

m  # Print the map

## to hmtl
library(htmlwidgets)
saveWidget(m, file="map-cx-ls.html")

## save to png
mapview::mapshot(m, file = "map-cx-ls.png")
