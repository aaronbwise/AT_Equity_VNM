* MICS5 WS-08.

* v01 - 2014-03-03.

* Safe disposal of stools: CA15=01 or 02.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

* include definition of drinkingWater .
include "define/MICS5 - 05 - WS.sps" .

sort cases by HH1 HH2.

save outfile = 'tmp.sav'
  /keep HH1 HH2 toiletType.

get file = 'ch.sav'.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 .

select if (UF9 = 1).

weight by chweight.

select if (AG2 < 3).

recode CA15 (1,2 = 100) (else = 0) into stools.
variable labels  stools "Percentage of children whose last stools were disposed of safely [1]".
value labels stools 100 "".

variable labels  CA15 "Place of disposal of child's faeces".

compute numChildren  = 1.
value labels numChildren 1 "".
variable labels  numChildren "Number of children age 0-2 years".

* changing the labels for toiletType to match tabulation plan.
variable labels  toiletType "Type of sanitaton facility in dwelling".
value labels toiletType 
    1 "Improved" 
    2 "Unimproved"
    3 "Open defacation".

compute total = 1.
value labels total 1 "Total".
variable labels  total "".

compute total100 = 100.
value labels total100 100 "".
variable labels  total100 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total display  = none
  /table   total [c]
         + toiletType [c]
         + hh7 [c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by 
           ca15 [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1] 
         + stools [s] [mean,'',f5.1] 
         + numChildren [s] [sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.8: Disposal of child's faeces"
    "Percent distribution of children age 0-2 years according to place "+
    "of disposal of child's faeces, and the percentage of children age 0-2 " +
    "years whose stools were disposed of safely the last time the child passed stools, " +surveyname
   caption = 
    "[1] MICS indicator 4.4 - Safe disposal of child’s faeces"
  .
                                        
new file.

erase file = 'tmp.sav'.


