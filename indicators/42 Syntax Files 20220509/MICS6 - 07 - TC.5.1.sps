* Encoding: windows-1252.
 * Advice or treatment: CA20
   Public are CA21[A-H], Private are CA21[I-O], and Other are CA21[P-R] and [X]. 
 * Community health providers are CA21[D-E] and [L-M].
 * Health facilities or providers are CA21[A-J], [L-O] and [W].

 * Source: CA22=1 and CA23=L-O
   Public are CA25[A-H], Private are CA25[I-O], and Other are CA25[P-R] and [X]. 
 * Community health providers are CA25[D-E] and [L-M].
 * Health facilities or providers are CA25[A-O] and [W].

 * Note that the two columns of "A health facility or provider" have slightly different calculation. For source of antibiotics the column includes all public and private health
    facilities and providers, whereas it for source of advice or treatment is similar, but excludes private pharmacy.

 * Children receiving antibiotics: CA23=L, M, N, or O.

 * The denominator for this table is number of children with symptoms of ARI: Those who had an illness with a cough (CA16=1), accompanied by a rapid or difficult 
   breathing (CA17=1) and whose symptoms were due to a problem in the chest, or both a problem in the chest and a blocked nose (CA18=1 or 3).

***.
* v03 - 2020-04-14. Additional text added to subtitle. A new note D has been inserted. Labels in French and Spanish have been removed.
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* Suspected pneumonia in the last 2 weeks.
* Those who had an illness with a cough (CA16=1), accompanied by a rapid or difficult breathing (CA17=1) 
* and whose symptoms were due to a problem in the chest, or both a problem in the chest and a blocked nose (CA18=1 or 3).
compute ari  = 0.
if (CA16 = 1 and CA17 = 1 and (CA18 =1 or CA18 = 3)) ari = 100.
variable labels  ari "Had suspected pneumonia in the last two weeks".

do if (ari = 100).

 * Advice or treatment: CA20
   Public are CA21[A-H], Private are CA21[I-O], and Other are CA21[P-R] and [X]. 
 * Community health providers are CA21[D-E] and [L-M].
 * Health facilities or providers are CA21[A-J], [L-O] and [W].

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
	Community health worker 
                              (non-government)	L
	Mobile clinic 		M
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

* Health facilities or providers are CA21[A-J] and [L-O] (excludes private parmacy).
+ compute hf = 0.
+ if (CA21A = "A" or CA21B = "B" or CA21C = "C" or CA21D = "D" or CA21E = "E" or CA21H = "H" or
	CA21I = "I" or CA21J = "J" or CA21L = "L" or CA21M = "M" or CA21O = "O" or CA21W = "W") hf = 100.

*Community health providers are CA21[D-E] and [L-M].
+ if (CA21D = "D" or CA21E = "E" or CA21L = "L" or CA21M = "M") anycom = 100.

+ compute noadvice = 0.
+ if (CA20 <> 1) noadvice = 100.

 * Children receiving antibiotics: CA23=L, M, N, or O.
+ compute anti = 0.
+ if (CA23L = "L" or CA23M = "M" or CA23N = "N" or CA23O = "O") anti = 100.
+ compute atotal = 1.
end if.


* * Source: CA22=1 and CA23=L-O
   Public are CA25[A-H], Private are CA25[I-O], and Other are CA25[P-R] and [X]. 
 * Community health providers are CA25[D-E] and [L-M].
 * Health facilities or providers are CA25[A-O] and [W].

do if (anti = 100).

+ compute sourcePublic = 0.
+ compute sourcePrivate = 0.
+ compute sourceCom = 0.
+ compute sourceOther = 0.

 * Public are CA25[A-H], .
+ if (CA25A = "A" or CA25B = "B" or CA25C = "C" or CA25D = "D" or CA25E = "E" or CA25H = "H" ) sourcePublic = 100.
*Private are CA25[I-O].
+ if (CA25I = "I" or CA25J = "J" or CA25K = "K" or CA25L = "L" or CA25M = "M" or CA25O = "O") sourcePrivate = 100.
* Other are CA25[P-R] and [X]. 
+ if (CA25P = "P" or CA25Q = "Q" or CA25R = "R" or CA25X = "X") sourceOther = 100.
 * Community health providers are CA25[D-E] and [L-M].
