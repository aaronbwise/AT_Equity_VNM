* Updated 4/13/2015.
* weight by hhweight added to the syntax.

* Open the household members data file.
get file = 'hl.sav'.

weight by hhweight.

select if (HL6 >= 5 and HL6 <= 24).

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute amyb = 0.
compute ayb   = 0.
compute amb   = 0.
compute nd   = 0.

if (HL5M < 97 and HL5Y < 9997) amyb = 100.  
if (HL5M >= 97 and HL5Y < 9997) ayb = 100.  
if (HL5M < 97 and HL5Y >= 9997) amb = 100.  
if (HL5M >= 97 and HL5Y >= 9997) nd = 100.

compute wn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of children, adolescents and young people age 5-24 years" .
variable labels amyb "Year and month of birth".
variable labels ayb "Year of birth only".
variable labels amb "Month of birth only".
variable labels nd "Both missing".
value labels layer 1 " Completeness of reporting of month and year of birth".

ctables
  /vlabels variables = layer wn
         display = none
   /table total [c] + hh7 [c] + hh6 [c] by 
    layer [c] > (amyb [s] [mean,'',f5.1] +ayb [s] [mean,'',f5.1] + amb [s] [mean,'',f5.1] +
    nd [s] [mean,'',f5.1]) + tot1 [s] [mean,'',f5.1] + wn [c] [count,'',f5.0]  
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.9: Birth date reporting: Children, adolescents and young people"
   "Percent distribution of children, adolescents and young people age 5-24 years by completeness of date of birth information, " + surveyname.				

new file.		
