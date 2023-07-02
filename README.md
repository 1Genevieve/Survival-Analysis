# Survival Analysis in R
## Key packages and functions
### Package: Survival
### Functions:

"survfit" - fits a simple survival model

"surv" - produces the KM estimates of the probability of survival over time

"survdiff" - compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves.

For example:

survdiff(Surv(fu_time, death) ~ gender, rho=0)


