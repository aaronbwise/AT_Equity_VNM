* Encoding: windows-1252.
 * Men who have ever had sex: MSB1>00.

 * Men who had sex in the last 12 months: MSB2<401.

 * Men who had more than one partner in the last 12 months: MSB7=1.

 * Men who had sex in the last 12 months with more than one partner, who used a condom last time they had sex: MSB7=1 and MSB3=1.

 * The denominator for MICS indicator TM.24 is men who had more than one partner in the last 12 month, as shown above (MSB7=1).


***.
* v02 - 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

* ctables command in English.
ctables
  /vlabels variables = total numMen layer numMenMorePartners 
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwagez [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
           layer [c]  > (
             sexEver [s] [mean '' f5.1]
           + sex12 [s] [mean '' f5.1]
           + morePartners [s] [mean '' f5.1] )
         + numMen [c] [count '' f5.0]
         + usedCondom [s] [mean '' f5.1]
         + numMenMorePartners [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.10.1M: Sex with multiple partners (men)"
                  "Percentage of men age 15-49 years who ever had sex, percentage who had sex in the last 12 months, " +
                   "percentage who had sex with more than one partner in the last 12 months, and among those who had sex " +
                   "with multiple partners in the last 12 months, the percentage who used a condom at last sex," + surveyname						
   caption=
    "[1] MICS indicator TM.22 - Multiple sexual partnerships"
    "[2] MICS indicator TM.23 - Condom use at last sex among people with multiple sexual partnerships"
  .

new file.
