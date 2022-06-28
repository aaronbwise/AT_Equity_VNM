* Encoding: UTF-8.
***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
* v03 - 2020-09-09. ctable command changed to include $mwage instead of mwage variable.
***.

include "surveyname.sps".

get file="mn.sav".

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

compute goesOut = 0.
if (MDV1A = 1) goesOut = 100.
variable labels goesOut "If she goes out without telling him".

compute neglectsKids = 0.
if (MDV1B = 1) neglectsKids = 100.
variable labels neglectsKids "If she neglects the children".

compute sheArgues = 0.
if (MDV1C = 1) sheArgues = 100.
variable labels sheArgues "If she argues with him".

compute refusesSex = 0.
if (MDV1D = 1) refusesSex = 100.
variable labels refusesSex "If she refuses sex with him".

compute burnsFood = 0.
if (MDV1E = 1) burnsFood = 100.
variable labels burnsFood "If she burns the food".

compute anyReason = 0.
if (any(1, MDV1A, MDV1B, MDV1C, MDV1D, MDV1E)) anyReason = 100.
variable labels anyReason "For any of these five reasons [1]".

compute layer = 1.
value labels layer 1 "Percentage of men who believe a husband is justified in beating his wife:".

compute nummen = 1.
value labels nummen 1 "Number of men".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer nummen
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwage [c]
        + mwelevel [c]
        + mmstatus [c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
   by
          layer [c] > (
            goesOut [s] [mean '' f5.1]
          + neglectsKids [s] [mean '' f5.1]
          + sheArgues [s] [mean '' f5.1]
          + refusesSex [s] [mean '' f5.1]
          + burnsFood [s] [mean '' f5.1]
          + anyReason [s] [mean '' f5.1] )
        + nummen [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table PR.8.1M: Attitudes toward domestic violence (men)"
  	 "Percentage of men age 15-49 years who believe a husband is justified in beating his wife in various circumstances, " + surveyname
   caption=
     "[1] MICS indicator PR.15 - Attitudes towards domestic violence"
  .

new file.