+ if (CA25D = "D" or CA25E = "E" or CA25L = "L" or CA25M = "M" ) sourceCom = 100.

 * Health facilities or providers are CA25[A-O] and [W].
* Note that the two columns of "A health facility or provider" have slightly different calculation. 
* For source of antibiotics the column includes all public and private health facilities and providers, 
* whereas it for source of advice or treatment is similar, but excludes private pharmacy.
+ compute hfanti= 0.
+ if (sourcePublic = 100 or sourcePrivate = 100 or CA25W = "W") hfanti = 100.

+ compute antitot = 1.
end if.

variable labels caretakerdis "Mother's functional difficulties [D]".

variable labels  anypublic "Public".
variable labels  anyprivate "Private".
variable labels  anycom "Community health provider [A]".
variable labels  anyother "Other source".
variable labels hf "A health facility or provider [1] [B]".
variable labels hfanti "A health facility or provider [C]".
variable labels noadvice "No advice or treatment sought".

variable labels  anti "Percentage of children with symptoms of ARI in the last two weeks who were given antibiotics [2]".
variable labels  atotal "".
value labels atotal 1 "Number of children with symptoms of ARI in the last two weeks".

variable labels antitot "".
value labels antitot 1 "Number of children with symptoms of ARI in the last two weeks who were given antibiotics".

variable labels hfanti "A health facility or provider [C]".

variable labels sourcePublic "Public".
variable labels sourcePrivate "Private".
variable labels sourceCom  "Community health provider [A]".
variable labels sourceOther "Other source".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with symptoms of ARI for whom:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Advice or treatment was sought from:".

compute layer2 = 0.
variable labels  layer2 "".
value labels layer2 0 "Percentage of children with symptoms of ARI for whom the source of antibiotics was:".

compute layer3 = 0.
variable labels  layer3 "".
value labels layer3 0 "Health facilities or providers".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables = tot layer layer1 layer2 layer3 atotal antitot
         display = none
  /table tot [c]  
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]   by 
                  layer [c] > ( layer1 [c] > ( layer3 [c] > (anypublic [s] [mean '' f5.1] + anyprivate [s] [mean '' f5.1]  + anycom [s] [mean '' f5.1])  + anyother [s] [mean '' f5.1] +  hf [s] [mean '' f5.1]) + noadvice [s] [mean '' f5.1])
                                    + anti [s] [mean '' f5.1] + atotal[c][count '' f5.0]+
                  layer2 [c] > (layer3 [c] > (sourcePublic [s] [mean '' f5.1] + sourcePrivate [s] [mean '' f5.1]  + sourceCom [s] [mean '' f5.1])  + sourceOther [s] [mean '' f5.1] 
		+ hfanti [s] [mean '' f5.1]) + antitot [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.5.1: Care-seeking for and antibiotic treatment of symptoms of acute respiratory infection (ARI)"
 	 "Percentage of children age 0-59 months with symptoms of ARI in the last two weeks for whom advice or treatment was sought, by source of advice or treatment, " +
                   "and percentage of children with symptoms who were given antibiotics, by source of antibiotics, "+ surveyname
  caption =
  	"[1] MICS indicator TC.19 - Care-seeking for children with acute respiratory infection (ARI) symptoms; SDG indicator 3.8.1"
                  "[2] MICS indicator TC.20 - Antibiotic treatment for children with ARI symptoms"
                  "[A] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Non-Government community health worker and Mobile clinic) health facilities"
                  "[B] Includes all public and private health facilities and providers, as well as those who did not know if public or private. Excludes private pharmacy"
                  "[C] Includes all public and private health facilities and providers, as well as those who did not know if public or private"
                  "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."		
.																	
																
new file.														
