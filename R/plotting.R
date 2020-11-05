#' Add SPI or SPEI indicators to a ggplot
#'
#' @param p a ggplot object
#' @param ... other arguments passed to [annotate()], e.g. `alpha`
#'
#' @return a ggplot object
#' @export
#'
#' @examples
annotate_spei <- function(p, ...) {
  spei_rects <- list(
    annotate(geom = "rect", xmin = -Inf, xmax = Inf, ymin = -4.2, ymax = -2, fill = "#e31a1c", ...),
    annotate(geom = "rect", xmin = -Inf, xmax = Inf, ymin = -2, ymax = -1.5, fill = "#fd8d3c", ...),
    annotate(geom = "rect", xmin = -Inf, xmax = Inf, ymin = -1.5, ymax = -1, fill = "#fecc5c", ...),
    annotate(geom = "rect", xmin = -Inf, xmax = Inf, ymin = -1, ymax = 0, fill = "#ffffb2", ...) 
  )
  #add rectangles
  P2 <- p + spei_rects
  #now, move the last 4 layers to the bottom
  nlayers <- length(P2$layers)
  P2$layers <- c(P2$layers[(nlayers-3):nlayers], P2$layers[1:(nlayers-4)])
  return(P2)
}
