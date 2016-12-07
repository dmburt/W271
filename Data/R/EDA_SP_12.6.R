# Set working directory
setwd("c:/Users/Steve/Documents/mids/w_271/project/W271/Data/R/")


#Steve starts exploring
#-----------------------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(tidyr)
library(maps)
names(d)

#Number of providers in HRR
hist((d %>% count(HRR))$n, breaks = 30, main = "Number of Providers by HRR")
summary((d %>% count(HRR))$n)


#Group by HRRs
HRR = d %>% group_by(HRR) %>% 
  summarise(FY2013_ADJUSTED_AVG_CHG = mean(FY2013_ADJUSTED_AVG_CHG, na.rm = T),
                                           FY2014_ADJUSTED_AVG_CHG = mean(FY2014_ADJUSTED_AVG_CHG, na.rm = T))

#Distribution of HRR charges. Has positive skew.
hist(HRR$FY2013_ADJUSTED_AVG_CHG, breaks = 30)


#Map HRRs
all_cities = us.cities %>% 
  unite(HRR, c(country.etc, name), sep = " - ", remove = F) %>%
  separate(HRR, into = c("HRR", "State"), sep = -4) %>%
  select(-State) %>% rename(lon = long)
HRR = HRR %>% left_join(all_cities, by = "HRR")
usa = map_data("state") %>% 
  select(lon = long, lat, group, id = subregion)
ggplot(HRR %>% filter(country.etc != 'AK' , country.etc != "HI"), aes(lon, lat)) + 
  geom_polygon(aes(group = group), usa, fill = NA, colour = "grey50") +
  geom_point(aes(colour = FY2013_ADJUSTED_AVG_CHG)) + 
  coord_quickmap() + 
  labs(colour = "Adjusted\nAverage\nCharge\n2013", y = NULL, x = NULL) +
  ggtitle('Adjusted Average Charge by Hospital Referral Region (Dollars)') +
  scale_x_continuous(breaks = NULL, labels = NULL) +
  scale_y_continuous(breaks = NULL, labels = NULL) +
  scale_colour_gradient(low = "blue",high = "red")

#Change in charges by HRR between 2013 and 14
HRR = HRR %>% 
  mutate(DIFF_14_13_ADJUSTED_AVG_CHG = (FY2014_ADJUSTED_AVG_CHG - FY2013_ADJUSTED_AVG_CHG)/FY2013_ADJUSTED_AVG_CHG * 100)
hist(HRR$DIFF_14_13_ADJUSTED_AVG_CHG, breaks = 30)

#plot change in charge from 2013-14 by HRR
ggplot(HRR %>% filter(country.etc != 'AK' , country.etc != "HI"), aes(lon, lat)) + 
  geom_polygon(aes(group = group), usa, fill = NA, colour = "grey50") +
  geom_point(aes(colour = DIFF_14_13_ADJUSTED_AVG_CHG)) + 
  coord_quickmap() + 
  labs(colour = "Percent Change\nin Adjusted\nAverage\nCharge\n2013 to 2014", y = NULL, x = NULL) +
  ggtitle('Adjusted Average Charge by Hospital Referral Region (Dollars)') +
  scale_x_continuous(breaks = NULL, labels = NULL) +
  scale_y_continuous(breaks = NULL, labels = NULL) +
  scale_colour_gradient(low = "blue",high = "red")

#Relationship between provider charges relative to HRR in 2013
#some 0 values. recode as NA
summary(d$FY2013_ADJUSTED_AVG_CHG)
summary(d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP)

d$FY2013_ADJUSTED_AVG_CHG = ifelse(d$FY2013_ADJUSTED_AVG_CHG == 0, NA, d$FY2013_ADJUSTED_AVG_CHG)
d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP = ifelse(d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP == 0, 
                                             NA, d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP)

#as expected in a healthy market, positive correlation between provider and HRR Charges
ggplot(d, aes(d$FY2013_ADJUSTED_AVG_CHG, HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP)) + geom_point(aes(colour = URBAN_RURAL_IND))

