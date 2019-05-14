# set-up


# use_this ----------------------------------------------------------------

usethis::use_data_raw()


library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "lib2bib")

#Set your name
my_desc$set("Authors@R",
            "person('Alexander', 'Hurley', email = 'agl.hurley@gmail.com', role = c('cre', 'aut'), comment = c(ORCID = 0000-0002-9641-2805))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Get your packages into your bibliography")
# The description of your package
my_desc$set(Description = "Identify all packages used in a (project) folder or file, and generate plain-text or bibtex bibliographies. An interactive app allows selecting a subset of packages to save.")
# The urls
my_desc$set("URL", "https://github.com/the-Hull/lib2bib/")
my_desc$set("BugReports", "https://github.com/the-Hull/lib2bib/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
# use_mit_license(name = "Alexander Hurley")
usethis::use_gpl3_license("Alexander Hurley")

use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()
use_readme_md()


# Get the dependencies
# use_package("httr")
# use_package("jsonlite")
# use_package("curl")
# use_package("attempt")
#

# Clean your description
use_package("attempt")
use_package("stringi")
use_package("knitr")
use_package("purrr")
use_package("DT", type = "suggests")
use_package("shiny", type = "suggests")




use_tidy_description()
use_travis()
pkgdown::build_site()

