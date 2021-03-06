#' @title Function to merge different circRNA lists from CIRI 2
#' @description This function executes the docker container ciri2merge by running the merge of different lists of circRNAs predicted by CIRI2  following a sample data files provided by the user. The function executes also a filter based on the number of back-splicing reads computed in each experiment and across replicates of the same biological condition.
#'
#' @param group, a character string. Two options: \code{"sudo"} or \code{"docker"}, depending to which group the user belongs
#' @param scratch.folder, a character string indicating the scratch folder where docker container will be mounted
#' @param data.folder, a character string indicating the data folder where the CIRI 2 output files are located
#' @param samples.list, a character vector indicating the identifiers of the samples
#' @param covariates.list, a character vector indicating the classes of the samples
#' @param covariate.order, a character vector indicating ...
#' @param min_reads, the minimum number of back-splicing reads supporting a circRNA and detected in at least min_reps number of biological replicates of the same experimental condition (default = 2)
#' @param min_reps, the minimum number of replicates associated with at least min_reads supporting a circRNA (default = 0)
#' @param min_avg, the average number of back-splicing reads across biological replicates of the same experimental condition that shall support a circRNA (default = 10)
#' @author Nicola Licheri and Giulio Ferrero
#'
#' @return Two tab-delimited tables reporting the BS supporting reads and the coordinates of the filtered circRNAs are reported
#' @examples
#'\dontrun{
#'
#'     #retrieve the example data
#'     system("wget https://github.com/carlo-deintinis/circhunter/archive/master.zip") #retrieve the example data
#'     system("unzip master.zip")
#'     system("unzip ./circhunter-master/CircHunter/data/CIRI_predictions.zip")
#'
#'     #running the ciri2MergePredictions function
#'     ciri2MergePredictions(group="docker", scratch.folder="/data/scratch", data.folder="./circhunter-master/CircHunter/data/CIRI_predictions", groups.file="./circhunter-master/CircHunter/data/CIRI_predictions/SampleData.tsv", min_reads = 2, min_reps = 2, min_avg = 10)
#
#' }
#' @export

ciri2MergePredictions <- function(group = c("sudo", "docker"), scratch.folder, data.folder, samples.list, covariates.list, covariate.order, min_reads = 2, min_reps = 0, min_avg = 10) {


  # running time 1
  ptm <- proc.time()

  scratch.folder <- normalizePath(scratch.folder)
  data.folder <- normalizePath(data.folder)

  # setting the data.folder as working folder
  if (!file.exists(data.folder)) {
    cat(paste("\nIt seems that the ", data.folder, " folder does not exist\n"))
    return(2)
  }

  # storing the position of the home folder
  home <- getwd()
  setwd(data.folder)
  # initialize status
  system("echo 0 > ExitStatusFile 2>&1")

  # check  if scratch folder exist
  if (!file.exists(scratch.folder)) {
    cat(paste("\nIt seems that the ", scratch.folder, " folder does not exist\n"))
    system("echo 3 > ExitStatusFile 2>&1")
    setwd(home)
    return(3)
  }

  # check if each sample is associated to a covariate and viceversa
  if (length(samples.list) != length(covariates.list)) {
    cat("\nSamples and covariates lists must have the same length.\n")
    system("echo 2 > ExitStatusFile 2>&1")
    setwd(home)
    return(2)
  }

  # executing the docker job
  params <- paste(
      "--cidfile", paste0(data.folder, "/dockerID"),
      "-v", paste0(scratch.folder, ":/scratch"),
      "-v", paste0(data.folder, ":/data"),
      "-d docker.io/cursecatcher/docker4circ python3 /ciri2/docker4ciri.py merge",
      "--samples", paste(samples.list, collapse = " "),
      "--cov", paste(covariates.list, collapse = " "),
      "--order", paste(covariate.order, collapse = " "),
      "--mr", min_reads,
      "--mrep", min_reps,
      "--avg", min_avg
  )
  resultRun <- runDocker(group = group, params = params)

  # running time 2
  ptm <- proc.time() - ptm
  dir <- dir(data.folder)
  dir <- dir[grep("run.info", dir)]
  if (length(dir) > 0) {
    con <- file("run.info", "r")
    tmp.run <- readLines(con)
    close(con)
    tmp.run[length(tmp.run) + 1] <- paste("user run time mins ", ptm[1] / 60, sep = "")
    tmp.run[length(tmp.run) + 1] <- paste("system run time mins ", ptm[2] / 60, sep = "")
    tmp.run[length(tmp.run) + 1] <- paste("elapsed run time mins ", ptm[3] / 60, sep = "")
    writeLines(tmp.run, "run.info")
  } else {
    tmp.run <- NULL
    tmp.run[1] <- paste("run time mins ", ptm[1] / 60, sep = "")
    tmp.run[length(tmp.run) + 1] <- paste("system run time mins ", ptm[2] / 60, sep = "")
    tmp.run[length(tmp.run) + 1] <- paste("elapsed run time mins ", ptm[3] / 60, sep = "")

    writeLines(tmp.run, "run.info")
  }

  # saving log and removing docker container
  container.id <- readLines(paste(data.folder, "/dockerID", sep = ""), warn = FALSE)
  system(paste("docker logs ", substr(container.id, 1, 12), " &> ", data.folder, "/", substr(container.id, 1, 12), ".log", sep = ""))
  system(paste("docker rm ", container.id, sep = ""))
  # removing temporary files
  cat("\n\nRemoving the temporary file ....\n")
  system("rm -fR out.info")
  system("rm -fR dockerID")
  system(paste("cp ", paste(path.package(package = "docker4seq"), "containers/containers.txt", sep = "/"), " ", data.folder, sep = ""))
  setwd(home)
}
