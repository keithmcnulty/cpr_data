# set inputs to the left and output chart to the right

shiny::sidebarLayout(
  shiny::sidebarPanel(
  shiny::uiOutput("sliderstart_hist"),  # input depends on global filters
    shiny::uiOutput("histend") # endpoint input depends in startpoint
  ),
  shiny::mainPanel(
    shiny::plotOutput("histplot")
  )
)

# starts slider at the earliest incident year based on global filters

output$sliderstart_hist <- shiny::renderUI({
  shiny::sliderInput("hist_start", "Select start year:",
                     min = min(data_filt()$yearoftow), 
                     max = max(data_filt()$yearoftow),
                     value = min(data_filt()$yearoftow), 
                     step = 1,
                     sep = "")
})


# starts endpoiint slider so that it is no earlier than the startpoint input

output$histend <- shiny::renderUI({
  shiny::sliderInput("hist_end", "Select end year:", 
                     min = input$hist_start, 
                     max = max(data_filt()$yearoftow),
                     value = max(data_filt()$yearoftow), 
                     step = 1, sep = "")
})

# filters data based on startpoint and endpoint

histdata <- reactive({
  data_filt() %>% 
    dplyr::filter(yearoftow >= as.numeric(input$hist_start) &
                    yearoftow <= as.numeric(input$hist_end)) %>% 
    dplyr::rename(Year = yearoftow)  ## for axis labelling
})

# creates histogram based on incident density

output$histplot <- shiny::renderPlot({
  histdata() %>% 
    ggplot2::ggplot(aes(x = Year)) + 
    ggplot2::geom_histogram(aes(y = ..density..),binwidth = 1, fill = "blue", alpha = 0.2) +
    ggplot2::geom_density(color = "blue", alpha = 1) ## adds density curve
  }, 
  width = 600, height = 400 ## defines dimensions of output chart
)