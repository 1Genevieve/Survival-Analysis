print("This file was created within RStudio")
print("And now it lives on GitHub")
getwd()

g<-read.csv(file="C:/Users/admin/Desktop/2022 Project/Survival_Analysis/Simulated HF mort data for GMPH.csv")
#Number of rows and columns
dim(g)
head(g)
#Take rows 1 to 5 and all of the columns.
g[1:5,]

#“Survival” creates a number of useful R objects that can be further manipulated. A key one is “survfit”.
install.packages("survival")
install.packages("ggplot")
#This is the cornerstone command for survival analysis in R.
library(survival)
#Newer package that does nice plots
library(ggplot2)

#Turn each column of the data set, which we’ve called “g”, into a variable and tell R what kind of variable it is.
##R calls categorical variables factors
gender <- as.factor(g[,"gender"])
cancer <- as.factor(g[,"cancer"])
cabg <- as.factor(g[,"cabg"])
ihd <-as.factor(g[,"ihd"])
DM <- as.factor(g[,"diabetes"])
HPN <-as.factor(g[,"hypertension"])
copd <-as.factor(g[,"copd"])
dep <- as.factor(g[,"mental_health"])
vd <- as.factor(g[,"valvular_disease"])
pm <- as.factor(g[,"pacemaker"])
ethgrp <- as.factor(g[,"ethnicgroup"])

##Continuous variable (numeric)
fu_time <- g[,"fu_time"]
age <- g[,"age"]
pat <- g[,"prior_appts_attended"]
los <- g[,"los"]

##Binary variable (numeric)
death <- g[,"death"]


##########Descriptive Analysis##########
#categorical/binary variables
table(death)
table(gender)
table(cancer)
table(cabg)
table(DM)
table(HPN)
table(ihd)
table(dep)
table(copd)
table(vd)
table(pm)
table(ethgrp)


#continuous variables
summary(los)
hist(los)
summary(age)
hist(age)
summary(fu_time)
hist(fu_time)
summary(pat)
hist(pat)


##########Linear Regression##########


##########Logistic Regression##########


##########Survival Analysis##########

#Survfit” fits a simple survival model; there aren’t any predictors, so the model just has the intercept, denoted by “1”. 
##The two arguments used by “Surv” are the follow-up time for each patient and whether they died.
##The survfit() function produces the KM estimates of the probability of survival over time.
km_fit <- survfit(Surv(fu_time, death) ~ 1)
km_fit
plot(km_fit)
summary(km_fit, times = c(1:7,30,60,90*(1:10))) 
plot(km_gender_fit)

##Split the curve by gender
km_gender_fit <- survfit(Surv(fu_time, death) ~ gender)
km_gender_fit
plot(km_gender_fit)

##Compare survival by gender using log rank test
survdiff(Surv(fu_time, death) ~ gender, rho=0)

##Compare survival by 65& above vs under 65
###Dichotomise age
