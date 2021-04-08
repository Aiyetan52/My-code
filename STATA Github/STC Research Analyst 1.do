
***Name: Imisi Raphael Aiyetan ***
****		Problem 1 *****

*****Note: I just use this data to implement the code. 

use "/Users/imisiaiyetan/Documents/STC.dta"


* 1(a): Estimating fixed effect by constructing standard errors in 2 ways 

xtset id year 
* The regular robust standard errors

xtreg lrpdi lsales, fe vce(robust)
 
* Clustering  by i, the of cross-sectional observation

xtreg lrpdi lsales, fe vce(cluster id) 

* 1(b): Estimating fixed effect using Demean approach

egen lsale_bar = mean(lsales)

egen lrpdi_bar =mean(lrpdi)

gen z = lsales - lsale_bar
 
gen q = lrpdi - lrpdi_bar 

reg z q

egen l_sale_bar = mean(lsales), by(id)

egen l_rpdi_bar =mean(lrpdi), by(id)

gen x = lsales - l_sale_bar
 
gen y = lrpdi - l_rpdi_bar 

reg y x 



* 1(c) Estimating the fixed effect using the poolregression with individual 
* dummy variable and by cluster

* Estimating regression equation with individual dummy variable. Note that 
*we removed D1 to avoid dummy variable trap.

reg lrpdi lsales d2 d3 d4 d5 d6 d7 

* Estimating regression equation with clustering by i

reg lrpdi lsales i.id 
