# 10-process_cspa

cspa <- readxl::read_excel(here::here("data-raw","cspa","S2_File.xlsx"), sheet = "Table A")
cli::cli_alert_success("Loaded CSPA source data.")

cspa_gene <- dplyr::mutate(cspa, GENE = `ENTREZ gene symbol`)

x<-cspa |>
  dplyr::mutate(ENTREZ_gene_ID = as.character(ENTREZ_gene_ID)) |>
  dplyr::filter(!is.na(ENTREZ_gene_ID))

cli::cli_alert_info("Annotating CSPA for HG-U133Plus 2.0")
cspa_hgu133plus2 <- AnnotationDbi::mapIds(
  hgu133plus2.db::hgu133plus2.db,
  keytype="ENTREZID",
  keys = unique(x$ENTREZ_gene_ID),
  column = "PROBEID"
) |>
  tibble::enframe(value = "PROBEID", name = "ENTREZID") |>
  dplyr::filter(!is.na(PROBEID)) |>
  dplyr::left_join(x, by=c("ENTREZID"="ENTREZ_gene_ID"))

usethis::use_data(cspa, cspa_gene, cspa_hgu133plus2, overwrite = TRUE)
cli::cli_alert_success("Created package data object `cspa`, `cspa_gene` and `cspa_hgu133plus2`")
