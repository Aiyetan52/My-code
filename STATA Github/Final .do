clear all
use "/Users/imisiaiyetan/Downloads/Table19_4_data.dta"

* Question 1

* To generate the treatment variable 
gen treatment = 0
replace treatment = 1 if s >=15
* To generate the instrumental variables 
gen ssf = 0 
replace ssf = 1 if sf>=15
gen ssm = 0
replace ssm = 1 if sm>=15
gen sib = 1
replace sib = 0 if siblings > 3
* Question 2
* Before jumping into iv-regression, I estimate the effect of treatment 
*and other covariates on earnings 
reg earnings treatment wexp female  ethblack ethhisp married

*Robust ols  
reg earnings treatment wexp female ethblack ethhisp married, robust

*Question 3
*****************IV-regression******************************
****2sls*****************
ivregress 2sls earnings (treatment= ssf ssm sib) wexp female  ethblack ethhisp ///
married 
***** 2SLS Bias****
estat firststage
******Equivalently, Gmm IV-regression**************** 
ivregress gmm earnings (treatment= ssf ssm sib) wexp female  ethblack ethhisp ///
married
*****Standard Errors*************
* To estimate the correct standard error, we use bootstrap 
ivregress 2sls earnings (treatment= ssf ssm sib) wexp female ethblack ethhisp ///
married, vce(bootstrap, reps(1000) seed(423))
*Alternatively, 
bootstrap, reps(1000) seed(423):ivregress 2sls  earnings ///
(treatment= ssf ssm sib) wexp female  ethblack ethhisp married, robust

*

bootstrap _b[treatment] _se[treatment], reps(1000) seed(423) ///
saving(bootstrap_data, replace): ivregress 2sls earnings ///
(treatment= ssf ssm sib) wexp female  ethblack ethhisp married, robust

use "/Users/imisiaiyetan/Downloads/bootstrap_data.dta", clear

gen temp=(_bs_1+ 23.99881 )^2
egen temp2=mean(temp)
gen se=sqrt(temp2)
sum se
/* From asymptotic approx, Normal 95% CI is roughly  14.5665  33.11051*/
/* From boot-c, Normal 95% CI is roughly 14.46548    33.53213. */

_pctile _bs_1, p(14.5 33.5)

dis r(r2)
dis r(r1)

/* From boot-c, 95% CI is roughly 14.46548   33.53213. */

/* Boot-t */
gen t=(_bs_1+23.99881)/(_bs_2)
sum t,d
_pctile t, p(14.5 33.5)

dis r(r2)
dis r(r1)

/* This is based on coeff and std. error from regular robust SE estimation */
dis 23.99881+( 4.864031 )*(r(r1))
dis 23.99881+( 4.864031 )*(r(r2))






