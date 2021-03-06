% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/salmonIndex.R
\name{salmonIndex}
\alias{salmonIndex}
\title{A function to create a Salmon pseudo reference}
\usage{
salmonIndex(group = c("sudo", "docker"), index.folder,
  ensembl.urltranscriptome, ensembl.urlgtf, k = 31)
}
\arguments{
\item{group, }{a character string. Two options: sudo or docker, depending to which group the user belongs}

\item{index.folder, }{a character string indicating the folder where transcriptime index will be created.}

\item{ensembl.urltranscriptome, }{a character string indicating the URL from ENSEMBL ftp for the transcripts fasta file of interest}

\item{ensembl.urlgtf, }{a character string indicating the URL from ENSEMBL ftp for the GTF for genome of interest}

\item{k, }{a number indicating the k-mers length, 31 eems to work well for reads of 75bp or longer, but you might consider a smaller k if dealing with shorter reads.}
}
\description{
This function executes the Salmon docker that produces as output a transcripts index file.
}
\examples{
\dontrun{
    #running salmonIndex mouse
    salmonIndex(group="docker", index.folder=getwd(), 
    ensembl.urltranscriptome="ftp://ftp.ensembl.org/pub/release-90/fasta/mus_musculus/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz",
    ensembl.urlgtf="ftp://ftp.ensembl.org/pub/release-90/gtf/mus_musculus/Mus_musculus.GRCm38.90.gtf.gz", 
    k=31)
    #running salmonIndex human
    library(docker4seq)
    salmonIndex(group="docker", index.folder=getwd(), 
           ensembl.urltranscriptome="ftp://ftp.ensembl.org/pub/release-90/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz",
           ensembl.urlgtf="ftp://ftp.ensembl.org/pub/release-90/gtf/homo_sapiens/Homo_sapiens.GRCh38.90.gtf.gz", 
           k=31)
    
}

}
\author{
Raffaele Calogero, raffaele.calogero [at] unito [dot] it, Bioinformatics and Genomics unit University of Torino Italy
}
