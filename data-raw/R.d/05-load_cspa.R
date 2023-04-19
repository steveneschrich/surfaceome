# The table is unique in protein identifier space (ID_link)
cspa <- readxl::read_excel(here::here("data-raw","cspa","S2_File.xlsx"), sheet = "Table A")

stopifnot(!any(duplicated(cspa$ID_link)))
stopifnot(all(cspa$organism=="Human"))


curl::curl_download(
  url="https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/by_organism/HUMAN_9606_idmapping.dat.gz",
  destfile = here::here("data-raw/uniprot/HUMAN_9606_idmapping.dat.gz")
)
idmap <- vroom::vroom(
  here::here("data-raw/uniprot/HUMAN_9606_idmapping.dat.gz"),
  delim="\t",
  col_types = "ccc",
  col_names = c("UniprotKB-AC","ID_type","ID")
)

# NOTE: The data here is not new so the annotations are likely somewhat out of date. We
# try to reannotate the information here using the following approach.
#
# First, we think that ID_link is the identifier that was used to determine a unique
# entry. These are uniprot id's, so we can remap these to newer uniprot id's in case
# they have been merged/changed (which happens often enough). To do this, we used the
# uniprot mapping tool: https://www.uniprot.org/id-mapping
#
readr::write_tsv(dplyr::select(cspa,ID_link), file = here::here("data-raw/work/uniprot_ids_for_annotation.txt"))
# Map the ID's and export to JSON
jo <- jsonlite::read_json(here::here("data-raw/uniprot/cspa_id_map_json_format_20221203.gz"))

uniprot_mapping <- purrr::map_dfr(x$results, ~list(from=.x$from, to=.x$to$primaryAccession))
#
# To
# We reannotate the
# We also want a gene identifier focused version. Note that this means
cspa_gene <- dplyr::mutate(cspa, GENE = `ENTREZ gene symbol`)

# Downloading from uniprot:
#
# https://rest.uniprot.org/uniprotkb/stream?compressed=true&fields=accession%2Creviewed%2Cid%2Cprotein_name%2Cgene_names%2Corganism_name%2Clength%2Cxref_ensembl%2Cxref_geneid%2Cxref_hgnc&format=tsv&query=%28%2A%29%20AND%20%28model_organism%3A9606%29

#
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
