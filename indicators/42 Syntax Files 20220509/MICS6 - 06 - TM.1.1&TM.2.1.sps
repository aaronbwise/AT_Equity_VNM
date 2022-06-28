* Encoding: windows-1252.
* MICS6 TM1.1&TM2.1.

* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

* The age-specific fertility rate is defined as the number of live births to women in a specific age group during a specified period, 
divided by the average number of women in that age group during the same period, expressed per 1,000 women. The age-specific fertility rate for women age 15-19 years is also termed as the adolescent birth rate.

* The total fertility rate (TFR) is calculated by summing the age-specific fertility rates calculated for each of the 5-year age groups of women, 
from age 15 through to age 49. The TFR denotes the average number of children to which a woman will have given birth by the end of her reproductive years (by age 50) if current fertility rates prevailed.

* The general fertility rate (GFR) is the number of live births to women age 15-49 years during a specified period, divided by the average number of women in the same age group during the same period, expressed per 1,000 women.

* The crude birth rate (CBR) is the number of live births during a specified period, divided by the total population during the same period, expressed per 1,000 population.

* Rates are calculated for the three-year (1-36 months) period preceding the survey, based on data collected in birth histories. The month of interview is ignored, as it would represent a censored (incomplete) period of observation.

* See notes below TM.2.1 for further details.

***.
include "surveyname.sps".

* Main program - calls.
*  MICS6 - 06 - fert_b.sps  for calculation of births.
*  MICS6 - 06 - fert_e.sps  for calculation of exposure.
*  MICS6 - 06 - fert_p.sps  for calculation of live births during a specified period, divided by the total population during the same period,.
*  MICS6 - 06 - fert_c.sps  for calculation of probabilities and rates, and final tables.

define runfert (backvar = !tokens(1) / backval = !tokens(1)).
get file='bh.sav'.
!if (!backvar=total) !then
compute !backvar=!backval.
execute.
!ifend
select if (!backvar=!backval).
compute period=36.
compute maxper=5.
include 'MICS6 - 06 - fert_B.sps'.
get file='wm.sav'.
!if (!backvar=total) !then
compute !backvar=!backval.
execute.
!ifend
select if (WM17 = 1 and !backvar=!backval).
compute period=36.
compute maxper=5.
include 'MICS6 - 06 - fert_E.sps'.
get file = 'hl.sav'.
!if (!backvar=total) !then
compute !backvar=!backval.
execute.
!ifend
!if (!backvar=welevel) !then
compute !backvar=!backval.
execute.
!ifend
select if (!backvar=!backval).
include 'MICS6 - 06 - fert_P.sps'.
include 'MICS6 - 06 - fert_C.sps'.
compute !backvar=!backval.
!if (!backvar<>total) !then
add files
  /file='tmpfert.sav'
  /file=*.
execute.
!ifend
save outfile='tmpfert.sav'.
new file.
erase file = 'births.sav'.
erase file = 'exposure.sav'.
erase file = 'exposuretotal.sav'.
!enddefine.

* National fertility estimates.
define subgroupname ()
'(Total)'
!enddefine.
runfert backvar=total backval=1.

* Regions.
define subgroupname ()
'(Region 1)'
!enddefine.
runfert backvar=hh7 backval=1.

define subgroupname ()
'(Region 2)'
!enddefine.
runfert backvar=hh7 backval=2.

define subgroupname ()
'(Region 3)'
!enddefine.
runfert backvar=hh7 backval=3.

define subgroupname ()
'(Region 4)'
!enddefine.
runfert backvar=hh7 backval=4.

define subgroupname ()
'(Region 5)'
!enddefine.
runfert backvar=hh7 backval=5.


* Ethnicity.
define subgroupname ()
'(Group 1)'
!enddefine.
runfert backvar=ethnicity backval=1.

* Ethnicity.
define subgroupname ()
'(Group 2)'
!enddefine.
runfert backvar=ethnicity backval=2.

* Ethnicity.
define subgroupname ()
'(Group 3)'
!enddefine.
runfert backvar=ethnicity backval=3.

* Ethnicity.
define subgroupname ()
'(Other)'
!enddefine.
runfert backvar=ethnicity backval=6.


* Area.
define subgroupname ()
'(Urban)'
!enddefine.
runfert backvar=HH6 backval=1.

define subgroupname ()
'(Rural)'
!enddefine.
runfert backvar=HH6 backval=2.


* Mother's education.
define subgroupname ()
'(Pre-primary or none)'
!enddefine.
runfert backvar=welevel backval=0.

