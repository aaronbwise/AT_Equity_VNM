*v1 - 2014-03-14.
*v2 - 2014-04-21.
* The wording in column H has changed to: “Percentage of children with symptoms of ARI in the last two weeks who were given antibiotics”.
* The wording in column O has changed to: “Number of children with symptoms of ARI in the last two weeks who were given antibiotics”.
* In the comment, under “Advice or treatment: CA11”. Private is updated to now include “CA11[I-O]”.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* Suspected pneumonia in the last 2 weeks.
* Those who had an illness with a cough (CA7=1), accompanied by a rapid or difficult breathing (CA8=1) 
* and whose symptoms were due to a problem in the chest, or both a problem in the chest and a blocked nose (CA9=1 or 3).
compute ari  = 0.
if (CA7 = 1 and CA8 = 1 and (CA9 =1 or CA9 = 3)) ari = 100.
variable labels  ari "Had suspected pneumonia in the last two weeks".

do if (ari = 100).

*Advice or treatment: CA11
*Public are CA11[A-H], Private are CA11[I-O], and Other are CA11[P-X]. 
*Community health providers are CA11[D-E] and [L].
*Health facilities or providers are CA11[A-J] and [L-O].

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

* Health facilities or providers are CA11[A-J] and [L-O] (excludes private parmacy).
+ compute hf = 0.
+ if (CA11A = "A" or CA11B = "B" or CA11C = "C" or CA11D = "D" or CA11E = "E" or CA11H = "H" or
	CA11I = "I" or CA11J = "J" or CA11L = "L" or CA11O = "O") hf = 100.

*Community health providers are CA11[D-E] and [L].
+ if (CA11D = "D" or CA11E = "E" or CA11L = "L") anycom = 100.

+ compute noadvice = 0.
+ if (CA10 <> 1) noadvice = 100.

*Children receiving antibiotics: CA13=I or J.
+ compute anti = 0.
+ if (CA13I = "I" or CA13J = "J") anti = 100.
+ compute atotal = 1.
end if.


* Source: CA13B.
do if (anti = 100).

+ compute sourcePublic = 0.
+ compute sourcePrivate = 0.
+ compute sourceCom = 0.
+ compute sourceOther = 0.

* Public are CA13B=11-16.
+ if (CA13BB >= 11 and  CA13BB <= 16) sourcePublic = 100.
* Private are CA13=21-26.
+ if (CA13BB >= 21 and  CA13BB <= 26) sourcePrivate = 100.
* Other are CA13=31-33, 40, and 96 . 
+ if ((CA13BB >= 31 and  CA13BB <= 33) or CA13BB = 40 or CA13BB = 96) sourceOther = 100.
* Community health providers are CA13B=14, 15, and 24.
+ if (CA13BB = 14 or CA13BB = 15 or CA13BB = 24) sourceCom = 100.

* Health facilities or providers are CA13B=11-26.
* Note that the two columns of "A health facility or provider" have slightly different calculation. 
* For source of antibiotics the column includes all public and private health facilities and providers, 
* whereas it for source of advice or treatment is similar, but excludes private pharmacy.
+ compute hfanti= 0.
+ if (CA13BB >= 11 and  CA13BB <= 26) hfanti = 100.

+ compute antitot = 1.
end if.



variable labels  anypublic "Health facilities or providers: Public".
variable labels  anyprivate "Health facilities or providers: Private".
variable labels  anycom "Health facilities or providers: Community health provider [a]".
variable labels  anyother "Other source".
variable labels hf "A health facility or provider [1], [b]".
variable labels hfanti "A health facility or provider [c]".
variable labels noadvice "No advice or treatment sought".

variable labels  anti "Percentage of children with symptoms of ARI in the last two weeks who were given antibiotics [2]".
variable labels  atotal "".
value labels atotal 1 "Number of children age 0-59 months with symptoms of ARI in the last two weeks".

variable labels antitot "".
value labels antitot 1 "Number of children with symptoms of ARI in the last two weeks who were given antibiotics".

variable labels hfanti "A health facility or provider [c]".

variable labels sourcePublic "Health facilities or providers: Public".
variable labels sourcePrivate "Health facilities or providers: Private".
variable labels sourceCom  "Health facilities or providers: Community health provider [a]".
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

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables = tot layer layer1 layer2 atotal antitot
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
                  layer [c] > ( layer1 [c] > ( anypublic [s] [mean,'',f5.1] + anyprivate [s] [mean,'',f5.1]  + anycom [s] [mean,'',f5.1])  + anyother [s] [mean,'',f5.1] +  hf [s] [mean,'',f5.1]) + noadvice [s] [mean,'',f5.1]
                                    + anti [s] [mean,'',f5.1] + atotal[c][count,'',f5.0]+
                  layer2 [c] > (sourcePublic [s] [mean,'',f5.1] + sourcePrivate [s] [mean,'',f5.1]  + sourceCom [s] [mean,'',f5.1]  + sourceOther [s] [mean,'',f5.1] 
		+ hfanti [s] [mean,'',f5.1]) + antitot [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.10: Care-seeking for and antibiotic treatment of symptoms of acute respiratory infection (ARI)"
 	 "Percentage of children age 0-59 months with symptoms of ARI in the last two weeks for whom advice or treatment was sought, "+
                   "by source of advice or treatment, and percentage of children with symptoms who were given antibiotics, " + surveyname
  caption =
  	"[1] MICS indicator 3.13 - Care-seeking for children with acute respiratory infection (ARI) symptoms"
                  "[2] MICS indicator 3.14 - Antibiotic treatment for children with ARI symptoms"
	"[a] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Mobile clinic) health facilities"														
	"[b] Includes all public and private health facilities and providers, but excludes private pharmacy"								
	"[c] Includes all public and private health facilities and providers".											
																	
new file.														
