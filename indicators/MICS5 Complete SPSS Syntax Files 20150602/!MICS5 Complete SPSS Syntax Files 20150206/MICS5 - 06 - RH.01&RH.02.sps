* MICS5 RH-01.

* v01 - 2013-03-18.
* v02 - 2015-04-21.
* RH.2: The Adolescent birth rate column has “years” added behind “age 15-19”.



* The age-specific fertility rate is defined as the number of live births to women in a specific age group during a specified period, 
  divided by the average number of women in that age group during the same period, expressed per 1000 women. 
* The age-specific fertility rate for women age 15-19 years is also termed as the adolescent birth rate.

* The total fertility rate (TFR) is calculated by summing the age-specific fertility rates calculated for each of the 5-year age groups of 
  women, from age 15 through to age 49. 
* The TFR denotes the average number of children to which a woman will have given birth by the end of her reproductive years (by age 50) if 
  current fertility rates prevailed.

* The general fertility rate (GFR) is the number of live births to women age 15-49 years during a specified period, divided by the average 
  number of women in the same age group during the same period, expressed per 1,000 women.

* The crude birth rate (CBR) is the number of live births during a specified period, divided by the total population during the same period, 
  expressed per 1,000 population.

* Rates are calculated for the three-year (1-36 months) period preceding the survey, based on data collected in birth histories, 
  when the Fertility/Birth History module is included in the survey. 
* The month of interview is ignored, as it would represent a censored (incomplete) period of observation.

* If the Fertility module (which excludes the Birth History) is included, all fertility rates are calculated by using information on the date 
  of last birth of each woman (CM12) and are based on the one-year period (1-12 months) preceding the survey. 
* Rates are underestimated by a very small margin due to the absence of information on multiple births (twins, triplets etc.) and on 
  multiple deliveries women may have had during the one year period preceding the survey. 
* The month of interview is ignored for the same reason as indicated above.

* When the latter approach is used to estimate fertility rates, numerators and denominators should be carefully checked for the total and 
  urban-rural samples to ensure that they are based on sufficient numbers of cases. 
* In particular, use of a one-year estimation period may result in very small denominators, even for the urban-rural domains of estimation.

* See notes below RH.2.
* SPSS produces working tables that show the numerators and denominators of all age-specific fertility rates.
* Unweighted denominators of the age-specific fertility rates of the 15-19 age group (the adolescent birth rates) should be thoroughly checked 
  before finalizing the adolescent birth rates in this table.
* Adolescent birth rates based on fewer than 125 unweighted cases should not be shown (should be replaced with '*'); 
  rates based on 125 to 249 cases should be shown in parentheses.

* If, for any TFR in the table, any of the 5-year age-specific fertility rates from age 15-19 years to 40-44 years is based on less than 125 
  unweighted cases, the TFR should not be shown.
* If at least one ASFR is based on 125 to 249 unweighted cases, the TFR should be shown in parentheses.
* Note that this exercise is carried out without taking the denominators of the age-specific fertility rate for the 45-49 age group into account.

* Detailed information on these reporting conventions can be found on childinfo.org.

* Denominators for many background categories may be too small in some surveys, especially when rates are calculated for the one-year period 
  preceding the survey. 
* Upon checking the unweighted denominators of the age-specific fertility rates, as described above, background categories may need to be 
  grouped together or re-constructed to produce estimates of fertility rates based on sufficient numbers.
* For example, in some surveys, the wealth index will need to be re-designed into two or three categories, such as: "Poorest 30 percent", 
  "Middle 40 percent" and "Richest 30 percent", as reporting on adolescent birth rates or total fertility rates for each of the quintiles may 
  not be possible.
* It may also be necessary to recode regions together to increase the sizes of denominators.

***.
include "surveyname.sps".

* Main program - calls.
*  MICS5 - 06 - fert_b.sps  for calculation of births.
*  MICS5 - 06 - fert_e.sps  for calculation of exposure.
*  MICS5 - 06 - fert_p.sps  for calculation of live births during a specified period, divided by the total population during the same period,.
*  MICS5 - 06 - fert_c.sps  for calculation of probabilities and rates, and final tables.

