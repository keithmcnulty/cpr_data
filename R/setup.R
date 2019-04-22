# basic settings and libraries

knitr::opts_chunk$set(echo = FALSE)

library(flexdashboard)
library(tidyverse)
library(leaflet)
library(ggplot2)

# load data

data <- readRDS("data/data.RDS")


# filters and colors

# generate all incidents view in leaflet

# create map color and filtered df

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

# create color legend df

legend <- data.frame(
  type = c("Netting", "Line", "Rope", "Bag", "Monofilament", "String", "Unclassified"),
  color = c("red", "blue", "yellow", "green", "pink", "cyan", "black")
)


# useful functions to save time

addMarks <- function (x, type = c("start", "end"), clusters = NULL) {
  
  long <- paste0("~tow_lon_", type)
  latit <- paste0("~tow_lat_", type)
  

  leaflet::addCircleMarkers(x, lng = as.formula(long), 
                              lat = as.formula(latit),
                              popup = ~paste0(yearoftow, ": ", observation), radius = 3, 
                              color = ~color,
                              clusterOptions = clusters)
}