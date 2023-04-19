dir.create(here::here("data-raw/cspa"), showWarnings=FALSE)
dir.create(here::here("data-raw/surfy"), showWarnings=FALSE)


src <- "https://wlab.ethz.ch/cspa/data/S2_File.xlsx"
dest <- "data-raw/cspa/S2_File.xlsx"
cli::cli_alert_info("Downloading {src}")
curl::curl_download(
  url=src,
  destfile = here::here(dest)
)
cli::cli_alert_success("Downloaded {dest} ({fs::file_size(here::here(dest))})")

src <- "http://wlab.ethz.ch/surfaceome/table_S3_surfaceome.xlsx"
dest <- "data-raw/surfy/table_S3_surfaceome.xlsx"
cli::cli_alert_info("Downloading {src}")
curl::curl_download(
  url=src,
  destfile = here::here(dest)
)
cli::cli_alert_success("Downloaded {dest} ({fs::file_size(here::here(dest))})")

