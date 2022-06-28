* Encoding: UTF-8.
*2018.08.22: The calculation of weight assesment is corrected from:
 if (PN30 = 1) WeightAssessment = 100. 
*to
*if (PN29 = 1) WeightAssessment = 100.
***.

* v02. 2019-03-14.
* v03 - 2020-04-26. In the subtitle, headings of columns D and F and description, changed "counseling" to "counselling". Labels in French and Spanish have been removed.
* v04 - 2020-07-10. Calculation of indicator "Counseling or observation" corrected from if (PN25B = 1 or PN27 = 1) BreasfeedingBoth = 100. to if (PN25C = 1 or PN27 = 1) BreasfeedingBoth = 100.

***.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey.
select if (CM17 = 1).

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of newborns receiving post-natal signal care function of:".

* Those receiving postnatal care functions are:
* Cord examination: PN25[A]=1.
* Temperature assessment: PN25[B]=1.
* Counseling on breastfeeding: PN25[C]=1.
* Observation of breastfeeding: PN27=1.
* Weight assessment: PN29=1.
* Information on the symptoms requiring care-seeking: PN30=1.

compute cordExam = 0.
if (PN25A = 1) cordExam = 100.
variable labels cordExam "Cord examination".

compute TempAssessment = 0.
if (PN25B = 1) TempAssessment = 100.
variable labels TempAssessment "Temperature assessment".

compute BreasfeedingC = 0.
if (PN25C = 1) BreasfeedingC = 100.
variable labels BreasfeedingC "Counselling".

compute BreasfeedingO = 0.
if (PN27 = 1) BreasfeedingO = 100.
variable labels BreasfeedingO "Observation".

compute BreasfeedingBoth = 0.
if (PN25C = 1 or PN27 = 1) BreasfeedingBoth = 100.
variable labels BreasfeedingBoth "Counselling or observation".

compute WeightAssessment = 0.
if (PN29 = 1) WeightAssessment = 100.
variable labels WeightAssessment "Weight assessment".

compute CareSeek = 0.
if (PN30 = 1) CareSeek = 100.
variable labels CareSeek "Receiving information on the symptoms requiring care-seeking".

* Percentage of newborns who received a least 2 of the preceding signal postnatal care functions within 2 days after birth.
compute pncCheck = cordExam +  TempAssessment + BreasfeedingC + BreasfeedingO + BreasfeedingBoth + WeightAssessment + CareSeek.
recode pncCheck (200 thru hi = 100) (else = 0).
variable labels pncCheck " Percentage of newborns who received a least 2 of the preceding post-natal signal care functions within 2 days of birth [1]".

compute numChildren = 1.
variable labels numChildren "Number of women with a live birth in the last 2 years".
value labels  numChildren 1 "".

compute total = 1.
variable labels total "Total".
value labels  total 1 " ".

compute layer1 = 0.
variable labels layer1 "".											  
value labels layer1 0 "Breastfeeding".

variable labels welevel "Education".
variable labels ageAtBirth "Age at most recent live birth".
variable labels disability "Functional difficulties (age 18-49 years)".
variable labels bh3_last "Sex of newborn".

* Ctables command in English.
ctables
  /vlabels variables = layer layer1 display = none
  /table   total [c]
         + bh3_last [c]
         + hh6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + $deliveryPlace [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]   
     by
           layer [c] > 
          (cordExam [s] [mean '' f5.1] + TempAssessment [s] [mean '' f5.1] + layer1 [c] > (BreasfeedingC [s] [mean '' f5.1] + BreasfeedingO [s] [mean '' f5.1] + BreasfeedingBoth [s] [mean '' f5.1]) + 
              WeightAssessment [s] [mean '' f5.1] + CareSeek [s] [mean '' f5.1]) +
         pncCheck [s] [mean '' f5.1] + 
         numChildren[s] [count '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible=no
  /titles title="Table TM.8.6: Content of postnatal care for newborns"
	"Percentage of women age 15-49 years with a live birth in the last 2 years for whom, within 2 days of the most recent live birth, the umbilical cord was examined, " +
                  "the temperature of the newborn was assessed, breastfeeding counselling was done or breastfeeding observed, the newborn was weighed and counselling on danger signs for newborns was done, " + surveyname
   caption=
      "[1] MICS indicator TM.19 - Postnatal signal care functions".

new file.
