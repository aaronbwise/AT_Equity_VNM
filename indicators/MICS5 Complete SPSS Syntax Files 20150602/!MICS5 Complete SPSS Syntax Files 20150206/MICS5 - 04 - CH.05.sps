*v.1 - 2014-04-03.

* Advice or treatment: CA3B.

* Public are CA3B[A-H], Private are CA3B[I-O], and Other are CA3B[P-X].
* Community health providers are CA3B[D-E] and [L].
* Health facilities or providers are CA3B[A-J] and [L-O].
* An additional table disaggregating the source of advice or treatment is available on request.
* In this table, percentages of children for whom advice or treatment was sought will not add to 100 since for some advice or treatment may have been sought from more than one type of provider.
* The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

* Diarrhoea.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "An episode of diarrhoea".

do if (diarrhea = 100).

* Advice or treatment: valid CA3B - equivalent of CA3A = 1.
+ recode CA3A (1 = 0) (else = 100) into advice.

* Public sector CA3B[A-H]
*	Government hospital		A
*	Government health centre	B
*	Government health post		C
*	Community health worker	D
*	Mobile / Outreach clinic		E
*	Other public (specify)		H.

* Private medical sector CA3B[I-O]
*	Private hospital / clinic		I
*	Private physician		J
*	Private pharmacy 		K
*	Mobile clinic 		L
*	Other private medical (specify)	O

*Other source CA3B[P-X]
*	Relative / Friend		P
*	Shop 			Q
*	Traditional practitioner 		R

*Other (specify)			X.


* Public are CA3B[A-H].
+ compute public = 0.
+ if (CA3BA = "A" or CA3BB = "B" or CA3BC = "C" or  CA3BD = "D" or  CA3BE = "E" or CA3BH = "H") public = 100. 

* Private are CA3B [I-O], including private pharmacy.
+ compute private = 0.
+ if (CA3BI = "I" or CA3BJ = "J" or CA3BK = "K" or CA3BL = "L" or CA3BO = "O") private = 100. 

* Other are CA3B[P-X].
+ compute others = 0.
+ if (CA3BP = "P" or CA3BQ = "Q" or CA3BR = "R" or CA3BX = "X") others = 100. 

* Community health providers are CA3B[D-E] and [L].
+ compute comunityhp = 0.
+ if (CA3BD = "D" or CA3BE = "E"  or CA3BL = "L") comunityhp = 100. 

* Health facilities or providers are CA3B[A-J] and [L-O] (private pharmacy not included).
+ compute anyhealth = 0.
+ if (CA3BA = "A" or CA3BB = "B" or CA3BC = "C" or CA3BD = "D" or CA3BE = "E"  or CA3BH = "H" or CA3BI = "I" or CA3BJ = "J" or 
      CA3BL = "L" or CA3BO = "O") anyhealth = 100.

+ compute dtotal = 1.

end if.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of children with diarrhoea for whom:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Advice or treatment was sought from:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Health facilities or providers".

variable labels  advice " No advice or treatment sought".
variable labels  public "Public".
variable labels  private "Private".
variable labels  comunityhp "Community health provider [a]".
variable labels  others "Other source".
variable labels  anyhealth " A health facility or provider [1] [b]".

variable labels  dtotal "".
value labels dtotal 1 "Number of children age 0-59 months with diarrhoea in the last two weeks".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with diarrhoea for whom:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot layer layer1 layer2 dtotal 
         display = none
  /table  tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c]  + windex5 [c] + ethnicity [c]   by 
                  layer [c] > (layer1 [c] > (layer2 [c] > (public [s] [mean,'',f5.1] + private [s] [mean,'',f5.1] + comunityhp [s] [mean,'',f5.1] ) +
                                    others [s] [mean,'',f5.1] + anyhealth [s] [mean,'',f5.1]) + 
                   	advice [s] [mean,'',f5.1])+ dtotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.5: Care-seeking during diarrhoea"
 	 "Percentage of children age 0-59 months with diarrhoea in the last two weeks for whom advice or treatment was sought, by source of advice or treatment,  "
                   + surveyname
  caption =
  	"[1] MICS indicator 3.10 - Care-seeking for diarrhoea"
	"[a] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Mobile clinic) health facilities"						
	"[b] Includes all public and private health facilities and providers, but excludes private pharmacy".					
																										
new file.
