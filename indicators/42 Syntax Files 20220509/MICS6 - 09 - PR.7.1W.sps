* Encoding: windows-1252.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".
 
get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

variable labels vt20 "Percent distribution of women who walking alone in their neighbourhood after dark feel:".
variable labels vt21 "Percent distribution of women who being home alone after dark feel:".
recode vt20 vt21(9=sysmis).
compute vt20safe=0.
if any(vt20,1,2) vt20safe=100.
variable labels vt20safe "Percentage of women who feel safe walking alone in their neighbourhood after dark [1]".

compute vt21safe=0.
if any(vt21,1,2) vt21safe=100.
variable labels vt21safe "Percentage of women who feel safe home alone after dark".

compute unsafe=0.
if vt20=4 or vt21=4 unsafe=100.
variable labels unsafe "Percentage of women who after dark feel very unsafe walking alone in their neighborhood or being home alone".

compute totwomen=1.
variable labels totwomen "Number of women".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by  
        vt20[c][rowpct F4.1]+vt20safe[s][mean F4.1]+
        vt21[c][rowpct F4.1]+vt21safe[s][mean F4.1]+
        unsafe[s][mean F4.1]+
        totwomen[s][sum F6.0]
  /categories variables=all empty=exclude missing=exclude
 /cat var= vt20 vt21 total=yes
  /slabels position=column visible = no
  /titles title=
    "Table PR.7.1W: Feelings of safety (women)"		
    "Percent distribution of women age 15-49 years by feeling of safety walking alone in their neighbourhood after dark and being home alone after dark, "+surveyname															
   caption =
    "[1] MICS indicator PR.14 - Safety; SDG indicator 16.1.4	".

new file.


