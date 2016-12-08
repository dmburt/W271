# This script uploads the most recent data, cleans it, and creates all variables needed for analysis
# The output is a dataframe that will be used for the enirity of analysis

# loading data and saving to a dataframe
#setwd("~/Desktop/Cal/MIDS/271/271 final project/")
#d <- read.delim("W271_Lab3_Dataset_By_Hosp.txt")

setwd("c:/Users/Steve/Documents/mids/w_271/project/W271/Data/R/")
d <- read.delim("../../../W271_Lab3_Dataset_By_Hosp.txt")

# Excluding hospitals that have no charges in either 2013 or 2014 (or both)
d <- d[ which(d$FY2013_AVG_CHG!=0 & d$FY2014_AVG_CHG!=0), ]

# Excluding hospitals for which HRR averages are 0
d = d[d$HRR_FY2013_AVG_CHG_EXCLUDING_HOSP != 0,] # only exists in unadjusted averages

# Creating independent relative variables for regression
d$FY2013_AVG_CHG_RELATIVE_EX = 100*(d$FY2013_AVG_CHG/d$HRR_FY2013_AVG_CHG_EXCLUDING_HOSP) - 100
d$FY2013_AVG_CHG_RELATIVE_IN = 100*(d$FY2013_AVG_CHG/d$HRR_FY2013_AVG_CHG_INCLUDING_HOSP) - 100
d$FY2013_ADJUSTED_AVG_CHG_RELATIVE_EX = 100*(d$FY2013_ADJUSTED_AVG_CHG/d$HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP) - 100
d$FY2013_ADJUSTED_AVG_CHG_RELATIVE_IN = 100*(d$FY2013_ADJUSTED_AVG_CHG/d$HRR_FY2013_ADJUSTED_AVG_CHG_INCLUDING_HOSP) - 100

# Creating other explanatory variables of interest
d$N_PROVIDERS = d$N_NURSES + d$N_PHYSICIANS
d$BENEFICIARIES_PER_PROVIDER = d$PART_A_BENEFICIARIES/d$N_HOSPS_IN_HRR/1000
d$BED_CNT_PER_THOUSAND_BENEFICIARIES = d$BED_CNT/d$BENEFICIARIES_PER_PROVIDER

# Checking for missing values
sapply(d, function(x) sum(is.na(x))) # only missing values are in bed count; how do we want to deal with these?
d = d[complete.cases(d),]

# big outliers, remove?
#d = d[which(d$DIFF_14_13_ADJUSTED_AVG_CHG < 79000 & d$DIFF_14_13_ADJUSTED_AVG_CHG > -33000),]
