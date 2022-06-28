* Encoding: windows-1252.
* Call include file for the working directory and the survey name.

*v02. 2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

compute layerW = 0.
variable labels layerW "".
value labels layerW 0 "Percentage of live births weighed at birth:".

compute fromCard = 0.
if (MN34A = 1) fromCard = 100.
variable labels fromCard "From card".

compute fromRecall = 0.
if (MN34A = 2) fromRecall = 100.
variable labels fromRecall "From recall".

compute totalWeighted = 0.
if (MN33 = 1) totalWeighted = 100.
variable labels totalWeighted "Total [1] [A]".

do if (MN34 < 9.997).
+ compute numWeighted = 1.
end if.

do if (numWeighted = 1).

compute lessThen2500Card = 0.
if (MN34A = 1 and MN34 < 2.5) lessThen2500Card = 100.
variable labels lessThen2500Card "From card".

compute lessThen2500Recall = 0.
if (MN34A = 2 and MN34 < 2.5) lessThen2500Recall = 100.
variable labels lessThen2500Recall "From recall".

compute lessThen2500= 0.
if (MN34 < 2.5) lessThen2500 = 100.
variable labels lessThen2500 "Total".

end if.

compute layer2500 = 0.
variable labels layer2500 "".
value labels layer2500 0 "Percentage of weighed live births recorded below 2,500 grams (crude low birthweight) [B]:".

* generate total variable.
compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute total100 = 100.
variable labels total100 "Total".

compute  numChildren = 1.
variable labels numChildren ''.
value labels numChildren 1 'Number of women with a live birth in the last 2 years'.

variable labels numWeighted ''.
value labels numWeighted 1 'Number of women with a live birth in the last 2 years whose most recent live-born child have a recorded or recalled birthweight'.

* generate order of the birth by looking at the total number of children ever born. 
recode cm11
  (1=1)
  (2,3 = 2)
  (4,5 = 4)
  (6 thru highest = 6)
  into birthOrder.
variable labels birthOrder "Birth order of most recent live birth".
value labels birthOrder
 1 '1'
 2 '2-3'
 4 '4-5'
 6 '6+' .

variable labels welevel "Education".

variable labels ageAtBirth "Mother’s age at delivery".
variable labels disability "Functional difficulties (age 18-49 years)".

* Ctables command in English.
ctables
  /vlabels variables=total layerW layer2500 numChildren numWeighted display=none
  /table  total [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]         
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + birthOrder [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]  
   by
         layerW [c] > (fromCard [s][mean f8.1] + fromRecall [s][mean f8.1] + totalWeighted [s][mean f8.1]) + numChildren [c][count] + 
         layer2500 [c] >  (lessThen2500Card [s][mean f8.1] + lessThen2500Recall [s][mean f8.1] + lessThen2500 [s][mean f8.1]) + numWeighted [c][count]
  /slabels visible = no
  /titles title=
     "Table TM.7.1: Infants weighed at birth"
     "Percentage of women age 15-49 years with a live birth in the last 2 years whose most recent live-born child was weighed at birth, " +
     "by source of information, and percentage of those with a recorded or recalled birthweight estimated to have weighed below 2,500 grams at birth, " +
     "by source of information, " + surveyname
   caption =
     "[1] MICS indicator TM.11 - Infants weighed at birth"
     "[A] The indicator includes children that were reported weighed at birth, but with no actual birthweight recorded or recalled	"						
     "[B] The values here are as recorded on card or as reported by respondent. The total crude low birthweight typically requires adjustment for heaping, " +
     "particularly at exactly 2,500 gram. The results presented here cannot be considered to represent the precise rate of low birthweight (very likely an underestimate) " +
     "and therefore not reported as a MICS indicator. More note coming later on old and new model and future of inclusion of indicator in MICS".						

new file.