* Problem 2 

* 2a(i) 
use "/Users/imisiaiyetan/Documents/jtrain1(1).dta"

* 2a(i): Constructing the 4 means 

save train.dta, replace 

drop if missing(hrsemp) 

drop if year ==1989 

save train2.dta, replace 

egen E = max(grant), by(fcode)

mean (hrsemp) if year==1987 & E==0
mean (hrsemp) if year==1988 & E==0
mean (hrsemp) if year==1987 & E==1
mean (hrsemp) if year==1988 & E==1

ttest hrsemp, by(E)

ttest hrsemp if year==1987, by(E)
ttest hrsemp if year==1988, by(E)

* 2a(ii): Estimating the regression model 

reg hrsemp grant d88 E

* 2a(iii): Estimating the fixed effect model  

xtset fcode year 

xtreg hrsemp grant d88, fe 

save train2.dta, replace 

* 2b(i) Estimating the fixed effect regression by adding trend in the data

use train.dta 

egen E = max(grant), by(fcode) 

bys fcode: gen t = _n

reg hrsemp grant d88 E t 

xtset fcode year 

xtreg hrsemp grant d88, fe 

* 2b(ii) Estimating regression model based on the residuals from firm specific 
* regression with trend.

drop if missing(hrsemp) 

xtreg hrsemp t, fe
 
predict hrsemp_res

drop if missing(grant) 

xtreg grant t, fe 

predict grant_res

drop if missing(d88) 

xtreg d88 t, fe 

predict d88_res

drop if missing(E) 

xtreg E t, fe 

predict E_res

reg hrsemp_res grant_res d88_res E_res

