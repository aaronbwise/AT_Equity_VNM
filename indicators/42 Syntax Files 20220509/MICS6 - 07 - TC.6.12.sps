* Encoding: UTF-8.
 * Children who had a finger or heel stick: CA15=1

 * Children given any anti-malarial are: CA23=A-K

 * Children given Artemisinin-based Combination Therapy (ACT) are: CA23=A

 * The percentage who took the anti-malarial drug same or next day are CA29A=0 or 1.

 * The denominators for this table are:
(i) number of children with fever during the last two weeks: CA14=1
(ii) number of children with fever during the last two weeks who were given any anti-malarials																	


****.
* v02 - 2020-04-24. A new note A has been inserted. Labels in French and Spanish have been removed.
* v03 - 2021-10-26
Line 109:
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
value labels fever 1 "Number of children with fever in the last two weeks".

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
+ if (CA23W = "W" or CA23Z = "Z" or CA23NR ="?") DKPill= 100.

compute heel=0.
if CA15=1 heel=100.
variable labels heel "Had blood taken from a finger or heel for testing [1]".

compute antimalarial=0.
if (ACT = 100 or spFansidar = 100 or Chloroquine = 100 or Amodiaquine = 100 or QuininePill = 100 or QuinineInc = 100 or ArtesunateRect = 100 or ArtesunateInc = 100 or otherMalaria = 100) antimalarial=100. 
variable labels antimalarial "Any antimalarial drugs [2]".

compute sameday=0.
if (CA29=0 or CA29=1) sameday=1.

compute ACTsameday=0.
if (ACT=100 and sameday=1) ACTsameday=100.
variable labels ACTsameday "ACT the same or next day".

compute antimalarialsameday=0.
if (antimalarial=100 and sameday=1) antimalarialsameday=100.
variable labels antimalarialsameday "Any antimalarial drugs same or next day".

do if antimalarial=100. 
+ compute totaln = 1.
+compute ACTanti=0.
+ if ACT=100 ACTanti=100.
end if.

variable labels totaln " ".
value labels totaln 1 "Number of children with fever in the last two weeks who were given any antimalarial drugs".

variable labels  ACT 		"Artemisinin-based Combination Therapy (ACT)".
variable labels  ACTanti 	"Treatment with ACT among children with fever who received anti-malarial treatment [3]".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with fever who:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Were given:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = layer layer1 tot totaln 
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
              layer [c] > ( heel [s][mean '' f5.1] + (layer1 [c] > (ACT [s][mean '' f5.1] + ACTsameday [s][mean '' f5.1] + antimalarial [s][mean '' f5.1] + antimalarialsameday [s][mean '' f5.1])))
                         +  fever [c] [count '' f5.0] + ACTanti [s][mean '' f5.1] + totaln [c] [count '' f5.0]
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.6.12: Diagnostics and anti-malarial treatment of children"														
	"Percentage of children age 0-59 months who had a fever in the last two weeks who had a finger or heel stick for malaria testing, who were given Artemisinin-based Combination Therapy (ACT) "
                  "and any anti-malarial drugs, and percentage who were given ACT among those who were given anti-malarial drugs, "+ surveyname
  caption =   
           "[1] MICS indicator TC.27 - Malaria diagnostics usage"	
           "[2] MICS indicator TC.28 - Anti-malarial treatment of children under age 5"
           "[3] MICS indicator TC.29 - Treatment with Artemisinin-based Combination Therapy (ACT) among children who received anti-malarial treatment"
           "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
.

new file.

