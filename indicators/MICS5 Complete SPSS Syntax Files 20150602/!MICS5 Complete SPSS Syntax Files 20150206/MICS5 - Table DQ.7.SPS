* Updated 4/13/2015.
* weight by mnweight added to the syntax.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the men data file.
get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute mmyb = 0.
compute myab   = 0.
compute myb   = 0.
compute mab   = 0.
compute mnd   = 0.

if (MWB1M < 97 and MWB1Y < 9997) mmyb = 100.  
if (MWB1M >= 97 and MWB1Y < 9997 and MWB2 < 97) myab = 100.  
if (MWB1M >= 97 and MWB1Y >= 9997 and MWB2 < 97) mab = 100.  
if (MWB1M >= 97 and MWB1Y < 9997 and MWB2 >= 97) myb = 100.  
if (mmyb = 0 and myab = 0 and myb = 0 and mab = 0) mmd=100.
compute mn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels mn " ".
value labels mn 1 "Number of men age 15-49 years" .
variable labels mmyb "Year and month of birth".
variable labels myab "Year of birth and age".
variable labels myb "Year of birth only".
variable labels mab "Age only".
variable labels mnd "Other/DK/Missing".
value labels layer 1 " Completeness of reporting of date of birth and age".

ctables
  /vlabels variables = layer mn
         display = none
   /table total [c] + hh7 [c] + hh6 [c] by 
    layer [c] > (mmyb [s] [mean,'',f5.1] +myab [s] [mean,'',f5.1] + myb [s] [mean,'',f5.1] +
    mab [s] [mean,'',f5.1] + mnd [s] [mean,'',f5.1]) + tot1 [s] [mean,'',f5.1] + mn [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.7: Birth date and age reporting: Men"
   "Percent distribution of men age 15-49 years by completeness of date of birth/age information, " + surveyname.
					
new file.		

