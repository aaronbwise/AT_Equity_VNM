* Encoding: windows-1252.

***.
* v02 - 2020-04-23. A new note has been inserted. Labels in French and Spanish have been removed.
***.

 *  Source of anti-malarial: CA22=1 and CA23=A-K

 * Public are CA27[A-H], Private are CA27[I-O], and Other are CA27[P-R] and [X].
 * Community health providers are CA27[D-E] and [L-M].
 * Health facilities or providers are CA27[A-O], [Q] and [W].

 * The denominators for this table are:
(i) number of children with fever during the last two weeks: CA14=1
(ii) number of children with fever during the last two weeks who were given any anti-malarials															


****.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

* children with fever during the last two weeks: CA14=1.
select if (CA14 = 1).

weight by chweight.

compute fever = 1.
variable labels  fever "".
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
*CA27.
 * PUBLIC MEDICAL SECTOR
	GOVERNMENT HOSPITAL	A
	GOVERNMENT HEALTH CENTRE	B
	GOVERNMENT HEALTH POST	C
	COMMUNITY HEALTH WORKER	D
	MOBILE / OUTREACH CLINIC	E
	OTHER PUBLIC MEDICAL
		(specify)	H

 * PRIVATE MEDICAL SECTOR
	PRIVATE HOSPITAL / CLINIC	I
	PRIVATE PHYSICIAN	J
	PRIVATE PHARMACY 	K
	COMMUNITY HEALTH WORKER
		(NON-GOVERNMENT)	L
	MOBILE CLINIC 	M
	OTHER PRIVATE MEDICAL
		(specify)	O

 * OTHER SOURCE
	RELATIVE / FRIEND	P
	SHOP / MARKET / STREET	Q
	TRADITIONAL PRACTITIONER	R

 * OTHER (specify)	X
DK / DON’T REMEMBER	Z

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
+ if (CA23W = "W" or CA23Z = "Z") DKPill= 100.

compute antimalarial=0.
if (ACT = 100 or spFansidar = 100 or Chloroquine = 100 or Amodiaquine = 100 or QuininePill = 100 or QuinineInc = 100 or ArtesunateRect = 100 or ArtesunateInc = 100 or otherMalaria = 100) antimalarial=100. 
variable labels antimalarial "Percentage of children with fever who were given anti-malarial".

do if antimalarial=100. 
*Public are CA27[A-H].
+compute anypublic = 0.
+ if (CA27A = "A" or CA27B = "B" or CA27C = "C" or CA27D = "D" or CA27E = "E" or CA27H = "H" ) anypublic = 100.
* Private are CA27[I-O].
+compute anyprivate = 0.
+ if (CA27I = "I" or CA27J = "J" or CA27K = "K" or CA27L = "L"  or CA27M = "M" or CA27O = "O") anyprivate = 100.
* Other are CA27[P-X]. 
+compute anyother = 0.
+ if (CA27P = "P" or CA27Q = "Q" or CA27R = "R" or  CA27X = "X" ) anyother = 100.

*  * Health facilities or providers are CA27[A-O], [Q] and [W].
+ compute hf = 0.
+ if (CA27A = "A" or CA27B = "B" or CA27C = "C" or CA27D = "D" or CA27E = "E" or CA27H = "H" or
	CA27I = "I" or CA27J = "J" or CA27K = "K" or CA27L = "L" or CA27M = "M" or CA27O = "O" or CA27Q = "Q" or CA27W = "W") hf = 100.

+ compute anycom = 0.
 * Community health providers are CA27[D-E] and [L-M].
+ if (CA27D = "D" or CA27E = "E" or CA27L = "L" or CA27M = "M") anycom = 100.

variable labels  anypublic "Public".
variable labels  anyprivate "Private".
variable labels  anycom "Community health provider [A]".
variable labels  anyother "Other source".
variable labels hf "A health facility or provider [B]".

+ compute totaln = 1.
+compute ACTanti=0.
+ if ACT=100 ACTanti=100.
end if.

variable labels totaln " ".
value labels totaln 1 "Number of children who were given anti-malarial as treatment for fever in the last two weeks".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with fever for whom the source of anti-malarial was:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Health facilities or providers".

variable labels caretakerdis "Mother's functional difficulties [C]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = layer layer1 tot totaln fever
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
         antimalarial [s][mean '' f5.1] +  fever [c] [count '' f5.0]  +  layer [c] > ((layer1 [c] > (anypublic [s][mean '' f5.1] + anyprivate [s][mean '' f5.1] + anycom [s][mean '' f5.1]) 
        + anyother [s][mean '' f5.1] + hf [s][mean '' f5.1]))
                         + totaln [c] [count '' f5.0]
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.6.13: Source of anti-malarial"														
	"Percentage of children age 0-59 months with fever in the last two weeks who were given anti-malarial by the source of anti-malarial, "+ surveyname
  caption =   
       "[A] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Non-Government community health worker and Mobile clinic) health facilities"								
       "[B] Includes all public and private health facilities, as well as those who did not know if public or private. Also includes shops"							
       "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."							
.
				
new file.
