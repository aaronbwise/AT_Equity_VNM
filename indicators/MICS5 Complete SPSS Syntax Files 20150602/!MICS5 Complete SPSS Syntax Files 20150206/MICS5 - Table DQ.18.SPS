* Updated 4/13/2015.
* weight by wmweight added to the syntax.
* total moved to the firts row.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

weight by wmweight.

recode MN5 (3=100)(else=0) into nocard.
variable labels nocard "Woman does not have health card".

recode MN5 (1=100)(else=0) into cseen.
variable labels cseen "Seen by the interviewer (1)".

recode MN5 (2=100)(else=0) into notseen.
variable labels notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Woman has health card".

recode MN5 (8,9=100)(else=0) into dkcard.
variable labels dkcard "Missing/DK".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable labels pseen "Percent of health cards seen by the interviewer (1)/(1+2)*100".

recode wage (1,2 = 1) (3,4 = 2) (else = 3) into wagec.
variable labels wagec "Age".
value labels wagec 1 "15-24" 2 "25-34" 3 "35-49".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Number of women with a live birth in the last two years".

ctables
  /vlabels variables = layer total display = none
  /table tot2 [c] + hh7 [c] + hh6 [c] + wagec [c]  by nocard [s] [mean,'' ,f7.1] + layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1])+
                 dkcard [s] [mean,'' ,f7.1] + tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count,'',f5.0]
  /slabels visible = no  
  /titles title="Table DQ.18: Observation of women's health cards"  
	"Percent distribution of women with a live birth in the last 2 years by presence of a health card, and the percentage of health cards seen by the interviewers, "
	 + surveyname.

new file.

