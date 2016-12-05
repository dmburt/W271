drop table HRR_IP_Charge_All_Hosps_FY2013;
select 
       ip.[HRR],
	   ip.[DRG],
	   sum(ip.[N_FY2013_DISCHARGES]) as [HRR_FY2013_DISCHARGES_INCLUDING_HOSP],
	   sum(ip.[N_FY2013_DISCHARGES] * ip.[FY2013_AVG_CHG])          / sum(ip.[N_FY2013_DISCHARGES]) as [HRR_FY2013_AVG_CHG_INCLUDING_HOSP],
	   sum(ip.[N_FY2013_DISCHARGES] * ip.[FY2013_ADJUSTED_AVG_CHG]) / sum(ip.[N_FY2013_DISCHARGES]) as [HRR_FY2013_ADJUSTED_AVG_CHG_INCLUDING_HOSP],
	   count(distinct [PRVDR_NUM]) as N_HOSPS_IN_HRR

INTO HRR_IP_Charge_All_Hosps_FY2013

from dbo.w271_IP_CHARGE ip

group by ip.[HRR],
	     ip.[DRG]

having sum(ip.[N_FY2013_DISCHARGES]) > 0