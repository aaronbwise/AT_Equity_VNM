* Encoding: windows-1252.

***.
* v02 - Updated 4/13/2015: weight by wmweight added to the syntax.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'wm.sav'.

select if (WM17 = 1).

weight by wmweight.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute wmyb = 0.
compute wyab   = 0.
compute wyb   = 0.
compute wab   = 0.
compute wnd   = 0.

* Year and month of birth.
if (WB3M < 97 and WB3Y < 9997) wmyb = 100.  
* Year of birth and age.
if (WB3M >= 97 and WB3Y < 9997 and WB4 < 97) wyab = 100.  
* Age only.
if (WB3M >= 97 and WB3Y >= 9997 and WB4 < 97) wab = 100.  
* Year of birth only.
if (WB3M >= 97 and WB3Y< 9997 and WB4 >= 97) wyb = 100.
* Other/DK/Missing.
if (wmyb = 0 and wyab = 0 and wyb = 0 and wab = 0) wnd = 100.

compute wn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of women" .
variable labels wmyb "Year and month of birth".
variable labels wyab "Year of birth and age".
variable labels wyb "Year of birth only".
variable labels wab "Age only".
variable labels wnd "Other/DK/Missing".
value labels layer 1 " Completeness of reporting of date of birth and age".

* Ctables command in English.
ctables
  /vlabels variables = layer wn
         display = none
   /table total [c] + hh6 [c] + hh7 [c] + wage [c] by 
    layer [c] > (wmyb [s] [mean '' f5.1] + wyab [s] [mean '' f5.1] + wyb [s] [mean '' f5.1] +
    wab [s] [mean '' f5.1] + wnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + wn [c] [count '' f5.0]  
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.2.2W: Birth date and age reporting (women)"
   "Percent distribution of women age 15-49 years by completeness of date of birth/age information, " + surveyname.

new file.			
