##########Imisi Raphael Aiyetan##################
#######Discrete choice and Travel Cost/recreation demand#######
library(stargazer)
library(mlogit)
####### Question 1######
## question b
ic=c(5.9948,7.8305,	7.1986,	9.0011,10.483,
     5.6844,6.1743,6.8718,7.1872,7.7554,
     6.5757,8.9216,7.8807,7.9952,10.831)
oc=c(1.6558,1.378,4.3906,4.0474,1.7147,
     1.1945,1.1168,3.6592,3.9514,1.7353,
     1.7615,1.4893,4.4099,2.8629,2.0387)
#Estimate Model 
Vij=-0.6231*ic-0.4580*oc
#Find the exponential
chc=exp(Vij)
#Slice and column bind
x_3=chc[c(1:5)]
x_14=chc[c(6:10)]
x_21=chc[c(11:15)]
prob=cbind(x_3/sum(x_3),x_14/sum(x_14),x_21/sum(x_21))
t(prob)
##question  c
j_5=c(10.483,7.7554, 10.831)
Redn=cbind((0.15*100*j_5)*1.36)
Redn
#####Question 2######


home_heating1 <- read_csv("home_heating1.csv")
# Estimate the conditional logit model for question a,b,c
logit3=mlogit(choice ~ ic+oc|-1, home_heating1)
summary(logit3)
logit4=mlogit(choice ~ ic+oc|1, home_heating1)
summary(logit4)
logit5=mlogit(choice ~ ic+oc+Inc_central|-1, home_heating1)
summary(logit5)
logit6=mlogit(choice ~ ic+oc+Inc_central|1, home_heating1)
summary(logit6)
#for question d and e
resulted=predict(logit6,newdata=home_heating1)
res1=resulted-(0.15*resulted)
#comparing the average probability 
summary(res1)
summary(resulted)
logit7=mlogit(choice ~ ic+oc+inc_central1|1, home_heating1)
summary(logit7)

#####Question 3#######
# import the data 
NC_beach <- read_excel("NC_beach.xls")
# list of variables from the data 
tr9=NC_beach$tr9
pr9=NC_beach$pr9
inc=NC_beach$inc
#Estimate the poission model
m1=glm(tr9 ~ pr9, family="poisson", data=NC_beach)
summary(m1)
m2<- glm(tr9 ~ pr9+inc, family="poisson", data=NC_beach)
summary(m2)
stargazer(m2, m1, title="Poisson Regressions for the number of trips",
          type = "html",digits.extra=9, align=TRUE)
#generating parameter for welfare calculation
Pr_para=summary(m1)$coefficients[2,1]
Intercept=summary(m1)$coefficients[1,1]
# value function 
V=exp(Intercept+Pr_para*pr9)
SV=mean(V)
EV=(SV/-(Pr_para))
EV
#welfare
Welf=(1/-(Pr_para))*V
swelf=mean(Welf)
swelf
median_swelf=median(swelf)
V1=exp(Intercept+Pr_para*(pr9+5))
newwelf=(1/-(Pr_para))*V1
snewwelf=mean(newwelf)
snewwelf
median_snewwelf=median(newwelf)
median_snewwelf
Welfare_mean=swelf-snewwelf
Welfare_mean
Welfareloss_median=median_swelf-median_snewwelf
Welfareloss_median

