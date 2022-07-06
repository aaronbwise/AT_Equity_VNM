*v.02. 30-06-2014.
*Incomplete information on date of birth excluded from calculations.

* Updated 4/13/2015.
* weight by chweight added to the syntax.

include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

* weight is not measured.
compute wnmeas  = 0.
if (AN3 >= 97 and AN4 < 997) wnmeas = 100.
variable labels wnmeas "Weight not measured".

*length/height is not measured.
compute hnmeas  = 0.
if (AN3 < 97 and AN4 >= 997) hnmeas = 100.
variable labels hnmeas "Length/Height not measured".

compute wgthgt  = 0.
if ((AN3 >= 97 and AN4 >= 997) or AN2<>1) wgthgt = 100.
variable labels wgthgt "Weight and length/height not measured".

*the relationship between the results of the two measurements is found to be outside normal ranges (outliers).
compute flag = 0.
if (WHZFLAG = 1 and wnmeas = 0 and hnmeas = 0 and wgthgt = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdatew  = 0.
if (AN3 < 97 and AN4 < 997 and flag = 0) vdatew = 100.
variable labels vdatew "Valid weight and length/height".

compute excluded = 0.
if (wnmeas = 100 or hnmeas = 100 or wgthgt = 100 or flag = 100) excluded = 100.
variable labels excluded "Percent of children excluded from analysis".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Reason for exclusion from analysis".

variable labels cage_6 "Age".
value labels cage_6 1 "<6 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months" 5 "36-47 months" 6 "48-59 months".

ctables
  /vlabels variables =  total layer
         display = none
  /table tot [c] + CAGE_6 [c]  by 
	vdatew [s] [mean,f5.1] + 	layer[c] >(wnmeas [s] [mean,f5.1]  + hnmeas [s] [mean,f5.1] + wgthgt [s] [mean,f5.1] + flag [s][mean,f5.1] ) + 
                  tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /titles title = 
   "Table DQ.14: Completeness of information for anthropometric indicators: Wasting"
   "Percent distribution of children under 5 by completeness of information on weight and length or height, " + surveyname.							

new file.



