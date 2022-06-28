* Encoding: windows-1252.

***.
* v02 - 2020-04-14. “last” has been added to the second layer (layer2) header in row 4: “Date of last live birth” . Labels in French and Spanish have been removed.

* Separatly for the first birth.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'wm.sav'.

weight by wmweight.

select if (WM17 = 1).

select if (CM1 = 1 or (CM1 = 2 and CM8 = 1)).

compute layer = 1.
compute layer1 = 1.
compute layer2 = 1.
compute tot1 = 100.
compute total = 1.

* separatly for first birth.
compute fbmyb = 0.
compute fbyb   = 0.
compute fbab   = 0.
compute fbnd   = 0.

if (BH4M_first < 97 and BH4Y_first < 9997) fbmyb = 100.  
if (BH4M_first >= 97 and BH4Y_first< 9997) fbyb = 100.  
if (BH4M_first >= 97 and BH4Y_first >= 9997 and BH6_first < 97) fbab = 100.  
if (fbmyb=0 and fbyb=0 and fbab=0) fbnd=100.

compute bnfirst = 1.

*..and last birth.

do if (CM11 > 1).

+ compute lbmyb = 0.
+ compute lbyb   = 0.
+ compute lbnd   = 0.

+ if (BH4M_last < 97 and BH4Y_last < 9997) lbmyb = 100.  
+ if (BH4M_last >= 97 and BH4Y_last < 9997) lbyb = 100.  
+ if (lbmyb = 0 and lbyb = 0) lbnd=100.

+ compute bnlast = 1.

end if. 

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .					
value labels bnfirst 1 "Number of first live births" .
variable labels fbmyb "Year and month of birth".
variable labels fbyb "Year of birth only".
variable labels fbab "Completed years since first birth only".
variable labels fbnd "Other/DK/Missing".
value labels layer1 1 " Date of first live birth".
value labels bnlast 1 "Number of most recent live births" .
variable labels lbmyb "Year and month of birth".
variable labels lbyb "Year of birth only".
variable labels lbnd "Other/DK/Missing".
value labels layer2 1 "Date of last live birth".
value labels layer 1 "Completeness of reporting of date of birth".

* Ctables command in English.
ctables
  /vlabels variables = layer layer1 layer2 bnfirst bnlast
         display = none
   /table total [c] + hh6 [c] + hh7 [c] by 
    layer [c] >
   (layer1 [c] > (fbmyb [s] [mean '' f5.1] +fbyb [s] [mean '' f5.1] + fbab [s] [mean '' f5.1] + fbnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + bnfirst [c] [count '' f5.0] +
    layer2 [c] > (lbmyb [s] [mean '' f5.1] +lbyb [s] [mean '' f5.1] + lbnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + bnlast [c] [count '' f5.0])
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.2.3: Birth date reporting (live births)"
   "Percent distribution of first and most recent live births to women age 15-49 years by completeness of date of birth (unimputed), " + surveyname.

new file.		
