# Survival Analysis in R
## Key packages and functions
### Package: Survival
### Functions:

###1. "survfit" - fits a simple survival model

###2. "surv" - produces the KM estimates of the probability of survival over time

###3. "survdiff" - compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves.

For example:

survdiff(Surv(fu_time, death) ~ gender, rho=0)

![survdiff](https://github.com/1Genevieve/Survival_Analysis/blob/master/survdiff1.JPG)
