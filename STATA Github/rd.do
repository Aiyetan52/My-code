************************************************
******* Generate Data **************************
************************************************
pause on

set obs 1001
gen x=uniform()
gen T=0
replace T=1 if x>0.5
gen g=T+3*log(x+1)+sin(x*12)/3

gen y=g+invnorm(uniform())/5
sort x
replace x=0.5 if _n==1001
replace g=. if _n==1001
replace y=. if _n==1001
gen g0=g if T==0
gen g1=g if T==1
scatter y g0 g1 x, c(. l l) s(x i i)
pause



************************************************
******* Try 3 different Bandwidths *************
************************************************
gen h1=0.1
gen h2=0.05
gen h3=0.01

************************************************
******* Kernel Regression with Uniform *********
******* Kernel *********************************
************************************************
gen kern11u=0
gen kern11l=0
replace kern11u=1 if ((x>0.5)&(x<0.5+h1))
replace kern11l=1 if ((x<0.5)&(x>0.5-h1))
reg y [pweight=kern11u]
predict b011u
reg y [pweight=kern11l]
predict b011l
gen est11=b011u-b011l

gen kern12u=0
gen kern12l=0
replace kern12u=1 if ((x>0.5)&(x<0.5+h2))
replace kern12l=1 if ((x<0.5)&(x>0.5-h2))
reg y [pweight=kern12u]
predict b012u
reg y [pweight=kern12l]
predict b012l
gen est12=b012u-b012l

gen kern13u=0
gen kern13l=0
replace kern13u=1 if ((x>0.5)&(x<0.5+h3))
replace kern13l=1 if  ((x<0.5)&(x>0.5-h3))
reg y [pweight=kern13u]
predict b013u
reg y [pweight=kern13l]
predict b013l
gen est13=b013u-b013l



************************************************
******* Kernel Regression with Epanechnikov ****
******* Kernel *********************************
************************************************
gen kern21u=0
gen kern21l=0
gen dx1=(x-0.5)/h1
replace kern21u=(1-dx1*dx1) if ((x>0.5)&(x<0.5+h1))
replace kern21l=(1-dx1*dx1) if ((x<0.5)&(x>0.5-h1))
reg y [pweight=kern21u]
predict b021u
reg y [pweight=kern21l]
predict b021l
gen est21=b021u-b021l

gen kern22u=0
gen kern22l=0
gen dx2=(x-0.5)/h2
replace kern22u=(1-dx2*dx2) if ((x>0.5)&(x<0.5+h2))
replace kern22l=(1-dx2*dx2) if  ((x<0.5)&(x>0.5-h2))
reg y [pweight=kern22u]
predict b022u
reg y [pweight=kern22l]
predict b022l
gen est22=b022u-b022l

gen kern23u=0
gen kern23l=0
gen dx3=(x-0.5)/h3
replace kern23u=(1-dx3*dx3) if  ((x>0.5)&(x<0.5+h3))
replace kern23l=(1-dx3*dx3) if ((x<0.5)&(x>0.5-h3))
reg y [pweight=kern23u]
predict b023u
reg y [pweight=kern23l]
predict b023l
gen est23=b023u-b023l
sum est11 est12 est13 est21 est22 est23
pause


************************************************
******* Local Linear Regression with ***********
******* different Kernels and bandwidths *******
************************************************
reg y  x [pweight=kern11u]
predict b031u
reg y x [pweight=kern11l]
predict b031l
gen est31=b031u-b031l if _n==1001
reg y  x [pweight=kern12u]
predict b032u
reg y x [pweight=kern12l]
predict b032l
gen est32=b032u-b032l if _n==1001
reg y  x [pweight=kern13u]
predict b033u
reg y x [pweight=kern13l]
predict b033l
gen est33=b033u-b033l if _n==1001

reg y  x [pweight=kern21u]
predict b041u
reg y x [pweight=kern21l]
predict b041l
gen est41=b041u-b041l if _n==1001
reg y  x [pweight=kern22u]
predict b042u
reg y x [pweight=kern22l]
predict b042l
gen est42=b042u-b042l if _n==1001
reg y  x [pweight=kern23u]
predict b043u
reg y x [pweight=kern23l]
predict b043l
gen est43=b043u-b043l if _n==1001
sum est31 est32 est33 est41 est42 est43
pause


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
replace gt5=1 if x>0.5
gen xgt=(x-0.5)*gt5
gen x2gt=xgt*xgt
gen x3gt=x2gt*xgt
gen x4gt=x3gt*xgt
gen x5gt=x4gt*xgt
gen x6gt=x5gt*xgt
gen x7gt=x6gt*xgt
gen x8gt=x7gt*xgt


reg y T x
reg y T x x2 x3
reg y T x x2 x3 x4
reg y T x x2 x3 x4 x5 x6
reg y T x x2 x3 x4 x5 x6 x7 x8
reg y T x xgt
reg y T x x2 x3 x4 xgt x2gt x3gt x4gt
reg y T x x2 x3 x4 x5 x6 xgt x2gt x3gt x4gt x5gt x6gt
reg y T x x2 x3 x4 x5 x6 x7 x8 xgt x2gt x3gt x4gt x5gt x6gt x7gt x8gt
