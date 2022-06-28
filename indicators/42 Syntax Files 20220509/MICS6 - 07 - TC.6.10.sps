* Encoding: UTF-8.
 * Advice or treatment: CA20

 * Public are CA21[A-H], Private are CA21[I-O], and Other are CA21[P-R] and [X]. 
 * Community health providers are CA21[D-E] and [L-M].
 * Health facilities or providers are CA21[A-O], [Q] and [W].

 * In this table, percentages of children for whom advice or treatment was sought will not add to 100 since for some advice or treatment may have been sought from more than one type of provider.

 * The denominator for this table is number of children with fever during the last two weeks: CA14=1			

* v03 - 2020-04-14. A new note C has been inserted. Labels in French and Spanish have been removed.
* v04 - 2021-04-09. typo corrected "monhts" to "months" in line:
value labels  fever 1 "Number of children age 0-59 monhts with fever in last two weeks".

* v05 - 2021-10-26
Line 80
CA21I = "I" or CA21J = "J" or CA21K = "K" or CA21L = "L" or CA21M = "M" or CA21O = "O" or CA21Q = "Q" or CA21W = "W") hf = 100
Changed to:
CA21I = "I" or CA21J = "J" or CA21K = "K" or CA21L = "L" or CA21M = "M" or CA21O = "O" or CA21W = "W") hf = 100.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* children with fever during the last two weeks: CA14=1.
select if (CA14 = 1).

compute fever  = 1.
variable labels fever " ".
value labels  fever 1 "Number of children age 0-59 months with fever in last two weeks".

* Advice or treatment: CA21
* Public are CA21[A-H], Private are CA21[I-O], and Other are CA21[P-X]. 
* Community health providers are CA21[D-E] and [L].
* Health facilities or providers are CA21[A-J], [L-O] and [Q].

*Public sector
	Government hospital		A
	Government health centre	B
	Government health post		C
	Community health worker	D
	Mobile / Outreach clinic		E
	Other public (specify)		H.

*Private medical sector
	Private hospital / clinic		I
	Private physician		J
	Private pharmacy 		K
	Mobile clinic 		L
	Other private medical (specify)	O.

*Other source
	Relative / Friend		P
	Shop 			Q
	Traditional practitioner 		R

*Other (specify)			X.

+ compute anypublic = 0.
+ compute anyprivate = 0.
+ compute anycom = 0.
+ compute anyother = 0.

*Public are CA21[A-H].
+ if (CA21A = "A" or CA21B = "B" or CA21C = "C" or CA21D = "D" or CA21E = "E" or CA21H = "H" ) anypublic = 100.
* Private are CA21[I-O].
+ if (CA21I = "I" or CA21J = "J" or CA21K = "K" or CA21L = "L" or CA21M = "M" or CA21O = "O") anyprivate = 100.
* Other are CA21[P-X]. 
+ if (CA21P = "P" or CA21Q = "Q" or CA21R = "R" or  CA21X = "X" ) anyother = 100.

* Health facilities or providers are CA21[A-O] and [Q].
+ compute hf = 0.
+ if (CA21A = "A" or CA21B = "B" or CA21C = "C" or CA21D = "D" or CA21E = "E" or CA21H = "H" or
	CA21I = "I" or CA21J = "J" or CA21K = "K" or CA21L = "L" or CA21M = "M" or CA21O = "O" or CA21W = "W") hf = 100.

*Community health providers are CA21[D-E] and [L].
+ if (CA21D = "D" or CA21E = "E" or CA21L = "L" or CA21M = "M") anycom = 100.

+ compute noadvice = 0.
+ if (CA20 <> 1) noadvice = 100.

variable labels  anypublic "Public".
variable labels  anyprivate "Private".
variable labels  anycom "Community health provider [A]".
variable labels  anyother "Other source".
variable labels hf "A health facility or provider [1] [B]".
variable labels noadvice "No advice or treatment sought".
variable labels caretakerdis "Mother's functional difficulties [C]".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with fever for whom:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Advice or treatment was sought from:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Health facilities or providers".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables = tot layer layer1 layer2 fever
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
                  layer [c] > ( layer1 [c] > (  layer2 [c] > (anypublic [s] [mean '' f5.1] + anyprivate [s] [mean '' f5.1]  + anycom [s] [mean '' f5.1])
	 + anyother [s] [mean '' f5.1] +  hf [s] [mean '' f5.1]) + noadvice [s] [mean '' f5.1] )+ fever[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
 	"Table TC.6.10: Care-seeking during fever"
	"Percentage of children age 0-59 months with fever in the last two weeks for whom advice or treatment was sought, by source of advice or treatment, " + surveyname
  caption =
	"[1] MICS indicator TC.26 - Care-seeking for fever" 
	"[A] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Non-Government community health worker and Mobile clinic) health facilities"
	"[B] Includes all public and private health facilities and providers, as well as those who did not know if public or private. Also includes shops"
                  "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."	
.									
		
new file.														
