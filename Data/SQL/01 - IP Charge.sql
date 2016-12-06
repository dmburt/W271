
drop table dbo.W271_IP_CHARGE;
select 
       c.[Provider Id] as [PRVDR_NUM],
       c.[Hospital Referral Region (HRR) Description] as [HRR],
	   left(c.[DRG Definition], 3) as [DRG],
	   d.[DRG_DESC],
	   d.[MDC],
	   d.[TYPE] as [MDC_TYPE],
	   sum(case when c.[Year] = 2012
	        then     c.[Total Discharges] 
			else     0
			end) as  [N_FY2012_DISCHARGES],
	   sum(case when c.[Year] = 2012
	        then     c.[Average Covered Charges]
			else     0
			end) as  [FY2012_AVG_CHG],
       sum(case when c.[Year] = 2012
	        then     c.[Average Covered Charges] / d.[RW]
			else     0
			end) as  [FY2012_ADJUSTED_AVG_CHG],
	   sum(case when c.[Year] = 2013
	        then     c.[Total Discharges] 
			else     0
			end) as  [N_FY2013_DISCHARGES],
	   sum(case when c.[Year] = 2013
	        then     c.[Average Covered Charges]
			else     0
			end) as  [FY2013_AVG_CHG],
	   sum(case when c.[Year] = 2013
	        then     c.[Average Covered Charges] / d.[RW]
			else     0
			end) as  [FY2013_ADJUSTED_AVG_CHG],
	   	   sum(case when c.[Year] = 2014
	        then     c.[Total Discharges] 
			else     0
			end) as  [N_FY2014_DISCHARGES],
	   sum(case when c.[Year] = 2014
	        then     c.[Average Covered Charges]
			else     0
			end) as  [FY2014_AVG_CHG],
	   sum(case when c.[Year] = 2014
	        then     c.[Average Covered Charges] / d.[RW]
			else     0
			end) as  [FY2014_ADJUSTED_AVG_CHG],
	   sum(0 * c.[Average Covered Charges]) as [DIFF_13_12_AVG_CHG],                    -- Placeholders for subsequent calculation in update
	   sum(0 * c.[Average Covered Charges]) as [DIFF_13_12_ADJUSTED_AVG_CHG],           -- Note these use existing fields to maintain float data type.
   	   sum(0 * c.[Average Covered Charges]) as [DIFF_14_13_AVG_CHG],                    -- Placeholders for subsequent calculation in update
	   sum(0 * c.[Average Covered Charges]) as [DIFF_14_13_ADJUSTED_AVG_CHG],           -- Note these use existing fields to maintain float data type.
	   sum(0) as [N_HOSPS_IN_HRR],
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_DISCHARGES_INCLUDING_HOSP],       -- Calculated average charges for HRR are calculated not
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_AVG_CHG_INCLUDING_HOSP],          --  only for unadjusted and DRG relative weight-adjusted
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_AVG_CHG_EXCLUDING_HOSP],          --  charges, but also have two versions: one with the given
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_DISCHARGES_EXCLUDING_HOSP],       --  hospital included, and one with the given hospital removed.
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_ADJUSTED_AVG_CHG_INCLUDING_HOSP], -- Discharges (including AND excluding) will be needed for
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP], --  hospital-level rollup.
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_DISCHARGES_INCLUDING_HOSP],
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_AVG_CHG_INCLUDING_HOSP],          -- ...Ditto for FY2013
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_AVG_CHG_EXCLUDING_HOSP],          
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_DISCHARGES_EXCLUDING_HOSP],
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_ADJUSTED_AVG_CHG_INCLUDING_HOSP], 
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP], 
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_DISCHARGES_INCLUDING_HOSP],
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_AVG_CHG_INCLUDING_HOSP],          -- ...Ditto for FY2014
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_AVG_CHG_EXCLUDING_HOSP],          
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_DISCHARGES_EXCLUDING_HOSP],
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_ADJUSTED_AVG_CHG_INCLUDING_HOSP], 
	   sum(0 * c.[Average Covered Charges]) as [HRR_FY2014_ADJUSTED_AVG_CHG_EXCLUDING_HOSP], 
	   pos.[BED_CNT],
	   case when pos.[chow_dt] is null then 'N'
	        when pos.[chow_dt] = '' then 'N'
			when pos.[chow_dt] < 20120101 THEN 'N'
			when pos.[chow_dt] > 20141231 THEN 'N'
			else 'Y'
			end as [CHANGE_OF_OWNERSHIP_IN_PERIOD],
	   case when pos.[GNRL_CNTL_TYPE_CD] = '01' THEN 'CHURCH'
	        when pos.[GNRL_CNTL_TYPE_CD] = '02' THEN 'PRIVATE NOT FOR PROFIT'
			when pos.[GNRL_CNTL_TYPE_CD] = '03' THEN 'OTHER'
			when pos.[GNRL_CNTL_TYPE_CD] = '04' THEN 'PRIVATE FOR PROFIT'
			when pos.[GNRL_CNTL_TYPE_CD] = '05' THEN 'FEDERAL'
			when pos.[GNRL_CNTL_TYPE_CD] = '06' THEN 'STATE'
			when pos.[GNRL_CNTL_TYPE_CD] = '07' THEN 'LOCAL'
			when pos.[GNRL_CNTL_TYPE_CD] = '08' THEN 'HOSPITAL DISTRICT OR AUTHORITY'
			when pos.[GNRL_CNTL_TYPE_CD] = '09' THEN 'PHYSICIAN OWNERSHIP'
			when pos.[GNRL_CNTL_TYPE_CD] = '10' THEN 'TRIBAL'
			else 'OTHER'
			end as [TYPE_OF_OWNERSHIP],
	   case when pos.[CBSA_URBN_RRL_IND] = 'R'
	        then 'R'
			else 'U'
			end as [URBAN_RURAL_IND],
	   
	   CASE WHEN (
	       CASE WHEN pos.[RSDNT_PGM_ALPTHC_SW] = 'Y' 
	            THEN 1
			    ELSE 0
			    END
		   + CASE WHEN pos.[RSDNT_PGM_DNTL_SW] = 'Y' 
	            THEN 1
			    ELSE 0
			    END
		   + CASE WHEN pos.[RSDNT_PGM_OSTPTHC_SW] = 'Y' 
	            THEN 1
			    ELSE 0
			    END
		   + CASE WHEN pos.[RSDNT_PGM_OTHR_SW] = 'Y' 
	            THEN 1
			    ELSE 0
			    END
		   + CASE WHEN pos.[RSDNT_PGM_PDTRC_SW] = 'Y' 
	            THEN 1
			    ELSE 0
			    END
		   ) > 0 THEN 'Y' ELSE 'N' END as [RESIDENCY_PROGRAM_IND],
	   case when isnumeric(pos.[PHYSN_CNT]) = 0
            then 0
            else cast(pos.[PHYSN_CNT] as float)
      	    end
       + case when isnumeric(pos.[RSDNT_PHYSN_CNT]) = 0
            then 0
	        else cast(pos.[RSDNT_PHYSN_CNT] as float)
	        end
       + case when isnumeric(pos.[PHYSN_OTHR_CNTRCT_CNT]) = 0
            then 0
	        else cast(pos.[PHYSN_OTHR_CNTRCT_CNT] as float)
	        end
       + case when isnumeric(pos.[PHYSN_OTHR_FLTM_CNT]) = 0
            then 0
	        else cast(pos.[PHYSN_OTHR_FLTM_CNT] as float)
	        end
       + case when isnumeric(pos.[PHYSN_OTHR_PRTM_CNT]) = 0
            then 0
	        else cast(pos.[PHYSN_OTHR_PRTM_CNT] as float)
	        end as [N_PHYSICIANS],

      case when isnumeric(pos.[RN_FLTM_CNT]) = 0
           then 0
	       else cast(pos.[RN_FLTM_CNT] as float)
	       end
      + case when isnumeric(pos.[RN_CNTRCT_CNT]) = 0
           then 0
      	   else cast(pos.[RN_CNTRCT_CNT] as float)
      	   end
      + case when isnumeric(pos.[RN_PRTM_CNT]) = 0
          then 0
      	  else cast(pos.[RN_PRTM_CNT] as float)
      	  end
      + case when isnumeric(pos.[LPN_LVN_FLTM_CNT]) = 0 
          then 0
      	  else cast(pos.[LPN_LVN_FLTM_CNT] as float)
      	  end
      + case when isnumeric(pos.[CRNA_CNT]) = 0
          then 0
      	  else cast(pos.[CRNA_CNT] as float)
      	  end
      + case when isnumeric(pos.[NRS_PRCTNR_CNT]) = 0
          then 0
      	  else cast(pos.[NRS_PRCTNR_CNT] as float)
      	  end as [N_NURSES],
	  e.PART_A_BENEFICIARIES

