# Set working directory
setwd("c:/Users/Steve/Documents/mids/w_271/project/W271/Data/R/")

# Read and examine data
d <- read.delim("W271_Lab3_Dataset_By_Hosp.txt")
str(d)
summary(d)

# Checking for missing values
sapply(d, function(x) sum(is.na(x))) 
# no missing values, except bed count, physicians and nurses
# only one entry for; should probably drop or combine N_LPN_LVN_NURSES

# Examining outcome variable, difference in charges 2012-2013
summary(d$DIFF_AVG_CHG)
hist(d$DIFF_AVG_CHG) # most around 0; couple HUGE outliers (pos and neg)

# OR: outcome variable is just charges in 2013? why is it the difference, again?
summary(d$FY2013_AVG_CHG)
hist(d$FY2013_AVG_CHG) # skewed right, HUGE outlier to the right, not normal
hist(log10(d$FY2013_AVG_CHG)) # log looks much more normal (ln ok too)

# Investigating N_HOSPS_HRR
# Number of other hospitals in HRR is a proxy for competition
summary(d$N_HOSPS_IN_HRR)
hist(d$N_HOSPS_IN_HRR) # definitely not normal; looks like rounded bins

# Checking out bed count
summary(d$BED_CNT) # no weird values
hist(d$BED_CNT) # skewed right; large outliers (2,500 beds!)
table(d$BED_CNT <= 10 ) # 30 hospitals have 10 beds or fewer

# Checking out discharges
summary(d$N_FY2013_DISCHARGES) # 0 ? kind of weird
table(d$N_FY2013_DISCHARGES == 0) # there are 62 hospitals with 0 discharges
hist(d$N_FY2013_DISCHARGES) # skewed right

# Checking out number of FTE
summary(d$N_FTE_TOTAL) # EMPTY RIGHT NOW; sum later (easier in SQL?)

# Bed count, number of FTE, and number of discharges are a proxy for hospital size
# Checking correlations to make sure we don't include autocorrelations in regression
cor.test(d$BED_CNT,d$N_FY2013_DISCHARGES, use="complete") # highly and significantly correlated

# Change of ownership could affect charges; checking out change of ownership variable
summary(d$CHANGE_OF_OWNERSHIP_IN_PERIOD) # 118 of 3255 (or ~ 3.6%) of hospitals changed ownership

# Checking out type of ownership
summary(d$TYPE_OF_OWNERSHIP) # Mostly private not for profit
plot(d$TYPE_OF_OWNERSHIP)

# Resident programs can change costs for hospitals; checking out resident physicians
summary(d$N_RESIDENT_PHYSICIANS) # 51 missing values
table(d$N_RESIDENT_PHYSICIANS == 0) # 618 hospitals have residents (~20%)

# Making a new variable; resident program, binary
d$RESIDENT_PROGRAM = 0 
d$RESIDENT_PROGRAM[d$N_RESIDENT_PHYSICIANS != 0] <- 1
table(d$RESIDENT_PROGRAM)
