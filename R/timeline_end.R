
ui <- shiny::bootstrapPage(
  shiny::tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leaflet::leafletOutput("timeline_start"),
  shiny::absolutePanel(top = 10, right = 10,
                       sliderInput("animation", "Year:",
                                   min = min(data$yearoftow),
                                   max = max(data$yearoftow),
                                   value = min(data$yearoftow),
                                   sep = "",
                                   ticks = FALSE,
                                   animate = animationOptions(interval = 600))
  )
)
  
  
server <- function(input, output) {

  data_filt_anim <- shiny::reactive({
    data_filt() %>% dplyr::filter(yearoftow <= input$animation)
  })
    
  output$timeline_start <- leaflet::renderLeaflet({
    leaflet::leaflet() %>%
      leaflet::addTiles() %>%
      leaflet::addProviderTiles(providers$CartoDB.Positron) %>%
      leaflet::fitBounds(lng1 = -60, 
                         lat1 = 40, 
                         lng2 = 20, 
                         lat2 = 70) %>% 
      leaflet::addLegend(position = "bottomleft", colors = legend$color, 
                         labels = legend$type)
  })
    
  shiny::observe({
    leaflet::leafletProxy("timeline_start", data = data_filt_anim()) %>%
      leaflet::clearShapes() %>%
      leaflet::addCircleMarkers(lng = ~tow_lon_end, lat = ~tow_lat_end,
                  radius = 3, color = ~color, popup = ~paste0(yearoftow, ": ", observation))
  })
    
}

# Run the application 
shiny::shinyApp(ui = ui, server = server)