# set inputs to the left and output chart to the right

shiny::sidebarLayout(
  shiny::sidebarPanel(
    shiny::uiOutput("sliderstart_box"), # input depends on global filters
    shiny::radioButtons("box_period", "Select period:",
                        choices = c("5 year" = 5, "10 year" = 10),
                        selected = 10)
  ),
  shiny::mainPanel(
    shiny::plotOutput("boxplot")
  )
)

# starts slider at the earliest incident year based on global filters

output$sliderstart_box <- shiny::renderUI({
  shiny::sliderInput("boxstart", "Select start year:", 
                     min = min(data_filt()$yearoftow), 
                     max = max(data_filt()$yearoftow),
                     value = min(data_filt()$yearoftow), 
                     step = 1,
                     sep = "")
})

# filters data based on selected start point

boxdata <- reactive({
  data_filt() %>% 
    dplyr::filter(yearoftow >= as.numeric(input$boxstart))
})

# creates vector of breakpoints for boxplot based on inputs

breaks <- reactive({

  breaks <- as.numeric(input$boxstart)

  for (n in 1:20) {
    breaks <- c(breaks, as.numeric(input$boxstart) + n * as.numeric(input$box_period))
  }
  
  breaks

})

# creates boxplot of number of incidents 

output$boxplot <- shiny::renderPlot({
  boxdata() %>% 
    # count incidents by year
    dplyr::group_by(yearoftow) %>% 
    dplyr::summarise(Incidents = n()) %>% 
    # break into periods as defined by breaks()
    dplyr::mutate(Period = cut(yearoftow, breaks(), 
                                  right = FALSE, dig.lab = 15)) %>% 
    # create boxplot with whiskers
    ggplot2::ggplot(aes(Period, Incidents)) +
    ggplot2::stat_boxplot(geom = "errorbar", width = 0.2) + 
    ggplot2::geom_boxplot(fill = "blue", alpha = 0.2)
  }, 
  width = 600, height = 400
)