* Encoding: windows-1252.
 * Women who have ever had sex: SB1>00.

 * Women who had sex in the last 12 months: SB2<401.

 * Women who had more than one partner in the last 12 months: SB7=1.

 * Women who had sex in the last 12 months with more than one partner, who used a condom last time they had sex: SB7=1 and SB3=1.

 * The denominator for MICS indicator TM.24 is women who had more than one partner in the last 12 month, as shown above (SB7=1).


***.
* v02 - 2019-03-14.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women".

* ctables command in English.
ctables
  /vlabels variables = total numWomen layer numWomenMorePartners 
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wagez [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
           layer [c]  > (
             sexEver [s] [mean '' f5.1]
           + sex12 [s] [mean '' f5.1]
           + morePartners [s] [mean '' f5.1] )
         + numWomen [c] [count '' f5.0]
         + usedCondom [s] [mean '' f5.1]
         + numWomenMorePartners [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.10.1W: Sex with multiple partners (women)"
                  "Percentage of women age 15-49 years who ever had sex, percentage who had sex in the last 12 months, " +
                  "percentage who had sex with more than one partner in the last 12 months, and among those who had sex " +
                  "with multiple partners in the last 12 months, the percentage who used a condom at last sex," + surveyname						
   caption=
    "[1] MICS indicator TM.22 - Multiple sexual partnerships"
    "[2] MICS indicator TM.23 - Condom use at last sex among people with multiple sexual partnerships"
  .

new file.
