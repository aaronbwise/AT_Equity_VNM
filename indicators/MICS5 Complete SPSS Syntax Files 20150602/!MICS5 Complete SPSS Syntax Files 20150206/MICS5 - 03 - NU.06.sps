* MICS5 NU-06.

* v02 - 2014-03-05.

* Children appropriately breastfed includes children age 0-5 months who are exclusively breastfed
 (see table NU.3) and children age 6-23 months who are currently breastfed (BD3=1) and receiving
 any solid, semi-solid or soft foods (at least one 1 "Yes" to any food item in BD8).

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS5 - 03 - NU.sps' .

do if (cage >= 0 and cage <= 5).
+ compute approp0_5 = exclusivelyBreastfed.
end if.

variable labels approp0_5 "Children age 0-5 months".


do if (cage >= 6 and cage <= 23).
+ compute approp6_23 = 0.
+ if (BD3 = 1 and solidSemiSoft) approp6_23 = 100.
end if.
variable labels approp6_23 "Children age 6-23 months".

do if (cage >= 0 and cage <= 23).
+ compute appropAll = 0.
+ if (cage >= 0 and cage <= 5 and approp0_5 = 100) appropAll = 100.
+ if (cage >= 6 and cage <=23 and approp6_23 = 100) appropAll = 100.
end if.
variable labels appropAll "Children age 0-23 months".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           approp0_5  [s] [mean,'Percent exclusively breastfed [1]',f5.1,
                           validn 'Number of children' f5.0]
         + approp6_23 [s] [mean,'Percent currently breastfeeding and receiving solid, semi-solid or soft foods',f5.1,
                           validn 'Number of children' f5.0]
         + appropAll  [s] [mean,'Percent appropriately breastfed [2]',f5.1,
                          validn 'Number of children' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
     "Table NU.6: Age-appropriate breastfeeding"
     "Percentage of children age 0-23 months who were appropriately breastfed during the previous day, " + surveyname
   caption=
     "[1] MICS indicator 2.7 - Exclusive breastfeeding under 6 months"
     "[2] MICS indicator 2.12 - Age-appropriate breastfeeding"
  .

new file.
