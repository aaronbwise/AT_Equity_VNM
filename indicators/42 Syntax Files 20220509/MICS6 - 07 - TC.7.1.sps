* Encoding: windows-1252.
* MICS6 TC-7.1.
***.
* v02 - 2020-04-23. Labels in French and Spanish have been removed.
***.

 * Children who were ever breastfed: MN36.

 * Children who started breastfeeding within one hour of birth: MN37=000 (immediately) or MN37=100 (within 1 hour).

 * Children who started breastfeeding within one day of birth: MN37=000 (immediately) or (MN37 >= 100 and MN37 <= 123). Includes children who started breastfeeding within one hour of birth.

 * The table is based on responses of women in the Questionnaire for Individual Women on their last-born children in the 2 years preceding the survey.

 * For the disaggregate of place of delivery, some surveys will find very few cases of home births or births in private facilities. Appropriate combinations can be constructed, e.g. combining 
   public and private or separating 'Other' from 'Other/DK/Missing' and adding home deliveries to 'Other'.
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

select if (CM17 = 1).

* Calculate months since last birth IF last birth in last five years.
compute monthsSinceLastBirth = wdoi - wdoblc.
variable labels monthsSinceLastBirth "Months since last birth".

*Create a recoded months variable since last birth.
recode monthsSinceLastBirth (0 thru 11 = 1)(12 thru 24 = 2) into monthsSinceLastBirthGroups.
variable labels monthsSinceLastBirthGroups "Months since last birth".
value labels monthsSinceLastBirthGroups 
1 " 0-11 months" 
2 "12-23 months".

compute everBreastfed = 0.
if (MN36 = 1) everBreastfed = 100.
variable labels everBreastfed "Percentage who were ever breastfed [1]".

compute layer = 1.
value labels layer 1 "Percentage of children who were first breastfed:".

compute within1hour = 0.
if ((MN37U = 1 and MN37N = 0) or MN37U  = 0) within1hour = 100.
variable labels within1hour "Within one hour of birth [2]".

compute within1day = 0.
if (MN37U = 0 or MN37U = 1) within1day = 100.
variable labels within1day "Within one day of birth".

compute numChildren = 1.
value labels numChildren 1 "Number of most recent live-born children to women with a live birth in the last 2 years".

compute total = 1.
value labels total 1 " ".
variable labels total "Total".

variable labels welevel "Mother’s education".
variable labels disability "Mother's functional difficulties".

* Ctables command in English.
ctables
  /vlabels variables = numChildren layer  
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + monthsSinceLastBirthGroups [c]
        + welevel [c]
        + personAtDelivery1 [c]
        + $deliveryPlace [c]
        + deliveryType [c]
        + disability[c]
        + ethnicity [c]
        + windex5 [c]
   by
          everBreastfed[s][mean '' f5.1]
        + layer [c] > (
            within1hour[s][mean '' f5.1]
          + within1day[s][mean '' f5.1] )
         + numChildren[c][count '' f5.0]
  /slabels visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
        "Table TC.7.1: Initial breastfeeding"
        "Percentage of most recent live-born children to women age 15-49 years with a live birth in the last two years who were ever breastfed, breastfed within one hour of birth and within one day of birth, " + surveyname
  caption=
        "[1] MICS indicator TC.30 - Children ever breastfed"
        "[2] MICS indicator TC.31 - Early initiation of breastfeeding" 
      .							

new file.
