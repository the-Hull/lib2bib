#' @importFrom stringi stri_extract
extract_packages <- function(text){
    # extracts package names from text file
    # finds all library/require(),
    # and explicit package::function() calls


    # drop comments
    text <- text[!grepl("[ ]*(#).*$", text)]
    # grab packages (loading)
    loaded <- text[grepl("(library|require)\\(([a-zA-Z0-9]*)\\)",
                       text)]
    pkgs_load <- gsub(".*(library|require)\\(([a-zA-Z0-9]*)\\).*",
                 "\\2",
                 loaded)


    pkgs_colon <- stringi::stri_extract(text, regex = "([[:alnum:]]+)(?=::)")

    # grab packages (explicit :: notation)
    pkgs <- c(pkgs_load,
              pkgs_colon[!is.na(pkgs_colon)])



    #           gsub(pattern = "(\w+)(?=::)",
    #           # gsub(pattern = "(.*[[:graph:][:space:]]){0,1}([a-zA-Z0-9]*)(::)(.*)",
    #                x = text[grepl(pattern = "([a-zA-Z])+(::){1}", x = text)],
    #                replacement = "\\2",
    #                perl = TRUE)
    # )
    return(unique(pkgs))


}


check_if_r <- function(path){
    # https://github.com/juba/questionr/blob/master/R/utils.R

    is_r <- grepl(pattern = "[.]r$", x = path, ignore.case = TRUE)

    return(is_r)

}

check_if_rmd <- function(path){
    # https://github.com/juba/questionr/blob/master/R/utils.R

    is_rmd <- grepl(pattern = "[.]rmd$", x = path, ignore.case = TRUE) ||
        grepl(pattern = "[.]rmarkdown$", x = path, ignore.case = TRUE)

    return(is_rmd)

}





#' @importFrom purrr map2
make_bibtex_list <- function(libs_bibtex){



    # id indices of each entry
    id_entries <- function(libs_bibtex){


        entry_start <- grep(pattern = "^@[[:alnum:]]+[{][,]",
                            x = libs_bibtex)


        entry_end <- grep(pattern = "^[}]$",
                          x = libs_bibtex)


        entries <- cbind(entry_start, entry_end)
        n_entries <- nrow(entries)

        entry_details <- list(entries = entries,
                              n_entries = n_entries)

        return(entry_details)
    }



    entries <- lapply(libs_bibtex, id_entries)



    res_libs <- vector(mode = "list",
                       length = sum(sapply(entries,
                                           `[[`,
                                           "n_entries")))




    names(res_libs) <- unlist(
        purrr::map2(
            names(sapply(entries, `[[`, "n_entries")),
            sapply(entries, `[[`, "n_entries"),
            rep))


    # fill res libs based on number of items in entries
    res_libs_idx <- 1
    for(j in seq_along(entries)){

        n_entries <- entries[[j]][["n_entries"]]

        # fill list items with each occurence of an entry
        res_libs[res_libs_idx:(res_libs_idx+n_entries-1)] <-
             purrr::map2(entries[[j]][['entries']][,'entry_start'],
                                        entries[[j]][['entries']][,'entry_end'],
                                        function(x,y){
                                            c(libs_bibtex[[j]][x:y])
                                        })

        res_libs_idx <- sum(sapply(res_libs, Negate(is.null))) + 1


    }


    return(res_libs)


}
