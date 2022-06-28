* Encoding: windows-1252.
 * Advice or treatment: CA5.

 * Public are CA6[A-H], Private are CA6[I-O], and Other are CA6[P-R] and [X].
 * Community health providers are CA6[D-E] and [L-M].
 * Health facilities or providers are CA6[A-J], [L-O] and [W].

 * In this table, percentages of children for whom advice or treatment was sought will not add to 100 since for some advice or treatment may have been sought from more than one type of provider.

 * The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1.					

***********************.

* v02. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open children data file.
get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* Diarrhoea.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "An episode of diarrhoea".

do if (diarrhea = 100).

* Advice or treatment: CA5.
+ recode CA5 (1 = 0) (else = 100) into advice.

* Public sector CA6[A-H]
*	Government hospital		A
*	Government health centre	B
*	Government health post		C
*	Community health worker	D
*	Mobile / Outreach clinic		E
*	Other public medical (specify)	H.

* Private medical sector CA6[I-O]
*	Private hospital / clinic		I
*	Private physician		J
*	Private pharmacy 		K
*	Community health worker
                             (non governement)	L
*	Mobile clinic 		M
*	Other private medical (specify)	O

*Other source CA6[P-X]
*	Relative / Friend		P
*	Shop / Market / Street 		Q
*	Traditional practitioner 		R

*Other (specify)			X.


* Public are CA6[A-H].
+ compute public = 0.
+ if (CA6A = "A" or CA6B = "B" or CA6C = "C" or  CA6D = "D" or  CA6E = "E" or CA6H = "H") public = 100. 

* Private are CA6 [I-O], including private pharmacy.
+ compute private = 0.
+ if (CA6I = "I" or CA6J = "J" or CA6K = "K" or CA6L = "L" or CA6M = "M" or CA6O = "O") private = 100. 

* Other are CA6[P-X].
+ compute others = 0.
+ if (CA6P = "P" or CA6Q = "Q" or CA6R = "R" or CA6X = "X") others = 100. 

* Community health providers are CA6[D-E] and [L].
+ compute comunityhp = 0.
+ if (CA6D = "D" or CA6E = "E"  or CA6L = "L" or CA6M = "M") comunityhp = 100. 

* Health facilities or providers are CA6[A-J] and [L-O] (private pharmacy not included).
+ compute anyhealth = 0.
+ if (CA6A = "A" or CA6B = "B" or CA6C = "C" or CA6D = "D" or CA6E = "E"  or CA6H = "H" or CA6I = "I" or CA6J = "J" or 
      CA6L = "L" or CA6M = "M" or CA6O = "O" or CA6W = "W") anyhealth = 100.

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

variable labels  advice "No advice or treatment sought".
variable labels  public "Public".
variable labels  private "Private".
variable labels  comunityhp "Community health provider [A]".
variable labels  others "Other source".
variable labels  anyhealth "A health facility or provider [1] [B]".
variable labels caretakerdis "Mother's functional difficulties [C]".

variable labels  dtotal "".
value labels dtotal 1 "Number of children with diarrhoea in the last two weeks".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = tot layer layer1 layer2 dtotal 
         display = none
  /table  tot [c]
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]    by 
                  layer [c] > (layer1 [c] > (layer2 [c] > (public [s] [mean '' f5.1] + private [s] [mean '' f5.1] + comunityhp [s] [mean '' f5.1] ) +
                                    others [s] [mean '' f5.1] + anyhealth [s] [mean '' f5.1]) + 
                   	advice [s] [mean '' f5.1])+ dtotal[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.3.1: Care-seeking during diarrhoea"
 	 "Percentage of children age 0-59 months with diarrhoea in the last two weeks for whom advice or treatment was sought, by source of advice or treatment, "
                   + surveyname
  caption =
  	"[1] MICS indicator TC.12 - Care-seeking for diarrhoea"		
                  "[A] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Non-Government community health worker and Mobile clinic) health facilities"
                  "[B] Includes all public and private health facilities and providers, as well as those who did not know if public or private. Excludes private pharmacy"
                  "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.				
		
new file.
