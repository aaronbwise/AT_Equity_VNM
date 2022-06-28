* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

recode BR1 (3=100)(else=0) into nocard.
variable labels nocard "Child does not have birth certificate".

recode BR1 (1=100)(else=0) into cseen.
variable labels cseen "Seen by the interviewer (1)".

recode BR1 (2=100)(else=0) into notseen.
variable labels notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Child has birth certificate".

recode BR1 (8,9=100)(else=0) into dkcard.
variable labels dkcard "DK/Missing".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable labels pseen "Percentage of birth certificates seen by the interviewer (1)/(1+2)*100".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Number of children under 5".

* Ctables command in English.
ctables
  /vlabels variables = layer total display = none
  /table  tot2 [c] + hh6 [c] + hh7 [c] + cage_6 [c] by layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1]) + nocard [s] [mean,'' ,f7.1] +
                 dkcard [s] [mean,'' ,f7.1] + tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count '' f5.0]
  /slabels visible = no  
  /titles title="Table DQ.4.3: Observation of birth certificates"  
	"Percent distribution of children under 5 by presence of birth certificates,and percentage of birth certificates seen, " + surveyname.							

new file.

