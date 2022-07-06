* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Household.
get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

* Salt test result.
recode SI1 (8,9 =100) (else  = 0) into msalt.
variable labels msalt "Salt test result".

*Starting time of interview.
compute stime = 0.
if (HH18H >=97 or HH18M >=97) stime = 100.
variable labels stime "Starting time of interview".

* Ending time of interview.
compute etime = 0.
if (HH19H >=97 or HH19M >=97) etime = 100.
variable labels etime "Ending time of interview".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Household".


CTABLES
  /TABLE 
  layer [c] >
  (msalt[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0])
  /TITLES TITLE=
  "Table DQ.11: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.
	

* Women.
get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

do if (sysmis(MA5) or MA5 <> 3).

+ compute mwmfm   = 0.
+ compute mwyfm = 0.
+ if (MA8M >= 97 and MA8Y < 9997) mwmfm = 100.  
+ if (MA8M >= 97 and MA8Y >= 9997) mwyfm = 100.  
+ recode MA9 (97,98,99 = 100) (else = 0) into agefm.

end if.

variable labels mwmfm "Date of first marriage/union: Only month".
variable labels mwyfm "Date of first marriage/union: Both month and year ".
variable labels agefm "Age at first marriage/union".

do if (WB2 >= 15 and WB2 <= 24 and SB1 <> 0).

+ compute agefi = 0.
+ compute timesli = 0.
+ recode SB1 (97,98,99 = 100) (else = 0) into agefi.  
+ recode SB3N (97,98,99 = 100) (sysmis = copy) (else = 0) into timesli.  

end if.

variable labels agefi "Age at first intercourse".
variable labels timesli "Time since last intercourse".

do if (WM7 = 1).

+ compute stime = 0.
+ if (WM10H >=97 or WM10M >=97) stime = 100.

+ compute etime = 0.
+ if (WM11H >=97 or WM11M >=97) etime = 100.

end if.

variable labels stime "Starting time of interview".
variable labels etime "Ending time of interview".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Women".

CTABLES
  /TABLE 
  layer [c] >
  (mwmfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mwyfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefi[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  timesli[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0])
  /TITLES TITLE=
   "Table DQ.11: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

* Men.
get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

do if (sysmis(MMA5) or MMA5 <> 3).

+ compute mnmfm   = 0.
+ compute mnyfm = 0.
+ if (MMA8M >= 97 and MMA8Y < 9997) mnmfm = 100.  
+ if (MMA8M >= 97 and MMA8Y >= 9997) mnyfm = 100.  
+ recode MMA9 (97,98,99 = 100) (else = 0) into agefmm.

end if.

variable labels mnmfm "Date of first marriage/union: Only month".
variable labels mnyfm "Date of first marriage/union: Both month and year ".
variable labels agefmm "Age at first marriage/union".

do if (MWB2 >= 15 and MWB2 <= 24 and MSB1 <> 0).

+ compute agefim = 0.
+ compute timeslim = 0.
+ recode MSB1 (97,98,99 = 100) (else = 0) into agefim.  
+ recode MSB3N (97,98,99 = 100) (sysmis = copy) (else = 0) into timeslim.  

end if.

variable labels agefim "Age at first intercourse".
variable labels timeslim "Time since last intercourse".

do if (MWM7 = 1).

+ compute stimem = 0.
+ if (MWM10H >=97 or MWM10M >=97) stimem = 100.

+ compute etimem = 0.
+ if (MWM11H >=97 or MWM11M >=97) etimem = 100.

end if.

variable labels stimem "Starting time of interview".
variable labels etimem "Ending time of interview".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Men".

CTABLES
  /TABLE 
  layer [c] >
  (mnmfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  mnyfm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefmm[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  agefim[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  timeslim[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  stimem[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etimem[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0])
  /TITLES TITLE=
   "Table DQ.11: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

* Under 5.
get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.
compute stime = 0.
if (UF12H >=97 or UF12M >=97) stime = 100.
variable labels stime "Starting time of interview".

compute etime = 0.
if (UF13H >=97 or UF13M >=97) etime = 100.
variable labels etime "Ending time of interview".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Under-5".

CTABLES
  /TABLE 
  layer[c] >
  (stime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0]+
  etime[S][MEAN,'Percent with missing/incomplete information*',F5.1,VALIDN,'Number of cases',F5.0])
  /TITLES TITLE=
   "Table DQ.11: Completeness of reporting"
   "Percentage of observations that are missing information for selected questions and indicators, " + surveyname.

new file.
