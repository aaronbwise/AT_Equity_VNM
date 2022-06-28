* Encoding: windows-1252.
* MICS6 TC-7.8.

* v02 - 2014-03-05.
* v03 - 2017 - 11 - 20.
* customized for MICS6. 
* v04 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include "CommonVarsCH.sps".

select if (UF17 = 1).

weight by chweight.

select if (cage <= 23).

compute numChildren = 1.
variable labels numChildren "Number of children age 0-23 months:".
value labels numChildren 1"".

* Bottle feeding: BD4=1 .
compute bottleFeeding = 0.
if (BD4 = 1) bottleFeeding = 100.
variable labels bottleFeeding "Percentage of children age 0-23 months fed with a bottle with a nipple [1]".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ageCat [c]
         + melevel [c]         
        + caretakerdis[c]
        + ethnicity [c]
        + windex5 [c]
   by
           bottleFeeding [s] [mean '' f5.1]
         + numChildren [s] [count,'' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title=
     "Table TC.7.8: Bottle feeding"
     "Percentage of children age 0-23 months who were fed with a bottle with a nipple during the previous day, " + surveyname
   caption=
     "[1] MICS indicator TC.43 - Bottle feeding"
     "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
. 
 
new file.
