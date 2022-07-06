* Updated 4/13/2015.
* weight by hhweight added to the syntax.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the household members data file.
get file = 'hl.sav'.

weight by hhweight.

* Recode age.
recode HL6 (0 thru 4 = 1 ) (5 thru 14 = 2) (15 thru 24 = 3) (25 thru 49 = 4) (50 thru 64 = 5) (65 thru 84 = 6) (85 thru 96 = 85) (97 thru 99 = 99) into mage.
formats mage (f3.0).
variable labels mage "Age".
value labels mage
	1 "0-4"
	2 "5-14"
	3 "15-24"
	4 "25-49"
	5 "50-64"
	6 "65-84"
	85 	"85+"
 99 	"DK/missing".

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute myb = 0.
compute yb   = 0.
compute mb   = 0.
compute nd   = 0.

if (HL5M < 97 and HL5Y < 9997) myb = 100.  
if (HL5M >= 97 and HL5Y < 9997) yb = 100.  
if (HL5M < 97 and HL5Y >= 9997 ) mb = 100.  
if (HL5M >= 97 and HL5Y>= 9997) nd = 100.

compute wn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of household members".
variable labels myb "Year and month of birth".
variable labels yb "Year of birth only".
variable labels mb "Month of birth only".
variable labels nd "Both missing".
value labels layer 1 " Completeness of reporting of month and year of birth".

ctables
  /vlabels variables = layer wn
         display = none
   /table total [c] + mage [c] +  hh7 [c] + hh6 [c] by 
    layer [c] > (myb [s] [mean,'',f5.1] + yb [s] [mean,'',f5.1] + mb [s] [mean,'',f5.1] +
    nd [s] [mean,'',f5.1]) + tot1 [s] [mean,'',f5.1] + wn [c] [count,'',f5.0]  
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.5: Birth date reporting: Household population"
   "Percent distribution of household population by completeness of date of birth information, " + surveyname.

new file.		
	
