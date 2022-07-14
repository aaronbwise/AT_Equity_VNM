* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

variable label AG2 "Child's age".

recode BR1 (3=100)(else=0) into nocard.
variable label nocard "Child does not have birth certificate".

recode BR1 (1=100)(else=0) into cseen.
variable label cseen "Seen by the interviewer (1)".

recode BR1 (2=100)(else=0) into notseen.
variable label notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable label layer "".
value label layer 0 "Child has birth certificate".

recode BR1 (8,9=100)(else=0) into dkcard.
variable label dkcard "Missing/DK".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable label pseen "Percent of birth certificates seen by the interviewer (1)/(1+2)*100".

compute tot1 = 100.
variable label tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable label tot2 "Total".
value labels tot2 1 " ".

compute total = 1.
variable label total "".
value label total 1 "Number of children under age 5".

ctables
  /vlabels variables = layer total display = none
  /table hh7 [c] + hh6 [c] + ag2 [c] + tot2 [c] by nocard [s] [mean,'' ,f7.1] + layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1])+
                 dkcard [s] [mean,'' ,f7.1] + tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count,'',f5.0]
  /slabels visible = no  
  /titles title="Table DQ.11: Observation of under-5s birth certificates"  
	"Percent distribution of children under 5 by presence of birth certificates,and percentage of birth calendar seen, " + surveyname.

new file.

