#' Print package citations
#'
#' @param libs Character (string) of package name(s) or Dataframe with a column "Package".
#' @param textformat Logical. Print as text version or as BibTeX.
#'
#' @return Returns a list of citations, either in text or BibTeX format.
#' @export
#'
#' @usage lib_print(libs, textformat = TRUE)
#'
#' @examples lib_print("base")
lib_print <- function(libs, textformat = TRUE){

    # check for object type and adjust call to citation
    if(is.data.frame(libs)){
        citations <- lapply(libs$Package, citation)

    } else {
        citations <- lapply(libs, citation)

    }



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

        return(text_citations)


    } else {



        bibtex_citations <- sapply(citations, toBibtex)

        if(is.data.frame(libs)){
            names(bibtex_citations) <- as.character(libs$Package)

        } else {
            names(bibtex_citations) <- libs

        }
        return(bibtex_citations)


    }





}
