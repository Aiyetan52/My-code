 
 ****Name: Imisi Raphael Aiyetan*****
 *******Problem 1******
 
 * Let's load the data from download folder 
clear 
set more off 
webuse auto 

***Note: I just use this data to implement the code.

use "/Users/imisiaiyetan/Downloads/STC1.dta"

* Problem 1a: Run the multiple regression 

reg lnoutput lnlabor lncapital 

* problem 1b: Regress lnoutput on lncapital to predict the first residual. 
*Similarly, regress  lnlabour on lncapital to predict the second residual 

reg lnoutput lncapital  
predict e1, residuals 

reg  lnlabor lncapital 
predict e2, residuals 

reg e1 e2 


* problem 1c: The next procedure is to regress lnoutput on the second residual 

reg lnoutput e2 



* problem 2: IV regression  


* problem 2a: Instrumental Variable regression. lnoutlab is used as an 
*instrument in this regression. In that case, we replace lncapital with 
*lnoutlab and lnoutput is regressed on lnlabor lnoutlab 

ivregress gmm lnoutput lnlabor (lncapital = lnoutlab) 


reg lnoutput lnlabor lnoutlab 

* problem 2b: To perform two stage least squares, predict lncapital_hat 
*and thereafter regress lnoutput on lnlabour and lncapital_hat 

predict lncapital_hat 

reg lnoutput lnlabor lncapital_hat 

* problem 2c: Regress lnoutput on lnlabor and lnoutlab and generate the 
*first coefficient. Similarly, Regress lncapital on lnlabor and lnoutlab and 
*generate the second coefficient 

reg lnoutput lnlabor lnoutlab 
mat beta = e(b) 
svmat beta, names(matcol) 

reg lncapital lnlabor lnoutlab
mat gamma = e(b) 
svmat gamma, names(matcol) 

* Take the ratio of the two coefficients derived 

scalar alpha_hat1 = betalnoutlab/gammalnoutlab 
display alpha_hat1 

* problem 2d: Check using another approach, if we will arrive at the same 
* alpha_hat1. The procedure is as follows 

* regress lnoutlab on lnlabor and predict the first residuals   

reg lnoutlab lnlabor  
predict e_z, residuals 

* regress lnoutput on lnlabor and predict the second residuals

reg lnoutput lnlabor 
predict e_y, residuals 

* regress lnoutlab on lnlabor and predict the third residuals

reg lncapital lnlabor 
predict e_t, residuals 

* Estimate the first covariance using the second and the first residuals 

corr e_y e_z, covariance 
scalar scov1 = r(cov_12) 

* Estimate the second covariance using the third and the first residuals 

corr e_t e_z, covariance 
scalar scov2 = r(cov_12) 

* Finally, divide the first covariance by the second covariance.

scalar alpha_hat2 = scov1/scov2 
display alpha_hat2 






