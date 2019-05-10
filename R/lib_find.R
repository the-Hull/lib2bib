#' Find all packages used in scripts
#'
#' @description Find all packages used via _library()_ in your project, a folder, or file.
#' @param path Charater. Defines path to project file, a folder or an individual rmarkdown or script file. Defaults to current working directory
#' @param verbose Logical. Set as TRUE if results from all files are to be reported
#'
#' @return Returns a list containing all packages used in file(s) supplied by path
#' @export
#'
#' @rdname lib_find
#'
#' @importFrom attempt stop_if_not

#'
#' @examples \dontrun{lib_find()}
lib_find <- function(path = ".", verbose = FALSE){
    # checks
attempt::stop_if_not(path, is.character, msg = "Please supply a character string defining a path to your script (files)")


    # set-up
    if(grepl(pattern = "[.][Rr][Pp][Rr][Oo][Jj]$", x = path)){
        # from https://stackoverflow.com/questions/15073753/regex-return-file-name-remove-path-and-file-extension
        path <- sub("(.*\\/)([^.]+)(\\.[[:alnum:]]+$)", "\\1", path)
    }


    # https://github.com/juba/questionr/blob/master/R/utils.R


    if(check_if_r(path) ||
       check_if_rmd(path)
       ){
        # from https://stackoverflow.com/questions/15073753/regex-return-file-name-remove-path-and-file-extension

        files <- list(path)

    } else {

        files <-  dir(path = path,
                      pattern="\\.R$|\\.Rmd$|\\.$Rmarkdown",
                      ignore.case = TRUE,
                      recursive = TRUE,
                      full.names = TRUE)

    }





    # parse
    libs <- sapply(files, FUN = function(x) {

        if(check_if_rmd(x)){
            cat("is RMD!!!!")
            temp_r_extracted <- tempfile(fileext  = ".R")
            knitr::purl(x, output = temp_r_extracted)
            conn <- file(temp_r_extracted)
            text <- readLines(conn, warn = FALSE)
            unlink(temp_r_extracted)


        } else {

            conn <- file(x)

            text <- readLines(conn, warn = FALSE)
        }


        close(conn)


        # # drop comments
        # text <- text[!grepl("^(#).*$", text)]
        # # grab packages (loading)
        # text <- text[grepl("(library|require)\\(([a-zA-Z0-9]*)\\)", text)]
        # pkgs <- gsub(".*(library|require)\\(([a-zA-Z0-9]*)\\).*", "\\2", text)
        #
        # # grab packages (explicit)
        # text <- text[grepl("(library|require)\\(([a-zA-Z0-9]*)\\)", text)]
        # pkgs <- rbind(pkgs,
        #               gsub(".*(library|require)\\(([a-zA-Z0-9]*)\\).*", "\\2", text)
        #               )

        pkgs <- extract_packages(text)
        unique(pkgs)

    })
    all(sapply(libs, length) == 0)

    if(all(sapply(libs, length) == 0)){

        stop(paste0("scanned ",
                    length(files),
                    " file(s) and found no explicit package use"))



    }


    # clean resulting list

    # by dropping 0 length list element
    clean_libs <- libs[sapply(libs, function(x){length(x) > 0})]

    # by subsequently cleaning  lists with strings of 0 length
    clean_libs <- clean_libs[sapply(clean_libs, function(x){any(nchar(x) != 0)})]


    # print message on scanned files
    if(verbose){
        cat(paste0("scanned ",
                   length(files),
                   " files, of which ",
                   length(libs) - length(clean_libs),
                   " had no package entry.\n",
                   "Used packages are:\n"
                   ),
            as.character(unlist(clean_libs)))
    }

    clean_libs <- as.character(unlist(clean_libs))


    # if(length(clean_libs) == 0){
    #
    #     stop(paste0("scanned ",
    #                 length(files),
    #                 " file(s) and found no package use"))
    #


    # } else {

    info_libs <- installed.packages()[installed.packages()[,"Package"] %in%
                                          clean_libs,]

    return(info_libs)

    # }




}


