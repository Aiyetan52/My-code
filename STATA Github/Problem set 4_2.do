*****Name: Imisi Raphael Aiyetan******
*****Course: Econometrics 512********

***** Let's clear the workplace******
clear all 
set more off 

***** We import the data from Download folder*******

use "/Users/imisiaiyetan/Downloads/midterm-1.dta" 

***** We define the regression estimation in the next line of code*******

reg dayssmklm17 pct_insclnxtyr mhighgrad msomcol fhighgrad fsomcol parincome afqt, vce(robust) 

***We define the bootstrapping exercise of the regression estimation in the next line of code**** 

bs, reps(1000) seed(12345) size(500) saving(bsauto1, replace): reg dayssmklm17 pct_insclnxtyr mhighgrad msomcol fhighgrad fsomcol parincome afqt, vce(robust)

***** In the next line of code we define the IV estimation*******

ivregress gmm dayssmklm17 ctuition17 mhighgrad msomcol fhighgrad fsomcol parincome afqt, vce(robust) 

***We define the bootstrapping exercise of the IV estimation in the next line of code**** 

bs, reps(1000) seed(12345) size (500) saving(bsauto2, replace): ivregress gmm dayssmklm17 ctuition17 mhighgrad msomcol fhighgrad fsomcol parincome afqt, vce(robust)

****  In the next line of code we carry out sensitivity analysis on the instrument*****

use bsauto1, replace 

mean _b_pct_insclnxtyr

use bsauto2, replace

mean _b_ctuition17
