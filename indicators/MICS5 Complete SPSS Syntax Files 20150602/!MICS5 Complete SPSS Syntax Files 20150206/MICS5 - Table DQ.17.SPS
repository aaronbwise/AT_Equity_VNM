* Updated 4/13/2015.
* weight by chweight added to the syntax.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

*select only children eligible for immunization module.

select if (cage <= 35).

recode IM2 (1=100)(else=0) into prcard.
variable labels prcard "Had vaccination card previously".

recode IM2 (2=100)(else=0) into noprcard.
variable labels noprcard "Never had vaccination card".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Child does not have vaccination card".

recode IM1 (1=100)(else=0) into cseen.
variable labels cseen "Seen by the interviewer (1)".

recode IM1 (2=100)(else=0) into notseen.
variable labels notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Child has vaccination card".

compute dkcard = 0.
if (IM1 = 8 or IM1 = 9 or IM2 = 8 or IM2 = 9) dkcard = 100.
variable labels dkcard "Missing/DK".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable labels pseen "Percent of vaccination cards seen by the interviewer (1)/(1+2)*100".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Number of children age 0-35 months".

variable labels cage_6 "Child's age".
value labels cage_6 1 "0-5 months" 2 "6-11 months" 3 "12-23 months" 4 "24-35 months".

ctables
  /vlabels variables = layer1 layer total display = none
  /table tot2 [c] + hh7 [c] + hh6 [c] + cage_6 [c] by 
                 layer1 [c] > (prcard [s] [mean,'' ,f7.1] + noprcard [s] [mean,'' ,f7.1]) +
                 layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1])+ dkcard [s] [mean,'' ,f7.1] +
                 tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count,'',f5.0]
  /slabels visible = no  
  /categories var = all empty=exclude missing=exclude 
  /titles title="Table DQ.17: Observation of vaccination cards"  
	"Percent distribution of children age 0-35 months by presence of a vaccination card, and the percentage of vaccination cards seen by the interviewers, " + surveyname.									

new file.

