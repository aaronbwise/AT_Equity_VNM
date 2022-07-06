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

* Weight not measured, date of birth complete.
compute wnmeas  = 0.
if ((AN3 >= 97 or AN2 <> 1) and AG1M < 97 and AG1Y < 9997) wnmeas = 100.
variable labels wnmeas "Weight not measured".

* Date of birth information is incomplete, weight measured.
compute dkdate  = 0.
if ((AG1M >= 97 or AG1Y >= 9997) and AN3 < 97) dkdate = 100.
variable labels dkdate "Incomplete date of birth".

* Date of birth information is incomplete and weight not measured.
compute both  = 0. 
if ((AG1M >= 97 or AG1Y >= 9997) and (AN3 >= 97 or AN2 <> 1)) both = 100.
variable labels both "Weight not measured, incomplete date of birth".

* Result of weight measurement, with respect to the age of the child, is found to be outside normal ranges (outliers).
compute flag = 0.
if (WAZFLAG = 1 and wnmeas = 0 and dkdate = 0 and both = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdatew  = 0.
if (AG1M < 97 and AG1Y < 9997 and AN3 < 97 and flag = 0) vdatew = 100.
variable labels vdatew "Valid weight and date of birth".

* Children excluded from the underweight analysis.
compute excluded = 0.
if (wnmeas = 100 or dkdate = 100 or both = 100 or flag = 100) excluded = 100.
variable labels excluded "Percent of children excluded from analysis".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Reason for exclusion from analysis".

variable labels cage_6 "Weight by age".
value labels cage_6 1 "<6 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months" 5 "36-47 months" 6 "48-59 months".

ctables
  /vlabels variables =  total layer
         display = none
  /TABLE tot [c] + CAGE_6 [c]  by 
	vdatew [s] [mean,f5.1] + 	layer[c] >(wnmeas [s] [mean,f5.1] + dkdate [s] [mean,f5.1] + both [s] [mean,f5.1] + flag [s][mean,f5.1] ) + tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /TITLES TITLE=
   "Table DQ.12: Completeness of information for anthropometric indicators: Underweight"
   "Percent distribution of children under 5 by completeness of information on date of birth and weight, " + surveyname.
						
new file.
