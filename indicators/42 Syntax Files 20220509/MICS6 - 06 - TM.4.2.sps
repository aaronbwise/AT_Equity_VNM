* Encoding: UTF-8.
* MICS5 RH-08.

***.
*v02.2019-03-14.
*v03 - 2020-04-14. Labels in French and Spanish have been removed.
*v04 - 2020-09-10. Median number of months presented with 1 decimal point.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

* select women that gave birth in two years preceeding the survey. 
select if (CM17 = 1).

include "surveyname.sps".

weight by wmweight.

* definitions of anc, ageAtBirth .
include 'define\MICS6 - 06 - TM.sps' .

* Define Multiple Response Sets.
mrsets
  /mcgroup name = $antvisits
           label = 'Percentage of women by number of antenatal care visits:'
           variables =  noVisitsAux1 noVisitsAux2 .

compute visitTime = 0 .
if (MN4AU >= 8 or MN4AN >= 98) visitTime = 9 .
* 8+ months: weeks 31 and above; months 8 and above.
if ((MN4AU=1 and MN4AN>=31 and MN4AN<98) or (MN4AU=2 and MN4AN>7 and MN4AN<98)) visitTime = 4 .
* 6-7 months: weeks 22-30; months 6,7.
if ((MN4AU=1 and MN4AN<31) or (MN4AU=2 and any(MN4AN,6,7))) visitTime = 3 .
* 4-5 months: weeks 14 - 21; months 4,5.
if ((MN4AU=1 and MN4AN<22) or (MN4AU=2 and any(MN4AN,4,5))) visitTime = 2 .
* First trimestar: weeks 1 - 13, months 1,2,3.
if ((MN4AU=1 and MN4AN<14) or (MN4AU=2 and any(MN4AN,1,2,3))) visitTime = 1 .
variable labels visitTime "Percent distribution of women by number of months pregnant at the time of first antenatal care visit" .
value labels visitTime
  0 "No antenatal care visits"
  1 "Less than 4 months"
  2 "4-5 months"
  3 "6-7 months"
  4 "8+ months"
  9 "DK/Missing"
  .

compute numWomenANC = 0.
if (visitTime >= 1 and visitTime < 9) numWomenANC = 1.
value labels numWomenANC 1 " ".
variable labels numWomenANC "Number of women with a live birth in the last 2 years who had at least one ANC visit".

do if (visitTime >= 1 and visitTime < 9).
+ compute nmonths = 99.
+ if (MN4AU=1 and MN4AN <98) nmonths = MN4AN*12/52.
+ if (MN4AU=2 and MN4AN <98) nmonths = MN4AN.
+ recode nmonths (99 = sysmis) (else = copy).
end if.

compute numWomen = 1.
value labels numWomen 1 "".
variable labels numWomen "Number of women with a live birth in the last 2 years".

variable labels nmonths "Median months pregnant at first ANC visit".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100" ".

* Ctables command in English.
ctables
  /table   total [c]
         + HH6 [c]
         + hh7 [c]
         + welevel [c]
         + ageAtBirth [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]        
   by
           $antvisits [c] [rowpct.validn '' f5.1]
         + visitTime [c] [rowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1] 
         + numWomen [s] [count '' f5.0]
         + nmonths [s] [median '' f5.1]
         + numWomenANC [s] [sum '' f5.0]
  /categories variables=all empty=exclude
  /slabels position=column visible=no
  /titles title=
     "Table TM.4.2: Number of antenatal care visits and timing of first visit"
     "Percentage of women age 15-49 years with a live birth in the last 2 years by number of antenatal care visits by any provider and percent distribution of timing of first antenatal care " +
        "visit during the pregnancy of the most recent live birth, and median months pregnant at first ANC visit among women with at least one ANC visit,  "     + surveyname 
   caption=
     "[1] MICS indicator TM.5b - Antenatal care coverage (at least four times by any provider); SDG indicator 3.8.1"
     "[2] MICS indicator TM.5c - Antenatal care coverage (at least eight times by any provider)"
  .														
							
new file.
