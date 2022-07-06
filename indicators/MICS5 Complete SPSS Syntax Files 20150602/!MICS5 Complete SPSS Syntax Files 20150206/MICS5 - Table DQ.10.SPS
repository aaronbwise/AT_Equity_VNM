* Updated 4/13/2015.
* weight by wmweight added to the syntax.

* Separatly for the first birth.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'wm.sav'.

weight by wmweight.

select if (WM7 = 1).

select if (CM1 = 1).

compute layer = 1.
compute layer1 = 1.
compute layer2 = 1.
compute tot1 = 100.
compute total = 1.

* separatly for first birth.
compute fbmyb = 0.
compute fbyab   = 0.
compute fbab   = 0.
compute fbnd   = 0.

if (CM2M < 97 and CM2Y < 9997) fbmyb = 100.  
if (CM2M >= 97 and CM2Y< 9997) fbyab = 100.  
if (CM2M >= 97 and CM2Y >= 9997 and CM3 < 97) fbab = 100.  
if (fbmyb=0 and fbyab=0 and fbab=0) fbnd=100.

compute bnfirst = 1.

*..and last birth.

do if (CM10 > 1).

+ compute lbmyb = 0.
+ compute lbyab   = 0.
+ compute lbab   = 0.
+ compute lbnd   = 0.

+ if (CM12M < 97 and CM12Y < 9997) lbmyb = 100.  
+ if (CM12M >= 97 and CM12Y < 9997) lbyab = 100.  
+ if (lbmyb = 0 and lbyab = 0) lbnd=100.

+ compute bnlast = 1.

end if. 

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels bnfirst " ".
value labels bnfirst 1 "Number of first births" .
variable labels fbmyb "Year and month of birth".
variable labels fbyab "Year of birth only".
variable labels fbab "Completed years since first birth only".
variable labels fbnd "Other/DK/Missing".
value labels layer1 1 " Date of first birth".
value labels bnlast 1 "Number of last births" .
variable labels lbmyb "Both month and year".
variable labels lbyab "Year only".
variable labels lbnd "Other/DK/Missing".
value labels layer2 1 "Date of last birth".
value labels layer 1 "Completeness of reporting of date of birth".

ctables
  /vlabels variables = layer layer1 layer2 bnfirst bnlast
         display = none
   /table total [c] + hh7 [c] + hh6 [c] by 
    layer [c] >
   (layer1 [c] > (fbmyb [s] [mean,'',f5.1] +fbyab [s] [mean,'',f5.1] + fbab [s] [mean,'',f5.1] + fbnd [s] [mean,'',f5.1]) + tot1 [s] [mean,'',f5.1] + bnfirst [c] [count,'',f5.0] +
    layer2 [c] > (lbmyb [s] [mean,'',f5.1] +lbyab [s] [mean,'',f5.1] + lbnd [s] [mean,'',f5.1]) + tot1 [s] [mean,'',f5.1] + bnlast [c] [count,'',f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.10: Birth date reporting: First and last births"
   "Percent distribution of first and last births to women age 15-49 years by completeness of date of birth, " + surveyname.
								
new file.		
