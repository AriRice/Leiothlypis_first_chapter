# input args <- input file, popmap
args <- commandArgs(trailingOnly = TRUE)

# Only use these if testing a single window in Rstudio on your computer
#args[1] <- "CM019928.1__ABBA_BABA.simple.vcf"
#args[2] <- "leio_introgression_popmap.txt"
#args[3] <- "leio_introgression_comparisons.txt"

# no scientific notation
options(scipen=999)

# read in input file. This part was modified by me to work with ONE vcf. 
input_file <- read.table(args[1], sep="\t", stringsAsFactors=F)

# subset input file 
input_file_genotypes <- input_file[,4:ncol(input_file)]

# read in populations
populations <- read.table(args[2], sep="\t", stringsAsFactors=F, header=T)

# read in introgression comparisons
intro_comps <- read.table(args[3], sep="\t", stringsAsFactors=F, header=T)
output_name <- paste(strsplit(args[1], ".simple")[[1]][1], "__stats.txt", sep="")
write(c("chr", "p1", "p2", "p3", "o", "n_snps", "D", "fd"), ncolumns=8, file=output_name, sep="\t")

# remove phasing information from genotypes file
for(a in 1:ncol(input_file_genotypes)) {
  input_file_genotypes[,a] <- gsub("\\|", "/", input_file_genotypes[,a])
}

# loop for each of the comparisons in the intro_comps object
for(a in 1:nrow(intro_comps)) {
  p1 <- intro_comps[a,1]
  p2 <- intro_comps[a,2]
  p3 <- intro_comps[a,3]
  outgroup <- intro_comps[a,4]
  total <- c(p1, p2, p3, outgroup)
  
  # keep only genotypes that are homozygous in outgroup. Modified to work with 5 outgroup individuals instead of 1
  outgroup_genotypes <- input_file_genotypes[,populations$PopName == outgroup]
  # If ANY of the outgroup genotypes are not homozygous, I need to eliminate that entire line. 
  keep <- outgroup_genotypes$V4 == "0/0" | outgroup_genotypes$V4 == "1/1"
  a_genotypes <- input_file_genotypes[keep,]
  keep <- a_genotypes$V5 == "0/0" | a_genotypes$V5 == "1/1"
  a_genotypes <- a_genotypes[keep,]
  keep <- a_genotypes$V6 == "0/0" | a_genotypes$V6 == "1/1"
  a_genotypes <- a_genotypes[keep,]
  keep <- a_genotypes$V7 == "0/0" | a_genotypes$V7 == "1/1"
  a_genotypes <- a_genotypes[keep,]
  keep <- a_genotypes$V8 == "0/0" | a_genotypes$V8 == "1/1"
  a_genotypes <- a_genotypes[keep,]
 
  # extract genotypes
p1_genotypes <- a_genotypes[,populations$PopName == p1]
  p2_genotypes <- a_genotypes[,populations$PopName == p2]
  p3_genotypes <- a_genotypes[,populations$PopName == p3]
  outgroup_genotypes <- a_genotypes[,populations$PopName == outgroup]
  
  # identify any sites where a population only has missing data
  keep <- rep(TRUE, nrow(p1_genotypes))
  for(b in 1:nrow(p1_genotypes)) {
    if(length(unique(as.character(p1_genotypes[b,]))) == 1) {
      if(unique(as.character(p1_genotypes[b,])) == "./.") {
        keep[b] <- FALSE
      }
    }
    if(length(unique(as.character(p2_genotypes[b,]))) == 1) {
      if(unique(as.character(p2_genotypes[b,])) == "./.") {
        keep[b] <- FALSE
      }
    }
    if(length(unique(as.character(p3_genotypes[b,]))) == 1) {
      if(unique(as.character(p3_genotypes[b,])) == "./.") {
        keep[b] <- FALSE
      }
    }
  }
  
  # remove missing sites from genotype dataframes
  p1_genotypes <- p1_genotypes[keep, ]
  p2_genotypes <- p2_genotypes[keep, ]
  p3_genotypes <- p3_genotypes[keep, ]
  outgroup_genotypes <- outgroup_genotypes[keep, ]
  
  # identify any sites that are not biallelic in the designated populations (excluding outgroup)
  total_test <- cbind(p1_genotypes, p2_genotypes, p3_genotypes)
  keep <- rep(TRUE, nrow(total_test))
  for(b in 1:nrow(total_test)) {
    b_rep <- as.character(total_test[b,])
    if(length(unique(unlist(strsplit(b_rep[b_rep != "./."], "/")))) == 1) {
      keep[b] <- FALSE
    }
  }
  
  # remove non-polymorphic sites from genotype dataframes
  p1_genotypes <- p1_genotypes[keep, ]
  p2_genotypes <- p2_genotypes[keep, ]
  p3_genotypes <- p3_genotypes[keep, ]
  outgroup_genotypes <- outgroup_genotypes[keep, ]
  all_genotypes <- cbind(p1_genotypes, p2_genotypes, p3_genotypes, outgroup_genotypes)
  outgroup_gen <- as.vector(outgroup_genotypes$V4)

# do the calculations if we have the minimum number of sites needed
  # find derived allele frequency for each snp
  derived <- c()
  d1 <- c()
  d2 <- c()
  d3 <- c()
  donor <- c() # donor population of gene flow from fd statistic denominator. 
  for(b in 1:nrow(p1_genotypes)) {
      if(substr(outgroup_gen[b], 1, 1) == 0) {
        derived[b] <- 1
      } else {
        derived[b] <- 0
      }
      # extract alleles for each group
      b_p1 <- unlist(strsplit(as.character(p1_genotypes[b,]), "/"))
      b_p1 <- b_p1[b_p1 != "."]
      
      b_p2 <- unlist(strsplit(as.character(p2_genotypes[b,]), "/"))
      b_p2 <- b_p2[b_p2 != "."]
      
      b_p3 <- unlist(strsplit(as.character(p3_genotypes[b,]), "/"))
      b_p3 <- b_p3[b_p3 != "."]
      
      # calculate d for each group
      d1[b] <- length(b_p1[b_p1 == derived[b]]) / length(b_p1)
      d2[b] <- length(b_p2[b_p2 == derived[b]]) / length(b_p2)
      d3[b] <- length(b_p3[b_p3 == derived[b]]) / length(b_p3)
      
      # donor pop (either d2 or d3, whichever is larger)
      if(d2[b] >= d3[b]) {
        donor[b] <- d2[b]
      } else {
        donor[b] <- d3[b]
      }
    }
    
    # calculate ABBA
    abba <- (1 - d1) * d2 * d3 * (1 - 0)
    # calculate BABA
    baba <- d1 * (1 - d2) * d3 * (1 - 0)
    # calculate ABBA with donor pop
    abba_donor <- (1 - d1) * donor * donor * (1 - 0)
    # calculate BABA with donor pop
    baba_donor <- d1 * (1 - donor) * donor * (1 - 0)
    
    # calculate D and fd statistics. Added the D bit in to make negative D stats disappear. 
    D <- sum(abba - baba) / sum(abba + baba)
    fd <- sum(abba - baba) / sum(abba_donor - baba_donor)
   # if(fd < 0) { fd <- 0 }
   # if(D < 0) { D <- 0 }

  output <- c(strsplit(output_name, "__")[[1]][1],
                p1, p2, p3, outgroup, nrow(p2_genotypes), D, fd)
    write(output, ncolumns=8, file=output_name, sep="\t", append=T)
  }

