#' Numeric Vector Report
#'
#' Create a report of a numeric vector.
#'
#' @param x a dataframe.
#' @param median show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param dispersion show dispersion (\link{sd} or \link{mad}).
#' @param range show range.
#' @param missing_percentage show missings by number (default) or percentage
#' @param ... arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' x <- rnorm(1000)
#' report(x)
#' report(x, median = TRUE, dispersion = TRUE, range = TRUE, missing_percentage = TRUE)
#' print(report(x), full=TRUE)
#'
#' @seealso report
#' @import dplyr
#' @importFrom stats mad sd
#'
#' @export
report.numeric <- function(x, median = FALSE, dispersion = TRUE, range = TRUE, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame(
    Mean = mean(x),
    SD = sd(x),
    Median = median(x),
    MAD = mad(x),
    Min = min(x),
    Max = max(x),
    n_Obs = length(x),
    n_Missing = sum(is.na(x))
  )
  table_full$perc_Missing <- table_full$n_Missing / table_full$n_Obs


  # Text --------------------------------------------------------------------
  # Centrality
  text_mean <- paste0("Mean = ", format_value(table_full$Mean[1]))
  text_median <- paste0("Median = ", format_value(table_full$Median[1]))

  # Dispersion
  text_sd <- format_value(table_full$SD[1])
  text_mad <- format_value(table_full$MAD[1])

  # Range
  text_range <- paste0(" [", format_value(table_full$Min[1]), ", ", format_value(table_full$Max[1]), "]")

  # Missings
  if (missing_percentage == TRUE) {
    text_missing <- paste0(", ", format_value(table_full$perc_Missing[1], 1), "% missing.")
  } else {
    text_missing <- paste0(", ", table_full$n_Missing[1], " missing.")
  }



  # Selection ---------------------------------------------------------------
  table <- table_full
  if (median == TRUE) {
    if (dispersion == TRUE) {
      text <- paste0(text_median, " +- ", text_mad)
      table <- dplyr::select(table, -one_of("Mean", "SD"))
    } else {
      text <- text_median
      table <- dplyr::select(table, -one_of("Mean", "SD", "MAD"))
    }
  } else {
    if (dispersion == TRUE) {
      text <- paste0(text_mean, " +- ", text_sd)
      table <- dplyr::select(table, -one_of("Median", "MAD"))
    } else {
      text <- text_mean
      table <- dplyr::select(table, -one_of("Median", "MAD", "SD"))
    }
  }

  if (range == TRUE) {
    text <- paste0(text, text_range)
  } else {
    table <- dplyr::select(table, -one_of("Min", "Max"))
  }

  if (missing_percentage == TRUE) {
    table <- dplyr::select(table, -one_of("n_Missing"))
  } else {
    table <- dplyr::select(table, -one_of("perc_Missing"))
  }


  # Text
  text_full <- paste0(
    text_mean, ", SD = ", text_sd, ", ",
    text_median, ", MAD = ", text_mad, ", Range =",
    text_range, text_missing
  )

  if (table_full$n_Missing[1] > 0) {
    text <- paste0(text, text_missing)
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full
  )

  # class(out) <- c("report", class(out))
  return(as.report(out))
}