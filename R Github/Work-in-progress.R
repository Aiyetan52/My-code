######### Imisi Raphael Aiyetan ##############
###### Air Pollution and the determinants of outflow migration: Evidence from US 
## Counties####
library(readxl)
library(ggplot2)
library(foreign)
### Load data
Ecodata=read_excel("Econometrics Proposal 2.xlsx")
#Redefine variables 
inflow=Ecodata$Inflow
outflow=Ecodata$Outflow
PM=Ecodata$`Air Pollution`
Pop=Ecodata$Population
percapPI=Ecodata$`Per capital Personal Income`
AveJbcom=Ecodata$`Average Compensation`
Collg=Ecodata$college
Unemp=Ecodata$Unemployment
PDealth=Ecodata$`Premature Death`
#Exploratory Analysis
ggplot(Ecodata, aes(y=Outflow,x=Counties))+geom_boxplot()+coord_flip()
ggplot(Ecodata, aes(y=`Air Pollution`,x=Counties))+geom_boxplot()+coord_flip()
plot()
summary(Ecodata)
coplot(Outflow ~ Year|Counties, type="b", data=Ecodata)
plot(Ecodata)
#####Estimation without control variables#########
pool=plm(log(outflow)~PM,data=Ecodata, index=c("Counties", "Year"), model="pooling")
summary(pool)
#diagnostic tests
pbgtest(pool)
bptest(pool)
qqnorm(pool$res)
qqline(pool$res)
hist(pool$res)
######Estimation with control variables#######
pool1=plm(log(outflow)~PM+log(Collg)+log(Unemp)+log(PDealth)+log(percapPI)+log(AveJbcom)+log(Pop),data=Ecodata, index=c("Counties", "Year"), model="pooling")
summary(pool1)
#diagnostic tests
pbgtest(pool1)
bptest(pool1)
fit1=Anova(pool1, type=2)
fit1
qqnorm(pool1$res)
qqline(pool1$res)
hist(pool1$res)
#######Estimation with significance variables########
pool2=plm(log(outflow)~PM+log(percapPI)+log(AveJbcom)+log(Pop),data=Ecodata, index=c("Counties", "Year"), model="pooling")
summary(pool2)
#diagnostic tests
pbgtest(pool2)
bptest(pool2)
fit2=Anova(pool2, type=2)
fit2
qqnorm(pool2$res)
qqline(pool2$res)
hist(pool2$res)
library(stargazer)
stargazer(pool,pool1,pool2,title=" Regression of the effect of Air Pollution on Outflow Migration  ",
          type = "html",se = NULL,p = NULL, 
          intercept.top = FALSE, align=TRUE)
library(tseries)
Panel.set=pdata.frame(Ecodata, index=c("Counties", "Year")) 

adf.test(Panel.set$Outflow, k=2)
