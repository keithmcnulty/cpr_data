
# sidebar panel controls

shiny::mainPanel(
  shiny::selectInput("type", "Select type:",
                     choices = sort(unique(data$type)),
                     selected = unique(data$type),
                     multiple = TRUE),
  shiny::selectInput("region", "Select region:",
                     choices = sort(unique(data$region)),
                     selected = unique(data$region),
                     multiple = TRUE)
)