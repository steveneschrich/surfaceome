# Overview
See the `README.md` in the main directory for details on the source data. It is from two different research projects (I believe the same group), but both are trying to assemble a list of surfaceome proteins/genes. CSPA (Cell Surface Protein Atlas) is an experimentally derived list of surface proteins. The other (SURFY) is machine learning inferred. This document is to load these tables and make them available in R. The files are available on their respective websites as well as in the publications.



## CSPA
The Cell Surface Protein Atlas is an empirically determined set of surface proteins. We are using `S2_File.xlsx` from the website, which is the same as in the publication. There are a couple of sheets in the spreadsheet. Per the paper (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4404347/) we want `Table A` which is the list of human surfaceome proteins.

Note there isn't much to do here, since each omics type will require it's own mapping. We provide the default (gene) mapping which is what is comes with (RNASeq data should probably use the `ENTREZ gene symbol` field). Mapping to the U133 chip should involve the `ENTREZ_gene_id` field.

For convenience, I will create two different tables:
- `cspa` the original
- `cspa_gene` original with GENE (not sure about name)
- `cspa_u133plus2` original with probeset

