# prep data for use in CPR app

# load libraries

library(dplyr)
library(openxlsx)

# load original data file and make colnames easier to code with

data <- openxlsx::read.xlsx("data/Supplementary_Data_1.xlsx", sheet = 1, startRow = 2)

colnames(data) <- gsub("[.]", "", colnames(data)) %>% 
  tolower()

colnames(data)[grepl("region", colnames(data))] <- "region"

# create columns to classify by key term

data <- data %>% 
  dplyr::mutate(
    type = dplyr::case_when(
      grepl("net", observation, ignore.case = TRUE) == TRUE ~ "Netting",
      grepl("line | twine", observation, ignore.case = TRUE) == TRUE ~ "Line",
      grepl("rope", observation, ignore.case = TRUE) == TRUE ~ "Rope",
      grepl("bag", observation, ignore.case = TRUE) == TRUE ~ "Bag",
      grepl("monofilament", observation, ignore.case = TRUE) == TRUE ~ "Monofilament",
      sum(grepl("string | cord | tape | binding | fibre", observation, ignore.case = TRUE)) > 0 ~ "String",
      1L == 1L ~ "Unclassified"
  )
)

saveRDS(data, "data/data.RDS")


