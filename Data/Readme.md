# W271 Final Project

###What is Driving the Cost of Care? A Study of the Factors Influencing Increasing Hospital Inpatient Charges Over Time

__Medical costs in the United States are rising.__ Between 2011 and 2014, general inflation in the United States slowed from 3.2% to 1.6%, while hospital and related services slowed from 5.6% to 4.6% (U.S. Bureau of Labor Statistics, 2012, 2013, 2014). The increase in cost of medical care has long outpaced the increases in costs of all goods and services in the U.S., and at an estimated $3 trillion in national health expenditures (National Center for Health Statistics, 2016), this difference in inflation is significant. With an aging Baby Boomer population, Medicare spending has doubled as a proportion of total health care expenditure between 1970 and 2014, from 10.1% to 20.2%. In essence, medical cost inflation is higher than general inflation in a population getting increasingly older.

Hospitals seek to cover the expenses across the wide range of services they provide by adjusting what they charge for those services. They cannot charge different amounts to different people, regardless of who pays, whether the patient is covered by Medicaid, by Medicare, by a private insurer, or if the patient pays out of their own pocket. Of course, not every payor is expected to reimburse the hospital the same amount: Medicaid generally pays relatively little, while Medicare pays a bit more, and private payers generally pay even more, and all of these insurers pay less than what the hospital charges. These insurers pay according to different reimbursement methodologies, but these methodologies typically are sensitive to the charges in order to adequately cover unusually high-cost hospital stays (through “outlier” or “stoploss” payments). It could thus be advantageous to a hospital to increase charges to a level that could trigger some of these higher alternative outlier payments and increase revenue surplus. There are significant downsides to such an approach, however—those patients who must pay out-of-pocket are expected to pay the full charges, leading to a lessened quantity demanded for those services, and some insurers may similarly seek to divert patients to other nearby hospitals. All the while, a hospital’s own costs change over time: local wages and overhead costs are subject to market conditions, and new medical technologies are developed every year.  

Can we gain insight into the factors that motivate shifts in hospital charges? Do these factors move in ways that explain an overall charge increase that surpasses general cost inflation? We seek to explore this question using several publicly-available data sets that cover hospital service-level1 charges for the entire set of hospitals in the United States for Medicare inpatient stays between 2011 and 2014. Explanatory variables are available not only from that same data set (in the form of local-market competition charges and service demand), but also from complimentary data sets that describe resource availability and utilization within those same hospitals and their surrounding areas.

## Data Sets

###Inpatient Charge Data, 2011-2014
_Source: Centers for Medicare & Medicaid Services (CMS)_
https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/
__Stats:__
* 681,215 rows
* 3,446 hospitals
* 566 services
* 27,453,280 discharges (avg. 6,863,320 per year)
__Primary elements:__
* Hospital identifier, name
* Hospital location (address, city, state, ZIP)
* Diagnosis-Related Group
* Year (of date discharged)
* Number of inpatient discharges
* Average charge per discharge (stay)
* Average Medicare payment per discharge (stay)

###Medicare Fee-for-Service Enrollment, 2011-2014
_Source: Centers for Medicare & Medicaid Services (CMS)_
https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/CMSProgramStatistics/2013/Enrollment.html#Total (Fee-For-Service and Managed Care) Medicare Enrollment
__Stats:__
* 1,224 rows
Primary elements
* State
* Hospital referral region
* Number of Medicare beneficiaries (Part A and Part B)

###Provider of Services, 2010-2014
_Source: Centers for Medicare & Medicaid Services (CMS)_
https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/Provider-of-Services/index.html
Note: including 2010 POS file to allow for leading indicators. Hospitals may be responding to market conditions in the prior year to set charges for the current year.
__Stats:__
* 676,131 rows (avg. 135,226 per year)
Primary elements
* Number of times this provider has undergone a change of ownership
* Facility is eligible to participate in the Medicare and/or Medicaid programs (1/0).
* Number of affiliated providers
* Indicates if the hospital has any other affiliated resident program
* Number of beds in Medicare and/or Medicaid certified areas within a facility
* Total number of beds in a hospital, including those in non-participating or non-licensed areas
* Number of full-time equivalent other personnel employed by a provider
* Number of full-time equivalent physicians employed by a provider
* Number of full-time equivalent licensed practical or vocational nurses employed by a provider
* Number of full-time equivalent registered nurses employed by a provider
* Hospital location (city, state, ZIP, CBSA, urban/rural indicator)
* There are over 180 hospital-level data elements in this file. We will choose a reasonable explanatory subset of these (in addition to those above) prior to analysis.

## History
01 Nov 2016: 
1. Created repository
2. Loaded original and combined data sets.
             

