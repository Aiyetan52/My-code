######Imisi Raphael Aiyetan########################
####Topic: Discrete Choice,Stated Preference and Revealed Preference#####
library(stargazer)
library("fastDummies")
library(mlogit)
##################QUESTION 1##############################################
# Dataframe
ic=c(5.9948,7.8305,	7.1986,	9.0011,10.483,
     5.6844,6.1743,6.8718,7.1872,7.7554,
     6.5757,8.9216,7.8807,7.9952,10.831)
oc=c(1.6558,1.378,4.3906,4.0474,1.7147,
     1.1945,1.1168,3.6592,3.9514,1.7353,
     1.7615,1.4893,4.4099,2.8629,2.0387)
#Estimate the Model 
Vij=-0.6231*ic-0.4580*oc
#Find the exponential of the value function
chc=exp(Vij)
#Slice and column bind
x_3=chc[c(1:5)]
x_14=chc[c(6:10)]
x_21=chc[c(11:15)]
##question  b
prob=cbind(x_3/sum(x_3),x_14/sum(x_14),x_21/sum(x_21))
##question  c
j_5=c(10.483,7.7554, 10.831)
Redn=cbind((0.15*100*j_5)*1.36)
t(prob)
Redn
stargazer(t(prob), title="Predicted probabilities")
stargazer(Redn, title="Fifteen percent Reduction")
####################QUESTION 2 ###################################
#load Data
Kolkata_vaccine=read_csv("Kolkata vaccine.csv")
# Create Dummmies using Fast Dummies 
Kolkata= fastDummies::dummy_cols(Kolkata_vaccine)
#3a, estimate probit regression for the four model
mod=glm(yesno~priceUS+chol_cholera+ttt_TTT+til_Tiljala, 
        family=binomial(link ="probit"),data=Kolkata)
mod1=glm(yesno~priceUS+chol_cholera+ttt_TTT,
         family=binomial(link ="probit"),data=Kolkata, subset = til == "Beli")
mod2=glm(yesno~priceUS+chol_cholera,
         family=binomial(link ="probit"),data=Kolkata, subset = til == "Tiljala")
mod3=glm(yesno~priceUS+chol_cholera+ttt_TTT+til_Tiljala+
           male+age+edu2+edu3+edu4+KNOW,family=binomial(link ="probit"),data=Kolkata)
summary(mod)
summary(mod1)
summary(mod2)
summary(mod3)
stargazer(mod, mod1, mod2,mod3, title="Probit Regressions of Vaccine demand in cholera")

####################QUESTION 3a ###################################
#Load Data
Vietnam_choice=read_csv("Vietnam choice.csv")
#Estimate multinomial logit regression using mlogit package for three models
Bhat=mlogit.data(Vietnam_choice, shape = "long", chid.var = "line",
                 alt.var = "alternative", choice = "choice", drop.index = TRUE)
logit=mlogit(choice~price+asc+eff70+eff99+dur+vacc_ch|-1, Bhat)
logit1=mlogit(choice~price+asc+eff70+eff99+dur+vacc_ch|-1, Bhat ,subset = nttt == "1")
logit2=mlogit(choice~price+asc+eff70+eff99+dur+vacc_ch|-1, Bhat ,subset = ttt == "1")
summary(logit)
summary(logit1)
summary(logit2)
stargazer(logit, logit1, logit2, 
          title="Conditional logit models of vaccine demand in Hue, Vietnam")

####################QUESTION 3b ###################################
# Generate Willingness to pay using the estimates from logit1
coef(logit1)[- 1] / coef(logit1)[1]

#Estimate multinomial logit regression question 3b
logit3=mlogit(choice~nprice+tprice+nasc+tasc+neff70+teff70+teff99+neff99
              +ndur+tdur+nvacc_ch+tvacc_ch|-1, Bhat)
summary(logit3)
stargazer( logit3, title=" Conditional logit models of 
           vaccine demand in Hue, Vietnam (Fully Interacted TTT)")

####################QUESTION 4a ###################################
# Reshape the data for mixed logit
Bha1t=mlogit.data(Vietnam_choice, shape = "long", chid.var = "line",
                  id="respid", 
                  alt.var = "alternative", choice = "choice", drop.index = TRUE)
#Estimate mixed logit
mixlogit=mlogit(choice~price+asc+eff70+eff99+dur+vacc_ch|-1,  Bha1t, 
                rpar=c(price="n",asc="n"), R=100, halton=NA,print.level=0,panel = TRUE )
summary(mixlogit)
stargazer(mixlogit, title="Mixed logit model of vaccine demand in Hue, Vietnam ")

####################QUESTION 4b ###################################
# Estimate normally distribution pf fixed coefficients
pnorm(-coef(mixlogit)['price']/coef(mixlogit)['sd.price'])
pnorm(-coef(mixlogit)['asc']/coef(mixlogit)['sd.asc'])
#Fitted mixedlogit for individual-level expected WTP
indpar=fitted(mixlogit, type = "parameters")
#Plot of individual-level expected WTP
library("ggplot2")
ggplot(indpar) +
  geom_histogram(aes(x=price,y=..density..),
                 fill = "grey", color = "black",bins=20)+geom_density(aes(x=price,y=..density..))
ggplot(indpar) +
  geom_histogram(aes(x=asc,y=..density..),
                 fill = "grey", color = "black",bins=18)+geom_density(aes(x=asc,y=..density..))
plot(rpar(mixlogit, 'price'))
plot(rpar(mixlogit, 'asc'))
