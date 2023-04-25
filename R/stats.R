

#' Calculate gene statistics for a matrix
#'
#' @param x A matrix to calculate gene statistics
#'
#' @return
#' @export
#'
#' @examples
calculate_gene_statistics <- function(x) {

  # Calculate median rank
  median_rank <- apply(x, 2, data.table::frank) |>
    matrixStats::rowMedians()
  # Calculate median quantile of gene expression
  median_quantile <- apply(x, 2, \(x) stats::ecdf(x)(x)) |>
    matrixStats::rowMedians()

  # Calculate median expression
  median_expr <- matrixStats::rowMedians(x)

  data.frame(
    median_rank = median_rank,
    median_quantile = median_quantile,
    median_expression = median_expr,
    row.names = rownames(x)
  )
}
