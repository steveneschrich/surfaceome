#' Subset
#'
#' The surfaceome table (UniProt gene) has only one gene identifier per line (although
#' it has multiple lines with the same gene symbol). The experimental data, however,
#' may have gene smbols that are actually a list (separated with ;). So subsetting to
#' the surfaceome is a little more complicated.
#'
#' @param x
#' @param surfaceome
#'
#' @return
#' @export
#'
#' @examples
subset_surfaceome <- function(x, surfaceome = surfaceome::surfy$`UniProt gene`) {
  sgenes <- unique(stats::na.omit(surfaceome))
  cli::cli_alert_success(paste("Reduced surfy (n = {length(surfaceome)} to entries",
                               "with 'UniProt gene' ids (n = {length(sgenes)})."))

  # From surfy data, reduce the experiment
  gene_symbols<-stringr::str_split(rownames(x), "; ")
  surfaceome_match <- purrr::map_chr(
    gene_symbols,
    \(.x) {
      all_matches <- intersect(.x, sgenes)
      if ( length(all_matches) > 1 ) {
        cli::cli_alert_warning("Multiple matches on {.x} from experiment to Surfy genes. Arbitrarily picking the first one.")
        return(all_matches[1])
      } else if ( length(all_matches) == 1)
        return(all_matches)
      else return(NA)

    }
  )
  is_surfaceome <- purrr::map_lgl(
    gene_symbols,
    \(.x) {
      any(.x %in% sgenes)
    }
  )

  xf <- x[is_surfaceome,]
  xf <- collapse_reporters(xf, names = surfaceome_match[is_surfaceome])
  cli::cli_alert_success("Reduced experiment to surfaceome from {nrow(x)} to {nrow(xf$x)} genes.")

  xf$x

}
