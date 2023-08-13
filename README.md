# Survival Analysis in R: Analyses, Packages and Functions

## Kaplan-Meier Analysis
The KM analysis is the most basic of the analyses -- it estimates survival probabilities and generates a KM curve. To be useful, you must use the survival probabilities to compare survival between groups, visualize survival curves, and identify potential differences in survival patterns.

### Package: Survival
```
install.packages("survival")
install.packages("ggplot")
library(survival)
library(ggplot2)
```

### Functions:

### 1. "survfit"
**'survfit'** fits a simple survival model. This is the function used to create survival curves in R based on the Kaplan-Meier estimator. It estimates the KM survival curves for the given data. 

For example:

```
km_fit <- survfit(Surv(fu_time, death) ~ 1)
```

**'Surv(fu_time, death)'** defines the survival object for the analysis. The **'Surv'** function is used to specify the time-to-event data, where fu_time represents the follow-up time and death represents the event indicator (1 if an event occurred, 0 if censored). ~ 1 is the formula specification for the survival analysis. Tilde (~) separates the response variable **'(Surv(fu_time, death))'** from the explanatory variable. In this case, 1 indicates that there are no explanatory variables, meaning we are interested in estimating the overall survival curve without considering any specific grouping factors.

**'km_fit'** is the survfit object obtained from the KM analysis. Plotting **'km_fit'** will show show the survival curve:

```
plot(km_fit)
```

![kmfit](https://github.com/1Genevieve/Survival_Analysis/blob/master/kmfit2.JPG)

**'km_fit'** also contains the survival probabilities at different time points, and other relevant information such as the number at risk and the number of events at each time point. **'km-fit'** can be used to plot the survival curve or perform further analyses on the survival data. 

### 2. "surv" 
**'Surv'** produces the KM estimates of the probability of survival over time. For instance, we want to extract the survival probabilities from **'km_fit'** object generated by the **'survfit'** function. We use the **'summary'** function in R. 

```
km_summary <- summary(km_fit)
surv_prob <- km_summary$surv
```

The **'summary'** function is applied to the **'survfit'** object, **'km_fit'** to calculate summary statistics, including the survival probabilities at different time points. These are stored in **'km_summary'**. You can use the **'km_summary'** object to access and analyze the survival probabilities at different time points obtained from the KM analysis. The specific statistics include number at risk, number of events, survival probability and confidence intervals depending on the settings and options used in the survfit object and the summary function:

![kmsummary](https://github.com/1Genevieve/Survival_Analysis/blob/master/kmsummary.JPG)

By assigning **'km_summary$surv'** to the object **'surv_prob'**, you extract the survival probabilities as a vector:

![survprob](https://github.com/1Genevieve/Survival_Analysis/blob/master/survprob.JPG)



A further example:

```
summary(km_fit, times = c(1:7,30,60,90*(1:10))) 
```

By specifying the times argument, you can request summary statistics for the KM survival curve represented by **'km_fit'** at specific time points. In this case, the code requests summary statistics at time points 1, 2, 3, 4, 5, 6, 7, 30, 60, 90, 180, 270, 360, 450, 540, 630, 720, 810, 900:

![summary](https://github.com/1Genevieve/Survival_Analysis/blob/master/summary1.JPG)

## Log-Rank Test
Compared to the KM anaylysis, the log-rank test determines whether there is a significant difference in the survival curves or survival probabilities of groups. It is a non-parametric test.

### Function:
### "Survdiff" 
**'survdiff'** compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves. For example, the survival curves of two groups based on gender are compared: 

```
survdiff(Surv(fu_time, death) ~ gender, rho=0) 
```

![survdiff](https://github.com/1Genevieve/Survival_Analysis/blob/master/survdiff1.JPG)

THe chi-squared test statistic measures the discrepancy between the observed data and the expected data under the null hypothesis. In the context of survival analysis, the chi-squared statistic compares the observed survival data among different groups. It provides a measure of the discrepancy between the observed survival data and the expected survival data under the null hypothesis.

**Null hypothesis** - the chi-squared test starts with a null hypothesis, which assumes that there is no difference between the groups being compared. In the case of survdiff, it assumes that the survival curves of the groups are identical.

**Expected Data** - under the null hypothesis, the expected survival data is calculated based on the assumption of no difference between the groups. The expected data represents what would be observed if the null hypothesis is true.

**Observed Data** - actual data collected or obtained from the study.

**Interpretation** - the obtained chi-squared statistic is compared to a chi-squared distribution with a specific number of degrees of freedom. A higher chi-squared value indicates a larger difference between the groups, while a smaller value suggests a smaller difference or similarity. The degrees of freedom depend on the number of categories or groups being compared. The resulting p-value indicates the probability of obtaining a chi-squared statistic as extreme as the observed one, assuming the null hypothesis is true.

The chi-squared statistic of 0.1 with 1 degree of freedom and a p-value of 0.8 indicates that the observed differences in the data are likely due to chance or random variation. There is weak evidence to suggest a significant difference between the groups being compared based on the chi-squared test results.

Plot of KM curves:

```
km_gender_fit <- survfit(Surv(fu_time, death) ~ gender)
plot(km_gender_fit)
```

![km_gender](https://github.com/1Genevieve/Survival_Analysis/blob/master/kmfit_gender.JPG)

## Cox-Proportional Hazards Model


### Package: Survminer
```
install.packages("survminer")
library(survminer)
```
