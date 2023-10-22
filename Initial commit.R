print("This file was created within RStudio")
print("And now it lives on GitHub")
getwd()

g<-read.csv(file="C:/Users/admin/Desktop/2022 Project/Survival_Analysis/Simulated HF mort data for GMPH.csv")
#Number of rows and columns
dim(g)
head(g)
#Take rows 1 to 5 and all of the columns.
g[1:5,]

#Survival creates a number of useful R objects that can be further manipulated. A key one is “survfit”.
install.packages("survival")
install.packages("ggplot")
#This is the cornerstone command for survival analysis in R.
library(survival)
#Newer package that does nice plots
library(ggplot2)

####Turn each column of the data set, which we've called g, into a variable and tell R what kind of variable it is.
##Continuous variable (numeric)
#Length of hospital stay
table(los)
los <- g[,"los"]
#Age
table(age)
age <- g[,"age"]
#Prior appointments attended
table(g$prior_appts_attended)
pat <- g[,"prior_appts_attended"]
#Follow-up time
table(fu_time)
fu_time <- g[,"fu_time"]
#Number of prior missed appointments
table(prior_dnas)
tpd <- table(prior_dnas)
round(100*prop.table(tpd),digits=1)
pdnas <- g[,"prior_dnas"]


##Binary variable (numeric)
death <- g[,"death"]

##R calls categorical variables factors
gender <- as.factor(g[,"gender"])
cancer <- as.factor(g[,"cancer"])
cabg <- as.factor(g[,"cabg"])
table(crt)
crt <- as.factor(g[,"crt"])
table(defib)
defib <- as.factor(g[,"defib"])
table(g$dementia)
dementia <- as.factor(g[,"dementia"])
DM <- as.factor(g[,"diabetes"])
HPN <-as.factor(g[,"hypertension"])
ihd <-as.factor(g[,"ihd"])
dep <- as.factor(g[,"mental_health"])
afib <-as.factor(g[, "arrhythmias"])
copd <-as.factor(g[,"copd"])
table(g$obesity)
fat <-as.factor(g[,"obesity"])
table(g$pvd)
pvd <-as.factor(g[,"pvd"])
rd <-as.factor(g[,"renal_disease"])
vd <- as.factor(g[,"valvular_disease"])
table(g$metastatic_cancer)
CA <- as.factor(g[,"metastatic_cancer"])
pm <- as.factor(g[,"pacemaker"])
pne <- as.factor(g[,"pneumonia"])
table(g$pci)
pci <- as.factor(g[,"pci"])
table(g$stroke)
CVA <- as.factor(g[,"stroke"])
table(g$senile)
old <- as.factor(g[,"senile"])
table(g$quintile)
class <- as.factor(g[,"quintile"])
table(g$ethnicgroup)
ethgrp <- as.factor(g[,"ethnicgroup"])



###############################Descriptive Analysis###################################

###Missing values
##Count the total number of missing values in the entire data frame
sum(is.na(g))
##Find the column names with missing values
columns_with_missing <- colnames(g)[colSums(is.na(g)) > 0]
print(columns_with_missing)

##Count the total number of missing values in ethnic group
table(ethgrp)
table(ethgrp, exclude=NULL)
sum(is.na(g$ethnicgroup))
##Count the total number of missing values in quintile
sum(is.na(g$quintile))
table(class, exclude=NULL)


###Categorical/binary variables
table(death)
##Add total
table(gender)
tg <- table(gender)
addmargins(tg)
##Get %s rounded to 1dp
round(100*prop.table(tg),digits=1)
table(cancer)
table(cabg)
table(DM)
table(HPN)
table(ihd)
table(dep)
table(copd)
table(vd)
table(pm)


###Continuous variables
summary(los)
hist(los)

summary(age)
hist(age)

summary(fu_time)
hist(fu_time)

summary(pat)
hist(pat)

table(prior_dnas)
tpd <- table(prior_dnas)
addmargins(tpd)
round(100*prop.table(tpd),digits=1)

##################################Survival Analysis###################################

###Survfit() fits a simple survival model; there aren't any predictors, so the model just has the intercept, denoted by “1”. 
##The two arguments used by Surv are the follow-up time for each patient and whether they died.
#The survfit() function produces the KM estimates of the probability of survival over time.
km_fit <- survfit(Surv(fu_time, death) ~ 1)
km_fit
plot(km_fit)
#Label the axes
plot(km_fit, xlab = "time", ylab = "Survival probability")
km_summary <- summary(km_fit)
surv_prob <- km_summary$surv
surv_prob
summary(km_fit, times = c(1:7,30,60,90*(1:10))) 

##Split the curve by gender
km_gender_fit <- survfit(Surv(fu_time, death) ~ gender)
km_gender_fit
plot(km_gender_fit, xlab = "time", ylab = "Survival probability - Females & Males")


