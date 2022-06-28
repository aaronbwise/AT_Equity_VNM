* Encoding: windows-1252.

* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Men who have fathered a live birth are those with MCM11 = 1.

* Ages at first birth are MCM17 (Age of first live birth if multiple children) and, if only one child, the date of birth of his only child (MCM18A) 
and the date of birth of the man (MWB3). Dates of birth for men and first births are first converted into century month codes (CMC) (see Table TM.2.2W). 
* The CMC of the man's birth date is then subtracted from the CMC of the birth date of the first child, and divided by 12 to obtain the man's age in years at the time of first birth.

* Please see Table TM.2.2W for additional information on CMC calculation and on how incomplete data is handled.

***.

include "surveyname.sps".

get file = 'mn.sav'.

do if (MCM17<98).
+ compute mdobfc = MCM17*12+mwdob.
end if.

do if (sysmis(MCM17) and MCM18M<99 and MCM18Y<9999).
+ compute mdobfc = (MCM18Y-1900)*12+MCM18M.
end if.

select if (MWM17 = 1).

weight by mnweight.

recode MCM11 (sysmis = 0) .

do if (MWB4 >=15 and MWB4<=19).
+ compute numMan15 = 1.
+ compute hadBirth = 0.
+ if (MCM11 > 0) hadBirth = 100.
+ compute birthBefore15 = 0.
+ if ((mdobfc - mwdob)/12 < 15) birthBefore15 = 100.
end if.

variable labels
   numMan15 "Number of men age 15-19 years"
  /hadBirth "Fathered a live birth"
  /birthBefore15 "Fathered a live birth before age 15"
  .
 	
do if (MWB4 >=20 and MWB4 <= 24).
+ compute numMan20 = 1.
+ compute birthBefore18 = 0.
+ if ((mdobfc - mwdob)/12 < 18) birthBefore18 = 100.
end if.

variable labels
   numMan20 "Number of men age 20-24 years"
  /birthBefore18 "Percentage of men age 20-24 years who have fathered a live birth before age 18"
  .

compute layer = 0.
value labels layer 0 "Percentage of men age 15-19 years who have:".
variable labels layer " ".

compute total = 1.
variable labels total "Total".
value labels total 1" ".

* Ctables command in English.
ctables
  /vlabels variables = layer
           display = none
  /table   total [c]
         + HH6 [c]
         + hh7 [c]
         + mwelevel [c]
         + mdisability [c]
         + ethnicity[c]
         + windex5 [c]     
   by
           layer [c] > (
             hadBirth [s] [mean '' f5.1]
           + birthBefore15 [s] [mean '' f5.1] )
         + numMan15 [s] [sum '' f5.0]
         + birthBefore18 [s] [mean '' f5.1]
         + numMan20 [s] [sum '' f5.0]
  /slabels position=column visible =no
  /categories variables=all empty=exclude missing=exclude
  /titles title=
                 "Table TM.2.2M: Early fatherhood (young men)"			
                 "Percentage of men age 15-19 years who have fathered a live birth and who have fathered a live birth before age 15, " +
                 "and percentage of men age 20-24 years who have fathered a live birth before age 18, " + surveyname
.

new file.
