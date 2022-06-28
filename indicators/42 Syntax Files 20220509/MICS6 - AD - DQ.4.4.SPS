* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* v03 - 2020-09-10. Corrected calculation of variable dkcard.
* v04 - 2021-10-26
Line 53
if (IM5 = 9 or (IM2 = 4 and IM3 = 9)) dkcard = 100
changed to 
if (IM5 = 8 or IM5 = 9 or IM3 = 8 or IM3 = 9) dkcard = 100.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

*select only children eligible for immunization module.

select if (cage <= 35).

* Children who do not have vaccination records, but had previously: IM2=4 and IM3=1.
* Children who never had vaccination records: IM2=4 and IM3=2.
* Children with vaccination records seen by the interviewer: IM5<4.
* Children reported with vaccination records not seen by the interviewer: IM5=4.

compute prcard = 0.
if (IM2 = 4 and IM3 = 1)  prcard = 100.
variable labels prcard "Had vaccination records previously".

compute noprcard = 0.
if (IM2 = 4 and IM3 = 2) noprcard = 100.
variable labels noprcard "Never had vaccination records".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Child does not have vaccination records".

recode IM5 (1,2,3=100)(else=0) into cseen.
variable labels cseen "Seen by the interviewer (1)".

recode IM5 (4=100)(else=0) into notseen.
variable labels notseen "Not seen by the interviewer (2)".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Child has vaccination records".

compute dkcard = 0.
if (IM5 = 8 or IM5 = 9 or IM3 = 8 or IM3 = 9) dkcard = 100.
variable labels dkcard "DK/Missing".

do if (cseen = 100 or notseen = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.
variable labels pseen "Percent of vaccination records seen by the interviewer (1)/(1+2)*100".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

compute total = 1.
variable labels total "".
value labels total 1 "Number of children age 0-35 months".

* Ctables command in English.
ctables
  /vlabels variables = layer1 layer total display = none
  /table tot2 [c] + hh6 [c] + hh7 [c] + cage_6 [c] by 
                 layer1 [c] > (prcard [s] [mean,'' ,f7.1] + noprcard [s] [mean,'' ,f7.1]) +
                 layer [c] > (cseen [s] [mean,'' ,f7.1] + notseen [s] [mean,'' ,f7.1])+ dkcard [s] [mean,'' ,f7.1] +
                 tot1[s] [mean,'' ,f7.1] + pseen [s] [mean,'' ,f7.1]+ total [c][count '' f5.0]
  /slabels visible = no  
  /categories variables = all empty=exclude missing=exclude 
  /titles title="Table DQ.4.4: Observation of vaccination records"  
	"Percent distribution of children age 0-35 months by presence of vaccination records, and the percentage of vaccination records seen by the interviewers, " + surveyname.									

new file.

