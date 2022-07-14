* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hl.sav".

recode HL6 (98,99 = 100) (else = 0) into mage.
variable labels mage "Age".

CTABLES
  /TABLE 
  mage[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]
  /TITLES TITLE=
  "Table DQ.6: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

recode SI1 (8,9 =100) (else  = 0) into msalt.
variable labels msalt "Salt testing".

compute stime = 0.
if (HH18H = 99 or HH18M = 99) stime = 100.
variable labels stime "Starting time of interview".

compute etime = 0.
if (HH19H = 99 or HH19M = 99) etime = 100.
variable labels etime "Ending time of interview".

CTABLES
  /TABLE 
  msalt[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]
  /TITLES TITLE=
  "Table DQ.6: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.
COMMENT -- End CTABLES command.

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute mwmb   = 0.
compute mwmyb = 0.
if ((WB1M = 98 or WB1M = 99) and WB1Y < 9998) mwmb = 100.  
if (WB1M >= 98 and WB1Y >= 9998) mwmyb = 100.  
variable labels mwmb "Woman's date of birth: Only month".
variable labels mwmyb "Woman's date of birth: Both month and year".

do if (CM1 = 1).

+ compute mwmfb   = 0.
+ compute mwmyfb = 0.
+ if (CM2M  >= 98  and CM2Y  < 9998) mwmfb = 100.  
+ if (CM2M  >= 98 and CM2Y  >= 9998) mwmyfb = 100.  
+ recode CM3 (98,99 = 100) (sysmis = copy) (else = 0) into cyears.

+ compute mwmlb   = 0.
+ compute mwmylb = 0.
+ if (CM12M >= 98 and CM12Y < 9998) mwmlb = 100.  
+ if (CM12M >= 98 and CM12Y >= 9998) mwmylb = 100.  

end if.

variable labels mwmfb "Date of first birth: Only month".
variable labels mwmyfb "Date of first birth: Both month and year".
variable labels cyears "Completed years since first birth".

variable labels mwmlb "Date of last birth: Only month".
variable labels mwmylb "Date of last birth: Both month and year".

do if (sysmis(MA5) or MA5 <> 3).

+ compute mwmfm   = 0.
+ compute mwyfm = 0.
+ if (MA8M >= 98 and MA8Y < 9998) mwmfm = 100.  
+ if (MA8M >= 98 and MA8Y >= 9998) mwyfm = 100.  
+ recode MA9 (98,99 = 100) (else = 0) into agefm.

end if.

variable labels mwmfm "Date of first marriage/union: Only month".
variable labels mwyfm "Date of first marriage/union: Both month and year ".
variable labels agefm "Age at first marriage/union".

do if (WB2 >= 15 and WB2 <= 24 and SB1 <> 0).

+ compute agefi = 0.
+ compute timesli = 0.
+ recode SB1 (98,99 = 100) (else = 0) into agefi.  
+ recode SB3N (98,99 = 100) (sysmis = copy) (else = 0) into timesli.  

end if.

variable labels agefi "Age at first intercourse".
variable labels timesli "Time since last intercourse".

do if (WM7 = 1).

+ compute stime = 0.
+ if (WM10H = 99 or WM10M = 99) stime = 100.

+ compute etime = 0.
+ if (WM11H = 99 or WM11M = 99) etime = 100.

end if.

variable labels stime "Starting time of interview".
variable labels etime "Ending time of interview".

CTABLES
  /TABLE 
  mwmb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mwmyb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  mwmfb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  mwmyfb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  cyears[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  mwmlb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  mwmylb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mwmfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mwyfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefi[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  timesli[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]
  /TITLES TITLE=
   "Table DQ.6: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

compute mnmb   = 0.
compute mnmyb = 0.
if ((MWB1M = 98 or MWB1M = 99) and WB1Y < 9998) mnmb = 100.  
if (MWB1M >= 98 and MWB1Y >= 9998) mnmyb = 100.  
variable labels mnmb "Man's date of birth: Only month".
variable labels mnmyb "Man's date of birth: Both month and year".

do if (sysmis(MMA5) or MMA5 <> 3).

+ compute mnmfm   = 0.
+ compute mnyfm = 0.
+ if (MMA8M >= 98 and MMA8Y < 9998) mnmfm = 100.  
+ if (MMA8M >= 98 and MMA8Y >= 9998) mnyfm = 100.  
+ recode MMA9 (98,99 = 100) (else = 0) into agefmm.

end if.

variable labels mnmfm "Date of first marriage/union: Only month".
variable labels mnyfm "Date of first marriage/union: Both month and year ".
variable labels agefmm "Age at first marriage/union".

do if (MWB2 >= 15 and MWB2 <= 24 and MSB1 <> 0).

+ compute agefim = 0.
+ compute timeslim = 0.
+ recode MSB1 (98,99 = 100) (else = 0) into agefim.  
+ recode MSB3N (98,99 = 100) (sysmis = copy) (else = 0) into timeslim.  

end if.

variable labels agefim "Age at first intercourse".
variable labels timeslim "Time since last intercourse".

do if (MWM7 = 1).

+ compute stimem = 0.
+ if (MWM10H = 99 or MWM10M = 99) stimem = 100.

+ compute etimem = 0.
+ if (MWM11H = 99 or MWM11M = 99) etimem = 100.

end if.

variable labels stime "Starting time of interview".
variable labels etime "Ending time of interview".

CTABLES
  /TABLE 
  mnmb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mnmyb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0] +
  mnmfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mwyfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefi[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  timeslim[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stimem[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etimem[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]
  /TITLES TITLE=
   "Table DQ.6: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute mmb = 0.
compute myb  = 0.
if (AG1M >= 98 and AG1Y < 9998) mmb = 100.
if (AG1M >= 98 and AG1Y >= 9998) myb = 100.
variable labels mmb "Date of birth: Only month".
variable labels myb "Date of birth: Both month and year".

compute miswgt = 0.
if (sysmis (AN3) or AN3 > 99) miswgt = 100.
variable labels miswgt "Anthropometric measurements: Weight".

compute mishgt = 0.
if (sysmis(AN4) or AN4 > 999) mishgt = 100.
variable labels mishgt "Anthropometric measurements: Height".

compute miswh = 0.
if (miswgt = 100 and mishgt = 100) miswh = 100.
variable labels miswh "Anthropometric measurements: Both weight and height".

compute stime = 0.
if (UF12H = 99 or UF12M = 99) stime = 100.
variable labels stime "Starting time of interview".

compute etime = 0.
if (UF13H = 99 or UF13M = 99) etime = 100.
variable labels etime "Ending time of interview".

COMMENT -- End commenting out TABLES command.
COMMENT -- Begin CTABLES command.

CTABLES
  /TABLE 
  mmb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  myb[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  miswgt[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mishgt[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  miswh[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]
  /TITLES TITLE=
   "Table DQ.6: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.
COMMENT -- End CTABLES command.

new file.
