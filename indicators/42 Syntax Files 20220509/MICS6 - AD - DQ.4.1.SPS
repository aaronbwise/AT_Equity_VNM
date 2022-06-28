* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Observation of bednets.

get file = "tn.sav".

weight by hhweight.

* The percentage of bednets observed is calculated by the number of bednets observed in the net roster (TN3=1).
compute obs = 0.
if (TN3 = 1) obs = 100.
variable labels obs "Percentage of bednets observed by interviewer".

compute total = 1.
variable labels total " ".
value labels total 1 "Number of bednets".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = total display = none
  /table tot [c]  + hh6 [c] + hh7 [c] + windex5 [c]  by  
	obs [s] [mean,'' ,f7.1] + total [c][count '' f5.0]
  /categories variables= all empty = exclude
  /slabels visible = no 
  /titles title="Table DQ.4.1: Observation of bednets"  
	"Percentage of bednets in all households observed by the interviewers, "+ surveyname.

new file.							


