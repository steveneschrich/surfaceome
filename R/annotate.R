




#' Title
#'
#' @param x
#' @param genes
#'
#' @return
#' @export
#'
#' @examples
annotate_transcriptome <- function(x, genes) {
  # First, collapse expression dataset to by-gene (instead of by-reporter).
  x_by_gene <- collapse_reporters(x, names = genes)

  # Then calculate the statistics on the full dataset
  stats <- calculate_gene_statistics(x_by_gene$x)

  stopifnot(nrow(x_by_gene$x) == nrow(stats))

  # Combine statistics and expression data
  full_x <- dplyr::bind_cols(
    stats,
    x_by_gene$x
  ) |>
    dplyr::mutate(
      Quartile = dplyr::case_when(
        median_quantile >= 0.75 ~ "Q4",
        median_quantile >= 0.50 ~ "Q3",
        median_quantile >= 0.25 ~ "Q2",
        TRUE ~ "Q1"
      )
    )

  full_x
}

#' Title
#'
#' @param x A matrix of gene expression
#' @param genes The list of gene names (possibly separated by `;`)
#' @param surfaceome The surfaceome table to join into results
#' @param surfaceome_identifier The column name to use as identifier. Should match the type of `genes`.
#'
#' @return
#' @export
#'
#' @examples
annotate_surfaceome <- function(x, genes, surfaceome = surfaceome::surfy, surfaceome_identifier = `UniProt gene`) {

  surfaceome_identifier <- rlang::enquo(surfaceome_identifier)
  # Annotate the full transcriptome first
  full_x <- annotate_transcriptome(x, genes)
  # Subset to surfaceome only rows
  surfaceome_x <- subset_surfaceome(full_x, dplyr::pull(surfaceome,!!surfaceome_identifier))

  # Finally, the data should join to surfaceome. Note, however, that the surfaceome may
  # not be unique on join column so distinct these first.
  s <-  surfaceome |>
    dplyr::filter(!is.na({{ surfaceome_identifier }})) |>
    dplyr::distinct({{ surfaceome_identifier }}, .keep_all = TRUE)
  cli::cli_alert_success(paste("Reduced surfy (n = {nrow(surfaceome)} to entries",
                               "with identifier ids (n = {nrow(s)})."))

  result_table <- dplyr::left_join(
    tibble::rownames_to_column(surfaceome_x, rlang::as_name(surfaceome_identifier)),
    s, by = rlang::as_name(surfaceome_identifier)
  )

  result_table <- result_table |>
    dplyr::mutate(
      glycomineO_count = ifelse(
        is.na(.data$`glycomineO sites`),
        0,
        stringr::str_count(.data$`glycomineO sites`,";")+1
      ),
      glycomineC_count = ifelse(
        is.na(.data$`glycomineC sites`),
        0,
        stringr::str_count(.data$`glycomineC sites`,";")+1
      ),
      Almen_Enzymes = ifelse(.data$`Membranome Almen main-class`=="Enzymes", "Enzymes", NA)
    )

  cli::cli_alert_success("Created surfy result table of {nrow(result_table)} genes from {nrow(x)} reporters.")

  result_table

}
