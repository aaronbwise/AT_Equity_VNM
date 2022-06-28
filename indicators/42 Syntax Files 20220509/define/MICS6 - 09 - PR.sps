* Encoding: UTF-8.
compute economicActivity = any(1, CL1A, CL1B, CL1C, CL1X) .

do if (CB3<=11) .
+ compute numChildren5_11 = 1 .
+ compute ea1more = 0 .
+ compute ea1less = 0 .
+ if (economicActivity=1 and CL3<1) ea1less = 100 .
+ if (economicActivity=1 and CL3>=1 and CL3<97) ea1more = 100 .
end if .

do if (any(CB3,12,13,14)) .
+ compute numChildren12_14 = 1 .
+ compute ea14less = 0 .
+ compute ea14more = 0 .
+ if (economicActivity=1 and CL3<14) ea14less = 100 .
+ if (economicActivity=1 and CL3>=14 and CL3<97) ea14more = 100 .
end if.

do if (any(CB3,15,16,17)) .
+ compute numChildren15_17 = 1 .
+ compute ea43less = 0 .
+ compute ea43more = 0 .
+ if (economicActivity=1 and CL3<43) ea43less = 100 .
+ if (economicActivity=1 and CL3>=43 and CL3<97) ea43more = 100 .
end if.

compute  eaLess = sum(0, ea1less, ea14less, ea43less) .
compute  eaMore = sum(0, ea1more, ea14more, ea43more) .

compute hhChores = any(1, CL7, CL9, CL11A, CL11B, CL11C, CL11D, CL11E, CL11F, CL11X) .

do if (CB3<=14) .
+ compute hhc21less = 0 .
+ compute hhc21more = 0 .
+ if (hhChores=1 and sum(CL8, CL10, CL13)<21)  hhc21less = 100 .
+ recode CL8 (97,98,99=0).
+ recode CL10 (97,98,99=0).
+ recode CL13 (97,98,99=0).
+ if (hhChores=1 and sum(CL8, CL10, CL13)>=21) hhc21more = 100 .
end if.

* not applicable as indicator definition has changed.
* do if (any(CB3, 15, 16, 17)) .
* + compute hhc43less = 0 .
* + compute hhc43more = 0 .
* + recode CL8 (97,98,99=0).
* + recode CL10 (97,98,99=0).
* + recode CL13 (97,98,99=0).
* + if (hhChores=1 and sum(CL8, CL10, CL13)<43)  hhc43less = 100 .
* + if (hhChores=1 and sum(CL8, CL10, CL13)>=43) hhc43more = 100 .
* end if.

compute  hhcLess = sum(0, hhc21less) .
compute  hhcMore = sum(0, hhc21more) .

compute hazardConditions = 0 .
if (any(1, CL4, CL5, CL6A, CL6B, CL6C, CL6D, CL6E, CL6X)) hazardConditions = 100 .

* hazardConditions removed from the calculation of child labor.
compute childLabor = maximum(0, eaMore, hhcMore) .

compute includeHaz = maximum(0, eaMore, hhcMore, hazardConditions) .
