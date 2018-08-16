library(googlesheets)
(my_sheets <- gs_ls())
tmp <- gs_title("CX tracks in Lausanne")
coord <- tmp %>%
  gs_read(ws = "Sheet1")

library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lat=coord$latitude, lng=coord$longitude, popup=coord$name) %>%
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
