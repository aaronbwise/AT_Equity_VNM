* MICS5 NU-02.

* v02 - 2014-03-05.
* v03 - 2014-07-18. 
* Label whAbove 1 'Above'/ changed to whAbove 1 'Percent Above'/.
* v04 - 2014-08-19.
*Age categories corrected to correspond to the latest version of tab plan.


* The first two columns for each anthropometric indicator refer to children whose z-scores for the anthropometric indicator (ie the exact number
  of standard deviations from the median) fall below -2 standard deviations (moderately and severely underweight, stunted, or wasted) and -3
  standard deviations (severely underweight, stunted, or wasted) from the median of the WHO Child Growth Standards for the same anthropometric
  indicator.
* The table also includes mean z-scores for each anthropometric indicator, as well as the percentage of children who are overweight, which takes
  into account those children whose weight for height is above 2 standard deviations from the median of the WHO Child Growth Standards.

* The percent ‘below –2 standard deviations’ includes those who fall below -3 standard deviations from the median.

* Denominators for weight for age, height for age, and weight for height may be different.
* Children who were not weighed, who were weighed but had flagged (outlying) weight measurements, and children who did not have both month and
  year of birth are excluded from the weight for age (underweight) calculations.
* Children whose heights were not measured, who had flagged (outlying) height measurements, and who did not have both month and year of birth are
  excluded from the height for age (stunting) calculations. For the weight for height (wasting) indicator, only children with both valid weight
  and height measurements are included. The denominator of this indicator includes children without full date of birth information.

* Indices used in this table are not comparable to those based on the NCHS/CDC/WHO reference.
* The nutritional status table based on the NCHS/CDC/WHO reference can be produced if needed.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

do if (wazflag = 0).
+ recode WAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into wa2sd.
+ recode WAZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into wa3sd.
+ compute waMean = WAZ2.
+ compute waCount = 1.
else.
+ compute wa2sd = $SYSMIS.
+ compute wa3sd = $SYSMIS.
end if.
variable labels wa2sd "- 2 SD [1]".
variable labels wa3sd "- 3 SD [2]".
variable labels waMean "Mean Z-Score (SD)".
variable labels waCount "Number of children under age 5".

do if (hazflag = 0).
+ recode HAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into ha2sd.
+ recode HAZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into ha3sd.
+ compute haMean = HAZ2.
+ compute haCount = 1.
else.
+ compute ha2sd = $SYSMIS.
+ compute ha3sd = $SYSMIS.
end if.
variable labels ha2sd "- 2 SD [3]".
variable labels ha3sd "- 3 SD [4]".
variable labels haMean "Mean Z-Score (SD)".
variable labels haCount "Number of children under age 5".

do if (whzflag = 0).
+ recode WHZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 100) into wh2sd.
+ recode WHZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 100) into wh3sd.
+ recode WHZ2 (sysmis=sysmis) (lo thru +2.00 = 0) (else = 100) into wh2sdAbove.
+ compute whMean = WHZ2.
+ compute whCount = 1.
else.
+ compute wh2sd = $SYSMIS.
+ compute wh3sd = $SYSMIS.
+ compute wh2sdAbove = $SYSMIS.
end if.
variable labels wh2sd " - 2 SD [5]".
variable labels wh3sd "- 3 SD [6]".
variable labels wh2sdAbove "+ 2 SD [7]".
variable labels whMean "Mean Z-Score (SD)".
variable labels whCount "Number of children under age 5".


compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* generate layers .
compute waPercentBelow = 1 .
compute haPercentBelow = 1 .
compute whPercentBelow = 1 .
compute whAbove = 1 .
compute underweight = 1 .
compute stunted = 1 .
compute wasted = 1 .
compute overweight = 1 .
compute weightForAge = 1 .
compute heightForAge = 1 .
compute weightForHeight = 1 .

value labels
  weightForAge 1 'Weight for age'/
  heightForAge 1 'Height for age'/
  weightForHeight 1 'Weight for height'/
  waPercentBelow haPercentBelow whPercentBelow 1 'Percent below'/
  whAbove 1 'Percent above'/
  underweight 1 'Underweight'/
  stunted 1 'Stunted'/
  wasted 1 'Wasted'/
  overweight 1 'Overweight' .

recode cage
  (0 thru 5 = 1)
  (6 thru 11 = 2)
  (12 thru 17 = 3)
  (18 thru 23 = 4)
  (24 thru 35= 5)
  (36 thru 47= 6)
  (else = 7) into childAge7.
variable labels childAge7 "Age".

value labels childAge7
  1 "0-5 months"
  2 "6-11 months"
  3 "12-17 months"
  4 "18-23 months"
  5 "24-35 months"
  6 "36-47 months"
  7 "48-59 months".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = weightForAge heightForAge weightForHeight
                       waPercentBelow haPercentBelow whPercentBelow whAbove
                       underweight stunted wasted overweight
           display=none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + childAge7 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
     by
           weightForAge [c] > (
             underweight [c] >
               waPercentBelow [c] > (
                 wa2sd [s] [mean f5.1]
               + wa3sd [s] [mean f5.1] )
           + waMean [s] [mean f5.1] )
         + waCount [s] [validn f5.0]
         + heightForAge [c] > (
             stunted [c] >
               haPercentBelow [c] > (
                 ha2sd [s] [mean f5.1]
               + ha3sd [s] [mean f5.1] )
           + haMean [s] [mean f5.1] )
         + haCount [s] [validn f5.0]
         + weightForHeight [c] > (
             wasted [c] >
               whPercentBelow [c] > (
                 wh2sd [s] [mean f5.1]
               + wh3sd [s] [mean f5.1] )
           + overweight [c] >
               whAbove [c] >
                 wh2sdAbove [s] [mean f5.1]
           + whMean [s] [mean f5.1] )
         + whCount [s] [validn f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible = no
  /title title=
     "Table NU.2: Nutritional status of children"
     "Percentage of children under age 5 by nutritional status according to three anthropometric " +
     "indices: weight for age, height for age, and weight for height," + surveyname
   caption=
     "[1] MICS indicator 2.1a and MDG indicator 1.8 - Underweight prevalence (moderate and severe)"
     "[2] MICS indicator 2.1b - Underweight prevalence (severe)"
     "[3] MICS indicator 2.2a - Stunting prevalence (moderate and severe)"
     "[4] MICS indicator 2.2b - Stunting prevalence (severe)"
     "[5] MICS indicator 2.3a - Wasting prevalence (moderate and severe)"
     "[6] MICS indicator 2.3b - Wasting prevalence (severe)"
     "[7] MICS indicator 2.4 - Overweight prevalence" .

new file.
