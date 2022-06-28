* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the under 5 data file.
get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute chmyb = 0.
compute chyab   = 0.
compute chab   = 0.
compute chyb   = 0.
compute cnd   = 0.

if (UB1M < 97 and UB1Y < 9997) chmyb = 100.  
if (UB1M >= 97 and UB1Y < 9997 and UB2 < 7) chyab = 100.  
if (UB1M >= 97 and UB1Y >= 9997 and UB2 < 7 ) chab = 100.  
if (UB1M >= 97 and UB1Y < 9997 and UB2 >= 7 ) chyb = 100.  
if (chmyb = 0 and chyab = 0 and chyb = 0 and chab = 0) cnd = 100.

compute cn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels cn " ".
value labels cn 1 "Number of children under 5" .
variable labels chmyb "Year and month of birth".
variable labels chyab "Year of birth and age".
variable labels chyb "Year of birth only".
variable labels chab "Age only".
variable labels cnd "Other/DK/Missing".
value labels layer 1 "Completeness of reporting of date of birth and age".

* Ctables command in English.
ctables
  /vlabels variables = layer cn
         display = none
   /table total [c] + hh6 [c] + hh7 [c] + UB2 by 
    layer [c] > (chmyb [s] [mean '' f5.1] +chyab [s] [mean '' f5.1] + chyb [s] [mean '' f5.1]  +
    chab [s] [mean '' f5.1] + cnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + cn [c] [count '' f5.0]  
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.2.4: Birth date and age reporting (children under age 5 years)"
   "Percent distribution of children under 5 by completeness of date of birth/age information, " + surveyname.

new file.	
