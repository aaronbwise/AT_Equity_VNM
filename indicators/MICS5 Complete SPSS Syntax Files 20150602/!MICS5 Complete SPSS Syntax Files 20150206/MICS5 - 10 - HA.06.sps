* MICS5 HA-06.

* v02 - 2014-04-02.
* v03 - 2014-04-22.
*Two extra columns have been inserted (F and G).
*Sub-title has changed to include description of the result.
*In column H, the wording has changed to: “Percentage of women who had more than one sexual partner in the last 12 months reporting that a condom was used the last time they had sex”
*An extra comment has been inserted to describe the algorithm.


* Women who have ever had sex: SB1>00.

* Women who had sex in the last 12 months: SB3<401.

* Women who had more than one partner in the last 12 months: SB8=1.

* Mean number of sexual partners in lifetime: SB15 - women with more than 95 partners enter calculations as having 95 partners.

* Women who had sex in the last 12 months with more than one partner, who used a condom last time they had sex: SB8=1 and SB4=1.

* The denominator for MICS indicator 9_13 is women who had more than one partner in the last 12 month, as shown above (SB8=1).

***.


include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.


* include HA . 
include 'define\MICS5 - 10 - HA.sps' .


recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
add value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1 = 2) (2 = 3) into wageAux2 .

recode wage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6) into wageAux1 .
variable labels wageAux1 "Age".
value labels wageAux1
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$wage
   label='Age'
   variables=wageAux1 wageAux2 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women age 15-49 years".

if (sexEver = 100) numSexEver = 1 .
value labels numSexEver 1 "Number of women age 15-49 years who have ever had sex".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total numWomen layer numWomenMorePartners numSexEver
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $wage [c]
         + mstatus [c]
         + welevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             sexEver [s] [mean,'',f5.1]
           + sex12 [s] [mean,'',f5.1]
           + morePartners [s] [mean,'',f5.1] )
         + numWomen [c] [count,'',f5.0]
		 + numPartners [s] [mean,'',f5.0]
		 + numSexEver [c] [count,'',f5.0]
         + usedCondom [s] [mean,'',f5.1]
         + numWomenMorePartners [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table HA.6: Sex with multiple partners (women)"
    "Percentage of women age 15-49 years who ever had sex, percentage who had sex in the last 12 months, " +
	"percentage who had sex with more than one partner in the last 12 months, mean number of sexual partners in lifetime for women who have ever had sex, " +
	"and among those who had sex with multiple partners in the last 12 months, the percentage who used a condom at last sex, " + surveyname						
   caption=
    "[1] MICS indicator 9.12 - Multiple sexual partnerships"
    "[2] MICS indicator 9.13 - Condom use at last sex among people with multiple sexual partnerships"
  .

new file.
