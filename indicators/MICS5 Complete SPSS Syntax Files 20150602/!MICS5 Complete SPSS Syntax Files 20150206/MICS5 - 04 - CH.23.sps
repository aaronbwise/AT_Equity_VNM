*v1 - 2014-04-07.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

select if (CA6AA = 1).

weight by chweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of children age 0-59 months with fever in the last two weeks".

* Percentage of children who were given anti-malarial (CA13).
* Anti-malarials:
	SP / Fansidar		A
	Chloroquine			B
	Amodiaquine		C
	Quinine			D
	Combination with Artemisinin	E
	Other anti-malarial 		H.

compute antiMalarial  = 0.
if (CA13A = "A" or CA13B = "B" or CA13C = "C" or CA13D = "D" or CA13E = "E" or CA13H = "H") antiMalarial = 100.
variable labels  antiMalarial "Percentage of children who were given anti-malarial".

do if (antiMalarial = 100).
* Source: CA13D.
* Public are CA13D=11-16, Private are CA13D=21-26, and Other are CA13D=31-33, 40, and 96.
* Community health providers are CA13D=14, 15, and 24.

+ compute sourcePublic = 0.
+ compute sourcePrivate = 0.
+ compute sourceCom = 0.
+ compute sourceOther = 0.

* Public are CA13B=11-16.
+ if (CA13DD >= 11 and  CA13DD <= 16) sourcePublic = 100.
* Private are CA13=21-26.
+ if (CA13DD >= 21 and  CA13DD <= 26) sourcePrivate = 100.
* Other are CA13=31-33, 40, and 96 . 
+ if ((CA13DD >= 31 and  CA13DD <= 33) or CA13DD = 40 or CA13DD = 96) sourceOther = 100.
* Community health providers are CA13B=14, 15, and 24.
+ if (CA13DD = 14 or CA13DD = 15 or CA13DD = 24) sourceCom = 100.

* Health facilities or providers are CA13D=11-26 and 32.

+ compute hfMalarial= 0.
+ if (CA13DD >= 11 and  CA13DD <= 26) hfMalarial = 100.
+ if (CA13DD = 32) hfMalarial = 100.

+ compute malariatot = 1.
end if.

variable labels malariatot "".
value labels malariatot 1 "Number of children age 0-59 months who were given anti-malarial as treatment for fever in the last two weeks".

variable labels hfMalarial "A health facility or provider [b]".

variable labels sourcePublic "Public".
variable labels sourcePrivate "Private".
variable labels sourceCom  "Community health provider [a]".
variable labels sourceOther "Other source".

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children for whom the source of anti-malarial was:".

compute layer1 = 0.
variable labels  layer1 "".
value labels layer1 0 "Health facilities or providers".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables = tot layer layer1 total malariatot
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
                  antiMalarial [s] [mean,'',f5.1]  + total [c][count,'',f5.0] +
                  layer [c] > (layer1 [c] > (sourcePublic [s] [mean,'',f5.1] + sourcePrivate [s] [mean,'',f5.1]  + sourceCom [s] [mean,'',f5.1]) + sourceOther [s] [mean,'',f5.1] 
		+ hfMalarial [s] [mean,'',f5.1]) + malariatot [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.23: Source of anti-malarial"							
	"Percentage of children age 0-59 months with fever in the last two weeks who were given anti-malarial by the source of anti-malarial, "+ surveyname
  caption =
	"[a] Community health providers include both public (Community health worker and Mobile/Outreach clinic) and private (Mobile clinic) health facilities"
	"[b] Includes all public and private health facilities and providers as well as shops".																	
																	
new file.														
