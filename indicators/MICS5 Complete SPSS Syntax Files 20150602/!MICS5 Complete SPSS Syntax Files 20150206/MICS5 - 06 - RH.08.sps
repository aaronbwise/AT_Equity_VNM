* MICS5 RH-08.

* v01 - 2014-03-19.
* v02 - 2014-07-02.
* v03 - 2014-09-07.
* v04 - 2015-04-21
* A typo has been fixed in the column “No antenatal care visits”.

* corrected week-to-month-conversion for variable "number of months pregnant at the time of first antenatal care visit".

* The number of antenatal care visits is based on responses to MN3, and are inclusive of antenatal care received from any provider,
  skilled or unskilled (MN1=1).
* The number of months pregnant at the time of first antenetal care visit is based on MN2A,
  and are also inclusive of antenatal care received from any provider.

* The table is based on all women who had a live birth in the last two years.
* Antenatal care during the pregnancy of the last birth is taken into account .

* line calculating nmonths is corrected from:
 + if (MN2AU=1 and MN2AN <98) nmonths = MN2AN/4.
* to :
 + if (MN2AU=1 and MN2AN <98) nmonths = MN2AN*12/52.

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* select women that gave birth in two years preceeding the survey.
select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* definitions of anc, ageAtBirth .
include 'define\MICS5 - 06 - RH.sps' .

compute noVisits = 0.
if (MN3 = 1) noVisits = 1.
if (MN3 = 2) noVisits = 2.
if (MN3 = 3) noVisits = 3.
if (MN3 >= 4) noVisits = 4.
if (MN3 = 98 or MN3 = 99) noVisits = 9.
variable labels noVisits "Percent distribution of women who had:".
value labels noVisits
  0 "No antenatal care visits"
  1 "One visit"
  2 "Two visits"
  3 "Three  visits"
  4 "4 or more visits [1]"
  9 "Missing/DK".

compute visitTime = 0 .
if (MN2AU >= 8 or MN2AN >= 98) visitTime = 9 .
* 8+ months: weeks 31 and above; months 8 and above.
if ((MN2AU=1 and MN2AN>=31 and MN2AN<98) or (MN2AU=2 and MN2AN>7 and MN2AN<98)) visitTime = 4 .
* 6-7 months: weeks 22-30; months 6,7.
if ((MN2AU=1 and MN2AN<31) or (MN2AU=2 and any(MN2AN,6,7))) visitTime = 3 .
* 4-5 months: weeks 14 - 21; months 4,5.
if ((MN2AU=1 and MN2AN<22) or (MN2AU=2 and any(MN2AN,4,5))) visitTime = 2 .
* First trimestar: weeks 1 - 13, months 1,2,3.
if ((MN2AU=1 and MN2AN<14) or (MN2AU=2 and any(MN2AN,1,2,3))) visitTime = 1 .
variable labels visitTime "Percent distribution of women by number of months pregnant at the time of first antenatal care visit" .
value labels visitTime
  0 "No antenatal care visits"
  1 "First trimester"
  2 "4-5 months"
  3 "6-7 months"
  4 "8+ months"
  9 "DK/Missing"
  .

compute numWomenANC = 0.
if (visitTime >= 1 and visitTime < 9) numWomenANC = 1.
value labels numWomenANC 1 " ".
variable labels numWomenANC "Number of women with a live birth in the last two years who had at least one ANC visit".

do if (visitTime >= 1 and visitTime < 9).
+ compute nmonths = 99.
+ if (MN2AU=1 and MN2AN <98) nmonths = MN2AN*12/52.
+ if (MN2AU=2 and MN2AN <98) nmonths = MN2AN.
+ recode nmonths (99 = sysmis) (else = copy).
end if.

compute numWomen = 1.
value labels numWomen 1 "".
variable labels numWomen "Number of women with a live birth in the last two years".

variable labels nmonths "Median months pregnant at first ANC visit".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + ageAtBirth [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]       
   by
           noVisits [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1] 
         + visitTime [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1] 
         + numWomen [s] [count,'',f5.0]
         + nmonths [s] [median,'',f5.1]
         + numWomenANC [s] [sum,'',f5.0]
  /categories var=all empty=exclude
  /slabels position=column visible=no
  /title title=
     "Table RH.8: Number of antenatal care visits"
     "Percent distribution of women age 15-49 years with a live birth in the last two years by number of antenatal care visits by any provider and by the timing of first antenatal care visits, "     + surveyname 
   caption=
     "[1] MICS indicator 5.5b; MDG indicator 5.5 - Antenatal care coverage"
  .

new file.
