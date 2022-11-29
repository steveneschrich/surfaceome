#' Title
#'
#' @param x
#' @param which
#'
#' @return
#' @export
#'
#' @examples
overexpressed_surfaceome <- function(x, which=c("surfy","cspa")) {
  stopifnot(class(x) %in% c("ExpressionSet"))

  which <- match.args(which,c("surfy","cspa"))
  data(surfy_gene)

  gex <- Biobase::exprs(x)[surfy_gene$GENE,]
  gex_median <- Biobase::rowMedians(gex)

  gex[order(gex_median, decreasing = TRUE),]
  # return result - median column
}
