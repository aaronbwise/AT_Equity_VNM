*v1 - 2014-03-14.
*v2 - 2014-12-12.
* Corrected line: + if (MN14A = "A" and MN16 >= 4 and MN16 < 97) spmore4 = 100.
*Intermittent Preventive Treatment (IPT) is defined as pregnant women who received at least 3 doses of SP/Fansidar 
*(MN14=A and MN16>=3) at any antenatal care visit during pregnancy.

include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* Select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
value labels total 1 "Number of women with a live birth in the last two years".
variable labels  total "".

include "define\MICS5 - 06 - RH.sps".

compute skilled = 0.
if (anc = 11 or anc = 12) skilled = 100.
variable labels  skilled "Percentage of women who received antenatal care (ANC)".

do if (skilled = 100).

+ compute anymed = 0.
+ if (MN13 = 1) anymed = 100.

+ compute sponce = 0.
+ if (MN14A = "A") sponce = 100.

+ compute spmore2 = 0.
+ if (MN14A = "A" and MN16 >= 2 and MN16 < 97) spmore2 = 100.

+ compute spmore3 = 0.
+ if (MN14A = "A" and MN16 >= 3 and MN16 < 97) spmore3 = 100.

+ compute spmore4 = 0.
+ if (MN14A = "A" and MN16 >= 4 and MN16 < 97) spmore4 = 100.

+ compute layer = 0.

+ compute anctot = 1.

end if.

variable labels  anymed "Who took any medicine to prevent malaria at any ANC visit during pregnancy".
variable labels  sponce "who took SP/Fansidar at least once during an ANC visit and in total took: At least once".
variable labels  spmore2 "who took SP/Fansidar at least once during an ANC visit and in total took: Two or more times".
variable labels  spmore3 "who took SP/Fansidar at least once during an ANC visit and in total took: Three or more times [1]".
variable labels  spmore4 "who took SP/Fansidar at least once during an ANC visit and in total took: Four or more times".
variable labels  anctot "".
value labels anctot 1 "Number of women with a live birth in the last two years and who received antenatal care".
variable labels  layer "".
value labels layer 0 "Percentage of pregnant women".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot anctot layer
         display = none
  /table tot [c] + hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] by 
                skilled [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
                layer[c] > (anymed [s][mean,'',f5.1] + sponce [s][mean,'',f5.1] + spmore2 [s][mean,'',f5.1] + spmore3 [s][mean,'',f5.1] + spmore4 [s][mean,'',f5.1]) +
                anctot [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.25: Intermittent preventive treatment for malaria"
	"Percentage of women age 15-49 years who had a live birth during the two years preceding the survey "
	"and who received intermittent preventive treatment (IPT) for malaria during pregnancy at any antenatal care visit, "+ surveyname
  caption =
    "[1] MICS indicator 3.25 - Intermittent preventive treatment for malaria".								

new file.
