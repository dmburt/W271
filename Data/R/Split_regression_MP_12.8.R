# Regression analysis on datasets split over/under inflation, over/under HRR

# Guiding question: is the coefficient for market influence different in subgroups that 
# increased their adjusted charges by different amounts?

# Loading packages
library(ggplot2)
library(ivpack)
library(lmtest)
library(stargazer)


# 1. Building regression models for over/under inflation
# plotting
plot(inflation_over$FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, inflation_over$DIFF_14_13_ADJUSTED_AVG_CHG)
plot(inflation_under$FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, inflation_under$DIFF_14_13_ADJUSTED_AVG_CHG)

# defining the model
# for the hospitals that are over inflation, how do to relative HRR adjusted charges predict diff(2013-2014)
inf_over <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, data = inflation_over)
# for the hospitals that are under inflation, how do to relative HRR adjusted charges predict diff(2013-2014)
inf_under <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, data = inflation_under)

# examining model
summary(inf_over) # positive significant coef
summary(inf_under) # negative sinificant coef 

# checking model assumptions
bptest(inf_over) # non significant, fail to reject null of homoskedasticity
bptest(inf_under) # significant, reject null of homoskedasticity
# Going to use robust standard errors for consistency 

# Plotting residuals
plot(inf_over$fitted, inf_over$residuals)
plot(inf_under$fitted, inf_under$residuals)

# Other diagnositc plots 
plot(inf_over) # residuals are not normal
plot(inf_under) # residuals are not normal here either

# Checking overall significance
waldtest(inf_over, vcov = vcovHC) # overall, significant
waldtest(inf_under, vcov = vcovHC) # also significant

# calculating and saving robust errors
se_inf_over <- robust.se(inf_over)[,2]
se_inf_under <- robust.se(inf_under)[,2]


# Adding covariates: beneficiaries per provider, bed count per 1000 beneficiaries
# percent urban in the HRR
inf_over2 <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX + 
                  RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + 
                  CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+  
                  BENEFICIARIES_PER_PROVIDER + 
                  BED_CNT_PER_THOUSAND_BENEFICIARIES,
                  data = inflation_over)

inf_under2 <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX + 
                  RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + 
                  CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+  
                  BENEFICIARIES_PER_PROVIDER + 
                  BED_CNT_PER_THOUSAND_BENEFICIARIES,
                data = inflation_under)

# examining model
summary(inf_over2) # positive significant coef
summary(inf_under2) # negative sinificant coef 

# checking model assumptions
bptest(inf_over2) # significant, reject null of homoskedasticity
bptest(inf_under2) # significant, reject null of homoskedasticity
# Going to use robust standard errors  

# Plotting residuals
plot(inf_over2$fitted, inf_over$residuals)
plot(inf_under2$fitted, inf_under$residuals)

# Other diagnositc plots 
plot(inf_over2) # residuals are not normal
plot(inf_under2) # residuals are not normal here either

# Checking overall significance
waldtest(inf_over2, vcov = vcovHC) # overall, significant
waldtest(inf_under2, vcov = vcovHC) # also significant

# calculating and saving robust errors
se_inf_over2 <- robust.se(inf_over2)[,2]
se_inf_under2 <- robust.se(inf_under2)[,2]

# showing total results with stargazer
# Full, with covariates
labels3 = c("Avg relative charge (ex)", "Residency program, y", "Urban (vs rural)", "Change of ownership, y", "Number of providers","Beneficiaries per provider", "Bed count, per 1000 beneficiaries")
stargazer(inf_over, inf_over2, inf_under,inf_under2, se = list(se_inf_over, se_inf_over2, se_inf_under, se_inf_under2), 
          covariate.labels=labels3,
          dep.var.labels = "Difference in charges, 2013-2014" , type ="text", df= F)
# Models 1 and 2 are for hospitals who increased their charges above inflation; 3 and 4 are charge changes below inflation



# 2. Building regression models for over/under HRR competitors (excluding)
# plotting
plot(hrr_over$FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, hrr_over$DIFF_14_13_ADJUSTED_AVG_CHG)
plot(hrr_under$FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, hrr_under$DIFF_14_13_ADJUSTED_AVG_CHG)

# defining the model
# for the hospitals that are over inflation, how do to relative HRR adjusted charges predict diff(2013-2014)
reg_over <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, data = hrr_over)
# for the hospitals that are under inflation, how do to relative HRR adjusted charges predict diff(2013-2014)
reg_under <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX, data = hrr_under)

# examining model
summary(reg_over) # positive significant coef
summary(reg_under) # negative non-sinificant coef 

# checking model assumptions
bptest(reg_over) # significant, reject null of homoskedasticity
bptest(reg_under) # non significant, fail to reject null of homoskedasticity
# Going to use robust standard errors for consistency 

# Plotting residuals
plot(reg_over$fitted, reg_over$residuals)
plot(reg_under$fitted, reg_under$residuals)

# Other diagnositc plots 
plot(reg_over) # qq plot shows residuals are not normal
plot(reg_under) # qq plot shows residuals are not normal here either

# Checking overall significance
waldtest(reg_over, vcov = vcovHC) # overall, significant
waldtest(reg_under, vcov = vcovHC) # overall non significant

# calculating and saving robust errors
se_reg_over <- robust.se(reg_over)[,2]
se_reg_under <- robust.se(reg_under)[,2]


# Adding covariates: beneficiaries per provider, bed count per 1000 beneficiaries
# percent urban in the HRR
reg_over2 <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX + 
                  RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + 
                  CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+  
                  BENEFICIARIES_PER_PROVIDER + 
                  BED_CNT_PER_THOUSAND_BENEFICIARIES,
                data = inflation_over)

reg_under2 <- lm(DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX + 
                   RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + 
                   CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+  
                   BENEFICIARIES_PER_PROVIDER + 
                   BED_CNT_PER_THOUSAND_BENEFICIARIES,
                 data = hrr_under)

# examining model
summary(reg_over2) # positive significant coef
summary(reg_under2) # negative sinificant coef 

# checking model assumptions
bptest(reg_over2) # significant, reject null of homoskedasticity
bptest(reg_under2) # significant, reject null of homoskedasticity
# Going to use robust standard errors  

# Plotting residuals
plot(reg_over2$fitted, reg_over$residuals)
plot(reg_under2$fitted, reg_under$residuals)

# Other diagnositc plots 
plot(inf_over2) # residuals are not normal
plot(inf_under2) # residuals are not normal here either

# Checking overall significance
waldtest(reg_over2, vcov = vcovHC) # overall, significant
waldtest(reg_under2, vcov = vcovHC) # also significant after accounting for other factors

# calculating and saving robust errors
se_reg_over2 <- robust.se(reg_over2)[,2]
se_reg_under2 <- robust.se(reg_under2)[,2]

# showing total results with stargazer
# Full, with covariates
labels4 = c("Avg relative charge (ex)", "Residency program, y", "Urban (vs rural)", "Change of ownership, y", "Number of providers","Beneficiaries per provider", "Bed count, per 1000 beneficiaries")
stargazer(reg_over, reg_over2, reg_under,reg_under2, se = list(se_reg_over, se_reg_over2, se_reg_under, se_reg_under2), 
          covariate.labels=labels4,
          dep.var.labels = "Difference in charges, 2013-2014" , type ="text", df= F)
# Models 1 and 2 are for hospitals who increased their charges above their region; 3 and 4 are charge changes below their region
