
#' Interactively choose which citations to keep
#'
#' @param libs Character (string) of package name(s) or Dataframe with a column "Package".
#' @param textformat Logical. Print as text version or as BibTeX.
#'
#' @description Opens an interactive shiny interface. Select desired packages, print them to console, copy them to the  clipboard and/or save them to disk (write new file or append). Note, that the download only captures entries visible in the table currently Incries number of rows shown to select from and write all packages to file.
#'
#'
#' @usage lib_interactive(libs,textformat = TRUE)
#' @source relies on code in https://github.com/rstudio/DT/issues/93
#'
#' @export
#'
#' @examples \dontrun{
#'
#' lib_interactive(libs)
#' }
lib_interactive <- function(libs,textformat = TRUE){

    # this code is re-used from https://github.com/rstudio/DT/issues/93


    if (!requireNamespace("DT", quietly = TRUE)) {
        stop("Package \"DT\" needed for this function to work. Please install it.",
             call. = FALSE)
    }

    if (!requireNamespace("shiny", quietly = TRUE)) {
        stop("Package \"shiny\" needed for this function to work. Please install it.",
             call. = FALSE)
    }


    shiny::shinyApp(
        ui = shiny::fluidPage(
            shiny::h3("Package Bibliography"),
            shiny::h5("Select and save"),

            shiny::actionButton("done", "done"),
            shiny::downloadButton('writebib', 'Write Bibliography to File'),
            shiny::br(),
            shiny::br(),
            DT::dataTableOutput('x1'),
            # verbatimTextOutput('x2'),
            shiny::tags$head(
                shiny::tags$style(shiny::HTML('#done{background-color:darkgray;
                            color:white}')),
                shiny::tags$style(shiny::HTML('#writebib{background-color:darkblue;
                            color:white}'))
            )),


        server = function(input, output) {


            # create a character vector of shiny inputs
            shinyInput = function(FUN, len, id, ...) {
                inputs = character(len)
                for (i in seq_len(len)) {
                    inputs[i] = as.character(FUN(paste0(id, i), label = NULL, ...))
                }
                inputs
            }

            # obtain the values of inputs
            shinyValue = function(id, len) {
                unlist(lapply(seq_len(len), function(i) {
                    value = input[[paste0(id, i)]]
                    if (is.null(value)) NA else value
                }))
            }

            # a sample data frame
            # res = data.frame(
            #     v1 = shinyInput(numericInput, 100, 'v1_', value = 0),
            #     v2 = shinyInput(checkboxInput, 100, 'v2_', value = TRUE),
            #     v3 = rnorm(100),
            #     v4 = sample(LETTERS, 100, TRUE),
            #     stringsAsFactors = FALSE
            # )


            # if(textformat){
            #
            #     libs_short <- unlist(lib_print(libs, textformat = TRUE))
            #
            #     # grab single and repeated names
            #     names(libs_short) <- rep.int(names(sapply(lib_print(libs,
            #                                                         textformat = TRUE),
            #                                               length)),
            #                                  times = sapply(lib_print(libs,
            #                                                           textformat = TRUE),
            #                                                 length))
            #
            #
            # } else if(isFALSE(textformat)){
            #
            #     # makes a list with one entry for each citation
            #     # packages with multiple citations get on entry for each
            #     # provided citation
            #
            #
            #     libs_short <- lapply(
            #         make_bibtex_list(
            #             lib_print(libs,
            #                   textformat = FALSE)),
            #         paste,
            #         collapse = "\n"
            #     )
            #
            #     libs_short <- unlist(libs_short)
            #
            # }



            libs_short <- make_pckgs_vector(libs, textformat = textformat)

            for_print <- data.frame(Package = names(libs_short),
                                    # cite_key = shinyInput(textInput,
                                    #                       length(libs),
                                    #                       'cite_key_',
                                    #                       value = NA),
                                    Print = shinyInput(checkboxInput,
                                                       length(libs_short),
                                                       'Print_',
                                                       value = TRUE),
                                    Citation = libs_short,
                                    stringsAsFactors = FALSE,
                                    row.names = NULL)



            # libs <- data.frame(Package = lib_print(libs),
            #                    cite_key = shinyInput(textInput,
            #                                          length(libs),
            #                                          'cite_key_',
            #                                          value = NA),
            #                    Print = shinyInput(checkboxInput,
            #                                       length(libs),
            #                                       'Print_',
            #                                       value = TRUE),
            #                    Citation = as.character(libs),
            #                    stringsAsFactors = FALSE)

            # res = cbind(libs)
            #     v1 = shinyInput(numericInput, 100, 'v1_', value = 0),
            #     v2 = shinyInput(checkboxInput, 100, 'v2_', value = TRUE),
            #     v3 = rnorm(100),
            #     v4 = sample(LETTERS, 100, TRUE),
            #     stringsAsFactors = FALSE
            # )

            # render the table containing shiny inputs
            output$x1 = DT::renderDataTable(
                for_print,
                server = FALSE,
                escape = FALSE,
                selection = 'none',
                options = list(
                    iDisplayLength = nrow(for_print),
                    preDrawCallback = DT::JS('function() { Shiny.unbindAll(this.api().table().node()); }'),
                    drawCallback = DT::JS('function() { Shiny.bindAll(this.api().table().node()); } ')
                )
            )


            # print the values of inputs
            # output$x2 = shiny::renderPrint({
            #     data.frame(v1 = shinyValue('v1_', 100), v2 = shinyValue('v2_', 100))
            # })



            output$writebib <- shiny::downloadHandler(

                filename = function(){

                    ext <- ".bib"
                    if(textformat){
                        ext <- ".txt"
                    }

                    # ext <- ifelse(textformat, ".txt", ".bib")
                    paste0("pckg_bibliography", ext)},


                content = function(file){

                    packages_to_print <- for_print$Package[shinyValue('Print_',
                                                                      nrow(for_print))]

                    for_write <- libs[libs$Package %in% packages_to_print, ]

                    lib_write(for_write,
                              path_out = file,
                              append = FALSE,
                              textformat = textformat)


                }

                )


            shiny::observeEvent(input$done, {
                # timeText <- paste0("\"", as.character(Sys.time()), "\"")
                # rstudioapi::insertText(timeText)
                shiny::stopApp()
            })

        }
    )
}


