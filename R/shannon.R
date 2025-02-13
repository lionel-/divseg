#' Compute Shannon Index
#'
#' @param .data [tibble][tibble::tibble-package]
#' @param .cols [`tidy-select`](https://tidyselect.r-lib.org/reference/language.html)
#' Columns to compute the measure with.
#' @param .name name for column with Shannon index. Leave missing to return a vector.
#'
#' @return a [tibble][tibble::tibble-package] or numeric vector if .name missing
#' @export
#'
#' @md
#' @concept div
#' @examples
#' data("de_county")
#' ds_shannon(de_county, starts_with('pop_'))
#' ds_shannon(de_county, starts_with('pop_'), 'shannon')
ds_shannon <- function(.data, .cols, .name){
  .cols <- rlang::enquo(.cols)

  if (missing(.name)) {
    .name <- 'v_index'
    ret_t <- FALSE
  } else {
    ret_t <- TRUE
  }

  out <- .data %>%
    drop_sf() %>%
    dplyr::rowwise() %>%
    dplyr::mutate(.total = sum(dplyr::c_across(!!.cols))) %>%
    dplyr::mutate(!!.name := -1 * sum( (dplyr::select(dplyr::cur_data(), !!.cols)/.data$.total) *
                                           log((dplyr::select(dplyr::cur_data(), !!.cols)/.data$.total))) ) %>%
    dplyr::pull(!!.name)

  if (ret_t) {
    .data %>% dplyr::mutate(!!.name := out) %>% relocate_sf()
  } else {
    out
  }
}

#' @rdname ds_shannon
#' @param ... arguments to forward to ds_shannon from shannon
#' @export
shannon <- function(..., .data = dplyr::cur_data_all()) {
  ds_shannon(.data = .data, ...)
}