define runfert (backvar = !tokens(1) / backval = !tokens(1)).
get file='bh.sav'.
!if (!backvar=total) !then
compute !backvar=!backval.
execute.
!ifend
select if (!backvar=!backval).
compute period=36.
compute maxper=5.
include 'MICS5 - 06 - fert_B.sps'.
get file='wm.sav'.
!if (!backvar=total) !then
compute !backvar=!backval.
execute.
!ifend
select if (WM7 = 1 and !backvar=!backval).
compute period=36.
compute maxper=5.
include 'MICS5 - 06 - fert_E.sps'.
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
include 'MICS5 - 06 - fert_P.sps'.
include 'MICS5 - 06 - fert_C.sps'.
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

* Clear output file before starting.
erase file='tmpfert.sav'.

* National mortality estimates.
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
'(No education)'
!enddefine.
runfert backvar=welevel backval=1.

define subgroupname ()
'(Primary)'
!enddefine.
runfert backvar=welevel backval=2.

define subgroupname ()
'(Secondary)'
!enddefine.
runfert backvar=welevel backval=3.

define subgroupname ()
'(Higher)'
!enddefine.
runfert backvar=welevel backval=4.

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

* Ethnicity of household head.
define subgroupname ()
'(Ethnicity 1)'
!enddefine.
runfert backvar=ethnicity backval=1.

define subgroupname ()
'(Ethnicity 2)'
!enddefine.
runfert backvar=ethnicity backval=2.

* Produce final output tables.

get file='tmpfert.sav'.

variable labels hh7 'Region'.
variable labels hh6 'Area'.
variable labels welevel "Education".
variable labels windex5 'Wealth index quintiles'.
variable labels ethnicity 'Ethnicity of household head'.
variable labels total 'Total'.

value labels hh7 1 'Region 1' 2 'Region 2' 3 'Region 3' 4 'Region 4'.
value labels hh6 1 'Urban' 2 'Rural'.
value labels welevel 1 'None' 2 'Primary' 3 'Secondary' 4 'Higher'.
value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 'Group 1' 2 'Group 2' .
value labels total 1 ' '.

add value labels age5 1 "15-19 [1]".

use all.
compute sel = (colper = 0).
filter by sel.

ctables
  /vlabels variables=age5 asfr display = none
  /table asfr[s][mean,'',comma5.0]>age5[c]+tfr[s][maximum,'',f5.1]+gfr[s][maximum,'',f5.1]+cbr[s][sum,'',f5.1] by hh6[c]+total[c]
  /categories var=all empty=exclude missing=exclude
  /slabels position=row
  /titles title = "Table RH.1: Fertility rates"
                    "Adolescent birth rate, age-specific and total fertility rates, the general fertility rate, and the crude birth rate for the one-year / three-year period preceding the survey, "+
                  	"by area, " + surveyname
   caption =  "1 MICS indicator 5.1; MDG indicator 5.4 - Adolescent birth rate"			
	"[a] TFR: Total fertility rate expressed per woman age 15-49 years"			
	"[b] GFR: General fertility rate expressed per 1,000 women age 15-49 years"
	"[c] CBR: Crude birth rate expressed per 1,000 population"
   corner = "Age".		
			
use all.
if (age5=1) asfr1519 = asfr.
if (age5<>1) asfr1519 = lag(asfr1519).
variable labels asfr1519 'Adolescent birth rate [1] (Age-specific fertility rate for women age 15-19 years)'.
compute sel = (colper = 0 and age5 = 7).
filter by sel.

ctables
   /table  total[c] + hh7[c] + welevel [c]+ windex5[c] + ethnicity[c] BY
      asfr1519[s][mean,'',comma5.0]+tfr[s][maximum,'',f5.1]
   /categories var=all empty=exclude missing=exclude
   /titles
    title=
    "Table RH.2: Adolescent birth rate and total fertility rate",""
    "Adolescent birth rates and total fertility rates for the one-year / three-year period preceding the survey, "+ surveyname
    caption=
    "[1] MICS indicator 5.1; MDG indicator 5.4 - Adolescent birth rate".	

new file.

*erase the working files.
erase file = 'tmpfert.sav'.
