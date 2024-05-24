# Description

This repository contains source data and scripts (preprocessing, modelling and analyses) used in the Colwell et al. paper concerning the influence of SSRAs on human behaviour.

This datapack has been updated following publication revision on 24/05/2024.

You will need access to R, RStudio, MATLAB, Docker, and Python to run all the scripts contained within this datapack. 

For any questions or to report any issues, please contact Michael Colwell (michaelcolwell92@gmail.com / michael.colwell@psych.ox.ac.uk).

If you wish to use our data in your research study, please first contact catherine.harmer@psych.ox.ac.uk.

All code within this datapack was validated on 64-bit Windows 10 (10.0, build 19045). No non-standard hardware is required to run this code.

## Citation and DOI

Citation for the study paper TBC.

Data pack DOI: https://doi.org/10.5281/zenodo.8395069

## Instructions for non-model preprocessing and statistical analysis scripts (R Software)

The datapack branches into folders which pertain (mostly) to tasks analysed throughout the paper (e.g. PILT). Each task folder will contain an associated RMarkdown file. You will need to manually set the directory within each markdown file to run the scripts.

The scripts have been tested on Windows with R language version 4.3.1. Each R script is an R Markdown file, where sections of preprocessing and analyses of divided into chunks for ease of use (we recommend using [R Studio](https://posit.co/download/rstudio-desktop/) for ease of use). Downloads and instructions for R 
are available [here](https://www.r-project.org/) (approxmiate installation time: 10-15 minutes). Once installed, you will be required to install the following packages to use the R Markdown files (you will be automatically prompted to do so if using R Studio). The following packages/dependencies are required:

* dplyr - 1.1.2
* tidyverse - 2.0.0
* gtools - 3.9.4
* knitr - 1.42
* data.table - 1.14.8
* ggplot2 - 3.4.2
* car - 3.1-2
* ggbeeswarm - 0.7.2
* ggrepel - 0.9.3
* readxl - 1.4.2
* data.table - 1.14.8
* openxlsx - 4.2.5.2
* ggpubr - 0.6.0
* rstatix - 0.7.2
* "ez" - 4.4-0
* ggsignif - 0.6.4
* RColorBrewer - 1.1-3
* emmeans - 1.8.5
* plotrix - 3.8-2
* sdamr - 0.2.0
* cowplot - 1.1.1
* psycho - 0.6.1
* ggridges - 0.5.4
* viridis - 0.6.4
* ggstance - 0.3.6
* ggdist - 3.3.0
* gghalves - 0.1.4
* ggpp - 0.5.4
* lme4 - 1.1-33
* stringr - 1.5.0
* effectsize - 0.8.6
* lmerTest - 3.1-3
* TOSTER - 0.8.1

Before running each script, you will need to set the directory for source files so R can load these. The easiest method of doing this is searching by using Ctrl + F (Cmd + F on Mac) for the string "C:/", which should identify instances where you must set the directory. Once this is done, you can activate a code chunk by clicking anywhere within it and clicking "run chunk" or using Ctrl + Shift + Enter (Cmd + Option + R on Mac). You must activate each code chunk in sequence unless it is marked as optional or as a quality check chunk. Run each chunk until the end of the markdown file to reproduce relevant findings (i.e., ANCOVA and EEM modelling results) reported within the primary paper. It should take less than five minutes to run scripts on an average computer. If you have any difficulty running these scripts, please contact the repository host.

## Drift Diffusion Model instructions

To run the DDM computational modelling scripts you will need to use Docker to ensure consistency among Python dependencies. Docker can be downloaded [here](https://www.docker.com/products/docker-desktop/) (approxmiate installation time: 10-20 minutes). You will need a computer which allows virtualisation to use Docker; if you are unsure if this is enabled which can be checked in your BIOS menu (Docker will alert you if you try to launch it without virtualisation enabled). Once docker is running, you will need to use the image [hcp4715/hddm:0.8](https://hub.docker.com/layers/hcp4715/hddm/0.8.0/images/sha256-afcf9eab8ab17886e7e3941d58d57b0c607b878d6ac245592af7fdab68da2039?context=explore) on the Docker hub repo, however later versions of HDDM may also work. Once booted into the docker Python kernel you will be able to use Jupyter Notebook to launch the main HDDM script (./EGNG_DDM_and_analysis/HDDM_EGNG.ipynb). You will also need to load each file from the ./EGNG_DDM_and_analysis/raw_data folder (which was produced using the main AGNG preprocessing script) to reproduce the modelling parameter/likehood data (found in ./EGNG_DDM_and_analysis/All_params.csv). Given potential computational bottlenecks (leading to kernel failure), we recommend loading data from the Sep_halved which loads roughly 50% of the participant data at once (run time: approximately 5-10 minutes per section of data). The instructions within the .ipynb file should take you through the rest of the required steps.

## Reinforcement Learning Model instructions

Reinforcement modelling scripts for the PILT were created by Prof Michael Browning (michael.browning@psych.ox.ac.uk). These scripts have been tested on MATLAB version R2022a which can be downloaded [here](https://uk.mathworks.com/products/new_products/release2022a.html) (approxmiate installation time: 10-30 minutes), but may work on later versions. You will need to extract the scripts (./PILT_fitting_scripts/) to a location on your computer. Once extracted, you will need to set the directory within the main wrapper script (run_fit_all_chdr.m) and the extractor script (lucy_extractc.m). You will also need to make sure the 'Data' folder corresponds to the source data (.dat files) from the folder ./PILT_non-model_analysis/. Make sure to create an empty './Test' folder in the relevant directory to save the fitting procedure output. You can use the wrapper script to execute all code (selected 'Run all' setions or F5 while within the wrapper script). Running each script with the relevant modelling procedures will reproduce the modelling parameter/likehood data found in ./PILT_Reinforcement_Learning_Mod/Reinforcement_Learning_PILT_full.csv (run time: approximately 1-3 hours). Instructions for changing modelling procedures are included as comments within the script. 

## License

Mozilla Public License Version 2.0.
