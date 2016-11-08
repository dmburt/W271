# W271 Final Project


## Data Sets


###Inpatient Charge Data by Hospital and DRG, 2011-2014
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
* Hospital Referral Region
* Diagnosis-Related Group
* Year (of date discharged)
* Number of inpatient discharges
* Average charge per discharge (stay)
* Average Medicare payment per discharge (stay)


###Inpatient Charge Data by Hospital Referral Region, 2011-2014
_Source: summarization of data found in the_ Inpatient Charge Data by Hospital and DRG _dataset (see above)._
__Stats:__
* 144,342 rows
* 306 hospital referral regions (local markets)
* 565 services
* 27,453,280 discharges (avg. 6,863,320 per year)

__Primary elements:__
* Hospital Referral Region
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

__Primary elements__
* State
* Hospital referral region
* Number of Medicare beneficiaries (Part A and Part B)


###Provider of Services, 2010-2014
_Source: Centers for Medicare & Medicaid Services (CMS)_
https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/Provider-of-Services/index.html
Note: including 2010 POS file to allow for leading indicators. Hospitals may be responding to market conditions in the prior year to set charges for the current year.

__Stats:__
* 28,573 rows (avg. 7,143 per year)

__Primary elements__
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

* Created repository
* Uploaded original and combined data sets.

06 Nov 2016:

* Uploaded HRR charges file (summary of IP charges by hospital referral region).

07 Nov 2016:

* Updated DRG descriptions for DRG 065 for:
    - 2013 IP Charge data set
    - 2014 IP Charge data set
    - HRR Summary IP Charge data set  
&nbsp;&nbsp;The DRG descriptions were inconsistent across years (2011-2012 had one description, and 2013-2014 had a different description).  In the updated data sets, this has been fixed to make all descriptions for DRG 065 consistent: "065 - INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W CC."
