* Updated 4/13/2015.
* weight by chweight added to the syntax.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

*  length/height is not measured and date of birth information is complete.
compute hnmeas  = 0.
if ((AN4 >= 997 or AN2 <> 1) and AG1M < 97 and AG1Y < 9997) hnmeas = 100.
variable labels hnmeas "Length/Height not measured".

*  length/height is measured and date of birth information is incomplete.
compute dkdate  = 0.
if ((AG1M >= 97 or AG1Y>=9997) and AN4 < 997) dkdate = 100.
variable labels dkdate "Incomplete date of birth".

compute both  = 0.
if ((AG1M>=97 or AG1Y>=9997) and (AN4 >= 997 or AN2 <> 1)) both = 100.
variable labels both "Length/Height not measured, incomplete date of birth".

compute flag = 0.
if (HAZFLAG = 1 and hnmeas = 0 and dkdate = 0 and both = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdateh  = 0.
if (AG1M < 97 and AG1Y < 9997 and AN4 < 997 and flag = 0) vdateh = 100.
variable labels vdateh "Valid length/height and date of birth".

compute excluded = 0.
if (hnmeas = 100 or dkdate = 100 or both = 100 or flag = 100) excluded = 100.
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
  /table tot [c] + CAGE_6 [c] by 
	vdateh [s] [mean,f5.1] + 	layer[c] >(hnmeas [s] [mean,f5.1] + dkdate [s] [mean,f5.1] + both [s] [mean,f5.1] + flag [s][mean,f5.1] ) + tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /titles title = 
   "Table DQ.13: Completeness of information for anthropometric indicators: Stunting"
   "Percent distribution of children under 5 by completeness of information on date of birth and length or height, " + surveyname.							


new file.

