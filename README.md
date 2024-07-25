Contains everything from the previous 3 Leiothlypis repositories... but better. 

Note: If you're running submission scripts that go back to BEFORE Step_11, you'll need to to change the partition from quanah to nocona and call upon the required software in a different manner (either using what's installed on nocona or using a conda environment). 

# Aligning, filtering, and genotyping
1. Run Step 1 interactively. Follow ALL the directions. 

2. Run the alignment script (step 2) from the 08_align_script folder.

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

4. 
