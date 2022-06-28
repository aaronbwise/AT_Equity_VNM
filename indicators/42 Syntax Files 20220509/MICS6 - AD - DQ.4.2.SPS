* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Observations of places for handwashing.

get file = 'hh.sav'.

select if (HH46 = 1).

weight by hhweight.

recode hw1 (1,2=100)(else=0) into hwash1.
recode hw1 (3=100)(else=0) into hwash2.
recode hw1 (4=100)(else=0) into hwash3.
recode hw1 (5=100)(else=0) into hwash4.
recode hw1 (6=100)(else=0) into hwash5.
variable labels hwash1 "Fixed facility".
variable labels hwash2 "Mobile object".
variable labels hwash3 "Not in the dwelling, plot or yard".
variable labels hwash4 "No permission to see".
variable labels hwash5 "Other reason".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Handwashing facility".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Observed".

compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Not observed".

compute total = 1.
variable labels total " ".
value labels total 1 "Number of households".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = total layer layer1 layer2 display = none
  /table  tot2 [c] + hh6 [c] + hh7 [c] + windex5 [c]  by  
          layer [c] > (
	           layer1 [c] >(hwash1 [s] [mean,'' ,f7.1] + hwash2 [s] [mean,'' ,f7.1]) 
	         + layer2 [c] >(hwash3 [s] [mean,'' ,f7.1] + hwash4 [s] [mean,'' ,f7.1] + hwash5 [s] [mean,'' ,f7.1]) + tot1 [s] [mean, '' f5.1] ) + total
  /categories variables= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.4.2: Observation of handwashing facility"  
	"Percent distribution of handwashing facility observed by the interviewers in all interviewed households, "+ surveyname.

new file.							


