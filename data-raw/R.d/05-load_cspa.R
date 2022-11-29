# The table is unique in protein identifier space (ID_link)
cspa <- readxl::read_excel(here::here("data-raw","cspa","S2_File.xlsx"), sheet = "Table A")

stopifnot(!any(duplicated(cspa$ID_link)))
stopifnot(all(cspa$organism=="Human"))

# We reannotate the
# We also want a gene identifier focused version. Note that this means
cspa_gene <- dplyr::mutate(cspa, GENE = `ENTREZ gene symbol`)

# Input
# uniprotswissprot
# Output
# <?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE Query>
#  <Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" >
#
#  <Dataset name = "hsapiens_gene_ensembl" interface = "default" >
#  <Filter name = "uniprotswissprot" value = "P08473,Q92854"/>
##  <Attribute name = "ensembl_gene_id" />
#  <Attribute name = "ensembl_gene_id_version" />
#  <Attribute name = "ensembl_peptide_id" />
#  <Attribute name = "hgnc_symbol" />
#  <Attribute name = "entrezgene_id" />
#  </Dataset>
#  </Query>

x<-cspa |>
  dplyr::mutate(ENTREZ_gene_ID = as.character(ENTREZ_gene_ID)) |>
  dplyr::filter(!is.na(ENTREZ_gene_ID))

cspa_hgu133plus2 <- AnnotationDbi::select(
  hgu133plus2.db::hgu133plus2.db,
  keytype="ENTREZID",
  keys = x$ENTREZ_gene_ID,
  columns = c("PROBEID")
) |>
  dplyr::filter(!is.na(PROBEID)) |>
  dplyr::left_join(x, by=c("ENTREZID"="ENTREZ_gene_ID"))


usethis::use_data(cspa, cspa_gene, cspa_hgu133plus2, overwrite = TRUE)
