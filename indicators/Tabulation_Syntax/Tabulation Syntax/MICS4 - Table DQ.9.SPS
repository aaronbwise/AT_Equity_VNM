* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Observation of bednets.

get file = "tn.sav".

compute obs = 0.
if (tn4 = 1) obs = 100.
variable labels obs "Percentage of bednets observed by interviewer".

compute total = 1.
variable labels total " ".
value label total 1 "Total number of bednets".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

ctables
  /vlabels variables = total display = none
  /table hh7 [c] + hh6 [c] + windex5 [c] + tot [c] by  
	obs [s] [mean,'' ,f7.1] + total [c][count,'',f5.0]
  /categories var= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.9: Observation of bednets"  
	"Percentage of bednets in all households interviewed observed by the interviewer, " + surveyname.

* Observations of places for handwashing.

get file = 'hh.sav'.

select if (HH9 = 1).

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
  /table hh7 [c] + hh6 [c] + windex5 [c] + tot2 [c] by  
	hwash1 [s] [mean,'' ,f7.1] + hwash2 [s] [mean,'' ,f7.1] + hwash3 [s] [mean,'' ,f7.1] + hwash4 [s] [mean,'' ,f7.1] + tot1 [s] [mean,'' ,f7.1] + total [c][count,'',f5.0]
  /categories var= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.9: Observation of places for hand washing"  
	"Percentage of places for handwashing observed by the interviewer in all interviewed households, " + surveyname.

new file.