define subgroupname ()
'(Primary)'
!enddefine.
runfert backvar=welevel backval=1.

define subgroupname ()
'(Lower secondary)'
!enddefine.
runfert backvar=welevel backval=2.

define subgroupname ()
'(Upper secondary +)'
!enddefine.
runfert backvar=welevel backval=3.


define subgroupname ()
'(Has functional difficulty)'
!enddefine.
runfert backvar=disability backval=1.

define subgroupname ()
'(Has no functional difficulty)'
!enddefine.
runfert backvar=disability backval=2.


* Wealth index quintile.
define subgroupname ()
'(Poorest)'
!enddefine.
runfert backvar=windex5 backval=1.

define subgroupname ()
'(Second)'
!enddefine.
runfert backvar=windex5 backval=2.

define subgroupname ()
'(Middle)'
!enddefine.
runfert backvar=windex5 backval=3.

define subgroupname ()
'(Fourth)'
!enddefine.
runfert backvar=windex5 backval=4.

define subgroupname ()
'(Richest)'
!enddefine.
runfert backvar=windex5 backval=5.


* Produce final output tables.

get file='tmpfert.sav'.

variable labels hh7 'Region'.
variable labels hh6 'Area'.
variable labels welevel "Education".
variable labels disability "Functional difficulties (age 18-49 years)".
variable labels windex5 'Wealth index quintiles'.
variable labels ethnicity 'Ethnicity of household head'.
variable labels total 'Total'.

value labels hh7 1 'Region 1' 2 'Region 2' 3 'Region 3' 4 'Region 4' 5 'Region 5'.
value labels hh6 1 'Urban' 2 'Rural'.
value labels welevel 0 'Pre-primary or none' 1 'Primary' 2 'Lower secondary ' 3 'Upper secondary +'.
value labels disability 1 'Has functional difficulty' 2 'Has no functional difficulty'.
value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 "Group 1" 2 "Group 2" 3 "Group 3" 6 "Other".
value labels total 1 ' '.

add value labels age5 1 "15-19 [1]".

use all.
compute sel = (colper = 0).
filter by sel.

ctables
  /vlabels variables=age5 asfr display = none
  /table asfr[s][mean '' comma5.0]>age5[c]+tfr[s][maximum '' f5.1]+gfr[s][maximum '' f5.1]+cbr[s][sum '' f5.1] by hh6[c] + total[c]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=row
  /titles title = "Table TM.1.1: Fertility rates"
                    "Adolescent birth rate, age-specific and total fertility rates, the general fertility rate, and the crude birth rate for the three-year period preceding the survey, by area of residence, " + surveyname
   caption =  "[1] MICS indicator TM.1 - Adolescent birth rate (age 15-19 years); SDG indicator 3.7.2"			
    "[A] The age-specific fertility rates (ASFR) are the number of live births in the last 3 years, divided by the average number of women in that age group during the same period, expressed per 1,000 women."			
    "[B] TFR: The Total Fertility Rate is the sum of age-specific fertility rates of women age 15-49 years. "+
    "The TFR denotes the average number of children to which a woman will have given birth by the end of her reproductive years (by age 50) if current fertility rates prevailed. The rate is expressed per woman age 15-49 years"		
    "[C] GFR: The General Fertility Rate is the number of births in the last 3 years divided by the average number of women age 15-49 years during the same period, expressed per 1,000 women age 15-49 years"
    "[D] CBR: The Crude Birth Rate is the number of births in the last 3 years, divided by the total population during the same period, expressed per 1,000 population"
   corner = "Age [A]".		

use all.
if (age5=1) asfr1519 = asfr.
if (age5<>1) asfr1519 = lag(asfr1519).
variable labels asfr1519 'Adolescent birth rate [1] (Age-specific fertility rate for women age 15-19 years) [A]'.
compute sel = (colper = 0 and age5 = 7).
filter by sel.

ctables
   /table  total[c] + hh6[c] + hh7[c] + welevel [c] + disability [c] + ethnicity[c] + windex5[c]  BY
      asfr1519[s][mean '' comma5.0]+tfr[s][maximum '' f5.1]
   /categories variables=all empty=exclude missing=exclude
   /titles
    title=
    "Table TM.2.1: Adolescent birth rate and total fertility rate"
    "Adolescent birth rates and total fertility rates for the three-year period preceding the survey, "+ surveyname
    caption=
    "[1] MICS indicator TM.1 - Adolescent birth rate (age 15-19 years);SDG indicator 3.7.2"
    "[A] Please see Table TM.1.1 for definitions.".

new file.

*erase the working files.
erase file = 'tmpfert.sav'.
