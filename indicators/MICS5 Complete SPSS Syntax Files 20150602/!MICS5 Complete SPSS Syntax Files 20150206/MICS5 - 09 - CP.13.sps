* MICS5 CP-13 .

* v01 - 2013-10-24.

* Women who believe a husband is justified in beating his wife:
    DV1A=1 or DV1B=1 or DV1C=1 or DV1D=1 or DV1E=1

* This table must be customised if the survey has included country specific reasons in the questionnaire.
* These should be added as separate columns after the indicator column "For any of these five reasons",
  which should not change for reasons of comparability.
* Another column can be added to include any reason, such as "For any of these seven reasons" if the survey included two
  country specific reasons in the questionnaire .

***.

include "surveyname.sps".

get file="wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute goesOut = 0.
if (DV1A = 1) goesOut = 100.
variable labels goesOut "If she goes out without telling him".

compute neglectsKids = 0.
if (DV1B = 1) neglectsKids = 100.
variable labels neglectsKids "If she neglects the children".

compute sheArgues = 0.
if (DV1C = 1) sheArgues = 100.
variable labels sheArgues "If she argues with him".

compute refusesSex = 0.
if (DV1D = 1) refusesSex = 100.
variable labels refusesSex "If she refuses sex with him".

compute burnsFood = 0.
if (DV1E = 1) burnsFood = 100.
variable labels burnsFood "If she burns the food".

compute anyReason = 0.
if (any(1, DV1A, DV1B, DV1C, DV1D, DV1E)) anyReason = 100.
variable labels anyReason "For any of these five reasons [1]".

compute layer = 1.
value labels layer 1 "Percentage of women age 15-49 years who believe a husband is justified in beating his wife:".

compute numWomen = 1.
value labels numWomen 1 "Number of women age 15-49 years".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer numWomen
           display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + wage [c]
        + mstatus [c]
        + welevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          layer [c] > (
            goesOut [s] [mean,'',f5.1]
          + neglectsKids [s] [mean,'',f5.1]
          + sheArgues [s] [mean,'',f5.1]
          + refusesSex [s] [mean,'',f5.1]
          + burnsFood [s] [mean,'',f5.1]
          + anyReason [s] [mean,'',f5.1] )
        + numWomen [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table CP.13: Attitudes toward domestic violence (women)"
  	 "Percentage of women age 15-49 years who believe a husband is justified in beating his wife in various circumstances, " + surveyname
   caption=
     "[1] MICS indicator 8.12 - Attitudes towards domestic violence"
  .

new file.
