* Encoding: windows-1252.
 * ORS: CA7[A]=1 or CA7[B]=1
Zinc: CA7[C]=1

 * Source of ORS: CA9
Public are CA9=A-H, Private are CA9=I-O, and Other are CA9=P-R and X.
 * Community health providers are CA9=D, E, L, and M.
 * Health facilities or providers are CA9=A-O or W.

 * Source of zinc: CA11
Public are CA11=A-H, Private are CA11=I-O, and Other are CA11=P-R, and X.
 * Community health providers are CA11=D, E, L, and M.
 * Health facilities or providers are CA11=A-O or W.

 * The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1														

****.

* v02. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute dtotal = 1.
*  * "ORS: CA7[A]=1 or CA7[B]=1..
+ compute ors = 0.
+ if (CA7A = 1 or CA7B = 1) ors = 100.
+ variable labels ors "ORS".

 *    Zinc: CA7[C]=1.
+ compute zinc = 0.
+ if (CA7C = 1) zinc = 100.
+ variable labels zinc "Zinc".
end if.

do if (ors = 100).
+ compute orstotal = 1.
 * Source of ORS: CA9.
 * Public are CA9=A-H, Private are CA9=I-O, and Other are CA9=P-R and X.
 * Community health providers are CA9=D, E, L, and M.
 * Health facilities or providers are CA9=A-O.
+ compute CA9public=0.
+ if (CA9A = "A" or CA9B = "B" or CA9C = "C" or CA9D = "D" or CA9E = "E" or CA9H = "H")  CA9public=100.
+ variable labels CA9public "Public".

+ compute CA9private=0.
+ if (CA9I = "I" or CA9J = "J" or CA9K = "K" or CA9L = "L" or CA9M = "M" or CA9O = "O")  CA9private=100.
+ variable labels CA9private "Private".

+ compute CA9other=0.
+ if (CA9P = "P" or CA9Q = "Q" or CA9R = "R" or CA9X = "X")  CA9other=100.
+ variable labels CA9other "Other source".

+ compute CA9community=0.
+ if (CA9D = "D" or CA9E = "E" or CA9L = "L" or CA9M = "M")  CA9community=100.
+ variable labels CA9community "Community health provider [A]".

+ compute CA9health=0.
+ if (CA9public=100 or CA9private=100 or CA9W = "W") CA9health=100.
+ variable labels CA9health "A health facility or provider [B]".
end if.
	

do if (zinc = 100).
+ compute zinctotal = 1.
 * Source of zinc: CA11.
 * Public are CA11=A-H, Private are CA11=I-O, and Other are CA11=P-R, and X.
 * Community health providers are CA11=D, E, L, and M.
 * Health facilities or providers are CA4E=A-O.
+ compute CA11public=0.
+ if (CA11A = "A" or CA11B = "B" or CA11C = "C" or CA11D = "D" or CA11E = "E" or CA11H = "H")  CA11public=100.
+ variable labels CA11public "Public".

+ compute CA11private=0.
+ if (CA11I = "I" or CA11J = "J" or CA11K = "K" or CA11L = "L" or CA11M = "M" or CA11O = "O")  CA11private=100.
+ variable labels CA11private "Private".

+ compute CA11other=0.
+ if (CA11P = "P" or CA11Q = "Q" or CA11R = "R" or CA11X = "X")  CA11other=100.
+ variable labels CA11other "Other source".

+ compute CA11community=0.
+ if (CA11D = "D" or CA11E = "E" or CA11L = "L" or CA11M = "M")  CA11community=100.
+ variable labels CA11community "Community health provider [A]".

+ compute CA11health=0.
+ if (CA11public=100 or CA11private=100 or CA11W = "W") CA11health=100.
+ variable labels CA11health "A health facility or provider [B]".

end if.

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of children for whom the source of ORS was:".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Percentage of children for whom the source of zinc was:".

compute layer4 = 0.
variable labels layer4 "".
value labels layer4 0 "Health facilities or providers:".

variable labels orstotal "".
value labels orstotal 1 "Number of children who were given ORS as treatment for diarrhoea in the last two weeks".

variable labels zinctotal "".
value labels zinctotal 1 "Number of children who were given zinc as treatment for diarrhoea in the last two weeks".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

variable labels caretakerdis "Mother's functional difficulties [C]".

* Ctables command in English.
ctables
  /vlabels variables = tot layer2 layer3 layer4 dtotal orstotal zinctotal
         display = none
  /table tot [c]  
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]  by   
  	layer2 [c] > (layer4 [c] >  (CA9public [s] [mean '' f5.1] + CA9private [s] [mean '' f5.1] + CA9community [s] [mean '' f5.1]) + CA9other [s] [mean '' f5.1] + CA9health [s] [mean '' f5.1] )   + orstotal [c][count '' f5.0] +
                  layer3 [c] > (layer4 [c] > (CA11public [s] [mean '' f5.1] + CA11private [s] [mean '' f5.1] + CA11community [s] [mean '' f5.1]) + CA11other [s] [mean '' f5.1] + CA11health [s] [mean '' f5.1] ) + zinctotal [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.3.5: Source of ORS and zinc"
                   "Percentage of children age 0-59 months with diarrhoea in the last two weeks who were given ORS, and percentage given zinc, by the source of ORS and zinc, " + surveyname
  caption =
	"[A] Community health providers includes both public (Community health worker and Mobile/Outreach clinic) and private (Non-Government community health worker and Mobile clinic) health facilities"
                  "[B] Includes all public and private health facilities and providers, as well as those who did not know if public or private"
                  "[C] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.	

new file.