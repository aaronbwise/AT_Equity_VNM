* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* DQ2.5. In the lines 29-33 condition CB3< 7, changed to CB3 < 97
 * if (CB2M < 97 and CB2Y < 9997) fsmyb = 100.  
 * if (CB2M >= 97 and CB2Y < 9997 and CB3 < 7) fsyab = 100.  
 * if (CB2M >= 97 and CB2Y >= 9997 and CB3 < 7 ) fsab = 100.  
 * if (CB2M >= 97 and CB2Y < 9997 and CB3 >= 7 ) fsyb = 100. 

* Open the 5-17 data file.
include "surveyname.sps".

get file = 'fs.sav'.

select if (FS17 = 1).

weight by fsHweight.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute fsmyb = 0.
compute fsyab   = 0.
compute fsab   = 0.
compute fsyb   = 0.
compute cnd = 0.

if (CB2M < 97 and CB2Y < 9997) fsmyb = 100.  
if (CB2M >= 97 and CB2Y < 9997 and CB3 < 97) fsyab = 100.  
if (CB2M >= 97 and CB2Y >= 9997 and CB3 < 97 ) fsab = 100.  
if (CB2M >= 97 and CB2Y < 9997 and CB3 >= 97 ) fsyb = 100.  
if (fsmyb = 0 and fsyab = 0 and fsyb = 0 and fsab = 0) cnd = 100.

compute cn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels cn " ".
value labels cn 1 "Number of selected children age 5-17 years" .
variable labels fsmyb "Year and month of birth".
variable labels fsyab "Year of birth and age".
variable labels fsyb "Year of birth only".
variable labels fsab "Age only".
variable labels cnd "Other/DK/Missing".
value labels layer 1 "Completeness of reporting of date of birth and age".

* Ctables command in English.
ctables
  /vlabels variables = layer cn
         display = none
   /table total [c] + hh6 [c] + hh7 [c] + fsage [c] by 
    layer [c] > (fsmyb [s] [mean '' f5.1] + fsyab [s] [mean '' f5.1] + fsyb [s] [mean '' f5.1] +
    fsab [s] [mean '' f5.1] + cnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + cn [c] [count '' f5.0]  
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.2.5: Birth date and age reporting (children age 5-17 years)"
   "Percent distribution of selected children age 5-17 years by completeness of date of birth/age information, " + surveyname.				
   
new file.		
