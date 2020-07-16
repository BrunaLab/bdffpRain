#' Spread accumulated values following NAs out over previous observations
#'
#' Takes the value after any number of NAs and replaces that value, and the
#' preceding NAs (up to `max_n` previous values) with that value divided by the
#' number of NAs (or `max_n` if supplied) plus 1.
#' 
#' @note This function doesn't replace leading or trailing NAs
#' @param x a numeric vector
#' @param max_n integer; what is the maximum number of observations backwards
#'   you'd like to fill.  If a gap is larger than this, the preceding `max_n`
#'   NAs will be replaced, but NAs before that will remain.
#'
#' @return a numeric vector with NAs replaced
#' @importFrom dplyr lag
#' @export
#'
#' @examples
#' x <- c(1, 2, 3, NA, NA, 6)
#' spread_back(x)
spread_back <- function(x, max_n = NULL) {
  names(x) <- 1:length(x)
  cumna <- cumsum(is.na(x))
  gaps <- cumna[!is.na(x)] - dplyr::lag(cumna[!is.na(x)])
  len <- gaps[which(gaps > 0)]
  ind <- as.numeric(names(len))
  if(!missing(max_n)) {
    len[len > max_n] <- max_n
  }
  for (i in 1:length(len)) {
    x[(ind[i] - len[i]):ind[i]] <- x[ind[i]]/(len[i] + 1) 
  }
  names(x) <- NULL
  return(x)
}