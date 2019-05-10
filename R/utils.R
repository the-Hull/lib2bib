extract_packages <- function(text){
    # extracts package names from text file
    # finds all library/require(),
    # and explicit package::function() calls


    # drop comments
    text <- text[!grepl("[ ]*(#).*$", text)]
    # grab packages (loading)
    loaded <- text[grepl("(library|require)\\(([a-zA-Z0-9]*)\\)",
                       text)]
    pkgs <- gsub(".*(library|require)\\(([a-zA-Z0-9]*)\\).*",
                 "\\2",
                 loaded)

    # grab packages (explicit :: notation)
    pkgs <- c(pkgs,
              gsub(pattern = "(.*[ ]){0,1}([a-zA-Z0-9]*)(::)(.*)",
                   x = text[grepl(pattern = "([a-zA-Z])+(::){1}", x = text)],
                   replacement = "\\2",
                   perl = TRUE)
    )
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
