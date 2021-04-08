*************Name: Imisi Raphael Aiyetan***************
*************Course: Econometrics 512******************

clear all


set more off 
**** We define the number of observation  for the uniform distribution******
set obs 1000 

gen a = _n

*** We define the disribution in the next line of code******

gen t = runiform()

**** Generate Y varibale assuming mean = 0 and variance = 1***** 

gen y = 10 + rnormal()

**** Generate t1 varibale assuming mean = 0 and variance = 1*****
 
gen t1 = t + rnormal() 

**** Generate t2 varibale assuming mean = 0 and variance = 1*****

gen t2 =  t + rnormal() 

***** Q1= We run Y on t *********

 reg y t 
 
***** We define the next line of code how to derive beta1********

mat beta1 = e(b) 

svmat beta1, names(matcol) 

scalar beta_endog1 = beta1t * (1/(1+1))  

***** Q2 = We run Y on t1 ********* 

 reg y t1 
 
***** We define the next line of code on how to derive beta1********

mat beta2 = e(b) 

svmat beta2, names(matcol) 

scalar beta_endog2 = beta2t1 

****Q3 = We run Y on t2 replacing t1 as an IV to estimate beta close beta1****

reg y t2 
 
scalar list 

