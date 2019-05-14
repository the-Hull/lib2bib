#' Find all packages used in scripts
#'
#' @description Find all packages used via library(), require() or with package::function() in your project, a folder, or in a file (.R, .Rmd, .Rmarkdown; not case sensitive).
#'
#'
#' @param path Charater. Defines path to project file, a folder or an individual rmarkdown or script file. Defaults to current working directory
#' @param verbose Logical. Set to TRUE for an informative message.
#'
#' @return Returns a data.frame resulting from a call to installed.packages, containing all packages used in file(s) supplied by path.
#' @export
#'
#' @rdname lib_find
#' @usage lib_find(path = ".", verbose = FALSE)
#'
#' @importFrom attempt stop_if_not
#' @importFrom attempt stop_if
#' @importFrom knitr purl
#' @importFrom crayon red
#' @importFrom crayon blue
#' @importFrom crayon green

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


    attempt::stop_if(length(files),  ~ . == 0,
                     msg = cat(paste0(crayon::red("Couldn't find any R scripts or markdown files."), " Please supply a different path and try again.")))


    # parse
    libs <- sapply(files, FUN = function(x) {

        if(check_if_rmd(x)){

            temp_r_extracted <- tempfile(fileext  = ".R")
            knitr::purl(x, output = temp_r_extracted, quiet = TRUE)
            conn <- file(temp_r_extracted)
            text <- readLines(conn, warn = FALSE)
            unlink(temp_r_extracted)


        } else {

            conn <- file(x)

            text <- readLines(conn, warn = FALSE)
        }


        close(conn)


        pkgs <- extract_packages(text)
        unique(pkgs)

    })
    all(sapply(libs, length) == 0)

    if(all(sapply(libs, length) == 0)){

        stop(cat(paste0("scanned ",
                    crayon::blue(length(files)),
                    " file(s) and found no explicit package use")))



    }


    # clean resulting list

    # drop 0 length list element
    clean_libs <- libs[sapply(libs, function(x){length(x) > 0})]

    # drop lists with strings of 0 length
    clean_libs <- clean_libs[sapply(clean_libs, function(x){any(nchar(x) != 0)})]

    # drop NAs (from stringr?)
    clean_libs <- clean_libs[!is.null(clean_libs)]




    clean_libs <- unique(as.character(unlist(clean_libs)))

    # print message on scanned files

    if(verbose){
        cat(paste0("scanned ",
                   crayon::blue(length(files)),
                   " files, and found ",
                   crayon::blue(length(clean_libs)),
                   " package entries \n",
                   "using either library, require, or double-colon notation.\n",
                   "Used packages are:\n"
        ),
        crayon::green(clean_libs))
    }



    # } else {

    info_libs <- utils::installed.packages()[utils::installed.packages()[,"Package"] %in%
                                          clean_libs,]

    return(as.data.frame(info_libs, stringsAsFactors = FALSE))

    # }




}


