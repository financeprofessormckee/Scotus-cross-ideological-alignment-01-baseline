* ------------------------------------------------------------
* Supreme Court Cross-Ideological Alignment
* Data Preparation File
* Terms 2020–2024
*
* This file:
* 1. Loads justice-centered SCDB voting data
* 2. Restricts to 2020–2024 Terms
* 3. Constructs pairwise justice voting observations
* 4. Identifies liberal and conservative justices
* 5. Generates same-side alignment indicator
* 6. Exports conservative–liberal and liberal–conservative datasets
* ------------------------------------------------------------
		
* ------------------------------------------------------------
* Load justice-centered voting data
* ------------------------------------------------------------

use "SCDB_2025_01_justiceCentered_Citation", clear

* Restrict to Terms 2020–2024
keep if term >= 2020 & term <= 2024

* Retain only variables needed for alignment analysis
keep term justice caseId vote 

* ------------------------------------------------------------
* Construct pairwise justice observations within each case
* Each case is expanded so every justice is paired with every
* other participating justice.
* ------------------------------------------------------------

rename justice justice1
rename vote vote1

* create majority and dissent variables
drop if vote == 8 | vote == .
gen in_majority = inlist(vote,1,3,4,5) 
gen in_dissent = inlist(vote,2,7)

rename in_majority maj1
rename in_dissent diss1

tempfile temp
save `temp'

rename justice1 justice2
rename maj1 maj2
rename diss1 diss2
rename vote vote2

joinby caseId using `temp'

* Remove self-pairs (justice paired with themselves)
drop if justice1 == justice2 

* ------------------------------------------------------------
* Identify ideological blocs (SCDB justice codes)
*
* Liberals:
* Breyer = 110
* Sotomayor = 113
* Kagan = 114
* Jackson = 118
*
* Conservatives:
* Thomas = 108
* Roberts = 111
* Alito = 112
* Gorsuch = 115
* Kavanaugh = 116
* Barrett = 117
* ------------------------------------------------------------

gen liberal1 = inlist(justice1,110,113,114,118)
gen liberal2 = inlist(justice2,110,113,114,118)

gen conservative1 = inlist(justice1,108,111,112,115,116,117)
gen conservative2 = inlist(justice2,108,111,112,115,116,117)

* ------------------------------------------------------------
* Generate same-side alignment indicator
* Equals 1 if both justices voted in majority or both in dissent
* ------------------------------------------------------------

gen same_side = maj1 == maj2

* ------------------------------------------------------------
* Export datasets for separate analysis
* ------------------------------------------------------------

preserve
keep if conservative1 == 1 & liberal2 == 1

save "data/conservative_pairs.dta", replace
restore

preserve
//keep only liberal-conservative pairs
keep if conservative2 == 1 & liberal1 == 1
save "data/liberal_pairs.dta", replace
restore

* ------------------------------------------------------------
* End of data preparation file
* ------------------------------------------------------------