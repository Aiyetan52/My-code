clear all
set more off 

bcuse wagepan  

* create treatment variable 

gen y = lwage 

gen x = hours/24

sum x 

gen x_bar = r(mean) 

gen T = 0 

replace T = 1 if x>x_bar


* create bandwidth 

gen h1=.2
gen h2= .5
gen h3= 1


******* Kernel Regression with Uniform *********

* treatment effect using h1 bandwidth 

gen kern11u=0
gen kern11l=0
replace kern11u=1 if ((x>x_bar)&(x<x_bar+h1))
replace kern11l=1 if ((x<x_bar)&(x>x_bar-h1))

reg y [pweight=kern11u]
predict b011u

reg y [pweight=kern11l]
predict b011l

gen est11=b011u-b011l

* treatment effect using h2 bandwidth 

gen kern12u=0
gen kern12l=0
replace kern12u=1 if ((x>x_bar)&(x<x_bar+h2))
replace kern12l=1 if ((x<x_bar)&(x>x_bar-h2))

reg y [pweight=kern12u]
predict b012u

reg y [pweight=kern12l]
predict b012l

gen est12=b012u-b012l

* treatment effect using h3 bandwidth 

gen kern13u=0
gen kern13l=0
replace kern13u=1 if ((x>x_bar)&(x<x_bar+h3))
replace kern13l=1 if  ((x<x_bar)&(x>x_bar-h3))

reg y [pweight=kern13u]
predict b013u
reg y [pweight=kern13l]
predict b013l

gen est13=b013u-b013l

mean est11 est12 est13


******* Local Linear Regression with ***********
******* different Kernels and bandwidths *******

* uniform kernel with h1 bandwidths 

reg y  x [pweight=kern11u]
predict b031u
reg y x [pweight=kern11l]
predict b031l

gen est31=b031u-b031l 

* uniform kernel with h2 bandwidths 

reg y  x [pweight=kern12u]
predict b032u
reg y x [pweight=kern12l]
predict b032l

gen est32=b032u-b032l 

* uniform kernel with h3 bandwidths 

reg y  x [pweight=kern13u]
predict b033u
reg y x [pweight=kern13l]
predict b033l

gen est33=b033u-b033l


mean est31 est32 est33 

************************************************
******* Polynomial Regression Approach *********
************************************************
gen x2=x*x
gen x3=x*x2
gen x4=x*x3
gen x5=x*x4
gen x6=x*x5
gen x7=x*x6
gen x8=x*x7
gen gt5=0
replace gt5=1 if x>x_bar
gen xgt=(x-x_bar)*gt5
gen x2gt=xgt*xgt
gen x3gt=x2gt*xgt
gen x4gt=x3gt*xgt
gen x5gt=x4gt*xgt
gen x6gt=x5gt*xgt
gen x7gt=x6gt*xgt
gen x8gt=x7gt*xgt


reg y T x
mat b1 = e(b) 
mat V1 = e(V) 
svmat b1, names(matcol)
svmat V1, names(matcol) 

reg y T x x2  
mat b2 = e(b ) 
svmat b2, names(matcol) 
mat V2 = e(V) 
svmat V2, names(matcol) 


reg y T x x2 x3 
mat b3 = e(b) 
svmat b3, names(matcol) 
mat V3 = e(V) 
svmat V3, names(matcol) 

reg y T x x2 x3 x4
mat b4 = e(b) 
svmat b4, names(matcol) 
mat V4 = e(V) 
svmat V4, names(matcol) 

reg y T x x2 x3 x4 x5 x6
mat b5 = e(b) 
svmat b5, names(matcol) 
mat V5 = e(V) 
svmat V5, names(matcol) 

reg y T x x2 x3 x4 x5 x6 x7 x8
mat b6 = e(b) 
svmat b6, names(matcol) 
mat V6 = e(V) 
svmat V6, names(matcol) 


reg y T x xgt
mat b7 = e(b) 
svmat b7, names(matcol) 
mat V7 = e(V) 
svmat V7, names(matcol) 


reg y T x x2 x3 x4 xgt x2gt x3gt x4gt
mat b8 = e(b) 
svmat b8, names(matcol) 
mat V8 = e(V) 
svmat V8, names(matcol) 

reg y T x x2 x3 x4 x5 x6 xgt x2gt x3gt x4gt x5gt x6gt
mat b9 = e(b) 
svmat b9, names(matcol) 
mat V9 = e(V) 
svmat V9, names(matcol) 

reg y T x x2 x3 x4 x5 x6 x7 x8 xgt x2gt x3gt x4gt x5gt x6gt x7gt x8gt
mat b10 = e(b) 
svmat b10, names(matcol) 
mat V10 = e(V) 
svmat V10, names(matcol) 

gen bT1u = b1T + 1.96*sqrt(V1T)
gen bT1l = b1T - 1.96*sqrt(V1T) 

gen bT2u = b2T + 1.96*sqrt(V2T)
gen bT2l = b2T - 1.96*sqrt(V2T)

gen bT3u = b3T + 1.96*sqrt(V3T)
gen bT3l = b3T - 1.96*sqrt(V3T)

gen bT4u = b4T + 1.96*sqrt(V4T)
gen bT4l = b4T - 1.96*sqrt(V4T)

gen bT5u = b5T + 1.96*sqrt(V5T)
gen bT5l = b5T - 1.96*sqrt(V5T)

gen bT6u = b6T + 1.96*sqrt(V6T)
gen bT6l = b6T - 1.96*sqrt(V6T)

gen bT7u = b7T + 1.96*sqrt(V7T)
gen bT7l = b7T - 1.96*sqrt(V7T)

gen bT8u = b8T + 1.96*sqrt(V8T)
gen bT8l = b8T - 1.96*sqrt(V8T) 

gen bT9u = b9T + 1.96*sqrt(V9T)
gen bT9l = b9T - 1.96*V9T

gen bT10u = b10T + 1.96*sqrt(V10T)
gen bT10l = b10T - 1.96*sqrt(V10T) 

mean b1T b2T b3T b4T b5T b6T b7T b8T b9T b10T 
mean bT1u bT2u bT3u bT4u bT5u bT6u bT7u bT8u bT9u bT10u
mean bT1l bT2l bT3l bT4l bT5l bT6l bT7l bT8l bT9l bT10l
    
