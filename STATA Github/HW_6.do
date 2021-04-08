clear all 
set more off 

use "C:\Users\Maksud\Google Drive\EconS 512\Homework & Tests\full merit aid data.dta", clear 

gen stateyear = state*100000 + year 

* problem 1(a) 

quietly reg coll merit male black asian i.state i.year, r 
estimates store a_robust

quietly reg coll merit male black asian i.state i.year, cluster(state)
estimates store a_state

quietly reg coll merit male black asian i.state i.year, cluster(stateyear) 
estimates store a_stateyear  


* problem 1(b) 

* variable weights for each state*year based on number of observations in easch state*year 

egen n = count(stateyear), by (stateyear)  

gen weight = 1/n 

quietly reg coll merit male black asian i.state i.year [w = weight], r 
estimates store b_robust 

quietly reg coll merit male black asian i.state i.year [w = weight], r 
estimates store b_state

quietly reg coll merit male black asian i.state i.year [w = weight], r 
estimates store b_stateyear

estout a_robust a_state a_stateyear b_robust b_state b_stateyear, cells (b(star) se)


* problem 1(c)

collapse (mean) coll merit male black asian state year weight, by (stateyear) 

quietly reg coll merit male black asian i.state i.year, r 
estimates store c_robust

quietly reg coll merit male black asian i.state i.year, cluster(state)
estimates store c_state


* problem 1(d) 

* variable weights 

quietly reg coll merit male black asian i.state i.year [w = weight], r 
estimates store d_robust 

quietly reg coll merit male black asian i.state i.year [w = weight], r 
estimates store d_state

estout c_robust c_state d_robust d_state, cells (b(star) se)

*********************************************

clear all 

set more off 

use "C:\Users\Maksud\Google Drive\EconS 512\Homework & Tests\synth_smoking.dta", clear 

tsset state year 

* create treatment 

gen treat = 0

replace treat =  1 if state == 3 & year > = 1989

* problem 2(a) 

* regression without additional covariates 

quietly reg cigsale treat i.state i.year, cluster(state)
estimates store a_nocovariates

* regression with additional covariates 
 
quietly reg cigsale treat lnincome beer age15to24 retprice i.state i.year, cluster(state)
estimates store a_covariates 

estout a_nocovariates a_covariates, cells (b(star) se) 


* problem 2(b)

synth cigsale beer(1984(1) 1988) lnincome retprice age15to24 cigsale(1988) cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) fig 

graph save Graph "C:\Users\Maksud\Google Drive\EconS 512\Homework & Tests\hw6_1.gph"

* problem 2(c) 

synth cigsale beer(1984(1) 1988) lnincome retprice age15to24 cigsale(1970(1)1988), trunit(3) trperiod(1989) fig 

graph save Graph "C:\Users\Maksud\Google Drive\EconS 512\Homework & Tests\hw6_2.gph"