######Question 4######
#load data 
WI100 <- read_csv("WI100.csv")
#list variable for welfare analysis below 
tc_new=WI100$tc_new
walleye_imp=WI100$Walleye_imp
Walleye_im=WI100$Walleye_im
site=WI100$siteid
Ascn=WI100$ASCons
ACS=WI100$ASC
choice=WI100$choice_orig
tc=WI100$tc
walleye=WI100$walleye
salmon=WI100$salmon
panfish=WI100$panfish
ramp=WI100$ramp
restroom=WI100$restroom
boat=WI100$boat
kids=WI100$kids
ramp_boat=ramp*boat
restroom_kids=restroom*kids
#estimat condition logit model for question a,b,c,d,e
logit=mlogit(choice ~ tc+walleye+salmon+panfish|-1 ,WI100)
summary(logit)
logit1=mlogit(choice ~ tc+walleye+salmon+panfish+ramp+restroom+ramp_boat+restroom_kids|-1 ,WI100)
summary(logit1)
logit2=mlogit(choice~ tc+ramp_boat+restroom_kids+siteid|1, WI100)
summary(logit2)
ols=glm(Ascn~walleye+salmon+panfish+ramp+restroom)
summary(ols)
#parameters from logit for welfare analysis $ analysis of welfare

summary(logit)$coefficients
tc_para=summary(logit)$coefficients[1]
wall_para=summary(logit)$coefficients[2]
wtp_TW=wall_para/-(tc_para)
wtp_TW

tc_para1=summary(logit1)$coefficients[1]
wall_para1=summary(logit1)$coefficients[2]
wtp_TW1=wall_para1/-(tc_para1)
wtp_TW1

tc_para1=summary(logit1)$coefficients[1]
wall_para1=summary(logit1)$coefficients[2]
sa_para1=summary(logit1)$coefficients[3]
pan_para1=summary(logit1)$coefficients[4]
ra_para1=summary(logit1)$coefficients[5]
rab_para1=summary(logit1)$coefficients[6]
rk_para1=summary(logit1)$coefficients[7]

V1=exp(tc_para1*tc+wall_para1*Walleye_im+sa_para1*salmon+pan_para1*panfish+ra_para1*ramp+rab_para1*ramp_boat+rk_para1*restroom_kids)
mean(V1)
V2=exp(tc_para1*tc+wall_para1*walleye+sa_para1*salmon+pan_para1*panfish+ra_para1*ramp+rab_para1*ramp_boat+rk_para1*restroom_kids)
mean(V2)
EV1=-(1/tc_para1)*(log(V1)-log(V2))
mean(EV1)

V3=exp(tc_para1*tc_new+wall_para1*walleye+sa_para1*salmon+pan_para1*panfish+ra_para1*ramp+rab_para1*ramp_boat+rk_para1*restroom_kids)
mean(V3)
V4=exp(tc_para1*tc+wall_para1*walleye+sa_para1*salmon+pan_para1*panfish+ra_para1*ramp+rab_para1*ramp_boat+rk_para1*restroom_kids)
mean(V4)
EV3=(1/tc_para1)*(log(V3)-log(V4))
mean(EV3)





wtp_TW1=wall_para1/-(tc_para1)
wtp_TW1
V=exp(Intercept+Pr_para*pr9)


int_para2=summary(logit2)$coefficients[1:99]
tc_para2=summary(logit2)$coefficients[100]
rab_para2=summary(logit2)$coefficients[101]
rk_para2=summary(logit2)$coefficients[102]
V7=exp(int_para2+tc_para1*tc_new+rab_para2*ramp_boat+rk_para2*restroom_kids)
mean(V7)
V8=exp(int_para2+tc_para2*tc+rab_para2*ramp_boat+rk_para2*restroom_kids)
mean(V8)
EV4=(1/tc_para1)*(log(V7)-log(V8))
mean(EV4)




int_para3=summary(ols)$coefficients[1]
tc_para3=summary(ols)$coefficients[2]
wall_para3=summary(ols)$coefficients[3]
sa_para3=summary(ols)$coefficients[4]
pan_para3=summary(ols)$coefficients[5]
ra_para3=summary(ols)$coefficients[6]
V5=exp(int_para3+wall_para3*Walleye_im+sa_para3*salmon+pan_para3*panfish+ra_para3*ramp)
mean(V5)
V6=exp(int_para3+wall_para1*walleye+sa_para1*salmon+pan_para1*panfish+ra_para1*ramp)
mean(V6)
EV5=(1/tc_para1)*(log(V5)-log(V6))
mean(EV5)