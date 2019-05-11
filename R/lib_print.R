#' Print package citations
#'
#' @param libs Character (string) of package name(s) or Dataframe with a column "Package".
#' @param textformat Logical. Print as text version or as BibTeX.
#' @param silent Logical. If TRUE, will output a list for subsequent use. If FALSE, prints bibliography (ready for e.g. copy-paste or capture).
#'
#' @return Returns a list of citations, either in text or BibTeX format.
#' @export
#'
#' @description Print bibliography of all identified packages, or output a list for subsequent use.
#'
#'
#' @usage lib_print(libs, textformat = TRUE, silent = FALSE)
#'
#' @examples lib_print("base")
lib_print <- function(libs, textformat = TRUE, silent = FALSE){

    # check for object type and adjust call to citation
    citations <- check_if_libs_is_df(libs)


    # get citations in either text or bibtex format
    if(textformat){

        text_citations <- sapply(citations, function(x){
            sapply(unclass(x),
                   attr,
                   "textVersion")
        })


        if(is.data.frame(libs)){
            names(text_citations) <- as.character(libs$Package)

        } else {
            names(text_citations) <- libs

        }

        if(isFALSE(silent)){
            cat(unlist(text_citations), sep = "\n\n")
            return(invisible(text_citations))
        }


        return(text_citations)


    } else if(isFALSE(textformat)){



        bibtex_citations <- sapply(citations, toBibtex)

        if(is.data.frame(libs)){
            names(bibtex_citations) <- as.character(libs$Package)

        } else {
            names(bibtex_citations) <- libs

        }

        if(isFALSE(silent)){
            cat(unlist(bibtex_citations), sep = "\n")
            return(invisible(bibtex_citations))
        }


        return(bibtex_citations)


    }






}
