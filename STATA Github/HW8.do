
use "/Users/imisiaiyetan/Downloads/Table11_1.dta"

gen treat1 = 0

replace treat1 =  1 if hwage >= 5 

gen treat2 = 0

replace treat2 =  1 if wage >= 7

gen treat3 = 0

replace treat3 =  1 if unemployment  >= 5 



ivregress 2sls mtr treat1 treat2 age heduc hsiblings  (siblings= treat3)

reg mtr treat1 treat2 treat3 age heduc hsiblings 
mat beta = e(b) 
svmat beta, names(matcol) 

reg siblings treat1 treat2 treat3 age heduc hsiblings
mat gamma = e(b) 
svmat gamma, names(matcol) 

* Take the ratio of the two coefficients derived 

scalar alpha_hat1 = betatreat3/gammatreat3
display alpha_hat1
