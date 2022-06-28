* Encoding: windows-1252.

 * "Those report discriminatory attitutes towards people living with HIV are those that respond 'no' to both HA30 and HA31 (HA30=2 and HA31=2), tabulated 
seperately in the two previous columns.

 * The five following columns are those who respond 'yes' to each of the matching questions, i.e. HA32=1, HA33=1, HA34=1, HA35=1 and HA36=1.

 * The denominator includes only women who have heard of AIDS (HA1=1)."											

***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1 and HA1=1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

compute discriminatory=0.
if (food =100 or school=100) discriminatory=100.
variable labels discriminatory "Report discriminatory attitutes towards people living with HIV [1] [A]".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of women who:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of women who think people:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women who have heard of AIDS".

variable labels disability "Functional difficulties (age 18-49 years)".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* ctables command in English.
ctables
  /vlabels variables =  numWomen layer1 layer2  total
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
         layer1 [c] > (
             food  [s] [mean '' f5.1]
           + school [s] [mean '' f5.1]
           + discriminatory [s] [mean '' f5.1]) +
          layer2 [c] > ( 
            hesitate [s] [mean '' f5.1]
           + talkbadly [s] [mean '' f5.1]
           + respect [s] [mean '' f5.1] ) +
          layer1 [c] > (
            ashamed [s] [mean '' f5.1]
           + fear [s] [mean '' f5.1])
         + numWomen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.3W: Attitudes towards people living with HIV (women)"
    "Percentage of women age 15-49 years who have heard of AIDS and report discriminating attitudes towards people living with HIV, " + surveyname
   caption =
    "[1] MICS indicator TM.31 - Discriminatory attitudes towards people living with HIV"					
    "[A] This is a composite indicator of those who would not buy fresh vegetables from a shopkeeper or vendor who is HIV-positive or think children living with HIV should not be allowed to attend school with children who do not have HIV"
    "[B] As part of respondent protection, those who answered that they are HIV-positive have been recoded to “No”, and thus treated as having no fear of contracting HIV"										
  .

new file.
