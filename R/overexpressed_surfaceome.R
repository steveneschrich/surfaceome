#' Calculate the over-expressed surfaceome
#'
#' @param x A matrix of expression data
#' @param which Which surfaceome definition to use (surfy or cspa)
#'
#' @return A ordering of the gene expression by over-expression (median expression).
#' @export
#'
#' @examples
overexpressed_surfaceome <- function(x, which=c("surfy","cspa")) {
  stopifnot(class(x) %in% c("ExpressionSet"))

  which <- match.arg(which,c("surfy","cspa"))

  gex <- Biobase::exprs(x)[surfaceome::surfy_gene$GENE,]
  gex_median <- Biobase::rowMedians(gex)

  gex[order(gex_median, decreasing = TRUE),]
  # return result - median column
}
