setwd("~/Desktop/PhD Thesis/Projects/Leiothlypis/Leiothlypis analyses/Ch1_new/TWISST_and_shout")
source("plot_twisst.R")
library(dplyr)

# Looking at the data (this part can be skipped after the first time)
###############################

xx <- read.table("Leiothlypis_50kbp.trees.weights.tsv.gz", header = TRUE, stringsAsFactors=F)

# Looking at the data (this part can be skipped after the first time)
###############################
# Look at the weights file and make sure it's the right format
str(xx)

# See how many windows and topologies there are...
dim(xx)
# 20474 windows and 945 possible topologies. 

# Show the distribution of weights for topology #1 across all windows. 
hist(xx[,1])
summary(xx[,1])
# Looks like nearly all weights are 0 for this topology, but 45,000 for one window. 

# How many windows for this topology actually have weights above 0? 
xx[xx[,1] > 2,1]
# Only 6 out of 20474. This means topology #1 can probably be excluded from further analyses. 
# But we can't do this individually for 944 other topologies. That would drive us insane. 

# Total weight for topology #1
sum(xx[,1])
# Now for topology #2 (which seems to have no support ANYWHERE)
sum(xx[,2])
# Now for topology #3
sum(xx[,3])

# Sum up weights for EACH topology and see where they fall in a histogram. 
hist(apply(xx, 2, sum))
# The vast majority are at or close to 0. 

# Look at total support/weights for each topology across all windows and put that into a new object. 
summary(apply(xx, 2, sum))
sums <- apply(xx, 2, sum)

sum(sums)
# Total weight across ALL windows and topologies = 1,599,531,250
sum(sums)/2
# Half of that is 799,765,625

# These 6 topologies have more than that value (which is half of ALL topology support)
sums[sums >= 60000000] -> top6
top6[order(top6, decreasing = TRUE)] -> top6
343096600 + 151876175 + 117852950 + 98987325 + 77678125 + 63725100

########################################

# Subset the top 6 topologies: 526, 529, 538, 541, 528, and 601

subx <- subset(xx, select = c('topo526', 'topo529', 'topo538', 'topo541', 'topo528', 'topo601'))

# Now we must rearrange the order of the windows so that the plot.twisst function doesnt fuck things up. 
# Import the metadata file w/ chrom #s and start and end points for each window. 
# Make sure to have a tab-separated header for the data file with "chrom", "start", and "end"
xxdata <- read.table("Leiothlypis_50kbp_data", header = TRUE, stringsAsFactors=F)
# Combine the metadata file with the actual data. 
all_xx_info <- cbind(xxdata, subx)
# Rearrange by chromosome #, then start point (Note that the Z chromosome is #33)
all_xx_info_arranged <- all_xx_info %>% arrange(chrom, start)

#######################
### Barplot stuff
#######################
# For barplots, we want the AVERAGE weights of topologies across all chromosomes. And if 
# you notice in the previous files, whatever those support values are always add up to 78125 in each window. 
# Hence, I will add an "other" column to a copy of the all_xx_info_arranged file. 
arranged_everything_weights <- subset(all_xx_info_arranged, select = c(4:9))
arranged_everything_weights$other <- 78125 - rowSums(arranged_everything_weights)
write.table(arranged_everything_weights, file = "Leiothlypis_50kbp_weights_for_histograms", sep = "\t", quote = FALSE, row.names = FALSE)
# Add in the headers manually- You can do this by opening up command line in this folder, 
# and grepping the names of the six top topologies from "Leiothlypis_50kbp.trees.weights.tsv.gz" into a new file. 
# Then, of course, copypasting. 

