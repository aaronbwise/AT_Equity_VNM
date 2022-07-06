*v1 - 20140319.
*v2 - 20140421.
* In the sub-title, the ordering of the three diseases has changed (to match the ordering of columns).

*This table establishes the denominators for all of the following care-seeking behaviour and treatment tables related to diarrhoea, suspected ARI, and fever (malaria).

*Diarrhoea: 
*CA1=1

*Suspected ARI:
*Children with symptoms of ARI are those who had an illness with a cough (CA7=1), accompanied by a rapid or difficult breathing (CA8=1) 
*and whose symptoms were due to a problem in the chest, or both a problem in the chest and a blocked nose (CA9=1 or 3).

*Fever:
*CA6A=1.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels total "Number of children age 0-59 months".

* Diarrhoea.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "An episode of diarrhoea".

* Suspected ARI.
compute ari  = 0.
if (CA7 = 1 and CA8 = 1 and (CA9 =1 or CA9 = 3)) ari = 100.
variable labels  ari "Symptoms of ARI".

* Fever.
recode CA6AA (1 = 100) (else = 0) into fever.
variable labels fever "An episode of fever".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children who in the last two weeks had:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer tot 
         display = none
  /table  tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c]  + windex5 [c] + ethnicity [c]    by 
	layer [c] > (diarrhea [s] [mean,'',f5.1] + ari [s] [mean,'',f5.1] + fever [s] [mean,'',f5.1]) + total [s] [count,'',f5.0] 
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.4: Reported disease episodes"
                  "Percentage of children age 0-59 months for whom the mother/caretaker reported an episode of diarrhoea, " +
	"symptoms of acute respiratory infection (ARI), and/or fever in the last two weeks, " + surveyname.
						
new file.
