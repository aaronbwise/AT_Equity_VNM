* MICS5 HA-06.

* v02 - 2014-04-02.
* v03 - 2014-04-22.
*Two extra columns have been inserted (F and G).
*Sub-title has changed to include description of the result.
*In column H, the wording has changed to: 
*“Percentage of men who had more than one sexual partner in the last 12 months reporting that a condom was used the last time they had sex”
*An extra comment has been inserted to describe the algorithm.


* Men who have ever had sex: MSB1>00.

* Men who had sex in the last 12 months: MSB3<401.

* Men who had more than one partner in the last 12 months: MSB8=1.

* Men number of sexual partners in lifetime: MSB15 - women with more than 95 partners enter calculations as having 95 partners.

* Men who had sex in the last 12 months with more than one partner, who used a condom last time they had sex: MSB8=1 and MSB4=1.

* The denominator for MICS indicator 9_13 is men who had more than one partner in the last 12 month, as shown above (MSB8=1).

***.


include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.


* include HA . 
include 'define\MICS5 - 10 - HA.M.sps' .


recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
add value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mwage (1 = 2) (2 = 3) into mwageAux2 .

recode mwage (1, 2 = 1) (3 = 4) (4, 5 = 5) (6, 7 = 6) into mwageAux1 .
variable labels mwageAux1 "Age".
value labels mwageAux1
 1 "15-24"
 2 "    15-19"
 3 "    20-24"
 4 "25-29"
 5 "30-39"
 6 "40-49" .

mrsets
  /mcgroup name=$mwage
   label='Age'
   variables=mwageAux1 mwageAux2 .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men age 15-49 years".

if (sexEver = 100) numSexEver = 1 .
value labels numSexEver 1 "Number of men age 15-49 years who have ever had sex".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total numMen layer numMenMorePartners numSexEver
           display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + $mwage [c]
         + mmstatus [c]
         + mwelevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layer [c]  > (
             sexEver [s] [mean,'',f5.1]
           + sex12 [s] [mean,'',f5.1]
           + morePartners [s] [mean,'',f5.1] )
         + numMen [c] [count,'',f5.0]
		 + numPartners [s] [mean,'',f5.0]
		 + numSexEver [c] [count,'',f5.0]
         + usedCondom [s] [mean,'',f5.1]
         + numMenMorePartners [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.6M: Sex with multiple partners (men)"
    "Percentage of men age 15-49 years who ever had sex, percentage who had sex in the last 12 months, percentage who had sex with more than one " +
	"partner in the last 12 months, mean number of sexual partners in lifetime for men who have ever had sex, and among those who had sex with " +
	"multiple partners in the last 12 months, the percentage who used a condom at last sex, " + surveyname
   caption=
    "[1] MICS indicator 9.12 - Multiple sexual partnerships"
    "[2] MICS indicator 9.13 - Condom use at last sex among people with multiple sexual partnerships"
  .

new file.
