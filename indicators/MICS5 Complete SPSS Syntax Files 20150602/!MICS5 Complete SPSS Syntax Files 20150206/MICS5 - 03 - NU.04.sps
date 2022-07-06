* MICS5 NU-04.

* v01 - 2014-03-05.
* v02 - 2014-07-18.
* variable labels updated as per the latest tab plan changes.

* Children exclusively breastfed: Children currently breastfeeding (BD3=1)
  and no other liquid or food given (answer must be 2 "No" for all items in questions BD7
  and BD8).
* Any answer to BD4, BD5, and BD6 is permissible.

* Children predominantly breastfed: Children currently breastfeeding (BD3=1), who are
  either exclusively breastfed or receiving plain water and non-milk liquids only
 (answer must be 2 "No" for BD7 groups [D] (Milk) and [E] (Formula) and for all BD8 food groups).
* BD4, BD5, and BD6 are still permissible.

* Titles of indicators on continued breastfeeding at 1 and 2 years reflect approximations of
  the age ranges covered.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1).

* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS5 - 03 - NU.sps' .

do if (cage >= 0 and cage <= 5).
+ compute childUpTo5 = 100.
end if.
value labels childUpTo5 100 "Children age 0-5 months".

do if (cage >= 12 and cage <= 15).
+ compute breastfed12_15 = 0.
+ if (BD3 = 1) breastfed12_15 = 100.
end if.
variable labels breastfed12_15 "Children age 12-15 months".

do if (cage >= 20 and cage <= 23).
+ compute breastfed20_23 = 0.
+ if (BD3 = 1) breastfed20_23 = 100.
end if.
variable labels breastfed20_23 "Children age 20-23 months".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = childUpTo5 exclusivelyBreastfed predominantlyBreastfed
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           childUpTo5 [c] > (
             exclusivelyBreastfed [s] [mean,'Percent exclusively breastfed [1]',f5.1]
           + predominantlyBreastfed [s] [mean,'Percent predominantly breastfed [2]',f5.1]
           + predominantlyBreastfed [s] [validn,'Number of children',f5.0] )
         + breastfed12_15 [s] [mean,'Percent breastfed (Continued breastfeeding at 1 year) [3]',f5.1,
                               validn,'Number of children',f5.0]
         + breastfed20_23 [s] [mean,'Percent breastfed (Continued breastfeeding at 2 years) [4]',f5.1,
                               validn,'Number of children',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
     "Table NU.4: Breastfeeding"
     "Percentage of living children according to breastfeeding status at selected age groups, " + surveyname
   caption=
     "[1] MICS indicator 2.7 - Exclusive breastfeeding under 6 months"
     "[2] MICS indicator 2.8 - Predominant breastfeeding under 6 months"
     "[3] MICS indicator 2.9 - Continued breastfeeding at 1 year"
     "[4] MICS indicator 2.10 - Continued breastfeeding at 2 years"
  .

new file.
