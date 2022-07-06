* MICS5 NU-07.

* v02 - 2014-03-05.

* Infants receiving solid, semi-solid, or soft foods the previous day: At least one 1 "Yes" to any food item in BD8..

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 8).


* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS5 - 03 - NU.sps' .

compute ctotal = 1.
variable labels ctotal "Number of children age 6-8 months".
value labels ctotal 1 "".

compute appropAll = 0.
if (solidSemiSoft) appropAll = 100.
variable labels appropAll "All".

do if (BD3 = 1).
+ compute appropBreastfed = 0.
+ if (solidSemiSoft) appropBreastfed = 100.
end if.
variable labels appropBreastfed "Currently breastfeeding".

do if (BD3 <> 1 or sysmis(BD3)).
+ compute appropNotBreastfed = 0.
+ if (solidSemiSoft) appropNotBreastfed = 100.
end if.
variable labels appropNotBreastfed "Currently not breastfeeding".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
   by
           appropBreastfed    [s] [mean,'Percent receiving solid, semi-solid or soft foods',f5.1,
                                   validn 'Number of children age 6-8 months' f5.0]
         + appropNotBreastfed [s] [mean,'Percent receiving solid, semi-solid or soft foods',f5.1,
                                   validn 'Number of children age 6-8 months' f5.0]
         + appropAll          [s] [mean,'Percent receiving solid, semi-solid or soft foods [1]',f5.1,
                                   validn 'Number of children age 6-8 months' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
     "Table NU.7: Introduction of solid, semi-solid, or soft foods"
     "Percentage of infants age 6-8 months who received solid, semi-solid, or soft foods during the previous day, " + surveyname
  caption=
     "[1] MICS indicator 2.13 - Introduction of solid, semi-solid or soft foods"
  .

new file.
