* Encoding: UTF-8.

* Women using appropriate menstrual hygiene materials with a private place to wash and change while at home: (UN17=1 and UN18=1). 

***.

* v01 - 2020-04-16. The background characteristic of “Disability status (age 18-49 years)” has been changed to “Functional difficulties (age 18-49 years). Labels in French and Spanish have been removed.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women dataset.
get file = 'wm.sav'.

include "CommonVarsWM.sps".

* Select completed interviews.
select if (WM17 = 1).

* Select women who reported menstruating in the last 12 months.
select if (not(sysmis(UN16))).

* Weight the data by the women weight.
weight by wmweight.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women who reported menstruating in the last 12 months".

compute amaterialre=0.
if UN19=1  amaterialre=100.
variable labels amaterialre "Reusable".

compute amaterialnonre=0.
if UN19=2  amaterialnonre=100.
variable labels amaterialnonre "Not reusable".

compute amaterialDKmissing=0.
if UN19>=8  amaterialDKmissing=100.
variable labels amaterialDKmissing "DK whether reusable/Missing".

compute materialother=0.
if UN18=2  materialother=100.
variable labels materialother "Other/No materials".

compute materialDK=0.
if UN18>=8  materialDK=100.
variable labels materialDK "DK/Missing".

compute appropriatematerial=0.
if UN18=1  appropriatematerial=100.
variable labels appropriatematerial "Percentage of women using appropriate materials for menstrual management during last menstruation".

compute privateplace=0.
if UN17=1  privateplace=100.
variable labels privateplace "Percentage of women with a private place to wash and change while at home".

compute totalprct=100.
variable labels totalprct "Total".

compute materialprivateplace=0.
if (privateplace=100 and UN18=1) materialprivateplace=100.
variable labels materialprivateplace "Percentage of women using appropriate menstrual hygiene materials with a private place to wash and change while at home [1]".

variable labels disability "Functional difficulties (age 18-49 years)".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percent distribution of women by use of materials during last menstruation".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Appropriate materials [A]".

compute total = 1.
variable labels total "".
value labels total 1 "Total".


* Ctables command in English.
ctables
  /vlabels variables =  numWomen layer0 layer1 total
         display = none
  /table   total [c]
        + HH6 [c]
        + HH7 [c]
        + $wagexx [c]
        + welevel [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
      by
        layer0 [c] > ( layer1 [c] > (amaterialre [s] [mean '' f5.1] + amaterialnonre [s] [mean '' f5.1]  + amaterialDKmissing [s] [mean '' f5.1])   + materialother [s] [mean '' f5.1]  + materialDK [s] [mean '' f5.1]+ totalprct [s] [mean '' f5.1] )
         + appropriatematerial [s] [mean '' f5.1]+ privateplace [s] [mean '' f5.1]+ materialprivateplace [s] [mean '' f5.1]
         + numWomen[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table WS.4.1: Menstrual hygiene management"
     "Percent distribution of women age 15-49 years by use of materials during last menstruation, percentage using appropriate materials, percentage with a private place to wash and change while at home " +
     "and percentage of women using appropriate menstrual hygiene materials with a private place to wash and change while at home,  "
     + surveyname
   caption =
        "[1] MICS indicator WS.12 - Menstrual hygiene management"
        "[A] Appropriate materials include sanitary pads, tampons or cloth".									
								
new file.
