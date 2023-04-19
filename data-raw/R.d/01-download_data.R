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

src <- "https://www.pnas.org/doi/suppl/10.1073/pnas.1808790115/suppl_file/pnas.1808790115.sd01.xls"
dest <- "data-raw/surfy/dataset_s01.xls"
cli::cli_alert_info("Downloading {src}")
curl::curl_download(
  url=src,
  destfile = here::here(dest),
  handle = curl::new_handle(ssl_verifyhost=0)
)
cli::cli_alert_success("Downloaded {dest} ({fs::file_size(here::here(dest))})")
