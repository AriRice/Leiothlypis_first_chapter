Contains everything from the previous 3 Leiothlypis repositories... but better. 

Requires conda environments to be set up appropriately for each job/ submission script (for instance, if the script for an array job requires bcftools, vcftools, and some other thing, create an environment with all three of those programs and activate it at the beginning of said script). 

Note: Step_02_align.sh needs to be updated to run on a different computing cluster where some of those software packages aren't already installed (preferably in a conda environment). 

# Aligning, filtering, and genotyping
1. Run Step 1 interactively. Follow ALL the directions. 

2. Run the alignment script (step 2) from the 08_align_script folder. Step_02b_mitogenome.sh can be combined into this. 

    2.1. Go to the mitogenome folder and run extract_this.sh to extract a subset of mtDNA for each sample.

    2.2. Import the mtDNA subsets into Geneious and blast em to make sure they're actually Leiothlypis. 

3. Run step 3 interactively from the 08_align_script folder. 

4. Run the Step_04 script from the main working directory. Requires a popmap.txt file in the 01_bam_files folder. Make that first. 

5. Move the *depth.txt files and the leiothlypis_coverage.txt file into the 01_coverage folder, copy this folder to an external HD, and run Step_05_plot_coverage.r in R on the big desktop computer. Consider tossing peregrina/ruficapilla redos if they have poor coverage. Hopefully that's not the case.

6. Run step 06 interactively if you don't already have a .dict file available for your reference genome. (Note that this step can be done any point before you do the genotyping).

7. Make the genotyping script in 09_genotyping_scripts. Run it from that folder.

    7.1. Transfer the histogram PDFs to a local computer and make sure there's nothing weird going on with them (First contamination check)

8. Create the scaffolds.txt file in the main directory (All ref. chromosomes >1 mbp, as seen in the .dict file from step 6). Then run Step_08_merge_vcfs.sh from the genotyping scripts folder. 

9. Make/run "Step_09_admixpca_filter.sh" in the 10_filter folder. Requires an "outgroup.txt" file in the same folder.
    
10. Run "Step_10_whole_genome_admixture" interactively within the "05_admixture_and_pca" directory. This will generate two files ("50kbpthin_plink_pca.eigenvec" and "50kbpthin_plink_pca.eigenval") that can be transferred to a local computer and inputted into RStudio (Plot_PCA_Leiothlypis.R) to generate PCA plots. For the admixture data, the last two lines can be run with different values of K to generate different "Q" files. Those can then be transferred to a local computer and inputted into RStudio (01_AAR_admixture.R) to generate admixture plots. This is the second check for contamination/ funny business. 

    10.1. Go back to the filter folder, run "Contam_check_filter.sh", and enter the 05b folder in case your admixture/pca results were weird and you suspect contamination.

    10.2. Merge the VCFs, put 4 scripts into this folder ("01a_leiothlypis_contamination_test.sh", "01_leiothlypis_contamination_test.sh", "checkHetsIndvVCF.sh", and "contamination_check.R"), and execute 01_leiothlypis_contamination_test.sh. 

    10.3. Execute 01a_leiothlypis_contamination_test.sh.

    10.4. Export and view the resulting PDF. 

11. Choose 1 peregrina and 2 ruficapilla to remove from the next few datasets. List them in a file called "excluded_samples.txt"

    11.1. Run the "Step_11_filter_everything_else.sh" script.

# Phylogenies and whole-genome stats
1. Excecute Step_01_phylostats_50kbp.r in R. This will write an array job submission script (phylo50kbp_array.sh) and 3 helper files in /06_phylogenies_and_summstats/.

2. Go to this folder and add 4 more R scripts (calculate_windows, create_fasta, create_fasta_from_vcf, and window_stat_calculations). No need to modify them.

   2.1. Add popmap_phylo.txt to this folder.

   2.2. Add a subfolder called "windows".

3. Execute phylo50kbp_array.sh. This'll take awhile (at least 1 day).

4. Run both parts of Step 04 in interactive sessions, then transfer tree and stats files to local computer for plotting.

5. Plot trees in Figtree (instructions not included here)

6. Plot windowed stats in R (script will eventually be included here)

# TWISST (For weighting topologies and plotting tree discordance across windows)
1. Download the python script for TWISST and put it somewhere (I put it in my home directory).

2. Get an interactive session and follow all the steps listed in "TWISST command" to run TWISST on the cluster. 

3. Export the weights output and the metadata ("Leiothlypis_50kbp_data") to a local computer.

4. Plot in R (Script included here, requires another plot.twisst.R script from the developers). 

# Treemix
I didn't put any methods on Github because it was very straightforward and ultimately didn't tell me anything. 

# D and fd statistics (ABBA-BABA tests)
There are two ways in which we did this. 
# With D-suite
1. Go to the 11_ABBA_BABA folder and create the following files, scripts, and directories: (a) species_tree.nwk, (b) test_trios.txt, (c) the three helper files (same ones from the 06_phylogenies_and_summstats directory), (d) Leio_Sets.txt, (e) Dsuite_by_chromosome.sh, (f) Dsuite_by_windows.sh, (g) Dstats_by_chromosome (directory), (h) Dstats_by_windows (directory).

2. Edit the helper files to get rid of reference chromosomes/ windows that were never sequenced ("Helper editing").

3. Run the Dsuite submission scripts.

4. Enter the Dstats_by_chromosome directory and get whole-genome information by combining everything (See "Other misc commands").

5. Import the fbranch figure and list of all windows to your local computer. You can also combine the window-based stats into one text file and plot those, but I didn't use these for the paper.

# With custom R scripts
Note that with these scripts, D is pretty much the same as in Dsuite, but missing data is handled a little differently, so values may not be exact. Dsuite also had trouble calculating fd per window, which is why I'm using these scripts here. 

1. Make a new folder in 11_ABBA_BABA called "fd_vs_D"
   
2. Run both "simplify" submission scripts to simplify vcfs (at window and chromosome levels).

3. Make a new folder in here called "windows" and another one called "chrom_level"

4. Make the "D and fD stats" R scripts, along with the submission scripts (run_introgression) that go along with them. Make sure the chromosome-level ones are placed inside the chrom_level folder and run from there. NOTE: You need a LOT of CPU for the chromosome-level one to run on the larger chromosomes (Namely 1, 2, 3, and Z). You may need to break it up into several submission scripts.

5. Use "Even MORE misc commands (int)" to extract f-branch metrics and combine things into singular files.
   
6. Export these to desktop R for plotting.

# Gene and site concordance factors
I did this part at the very end and will simply list the instructions here. 

1. Make a new directory

2. Assuming you have already gotten your trees/phylogenies, move "leiothlypis_50kbp.tre" and "Leiothlypis_50kbp.trees" into this directory

3. Move the .tre file to your local computer, open it up in figtree, save it in newick format, and move the .nwk file back into that directory (I'm sure there's a much easier way to do this, but this is because IQtree is picky about tree file formats). 

4. Go back and re-run the phylostats_50kbp array job, but make sure the fastas generated for each window are NOT deleted. These will be essential for getting site concordance factors.

5. Concatenate ALL of these fastas into a single one using seqkit and move the massive fasta file into your new IQtree directory.

6. Run Get_scf_gcf.sh. It's pretty self-explanatory from there.

# G-PhoCs
https://github.com/AriRice/Leiothlypis-GPHOCS/blob/main/README.md 
