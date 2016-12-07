
# GOAL: see how much of the increase in a hospital's charges from 2013 to 2014 is related
# to the average charges for hospitals in the same region in 2013

# Run these regressions, visualize with stargazer
# Outcome: diff 2013-2014
# Four different types of main predictors:
# 1) (fy2013/HRR_FY2013_AVG_CHG_EXCLUDING_HOSP)*100 - 100 # unadjusted, excluding 
# - tells you how far above/below their COMPETITORS this hospital was, unadjusted for type of hospital
# 2) (fy2013/HRR_FY2013_AVG_CHG_INCLUDING_HOSP)*100 - 100 # unadjusted, including
# - tells you how far above/below their WHOLE REGION this hospital was, unadjusted for type of hospital

# Dividing by charges of other hospitals, multiplying by 100 and then subtracting 100 gives the percentage points that the hospital was ALREADY above/below the other hosptials
# Says: for each percentage point difference between hospitals and competitors/region in 2013, charges changed by (coef) in 2014


# -------------------------------------------------------------------

# Set working directory
setwd("~/Desktop/Cal/MIDS/271/271 final project/")
library(ggplot2)
library(ivpack)
library(lmtest)
library(stargazer)

# Read data
d <- read.delim("W271_Lab3_Dataset_By_Hosp.txt")
features <- colnames(d)

# Plotting charges: FY2014 , FY2013 
plot(d$FY2014_AVG_CHG, d$FY2013_AVG_CHG) # seem to be about the same year to year
hist(d$DIFF_14_13_AVG_CHG) # difference is centered around 0, with more hospitals increasing charges from 2013 to 2014 than decreasing

# A few hospitals have 0 values for 2013 and/or 2014 (seen in scatterplot)
table(d$FY2013_AVG_CHG==0 ) # 95 0's for 2013
table(d$FY2014_AVG_CHG==0 ) # 120 0's for 2014
d <- d[ which(d$FY2013_AVG_CHG!=0 & d$FY2014_AVG_CHG!=0), ] # subset data to exclude these hospitals
plot(d$FY2014_AVG_CHG, d$FY2013_AVG_CHG) # plot looks good now

# Check for missing values in new data frame
sapply(d, function(x) sum(is.na(x))) # 45 hospitals are missing bed count

# Building regression models

# 1. Diff(2013,2014) unadjusted ~ HRR average unadjusted, excluding hospital
# Creating a new variable to hold the predictor; percent difference between hospital charges and the unadjusted average for competitors in 2013
table(d$HRR_FY2013_AVG_CHG_EXCLUDING_HOSP == 0) # first notice: denominator has 5 nonzero values. This won't do
d = d[d$HRR_FY2013_AVG_CHG_EXCLUDING_HOSP != 0,] # remove hospitals where HRR averages are 0 in 2013

d$FY2013_AVG_CHG_RELATIVE_EX = 100*(d$FY2013_AVG_CHG/d$HRR_FY2013_AVG_CHG_EXCLUDING_HOSP) - 100
hist(d$FY2013_AVG_CHG_RELATIVE_EX, breaks = 15) # right skew, most hospitals charged less than the average of their competitors
summary(d$FY2013_AVG_CHG_RELATIVE_EX) # Max unadjusted charge is almost 3 times higher than competitors

# Plotting outcome vs predictor variable; looks like a positive sloping relationship
ggplot(d, aes(FY2013_AVG_CHG_RELATIVE_EX, DIFF_14_13_AVG_CHG)) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(x = "Unadjusted Charge Relative to Competitors, 2013 ($)", y = "Difference in Unadusted Charges 2013-14 ($)") +
  ggtitle("Change in Provider Charges 2013-14 ~ Proportion of Provider:HRR Competitors 2013 Charge")

# Running the regression
m1 <- lm(DIFF_14_13_AVG_CHG ~ FY2013_AVG_CHG_RELATIVE_EX, data = d)
summary(m1) # significant positive coefficient, ~27
# Inerpret: for every percentage point a hospital is above their competitors in 2013, they will charge $27 more in 2014

# Diagnostic tests

# Examining residuals
hist(m1$residuals, breaks = 30) # centered around 0, slightly more negative, tends to underpredict
plot(m1$residuals) # look pretty evenly spaced, no obvious patterns
plot(m1$fitted.values, m1$residuals, xlab = "Fitted values", ylab = "Residuals", main = "Residuals vs Fitted") # no real obvious patterns; a few residual outliers are pretty bad

# Diagnostic plots
plot(m1) # QQ plot shows residuals skewed at the ends

# Formally checking for heteroskedasticity (Breusch-Pagan test)
bptest(m1) # Significant; reject null hypothesis of normally distributed errors. Use heterskedastic robust errors from now on. 

# Running coefficient test 
coeftest(m1, vcov = vcovHC) # calculates coefficient disngificantce with het. rob. se; still significant
se_m1 <- robust.se(m1) # calculates and stores heteroskedastic robust standard errors for stargazer

# Formally test overall significance of the model (Wald Test) with heteroskedastic robust errors
waldtest(m1, vcov = vcovHC)  # model is still signficant


