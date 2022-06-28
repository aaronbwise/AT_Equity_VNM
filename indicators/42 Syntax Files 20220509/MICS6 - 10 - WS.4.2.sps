* Encoding: UTF-8.

* Women who did not participate in social activities, school or work due to their last menstruation in the last 12 months: UN16=1

* Women age 15-49 who reported menstruating in the last 12 months: UN15=1

***.

* v01 - 2020-04-14. The background characteristic of “Disability status (age 18-49 years)” has been changed to “Functional difficulties (age 18-49 years). Labels in French and Spanish have been removed.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

include "CommonVarsWM.sps".

* Select completed interviews.
select if (WM17 = 1).
* Select women mensurated in last years.
select if (not(sysmis(UN16))).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women who reported menstruating in the last 12 months".

compute noparticipation=0.
if UN16=1  noparticipation=100.
variable labels noparticipation "Percentage of women who did not participate in social activities, school or work due to their last menstruation in the last 12 months [1]".

variable labels disability "Functional difficulties (age 18-49 years)".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  numWomen total
         display = none
  /table   total [c]
        + HH6 [c]
        + HH7 [c]
        + wageu [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
      by
           noparticipation [s] [mean '' f5.1]
           + numWomen[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table WS.4.2: Exclusion from activities during menstruation"
     "Percentage of women age 15-49 years who did not participate in social activities, school, or work due to their last menstruation in the last 12 months, "
     + surveyname
   caption =
        "[1] MICS indicator WS.13 - Exclusion from activities during menstruation".									

new file.
