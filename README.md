# Survival Analysis in R
## Key packages and functions
### Package: Survival
### Functions:

"survfit" - fits a simple survival model

"surv" - produces the KM estimates of the probability of survival over time

"survdiff" - compares the survival curves of 2 groups using the log rank test. It calculates the test statistic and p-value for comparing survival curves.

For example:
survdiff(Surv(fu_time, death) ~ gender, rho=0)

Call:
survdiff(formula = Surv(fu_time, death) ~ gender, rho = 0)

           N Observed Expected (O-E)^2/E (O-E)^2/V
gender=1 548      268      271    0.0365     0.082
gender=2 452      224      221    0.0448     0.082

 Chisq= 0.1  on 1 degrees of freedom, p= 0.8