# 2. Diff(2013,2014) unadjusted ~ HRR average unadjusted, including hospital
# Creating a new variable to hold the predictor; percent difference between hospital charges and the unadjusted average for competitors in 2013
table(d$HRR_FY2013_AVG_CHG_INCLUDING_HOSP == 0) # check; no zero values in the denominator

d$FY2013_AVG_CHG_RELATIVE_IN = 100*(d$FY2013_AVG_CHG/d$HRR_FY2013_AVG_CHG_INCLUDING_HOSP) - 100
hist(d$FY2013_AVG_CHG_RELATIVE_IN, breaks = 15) # right skew, most hospitals charged less than the average of their competitors
summary(d$FY2013_AVG_CHG_RELATIVE_IN) # Max unadjusted charge is 2.5 times higher than competitors

# Plotting outcome vs predictor variable; looks like a positive sloping relationship
ggplot(d, aes(FY2013_AVG_CHG_RELATIVE_IN, DIFF_14_13_AVG_CHG)) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(x = "Unadjusted Charge Relative to whole HRR, 2013 ($)", y = "Difference in Unadusted Charges 2013-14 ($)") +
  ggtitle("Change in Provider Charges 2013-14 ~ Proportion of Provider:Whole HRR 2013 Charge")

# Running the regression
m2 <- lm(DIFF_14_13_AVG_CHG ~ FY2013_AVG_CHG_RELATIVE_IN, data = d)
summary(m2) # significant positive coefficient, ~27
# Inerpret: for every percentage point a hospital is above the whole HRR in 2013, they will charge $30 on average more in 2014

# Diagnostic tests
# Examining residuals
hist(m2$residuals, breaks = 30) # centered around 0, slightly more negative, tends to underpredict
plot(m2$residuals) # look pretty evenly spaced, no obvious patterns
plot(m2$fitted.values, m2$residuals, xlab = "Fitted values", ylab = "Residuals", main = "Residuals vs Fitted") # no real obvious patterns; a few residual outliers are pretty bad

# Diagnostic plots
plot(m2) # QQ plot shows residuals skewed at the ends

# Formally checking for heteroskedasticity (Breusch-Pagan test)
bptest(m2) # Significant; reject null hypothesis of normally distributed errors. Use heterskedastic robust errors from now on. 

# Running coefficient test 
coeftest(m2, vcov = vcovHC) # calculates coefficient disngificantce with het. rob. se; still significant
se_m2 <- robust.se(m2) # calculates and stores heteroskedastic robust standard errors for stargazer

# Formally test overall significance of the model (Wald Test) with heteroskedastic robust errors
waldtest(m2, vcov = vcovHC)  # model is still signficant



# 3. Adding covariates to each of the models:
# residency program, urban/rural, whether there was a change in ownership, average number of potential patients (# medicare patients/number of providers) in HRR, the total number of doctors and nurses at the hospital, 
d$N_PROVIDERS <- d$N_NURSES + d$N_PHYSICIANS
d$BENEFICIARIES_PER_PROVIDER = d$PART_A_BENEFICIARIES/d$N_HOSPS_IN_HRR/1000
d$BED_CNT_PER_THOUSAND_BENEFICIARIES = d$BED_CNT/d$BENEFICIARIES_PER_PROVIDER
# Competitor model
m3 <- lm(DIFF_14_13_AVG_CHG ~ FY2013_AVG_CHG_RELATIVE_EX + RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+  BENEFICIARIES_PER_PROVIDER + BED_CNT_PER_THOUSAND_BENEFICIARIES, data = d)
# Whole HRR model
m4 <- lm(DIFF_14_13_AVG_CHG ~ FY2013_AVG_CHG_RELATIVE_IN + RESIDENCY_PROGRAM_IND + URBAN_RURAL_IND + CHANGE_OF_OWNERSHIP_IN_PERIOD + N_PROVIDERS+ BENEFICIARIES_PER_PROVIDER+ BED_CNT_PER_THOUSAND_BENEFICIARIES, data = d)

summary(m3) 
summary(m4)

bptest(m3) # reject; use heteroskedastic errors
bptest(m4) # reject; use heteroskedastic errors

waldtest(m3, vcov = vcovHC) # overall, significant
waldtest(m4, vcov = vcovHC) # also signficant

se_m3 <- robust.se(m3)[,2]
se_m4 <- robust.se(m4)[,2]


# Looking at results with stargazer to compare easily across regressions

# Simple, no covariates
labels1 = c("Avg relative charge (ex)", "Avg relative charge (in)")
stargazer(m1, m2, se = list(se_m1, se_m2), 
          covariate.labels=labels1,
          dep.var.labels = "Difference in charges, 2013-2014" , out ="model.tex", df= F)

# Full, with covariates
labels2 = c("Avg relative charge (ex)", "Avg relative charge (in)", "Residency program, y", "Urban (vs rural)", "Change of ownership, y", "Number of providers","Beneficiaries per provider", "Bed count, per 1000 beneficiaries")
stargazer(m1, m2, m3, m4, se = list(se_m1, se_m2, se_m3, se_m4), 
          covariate.labels=labels2,
          dep.var.labels = "Difference in charges, 2013-2014" , out ="model.tex", df= F)


