update ip

set ip.[N_HOSPS_IN_HRR] = n.[N_HOSPS_IN_HRR]

from [dbo].[W271_IP_CHARGE] ip
JOIN (select [HRR],
             count(distinct [PRVDR_NUM]) as [N_HOSPS_IN_HRR]
      from w271_ip_charge
      group by [hrr]
	  ) as n
  on ip.[HRR] = n.[HRR]