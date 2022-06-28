* Encoding: windows-1252.
 * "Those who report discriminatory attitutes towards people living with HIV are those that respond 'no' to both MHA30 and MHA31 (MHA30=2 and MHA31=2), tabulated 
   seperately in the two preceding columns.

 * The five following columns are those who respond 'yes' to each of the matching questions, i.e. MHA32=1, MHA33=1, MHA34=1, MHA35=1 and MHA36=1.

 * The denominator includes only men who have heard of AIDS (MHA1=1)."											

***.

* v02.2019-03-14.
* v03 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Table sub-title changed based on the latest tab plan. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1 and MHA1=1).

weight by mnweight.

* include TM.M . 
include 'define\MICS6 - 06 - TM.M.sps' .

compute discriminatory=0.
if (food =100 or school=100) discriminatory=100.
variable labels discriminatory "Report discriminatory attitutes towards people living with HIV [1] [A]".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of men who:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of men who think people:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men who have heard of AIDS".

variable labels mdisability "Functional difficulties (age 18-49 years)".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  numMen layer1 layer2  total
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
         + numMen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.3M: Attitudes towards people living with HIV (men)"
    "Percentage of men age 15-49 years who have heard of AIDS and report discriminating attitudes towards people living with HIV, " + surveyname
   caption =
    "[1] MICS indicator TM.31 - Discriminatory attitudes towards people living with HIV"					
    "[A] This is a composite indicator of those who would not buy fresh vegetables from a shopkeeper or vendor who is HIV-positive or think children living with HIV should not be allowed to attend school with children who do not have HIV"	
    "[B] As part of respondent protection, those who answered that they are HIV-positive have been recoded to “No”, and thus treated as having no fear of contracting HIV"		
  .

new file.