###Compare survival by gender using log rank test
survdiff(Surv(fu_time, death) ~ gender, rho=0)


##Compare survival by 65& above vs under 65
#Dichotomise age as 65& above and under 65
age_risk<-ifelse(g$age>=65, 1, 0)
#Inspect the numbers
table(age_risk)
table(age, age_risk, exclude = NULL)
survdiff(Surv(fu_time, death) ~ age_risk, rho=0)


###Cox proportional hazards regression modelling
install.packages("survminer")
install.packages("ggpubr")
library(survminer)

##Example 1: single continuous predictor
summary(age)
hist(age)
cox <- coxph(Surv(fu_time, death)~age)
summary(cox)
#Martingale test proportionality assumption
ap <- cox.zph(cox)
ap
plot(ap)
apfit <- coxph(Surv(fu_time, death) ~ age + tt(age))
summary(apfit)
#Deviance residuals
##The argument type = "dfbeta" plots the estimated changes in the regression coefficients on deleting each observation (patient) in turn
ggcoxdiagnostics(cox, type = "dfbeta", linear.predictions = FALSE, ggtheme = theme_bw()) 
##Visualize the deviance residuals, which are normalized transformations of the martingale residual and should be roughly symmetrically distributed about zero with a standard deviation of 1
ggcoxdiagnostics(cox, type = "deviance", linear.predictions = FALSE, ggtheme = theme_bw()) 
##Test if any continuous variable that you assume to have a linear relation with the outcome actually do have a linear relation
ggcoxfunctional(Surv(fu_time, death) ~ age + log(age) + sqrt(age), data = g)


##Example 2: one categorical predictor
##GENDER
gcox <- coxph(Surv(fu_time, death)~gender, data = g)
summary(gcox)
#Schoenfeld test for proportionality assumption
gp <- cox.zph(gcox)
print(gp)
plot(gp)
# "tt" is the time-transform function
fit <- coxph(Surv(fu_time, death) ~ gender + tt(gender))
summary(fit)

##ETHNIC GROUP
table(ethgrp, exclude=NULL)
ecox <- coxph(Surv(fu_time, death) ~ ethgrp, data = g)
summary(ecox)
#convert NA to 8
g$ethnicgroup <- ifelse(is.na(g$ethnicgroup), 8, g$ethnicgroup)
table(g$ethnicgroup)
ethgrp <- as.factor(g[,"ethnicgroup"])
table(ethgrp)
te <- table(ethgrp)
te
addmargins(te)
round(100*prop.table(te),digits=1)
#or add 8 as a factor
levels(ethnicgroup)<-c(levels(ethnicgroup),"8")
#change NA to 8
ethnicgroup[is.na(ethnicgroup)] <- "8"
#Schoenfeld test for proportionality assumption
ep <- cox.zph(ecox)
ep
plot(ep)

##COPD
table(copd)
cox_copd <- coxph(Surv(fu_time, death) ~ copd, data = g)
cox_copd
#Test the proportionality assumption
c <- cox.zph(cox_copd)
c
plot(c)


##Example 3: (multiple) predictors of mortality following an emergency admission for heart failure
summary(age)
hist(age)
#Gender: 1=male, 2=female
table(gender)
#Number of prior hospitalizations for heart failure
table(prior_dnas)
table(ethgrp, useNA = "ifany")
table(ethgrp, exclude=NULL)
table(copd)
mcox <- coxph(Surv(fu_time, death) ~ age + gender + copd + prior_dnas + ethgrp)
summary(mcox)
#Test proportionality assumption
p <- cox.zph(mcox)
p
plot(p)

##Example 4: non-convergence
table(class, exclude=NULL)
ccox <- coxph(Surv(fu_time, death) ~ age + gender + copd + class + ethgrp) 
summary(ccox)
##Analyse the non-convergence problem
#Row as counts
t <- table(class, death)
t
#Row as percentages
round(100*prop.table(t,1),digits=1)
#Fix the non-convergence problem 
#Change the reference category for quintile/class to make it 1 rather than 0
class <- relevel(class, ref = "1")
#Combine categories (combine class 0 with class 5)
quintile_5groups <- g[,"quintile"]
table(quintile_5groups)
quintile_5groups[quintile_5groups==0] <- 5
quintile_5groups <- factor(quintile_5groups)
qcox <- coxph(Surv(fu_time, death) ~ age + gender + copd + quintile_5groups + ethgrp)
summary(qcox)
#Drop the quintile 0 patients by setting their outcome variable to "NA"
quintile_5groups <- g[,'quintile'] 
#set the zeroes to missing 
quintile_5groups[quintile_5groups==0] <- NA
quintile_5groups <- factor(quintile_5groups)
table(quintile_5groups, exclude=NULL)
coox <- coxph(Surv(fu_time, death) ~ age + gender + copd + quintile_5groups + ethgrp)
summary(coox)
