## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(k5)

gaa_2025 <- gaa %>%
  filter(seasonId == 2024) %>%
  mutate(seasonId = 2025)

gaa <- bind_rows(gaa, gaa_2025)

usethis::use_data(gaa, overwrite = TRUE)
readr::write_csv(gaa, "data-raw/gaa_ids.csv", na = "")
readr::write_rds(gaa, "data-raw/gaa_ids.rds")

