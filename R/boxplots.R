shiny::sidebarLayout(
  shiny::sidebarPanel(
    shiny::selectInput("boxstart", "Select start year:", choices = c(1957:2000)),
    shiny::radioButtons("box_period", "Select period:",
                        choices = c("5 year" = 5, "10 year" = 10),
                        selected = 10)
  ),
  shiny::mainPanel(
    shiny::plotOutput("boxplot")
  )
)

boxdata <- reactive({
  data_filt() %>% 
    dplyr::filter(yearoftow >= as.numeric(input$boxstart))
})

breaks <- reactive({

  breaks <- as.numeric(input$boxstart)

  for (n in 1:20) {
    breaks <- c(breaks, as.numeric(input$boxstart) + n * as.numeric(input$box_period))
  }
  
  breaks

})


output$boxplot <- shiny::renderPlot({
  boxdata() %>% 
    dplyr::group_by(yearoftow) %>% 
    dplyr::summarise(Incidents = n()) %>% 
    dplyr::mutate(Period = cut(yearoftow, breaks(), 
                                  right = FALSE, dig.lab = 15)) %>% 
    ggplot2::ggplot(aes(Period, Incidents)) +
    ggplot2::stat_boxplot(geom = "errorbar", width = 0.2) + 
    ggplot2::geom_boxplot(fill = "blue", alpha = 0.2)
  }, 
  width = 600, height = 400
)