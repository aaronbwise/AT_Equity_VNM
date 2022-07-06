* v1 - 2014-04-03.
* v2 - 2014-06-21.
* Corrected indicator calculation: line:
* + if (anyors = 100 or zinc = 100) orszink = 100.
* changed to:
*+ if (anyors = 100 and zinc = 100) orszink = 100.



*Any ORS: CA4[A]=1 or CA4[B]=1.

*All recommended homemade fluids included in the country questionnaire (CA4F[A], CA4F[B], etc.) 
*should be included as separate columns and combined in "Any recommended homemade fluid". 
*If no government recommended fluid was included, the table should be redesigned to reflect this, i.e. deletion of columns and merge of column headers.
*If other fluids (i.e. not government recommended) were included, these should not be included as "recommended homemade fluids", but rather be tabulated 
*in a separate table or under a heading of "Other fluids".

*Any zinc: CA4C[A]=1 or CA4C[B]=1.

*The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

compute total = 1.
value labels total 1 "".
variable labels  total "Number of children age 0-59 months".

* Diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels  diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).

+ compute orspack = 0.
+ if (CA4A = 1) orspack = 100.

+ compute prepak = 0.
+ if (CA4B = 1) prepak = 100.

+ compute anyors = 0.
+ if (orspack = 100 or prepak = 100) anyors = 100.

* Recommended homemade fluids.
+ compute recom1 = 0.
+ if (CA4FA = 1) recom1 = 100.

+ compute recom2 = 0.
+ if (CA4FB = 1) recom2 = 100.

+ compute recom3 = 0.
+ if (CA4FC = 1) recom3 = 100.

+ compute anyrecom = 0.
+ if (recom1 = 100 or recom2 = 100 or recom3 = 100) anyrecom = 100.

+ compute any = 0.
+ if (anyors = 100 or anyrecom = 100) any = 100.

* Zink.
* Any zinc: CA4C[A]=1 or CA4C[B]=1

+ compute zincpill = 0.
+ if (CA4CA = 1) zincpill = 100.

+ compute zincsyrup = 0.
+ if (CA4CB = 1) zincsyrup = 100.

+ compute zinc = 0.
+ if (zincpill = 100 or zincsyrup = 100) zinc = 100.

* ORS and zinc.
+ compute orszink = 0.
+ if (anyors = 100 and zinc = 100) orszink = 100.

+ compute dtotal = 1.

end if.

compute layer = 0.
variable labels  layer "".
value labels layer 0 "Percentage of children with diarrhoea who received:".

compute layerrec = 0.
variable labels layerrec "".
value labels layerrec 0 "Recommended homemade fluids".

compute layerors = 0.
variable labels layerors "".
value labels layerors 0 "Oral rehydration salts (ORS)".

compute layerzinc = 0.
variable labels layerzinc "".
value labels layerzinc 0 "Zinc".

variable labels orspack "Fluid from packet".
variable labels prepak "Pre-packaged fluid".
variable labels anyors "Any ORS".

variable labels recom1 "Fluid X".
variable labels recom2 "Fluid Y".
variable labels recom3 "Fluid Z".
variable labels anyrecom "Any recommended homemade fluid".

variable labels any "ORS or any recommended homemade fluid".
variable labels zincpill "Tablet".
variable labels zincsyrup "Syrup".
variable labels  zinc "Any zinc".
variable labels  orszink "ORS and zinc [1]".

value labels dtotal 1 "Number of children aged 0-59 months with diarrhoea".
variable labels  dtotal "".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layerors layerrec layerzinc tot dtotal
         display = none
  /table  tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] by 
              layer [c] > (  
                              layerors [c] > (  orspack [s] [mean,'',f5.1] + prepak [s]  [mean,'',f5.1] + anyors [s]  [mean,'',f5.1]  ) +
	            layerrec [c] > (   recom1 [s]  [mean,'',f5.1] + recom2 [s]  [mean,'',f5.1] + recom3 [s]  [mean,'',f5.1] + anyrecom [s]  [mean,'',f5.1]  ) + 
                              any [s]  [mean,'',f5.1] +
	            layerzinc [c] > (zincpill [s]  [mean,'',f5.1] + zincsyrup [s]  [mean,'',f5.1] + zinc [s]  [mean,'',f5.1])+ orszink [s] [mean,'',f5.1]
                              ) +
           	            dtotal [c] [count,'',f5.0]
 /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.7: Oral rehydration solutions, recommended homemade fluids, and zinc"
  	"Percentage of children age 0-59 months with diarrhoea in the last two weeks, and treatment with oral rehydration salts (ORS), " +
                  "recommended homemade fluids, and zinc, " + surveyname
  caption =
    "[1] MICS indicator 3.11 - Diarrhoea treatment with oral rehydration salts (ORS) and zinc".
														
new file.
