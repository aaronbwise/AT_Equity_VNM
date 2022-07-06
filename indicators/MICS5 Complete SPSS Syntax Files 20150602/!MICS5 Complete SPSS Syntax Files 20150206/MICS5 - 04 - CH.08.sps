*v1 2014-04-03.

*In this table, the percentages of children receiving various treatments will not add to 100 since some children may have received more than one type of treatment.

*The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels  total "Number of children age 0-59 months".

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute zinc = 0.
+ if (CA4CA = 1 or CA4CB = 1) zinc = 100.

* ORS or increased fluids:  CA4[A]=1 or CA4[B]=1 or CA2=4.
+ compute orsdmore = 0.
+ if (CA4A = 1 or CA4B = 1 or CA2 = 4) orsdmore = 100.

* ORT (ORS or recommended homemade fluids or increased fluids).
* Includes above or any '1' to CA4F[A], CA4F[B], etc.
+ compute ort = 0.
+ if (orsdmore = 100 or CA4FA = 1 or CA4FB = 1 or CA4FC = 1) ort = 100.

* ORT with continued feeding: Includes above and CA3=2, 3, or 4.
+ compute ortfeed= 0.
+ if (ort = 100 and  (CA3 = 2 or CA3=3 or CA3 = 4)) ortfeed = 100.

* Other treatment: CA6.
* CA6 categories.
*Pill or Syrup
	Antibiotic					A
	Antimotility					B
	Other pill or syrup (Not antibiotic, 	antimotility or zinc)	G
	Unknown pill or syrup				H

*Injection
	Antibiotic		L
	Non-antibiotic	M
	Unknown injection	N

*Intravenous			O
*Home remedy / Herbal medicine	Q
*Other (specify)		X.


+ compute antibioticp = 0.
+ if (CA6A = "A") antibioticp = 100.
+ compute antimotility = 0.
+ if (CA6B = "B") antimotility = 100.
+ compute otherpill = 0.
+ if (CA6G = "G") otherpill = 100.
+ compute dkpill = 0.
+ if (CA6H = "H") dkpill = 100.
+ compute antibiotici = 0.
+ if (CA6L = "L") antibiotici = 100.
+ compute nonantii = 0.
+ if (CA6M = "M") nonantii = 100.
+ compute dkinj = 0.
+ if (CA6N = "N") dkinj = 100.
+ compute intravenous = 0.
+ if (CA6O = "O") intravenous = 100.
+ compute homerem = 0.
+ if (CA6Q = "Q") homerem = 100.
+ compute other = 0.
+ if (CA6X = "X") other = 100.

* Not given any treatment or drug: CA4[A]>1 and CA4[B]>1 and CA4C[A]>1 and CA4C[B]>1 and CA4F[A], CA4F[B], etc.>1 and CA5>1.
+ compute notreat = 0.
+ if (zinc = 0 and 
     ort = 0 and ortfeed = 0 and 
     antibioticp = 0 and antimotility = 0 and otherpill = 0 and dkpill = 0 and
     antibiotici = 0 and nonantii = 0 and dkinj = 0 and intravenous = 0 and  
     homerem = 0 and other = 0) notreat = 100.

+ compute dtotal = 1.

end if.

variable labels zinc "Zinc".
variable labels  orsdmore "ORS or increased fluids".
variable labels  ort "ORT (ORS or recommended homemade fluids or increased fluids)".
variable labels  ortfeed "ORT with continued feeding [1]".

variable labels  antibioticp "Pill or syrup: Antibiotic".
variable labels  antimotility "Pill or syrup: Antimotility".
variable labels  otherpill "Pill or syrup: Other ".
variable labels  dkpill "Pill or syrup: Unknown".
variable labels  antibiotici "Injection: Antibiotic".
variable labels  nonantii "Injection: Non-antibiotic".
variable labels  dkinj "Injection: Unknown".
variable labels  intravenous "Intravenous".
variable labels  homerem "Home remedy, herbal medicine".
variable labels  other "Other".
value labels dtotal 1 "Number of children age 0-59 months with diarrhoea in the last two weeks".
variable labels  dtotal "".
variable labels  notreat "Not given any treatment or drug".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with diarrhoea who were given:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Other treatment:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layer2 tot dtotal
         display = none
  /table tot [c]  + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
              layer [c] > ( zinc [s] [mean,'',f5.1] + orsdmore [s] [mean,'',f5.1] + ort [s] [mean,'',f5.1] + ortfeed [s] [mean,'',f5.1]  +
             	             layer2 [c] > (antibioticp [s] [mean,'',f5.1] + antimotility [s] [mean,'',f5.1] + 
                                  otherpill [s] [mean,'',f5.1] + dkpill [s] [mean,'',f5.1] + antibiotici [s] [mean,'',f5.1] + 
                                  nonantii [s] [mean,'',f5.1] + dkinj [s] [mean,'',f5.1] + intravenous [s] [mean,'',f5.1] +
                                  homerem [s] [mean,'',f5.1] + other [s] [mean,'',f5.1])) +
              notreat [s] [mean,'',f5.1] +
              dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.8: Oral rehydration therapy with continued feeding and other treatments"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks who were given oral rehydration " +
                  "therapy with continued feeding and percentage who were given other treatments, " + surveyname
  caption =
    "[1] MICS indicator 3.12 - Diarrhoea treatment with oral rehydration therapy (ORT) and continued feeding".

new file.

