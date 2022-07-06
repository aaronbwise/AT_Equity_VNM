* Updated 4/13/2015.
* weight by hhweight added to the syntax.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Observation of bednets.

get file = "tn.sav".

weight by hhweight.

compute obs = 0.
if (tn4 = 1) obs = 100.
variable labels obs "Percentage of bednets observed by interviewer".

compute total = 1.
variable labels total " ".
value labels total 1 "Total number of bednets".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

ctables
  /vlabels variables = total display = none
  /table tot [c]  + hh7 [c] + hh6 [c] + windex5 [c]  by  
	obs [s] [mean,'' ,f7.1] + total [c][count,'',f5.0]
  /categories var= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.19: Observation of bednets and places for handwashing"  
	"Percentage of bednets in all households observed by the interviewers, " 
 "and percent distribution of places for handwashing observed by the interviewers in all interviewed households, "+ surveyname.

* Observations of places for handwashing.

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

recode hw1 (1=100)(else=0) into hwash1.
recode hw1 (2=100)(else=0) into hwash2.
recode hw1 (3=100)(else=0) into hwash3.
recode hw1 (6=100)(else=0) into hwash4.
variable labels hwash1 "Observation of places for handwashing: Observed".
variable labels hwash2 "Place for handwashing not in dwelling".
variable labels hwash3 "No permission to see".
variable labels hwash4 "Other".

compute total = 1.
variable labels total " ".
value labels total 1 "Number of households interviewed".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

ctables
  /vlabels variables = total display = none
  /table  tot2 [c] + hh7 [c] + hh6 [c] + windex5 [c]  by  
	hwash1 [s] [mean,'' ,f7.1] + hwash2 [s] [mean,'' ,f7.1] + hwash3 [s] [mean,'' ,f7.1] + hwash4 [s] [mean,'' ,f7.1] + tot1 [s] [mean,'' ,f7.1] + total [c][count,'',f5.0]
  /categories var= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.19: Observation of bednets and places for handwashing"  
	"Percentage of bednets in all households observed by the interviewers, " 
 "and percent distribution of places for handwashing observed by the interviewers in all interviewed households, "+ surveyname.


new file.							


