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
      grepl("net", observation, ignore.case = TRUE) ~ "Netting",
      grepl("line|twine|fishing", observation, ignore.case = TRUE) ~ "Line",
      grepl("rope", observation, ignore.case = TRUE) ~ "Rope",
      grepl("bag|plastic", observation, ignore.case = TRUE) ~ "Bag",
      grepl("monofilament", observation, ignore.case = TRUE) ~ "Monofilament",
      grepl("string|cord|tape|binding|fibre", observation, ignore.case = TRUE) ~ "String",
      1L == 1L ~ "Unclassified"
  )
)

# save as an RDS file

saveRDS(data, "data/data.RDS")


