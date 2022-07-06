*v1 - 2014-04-06.
*v2 - 2014-04-21.
* The table title is changed to: “Care-seeking during fever”.
* The comment: “Public are CA11[A-H], Private are CA11[I-J], and Other are CA11[P-X].” has been changed to “Public are CA11[A-H], Private are CA11[I-O], and Other are CA11[P-X].”
* The comment: “Health facilities or providers are CA11[A-J], [L-O] and [Q].” has been changed to “Health facilities or providers are CA11[A-O] and [Q].”


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* children with fever during the last two weeks: CA6A=1.
select if (CA6AA = 1).

compute fever  = 1.
variable labels fever " ".
value labels  fever 1 "Number of children with fever in last two weeks".


* Advice or treatment: CA11
* Public are CA11[A-H], Private are CA11[I-O], and Other are CA11[P-X]. 
* Community health providers are CA11[D-E] and [L].
* Health facilities or providers are CA11[A-J], [L-O] and [Q].

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

*Public are CA11[A-H].
+ if (CA11A = "A" or CA11B = "B" or CA11C = "C" or CA11D = "D" or CA11E = "E" or CA11H = "H" ) anypublic = 100.
* Private are CA11[I-O].
+ if (CA11I = "I" or CA11J = "J" or CA11K = "K" or CA11L = "L" or CA11O = "O") anyprivate = 100.
* Other are CA11[P-X]. 
+ if (CA11P = "P" or CA11Q = "Q" or CA11R = "R" or  CA11X = "X" ) anyother = 100.

* Health facilities or providers are CA11[A-O] and [Q].
+ compute hf = 0.
+ if (CA11A = "A" or CA11B = "B" or CA11C = "C" or CA11D = "D" or CA11E = "E" or CA11H = "H" or
	CA11I = "I" or CA11J = "J" or CA11K = "K" or CA11L = "L" or CA11O = "O" or CA11Q = "Q") hf = 100.

*Community health providers are CA11[D-E] and [L].
+ if (CA11D = "D" or CA11E = "E" or CA11L = "L") anycom = 100.

+ compute noadvice = 0.
+ if (CA10 <> 1) noadvice = 100.

variable labels  anypublic "Health facilities or providers: Public".
variable labels  anyprivate "Health facilities or providers: Private".
variable labels  anycom "Health facilities or providers: Community health provider [a]".
variable labels  anyother "Other source".
variable labels hf "A health facility or provider [1], [b]".
variable labels noadvice "No advice or treatment sought".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children for whom:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Advice or treatment was sought from:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables = tot layer layer1 fever
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
                  layer [c] > ( layer1 [c] > ( anypublic [s] [mean,'',f5.1] + anyprivate [s] [mean,'',f5.1]  + anycom [s] [mean,'',f5.1])
	 + anyother [s] [mean,'',f5.1] +  hf [s] [mean,'',f5.1]) + noadvice [s] [mean,'',f5.1] + fever[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
 	"Table CH.20: Care-seeking during fever"
	"Percentage of children age 0-59 months with fever in the last two weeks for whom advice or treatment was sought, by source of advice or treatment, "							
		+ surveyname
  caption =
	"[1] MICS indicator 3.20 - Care-seeking for fever"
	"[a] Community health providers include both public (Community health worker and Mobile/Outreach clinic) and private (Mobile clinic) health facilities"						
	"[b] Includes all public and private health facilities and providers as well as shops".						
																										
new file.														
