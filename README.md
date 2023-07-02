# Survival Analysis in R
## Key packages and functions
### Package: Survival
### Functions:

### 1. "survfit" - fits a simple survival model

### 2. "surv" - produces the KM estimates of the probability of survival over time

### 3. "survdiff" - compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves.

For example:

survdiff(Surv(fu_time, death) ~ gender, rho=0)

![survdiff](https://github.com/1Genevieve/Survival_Analysis/blob/master/survdiff1.JPG)

The chi-squared statistic of 0.1 with 1 degree of freedom and a p-value of 0.8 indicates that the observed differences in the data are likely due to chance or random variation. There is weak evidence to suggest a significant difference between the groups being compared based on the chi-squared test results.
