# Description

This repository contains source data and scripts (preprocessing, modelling and analyses) used in the Colwell et al. paper concerning the influence of SSRAs on human behaviour.

This datapack has been updated following publication revision on 18/02/2024.

You will need access to R, RStudio, MATLAB, Docker, and Python to run all the scripts contained within this datapack. 

For any questions or to report any issues, please contact Michael Colwell (michaelcolwell92@gmail.com / michael.colwell@psych.ox.ac.uk).

If you wish to use our data in your research study, please first contact catherine.harmer@psych.ox.ac.uk.

## DOI

https://doi.org/10.5281/zenodo.8395069

## Instructions

The datapack branches into folders which pertain (mostly) to tasks analysed throughout the paper (e.g. PILT). Each task folder will contain an associated RMarkdown file. You will need
to manually set the directory within each markdown file to run the scripts.

The scripts have been tested on Windows with R version 4.3.1. The following packages are required to run all analyses:

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

## DDM

You will be able to rerun the AGNG drift difusion modelling via Python + Docker. You will require the docker image "hcp4715/hddm" on the Docker hub repo.

This will have all required versions of language/package to run the HDDM script. However, keep in mind that running the docker image requires virtualisation which entails a computational bottleneck. You will
need a good computer to run this or there is a high chance of kernel failure. 

## Reinforcement Learning Models

Reinforcement modelling scripts for the PILT were created by Prof Michael Browning (michael.browning@psych.ox.ac.uk), and are available upon request. 

## License

GNU GPLv3 (see LICENSE.md)
