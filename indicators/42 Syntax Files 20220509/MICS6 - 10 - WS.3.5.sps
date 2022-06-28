* Encoding: windows-1252.
 * Safe disposal of stools: CA31=01 or 02.

***.
* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. In the subtitle, “according to” has been changed to “by”. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

* include definition of drinkingWater .
include "define/MICS6 - 10 - WS.sps" .

sort cases by HH1 HH2.

save outfile = 'tmp.sav'
  /keep HH1 HH2 toiletType.

get file = 'ch.sav'.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 .

select if (UF17 = 1).

weight by chweight.

select if (UB2 < 3).

recode CA31 (1,2 = 100) (else = 0) into stools.
variable labels  stools "Percentage of children whose last stools were disposed of safely [A]".
value labels stools 100 "".

recode CA31 (98=99) (else=copy) into disposalplace.
value labels  disposalplace 1 "Child used toilet / latrine" 2"Put / rinsed into toilet or latrine" 3 "Put / rinsed into drain or ditch"
                                          4 "Thrown into garbage (solid waste)" 5 "Buried" 6 "Left in the open" 96 "Other" 99 "DK/Missing".
variable labels  disposalplace "Place of disposal of child's faeces".

compute numChildren  = 1.
value labels numChildren 1 "".
variable labels  numChildren "Number of children age 0-2 years".

compute total = 1.
value labels total 1 "Total".
variable labels  total "".

compute total100 = 100.
value labels total100 100 "".
variable labels  total100 "Total".

* Ctables command in English.
ctables
  /vlabels variables = total display  = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + melevel [c]
         + toiletType [c]
         + ethnicity [c]
         + windex5 [c]
   by 
           disposalplace [c] [rowpct.validn '' f5.1]
         + total100 [s] [mean '' f5.1] 
         + stools [s] [mean '' f5.1] 
         + numChildren [s] [sum '' f5.0]
  /categories variables=all empty=include missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.3.5: Disposal of child's faeces"
    "Percent distribution of children age 0-2 years by place of disposal of child's faeces, and the percentage of children age 0-2 years " +
    "whose stools were disposed of safely the last time the child passed stools, " +surveyname
   caption = 
    "[A] In many countries, disposal of children's faeces with solid waste is common." +
    "The risks vary between and within countries depending on whether solid waste is regularly collected and well managed; " +
    "therefore, for the purposes of international comparability, solid waste is not considered safely disposed.".

new file.

erase file = 'tmp.sav'.


