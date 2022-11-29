dir.create(here::here("data-raw/cspa"), showWarnings=FALSE)
dir.create(here::here("data-raw/surfy"), showWarnings=FALSE)


logger::log_info("Downloading S2_File")
curl::curl_download(
  url="https://wlab.ethz.ch/cspa/data/S2_File.xlsx",
  destfile = here::here("data-raw/cspa/S2_File.xlsx")
)

logger::log_info("Downloading S3_surfaceome")
curl::curl_download(
  url="http://wlab.ethz.ch/surfaceome/table_S3_surfaceome.xlsx",
  destfile = here::here("data-raw/surfy/table_S3_surfaceome.xlsx")
)

