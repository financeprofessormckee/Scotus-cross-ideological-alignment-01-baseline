* ------------------------------------------------------------
* Supreme Court baseline Cross-Ideological Alignment
* Master Replication File
* Terms 2020–2024
*
* Running this file will:
* 1. Construct pairwise datasets
* 2. Run conservative analysis
* 3. Run liberal analysis
* ------------------------------------------------------------

clear all
set more off

* ------------------------------------------------------------
* Set project root directory
* Assumes this file is located in the project root
* ------------------------------------------------------------

cd "`c(pwd)'"

* ------------------------------------------------------------
* Step 1: Build Pairwise Datasets
* ------------------------------------------------------------

do "code/01_build_pairwise_data.do"

* ------------------------------------------------------------
* Step 2: Conservative Justice Analysis
* ------------------------------------------------------------

do "code/02_conservative_analysis.do"

* ------------------------------------------------------------
* Step 3: Liberal Justice Analysis
* ------------------------------------------------------------

do "code/03_liberal_analysis.do"

* ------------------------------------------------------------
* End of Master File
* ------------------------------------------------------------