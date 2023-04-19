# 11-process_surfy

surfy <- readxl::read_excel(
  here::here("data-raw","surfy","table_S3_surfaceome.xlsx"),
  sheet = "in silico surfaceome only",
  skip = 1
)
surfy_almen <- readxl::read_excel(
  here::here("data-raw/surfy/dataset_s01.xls"),
  sheet = "11.10_protein_groups_Fig3F", skip=1
)

surfy <- surfy |>
  dplyr::left_join(surfy_almen, by = c("UniProt accession"="Protein"))
cli::cli_alert_success("Loaded Surfy source data.")

surfy_gene <- surfy |>
  dplyr::mutate(GENE = `UniProt gene`)


x <- surfy |>
  dplyr::mutate(GeneID = as.character(GeneID)) |>
  dplyr::filter(!is.na(GeneID))


cli::cli_alert_info("Annotating Surfy for HG-U133Plus 2.0")
surfy_hgu133plus2 <- AnnotationDbi::mapIds(
  hgu133plus2.db::hgu133plus2.db,
  keytype="ENTREZID",
  keys = unique(x$GeneID),
  column = "PROBEID"
) |>
  tibble::enframe(value = "PROBEID", name = "ENTREZID") |>
  dplyr::filter(!is.na(PROBEID)) |>
  dplyr::left_join(x, by=c("ENTREZID"="GeneID"))


usethis::use_data(surfy, surfy_gene, surfy_hgu133plus2, overwrite = TRUE)
cli::cli_alert_success("Created package data object `surfy`, `surfy_gene` and `surfy_hgu133plus2`")
