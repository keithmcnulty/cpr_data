# create leaflet map

map_end <- reactive({
  leaflet::leaflet(data_filt()) %>% 
    leaflet::addTiles() %>% 
    leaflet::addProviderTiles(providers$CartoDB.Positron) %>%
    leaflet::fitBounds(lng1 = -60, 
                       lat1 = 40, 
                       lng2 = 20, 
                       lat2 = 70) %>% 
    addMarks("end", clusters = TRUE) %>% 
    leaflet::addLegend(position = "bottomleft", colors = legend$color, 
                       labels = legend$type)
})

# display leaflet map

leaflet::renderLeaflet(map_end())