arranged_data_for_histogram <- subset(all_xx_info_arranged, select = 1:3)
write.table(arranged_data_for_histogram, file = "Leiothlypis_50kbp_arranged_data_for_histograms", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

Everything_window_data_file <- 'Leiothlypis_50kbp_arranged_data_for_histograms'
Everything_weights_file <- 'Leiothlypis_50kbp_weights_for_histograms'
Everything_twisst_data <- import.twisst(Everything_weights_file, Everything_window_data_file)

Histogram_data <- as.data.frame(Everything_twisst_data$weights_mean)
Histogram_data$row_names <- row.names(Histogram_data) 
library(tidyr)
Better_histogram_data <- gather(Histogram_data, key = "Chrom_number", value = "Topology_weight", 1:31)
colnames(Better_histogram_data)[1] ="Topology"
library(ggplot2)
library(ggpubr)

poop <- ggplot(data = Better_histogram_data, aes(x=Topology, y=Topology_weight)) +
  geom_bar(stat="identity") +   facet_wrap(~Chrom_number, ncol = 4, nrow = 8)
poop

# Figure out how to do this for JUST A FEW CHROMOSOMES (1, 2, Z, and maybe some tiny ones). 
# Then make it look pretty. 

###############
# Support of topologies vs. chromosome size (scatterplots)
###############

### This is just how big the chromosomes of the yellowthroat reference genome are. 
### It's hard to say how big the chromosomes of these birds are because we do not have reference-quality genomes for them. 
### But we'll assume here that they're similar.
#Chrom 1 = 153087655
#Chrom 2 = 116842828
#Chrom 3 = 114135043
#Chrom 4 = 74170629
#Chrom 5 = 72541719
#Chrom 6 = 63300891
#Chrom 7 = 39405193
#Chrom 8 = 36946645
#Chrom 9 = 31781422
#Chrom 10 = 26275112
#Chrom 11 = 21821579
#Chrom 12 = 21669806
#Chrom 13 = 20828009
#Chrom 14 = 20290551
#Chrom 15 = 18953334
#Chrom 16 = 17127930
#Chrom 17 = 16139120
#Chrom 18 = 14378491
#Chrom 19 = 12652716
#Chrom 20 = 12095713
#Chrom 21 = 11563386
#Chrom 22 = 8616481
#Chrom 23 = 8133595
#Chrom 24 = 7442647
#Chrom 25 = 7018295
#Chrom 26 = 5633410
#Chrom 27 = 5107092
#Chrom 28 = 4949373
#Chrom 29 = 2253211
#Chrom 30 = 1308927
#Chrom Z = 77059592


Actual_Chrom_sizes <- c(153087655, 153087655, 153087655, 153087655, 153087655, 153087655, 153087655,
                        116842828, 116842828, 116842828, 116842828, 116842828, 116842828, 116842828, 
                        114135043, 114135043, 114135043, 114135043, 114135043, 114135043, 114135043, 
                        74170629, 74170629, 74170629, 74170629, 74170629, 74170629, 74170629, 
                        72541719, 72541719, 72541719, 72541719, 72541719, 72541719, 72541719,
                        63300891, 63300891, 63300891, 63300891, 63300891, 63300891, 63300891, 
                        39405193, 39405193, 39405193, 39405193, 39405193, 39405193, 39405193, 
                        36946645, 36946645, 36946645, 36946645, 36946645, 36946645, 36946645, 
                        31781422, 31781422, 31781422, 31781422, 31781422, 31781422, 31781422, 
                        26275112, 26275112, 26275112, 26275112, 26275112, 26275112, 26275112, 
                        21821579, 21821579, 21821579, 21821579, 21821579, 21821579, 21821579, 
                        21669806, 21669806, 21669806, 21669806, 21669806, 21669806, 21669806, 
                        20828009, 20828009, 20828009, 20828009, 20828009, 20828009, 20828009, 
                        20290551, 20290551, 20290551, 20290551, 20290551, 20290551, 20290551, 
                        18953334, 18953334, 18953334, 18953334, 18953334, 18953334, 18953334, 
                        17127930, 17127930, 17127930, 17127930, 17127930, 17127930, 17127930, 
                        16139120, 16139120, 16139120, 16139120, 16139120, 16139120, 16139120, 
                        14378491, 14378491, 14378491, 14378491, 14378491, 14378491, 14378491, 
                        12652716, 12652716, 12652716, 12652716, 12652716, 12652716, 12652716, 
                        12095713, 12095713, 12095713, 12095713, 12095713, 12095713, 12095713, 
                        11563386, 11563386, 11563386, 11563386, 11563386, 11563386, 11563386, 
                        8616481, 8616481, 8616481, 8616481, 8616481, 8616481, 8616481, 
                        8133595, 8133595, 8133595, 8133595, 8133595, 8133595, 8133595, 
                        7442647, 7442647, 7442647, 7442647, 7442647, 7442647, 7442647, 
                        7018295, 7018295, 7018295, 7018295, 7018295, 7018295, 7018295, 
                        5633410, 5633410, 5633410, 5633410, 5633410, 5633410, 5633410, 
                        5107092, 5107092, 5107092, 5107092, 5107092, 5107092, 5107092, 
                        4949373, 4949373, 4949373, 4949373, 4949373, 4949373, 4949373, 
                        2253211, 2253211, 2253211, 2253211, 2253211, 2253211, 2253211, 
                        1308927, 1308927, 1308927, 1308927, 1308927, 1308927, 1308927, 
                        77059592, 77059592, 77059592, 77059592, 77059592, 77059592, 77059592)

Chrom_window_numbers <- c(3042, 3042, 3042, 3042, 3042, 3042, 3042, 
                          2320, 2320, 2320, 2320, 2320, 2320, 2320, 
                          2258, 2258, 2258, 2258, 2258, 2258, 2258, 
                          1450, 1450, 1450, 1450, 1450, 1450, 1450, 
                          1432, 1432, 1432, 1432, 1432, 1432, 1432, 
                          1252, 1252, 1252, 1252, 1252, 1252, 1252, 
                          768, 768, 768, 768, 768, 768, 768, 
                          721, 721, 721, 721, 721, 721, 721, 
                          630, 630, 630, 630, 630, 630, 630, 
                          516, 516, 516, 516, 516, 516, 516, 
                          414, 414, 414, 414, 414, 414, 414, 
                          428, 428, 428, 428, 428, 428, 428, 
                          405, 405, 405, 405, 405, 405, 405,
                          397, 397, 397, 397, 397, 397, 397, 
                          367, 367, 367, 367, 367, 367, 367, 
                          334, 334, 334, 334, 334, 334, 334, 
                          301, 301, 301, 301, 301, 301, 301, 
                          278, 278, 278, 278, 278, 278, 278, 
                          234, 234, 234, 234, 234, 234, 234, 
                          234, 234, 234, 234, 234, 234, 234, 
                          229, 229, 229, 229, 229, 229, 229, 
                          161, 161, 161, 161, 161, 161, 161, 
                          155, 155, 155, 155, 155, 155, 155, 
                          144, 144, 144, 144, 144, 144, 144, 
                          137, 137, 137, 137, 137, 137, 137, 
                          109, 109, 109, 109, 109, 109, 109, 
                          95, 95, 95, 95, 95, 95, 95, 
                          92, 92, 92, 92, 92, 92, 92,
                          41, 41, 41, 41, 41, 41, 41, 
                          22, 22, 22, 22, 22, 22, 22, 
                          1508, 1508, 1508, 1508, 1508, 1508, 1508)

Better_histogram_data$Number_of_windows <- Chrom_window_numbers
Better_histogram_data$Actual_chrom_size <- Actual_Chrom_sizes
Better_histogram_data$log_chrom_size <- log(Actual_Chrom_sizes)

Top_3_support <- subset(Better_histogram_data, Topology == "topo526" | Topology == "topo529" | Topology == "topo538")
other_support <- subset(Better_histogram_data, Topology == "other")


Overlaid_poop <- ggplot(data = Top_3_support, aes(x=log_chrom_size, y=Topology_weight, color=Topology)) + 
  geom_point() + scale_x_continuous(expand = c(0, 0), limits = c(14.08,19)) + 
   theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth(method = "lm") + 
  stat_cor(aes(label = after_stat(rr.label)), geom = "label")
Overlaid_poop + labs(x = "log(Chromosome size)", y = "Average weight", title = "Top 3 Topologies") + 
  theme(legend.position = "none") + scale_colour_manual(values = c("#0075DC", "#2BCE48", "#FFA405"))

Shit <- ggplot(data = other_support, aes(x=log_chrom_size, y=Topology_weight, color=Topology)) + 
  geom_point() + scale_x_continuous(expand = c(0, 0), limits = c(14.08,19)) + 
  theme(plot.background = element_blank(),
        panel.background = element_blank(),
        panel.grid = element_blank(), 
        axis.line.x = element_line(colour = 'black'),
        axis.line.y = element_line(colour = 'black')) + geom_smooth(method = "lm") + 
  stat_cor(aes(label = after_stat(rr.label)), label.y.npc="bottom", label.x.npc = "left", geom = "label")
Shit + labs(x = "log(Chromosome size)", y = "Average weight", title = "All other topologies combined") + 
  theme(legend.position = "none")

#######
#Old scatterplot stuff
#######
Topo573_support <- subset(Better_histogram_data, Topology == "topo573")
Topo573_poop <- ggplot(data = Topo573_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo573_poop + labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 573")

other_support <- subset(Better_histogram_data, Topology == "other")
other_poop <- ggplot(data = other_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
other_poop + labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Other topologies")

Topo572_support <- subset(Better_histogram_data, Topology == "topo572")
Topo572_poop <- ggplot(data = Topo572_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo572_poop+ labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 572")

Topo571_support <- subset(Better_histogram_data, Topology == "topo571")
Topo571_poop <- ggplot(data = Topo571_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo571_poop+ labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 571")

Topo534_support <- subset(Better_histogram_data, Topology == "topo534")
Topo534_poop <- ggplot(data = Topo534_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo534_poop+ labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 534")

Topo580_support <- subset(Better_histogram_data, Topology == "topo580")
Topo580_poop <- ggplot(data = Topo580_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo580_poop+ labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 580")

Topo585_support <- subset(Better_histogram_data, Topology == "topo585")
Topo585_poop <- ggplot(data = Topo585_support, aes(x=Number_of_windows, y=Topology_weight)) + 
  geom_point() + theme(plot.background = element_blank(),
                       panel.background = element_blank(),
                       panel.grid = element_blank(), 
                       axis.line.x = element_line(colour = 'black'),
                       axis.line.y = element_line(colour = 'black')) + geom_smooth()
Topo585_poop+ labs(x = "Chromosome size (# of windows)", y = "Average weights", title = "Topology 585")

##########
# Now let's split this up by chromosome window sizes. 

# Big chromosomes (1-6) have over 1,000 windows.
Big_chrom_data <- subset(all_xx_info_arranged, chrom <= 6 | chrom == 33)
arranged_bigchrom_weights <- subset(Big_chrom_data, select = c(4:9))
write.table(arranged_bigchrom_weights, file = "Leiothlypis_50kbp_arranged_bigchrom_weights_top6", sep = "\t", quote = FALSE, row.names = FALSE)
# IDK how to add the headers in, so I'll just do that part manually
arranged_bigchrom_data <- subset(Big_chrom_data, select = 1:3)
write.table(arranged_bigchrom_data, file = "Leothlypis_50kbp_arranged_bigchrom_data", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Medium chromosomes (7-10) have over 500.
Med_chrom_data <- subset(all_xx_info_arranged, chrom >= 7 & chrom <= 10)
arranged_medchrom_weights <- subset(Med_chrom_data, select = c(4:9))
write.table(arranged_medchrom_weights, file = "Leiothlypis_50kbp_arranged_medchrom_weights_top6", sep = "\t", quote = FALSE, row.names = FALSE)
# IDK how to add the headers in, so I'll just do that part manually
arranged_medchrom_data <- subset(Med_chrom_data, select = 1:3)
write.table(arranged_medchrom_data, file = "Leothlypis_50kbp_arranged_medchrom_data", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Small chromosomes (11-18) have over 250.
Sm_chrom_data <- subset(all_xx_info_arranged, chrom >= 11 & chrom <= 18)
arranged_smchrom_weights <- subset(Sm_chrom_data, select = c(4:9))
write.table(arranged_smchrom_weights, file = "Leiothlypis_50kbp_arranged_smchrom_weights_top6", sep = "\t", quote = FALSE, row.names = FALSE)
# IDK how to add the headers in, so I'll just do that part manually
arranged_smchrom_data <- subset(Sm_chrom_data, select = 1:3)
write.table(arranged_smchrom_data, file = "Leothlypis_50kbp_arranged_smchrom_data", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

# Tiny chromosomes (19-29) have less than 250. Chromosome 30 and W are too tiny to even be considered. 
Tiny_chrom_data <- subset(all_xx_info_arranged, chrom >= 19 & chrom <=29)
arranged_tinychrom_weights <- subset(Tiny_chrom_data, select = c(4:9))
write.table(arranged_tinychrom_weights, file = "Leiothlypis_50kbp_arranged_tinychrom_weights_top6", sep = "\t", quote = FALSE, row.names = FALSE)
# IDK how to add the headers in, so I'll just do that part manually
arranged_tinychrom_data <- subset(Tiny_chrom_data, select = 1:3)
write.table(arranged_tinychrom_data, file = "Leothlypis_50kbp_arranged_tinychrom_data", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

############################################
#Plotting the big chromosomes plus Z
############################################
Bigchrom_window_data_file <- 'Leothlypis_50kbp_arranged_bigchrom_data'
Bigchrom_weights_file <- 'Leiothlypis_50kbp_arranged_bigchrom_weights_top6'
Bigchrom_twisst_data <- import.twisst(Bigchrom_weights_file, Bigchrom_window_data_file)
pdf("Leio_Bigchrom_weights.pdf", width=20, height=50)
plot.twisst(Bigchrom_twisst_data, mode=3)
dev.off()

Bigchrom_twisst_data_smooth <- smooth.twisst(Bigchrom_twisst_data, span_bp=5000000, spacing=100000)

pdf("Leio_Bigchrom_weights_smoothed.pdf", width=20, height=50)
plot.twisst(Bigchrom_twisst_data_smooth, mode=3)
dev.off()

############################################
#Plotting the medium chromosomes
############################################
Medchrom_window_data_file <- 'Leothlypis_50kbp_arranged_medchrom_data'
Medchrom_weights_file <- 'Leiothlypis_50kbp_arranged_medchrom_weights_top6'
Medchrom_twisst_data <- import.twisst(Medchrom_weights_file, Medchrom_window_data_file)

pdf("Leio_Medchrom_weights.pdf", width=20, height=30)
plot.twisst(Medchrom_twisst_data, mode=3)
dev.off()

Medchrom_twisst_data_smooth <- smooth.twisst(Medchrom_twisst_data, span_bp=2000000)

pdf("Leio_Medchrom_weights_smoothed.pdf", width=20, height=30)
plot.twisst(Medchrom_twisst_data_smooth, mode=3)
dev.off()

############################################
#Plotting the small chromosomes
############################################
Smchrom_window_data_file <- 'Leothlypis_50kbp_arranged_smchrom_data'
Smchrom_weights_file <- 'Leiothlypis_50kbp_arranged_smchrom_weights_top6'
Smchrom_twisst_data <- import.twisst(Smchrom_weights_file, Smchrom_window_data_file)

pdf("Leio_Smchrom_weights.pdf", width=20, height=50)
plot.twisst(Smchrom_twisst_data, mode=3)
dev.off()

Smchrom_twisst_data_smooth <- smooth.twisst(Smchrom_twisst_data, span_bp=1500000)

pdf("Leio_Smchrom_weights_smoothed.pdf", width=20, height=50)
plot.twisst(Smchrom_twisst_data_smooth, mode=3)
dev.off()

############################################
#Plotting the tiny chromosomes
############################################
tinychrom_window_data_file <- 'Leothlypis_50kbp_arranged_tinychrom_data'
tinychrom_weights_file <- 'Leiothlypis_50kbp_arranged_tinychrom_weights_top6'
tinychrom_twisst_data <- import.twisst(tinychrom_weights_file, tinychrom_window_data_file)

pdf("Leio_tinychrom_weights.pdf", width=20, height=60)
plot.twisst(tinychrom_twisst_data, mode=3)
dev.off()

tinychrom_twisst_data_smooth <- smooth.twisst(tinychrom_twisst_data, span_bp=1250000)

pdf("Leio_tinychrom_weights_smoothed.pdf", width=20, height=60)
plot.twisst(tinychrom_twisst_data_smooth, mode=3)
dev.off()

