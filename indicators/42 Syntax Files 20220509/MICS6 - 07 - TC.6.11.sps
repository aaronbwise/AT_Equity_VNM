* Encoding: UTF-8.
 * Anti-malarial and other drugs given to children are obtained from CA23.

 * The percentages of children given various drugs will not add to 100 since some children may have been given more than one type of drug.

 * The denominator for this table is number of children with fever during the last two weeks: CA14=1																			


****.
* v02 - 2020-04-24. A new note A has been inserted. Labels in French and Spanish have been removed.
* v03 - 2021-10-26
Line 103:
+ if (CA23W = "W" or CA23Z = "Z") DKPill= 100
changed to 
+ if (CA23W = "W" or CA23Z = "Z" or CA23NR = "?") DKPill= 100.
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

* children with fever during the last two weeks: CA14=1.
select if (CA14 = 1).

weight by chweight.

compute fever = 1.
variable labels fever " ".
value labels fever 1 "Number of children age 0-59 months with fever in last two weeks".

 * CA23.
 * ANTI-MALARIALS
	ARTEMISININ COMBINATION	THERAPY (ACT)	A
	SP / FANSIDAR				B
	CHLOROQUINE				C
	AMODIAQUINE				D
	QUININE
		PILLS				E
		INJECTION/IV			F
	ARTESUNATE
		RECTAL				G
		INJECTION/IV			H
	OTHER ANTI-MALARIAL (specify)			K

 * ANTIBIOTICS
	AMOXICILLIN				L
	COTRIMOXAZOLE				M
	OTHER ANTIBIOTIC PILL/SYRUP			N
	OTHER ANTIBIOTIC INJECTION/IV			O

 * OTHER MEDICATIONS
	PARACETAMOL/PANADOL/ACETAMINOPHEN		R
	ASPIRIN					S
	IBUPROFEN				T

 * ONLY BRAND NAME RECORDED			W

 * OTHER (specify)					X
*  DK						Z

+ compute ACT = 0.
+ if (CA23A = "A") ACT = 100.
+ compute spFansidar = 0.
+ if (CA23B = "B") spFansidar = 100.
+ compute Chloroquine = 0.
+ if (CA23C = "C") Chloroquine = 100.
+ compute Amodiaquine = 0.
+ if (CA23D = "D") Amodiaquine = 100.
+ compute QuininePill = 0.
+ if (CA23E= "E") QuininePill = 100.
+ compute QuinineInc = 0.
+ if (CA23F= "F") QuinineInc = 100.
+ compute ArtesunateRect = 0.
+ if (CA23G = "G") ArtesunateRect = 100.
+ compute ArtesunateInc = 0.
+ if (CA23H = "H") ArtesunateInc = 100.
+ compute otherMalaria = 0.
+ if (CA23K = "K") otherMalaria = 100.

+ compute Amoxicillin = 0.
+ if (CA23L = "L") Amoxicillin = 100.
+ compute Cotrimoxazole = 0.
+ if (CA23M = "M") Cotrimoxazole = 100.
+ compute antiOtherPill = 0.
+ if (CA23N = "N") antiOtherPill = 100.
+ compute antiOtherInc = 0.
+ if (CA23O = "O") antiOtherInc = 100.

+ compute Paracetamol = 0.
+ if (CA23R = "R") Paracetamol= 100.
+ compute Aspirin = 0.
+ if (CA23S = "S") Aspirin= 100.
+ compute Ibuprofen = 0.
+ if (CA23T = "T") Ibuprofen= 100.

+ compute Other = 0.
+ if (CA23X = "X") Other= 100.

+ compute DKPill = 0.
+ if (CA23W = "W" or CA23Z = "Z" or CA23NR="?") DKPill= 100.

variable labels  ACT 		"Artemisinin-based Combination Therapy (ACT)".
variable labels  spFansidar 	"SP/ Fansidar".
variable labels  Chloroquine 	"Chloroquine".
variable labels  Amodiaquine 	"Amodiaquine".
variable labels  QuininePill 	"Quinine pills".
variable labels  QuinineInc	"Quinine injection/IV".
variable labels  ArtesunateRect	"Artesunate rectal".
variable labels  ArtesunateInc	"Artesunate injection/IV".
variable labels  otherMalaria 	"Other anti-malarial".
variable labels  Amoxicillin	"Amoxicillin".
variable labels  Cotrimoxazole	"Cotrimoxazole".
variable labels  antiOtherPill	"Other antibiotic pill/syrup".
variable labels  antiOtherInc	"Other antibiotic injection/IV".
variable labels  Paracetamol	"Paracetamol/ Panadol/ Acetaminophen".
variable labels  Aspirin		"Aspirin".
variable labels  Ibuprofen	"Ibuprofen".
variable labels  Other		"Other".
variable labels  DKPill		"DK/Missing".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Children with a fever in the last two weeks who were given:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Anti-malarials:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Other treatment:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = layer layer1 layer2 tot fever
         display = none
  /table tot [c]  
        + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + cage_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
 by 
              layer [c] > ( layer1 [c] > 
                             (ACT [s][mean '' f5.1] + spFansidar [s][mean '' f5.1] + Chloroquine [s][mean '' f5.1] + Amodiaquine [s][mean '' f5.1] + QuininePill [s][mean '' f5.1] + QuinineInc [s][mean '' f5.1] 
                         + ArtesunateRect [s][mean '' f5.1] + ArtesunateInc [s][mean '' f5.1] + otherMalaria [s][mean '' f5.1]) +
             	              layer2 [c] > ( Amoxicillin [s][mean '' f5.1] + Cotrimoxazole [s][mean '' f5.1] + antiOtherPill  [s][mean '' f5.1]
                         + antiOtherInc  [s][mean '' f5.1] + Paracetamol [s][mean '' f5.1] + Aspirin [s][mean '' f5.1] + Ibuprofen [s][mean '' f5.1]) +
                           Other [s][mean '' f5.1] + DKPill [s][mean '' f5.1])+
              fever [c] [count '' f5.0]
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.6.11: Treatment of children with fever"														
	"Percentage of children age 0-59 months who had a fever in the last two weeks, by type of medicine given for the illness, "+ surveyname
  caption=
   "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
.

new file.

