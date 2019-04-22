shiny::sidebarLayout(
  shiny::sidebarPanel(
    shiny::sliderInput("hist_start", "Select start year:", min = 1957, max = 2016,
                       value = 1957, step = 1, sep = ""),
    shiny::uiOutput("histend")
  ),
  shiny::mainPanel(
    shiny::plotOutput("histplot")
  )
)


output$histend <- shiny::renderUI({
  shiny::sliderInput("hist_end", "Select end year:", min = input$hist_start, max = 2016,
                     value = 2016, step = 1, sep = "")
})

histdata <- reactive({
  data_filt() %>% 
    dplyr::filter(yearoftow >= as.numeric(input$hist_start) &
                    yearoftow <= as.numeric(input$hist_end)) %>% 
    dplyr::rename(Year = yearoftow)
})

output$histplot <- shiny::renderPlot({
  histdata() %>% 
    ggplot2::ggplot(aes(x = Year)) + 
    ggplot2::geom_histogram(aes(y = ..density..),binwidth = 1, fill = "blue", alpha = 0.2) +
    ggplot2::geom_density(color = "blue", alpha = 1)
  }, 
  width = 600, height = 400
)