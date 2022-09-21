## code to prepare `DATASET` dataset goes here

usethis::use_data(gaa, overwrite = TRUE)
readr::write_csv(gaa, "data-raw/gaa_ids.csv", na = "")

