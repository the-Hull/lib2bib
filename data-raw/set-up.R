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
my_desc$set("Authors@R", "person('Alexander', 'Hurley', email = 'agl.hurley@gmail.com', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Get your packages into your bibliography")
# The description of your package
my_desc$set(Description = "Create LaTeX-conform .bib files from packages used in your analyses")
# The urls
my_desc$set("URL", "http://this")
my_desc$set("BugReports", "http://that")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "Alexander Hurley")
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
# use_package("purrr")

# Clean your description
use_tidy_description()


AOI::getAOI("Yosemite")