#create ratio variable of provider and HRR charges
#look at bivariate relationship with change in charges 2013-14
#2013 as predictor
d$HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP = ifelse(d$HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP == 0, 
                                                      NA, d$HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP)
d$FY2013_ADJUSTED_AVG_CHG_RELATIVE = d$FY2013_ADJUSTED_AVG_CHG/d$HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP
hist(d$FY2013_ADJUSTED_AVG_CHG_RELATIVE, breaks = 30) #slight positive skew, #most in the ballpark though
summary(d$FY2013_ADJUSTED_AVG_CHG_RELATIVE)
hist(d$DIFF_14_13_ADJUSTED_AVG_CHG, breaks = 100)

ggplot(d, aes(FY2013_ADJUSTED_AVG_CHG_RELATIVE, DIFF_14_13_ADJUSTED_AVG_CHG)) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(x = "Adjusted Charge Relative to HRR, 2013 ($)", y = "Difference in Adusted Charges 2013-14 ($)") +
  ggtitle("Change in Provider Charges 2013-14 ~ Proportion of Provider:HRR 2013 Charge")

summary(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2013_ADJUSTED_AVG_CHG_RELATIVE))

#do the same, but use 2012 charges as predictor
d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP = ifelse(d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP == 0, 
                                                      NA, d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP)
d$FY2012_ADJUSTED_AVG_CHG = ifelse(d$FY2012_ADJUSTED_AVG_CHG == 0, NA, d$FY2012_ADJUSTED_AVG_CHG)
d$FY2012_ADJUSTED_AVG_CHG_RELATIVE = d$FY2012_ADJUSTED_AVG_CHG/d$HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP
hist(d$FY2012_ADJUSTED_AVG_CHG_RELATIVE, breaks = 30) #slight positive skew, #most in the ballpark though
summary(d$FY2012_ADJUSTED_AVG_CHG_RELATIVE)
hist(d$DIFF_14_13_ADJUSTED_AVG_CHG, breaks = 100)

ggplot(d, aes(FY2012_ADJUSTED_AVG_CHG_RELATIVE, DIFF_14_13_ADJUSTED_AVG_CHG)) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(x = "Adjusted Charge Relative to HRR, 2012 ($)", y = "Difference in Adusted Charges 2013-14 ($)") +
  ggtitle("Change in Provider Charges 2013-14 ~ Proportion of Provider:HRR 2012 Charge")

summary(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG ~ FY2012_ADJUSTED_AVG_CHG_RELATIVE))

#try with percent difference as dependent variable
d$DIFF_14_13_ADJUSTED_AVG_CHG_PCT = d$DIFF_14_13_AVG_CHG/d$FY2013_ADJUSTED_AVG_CHG

ggplot(d, aes(FY2012_ADJUSTED_AVG_CHG_RELATIVE, DIFF_14_13_ADJUSTED_AVG_CHG_PCT)) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(x = "Adjusted Charge Relative to HRR, 2012 ($)", y = "Difference in Adusted Charges 2013-14 (Percent)") +
  ggtitle("Change in Provider Charges 2013-14 ~ Proportion of Provider:HRR 2012 Charge")

summary(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG_PCT ~ FY2012_ADJUSTED_AVG_CHG_RELATIVE))
plot(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG_PCT ~ FY2012_ADJUSTED_AVG_CHG_RELATIVE)) #heteroskedasticity problem

#Try predictor as binary - above or below HRR mean charges
d$FY2012_ADJUSTED_AVG_CHG_RELATIVE_BINARY = ifelse(d$FY2012_ADJUSTED_AVG_CHG_RELATIVE > 1,
                                                   "Above HRR Mean", "Below HRR Mean")
d %>% group_by(FY2012_ADJUSTED_AVG_CHG_RELATIVE_BINARY) %>% 
  summarise(AVG = mean(DIFF_14_13_ADJUSTED_AVG_CHG_PCT, na.rm = T))
summary(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG_PCT ~ FY2012_ADJUSTED_AVG_CHG_RELATIVE_BINARY))
plot(lm(data = d, DIFF_14_13_ADJUSTED_AVG_CHG_PCT ~ FY2012_ADJUSTED_AVG_CHG_RELATIVE_BINARY))


