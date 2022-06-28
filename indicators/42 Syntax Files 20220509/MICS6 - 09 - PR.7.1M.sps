* Encoding: UTF-8.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".
 
get file = "mn.sav".

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

variable labels MVT20 "Percent distribution of men who walking alone in their neighbourhood after dark feel:".
variable labels MVT21 "Percent distribution of men who being home alone after dark feel:".
recode MVT20 MVT21(9=sysmis).
compute MVT20safe=0.
if any(MVT20,1,2) MVT20safe=100.
variable labels MVT20safe "Percentage of men who feel safe walking alone in their neighbourhood after dark [1]".

compute MVT21safe=0.
if any(MVT21,1,2) MVT21safe=100.
variable labels MVT21safe "Percentage of men who feel safe home alone after dark".

compute unsafe=0.
if MVT20=4 or MVT21=4 unsafe=100.
variable labels unsafe "Percentage of men who after dark feel very unsafe walking alone in their neighborhood or being home alone".

compute totmen=1.
variable labels totmen "Number of men".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
   by  
        MVT20[c][rowpct F4.1]+MVT20safe[s][mean F4.1]+
        MVT21[c][rowpct F4.1]+MVT21safe[s][mean F4.1]+
        unsafe[s][mean F4.1]+
        totmen[s][sum F6.0]
  /categories variables=all empty=exclude missing=exclude
 /cat var= MVT20 MVT21 total=yes
  /slabels position=column visible = no
  /titles title=
    "Table PR.7.1M: Feelings of safety (men)"		
    "Percent distribution of men age 15-49 years by feeling of safety walking alone in their neighbourhood after dark and being home alone after dark, "+surveyname															
   caption =
    "[1] MICS indicator PR.14 - Safety; SDG indicator 16.1.4	".

new file.


