#' Title
#'
#' @param x
#' @param names
#'
#' @return
#' @export
#'
#' @importFrom rlang .data
#' @examples
collapse_reporters <- function(x, names, stat = c("median","mean")) {
  stopifnot(nrow(x) == length(names))
  stat <- match.arg(stat, c("median","mean"))


  # Subset x and names for any missing names
  x <- x[!is.na(names),]
  names <- stats::na.omit(names)

  # Combine matrix x with medians and names to summarize
  xp <- tibble::tibble(
    reporters = rownames(x),
    names = names,
    stats = if ( stat == "median" ) {
      matrixStats::rowMedians(as.matrix(x))
    } else {
      rowMeans(as.matrix(x))
    }
  ) |>
    # Group by the names argument
    dplyr::group_by(names) |>
    # Assemble all reporters in the group as a single string
    dplyr::mutate(reporter_list=list(reporters))|>
    # Choose the max
    dplyr::slice_max(order_by = .data$stats, with_ties = FALSE, n = 1) |>
    dplyr::ungroup()

  # We want to return a matrix (or data frame?) and a list of reporters
  reporters <- dplyr::select(xp, .data$names, .data$reporter_list) |>
    tibble::deframe()

  xp <- x[xp$reporters,]
  rownames(xp) <- names(reporters)

  cli::cli_alert_info("Collapsed gene matrix from {nrow(x)} to {nrow(xp)} from repeated measurements.")
  list(x = xp, reporters = reporters)
}
