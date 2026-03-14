* ------------------------------------------------------------
* Conservative Justices: Cross-Ideological Alignment (Baseline)
* Terms 2020–2024
* 
* This file:
* 1. Loads conservative–liberal pairwise voting data
* 2. Constructs a sorted justice variable for plotting
* 3. Estimates logistic regression with case-level clustering
* 4. Generates dot-and-whisker plot of predicted probabilities
* 5. Performs pairwise comparisons of predicted alignment rates
* ------------------------------------------------------------

* Load conservative-liberal pair dataset
use "data/conservative_pairs.dta", clear

* ------------------------------------------------------------
* Construct sorted justice variable for plotting
* SCDB justice codes:
* Roberts = 111
* Thomas = 108
* Alito = 112
* Gorsuch = 115
* Kavanaugh = 116
* Barrett = 117
* ------------------------------------------------------------

gen justice_sorted = .
replace justice_sorted = 1 if justice1 == 111   // Roberts
replace justice_sorted = 2 if justice1 == 116   // Kavanaugh
replace justice_sorted = 3 if justice1 == 117   // Barrett
replace justice_sorted = 4 if justice1 == 115   // Gorsuch
replace justice_sorted = 5 if justice1 == 108   // Thomas
replace justice_sorted = 6 if justice1 == 112   // Alito

label define sortedlbl ///
    1 "Roberts" ///
    2 "Kavanaugh" ///
    3 "Barrett" ///
    4 "Gorsuch" ///
    5 "Thomas" ///
    6 "Alito"

label values justice_sorted sortedlbl

* ------------------------------------------------------------
* Logistic regression:
* Dependent variable: same_side (1 = voted same side as liberal justice)
* Clustered standard errors at the case level
* ------------------------------------------------------------

logit same_side i.justice_sorted, cluster(caseId)

* Predicted probabilities of alignment by justice
margins justice_sorted

* ------------------------------------------------------------
* Dot-and-whisker plot of predicted probabilities
* Horizontal layout, 95% confidence intervals
* ------------------------------------------------------------

marginsplot, ///
    horizontal ///
    recast(scatter) ///
    recastci(rcap) ///
    plot1opts(msymbol(circle) mcolor(navy) msize(large)) ///
    ciopts(lcolor(navy) lwidth(medthin)) ///
    xscale(range(.45 .65)) ///
	yscale(reverse range(.5 6.5)) ///
    xlabel(.45(.05).65, nogrid) ///
    ylabel(, angle(0) nogrid) ///
    xtitle("Probability of Voting with Liberal Justices") ///
    ytitle("") ///
    title("Cross-Ideological Alignment Rates (2020–Present)") ///
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(color(white))
	
graph export "output/figures/part01_conservatives.png", replace

* ------------------------------------------------------------
* Pairwise comparisons of predicted probabilities
* Reports differences in alignment rates between justices
* ------------------------------------------------------------
margins justice_sorted, pwcompare(effects)





