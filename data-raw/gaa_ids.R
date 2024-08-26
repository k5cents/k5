## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(k5)

gaa_2024 <- gaa %>%
  filter(seasonId == 2023) %>%
  mutate(
    seasonId = 2024,
    abbrev = fct_recode(abbrev, "JUST" = "CHAR")
  )

usethis::use_data(gaa, overwrite = TRUE)
readr::write_csv(gaa, "data-raw/gaa_ids.csv", na = "")

