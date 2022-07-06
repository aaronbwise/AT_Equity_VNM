* v4  instead of just CL12 not it is sum(CL9, CL12) .
* v3 corrected "+ if (economicActivity=1 and CL4>=1) ea1less = 100", it should be less < .
* v2 corrected "compute ea43less = 0" and "CL4" to "CL12" .

compute economicActivity = any(1, CL2A, CL2B, CL2C, CL2D) .

do if (SL9C<=11) .
+ compute numChildren5_11 = 1 .
+ compute ea1more = 0 .
+ compute ea1less = 0 .
+ if (economicActivity=1 and CL4<1) ea1less = 100 .
+ if (economicActivity=1 and CL4>=1) ea1more = 100 .
end if .

do if (any(SL9C,12,13,14)) .
+ compute numChildren12_14 = 1 .
+ compute ea14less = 0 .
+ compute ea14more = 0 .
+ if (economicActivity=1 and CL4<14) ea14less = 100 .
+ if (economicActivity=1 and CL4>=14) ea14more = 100 .
end if.

do if (any(SL9C,15,16,17)) .
+ compute numChildren15_17 = 1 .
+ compute ea43less = 0 .
+ compute ea43more = 0 .
+ if (economicActivity=1 and CL4<43) ea43less = 100 .
+ if (economicActivity=1 and CL4>=43) ea43more = 100 .
end if.

compute  eaLess = sum(0, ea1less, ea14less, ea43less) .
compute  eaMore = sum(0, ea1more, ea14more, ea43more) .

compute hhChores = any(1, CL8, CL10A, CL10B, CL10C, CL10D, CL10E, CL10F, CL10G) .

do if (SL9C<=14) .
+ compute hhc28less = 0 .
+ compute hhc28more = 0 .
+ if (hhChores=1 and sum(CL9, CL12)<28)  hhc28less = 100 .
+ if (hhChores=1 and sum(CL9, CL12)>=28) hhc28more = 100 .
end if.

do if (any(SL9C, 15, 16, 17)) .
+ compute hhc43less = 0 .
+ compute hhc43more = 0 .
+ if (hhChores=1 and sum(CL9, CL12)<43)  hhc43less = 100 .
+ if (hhChores=1 and sum(CL9, CL12)>=43) hhc43more = 100 .
end if.

compute  hhcLess = sum(0, hhc28less, hhc43less) .
compute  hhcMore = sum(0, hhc28more, hhc43more) .

compute hazardConditions = 0 .
if (any(1, CL5, CL6, CL7A, CL7B, CL7C, CL7D, CL7E, CL7F)) hazardConditions = 100 .

compute childLabor = maximum(0, eaMore, hhcMore, hazardConditions) .
