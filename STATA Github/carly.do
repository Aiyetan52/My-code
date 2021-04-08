use "/Users/imisiaiyetan/Downloads/full merit aid data.dta" 

* To take the mean of all variables by state x year, we generate stateyear first
* and we estimate the mean of all variable. Finally, we run the regression based 
* the estimated mean of all variables  

gen stateyear = state*1000 + year 

* problem 1(a) 

reg coll merit male black asian i.state i.year, cluster(state)

* problem 1(b) 

* variable weights for each state*year based on number of observations in easch state*year 

egen n = count(stateyear), by (stateyear)  

gen weight = 1/n 

reg coll merit male black asian i.state i.year [w = weight], cluster(state)

* problem 1(c)

collapse (mean) coll merit male black asian state year, by (stateyear) 

reg coll merit male black asian i.state i.year, cluster(state)

* problem 1(d)

* To take the mean of all variables by state x year, we generate stateyear first
* and we estimate the mean of all variable. Finally, we run the regression based 
* the estimated mean of all variables using the weight. 

gen stateyear = state*1000 + year 


collapse (mean) coll merit male black asian state year, by (stateyear) 

egen n = count(stateyear), by (stateyear)  

gen weight = 1/n 

reg coll merit male black asian i.state i.year [w = weight], cluster(state)

*Problem 2

* load dataset
 use "/Users/imisiaiyetan/Downloads/synth_smoking.dta"
 
 tsset state year

* We create treatment based on the information from the question 

gen treat = 0

replace treat =  1 if state == 3 & year > = 1989



* Q(a)
* regression without additional variables 

reg cigsale treat i.state i.year, cluster(state)

* regression with additional variables 

 
reg cigsale treat lnincome beer age15to24 retprice i.state i.year, cluster(state)

*Q(b)

synth cigsale beer(1984(1) 1988) lnincome retprice age15to24 cigsale(1988) ///
cigsale(1980) cigsale(1975), trunit(3) trperiod(1989) fig 

*Q(c)


synth cigsale beer(1984(1) 1988) lnincome retprice age15to24 ///
cigsale(1970(1)1988), trunit(3) trperiod(1989) fig 

*Q(d)

 ** loop through units
 forval i=1/39{

qui synth cigsale retprice cigsale(1988) cigsale(1980) cigsale(1975), ///
xperiod(1980(1)1988) trunit(`i') trperiod(1989) keep(synth_`i', replace)
}
 forval i=1/39{

use synth_`i', clear

rename _time years

gen tr_effect_`i' = _Y_treated - _Y_synthetic

keep years tr_effect_`i'

drop if missing(years)

save synth_`i', replace
}

use synth_1, clear

forval i=2/39{

qui merge 1:1 years using synth_`i', nogenerate
}
local lp

forval i=1/39 {
   local lp `lp' line tr_effect_`i' years, lcolor(gs12) ||
}
*

* create plot

twoway `lp' || line tr_effect_3 years, ///
lcolor(orange) legend(off) xline(1989, lpattern(dash))
