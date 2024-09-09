## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(k5)

gaa_2024 <- gaa %>%
  filter(seasonId == 2023) %>%
  mutate(
    seasonId = 2024,
    abbrev = fct_recode(abbrev, "JUST" = "CHAR")
  )

gaa <- bind_rows(gaa, gaa_2024)

usethis::use_data(gaa, overwrite = TRUE)
readr::write_csv(gaa, "data-raw/gaa_ids.csv", na = "")
readr::write_rds(gaa, "data-raw/gaa_ids.rds")

