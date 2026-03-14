* ------------------------------------------------------------
* Liberal Justices: Cross-Ideological Alignment (Baseline)
* Terms 2020–2024
*
* This file:
* 1. Loads liberal–conservative pairwise voting data
* 2. Constructs a sorted justice variable for plotting
* 3. Estimates logistic regression with case-level clustering
* 4. Generates dot-and-whisker plot of predicted probabilities
* 5. Performs pairwise comparisons of predicted alignment rates
* ------------------------------------------------------------

* Load liberal–conservative pair dataset
use "data/liberal_pairs.dta", clear

* ------------------------------------------------------------
* Construct sorted justice variable for plotting
* SCDB justice codes:
* Kagan = 114
* Breyer = 110
* Jackson = 118
* Sotomayor = 113
* ------------------------------------------------------------

gen justice_sorted = .
replace justice_sorted = 1 if justice1 == 114   // Kagan
replace justice_sorted = 2 if justice1 == 110   // Breyer
replace justice_sorted = 3 if justice1 == 118   // Jackson
replace justice_sorted = 4 if justice1 == 113   // Sotomayor

label define sortedlbl ///
    1 "Kagan" ///
    2 "Breyer" ///
    3 "Jackson" ///
    4 "Sotomayor"

label values justice_sorted sortedlbl

* ------------------------------------------------------------
* Logistic regression:
* Dependent variable: same_side 
* (1 = voted on same side as conservative justice)
* Clustered standard errors at the case level
* ------------------------------------------------------------

logit same_side i.justice_sorted, cluster(caseId)

* Predicted probabilities of alignment by justice
margins justice_sorted

* ------------------------------------------------------------
* Dot-and-whisker plot of predicted probabilities
* Horizontal layout with 95% confidence intervals
* ------------------------------------------------------------

marginsplot, ///
    horizontal ///
    recast(scatter) ///
    recastci(rcap) ///
    plot1opts(msymbol(circle) mcolor(navy) msize(large)) ///
    ciopts(lcolor(navy) lwidth(medthin)) ///
    xscale(range(.50 .65)) ///
	yscale(reverse) ///
    xlabel(.50(.05).65, nogrid) ///
    ylabel(, angle(0) nogrid) ///
    xtitle("Probability of Voting with Conservative Justices") ///
    ytitle("") ///
    title("Cross-Ideological Alignment Rates for Liberal Justices (2020–Present)") ///
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(color(white))
	
graph export "output/figures/part01_liberals.png", replace

* ------------------------------------------------------------
* Pairwise comparisons of predicted probabilities
* Tests whether differences in alignment rates are statistically significant
* ------------------------------------------------------------
margins justice_sorted, pwcompare(effects)
