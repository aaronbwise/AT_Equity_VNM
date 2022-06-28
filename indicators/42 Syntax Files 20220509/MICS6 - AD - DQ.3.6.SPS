* Encoding: windows-1252.

***.
* v02 - 30-06-2014.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

* weight is not measured.
compute wnmeas  = 0.
if (AN8 >= 97 and AN11 < 997) wnmeas = 100.
variable labels wnmeas "Weight not measured".

*length/height is not measured.
compute hnmeas  = 0.
if (AN8 < 97 and (sysmis(AN11) or AN11 >= 997)) hnmeas = 100.
variable labels hnmeas "Length/Height not measured".

compute wgthgt  = 0.
if (AN8 >= 97 and (sysmis(AN11) or AN11 >= 997)) wgthgt = 100.
variable labels wgthgt "Weight and length/height not measured".

*the relationship between the results of the two measurements is found to be outside normal ranges (outliers).
compute flag = 0.
if (WHZFLAG = 1 and wnmeas = 0 and hnmeas = 0 and wgthgt = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdatew  = 0.
if (AN8 < 97 and AN11 < 997 and flag = 0) vdatew = 100.
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

* Ctables command in English.
ctables
  /vlabels variables =  total layer
         display = none
  /table tot [c] + CAGE_6 [c]  by 
	vdatew [s] [mean,f5.1] + 	layer[c] >(wnmeas [s] [mean,f5.1]  + hnmeas [s] [mean,f5.1] + wgthgt [s] [mean,f5.1] + flag [s][mean,f5.1] ) + 
                  tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /titles title = 
   "Table DQ.3.6: Completeness of information for anthropometric indicators: Wasting and overweight"
   "Percent distribution of children under 5 by completeness of information on weight and length or height, " + surveyname.							

new file.