INTO W271_IP_CHARGE

from dbo.IP_Charge c

join dbo.DRG d
  on left(c.[DRG Definition], 3) = d.[DRG]
 and c.[Year] = d.[Year]

join [Provider_of_Services_File_-_OTHER_-_December_2014] pos
  on c.[Provider Id] = pos.[PRVDR_NUM]

join dbo.Medicare_Enrollment_By_HRR e
  on c.[Hospital Referral Region (HRR) Description] = e.HRR_NAME

where c.[Year] between 2012 and 2014
  and c.[Provider Id] <> '000000'
  --and c.[Provider Id] = '010001'
  and pos.prvdr_ctgry_cd = '01'
  and e.[YEAR] = 2014

--  and c.[Provider Id] = '010001'
--  and left(c.[DRG Definition], 3) in ('039','057')
  --and pos.[YEAR] = 2014

group by c.[Provider Id],
         c.[Hospital Referral Region (HRR) Description],
	     left(c.[DRG Definition], 3),
		 d.[DRG_DESC],
	     d.[MDC],
		 d.[TYPE],
		 pos.[BED_CNT],
		 case when pos.[chow_dt] is null then 'N'
	        when pos.[chow_dt] = '' then 'N'
			when pos.[chow_dt] < 20120101 THEN 'N'
			when pos.[chow_dt] > 20141231 THEN 'N'
			else 'Y'
			end,
		 case when GNRL_CNTL_TYPE_CD = '01' THEN 'CHURCH'
	        when GNRL_CNTL_TYPE_CD = '02' THEN 'PRIVATE NOT FOR PROFIT'
			when GNRL_CNTL_TYPE_CD = '03' THEN 'OTHER'
			when GNRL_CNTL_TYPE_CD = '04' THEN 'PRIVATE FOR PROFIT'
			when GNRL_CNTL_TYPE_CD = '05' THEN 'FEDERAL'
			when GNRL_CNTL_TYPE_CD = '06' THEN 'STATE'
			when GNRL_CNTL_TYPE_CD = '07' THEN 'LOCAL'
			when GNRL_CNTL_TYPE_CD = '08' THEN 'HOSPITAL DISTRICT OR AUTHORITY'
			when GNRL_CNTL_TYPE_CD = '09' THEN 'PHYSICIAN OWNERSHIP'
			when GNRL_CNTL_TYPE_CD = '10' THEN 'TRIBAL'
			else 'OTHER'
			end,
		 case when pos.[CBSA_URBN_RRL_IND] = 'R'
	        then 'R'
			else 'U'
			end,
       pos.[RSDNT_PGM_ALPTHC_SW],
       pos.[RSDNT_PGM_DNTL_SW],
       pos.[RSDNT_PGM_OSTPTHC_SW],
       pos.[RSDNT_PGM_OTHR_SW],
       pos.[RSDNT_PGM_PDTRC_SW],
	   pos.[PHYSN_CNT],
	   pos.[RSDNT_PHYSN_CNT],
       pos.[PHYSN_OTHR_CNTRCT_CNT],
       pos.[PHYSN_OTHR_FLTM_CNT],
       pos.[PHYSN_OTHR_PRTM_CNT],
       pos.[RN_FLTM_CNT],
       pos.[RN_CNTRCT_CNT],
       pos.[RN_PRTM_CNT],
       pos.[LPN_LVN_FLTM_CNT],
       pos.[CRNA_CNT],
       pos.[NRS_PRCTNR_CNT],
	   e.PART_A_BENEFICIARIES

order by 3