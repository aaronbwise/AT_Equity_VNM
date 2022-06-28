* Encoding: windows-1252.
 * ORS or increased fluids:  CA7[A]=1 or CA7[B]=1 or CA3A/B=4.

 * ORT: Includes above or CA7[D]=1.

 * ORT with continued feeding: Includes above and CA4=2, 3, or 4.

 * Other treatment: CA13

 * Not given any treatment or drug: CA7[A]>1 and CA7[B]>1 and CA7[C]>1 and CA7[D]>1 and CA12>1

 * In this table, the percentages of children receiving various treatments will not add to 100 since some children may have received more than one type of treatment.

 * The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1																		


****.

* v02. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute zinc = 0.
+ if (CA7C=1) zinc = 100.

* ORS or increased fluids:  CA7[A]=1 or CA7[B]=1 or CA3A/B=4.
+ compute orsdmore = 0.
+ if (CA7A = 1 or CA7B = 1 or CA3 = 4) orsdmore = 100.


*ORT: Includes above or CA7[D]=1.
+ compute ort = 0.
+ if (orsdmore = 100 or CA7D = 1) ort = 100.

* ORT with continued feeding: Includes above and CA4=2, 3, or 4.

+ compute ortfeed= 0.
+ if (ort = 100 and  (CA4 = 2 or CA4=3 or CA4 = 4)) ortfeed = 100.

* Other treatment: CA13.
* CA13 categories.
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
+ if (CA13A = "A") antibioticp = 100.
+ compute antimotility = 0.
+ if (CA13B = "B") antimotility = 100.
+ compute otherpill = 0.
+ if (CA13G = "G") otherpill = 100.
+ compute dkpill = 0.
+ if (CA13H = "H") dkpill = 100.
+ compute antibiotici = 0.
+ if (CA13L = "L") antibiotici = 100.
+ compute nonantii = 0.
+ if (CA13M = "M") nonantii = 100.
+ compute dkinj = 0.
+ if (CA13N = "N") dkinj = 100.
+ compute intravenous = 0.
+ if (CA13O = "O") intravenous = 100.
+ compute homerem = 0.
+ if (CA13Q = "Q") homerem = 100.
+ compute other = 0.
+ if (CA13X = "X") other = 100.

*  No other treatement.
+ compute noothertreat = 0.
+ if (antibioticp = 0 and antimotility = 0 and otherpill = 0 and dkpill = 0 and
     antibiotici = 0 and nonantii = 0 and dkinj = 0 and intravenous = 0 and  
     homerem = 0 and other = 0) noothertreat = 100.

*  Not given any treatment or drug: CA7[A]>1 and CA7[B]>1 and CA7[C]>1 and CA7[D]>1 and CA12>1.
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
variable labels  ort "ORT (ORS or government-recommended homemade fluid or increased fluids)".
variable labels  ortfeed "ORT with continued feeding [1]".

variable labels  antibioticp "Antibiotic".
variable labels  antimotility "Antimotility".
variable labels  otherpill "Other ".
variable labels  dkpill "Unknown".
variable labels  antibiotici "Antibiotic".
variable labels  nonantii "Non-antibiotic".
variable labels  dkinj "Unknown".
variable labels  intravenous "Intravenous".
variable labels  homerem "Home remedy, herbal medicine".
variable labels  other "Other".
variable labels  noothertreat "No other treatment".
value labels dtotal 1 "Number of children with diarrhoea in the last two weeks".
variable labels  dtotal "".
variable labels  notreat "Not given any treatment or drug".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with diarrhoea who were given:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Other treatments".

compute layer3 = 0.
variable labels  layer3 "".
value labels layer3 0 "Pill or syrup".

compute layer4 = 0.
variable labels  layer4 "".
value labels layer4 0 "Injection".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

variable labels caretakerdis "Mother's functional difficulties [A]".

* Ctables command in English.
ctables
  /vlabels variables = layer layer2 tot dtotal layer3 layer4
         display = none
  /table tot [c]
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]  by 
              layer [c] > ( zinc [s] [mean '' f5.1] + orsdmore [s] [mean '' f5.1] + ort [s] [mean '' f5.1] + ortfeed [s] [mean '' f5.1]  +
             	             layer2 [c] > (layer3 [c] > (antibioticp [s] [mean '' f5.1] + antimotility [s] [mean '' f5.1] + 
                                  otherpill [s] [mean '' f5.1] + dkpill [s] [mean '' f5.1]) + layer4 [c] > (antibiotici [s] [mean '' f5.1] + 
                                  nonantii [s] [mean '' f5.1] + dkinj [s] [mean '' f5.1]) + intravenous [s] [mean '' f5.1] +
                                  homerem [s] [mean '' f5.1] + other [s] [mean '' f5.1]+ noothertreat [s] [mean '' f5.1])) +
              notreat [s] [mean '' f5.1] +
              dtotal [c] [count '' f5.0]
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.3.4: Oral rehydration therapy with continued feeding and other treatments"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks who were given oral rehydration therapy " +
                  "with continued feeding and percentage who were given other treatments, " + surveyname
  caption =
    "[1] MICS indicator TC.14 - Diarrhoea treatment with oral rehydration therapy (ORT) and continued feeding"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.

new file.