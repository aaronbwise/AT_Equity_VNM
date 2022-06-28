* Encoding: windows-1252.
* MICS5 RH-08.

***.
*v02.2019-03-14.
*v03 - 2020-04-26. In table note A, changed "counseling" to "counselling". Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

* select women that gave birth in two years preceeding the survey. 
select if (CM17 = 1).

weight by wmweight.

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

recode MN6A (1 = 100) (else = 0) into bloodPressure.
variable labels bloodPressure "Blood pressure measured".
recode MN6B (1 = 100) (else = 0) into urineSample.
variable labels urineSample "Urine sample taken".
recode MN6C (1 = 100) (else = 0) into bloodSample.
variable labels bloodSample "Blood sample taken".
compute allthree = 0.
if (bloodPressure = 100 & urineSample = 100 & bloodSample = 100) allthree = 100.
variable labels allthree "Blood pressure measured, urine and blood sample taken [1]".

compute numWomen = 1.
variable labels numWomen "Number of women with a live birth in the last 2 years".
value labels numWomen 1 "".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who, during the pregnancy of the most recent live birth, had:".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]        
   by 
           layer [c] > ( 
             bloodPressure [s] [mean '' f5.1] 
           + urineSample [s] [mean '' f5.1] 
           + bloodSample [s] [mean '' f5.1]
           + allthree [s] [mean '' f5.1] )
           + numWomen [s] [count '' f5.0]
  /categories variables=all empty=exclude 
  /slabels position=column visible=no
  /titles title=
     "Table TM.4.3: Content of antenatal care" 
	"Percentage of women age 15-49 years with a live birth in the last 2 years who, at least once, had their blood pressure measured, urine sample taken, " +
                    "and blood sample taken as part of antenatal care, during the pregnancy of the most recent live birth" + surveyname
   caption =
     "[1] MICS indicator TM.6 - Content of antenatal care [A]"					
     "[A] For HIV testing and counselling during antenatal care, please refer to table TM.11.5"
  .

new file.
