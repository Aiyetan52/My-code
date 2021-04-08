
// Name:  Imisi Raphael AIYETAN
// Course: Econometrics 512
//Topic: Effect of expectant  mothers smoking while pregnant on the birthweight of their kid 

clear 

set more off 

// To start with, let's set the path for the data from download folder.

use  "/Users/imisiaiyetan/Downloads/bwght2.dta"


// In the next lines of codes, we construct the treatment variable based on the condition 
//that if the mother ever smoked then we have cigs>0

gen Treatment_smoke = 0 

replace Treatment_smoke = 1 if cigs>0 


// The next lines of codes define the difference in log birthweight for mothers who smoked 
//versus those who didn't smoke. Basically, the difference in average of the mothers 
//who smoked from those who didn't smoked.


sum lbwght if Treatment_smoke ==1

scalar mean_Treatment_smoke = r(mean)

sum lbwght if Treatment_smoke ==0

scalar mean_noTreatment_smoke = r(mean)

display mean_noTreatment_smoke - mean_Treatment_smoke

 

// The next line of code indicates the estimation of the regression equation by running the 
//log birthweight on the treatment variable(i.e. smoked) and the control variables


reg lbwght Treatment_smoke mage meduc monpre npvis fage feduc fblck magesq npvissq mblck



// Having defined the regression estimate code, The next line of code defines the 
//propensity score matching routine to estimate the average treatment effect. 



teffects psmatch (lbwght) (Treatment_smoke mage meduc monpre npvis fage feduc fblck magesq npvissq mblck)


// In the next line of code, we define the code that estimate the treatment on the 
//treated with the propensity score matching routine


teffects psmatch (lbwght) (Treatment_smoke mage meduc monpre npvis fage feduc fblck magesq npvissq mblck), atet 

// In the next lines of codes, we define how the propensity score varies by mothers 
//who smoked and those who didn't through the estimation of the logit model and thereafter
// we calculate the propensity score for each individual based on the predicted value from this
// regression and we graph the distributions of the propensity score conditional on smoked=1 and no smoked ==0

logit Treatment_smoke mage meduc monpre npvis fage feduc fblck magesq npvissq mblck

predict Treatment_smoke_pred 

twoway (kdensity Treatment_smoke_pred if Treatment_smoke ==1) (kdensity Treatment_smoke_pred if Treatment_smoke ==0), legend (label(1 "Smoked") label(2 "No_Smoked"))
