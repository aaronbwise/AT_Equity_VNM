* v1 2014-04-06.
* v2 2014-04-21.
* The sub-title has been updated 


* Anti-malarial and other drugs given to children are obtained from CA13.
* The percentages of children given various drugs will not add to 100 since some children may have been given more than one type of drug.
* The denominator for this table is number of children with fever during the last two weeks: CA6A=1.

****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

select if (CA6AA = 1).

weight by chweight.

compute fever = 1.
variable labels fever " ".
value labels fever 1 "Number of children with fever in last two weeks".

* CA13.
*Anti-malarials:
	SP / Fansidar		A
	Chloroquine			B
	Amodiaquine		C
	Quinine			D
	Combination with Artemisinin	E
	Other anti-malarial 
		(specify)		H

*Antibiotics:
	Pill / Syrup			I
	Injection			J

*Other medications:
	Paracetamol/ Panadol /Acetaminophen	P
	Aspirin				Q
	Ibuprofen				R

*Other (specify)				X
*DK					Z

+ compute spFansidar = 0.
+ if (CA13A = "A") spFansidar = 100.
+ compute Chloroquine = 0.
+ if (CA13B = "B") Chloroquine = 100.
+ compute Amodiaquine = 0.
+ if (CA13C = "C") Amodiaquine = 100.
+ compute Quinine = 0.
+ if (CA13D= "D") Quinine = 100.
+ compute ACT = 0.
+ if (CA13E = "E") ACT = 100.
+ compute otherMalaria = 0.
+ if (CA13H = "H") otherMalaria = 100.

+ compute antiPill = 0.
+ if (CA13I = "I") antiPill= 100.
+ compute antiInjection = 0.
+ if (CA13J = "J") antiInjection= 100.

+ compute Paracetamol = 0.
+ if (CA13P = "P") Paracetamol= 100.
+ compute Aspirin = 0.
+ if (CA13Q = "Q") Aspirin= 100.
+ compute Ibuprofen = 0.
+ if (CA13R = "R") Ibuprofen= 100.

+ compute Other = 0.
+ if (CA13X = "X") Other= 100.

+ compute DKPill = 0.
+ if (CA13Z = "Z") DKPill= 100.

variable labels  spFansidar 	"SP/ Fansidar".
variable labels  Chloroquine 	"Chloroquine".
variable labels  Amodiaquine 	"Amodia-quine".
variable labels  Quinine 	"Quinine".
variable labels  ACT 		"Artemisinin-based Combination Therapy (ACT)".
variable labels  otherMalaria 	"Other anti-malarial".
variable labels  antiPill		"Antibiotic pill or syrup".
variable labels  antiInjection	"Antibiotic injection".
variable labels  Paracetamol	"Paracetamol/ Panadol/ Acetaminophen".
variable labels  Aspirin		"Aspirin".
variable labels  Ibuprofen	"Ibuprofen".
variable labels  Other		"Other".
variable labels  DKPill		"Missing/DK".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with a fever in the last two weeks who were given:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Anti-malarials: ".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Other treatment:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layer1 layer2 tot fever
         display = none
  /table tot [c]  + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
              layer [c] > ( layer1 [c] > (spFansidar [s][mean,'',f5.1] + Chloroquine [s][mean,'',f5.1] + Amodiaquine [s][mean,'',f5.1] + Quinine [s][mean,'',f5.1] + ACT [s][mean,'',f5.1] + otherMalaria [s][mean,'',f5.1]) +
             	              layer2 [c] > (antiPill [s][mean,'',f5.1] + antiInjection [s][mean,'',f5.1] + Paracetamol [s][mean,'',f5.1] + Aspirin[s][mean,'',f5.1] + Ibuprofen[s][mean,'',f5.1] ) +
                                  Other [s] [mean,'',f5.1] + DKPill [s] [mean,'',f5.1]) +
              fever [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.21: Treatment of children with fever"														
	"Percentage of children age 0-59 months who had a fever in the last two weeks, by type of medicine given for the illness, "+ surveyname.

new file.

