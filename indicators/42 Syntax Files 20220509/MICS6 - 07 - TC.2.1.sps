* Encoding: windows-1252.
 * "This table establishes the denominators for all of the following care-seeking behaviour and treatment tables related to diarrhoea, symptoms of ARI, and fever (malaria).

 * Diarrhoea: 
CA1=1

 * Symptoms of ARI:
 Children with symptoms of ARI are those who had an illness with a cough (CA16=1), accompanied by a rapid or difficult breathing (CA17=1) and whose symptoms were 
 due to a problem in the chest, or both a problem in the chest and a blocked nose (CA18=1 or 3).

 * Fever:
CA14=1"				

****.

*v2. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-23. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open children data file.
get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels total "Number of children".

* Diarrhoea.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "An episode of diarrhoea".

* Suspected ARI.
compute ari  = 0.
if (CA16 = 1 and CA17 = 1 and (CA18 =1 or CA18 = 3)) ari = 100.
variable labels  ari "Symptoms of ARI".

* Fever.
recode CA14 (1 = 100) (else = 0) into fever.
variable labels fever "An episode of fever".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children who in the last two weeks had:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = layer tot 
         display = none
  /table  tot [c]
          + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + ethnicity [c]
         + windex5 [c]   by 
	layer [c] > (diarrhea [s] [mean '' f5.1] + ari [s] [mean '' f5.1] + fever [s] [mean '' f5.1]) + total [s] [count '' f5.0] 
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.2.1: Reported disease episodes"
                  "Percentage of children age 0-59 months for whom the mother/caretaker reported an episode of diarrhoea, symptoms " + 
                  "of acute respiratory infection (ARI), and/or fever in the last two weeks, " + surveyname.
										  
new file.
