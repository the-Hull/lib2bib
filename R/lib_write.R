#' Write identified packages to a new (or append to existing) bibliography file
#'
#' @param libs Character (string) of package name(s) or Dataframe with a column "Package".
#' @param path_out Character. Path to new or existing bibliography file
#' @param append Logical. Determines if package bibliography should be appended or not
#' @param textformat Logical. Determines if plain-text or bibtex format should be used
#'
#' @usage lib_write(libs, path_out, append, textformat = TRUE)
#'
#' @description The bibliography of identified packages can be saved in two formats (plain-text or bibtex). Currently, the function does not recognize the text format from the file ending, so ensure to set the argument appropriately.
#'
#' @export
#'
#' @examples \dontrun{
#'
#' lib_write(libs, ".", append = FALSE)
#' }
lib_write <- function(libs, path_out, append = FALSE, textformat = TRUE){




    # open sink to capture output
    sink(file = file(description = path_out,
                     encoding = "UTF-8"),
         type = "output",
         append = append)

    # generate output without list

    if(isFALSE(textformat)){
        cat("% Encoding: UTF-8\n\n\n")
    }

    invisible(lib_print(libs = libs,textformat = textformat, silent = FALSE))


    #close sink
    sink()



}
