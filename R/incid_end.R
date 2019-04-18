# create leaflet map

map <- reactive({
  leaflet(data_filt()) %>% 
    leaflet::addTiles() %>% 
    leaflet::addProviderTiles(providers$CartoDB.Positron) %>%
    leaflet::fitBounds(lng1 = -60, 
                       lat1 = 40, 
                       lng2 = 20, 
                       lat2 = 70) %>% 
    leaflet::addCircleMarkers(~tow_lon_end, ~tow_lat_end, 
                              popup = ~paste0(yearoftow, ": ", observation), radius = 3, 
                              color = ~color,
                              clusterOptions = markerClusterOptions()) %>% 
    leaflet::addLegend(position = "bottomleft", colors = legend$color, 
                       labels = legend$type)
})

# display leaflet map

leaflet::renderLeaflet(map())
