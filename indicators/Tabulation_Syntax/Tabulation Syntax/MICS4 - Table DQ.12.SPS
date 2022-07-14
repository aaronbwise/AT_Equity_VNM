* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

variable label AG2 "Child's age".

recode IM2 (1=100)(else=0) into prcard.
variable label prcard "Had vaccination card previously".

recode IM2 (2=100)(else=0) into noprcard.
variable label noprcard "Never had vaccination card".

compute layer1 = 0.
variable label layer1 "".
value label layer1 0 "Child does not have vaccination card".

recode IM1 (1=100)(else=0) into cseen.
variable label cseen "Seen by the interviewer (1)".

recode IM1 (2=100)(else=0) into notseen.
variable label notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable label layer "".
value label layer 0 "Child has vaccination card".

compute dkcard = 0.
if (IM1 = 8 or IM1 = 9 or IM2 = 8 or IM2 = 9) dkcard = 100.
variable label dkcard "Missing/DK".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable label pseen "Percent of vaccination cards seen by the interviewer (1)/(1+2)*100".

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
  /vlabels variables = layer1 layer total display = none
  /table hh7 [c] + hh6 [c] + ag2 [c] + tot2 [c] by 
                 layer1 [c] > (prcard [s] [mean,'' ,f7.1] + noprcard [s] [mean,'' ,f7.1]) +
                 layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1])+ dkcard [s] [mean,'' ,f7.1] +
                 tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count,'',f5.0]
  /slabels visible = no  
  /titles title="Table DQ.12: Observation of vaccination cards"  
	"Percent distribution of children under 5 by presence of a vaccination card, and the percentage of vaccination cards seen by the interviewers, " + surveyname.

new file.

