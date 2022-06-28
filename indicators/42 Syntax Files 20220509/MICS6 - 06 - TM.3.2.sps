* Encoding: UTF-8.
***.
*v01. 2019-03-14.
*v02 - 2020-04-14. Labels in French and Spanish have been removed.
*v03 - 2021-04-09. added  /vlabels variables= layer   display=none ctables command.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

* definitions of contraceptiveMethod .
include 'define\MICS6 - 06 - TM.sps' .

select if  (mstatus <> 1 and sexact = 1).

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of sexually active [A] women currently unmarried or not in union who are using (or whose partner is using):".

compute anyModern = 0.
if (contraceptiveMethod >= 1 and contraceptiveMethod <= 11) anyModern = 100.
variable labels anyModern "Any modern method".

compute anyTraditional = 0.
if (contraceptiveMethod >= 12 and contraceptiveMethod < 99) anyTraditional = 100.
variable labels anyTraditional "Any traditional method".

* Any method of contraception still includes all responses to CP3, i.e. all modern and traditional methods, as well as any missing values (CP3 = A-X or ?). 
compute anyMethod = 0.
if (anyModern = 100 or anyTraditional = 100 or contraceptiveMethod = 99) anyMethod = 100.
variable labels anyMethod "Any method".

compute livingChildren = 0.
if (CM1 = 1 and CM8 <> 1) livingChildren = CM11.
if (CM1 = 1 and CM8 = 1) livingChildren = CM11 - (CM9 + CM10).
recode livingChildren (0 thru 3 = copy) (4 thru hi = 4).
variable labels livingChildren "Number of living children".
value labels livingChildren 4 "4+".
formats livingChildren (f5.0).

compute numWomen = 1.
variable labels numWomen "Number of sexually active [A] women currently unmarried or not in union".
value labels numWomen 1 "".

variable labels disability "Functional difficulties (age 18-49 years)".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English.
ctables
  /vlabels variables= layer display=none
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
         layer [c] > (   
         anyModern [s] [mean '' f5.1]
         + anyTraditional [s] [mean '' f5.1]
         + anyMethod [s] [mean '' f5.1])
         + numWomen [s] [sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude         
  /slabels position=column visible = no
  /titles title=
     "Table TM.3.2: Use of contraception (currently unmarried/not in union)"
     "Percentage of sexually active women age 15-49 years currently unmarried or not in union who are using (or whose partner is using) a contraceptive method, " + surveyname
   caption=
     "[A] >>Sexually active<< is defined as having had sex within the last 30 days."
  .													

new file.
