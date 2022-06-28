* Encoding: UTF-8.
***.
*v01. 2019-03-14.
*v02 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

select if  (mstatus = 1).

* definitions of contraceptiveMethod .
include 'define\MICS6 - 06 - TM.sps' .

variable labels contraceptiveMethod "Percent of women currently married or in union who are using (or whose partner is using):".

compute anyModern = 0.
if (contraceptiveMethod >= 1 and contraceptiveMethod <= 11) anyModern = 100.
variable labels anyModern "Any modern method".

compute anyTraditional = 0.
if (contraceptiveMethod >= 12 and contraceptiveMethod < 99) anyTraditional = 100.
variable labels anyTraditional "Any traditional method".

* Any method of contraception still includes all responses to CP3, i.e. all modern and traditional methods, as well as any missing values (CP3 = A-X or ?). 
compute anyMethod = 0.
if (anyModern = 100 or anyTraditional = 100 or  contraceptiveMethod = 99) anyMethod = 100.
variable labels anyMethod "Any method [1]".

compute livingChildren = 0.
if (CM1 = 1 and CM8 <> 1) livingChildren = CM11.
if (CM1 = 1 and CM8 = 1) livingChildren = CM11 - (CM9 + CM10).
recode livingChildren (0 thru 3 = copy) (4 thru hi = 4).
variable labels livingChildren "Number of living children".
value labels livingChildren 4 "4+".
formats livingChildren (f5.0).

compute numWomen = 1.
variable labels numWomen "Number of women currently married or in union".
value labels numWomen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1" ".
	
* Ctables command in English.
ctables
  /table   total [c]
         + HH6 [c]
         + hh7 [c]
         + $wage [c]
         + welevel [c]
         + livingChildren [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]            
   by
           contraceptiveMethod [c] [rowpct.validn '' f5.1]
         + anyModern [s] [mean '' f5.1]
         + anyTraditional [s] [mean '' f5.1]
         + anyMethod [s] [mean '' f5.1]
         + numWomen [s] [sum '' f5.0]
  /slabels position=column visible = no
  /titles title=
     "Table TM.3.1: Use of contraception (currently married/in union)"
     "Percentage of women age 15-49 years currently married or in union who are using (or whose partner is using) a contraceptive method, " + surveyname
   caption=
     "[1] MICS indicator TM.3 - Contraceptive prevalence rate"
  .																	

new file.
