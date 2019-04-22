# basic settings and libraries

knitr::opts_chunk$set(echo = FALSE)  ## ensure code is not echoed throughout app

library(flexdashboard)
library(tidyverse)
library(leaflet)
library(ggplot2)

# load data

data <- readRDS("data/data.RDS")


# create global filtered df generated from main sidebar inputs, adding colors for incident type

data_filt <- reactive({
  data %>%
    dplyr::filter(type %in% input$type,
                  region %in% input$region) %>% 
    dplyr::mutate(color = dplyr::case_when(
      type =="Netting" ~ "red", 
      type == "Line" ~ "blue",
      type == "Rope" ~ "yellow", 
      type == "Bag" ~ "green", 
      type == "Monofilament" ~ "pink",
      type == "String" ~ "cyan", 
      type == "Unclassified" ~ "black")
    )
})

# create color legend df for inserting into leaflet maps

legend <- data.frame(
  type = c("Netting", "Line", "Rope", "Bag", "Monofilament", "String", "Unclassified"),
  color = c("red", "blue", "yellow", "green", "pink", "cyan", "black")
)


# useful function to add circle markers to maps (to save repetitive coding)

addMarks <- function (x, type = c("start", "end"), clusters = NULL) {
  
  ## define longitude and latitude depending on start or end of tow
  
  long <- paste0("~tow_lon_", type)  
  latit <- paste0("~tow_lat_", type)
  
  ##  insert co-ordinates as formulae into leaflet::addCirclemarkers(), with no clustering as default

  leaflet::addCircleMarkers(x, lng = as.formula(long), 
                              lat = as.formula(latit),
                              popup = ~paste0(yearoftow, ": ", observation), radius = 3, 
                              color = ~color,
                              clusterOptions = clusters)
}