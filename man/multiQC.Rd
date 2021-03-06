% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/multiQC.R
\name{multiQC}
\alias{multiQC}
\title{A function to handle a docker containier executing MultiQC}
\usage{
multiQC(group = c("sudo", "docker"), data.folder)
}
\arguments{
\item{group, }{a character string. Two options: sudo or docker, depending to which group the user belongs}

\item{data.folder, }{a character string indicating the folder where input data are located and where output will be written}
}
\description{
This function executes MultiQC docker (Ewels et al., 2016. Bioinformatics. 32(19):3047-8) returning the multiqc_report.html file and the content of multiqc_data/ folder
}
\examples{
\dontrun{
    #running skeleton
    multiQC(group="docker", data.folder=getwd())
}

}
\author{
Giulio Ferrero, giulio.ferrero [at] unito [dot] it, University of Torino
}
