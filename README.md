# Survival Analysis in R
## Key packages and functions
### Package: Survival
### Functions:

### 1. "survfit"
Fits a simple survival model. This is the function used to create survival curves in R based on the Kaplan-Meier estimator. It estimates the Kaplan-Meier survival curves for the given data. 

For example:

km_fit <- survfit(Surv(fu_time, death) ~ 1)

Surv(fu_time, death): This part defines the survival object for the analysis. The Surv function is used to specify the time-to-event data, where fu_time represents the follow-up time and death represents the event indicator (1 if an event occurred, 0 if censored). ~ 1: This is the formula specification for the survival analysis. The tilde (~) is used to separate the response variable (Surv(fu_time, death)) from the explanatory variable. In this case, 1 indicates that there are no explanatory variables, meaning you are interested in estimating the overall survival curve without considering any specific grouping factors.

Plotting kmfit will show show the survival curve:

![kmfit](https://github.com/1Genevieve/Survival_Analysis/blob/master/kmfit1.JPG)

### 2. "surv" 
Produces the KM estimates of the probability of survival over time

### 3. "survdiff" 
Compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves.

For example:

The survival curves of two groups based on gender are compared. 

survdiff(Surv(fu_time, death) ~ gender, rho=0)



![survdiff](https://github.com/1Genevieve/Survival_Analysis/blob/master/survdiff1.JPG)

The chi-squared statistic of 0.1 with 1 degree of freedom and a p-value of 0.8 indicates that the observed differences in the data are likely due to chance or random variation. There is weak evidence to suggest a significant difference between the groups being compared based on the chi-squared test results.
