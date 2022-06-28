* Encoding: windows-1252.
* MICS6 TC-7.6.
***.
* v02 - 2020-04-23. Labels in French and Spanish have been removed.
***.
 * Infants receiving solid, semi-solid, or soft foods the previous day: At least one 1 "Yes" to any food item in BD8.

 * In many surveys, the sample of of children age 6-8 months currently not breastfeeding is very small and all results in this coumn must be suppressed. If this is the case, you 
 should present ony the results for all children, i.e. delete the first two sets of columns, and add a note explaining that results cannot be disaggregated due to the low number of children currently not breastfeeding.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 8).

* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS6 - 07 - TC.sps' .

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

* Ctables command in English.
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
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
     "Table TC.7.6: Introduction of solid, semi-solid, or soft foods"
     "Percentage of infants age 6-8 months who received solid, semi-solid, or soft foods during the previous day, " + surveyname
  caption=
     "[1] MICS indicator TC.38 - Introduction of solid, semi-solid or soft foods"
  .
   
new file.
