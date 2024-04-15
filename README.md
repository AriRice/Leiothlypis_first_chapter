# Leiothlypis_first_chapter
Contains everything from the previous 3 Leiothlypis repositories... but better. 

How to do everything:
1. Run Step 1 interactively. Follow ALL the directions. 

2. Run the alignment script (step 2) from the 08_align_script folder.

3. Run step 3 interactively from the 08_align_script folder. 

4. Run the Step_04 script from the main working directory. Requires a popmap.txt file in the 01_bam_files folder. Make that first. 

5. Move the *depth.txt files and the leiothlypis_coverage.txt file into the 01_coverage folder, copy this folder to an external HD, and run Step_05_plot_coverage.r in R on the big desktop computer. Consider tossing peregrina/ruficapilla redos if they have poor coverage. Hopefully that's not the case.

6. Run step 06 interactively if you don't already have a .dict file available for your reference genome. (Note that this step can be done any point before you do the genotyping).

7. Make the genotyping script in 09_genotyping_scripts. Run it from that folder. 
