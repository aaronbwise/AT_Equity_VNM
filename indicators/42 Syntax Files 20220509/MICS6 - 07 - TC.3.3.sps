* Encoding: windows-1252.
 * Any ORS: CA7[A]=1 or CA7[B]=1

 * In Column E (Government-recommended homemade fluid, CA7D), the fluid name can be added to the title for clarification. If more than one fluid is 
   included in questionnaire, the column title should be converted to a header with each fluid added below.

 * Column F (ORS or government-recommended homemade fluid) is: CA7[A]=1 or CA7[B]=1 or CA7[D]=1

 * Zinc tablets or syrup: CA7[C]=1

 * ORS and zinc: (CA7[A]=1 or CA7[B]=1) and CA7[C]=1

 * The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1

***.

* v02. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute orspack = 0.
+ if (CA7A = 1) orspack = 100.

+ compute prepak = 0.
+ if (CA7B = 1) prepak = 100.

+ compute anyors = 0.
+ if (orspack = 100 or prepak = 100) anyors = 100.

* Recommended homemade fluids.
+ compute recom = 0.
+ if (CA7D = 1) recom = 100.

+ compute any = 0.
+ if (anyors = 100 or recom = 100) any = 100.

* Zink.
* Any zinc: CA7C=1.

+ compute zinc = 0.
+ if (CA7C=1) zinc = 100.

* ORS and zinc.
+ compute orszink = 0.
+ if (anyors = 100 and zinc = 100) orszink = 100.

+ compute dtotal = 1.

end if.

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with diarrhoea who received:".

compute layerors = 0.
variable labels layerors "".
value labels layerors 0 "Oral rehydration salt solution (ORS)".

variable labels orspack "Fluid from packet".
variable labels prepak "Pre-packaged fluid".
variable labels anyors "Any ORS [1]".

variable labels recom "Government-recommended homemade fluid".

variable labels any "ORS or government-recommended homemade fluid".
variable labels  zinc "Zinc tablets or syrup".
variable labels  orszink "ORS and zinc [2]".

value labels dtotal 1 "Number of children with diarrhoea in the last two weeks".
variable labels  dtotal "".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables = layer layerors tot dtotal
         display = none
  /table  tot [c]  
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]  by 
              layer [c] > (  
                              layerors [c] > (  orspack [s] [mean '' f5.1] + prepak [s]  [mean '' f5.1] + anyors [s]  [mean '' f5.1]  ) +
	            recom [s]  [mean '' f5.1]  + any [s]  [mean '' f5.1] + zinc [s]  [mean '' f5.1] + orszink [s] [mean '' f5.1]) +
           	            dtotal [c] [count '' f5.0]
 /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table TC.3.3: Oral rehydration solutions, government-recommended homemade fluid and zinc"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks, and treatment with oral rehydration salt solution (ORS), government-recommended homemade fluid, and zinc, " + surveyname
  caption =
    "[1] MICS indicator TC.13a - Diarrhoea treatment with oral rehydration salt solution (ORS)"
    "[2] MICS indicator TC.13b - Diarrhoea treatment with oral rehydration salt solution (ORS) and zinc"
    "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.
			
new file.
