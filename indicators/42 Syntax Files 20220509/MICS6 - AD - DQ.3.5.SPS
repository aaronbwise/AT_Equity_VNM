* Encoding: windows-1252.

***.
* Updated 4/13/2015.weight by chweight added to the syntax.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

compute total = 1.
variable labels total  " ".
value labels total 1 "Number of children under 5".

*  length/height is not measured and date of birth information is complete.
compute hnmeas  = 0.
if ((sysmis(AN11) or AN11 >= 997) and UB1M < 97 and UB1Y < 9997) hnmeas = 100.
variable labels hnmeas "Length/Height not measured".

*  length/height is measured and date of birth information is incomplete.
compute dkdate  = 0.
if ((UB1M >= 97 or UB1Y>=9997) and AN11 < 997) dkdate = 100.
variable labels dkdate "Incomplete date of birth".

compute both  = 0.
if ((UB1M>=97 or UB1Y>=9997) and AN11 >= 997) both = 100.
variable labels both "Length/Height not measured and incomplete date of birth".

compute flag = 0.
if (HAZFLAG = 1 and hnmeas = 0 and dkdate = 0 and both = 0) flag = 100.
variable labels flag "Flagged cases (outliers)".

compute vdateh  = 0.
if (UB1M < 97 and UB1Y < 9997 and AN11 < 997 and flag = 0) vdateh = 100.
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

* Ctables command in English.
ctables
  /vlabels variables =  total layer
         display = none
  /table tot [c] + CAGE_6 [c] by 
	vdateh [s] [mean,f5.1] + 	layer[c] >(hnmeas [s] [mean,f5.1] + dkdate [s] [mean,f5.1] + both [s] [mean,f5.1] + flag [s][mean,f5.1] ) + tot [s] [mean,f5.1] + excluded [s][mean,f5.1]
                + total [c] [count,f5.0]  
  /slabels position = column visible = no
  /titles title = 
   "Table DQ.3.5: Completeness of information for anthropometric indicators: Stunting"
   "Percent distribution of children under 5 by completeness of information on date of birth and length or height, " + surveyname.				

new file.

