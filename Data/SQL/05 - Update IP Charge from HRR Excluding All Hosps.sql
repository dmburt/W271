update ip

SET ip.[HRR_FY2012_DISCHARGES_EXCLUDING_HOSP]       = hrr.[HRR_FY2012_DISCHARGES_EXCLUDING_HOSP],
    ip.[HRR_FY2012_AVG_CHG_EXCLUDING_HOSP]          = hrr.[HRR_FY2012_AVG_CHG_EXCLUDING_HOSP],
    ip.[HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP] = hrr.[HRR_FY2012_ADJUSTED_AVG_CHG_EXCLUDING_HOSP],
	ip.[HRR_FY2013_DISCHARGES_EXCLUDING_HOSP]       = hrr.[HRR_FY2013_DISCHARGES_EXCLUDING_HOSP],
	ip.[HRR_FY2013_AVG_CHG_EXCLUDING_HOSP]          = hrr.[HRR_FY2013_AVG_CHG_EXCLUDING_HOSP],
    ip.[HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP] = hrr.[HRR_FY2013_ADJUSTED_AVG_CHG_EXCLUDING_HOSP]

FROM [dbo].[W271_IP_CHARGE] ip
JOIN [dbo].[HRR_AVG_CHG_EXCLUDING_HOSP] hrr
  on ip.[PRVDR_NUM] = hrr.[PRVDR_NUM]
 and ip.[DRG] = hrr.[DRG]