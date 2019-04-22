
# global sidebar panel controls to select multiple incident types and incident regions

shiny::mainPanel(
  shiny::selectInput("type", "Select type:",
                     choices = unique(data$type) %>% sort(),
                     selected = unique(data$type),
                     multiple = TRUE),
  shiny::selectInput("region", "Select region:",
                     choices = unique(data$region) %>% sort(),
                     selected = unique(data$region),
                     multiple = TRUE)
)