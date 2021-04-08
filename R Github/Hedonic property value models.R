##########Imisi Raphael Aiyetan ##########
####### Hedonic Property Value#######
######Question 1###########
library(mlogit)
library(readxl)
# load data 
wake_exercise <- read_excel("wake_exercise.xlsx")
price=wake_exercise$price
lakedist=wake_exercise$lakedist
# Column 1 of Table 1
Fit=glm(lprice~ living_area + baths+ age+ fireplace
        + garage_area+condA+condB+condC,data = wake_exercise)
summary(Fit)
# Column 2 of Table 1
Fit1=glm(lprice~ living_area + baths+ age+ fireplace
         + garage_area+condA+condB+condC+lakedist,data = wake_exercise)
summary(Fit1)
# Column 3 of Table 1
Fit2=glm(lprice~ living_area + baths+ age+ fireplace
         + garage_area+condA+condB+condC+lnlakedist,data = wake_exercise)
summary(Fit2)
# Column 4 of Table 1
Fit3=glm(lprice~ living_area + baths+ age+ fireplace
         + garage_area+condA+condB+condC+lakedist+median_commute,data = wake_exercise)
summary(Fit3)
# marginal implicit price
mean((price)*(summary(Fit)$coefficients[2]))
#########Question 2#########
# Column 1 of Table 2 
Fit4=glm(lprice~ living_area + baths+ age+ fireplace + garage_area+condA+condB+condC+median_commute+
           zone1+ zone2+ zone3+ zone4+ zone5+ zone6+ zone7+ zone8+ zone9+ zone10
         +zone11+ zone12+ zone13+ zone14+ zone15+ zone16+ zone17+ zone18+lakedist,data = wake_exercise)
summary(Fit4)
# Transformation
tr_dist=pmax((1-(lakedist/10)^0.5),0)
# Column 2 of Table 2
Fit5=glm(lprice~ living_area + baths+ age+ fireplace + garage_area+condA+condB+condC+median_commute+
           zone1+ zone2+ zone3+ zone4+ zone5+ zone6+ zone7+ zone8+ zone9+ zone10
         +zone11+ zone12+ zone13+ zone14+ zone15+ zone16+ zone17+ zone18+tr_dist,data = wake_exercise)
summary(Fit5)
# Implicit price for 18.2a -18.2c
mean((price)*-(summary(Fit1)$coefficients[10]))
mean((price)*-(summary(Fit2)$coefficients[10]))
mean((price)*-(summary(Fit3)$coefficients[10]))
# 18.2d
df=(summary(Fit5)$coefficients[29]*0.5)*(10^-0.5)*(lakedist^-0.5)
df[!is.finite(df)]=0
mean(price*df)