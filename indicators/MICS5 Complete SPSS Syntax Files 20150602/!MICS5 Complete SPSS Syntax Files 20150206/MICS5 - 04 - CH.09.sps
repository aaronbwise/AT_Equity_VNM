* v2 - 2014-04-29.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months".

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute dtotal = 1.

* ORS: CA4[A]=1 or CA4[B]=1.
+ compute ors = 0.
+ if (CA4A = 1 or CA4B = 1) ors = 100.


* Zinc: CA4C[A]=1 or CA4C[B]=1.
+ compute zinc = 0.
+ if (CA4CA = 1 or CA4CB = 1) zinc = 100.

end if.

do if (ors = 100).
+ compute orstotal = 1.
*Source of ORS: CA4B
*Public are CA4B=11-16, Private are CA4B=21-26, and Other are CA4B=31-33, 40, and 96.
*Community health providers are CA4B=14, 15, and 24.
*Health facilities or providers are CA4B=11-26.
+ recode CA4BB (11 thru 16 = 1) (21 thru 26 = 2) (97, 98, 99 = 9) (else = 4) into source1.
+ if CA4BB = 14 or CA4BB = 15 or CA4BB = 24 source11 = 3.
+ compute orsSource = 0.
+ if (source1 = 1 or source1 = 2) orsSource = 100.
end if.

do if (zinc = 100).
+ compute zinctotal = 1.
*Source of zinc: CA4E.
*Community health providers (zinc) are CA4E=14, 15, and 24.
*Health facilities or providers (zinc) are CA4E=11-26.
+ recode CA4E (11 thru 16 = 1) (21 thru 26 = 2) (97, 98, 99 = 9) (else = 4) into source2.
+ if CA4E = 14 or CA4E = 15 or CA4E = 24 source21 = 3.
+ compute zincSource = 0.
+ if (source2 = 1 or source2 = 2) zincSource = 100.
end if.

mrsets
  /mcgroup name=$source1
   label='Health facilities or providers'
   variables=source1 source11 .

mrsets
  /mcgroup name=$source2
   label='Health facilities or providers'
   variables=source2 source21 .

variable labels ors "ORS".
variable labels zinc "Zinc".
variable labels source1 "Health facilities or providers".
value labels source1 1 "Public" 2 "Private" 3 "Community health provider [a]" 4 "Other source" 9 "DK/Missing".
variable labels source2 "Health facilities or providers".
value labels source2 1 "Public" 2 "Private" 3 "Community health provider [a]" 4 "Other source" 9 "DK/Missing".

variable labels orsSource  "A health facility or provider [b]".
variable labels zincSource "A health facility or provider [b]".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of children who were given as treatment for diarrhoea:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of children for whom the source of ORS was:".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Percentage of children for whom the source of zinc was:".

variable labels dtotal "".
value labels dtotal 1 "Number of children age 0-59 months with diarrhoea in the last two weeks".

variable labels orstotal "".
value labels orstotal 1 "Number of children age 0-59 months who were given ORS as treatment for diarrhoea in the last two weeks".

variable labels zinctotal "".
value labels zinctotal 1 "Number of children age 0-59 months who were given zinc as treatment for diarrhoea in the last two weeks".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot layer1 layer2 layer3 dtotal total orstotal zinctotal
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by   
  	layer1 [c] > (ors [s] [mean,'',f5.1] + zinc [s] [mean,'',f5.1]) + dtotal [c] [count,'',f5.0] +
                  layer2 [c] > ($source1 [c] [rowpct.validn,'',f5.1] + orsSource [s] [mean,'',f5.1]) + orstotal[c][count,'',f5.0] +
	layer3 [c] > ($source2 [c] [rowpct.validn,'',f5.1] + zincSource [s] [mean,'',f5.1]) + zinctotal[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.9: Source of ORS and zinc"
                   "Percentage of children age 0-59 months with diarrhoea in the last two weeks who were given ORS, and percentage given zinc, by the source of ORS and zinc, " + surveyname
  caption =
	"[a] Community health provider includes both public (Community health worker and Mobile/Outreach clinic) and private (Mobile clinic) health facilities"
	"[b] Includes all public and private health facilities and providers".


new file.
